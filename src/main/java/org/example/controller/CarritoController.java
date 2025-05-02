package org.example.controller;

import io.javalin.http.Context;
import org.example.dao.OrdenDAO;
import org.example.dao.ProductoDAO;
    import org.example.model.ItemCarrito;
import org.example.model.Orden;
import org.example.model.Producto;
    import org.example.model.Usuario;
import org.jetbrains.annotations.NotNull;

import java.time.LocalDateTime;
import java.util.ArrayList;
    import java.util.HashMap;
    import java.util.List;
    import java.util.Map;

import static org.example.dao.ProductoDAO.CACHE_TIMESTAMP;
import static org.example.dao.ProductoDAO.PRODUCTOS_CACHE;
   public class CarritoController {

    // Tiempo de expiración de caché en milisegundos
    private static final long CACHE_TIMEOUT_MS = 120000; // 2 minutos

    /**
     * Método para agregar un producto al carrito (desde formulario)
     */
       public static void agregarAlCarrito(Context ctx) {
           try {
               String productoIdParam = ctx.formParam("productoId");
               String referer = ctx.header("Referer"); // Obtener la página de referencia

               // Si no hay referencia, usar una ruta por defecto
               if (referer == null) {
                   referer = "/catalogo_simple";
               }

               if (productoIdParam == null) {
                   ctx.redirect(referer + "?error=NoProductId");
                   return;
               }

               int productoId = Integer.parseInt(productoIdParam);

               // Obtener cantidad del formulario o usar valor predeterminado
               String cantidadParam = ctx.formParam("cantidad");
               int cantidad = 1;

               if (cantidadParam != null && !cantidadParam.isEmpty()) {
                   try {
                       cantidad = Integer.parseInt(cantidadParam);
                   } catch (NumberFormatException e) {
                       // Si no es un número válido, usar el valor predeterminado
                   }
               }

               // Obtener carrito de la sesión o crear uno nuevo
               List<ItemCarrito> carrito = ctx.sessionAttribute("carrito");
               if (carrito == null) {
                   carrito = new ArrayList<>();
               }

               // Buscar si el producto ya existe en el carrito
               boolean productoExistente = false;
               for (ItemCarrito item : carrito) {
                   if (item.getProducto().getId() == productoId) {
                       item.setCantidad(item.getCantidad() + cantidad);
                       productoExistente = true;
                       break;
                   }
               }

               // Si no existe, lo agrega al carrito
               if (!productoExistente) {
                   Producto producto = ProductoDAO.obtenerPorId(productoId);
                   if (producto != null) {
                       ItemCarrito nuevoItem = new ItemCarrito(producto, cantidad);
                       carrito.add(nuevoItem);
                   } else {
                       ctx.redirect(referer + "?error=ProductoNoEncontrado");
                       return;
                   }
               }

               // Guardar carrito en la sesión
               ctx.sessionAttribute("carrito", carrito);

               // Redirigir a la página anterior o a la página de catálogo con mensaje de éxito
               ctx.redirect(referer + "?mensaje=ProductoAgregado");
           } catch (Exception e) {
               System.err.println("Error al agregar al carrito: " + e.getMessage());
               e.printStackTrace();
               ctx.redirect("/catalogo_simple?error=" + e.getMessage().replace(" ", "+"));
           }
       }

    /**
     * Obtiene un producto utilizando caché para mejorar rendimiento
     */
    private static Producto obtenerProductoOptimizado(int productoId) {
        // Verificar si el producto está en caché y si es válido
        Producto cachedProducto = PRODUCTOS_CACHE.get(productoId);
        Long timestamp = CACHE_TIMESTAMP.get(productoId);

        // Si está en caché y aún es válido
        if (cachedProducto != null && timestamp != null &&
                System.currentTimeMillis() - timestamp < CACHE_TIMEOUT_MS) {
            return cachedProducto;
        }

        // Si no está en caché o expiró, consultarlo y almacenarlo
        Producto producto = ProductoDAO.obtenerPorId(productoId);
        if (producto != null) {
            PRODUCTOS_CACHE.put(productoId, producto);
            CACHE_TIMESTAMP.put(productoId, System.currentTimeMillis());
        }

        return producto;
    }


    /**
     * Método para eliminar un producto del carrito
     */
    public static void eliminarDelCarrito(Context ctx) {
        try {
            int productoId = Integer.parseInt(ctx.pathParam("id"));
            List<ItemCarrito> carrito = ctx.sessionAttribute("carrito");

            if (carrito != null) {
                carrito.removeIf(item -> item.getProducto().getId() == productoId);
            }

            // Si es una petición AJAX, devolver respuesta JSON
            String requestedWith = ctx.header("X-Requested-With");
            if ("XMLHttpRequest".equals(requestedWith)) {
                ctx.status(200);
                ctx.contentType("application/json");
                ctx.result("{\"success\": true}");
                return;
            }

            ctx.redirect("/carrito");
        } catch (Exception e) {
            e.printStackTrace();

            // Si es una petición AJAX, devolver error JSON
            String requestedWith = ctx.header("X-Requested-With");
            if ("XMLHttpRequest".equals(requestedWith)) {
                ctx.status(500);
                ctx.contentType("application/json");
                ctx.result("{\"success\": false, \"error\": \"" + e.getMessage() + "\"}");
                return;
            }

            ctx.status(500);
            ctx.result("Error al eliminar del carrito");
        }
    }

    /**
     * Método para actualizar la cantidad de un producto en el carrito
     */
    public static void actualizarCantidad(Context ctx) {
        try {
            int productoId = Integer.parseInt(ctx.pathParam("id"));
            int cantidad = Integer.parseInt(ctx.formParam("cantidad"));

            List<ItemCarrito> carrito = ctx.sessionAttribute("carrito");
            if (carrito != null) {
                for (ItemCarrito item : carrito) {
                    if (item.getProducto().getId() == productoId) {
                        if (cantidad > 0) {
                            item.setCantidad(cantidad);
                        } else {
                            carrito.remove(item);
                        }
                        break;
                    }
                }
            }

            // Si es una petición AJAX, devolver respuesta JSON
            String requestedWith = ctx.header("X-Requested-With");
            if ("XMLHttpRequest".equals(requestedWith)) {
                ctx.status(200);
                ctx.contentType("application/json");
                ctx.result("{\"success\": true}");
                return;
            }

            ctx.redirect("/carrito");
        } catch (Exception e) {
            e.printStackTrace();

            // Si es una petición AJAX, devolver error JSON
            String requestedWith = ctx.header("X-Requested-With");
            if ("XMLHttpRequest".equals(requestedWith)) {
                ctx.status(500);
                ctx.contentType("application/json");
                ctx.result("{\"success\": false, \"error\": \"" + e.getMessage() + "\"}");
                return;
            }

            ctx.status(500);
            ctx.result("Error al actualizar cantidad");
        }
    }


       public static void mostrarCarrito(Context ctx) {
           try {
               Usuario usuario = ctx.sessionAttribute("usuario");
               if (usuario == null) {
                   ctx.redirect("/login");
                   return;
               }

               List<ItemCarrito> carrito = ctx.sessionAttribute("carrito");
               if (carrito == null) {
                   carrito = new ArrayList<>();
               }

               double total = carrito.stream()
                       .mapToDouble(item -> item.getProducto().getPrecio() * item.getCantidad())
                       .sum();

               Map<String, Object> modelo = new HashMap<>();
               modelo.put("usuario", usuario);
               modelo.put("carrito", carrito);
               modelo.put("total", total);

               ctx.render("carrito.ftl", modelo);
           } catch (Exception e) {
               e.printStackTrace();
               ctx.status(500).result("Error al mostrar el carrito");
           }
       }


       public static void vaciarCarrito(@NotNull Context context) {
        try {
            Usuario usuario = context.sessionAttribute("usuario");
            if (usuario == null) {
                context.redirect("/login");
                return;
            }

            // Vaciar el carrito en la sesión
            List<ItemCarrito> carrito = context.sessionAttribute("carrito");
            if (carrito != null) {
                carrito.clear();
            }

            // Vaciar el carrito en la base de datos
            OrdenDAO.vaciarCarrito(usuario.getId());

            context.redirect("/carrito");
        } catch (Exception e) {
            e.printStackTrace();
            context.status(500).result("Error al vaciar el carrito");
        }
    }


    public static void finalizarCompra(Context ctx) {
           try {
               Usuario usuario = ctx.sessionAttribute("usuario");
               if (usuario == null) {
                   ctx.redirect("/login");
                   return;
               }

               List<ItemCarrito> carrito = ctx.sessionAttribute("carrito");
               if (carrito == null || carrito.isEmpty()) {
                   ctx.redirect("/carrito");
                   return;
               }

               // Calcular el total
               double total = carrito.stream()
                       .mapToDouble(item -> item.getProducto().getPrecio() * item.getCantidad())
                       .sum();

               // Crear la orden
               Orden orden = new Orden();
               orden.setUsuario(usuario);
               orden.setTotal(total);
               orden.setEstado("PENDIENTE");
               orden.setFecha(LocalDateTime.now());

               // Añadir detalles a la orden
               for (ItemCarrito item : carrito) {
                   orden.agregarDetalle(item.getProducto(), item.getCantidad(), item.getProducto().getPrecio());
               }

               // Guardar en la base de datos
               OrdenDAO.guardar(orden);

               // Limpiar el carrito
               carrito.clear();
               ctx.sessionAttribute("carrito", carrito);

               // Redirigir al historial de pedidos
               ctx.redirect("/ordenes");

           } catch (Exception e) {
               e.printStackTrace();
               ctx.status(500).result("Error al procesar la compra: " + e.getMessage());
           }
       }

   }