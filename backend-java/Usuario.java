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
    private List<Producto> listaDeseos;
    private List<Pedido> historialPedidos;
    private PerfilBiometrico perfilBio;

    public Usuario(){
        this.carrito = new ArrayList<>();
        this.listaDeseos = new ArrayList<>();
        this.historialPedidos = new ArrayList<>();
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
        this.listaDeseos = new ArrayList<>();
        this.historialPedidos = new ArrayList<>();
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

    public void agregarADeseos(Producto p){
        this.listaDeseos.add(p);
    }

    public void verListaDeseos(){
        System.out.println("\n--- Lista de deseos de " + this.nombre + " ---");
        if (listaDeseos.isEmpty()) {
            System.out.println("Tu lista de deseos esta vacia");
        } else {
            for (Producto p : listaDeseos){
                System.out.println(" " + p.getNombre() + " (" + p.getMarca() + " )");
            }
        }
    }

    public double calcularTotalCarrito(){
        double total = 0;
        for (Producto p : carrito){
            total += p.getPrecioBase();
        }
        return total;
    }

    public boolean tieneCarritoVacio(){
        return this.carrito.isEmpty();
    }

    public void vaciarCarrito(){
        this.carrito.clear();
    }

    public void agregarPedido(Pedido nuevoPedido){
        this.historialPedidos.add(nuevoPedido);
    }

    public void verHistorialPedidos(){
        System.out.println("\n Historial de " + this.nombre);
        if (historialPedidos.isEmpty()) {
            System.out.println("Aun no se realizo niguna compra.");
        }   else {
            for (Pedido p : historialPedidos){
                p.imprimirTicket();
            }
        }
    }

    public List<Producto> getListaCarrito(){
        return this.carrito;
    }

    public PerfilBiometrico getPerfilBio(){
        return perfilBio;
    }

    public void setPerfilBio(PerfilBiometrico perfilBio){
        this.perfilBio = perfilBio;
    }

    public void verAsesoriaDeTalla(){
        if (this.perfilBio == null) {
            System.out.println("Aun no configuraste tu perfil biometrico");
        }   else {
            System.out.println("\n Asesoria inteligente de Stylematch");
            System.out.println("Basado en tu estatura (" + perfilBio.getEstatura() +  "m) y peso (" + perfilBio.getPeso() + "kg): " );
            System.out.println("Tu talla ideal recomendada es: " + perfilBio.calcularTallaIdeal());
        }
    }

    public List<Pedido> getHistorialPedidos(){
        return this.historialPedidos;
    }

    @Override
    public String toString() {
        return "Usuario [idUsuario=" + idUsuario + ", idRol=" + idRol + ", nombre=" + nombre + ", apellido=" + apellido
                + ", correo=" + correo + ", contrasena=" + contrasena + ", fechaRegistro=" + fechaRegistro + "]";
    }
}