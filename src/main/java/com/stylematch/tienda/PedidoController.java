package com.stylematch.tienda;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/pedidos")
@CrossOrigin(origins = "*")
public class PedidoController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @PostMapping("/procesar")
    @Transactional 
    public ResponseEntity<String> procesarPedido(@RequestBody PedidoRequest request) {
        try {
            String sqlPedido = "INSERT INTO pedidos (id_usuario, fecha_pedido, total_pagado, estado_pago) VALUES (?, ?, ?, ?)";
            jdbcTemplate.update(sqlPedido, request.getIdUsuario(), LocalDate.now(), request.getTotalPagado(), "Completado");

            Integer idPedido = jdbcTemplate.queryForObject("SELECT LAST_INSERT_ID()", Integer.class);
            String sqlDetalle = "INSERT INTO detalles_pedido (id_pedido, id_variante, cantidad, subtotal) VALUES (?, ?, ?, ?)";
            
            for (DetalleRequest detalle : request.getDetalles()) {
                Integer idVariante = jdbcTemplate.queryForObject("SELECT id_variante FROM variantes_producto WHERE id_producto = ? LIMIT 1", Integer.class, detalle.getIdProducto());
                if (idVariante != null) { jdbcTemplate.update(sqlDetalle, idPedido, idVariante, detalle.getCantidad(), detalle.getSubtotal()); }
            }

            // --- QUEMAR CUPÓN: Si el usuario usó un cupón, lo marcamos como usado en la DB ---
            if (request.getCodigoCupon() != null && !request.getCodigoCupon().trim().isEmpty()) {
                jdbcTemplate.update("UPDATE cupones_puntos SET usado = 1 WHERE codigo_cupon = ?", request.getCodigoCupon());
            }

            // --- SISTEMA DE LEALTAD ---
            int puntosGanados = (int) Math.round(request.getTotalPagado() * 2);
            Integer countPuntos = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM puntos_usuario WHERE id_usuario = ?", Integer.class, request.getIdUsuario());
            
            if (countPuntos != null && countPuntos > 0) {
                jdbcTemplate.update("UPDATE puntos_usuario SET puntos_actuales = puntos_actuales + ?, puntos_totales_ganados = puntos_totales_ganados + ? WHERE id_usuario = ?", puntosGanados, puntosGanados, request.getIdUsuario());
            } else {
                jdbcTemplate.update("INSERT INTO puntos_usuario (id_usuario, puntos_actuales, puntos_totales_ganados) VALUES (?, ?, ?)", request.getIdUsuario(), puntosGanados, puntosGanados);
            }
            jdbcTemplate.update("INSERT INTO historial_puntos (id_usuario, puntos_cantidad, concepto, fecha) VALUES (?, ?, ?, NOW())", request.getIdUsuario(), puntosGanados, "Compra Pedido #" + idPedido);

            return ResponseEntity.ok("Pedido registrado exitosamente.");
        } catch (Exception e) {
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
            return ResponseEntity.status(500).body("Error: Stock insuficiente o problema de conexión.");
        }
    }

    // --- NUEVO: Tienda de Cupones - Comprar un cupón con puntos ---
    @PostMapping("/comprar-cupon")
    @Transactional
    public ResponseEntity<String> comprarCupon(@RequestBody Map<String, Integer> payload) {
        try {
            Integer idUsuario = payload.get("idUsuario");
            Integer costoPuntos = payload.get("costoPuntos");
            Integer porcentaje = payload.get("porcentaje");

            Integer puntosActuales = jdbcTemplate.queryForObject("SELECT puntos_actuales FROM puntos_usuario WHERE id_usuario = ?", Integer.class, idUsuario);
            if(puntosActuales == null || puntosActuales < costoPuntos) {
                return ResponseEntity.status(400).body("Puntos insuficientes para este cupón.");
            }

            // Restar puntos
            jdbcTemplate.update("UPDATE puntos_usuario SET puntos_actuales = puntos_actuales - ? WHERE id_usuario = ?", costoPuntos, idUsuario);
            jdbcTemplate.update("INSERT INTO historial_puntos (id_usuario, puntos_cantidad, concepto, fecha) VALUES (?, ?, ?, NOW())", idUsuario, -costoPuntos, "Canje de cupón " + porcentaje + "%");

            // Generar código único y guardar en la BD
            String codigo = "STYLE" + porcentaje + "-" + (int)(Math.random()*10000);
            jdbcTemplate.update("INSERT INTO cupones_puntos (id_usuario, codigo_cupon, porcentaje_descuento, fecha_expiracion, usado) VALUES (?, ?, ?, DATE_ADD(NOW(), INTERVAL 30 DAY), 0)", idUsuario, codigo, porcentaje);

            return ResponseEntity.ok(codigo);
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Error al procesar el canje.");
        }
    }

    // --- NUEVO: Obtener los cupones activos (no usados) del usuario ---
    @GetMapping("/mis-cupones/{idUsuario}")
    public ResponseEntity<List<Map<String, Object>>> misCupones(@PathVariable Integer idUsuario) {
        return ResponseEntity.ok(jdbcTemplate.queryForList("SELECT codigo_cupon, porcentaje_descuento FROM cupones_puntos WHERE id_usuario = ? AND usado = 0", idUsuario));
    }

    @PostMapping("/devolver/{idPedido}")
    public ResponseEntity<String> solicitarDevolucion(@PathVariable Integer idPedido) {
        try {
            Integer idDetalle = jdbcTemplate.queryForObject("SELECT id_detalle FROM detalles_pedido WHERE id_pedido = ? LIMIT 1", Integer.class, idPedido);
            jdbcTemplate.update("CALL registrar_devolucion(?, ?)", idDetalle, "Solicitado por cliente web");
            jdbcTemplate.update("UPDATE pedidos SET estado_pago = 'Devuelto' WHERE id_pedido = ?", idPedido);
            return ResponseEntity.ok("Devolución ejecutada. Los triggers restauraron el stock a la tienda.");
        } catch(Exception e) { return ResponseEntity.status(500).body("Error al procesar la devolución."); }
    }

    @GetMapping("/usuario/{idUsuario}")
    public ResponseEntity<List<Map<String, Object>>> obtenerHistorial(@PathVariable Integer idUsuario) {
        String sql = "SELECT p.id_pedido, p.fecha_pedido, p.total_pagado, p.estado_pago, GROUP_CONCAT(pr.nombre SEPARATOR ', ') AS prendas " +
                     "FROM pedidos p JOIN detalles_pedido dp ON p.id_pedido = dp.id_pedido JOIN variantes_producto v ON dp.id_variante = v.id_variante JOIN productos pr ON v.id_producto = pr.id_producto " +
                     "WHERE p.id_usuario = ? GROUP BY p.id_pedido, p.fecha_pedido, p.total_pagado, p.estado_pago ORDER BY p.fecha_pedido DESC, p.id_pedido DESC";
        return ResponseEntity.ok(jdbcTemplate.queryForList(sql, idUsuario));
    }

    @GetMapping("/puntos/{idUsuario}")
    public ResponseEntity<Map<String, Object>> obtenerPuntos(@PathVariable Integer idUsuario) {
        try { return ResponseEntity.ok(jdbcTemplate.queryForMap("SELECT * FROM vista_puntos_usuario WHERE id_usuario = ?", idUsuario));
        } catch(Exception e) { return ResponseEntity.ok(Map.of("puntos_actuales", 0)); }
    }
}

