package com.stylematch.tienda;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*")
public class CatalogoController {

    @Autowired
    private ProductoCatalogoRepository vistaRepository;

    @GetMapping("/productos")
    public List<ProductoCatalogo> obtenerProductos() { 
        return vistaRepository.findAll();
    }
}