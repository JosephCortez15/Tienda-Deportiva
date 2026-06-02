package com.stylematch.tienda;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.List;

@RestController
@CrossOrigin(origins = "*")
public class CatalogoController {

    @Autowired
    private ProductoRepository productoRepository;

    @GetMapping("/api/productos")
    public List<Producto> obtenerCatalogo() {
        return productoRepository.findAll();
    }
}