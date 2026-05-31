import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        List<Usuario> tablaUsuarios = new ArrayList<>();
        List<Producto> tablaProductos = new ArrayList<>();

        tablaUsuarios.add(new Usuario(1, 1, "Admin", "Principal", "admin@stylematch.com", "1234", "2026-05-19"));
        tablaUsuarios.add(new Usuario(2, 2, "Maria", "Gomez", "maria@gmail.com ", "abcd", "2026-05-19"));
        tablaProductos.add(new Producto(1, 2, "Polera", "Adidas", 250, "Polera para el uso diario", 1));
        tablaProductos.add(new Producto(2, 2, "Tenis", "Nike", 350.5, "Tenis para el uso diario", 1));

        Scanner teclado = new Scanner(System.in);
        int opcion = 0;

        while (opcion != 11) {
            System.out.println("\n--- Bienvenidos a StyleMatch");
            System.out.println("1. Ver usuarios registrados");
            System.out.println("2. Registrar nuevo usuario");
            System.out.println("3. Ver cátalogo de productos");
            System.out.println("4. Comprar un producto (Agregar al carrito)");
            System.out.println("5. Lista de deseos");
            System.out.println("6. Ir a la caja (Pagar)");
            System.out.println("7. Ver el historial de pedidos");
            System.out.println("8. Asesoria de talla con IA");
            System.out.println("9. Calificar un producto");
            System.out.println("10. [Admin] Gestionar envios");
            System.out.println("11. Salir");
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
                    System.out.println("Tienes cupon de descuento?");
                    System.out.println("Si su respuesta es si coloque el codigo promocional");
                    System.out.println("Si su respuesta es no, pasara a confirmar su pago.");
                    String codigo = teclado.nextLine();
                    if (codigo.equalsIgnoreCase("MUNDIAL")) {
                        double descuento = totalAPagar * 0.20;
                        totalAPagar = totalAPagar - descuento;
                        System.out.println("Codigo promocional aceptado, se te descontaron " + descuento);
                        System.out.println("Nuevo total a pagar: " + totalAPagar);
                    }   else if (!codigo.trim().isEmpty()) {
                        System.out.println("Codigo no valido o expirado");
                    }
                    System.out.println("\n --- Deseas confirmar tu pago por: " + totalAPagar + "? (Presione 1 para SI / 2 para NO)");
                    int confirmacion = teclado.nextInt();
                    teclado.nextLine();
                    if (confirmacion == 1) {
                            System.out.println("\n Procesando pago...");
                            Pedido nuevoPedido = new Pedido(101, "2026-05-23", totalAPagar, "Pagado", comprador.getListaCarrito());
                            comprador .agregarPedido(nuevoPedido);
                            System.out.println("Pago exitoso! Se ha generado su pedido.");
                            System.out.println("Pasando al area de preparacion y envio.");
                            comprador.vaciarCarrito();
                    } else if (confirmacion == 2) {
                        System.out.println("Compra cancelada. Tus productos siguen guardados en el carrito.");
                    }   else{
                        System.out.println("\n Opcion no valida. Cancelando operacion.");
                    }
                }
            }   else if (opcion == 7) {
                Usuario comprador = tablaUsuarios .get(0);
                comprador.verHistorialPedidos();
            }   else if (opcion == 8) {
                System.out.println("\n Configurar perfil biometrico");
                Usuario cliente = tablaUsuarios.get(0);
                System.out.println("Ingresa tu estatura en metros (ej. 1,75): ");
                double estatura = teclado.nextDouble();
                teclado.nextLine();
                System.out.println("Ingresa tu peso en kilogramos (Ej. 70,5)");
                double peso = teclado.nextDouble();
                teclado.nextLine();
                PerfilBiometrico nuevoPerfil = new PerfilBiometrico(estatura, peso);
                cliente.setPerfilBio(nuevoPerfil);
                cliente.verAsesoriaDeTalla();
            }   else if (opcion == 9) {
                System.out.println("\n Dejar una reseñia");
                System.out.println("Ingresa el ID del producto que deseas calificar: ");
                int idBuscado = teclado.nextInt();
                teclado.nextLine();
                Producto productoA_Calificar = null;
                for (Producto p : tablaProductos){
                    if (p.getIdProducto() == idBuscado) {
                        productoA_Calificar = p;
                        break;
                    }
                }
                if (productoA_Calificar != null) {
                    Usuario clienteActual = tablaUsuarios.get(0);
                    System.out.println("Del 1 al 5, ¿Cuántas estrellas le darías a " + productoA_Calificar.getNombre() + "?");
                    int estrellas = teclado.nextInt();
                    teclado.nextLine();
                    if (estrellas <= 1) {
                        estrellas = 1;
                    }
                    if (estrellas >= 5) {
                        estrellas = 5;
                    }
                    System.out.println("Escriba un breve comentario: ");
                    String comentario = teclado.nextLine();
                    Resena nuevaResena = new Resena(estrellas, comentario, clienteActual.getNombre());
                    productoA_Calificar.agregarResena(nuevaResena);
                    System.out.println("Gracias por su opinion");
                    productoA_Calificar.verTodasLasResenas();
                }   else{
                    System.out.println("Error: No existe ningun producto con ese ID");
                }
            }   else if (opcion == 10) {
                System.out.println("\n Panel administrador de envios");
                Usuario cliente = tablaUsuarios.get(0);
                List<Pedido> todosLosPedidos = cliente.getHistorialPedidos();
                if (todosLosPedidos.isEmpty()) {
                    System.out.println("No hay pedidos pendientes en el sistema");
                }   else {
                    System.out.println("\n Lista de pedidos Activos");
                    for (Pedido p : todosLosPedidos){
                        System.out.println("ID: " + p.getIdPedido() + " | Estado actual: " + p.getEstadoEnvio());
                    }
                    System.out.println("\n Ingresa el ID del pedido que deseas actualizar: ");
                    int idActualizar = teclado.nextInt();
                    teclado.nextLine();

                    Pedido pedidoEncontrado = null;
                    for (Pedido p : todosLosPedidos){
                        if (p.getIdPedido() == idActualizar) {
                            pedidoEncontrado = p;
                            break;
                        }
                    }
                    if (pedidoEncontrado != null) {
                        System.out.println("Selecciona el nuevo estado del pedido #" + idActualizar + ":");
                        System.out.println("1. Preparado en Almacen");
                        System.out.println("2. En camino (Entregado al repartidor)");
                        System.out.println("3. Entregado al cliente");
                        System.out.println("Opcion: ");
                        int nuevoEstado = teclado.nextInt();
                        teclado.nextLine();
                        if (nuevoEstado == 1) {
                            pedidoEncontrado.setEstadoEnvio("Preparando en almacen");
                        }   else if (nuevoEstado == 2) {
                            pedidoEncontrado.setEstadoEnvio("En camino (Entregado al repartidor)");
                        }   else if (nuevoEstado == 3) {
                            pedidoEncontrado.setEstadoEnvio("Entregado al cliente");
                        }   else{
                            System.out.println("Opcion invalida");
                        }
                        System.out.println("!Estado actualizado exitosamente¡");
                    }   else {
                        System.out.println("Error: no se encontro ningun pedido con el ID: " + idActualizar);
                    }
                }
            }   else if (opcion == 11) {
                System.out.println("Saliendo del sistema");
            }   else{
                System.out.println("Opcion no valida, pruebe de nuevo.");
            }
        }
        teclado.close();
    }
}