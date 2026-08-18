package com.stylematch.tienda;

import jakarta.persistence.*;

@Entity
@Table(name = "descuentos")
public class Descuento {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_descuento")
    private Integer idDescuento;

    @Column(name = "id_producto")
    private Integer idProducto;

    @Column(name = "porcentaje")
    private Integer porcentaje;

    public Descuento() {}

    // --- GETTERS Y SETTERS ---
    public Integer getIdDescuento() { return idDescuento; }
    public void setIdDescuento(Integer idDescuento) { this.idDescuento = idDescuento; }

    public Integer getIdProducto() { return idProducto; }
    public void setIdProducto(Integer idProducto) { 
        this.idProducto = idProducto; 
    }

    public Integer getPorcentaje() { return porcentaje; }
    public void setPorcentaje(Integer porcentaje) { this.porcentaje = porcentaje; }
}