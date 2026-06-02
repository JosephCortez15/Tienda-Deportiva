package com.stylematch.tienda;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;

public interface ProductoRepository extends JpaRepository<Producto, Integer> {
    @Query(value = "SELECT p.* FROM productos p INNER JOIN lista_deseos l ON p.id_producto = l.id_variante WHERE l.id_usuario = :idUsuario", nativeQuery = true)
    List<Producto> findFavoritosByUsuario(@Param("idUsuario") int idUsuario);

}