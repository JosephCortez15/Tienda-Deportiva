package com.stylematch.tienda;
import jakarta.persistence.*;

@Entity
@Table(name = "lista_deseos")
public class ListaDeseos {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_wish")
    private Integer id_wish;

    @Column(name = "id_usuario")
    private Integer id_usuario;

    @Column(name = "id_variante")
    private Integer id_variante;

    @Column(name = "fecha_agregado")
    private java.time.LocalDate fecha_agregado;

    public ListaDeseos(){

    }

    public Integer getId_wish() {
        return id_wish;
    }

    public void setId_wish(Integer id_wish) {
        this.id_wish = id_wish;
    }

    public Integer getId_usuario() {
        return id_usuario;
    }

    public void setId_usuario(Integer id_usuario) {
        this.id_usuario = id_usuario;
    }

    public Integer getId_variante() {
        return id_variante;
    }

    public void setId_variante(Integer id_variante) {
        this.id_variante = id_variante;
    }

    public java.time.LocalDate getFecha_agregado() {
        return fecha_agregado;
    }

    public void setFecha_agregado(java.time.LocalDate fecha_agregado) {
        this.fecha_agregado = fecha_agregado;
    }

    
}