// Estructuras de Datos
class PedidoRequest {
    private Integer idUsuario; private Double totalPagado; private List<DetalleRequest> detalles;
    private String codigoCupon; // Se añade el campo para el código del cupón usado
    public Integer getIdUsuario() { return idUsuario; } public void setIdUsuario(Integer idUsuario) { this.idUsuario = idUsuario; }
    public Double getTotalPagado() { return totalPagado; } public void setTotalPagado(Double totalPagado) { this.totalPagado = totalPagado; }
    public List<DetalleRequest> getDetalles() { return detalles; } public void setDetalles(List<DetalleRequest> detalles) { this.detalles = detalles; }
    public String getCodigoCupon() { return codigoCupon; } public void setCodigoCupon(String codigoCupon) { this.codigoCupon = codigoCupon; }
}
class DetalleRequest {
    private Integer idProducto; private Integer cantidad; private Double subtotal;
    public Integer getIdProducto() { return idProducto; } public void setIdProducto(Integer idProducto) { this.idProducto = idProducto; }
    public Integer getCantidad() { return cantidad; } public void setCantidad(Integer cantidad) { this.cantidad = cantidad; }
    public Double getSubtotal() { return subtotal; } public void setSubtotal(Double subtotal) { this.subtotal = subtotal; }
}