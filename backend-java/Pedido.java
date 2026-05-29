import java.util.ArrayList;
import java.util.List;

public class Pedido {
    private int idPedido;
    private String fechaPedido;
    private double totalPagado;
    private String estadoPagado;
    private String estadoEnvio;

    private List<Producto> articulosComprados;

    public Pedido(){
        this.articulosComprados = new ArrayList<>();
    }

    public Pedido(int idPedido, String fechaPedido, double totalPagado, String estadoPagado,
            List<Producto> articulosComprados) {
        this.idPedido = idPedido;
        this.fechaPedido = fechaPedido;
        this.totalPagado = totalPagado;
        this.estadoPagado = estadoPagado;
        this.estadoEnvio = "\n Preparando en almacen";
        this.articulosComprados = new ArrayList<>(articulosComprados);
    }

    public int getIdPedido() {
        return idPedido;
    }

    public void setIdPedido(int idPedido) {
        this.idPedido = idPedido;
    }

    public String getFechaPedido() {
        return fechaPedido;
    }

    public void setFechaPedido(String fechaPedido) {
        this.fechaPedido = fechaPedido;
    }

    public double getTotalPagado() {
        return totalPagado;
    }

    public void setTotalPagado(double totalPagado) {
        this.totalPagado = totalPagado;
    }

    public String getEstadoPagado() {
        return estadoPagado;
    }

    public void setEstadoPagado(String estadoPagado) {
        this.estadoPagado = estadoPagado;
    }

    public List<Producto> getArticulosComprados() {
        return articulosComprados;
    }

    public void setArticulosComprados(List<Producto> articulosComprados) {
        this.articulosComprados = articulosComprados;
    }

    public void imprimirTicket(){
        System.out.println("---------------------------");
        System.out.println("Pedidio Nro " + idPedido + " | Fecha " + fechaPedido + " | Estado " + estadoPagado);
        System.out.println("Pago: " + estadoPagado);
        System.out.println("\n Estado del envio: " + estadoEnvio);
        System.out.println("Articulos: ");
        for (Producto p : articulosComprados){
            System.out.println(" - " + p.getNombre() + " (" + p.getMarca() + ")");
        }
        System.out.println("Total pagado: " + totalPagado);
        System.out.println("------------------------------");
    }

    public String getEstadoEnvio() {
        return estadoEnvio;
    }

    public void setEstadoEnvio(String estadoEnvio) {
        this.estadoEnvio = estadoEnvio;
    }
}
