package org.example.controller;

import io.javalin.http.Context;
import org.example.dao.OrdenDAO;
import org.example.dao.ProductoDAO;
import org.example.model.Orden;
import org.example.model.Producto;
import org.example.model.Usuario;

import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.javalin.http.UploadedFile;
import java.io.File;

import org.example.util.FileUtil;
import org.jetbrains.annotations.NotNull;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ProductoController {
    private static final Logger logger = LoggerFactory.getLogger(ProductoController.class);

    /**
     * Método para mostrar el dashboard administrativo
     */
    public static void mostrarDashboard(Context ctx) {

        try {
            logger.info("Iniciando carga del dashboard administrativo");
            
            // Obtener el usuario de la sesión
            Usuario usuario = ctx.sessionAttribute("usuario");

            // Verificar que el usuario está autenticado
            if (usuario == null) {
                logger.warn("No hay usuario en sesión al intentar acceder al dashboard");
                ctx.redirect("/login");
                return;
            }
    
            // Verificar si el usuario es admin
            if (!"admin".equalsIgnoreCase(usuario.getRol())) {
                logger.warn("Usuario no es admin: {} (Rol: {})", usuario.getUsername(), usuario.getRol());
                ctx.status(403);
                ctx.result("Acceso denegado: Solo administradores pueden acceder al dashboard");
                return;
            }
    
            logger.info("Mostrando dashboard para admin: {}", usuario.getUsername());
    
            // Obtener la lista de productos
            List<Producto> productos = ProductoDAO.obtenerTodos();
            logger.info("Productos encontrados: {}", productos.size());
            
            // Obtener las órdenes para la pestaña de pedidos
            List<Orden> ordenes = new ArrayList<>();
            try {
                ordenes = OrdenDAO.obtenerTodasOrdenes();
                // Formatear las fechas de las órdenes
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
                for (Orden orden : ordenes) {
                    if (orden.getFecha() != null) {
                        orden.setFechaFormateada(orden.getFecha().format(formatter));
                    }
                }

                logger.info("Órdenes cargadas: {}", ordenes.size());
            } catch (Exception e) {
                logger.warn("Error al cargar órdenes: {}", e.getMessage());
            }
    
            // Crear el modelo de datos para la plantilla
            Map<String, Object> modelo = new HashMap<>();
            modelo.put("productos", productos);
            modelo.put("ordenes", ordenes);
            modelo.put("usuario", usuario);
            
            // Verificar si hay mensaje de operación exitosa en la sesión
            String mensaje = ctx.sessionAttribute("mensaje");
            if (mensaje != null && !mensaje.isEmpty()) {
                modelo.put("mensaje", mensaje);
                // Limpiar el mensaje después de usarlo
                ctx.sessionAttribute("mensaje", null);
                logger.info("Mensaje para el dashboard: {}", mensaje);
            }
    
            // Renderizar la plantilla del dashboard
            ctx.render("dashboard.ftl", modelo);
            logger.info("Dashboard renderizado correctamente");
    
        } catch (Exception e) {
            logger.error("Error al cargar el dashboard: {}", e.getMessage(), e);
            ctx.status(500);
            ctx.result("Error al cargar el dashboard: " + e.getMessage());
        }
    }

    /**
     * Método para mostrar el formulario de creación de productos
     */
    public static void formularioNuevo(Context ctx) {
        try {
            // Verificar que el usuario es administrador
            Usuario usuario = ctx.sessionAttribute("usuario");
            if (usuario == null || !"admin".equalsIgnoreCase(usuario.getRol())) {
                logger.warn("Intento no autorizado de acceder al formulario de nuevo producto");
                ctx.redirect("/login");
                return;
            }
            
            // Crear modelo y agregar el usuario para mantener la consistencia de navegación
            Map<String, Object> modelo = new HashMap<>();
            modelo.put("usuario", usuario);
            
            // Verificar si hay un mensaje de error previo
            String error = ctx.sessionAttribute("error");
            if (error != null && !error.isEmpty()) {
                modelo.put("error", error);
                ctx.sessionAttribute("error", null);
            }
            
            ctx.render("productos/nuevo.ftl", modelo);
            logger.info("Formulario de nuevo producto mostrado para: {}", usuario.getUsername());
        } catch (Exception e) {
            logger.error("Error al mostrar formulario nuevo producto: {}", e.getMessage(), e);
            ctx.redirect("/dashboard");
        }
    }
    /**
     * Método para mostrar los detalles de un producto
     */
    public static void verDetalle(Context ctx) {
        try {
            // Obtener el ID del producto desde la URL
            int productoId = Integer.parseInt(ctx.pathParam("id"));

            // Obtener el producto de la base de datos
            Producto producto = ProductoDAO.obtenerPorId(productoId);

            // Verificar que el producto existe
            if (producto == null) {
                ctx.status(404);
                ctx.result("Producto no encontrado");
                return;
            }

            // Obtener el usuario de la sesión
            Usuario usuario = ctx.sessionAttribute("usuario");

            // Crear el modelo de datos para la plantilla
            Map<String, Object> modelo = new HashMap<>();
            modelo.put("producto", producto);
            modelo.put("usuario", usuario);

            // Renderizar la plantilla de detalle
            ctx.render("templates/productos/detalle.ftl", modelo);

        } catch (NumberFormatException e) {
            ctx.status(400);
            ctx.result("ID de producto inválido");
        } catch (Exception e) {
            e.printStackTrace();
            ctx.status(500);
            ctx.result("Error al cargar los detalles del producto: " + e.getMessage());
        }
    }
    public static void crearProducto(Context ctx) {
        try {
            String nombre = ctx.formParam("nombre");
            String descripcion = ctx.formParam("descripcion");
            double precio = Double.parseDouble(ctx.formParam("precio"));

            // Obtener existencias del formulario o usar valor por defecto
            int existencias = 10; // Valor por defecto
            try {
                String existenciasStr = ctx.formParam("existencias");
                if (existenciasStr != null && !existenciasStr.isEmpty()) {
                    existencias = Integer.parseInt(existenciasStr);
                }
            } catch (NumberFormatException e) {
                logger.warn("Error al parsear existencias, usando valor por defecto: {}", e.getMessage());
            }

            // Procesar la imagen subida
            String imagenUrl = "/img/default-product.jpg"; // Valor predeterminado

            UploadedFile uploadedFile = ctx.uploadedFile("imagen");
            if (uploadedFile != null) {
                try {
                    // Generar nombre único para la imagen
                    String nombreArchivo = System.currentTimeMillis() + "_" + uploadedFile.filename();

                    // Asegurarse de que exista el directorio
                    File uploadDir = new File("uploads/productos");
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }

                    // Guardar el archivo
                    String rutaArchivo = "uploads/productos/" + nombreArchivo;
                    FileUtil.streamToFile(uploadedFile.content(), rutaArchivo);

                    // Actualizar la URL de la imagen
                    imagenUrl = "/uploads/productos/" + nombreArchivo;
                } catch (Exception e) {
                    e.printStackTrace();
                    // En caso de error, se usará la imagen predeterminada
                }
            }

            Producto producto = new Producto();
            producto.setNombre(nombre);
            producto.setDescripcion(descripcion);
            producto.setImagenUrl(imagenUrl);
            producto.setPrecio(precio);
            producto.setExistencias(existencias);

            ProductoDAO.guardar(producto);
            ctx.redirect("/dashboard");
        } catch (Exception e) {
            e.printStackTrace();
            ctx.status(500);
            ctx.result("Error al crear el producto");
        }
    }

    /**
     * Método para mostrar el formulario de edición de un producto
     */
    public static void formularioEditar(Context ctx) {
        try {
            // Verificar que el usuario es administrador
            Usuario usuario = ctx.sessionAttribute("usuario");
            if (usuario == null || !"admin".equalsIgnoreCase(usuario.getRol())) {
                logger.warn("Intento no autorizado de editar producto");
                ctx.redirect("/login");
                return;
            }
            
            int id = Integer.parseInt(ctx.pathParam("id"));
            logger.info("Mostrando formulario de edición para producto ID: {}", id);
            
            Producto producto = ProductoDAO.obtenerPorId(id);
            if (producto != null) {
                Map<String, Object> modelo = new HashMap<>();
                modelo.put("producto", producto);
                modelo.put("usuario", usuario);
                
                // Verificar si hay un mensaje de error previo
                String error = ctx.sessionAttribute("error");
                if (error != null && !error.isEmpty()) {
                    modelo.put("error", error);
                    ctx.sessionAttribute("error", null);
                }
                
                ctx.render("productos/editar.ftl", modelo);
            } else {
                logger.warn("Producto no encontrado: ID {}", id);
                ctx.sessionAttribute("error", "Producto no encontrado");
                ctx.redirect("/dashboard");
            }
        } catch (NumberFormatException e) {
            logger.error("ID de producto inválido: {}", e.getMessage());
            ctx.sessionAttribute("error", "ID de producto inválido");
            ctx.redirect("/dashboard");
        } catch (Exception e) {
            logger.error("Error al cargar formulario de edición: {}", e.getMessage(), e);
            ctx.sessionAttribute("error", "Error al cargar el formulario de edición: " + e.getMessage());
            ctx.redirect("/dashboard");
        }
    }
    
    /**
     * Método para actualizar un producto existente
     */
    public static void editarProducto(Context ctx) {
        try {
            // Verificar que el usuario es administrador
            Usuario usuario = ctx.sessionAttribute("usuario");
            if (usuario == null || !"admin".equalsIgnoreCase(usuario.getRol())) {
                logger.warn("Intento no autorizado de actualizar producto");
                ctx.redirect("/login");
                return;
            }
            
            int id = Integer.parseInt(ctx.pathParam("id"));
            logger.info("Actualizando producto ID: {}", id);
            
            Producto producto = ProductoDAO.obtenerPorId(id);
            if (producto != null) {
                // Validar nombre (campo obligatorio)
                String nombre = ctx.formParam("nombre");
                if (nombre == null || nombre.trim().isEmpty()) {
                    logger.warn("Intento de actualizar producto sin nombre");
                    Map<String, Object> modelo = new HashMap<>();
                    modelo.put("error", "El nombre del producto es obligatorio");
                    modelo.put("producto", producto);
                    modelo.put("usuario", usuario);
                    ctx.render("productos/editar.ftl", modelo);
                    return;
                }
                
                producto.setNombre(nombre);
                producto.setDescripcion(ctx.formParam("descripcion"));
                
                // Validar y parsear precio
                try {
                    double precio = Double.parseDouble(ctx.formParam("precio"));
                    if (precio < 0) {
                        throw new NumberFormatException("El precio no puede ser negativo");
                    }
                    producto.setPrecio(precio);
                } catch (NumberFormatException e) {
                    logger.warn("Error al parsear precio para producto {}: {}", id, e.getMessage());
                    Map<String, Object> modelo = new HashMap<>();
                    modelo.put("error", "El precio debe ser un número válido mayor o igual a cero");
                    modelo.put("producto", producto);
                    modelo.put("usuario", usuario);
                    ctx.render("productos/editar.ftl", modelo);
                    return;
                }
    
                // Actualizar existencias
                try {
                    String existenciasStr = ctx.formParam("existencias");
                    if (existenciasStr != null && !existenciasStr.isEmpty()) {
                        int existencias = Integer.parseInt(existenciasStr);
                        if (existencias < 0) {
                            throw new NumberFormatException("Las existencias no pueden ser negativas");
                        }
                        producto.setExistencias(existencias);
                    }
                } catch (NumberFormatException e) {
                    logger.warn("Error al parsear existencias para el producto {}: {}", id, e.getMessage());
                    Map<String, Object> modelo = new HashMap<>();
                    modelo.put("error", "Las existencias deben ser un número entero positivo");
                    modelo.put("producto", producto);
                    modelo.put("usuario", usuario);
                    ctx.render("productos/editar.ftl", modelo);
                    return;
                }
    
                // Procesar la imagen subida solo si se proporciona una nueva
                UploadedFile uploadedFile = ctx.uploadedFile("imagen");
                if (uploadedFile != null && uploadedFile.size() > 0) {
                    try {
                        // Generar nombre único para la imagen
                        String nombreArchivo = System.currentTimeMillis() + "_" + uploadedFile.filename();
    
                        // Asegurarse de que exista el directorio
                        File uploadDir = new File("uploads/productos");
                        if (!uploadDir.exists()) {
                            uploadDir.mkdirs();
                        }
    
                        // Guardar el archivo
                        String rutaArchivo = "uploads/productos/" + nombreArchivo;
                        FileUtil.streamToFile(uploadedFile.content(), rutaArchivo);
    
                        // Eliminar imagen anterior si no es la predeterminada
                        String imagenAnterior = producto.getImagenUrl();
                        if (imagenAnterior != null && !imagenAnterior.equals("/img/default-product.jpg") &&
                            imagenAnterior.startsWith("/uploads/")) {
                            File imagenAnteriorFile = new File(imagenAnterior.substring(1)); // Eliminar la barra inicial
                            if (imagenAnteriorFile.exists()) {
                                boolean eliminada = imagenAnteriorFile.delete();
                                logger.info("Imagen anterior {}: {}", eliminada ? "eliminada" : "no se pudo eliminar", imagenAnterior);
                            }
                        }
    
                        // Actualizar la URL de la imagen
                        producto.setImagenUrl("/uploads/productos/" + nombreArchivo);
                        logger.info("Nueva imagen guardada para producto {}: {}", id, producto.getImagenUrl());
                    } catch (Exception e) {
                        logger.error("Error al procesar imagen para producto {}: {}", id, e.getMessage(), e);
                        // En caso de error, se mantiene la imagen existente
                    }
                }
    
                // Guardar los cambios
                ProductoDAO.actualizar(producto);
                logger.info("Producto actualizado correctamente: ID {}", id);
                
                // Agregar mensaje de éxito y redirigir al dashboard
                ctx.sessionAttribute("mensaje", "¡Producto actualizado exitosamente!");
                ctx.redirect("/dashboard");
            } else {
                logger.warn("Producto no encontrado para actualizar: ID {}", id);
                ctx.sessionAttribute("error", "Producto no encontrado");
                ctx.redirect("/dashboard");
            }
        } catch (NumberFormatException e) {
            logger.error("ID de producto inválido: {}", e.getMessage());
            ctx.sessionAttribute("error", "ID de producto inválido");
            ctx.redirect("/dashboard");
        } catch (Exception e) {
            logger.error("Error al actualizar producto: {}", e.getMessage(), e);
            ctx.sessionAttribute("error", "Error al actualizar el producto: " + e.getMessage());
            ctx.redirect("/dashboard");
        }
    }
    
    /**
     * Método para eliminar un producto
     */
    public static void eliminarProducto(Context ctx) {
        try {
            // Verificar que el usuario es administrador
            Usuario usuario = ctx.sessionAttribute("usuario");
            if (usuario == null || !"admin".equalsIgnoreCase(usuario.getRol())) {
                logger.warn("Intento no autorizado de eliminar producto");
                ctx.redirect("/login");
                return;
            }
            
            int id = Integer.parseInt(ctx.pathParam("id"));
            logger.info("Eliminando producto ID: {}", id);
            
            // Obtener el producto antes de eliminarlo para registrar información
            Producto producto = ProductoDAO.obtenerPorId(id);
            if (producto != null) {
                String nombreProducto = producto.getNombre();
                
                // Intentar eliminar la imagen si no es la predeterminada
                String imagenUrl = producto.getImagenUrl();
                if (imagenUrl != null && !imagenUrl.equals("/img/default-product.jpg") && 
                    imagenUrl.startsWith("/uploads/")) {
                    try {
                        File imagenFile = new File(imagenUrl.substring(1)); // Eliminar la barra inicial
                        if (imagenFile.exists()) {
                            boolean eliminada = imagenFile.delete();
                            logger.info("Imagen {}: {}", eliminada ? "eliminada" : "no se pudo eliminar", imagenUrl);
                        }
                    } catch (Exception e) {
                        logger.warn("Error al eliminar imagen del producto: {}", e.getMessage());
                    }
                }
                
                // Eliminar el producto
                ProductoDAO.eliminar(id);
                logger.info("Producto eliminado correctamente: {} (ID: {})", nombreProducto, id);
                
                // Agregar mensaje de éxito
                ctx.sessionAttribute("mensaje", "¡Producto '" + nombreProducto + "' eliminado exitosamente!");
            } else {
                logger.warn("Intento de eliminar producto inexistente ID: {}", id);
                ctx.sessionAttribute("error", "El producto que intentas eliminar no existe");
            }
            
            ctx.redirect("/dashboard");
        } catch (NumberFormatException e) {
            logger.error("ID de producto inválido: {}", e.getMessage());
            ctx.sessionAttribute("error", "ID de producto inválido");
            ctx.redirect("/dashboard");
        } catch (Exception e) {
            logger.error("Error al eliminar producto: {}", e.getMessage(), e);
            ctx.sessionAttribute("error", "Error al eliminar el producto: " + e.getMessage());
            ctx.redirect("/dashboard");
        }
    }



    public static void mostrarCatalogoSimple(Context ctx) {
    try {
        System.out.println("Iniciando carga de catálogo simple...");
        
        // Obtener el usuario de la sesión
        Usuario usuario = ctx.sessionAttribute("usuario");
        if (usuario == null) {
            System.out.println("No hay usuario en sesión para catálogo simple, redirigiendo a login");
            ctx.redirect("/login");
            return;
        }
    
        System.out.println("Usuario en sesión para catálogo: " + usuario.getUsername() + " (Rol: " + usuario.getRol() + ")");
        
        // Obtener todos los productos
        List<Producto> productos = ProductoDAO.obtenerTodos();
        System.out.println("Productos obtenidos para catálogo: " + productos.size());
        
        // Preparar el modelo
        Map<String, Object> modelo = new HashMap<>();
        modelo.put("productos", productos);
        modelo.put("usuario", usuario);
    
        // Procesar mensajes de sesión si existen
        String mensaje = ctx.sessionAttribute("mensaje");
        if (mensaje != null && !mensaje.isEmpty()) {
            System.out.println("Mensaje en sesión: " + mensaje);
            modelo.put("mensaje", mensaje);
            ctx.sessionAttribute("mensaje", null); // Limpiar mensaje
        }
    
        if (!productos.isEmpty()) {
            modelo.put("id", productos.get(0).getId()); // Ejemplo: pasa el ID del primer producto
        }
    
        System.out.println("Renderizando plantilla de catálogo simple...");
        ctx.render("catalogo_simple.ftl", modelo);
        System.out.println("Plantilla de catálogo simple renderizada correctamente");
    } catch (Exception e) {
        System.err.println("Error al cargar el catálogo: " + e.getMessage());
        e.printStackTrace();

        ctx.status(500);
        ctx.result("Error al cargar el catálogo: " + e.getMessage());
    }
}

    public static void mostrarDetalle(@NotNull Context context) {
        try {
            int id = Integer.parseInt(context.pathParam("id"));
            Producto producto = ProductoDAO.obtenerPorId(id);
            if (producto == null) {
                context.status(404);
                context.result("Producto no encontrado");
                return;
            }

            Map<String, Object> modelo = new HashMap<>();
            modelo.put("producto", producto);

            Usuario usuario = context.sessionAttribute("usuario");
            if (usuario != null) {
                modelo.put("usuario", usuario);
            }

            context.render("productos/detalle.ftl", modelo);
        } catch (NumberFormatException e) {
            context.status(400);
            context.result("ID de producto inválido");
        } catch (Exception e) {
            e.printStackTrace();
            context.status(500);
            context.result("Error al cargar el detalle del producto: " + e.getMessage());
        }
    }


    public static void listarProductos(@NotNull Context context) {
        try {
            List<Producto> productos = ProductoDAO.obtenerTodos();
            Map<String, Object> modelo = new HashMap<>();
            modelo.put("productos", productos);
            context.render("productos/lista.ftl", modelo);
        } catch (Exception e) {
            e.printStackTrace();
            context.status(500);
            context.result("Error al cargar la lista de productos: " + e.getMessage());
        }
    }

    public static void actualizarProducto(@NotNull Context context) {
        try {
            int id = Integer.parseInt(context.pathParam("id"));
            Producto producto = ProductoDAO.obtenerPorId(id);
            if (producto == null) {
                context.status(404);
                context.result("Producto no encontrado");
                return;
            }

            // Actualizar los campos del producto
            producto.setNombre(context.formParam("nombre"));
            producto.setDescripcion(context.formParam("descripcion"));
            producto.setPrecio(Double.parseDouble(context.formParam("precio")));
            producto.setExistencias(Integer.parseInt(context.formParam("existencias")));

            // Guardar los cambios
            ProductoDAO.actualizar(producto);
            context.redirect("/productos/lista");
        } catch (Exception e) {
            e.printStackTrace();
            context.status(500);
            context.result("Error al actualizar el producto: " + e.getMessage());
        }
    }

    public static void obtenerTodosProductos(@NotNull Context context) {
        try {
            List<Producto> productos = ProductoDAO.obtenerTodos();
            context.json(productos);
        } catch (Exception e) {
            e.printStackTrace();
            context.status(500);
            context.result("Error al obtener la lista de productos: " + e.getMessage());
        }

    }

    public static void obtenerProducto(@NotNull Context context) {
        try {
            int id = Integer.parseInt(context.pathParam("id"));
            Producto producto = ProductoDAO.obtenerPorId(id);
            if (producto == null) {
                context.status(404);
                context.result("Producto no encontrado");
                return;
            }
            context.json(producto);
        } catch (NumberFormatException e) {
            context.status(400);
            context.result("ID de producto inválido");
        } catch (Exception e) {
            e.printStackTrace();
            context.status(500);
            context.result("Error al obtener el producto: " + e.getMessage());
        }
    }
}