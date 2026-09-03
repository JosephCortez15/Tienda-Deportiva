package com.stylematch.tienda;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDate;

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

    @PostMapping("/agregar")
    public ResponseEntity<String> agregarProducto(@RequestBody Producto nuevoProducto) {
        try {
            Producto productoGuardado = productoRepository.save(nuevoProducto);

            HistorialPrecio primerPrecio = new HistorialPrecio();
            primerPrecio.setIdProducto(productoGuardado.getIdProducto());
            primerPrecio.setPrecioVenta(nuevoProducto.getPrecioBase());
            primerPrecio.setPrecioCompra(nuevoProducto.getPrecioBase());
            primerPrecio.setFecha(LocalDate.now());
            
            historialRepository.save(primerPrecio);

            return ResponseEntity.ok("Producto añadido al catálogo con su precio inicial exitosamente.");
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("Error al guardar en la base de datos.");
        }
    }

    @DeleteMapping("/eliminar/{id}")
    @Transactional 
    public ResponseEntity<String> eliminarProducto(@PathVariable Integer id) {
        try {
            // 1. Apagamos las restricciones de MySQL por un milisegundo (Modo Administrador)
            jdbcTemplate.execute("SET FOREIGN_KEY_CHECKS = 0");

            // 2. Limpiamos cualquier rastro del producto en las tablas principales
            jdbcTemplate.update("DELETE FROM descuentos WHERE id_producto = ?", id);
            jdbcTemplate.update("DELETE FROM historial_precios WHERE id_producto = ?", id);
            
            // Intentamos limpiar tablas secundarias (ignoramos si dan error por no existir)
            try { jdbcTemplate.update("DELETE FROM lista_deseos WHERE id_variante = ?", id); } catch(Exception e) {}
            try { jdbcTemplate.update("DELETE FROM variantes_producto WHERE id_producto = ?", id); } catch(Exception e) {}
            try { jdbcTemplate.update("DELETE FROM inventario WHERE id_producto = ?", id); } catch(Exception e) {}

            // 3. Eliminamos el producto principal de raíz
            productoRepository.deleteById(id);

            // 4. Volvemos a encender la seguridad de la base de datos
            jdbcTemplate.execute("SET FOREIGN_KEY_CHECKS = 1");

            return ResponseEntity.ok("Producto eliminado del catálogo exitosamente.");
        } catch (Exception e) {
            e.printStackTrace();
            // Si algo falla crítico, aseguramos que la seguridad se vuelva a encender
            jdbcTemplate.execute("SET FOREIGN_KEY_CHECKS = 1");
            return ResponseEntity.status(500).body("Error interno al procesar la eliminación.");
        }
    }
}