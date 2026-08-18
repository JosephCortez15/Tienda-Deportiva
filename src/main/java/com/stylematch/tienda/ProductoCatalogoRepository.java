package com.stylematch.tienda;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;

public interface ProductoCatalogoRepository extends JpaRepository<ProductoCatalogo, Integer> {
    
    // Esta maravilla cruza la lista de deseos directamente con TU VISTA
    @Query(value = "SELECT v.* FROM vista_catalogo v INNER JOIN lista_deseos l ON v.id_producto = l.id_variante WHERE l.id_usuario = :idUsuario", nativeQuery = true)
    List<ProductoCatalogo> findFavoritosByUsuario(@Param("idUsuario") int idUsuario);
}