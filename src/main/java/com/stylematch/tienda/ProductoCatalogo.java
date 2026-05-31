package com.stylematch.tienda;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.math.BigDecimal;

@Entity
@Table(name = "vista_catalogo")
public class ProductoCatalogo {

    @Id
    private Integer id_producto;
    private String nombre;
    private String marca;
    private String descripcion_general;
    private BigDecimal precio_venta;
    public Integer getId_producto() {
        return id_producto;
    }
    public void setId_producto(Integer id_producto) {
        this.id_producto = id_producto;
    }
    public String getNombre() {
        return nombre;
    }
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }
    public String getMarca() {
        return marca;
    }
    public void setMarca(String marca) {
        this.marca = marca;
    }
    public String getDescripcion_general() {
        return descripcion_general;
    }
    public void setDescripcion_general(String descripcion_general) {
        this.descripcion_general = descripcion_general;
    }
    public BigDecimal getPrecio_venta() {
        return precio_venta;
    }
    public void setPrecio_venta(BigDecimal precio_venta) {
        this.precio_venta = precio_venta;
    }

    
}