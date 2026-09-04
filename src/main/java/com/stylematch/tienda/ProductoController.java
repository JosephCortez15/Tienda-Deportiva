package com.stylematch.tienda;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.jdbc.core.JdbcTemplate;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/productos")
@CrossOrigin(origins = "*")
public class ProductoController {

    @Autowired
    private ProductoRepository productoRepository;

    @Autowired
    private HistorialPrecioRepository historialRepository;

    @Autowired
    private JdbcTemplate jdbcTemplate; 

    // Solo muestra los productos donde activo = 1
    @GetMapping("/catalogo-completo")
    public ResponseEntity<List<Map<String, Object>>> obtenerCatalogoConStock() {
        String sql = "SELECT p.id_producto, p.id_categoria, p.nombre, p.marca, " +
                     "h.precio_venta, CAST(IFNULL(SUM(v.stock_actual), 0) AS SIGNED) as stock_actual " +
                     "FROM productos p JOIN historial_precios h ON p.id_producto = h.id_producto " +
                     "LEFT JOIN variantes_producto v ON p.id_producto = v.id_producto " +
                     "WHERE p.activo = 1 AND h.id_historial_precio = (SELECT MAX(id_historial_precio) FROM historial_precios WHERE id_producto = p.id_producto) " +
                     "GROUP BY p.id_producto, p.id_categoria, p.nombre, p.marca, h.precio_venta";
        return ResponseEntity.ok(jdbcTemplate.queryForList(sql));
    }

    // NUEVO: Endpoint para listar los productos ocultos
    @GetMapping("/ocultos")
    public ResponseEntity<List<Map<String, Object>>> obtenerOcultos() {
        return ResponseEntity.ok(jdbcTemplate.queryForList("SELECT id_producto, nombre, marca FROM productos WHERE activo = 0"));
    }

    // NUEVO: Restaura el producto al catálogo (activo = 1)
    @PostMapping("/restaurar/{id}")
    public ResponseEntity<String> restaurarProducto(@PathVariable Integer id) {
        jdbcTemplate.update("UPDATE productos SET activo = 1 WHERE id_producto = ?", id);
        return ResponseEntity.ok("Producto restaurado al catálogo con éxito.");
    }

    // ELIMINACIÓN LÓGICA (Ocultar)
    @DeleteMapping("/eliminar/{id}")
    public ResponseEntity<String> eliminarProducto(@PathVariable Integer id) {
        try {
            jdbcTemplate.update("UPDATE productos SET activo = 0 WHERE id_producto = ?", id);
            jdbcTemplate.update("INSERT INTO bitacora_sistema (id_usuario, accion_realizada, fecha_hora, tabla_afectada) VALUES (1, CONCAT('Ocultó el producto #', ?), NOW(), 'productos')", id);
            return ResponseEntity.ok("El producto ha sido ocultado del catálogo.");
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Error al ocultar el producto.");
        }
    }

    // --- RESTO DE MÉTODOS INTACTOS ---
    @PostMapping("/deseos/agregar")
    public ResponseEntity<String> gestionarDeseo(@RequestBody Map<String, Object> payload) {
        try {
            Integer idUser = Integer.parseInt(payload.get("id_usuario").toString());
            Integer idProd = Integer.parseInt(payload.get("id_variante").toString()); 
            List<Integer> variantes = jdbcTemplate.queryForList("SELECT id_variante FROM variantes_producto WHERE id_producto = ? LIMIT 1", Integer.class, idProd);
            if (variantes.isEmpty()) { jdbcTemplate.update("INSERT INTO variantes_producto (id_producto, talla, color, stock_actual) VALUES (?, 'Única', 'Estándar', 0)", idProd); variantes = jdbcTemplate.queryForList("SELECT id_variante FROM variantes_producto WHERE id_producto = ? LIMIT 1", Integer.class, idProd); }
            Integer idVariante = variantes.get(0);
            Integer existe = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM lista_deseos WHERE id_usuario = ? AND id_variante = ?", Integer.class, idUser, idVariante);
            if (existe != null && existe > 0) { jdbcTemplate.update("DELETE FROM lista_deseos WHERE id_usuario = ? AND id_variante = ?", idUser, idVariante); return ResponseEntity.ok("Producto eliminado de tu lista personal."); } 
            else { jdbcTemplate.update("CALL agregar_wishlist(?, ?)", idUser, idVariante); return ResponseEntity.ok("Añadido a tus favoritos."); }
        } catch (Exception e) { return ResponseEntity.status(500).body("Error interno al gestionar favoritos."); }
    }

