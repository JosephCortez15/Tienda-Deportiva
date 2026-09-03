package com.stylematch.tienda;

import jakarta.persistence.*;
import com.fasterxml.jackson.annotation.JsonProperty;

@Entity
@Table(name = "productos")
public class Producto {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_producto")
    private Integer idProducto;

    @JsonProperty("id_categoria")
    @Column(name = "id_categoria")
    private Integer idCategoria;

    @JsonProperty("nombre")
    @Column(name = "nombre")
    private String nombre;

    @JsonProperty("marca")
    @Column(name = "marca")
    private String marca;

    @JsonProperty("descripcion_general")
    @Column(name = "descripcion_general")
    private String descripcionGeneral;

    @JsonProperty("id_proveedor")
    @Column(name = "id_proveedor")
    private Integer idProveedor;

    // @Transient evita que Java busque esta columna en la tabla productos
    @Transient 
    @JsonProperty("precio_base")
    private Double precioBase;

    public Producto() {}

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

    public Integer getIdProveedor() { return idProveedor; }
    public void setIdProveedor(Integer idProveedor) { this.idProveedor = idProveedor; }

    public Double getPrecioBase() { return precioBase; }
    public void setPrecioBase(Double precioBase) { this.precioBase = precioBase; }
}