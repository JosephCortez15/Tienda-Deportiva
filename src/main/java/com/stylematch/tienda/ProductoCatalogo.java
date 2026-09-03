package com.stylematch.tienda;

import jakarta.persistence.*;

@Entity
@Table(name = "vista_catalogo")
public class ProductoCatalogo {

    @Id
    @Column(name = "id_producto")
    private Integer idProducto;

    @Column(name = "id_categoria")
    private Integer idCategoria;

    @Column(name = "nombre")
    private String nombre;

    @Column(name = "marca")
    private String marca;

    @Column(name = "descripcion_general")
    private String descripcionGeneral;

    @Column(name = "precio_venta")
    private Double precioVenta;

    public ProductoCatalogo() {}

    public Integer getIdProducto() { return idProducto; }
    public void setIdProducto(Integer idProducto) { this.idProducto = idProducto; }
    public Integer getIdCategoria() { return idCategoria; }
    public void setIdCategoria(Integer idCategoria) { this.idCategoria = idCategoria; }
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public String getMarca() { return marca; }
    public void setMarca(String marca) { this.marca = marca; }
    public String getDescripcionGeneral() { return descripcionGeneral; }
    public void setDescripcionGeneral(String descripcionGeneral) { this.descripcionGeneral = descripcionGeneral; }
    public Double getPrecioVenta() { return precioVenta; }
    public void setPrecioVenta(Double precioVenta) { this.precioVenta = precioVenta; }
}