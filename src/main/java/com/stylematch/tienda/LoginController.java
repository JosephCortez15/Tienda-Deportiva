package com.stylematch.tienda;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;


@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*")
public class LoginController {

    @Autowired
    private UsuarioRepository usuarioRepository;

    @PostMapping("/login")
    public ResponseEntity<?> iniciarSesion(@RequestBody Usuario datosLogin) {
        return usuarioRepository.findByCorreoAndContrasenia(datosLogin.getCorreo(), datosLogin.getContrasenia())
                .map(usuarioEncontrado -> {
                    return ResponseEntity.ok("Bienvenid@ " + usuarioEncontrado.getNombre());
                })
                .orElseGet(() -> {
                    return ResponseEntity.status(401).body("Correo o contraseña incorrectos");
                });
    }

    @PostMapping("/registro")
    public ResponseEntity<String> registrarUsuario(@RequestBody Usuario nuevoUsuario) {
        try {
            if (nuevoUsuario.getCorreo().endsWith("@stylematch.com")) {
                nuevoUsuario.setId_rol(1);
            } else {
                nuevoUsuario.setId_rol(2);
            }
            nuevoUsuario.setFecha_registro(java.time.LocalDate.now());
            usuarioRepository.save(nuevoUsuario);
            
            return ResponseEntity.ok("¡Cuenta creada con éxito! Ya puedes iniciar sesión.");
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("Error al crear la cuenta. ¿El correo ya está en uso?");
        }
    }
    
}