    @GetMapping("/deseos/usuario/{idUsuario}")
    public ResponseEntity<List<Map<String, Object>>> obtenerDeseos(@PathVariable Integer idUsuario) {
        String sql = "SELECT p.id_producto, p.id_categoria, p.nombre, p.marca, h.precio_venta, CAST(IFNULL(SUM(v.stock_actual), 0) AS SIGNED) as stock_actual FROM productos p JOIN historial_precios h ON p.id_producto = h.id_producto JOIN variantes_producto v ON p.id_producto = v.id_producto JOIN lista_deseos l ON v.id_variante = l.id_variante WHERE l.id_usuario = ? AND p.activo = 1 AND h.id_historial_precio = (SELECT MAX(id_historial_precio) FROM historial_precios WHERE id_producto = p.id_producto) GROUP BY p.id_producto, p.id_categoria, p.nombre, p.marca, h.precio_venta";
        return ResponseEntity.ok(jdbcTemplate.queryForList(sql, idUsuario));
    }

    @PostMapping("/valorar")
    public ResponseEntity<String> valorarProducto(@RequestBody Map<String, Object> payload) {
        try {
            Integer idUser = Integer.parseInt(payload.get("idUsuario").toString()); Integer idProd = Integer.parseInt(payload.get("idProducto").toString()); Integer estrellas = Integer.parseInt(payload.get("estrellas").toString()); String comentario = payload.get("comentario").toString();
            jdbcTemplate.update("CALL registrar_resena(?, ?, ?, ?)", idUser, idProd, estrellas, comentario);
            String accionAuditoria = "Reseñó P#" + idProd + " (" + estrellas + "★): " + comentario;
            if (accionAuditoria.length() > 50) { accionAuditoria = accionAuditoria.substring(0, 47) + "..."; }
            jdbcTemplate.update("INSERT INTO bitacora_sistema (id_usuario, accion_realizada, fecha_hora, tabla_afectada) VALUES (?, ?, NOW(), 'resenas_valoraciones')", idUser, accionAuditoria);
            return ResponseEntity.ok("¡Reseña registrada con éxito!");
        } catch(Exception e) { return ResponseEntity.status(500).body("Error al guardar reseña."); }
    }

    @GetMapping("/bitacora")
    public ResponseEntity<List<Map<String, Object>>> verBitacora() { return ResponseEntity.ok(jdbcTemplate.queryForList("SELECT b.fecha_hora, u.nombre AS nombre_usuario, b.accion_realizada FROM bitacora_sistema b JOIN usuarios u ON b.id_usuario = u.id_usuario ORDER BY b.fecha_hora DESC LIMIT 20")); }

    @PostMapping("/actualizar-stock")
    public ResponseEntity<String> actualizarStock(@RequestBody Map<String, Integer> request) {
        try {
            Integer idProducto = request.get("idProducto"); Integer nuevoStock = request.get("stock");
            Integer conteo = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM variantes_producto WHERE id_producto = ?", Integer.class, idProducto);
            if (conteo != null && conteo > 0) { jdbcTemplate.update("UPDATE variantes_producto SET stock_actual = ? WHERE id_producto = ? LIMIT 1", nuevoStock, idProducto); } 
            else { jdbcTemplate.update("INSERT INTO variantes_producto (id_producto, talla, color, stock_actual) VALUES (?, 'Única', 'Estándar', ?)", idProducto, nuevoStock); }
            return ResponseEntity.ok("Stock actualizado exitosamente.");
        } catch (Exception e) { return ResponseEntity.status(500).body("Error al actualizar."); }
    }

    @PostMapping("/agregar")
    public ResponseEntity<String> agregarProducto(@RequestBody Producto nuevoProducto) {
        try {
            Producto productoGuardado = productoRepository.save(nuevoProducto);
            HistorialPrecio primerPrecio = new HistorialPrecio(); primerPrecio.setIdProducto(productoGuardado.getIdProducto()); primerPrecio.setPrecioVenta(nuevoProducto.getPrecioBase()); primerPrecio.setPrecioCompra(nuevoProducto.getPrecioBase()); primerPrecio.setFecha(LocalDate.now()); historialRepository.save(primerPrecio);
            jdbcTemplate.update("INSERT INTO variantes_producto (id_producto, talla, color, stock_actual) VALUES (?, 'Única', 'Estándar', 0)", productoGuardado.getIdProducto());
            return ResponseEntity.ok("Producto añadido al catálogo.");
        } catch (Exception e) { return ResponseEntity.status(500).body("Error de servidor."); }
    }
}