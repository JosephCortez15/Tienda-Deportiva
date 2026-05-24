import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        List<Usuario> tablaUsuarios = new ArrayList<>();
        List<Producto> tablaProductos = new ArrayList<>();

        tablaUsuarios.add(new Usuario(1, 1, "Admin", "Principal", "admin@stylematch.com", "1234", "2026-05-19"));
        tablaUsuarios.add(new Usuario(1, 2, "Maria", "Gomez", "maria@gmail.com ", "abcd", "2026-05-19"));
        tablaProductos.add(new Producto(1, 2, "Polera", "Adidas", 250, "Polera para el uso diario", 1));

        Scanner teclado = new Scanner(System.in);
        int opcion = 0;

        while (opcion != 5) {
            System.out.println("\n--- Bienvenidos a StyleMatch");
            System.out.println("1. Ver usuarios registrados");
            System.out.println("2. Registrar nuevo usuario");
            System.out.println("3. Ver cátalogo de productos");
            System.out.println("4. Comprar un producto (Agregar al carrito)");
            System.out.println("5. Lista de deseos");
            System.out.println("6. Ir a la caja (Pagar)");
            System.out.println("7. Salir");
            System.out.println("Elige una opcion: ");
            opcion = teclado.nextInt();
            teclado.nextLine();
            if (opcion == 1) {
                System.out.println("\n--- Lista de Uusarios ---");
                for (Usuario u : tablaUsuarios){
                    System.out.println(u.toString());
                }
            } else if (opcion == 2) {
                System.out.println("\n--- Registro de Usuarios ---");
                Usuario nuevo = new Usuario();
                nuevo.setIdUsuario(tablaUsuarios.size() + 1);
                nuevo.setIdRol(2);
                System.out.println("Ingresa tu nombre");
                nuevo.setNombre(teclado.nextLine());
                System.out.println("Ingresa tu apellido");
                nuevo.setApellido(teclado.nextLine());
                System.out.println("Ingresa tu correo");
                nuevo.setCorreo(teclado.nextLine());
                System.out.println("Ingresa tu contrasena");
                nuevo.setContrasena(teclado.nextLine());
                nuevo.setFechaRegistro("2026-05-19");
                tablaUsuarios.add(nuevo);
                System.out.println("Usuario registrado con exito!");
            }   else if (opcion == 3) {
                System.out.println("Catalogo de productos");
                for (Producto p : tablaProductos){
                    System.out.println(p.toString());
                }
            }   else if (opcion == 4) {
                System.out.println("Ingresa el ID del producto que deseas comprar");
                int idBuscado = teclado.nextInt();
                Producto productoEncontrado = null;
                for (Producto p : tablaProductos){
                    if (p.getIdProducto() == idBuscado) {
                        productoEncontrado = p;
                        break;
                    }
                }
                if (productoEncontrado != null) {
                    Usuario comprador = tablaUsuarios.get(0);
                    comprador.agregarAlCarrito(productoEncontrado);
                    System.out.println("\n -" + productoEncontrado.getNombre() + " agregado al carrito de " + comprador.getNombre() + " ¡");
                    comprador.verCarrito();
                }   else {
                    System.out.println("Error: No existe ningun producto con ID en el catalogo");
                }
            }   else if (opcion == 5) {
                System.out.println("\n --- Agregar a lista de deseos ---");
                System.out.println("Ingresa el id del producto que te gusta: ");
                int idBuscado = teclado.nextInt();
                teclado.nextLine();
                Producto productoEncontrado = null;
                for (Producto p : tablaProductos){
                    if (p.getIdProducto() == idBuscado) {
                        productoEncontrado = p;
                        break;
                    }
                }
                if (productoEncontrado != null) {
                    Usuario comprador = tablaUsuarios.get(0);
                    comprador.agregarADeseos(productoEncontrado);
                    System.out.println(productoEncontrado.getNombre() + ". Se agrego a tus favoritos");
                    comprador.verListaDeseos();
                }   else {
                    System.out.println("Error: No existe ningun producto con este ID");
                }
            }   else if (opcion == 6) {
                System.out.println("\n--- Caja registradora ---");
                Usuario comprador = tablaUsuarios.get(0);
                if (comprador.tieneCarritoVacio()) {
                    System.out.println("Tu carrito esta vacio. Ve al carrito para añadir un producto");
                }   else {
                    comprador.verCarrito();
                    double totalAPagar = comprador.calcularTotalCarrito();
                    System.out.println("\n --- Deseas confirmar tu pago por: " + totalAPagar + "? (Presione 1 para SI / 2 para NO)");
                    int confirmacion = teclado.nextInt();
                    teclado.nextLine();
                    if (confirmacion == 1) {
                            System.out.println("\n Procesando pago...");
                            System.out.println("Pago exitoso! Se ha generado su pedido.");
                            System.out.println("Pasando al area de preparacion y envio.");
                            comprador.vaciarCarrito();
                    } else if (confirmacion == 2) {
                        System.out.println("Compra cancelada. Tus productos siguen guardados en el carrito.");
                    }   else{
                        System.out.println("\n Opcion no valida. Cancelando operacion.");
                    }
                }
            }   else if (opcion == 5) {
                System.out.println("Saliendo del sistema");
            }
        }
        teclado.close();
    }
}