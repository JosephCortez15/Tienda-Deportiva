public class Producto {
    private int idProducto;
    private int idCategoria;
    private String nombre;
    private String marca;
    private double precioBase;
    private String descripcionGeneral;
    private int idProveedor;

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

    @Override
    public String toString() {
        return "Producto [" + idProducto + "] " + marca + " " + nombre + " - $" + precioBase;
    }
}
