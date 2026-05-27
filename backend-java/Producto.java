import java.util.ArrayList;
import java.util.List;

public class Producto {
    private int idProducto;
    private int idCategoria;
    private String nombre;
    private String marca;
    private double precioBase;
    private String descripcionGeneral;
    private int idProveedor;
    private List<Resena> listaResenas;

    public Producto(){
    }

    public Producto(int idProducto, int idCategoria, String nombre, String marca, double precioBase, String descripcionGeneral, int idProveedor){
        this.idProducto = idProducto;
        this.idCategoria = idCategoria;
        this.nombre = nombre;
        this.marca = marca;
        this.precioBase = precioBase;
        this.descripcionGeneral = descripcionGeneral;
        this.idProveedor = idProveedor;
        this.listaResenas = new ArrayList<>();
    }

    public int getIdProducto() {
        return idProducto;
    }

    public void setIdProducto(int idProducto) {
        this.idProducto = idProducto;
    }

    public int getIdCategoria() {
        return idCategoria;
    }

    public void setIdCategoria(int idCategoria) {
        this.idCategoria = idCategoria;
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

    public double getPrecioBase() {
        return precioBase;
    }

    public void setPrecioBase(double precioBase) {
        this.precioBase = precioBase;
    }

    public String getDescripcionGeneral() {
        return descripcionGeneral;
    }

    public void setDescripcionGeneral(String descripcionGeneral) {
        this.descripcionGeneral = descripcionGeneral;
    }

    public int getIdProveedor() {
        return idProveedor;
    }

    public void setIdProveedor(int idProveedor) {
        this.idProveedor = idProveedor;
    }

    public void agregarResena(Resena r){
        this.listaResenas.add(r);
    }

    public void verTodasLasResenas(){
        System.out.println("\n Reseñas para: " + this.nombre + "---");
        if (listaResenas.isEmpty()) {
            System.out.println("Aun no hay opiniones.");
        }   else {
            for (Resena r : listaResenas){
                r.imprimirResena();
            }
        }
    }

    @Override
    public String toString() {
        return "Producto [" + idProducto + "] " + marca + " " + nombre + " - $" + precioBase;
    }
}
