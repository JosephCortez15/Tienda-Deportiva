package com.stylematch.tienda;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.time.LocalDate;

@RestController
@RequestMapping("/api/precios")
@CrossOrigin(origins = "*")
public class HistorialPrecioController {

    @Autowired
    private HistorialPrecioRepository historialRepository;

    @PostMapping("/actualizar")
    public ResponseEntity<String> actualizarPrecio(@RequestBody HistorialPrecio nuevoPrecio) {
        try {
            // Asignamos la fecha de hoy automáticamente
            nuevoPrecio.setFecha(LocalDate.now());
            // Si no envían precio de compra, lo igualamos al de venta temporalmente
            if(nuevoPrecio.getPrecioCompra() == null) nuevoPrecio.setPrecioCompra(nuevoPrecio.getPrecioVenta());
            
            historialRepository.save(nuevoPrecio);
            return ResponseEntity.ok("✅ ¡Precio actualizado exitosamente en el historial!");
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("Error al actualizar el precio.");
        }
    }
}