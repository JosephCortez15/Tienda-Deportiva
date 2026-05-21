import java.util.ArrayList;
import java.util.List;

public class Usuario {

    private int idUsuario;
    private int idRol;
    private String nombre;
    private String apellido;
    private String correo;
    private String contrasena;
    private String fechaRegistro;
    private List<Producto> carrito;

    public Usuario(){
        this.carrito = new ArrayList<>();
    }

    public Usuario(int idUsuario, int idRol, String nombre, String apellido, String correo, String contrasena, String fechaRegistro){
        this.idUsuario = idUsuario;
        this.idRol = idRol;
        this.nombre = nombre;
        this.apellido = apellido;
        this.correo = correo;
        this.contrasena = contrasena;
        this.fechaRegistro = fechaRegistro;
        this.carrito = new ArrayList<>();
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public int getIdRol() {
        return idRol;
    }

    public void setIdRol(int idRol) {
        this.idRol = idRol;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getApellido() {
        return apellido;
    }

    public void setApellido(String apellido) {
        this.apellido = apellido;
    }

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }

    public String getContrasena() {
        return contrasena;
    }

    public void setContrasena(String contrasena) {
        this.contrasena = contrasena;
    }

    public String getFechaRegistro() {
        return fechaRegistro;
    }

    public void setFechaRegistro(String fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }

    public void agregarAlCarrito(Producto p){
        this.carrito.add(p);
    }

    public void verCarrito(){
        System.out.println("---Carrito de " + this.nombre + " ---");
        if (carrito.isEmpty()) {
            System.out.println("El carrito esta vacio");
        } else {
            double total = 0;
            for (Producto p : carrito){
                System.out.println("- " + p.getNombre() + " ($" + p.getPrecioBase() + ")");
                total += p.getPrecioBase();
            }
            System.out.println("Total a pagar = " + total);
        }
    }

    @Override
    public String toString() {
        return "Usuario [idUsuario=" + idUsuario + ", idRol=" + idRol + ", nombre=" + nombre + ", apellido=" + apellido
                + ", correo=" + correo + ", contrasena=" + contrasena + ", fechaRegistro=" + fechaRegistro + "]";
    }
}