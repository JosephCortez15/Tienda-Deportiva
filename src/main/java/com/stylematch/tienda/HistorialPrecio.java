package com.stylematch.tienda;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "historial_precios")
public class HistorialPrecio {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_historial_precio")
    private Integer idHistorialPrecio;

    @Column(name = "id_producto")
    private Integer idProducto;

    @Column(name = "precio_venta")
    private Double precioVenta;
    
    @Column(name = "precio_compra")
    private Double precioCompra;

    @Column(name = "fecha")
    private LocalDate fecha;

    public HistorialPrecio() {}

    // Getters y Setters
    public Integer getIdHistorialPrecio() { return idHistorialPrecio; }
    public void setIdHistorialPrecio(Integer idHistorialPrecio) { this.idHistorialPrecio = idHistorialPrecio; }
    public Integer getIdProducto() { return idProducto; }
    public void setIdProducto(Integer idProducto) { this.idProducto = idProducto; }
    public Double getPrecioVenta() { return precioVenta; }
    public void setPrecioVenta(Double precioVenta) { this.precioVenta = precioVenta; }
    public Double getPrecioCompra() { return precioCompra; }
    public void setPrecioCompra(Double precioCompra) { this.precioCompra = precioCompra; }
    public LocalDate getFecha() { return fecha; }
    public void setFecha(LocalDate fecha) { this.fecha = fecha; }
}