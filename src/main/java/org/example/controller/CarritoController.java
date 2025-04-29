package org.example.controller;

import io.javalin.http.Context;
import org.example.dao.OrdenDAO;
import org.example.dao.ProductoDAO;
import org.example.model.*;
import org.jetbrains.annotations.NotNull;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Controlador para gestionar las operaciones del carrito de compras
 * Versión optimizada para mejorar el rendimiento
 */
public class CarritoController {
    
    // Caché para productos frecuentemente consultados
    private static final Map<Integer, Producto> CACHE_PRODUCTOS = new ConcurrentHashMap<>(50);
    
    // Límite de tiempo para refrescar caché (30 segundos)
    private static final long CACHE_TIMEOUT_MS = 30000;
    private static final Map<Integer, Long> CACHE_TIMESTAMPS = new ConcurrentHashMap<>(50);
    
    /**
     * Método para mostrar el contenido del carrito
     */
    public static void verCarrito(Context ctx) {
        try {
            Usuario usuario = ctx.sessionAttribute("usuario");
            if (usuario == null) {
                ctx.redirect("/login");
                return;
            }

            // Obtener el carrito de la sesión o crear uno nuevo
            List<ItemCarrito> itemsCarrito = ctx.sessionAttribute("carrito");
            if (itemsCarrito == null) {
                itemsCarrito = new ArrayList<>();
                ctx.sessionAttribute("carrito", itemsCarrito);
            }

            // Calcular el total
            double total = 0.0;
            for (ItemCarrito item : itemsCarrito) {
                total += item.getSubtotal(); // Usar el subtotal que incluye la cantidad
            }

            Map<String, Object> modelo = new HashMap<>();
            modelo.put("usuario", usuario);
            modelo.put("items", itemsCarrito);
            modelo.put("total", total);
            
            ctx.render("carrito.ftl", modelo);
        } catch (Exception e) {
            e.printStackTrace();
            ctx.status(500);
            ctx.result("Error al cargar el carrito");
        }
    }

    /**
     * Método para agregar un producto al carrito (desde formulario)
     */
    public static void agregarAlCarrito(Context ctx) {
        try {
            int productoId = Integer.parseInt(ctx.formParam("productoId"));
            String cantidadParam = ctx.formParam("cantidad");
            int cantidad = 1; // Valor predeterminado
            
            if (cantidadParam != null && !cantidadParam.isEmpty()) {
                try {
                    cantidad = Integer.parseInt(cantidadParam);
                } catch (NumberFormatException e) {
                    // Si no es un número válido, usamos el valor predeterminado
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
                    ctx.json(Map.of("success", false, "error", "Producto no encontrado"));
                    return;
                }
            }

            ctx.sessionAttribute("carrito", carrito);
            ctx.json(Map.of("success", true));
        } catch (Exception e) {
            System.err.println("Error al agregar al carrito: " + e.getMessage());
            e.printStackTrace();
            ctx.json(Map.of("success", false, "error", e.getMessage()));
        }
    }

    /**
     * Obtiene un producto utilizando caché para mejorar rendimiento
     */
    private static Producto obtenerProductoOptimizado(int productoId) {
        // Verificar si el producto está en caché y si es válido
        Producto cachedProducto = CACHE_PRODUCTOS.get(productoId);
        Long timestamp = CACHE_TIMESTAMPS.get(productoId);
        
        // Si está en caché y aún es válido
        if (cachedProducto != null && timestamp != null && 
            System.currentTimeMillis() - timestamp < CACHE_TIMEOUT_MS) {
            return cachedProducto;
        }
        
        // Si no está en caché o expiró, consultarlo y almacenarlo
        Producto producto = ProductoDAO.obtenerPorId(productoId);
        if (producto != null) {
            CACHE_PRODUCTOS.put(productoId, producto);
            CACHE_TIMESTAMPS.put(productoId, System.currentTimeMillis());
        }
        
        return producto;
    }
    
    /**
     * Método para agregar un producto al carrito por ID en la URL
     * Versión optimizada para mejorar el rendimiento
     */


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


    public static void mostrarCarrito(@NotNull Context context) {
        try {
            Usuario usuario = context.sessionAttribute("usuario");
            if (usuario == null) {
                context.redirect("/login");
                return;
            }

            // Obtener el carrito del usuario desde la base de datos
            List<Orden> itemsCarrito = OrdenDAO. obtenerOrdenesDeUsuario(Long.valueOf(usuario.getId()));

            // Calcular el total
            double total = itemsCarrito.stream()
                                       .mapToDouble(Orden::calcularSubtotal)
                                       .sum();

            // Preparar el modelo para la vista
            Map<String, Object> modelo = new HashMap<>();
            modelo.put("usuario", usuario);
            modelo.put("items", itemsCarrito);
            modelo.put("total", total);

            context.render("carrito.ftl", modelo);
        } catch (Exception e) {
            e.printStackTrace();
            context.status(500).result("Error al cargar el carrito desde la base de datos");
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
}