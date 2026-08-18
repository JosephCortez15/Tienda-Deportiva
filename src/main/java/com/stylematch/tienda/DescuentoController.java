package com.stylematch.tienda;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/descuentos")
@CrossOrigin(origins = "*")
public class DescuentoController {

    @Autowired
    private DescuentoRepository descuentoRepository;

    @GetMapping
    public List<Descuento> obtenerDescuentos() {
        return descuentoRepository.findAll();
    }

    @PostMapping("/agregar")
    public ResponseEntity<String> agregarDescuento(@RequestBody Descuento descuento) {
        try {
            // Verificamos si ya existe un descuento para este producto para actualizarlo o crear uno nuevo
            descuentoRepository.save(descuento);
            return ResponseEntity.ok("¡Descuento guardado y aplicado en la base de datos!");
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("Error al guardar el descuento.");
        }
    }
}