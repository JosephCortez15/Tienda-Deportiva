package com.stylematch.tienda;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/deseos")
@CrossOrigin(origins = "*")
public class DeseosController {

    @Autowired
    private ListaDeseosRepository deseosRepository;

    @Autowired
    private ProductoRepository productoRepository;

    @PostMapping("/agregar")
    public ResponseEntity<String> agregarFavorito(@RequestBody ListaDeseos nuevoDeseo) {
        try {
            nuevoDeseo.setFecha_agregado(LocalDate.now());
            deseosRepository.save(nuevoDeseo);
            return ResponseEntity.ok("Producto añadido a tu lista de deseos");
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("Error al añadir el producto a favoritos.");
        }
    }

    @GetMapping("/usuario/{idUsuario}")
    public ResponseEntity<?> verMisFavoritos(@PathVariable int idUsuario) {
        try {
            List<Producto> misFavoritos = productoRepository.findFavoritosByUsuario(idUsuario);
            return ResponseEntity.ok(misFavoritos);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("Error al cargar la lista de deseos");
        }
    }
}