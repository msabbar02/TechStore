package org.example.controller;

import io.javalin.http.Context;
import org.example.dao.ProductoDAO;
import org.example.model.Producto;
import org.example.model.Usuario;

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

    public static void mostrarDashboard(Context ctx) {
        try {
            // Obtener el usuario de la sesión
            Usuario usuario = ctx.sessionAttribute("usuario");

            // Verificar que el usuario está autenticado
            if (usuario == null) {
                ctx.redirect("/login");
                return;
            }

            // Obtener la lista de productos
            List<Producto> productos = ProductoDAO.obtenerTodos();

            // Crear el modelo de datos para la plantilla
            Map<String, Object> modelo = new HashMap<>();
            modelo.put("productos", productos);
            modelo.put("usuario", usuario);

            // Renderizar la plantilla del dashboard
            ctx.render("dashboard.ftl", modelo);

        } catch (Exception e) {
            e.printStackTrace();
            ctx.status(500);
            ctx.result("Error al cargar el dashboard: " + e.getMessage());
        }
    }



    public static void formularioNuevo(Context ctx) {
        ctx.render("productos/nuevo.ftl");
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

    public static void formularioEditar(Context ctx) {
        try {
            int id = Integer.parseInt(ctx.pathParam("id"));
            Producto producto = ProductoDAO.obtenerPorId(id);
            if (producto != null) {
                Map<String, Object> modelo = new HashMap<>();
                modelo.put("producto", producto);
                ctx.render("productos/editar.ftl", modelo);
            } else {
                ctx.status(404);
                ctx.result("Producto no encontrado");
            }
        } catch (Exception e) {
            e.printStackTrace();
            ctx.status(500);
            ctx.result("Error al cargar el formulario de edición");
        }
    }

    public static void editarProducto(Context ctx) {
        try {
            int id = Integer.parseInt(ctx.pathParam("id"));
            Producto producto = ProductoDAO.obtenerPorId(id);
            if (producto != null) {
                producto.setNombre(ctx.formParam("nombre"));
                producto.setDescripcion(ctx.formParam("descripcion"));
                producto.setPrecio(Double.parseDouble(ctx.formParam("precio")));

                // Actualizar existencias
                try {
                    String existenciasStr = ctx.formParam("existencias");
                    if (existenciasStr != null && !existenciasStr.isEmpty()) {
                        producto.setExistencias(Integer.parseInt(existenciasStr));
                    }
                } catch (NumberFormatException e) {
                    logger.warn("Error al parsear existencias para el producto {}: {}", id, e.getMessage());
                }

                // Procesar la imagen subida solo si se proporciona una nueva
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

                        // Eliminar imagen anterior si no es la predeterminada
                        String imagenAnterior = producto.getImagenUrl();
                        if (imagenAnterior != null && !imagenAnterior.equals("/img/default-product.jpg") &&
                            imagenAnterior.startsWith("/uploads/")) {
                            File imagenAnteriorFile = new File(imagenAnterior.substring(1)); // Eliminar la barra inicial
                            if (imagenAnteriorFile.exists()) {
                                imagenAnteriorFile.delete();
                            }
                        }

                        // Actualizar la URL de la imagen
                        producto.setImagenUrl("/uploads/productos/" + nombreArchivo);
                    } catch (Exception e) {
                        e.printStackTrace();
                        // En caso de error, se mantiene la imagen existente
                    }
                }

                ProductoDAO.actualizar(producto);
                ctx.redirect("/dashboard");
            } else {
                ctx.status(404);
                ctx.result("Producto no encontrado");
            }
        } catch (Exception e) {
            e.printStackTrace();
            ctx.status(500);
            ctx.result("Error al actualizar el producto");
        }
    }

    public static void eliminarProducto(Context ctx) {
        try {
            int id = Integer.parseInt(ctx.pathParam("id"));
            ProductoDAO.eliminar(id);
            ctx.redirect("/dashboard");
        } catch (Exception e) {
            e.printStackTrace();
            ctx.status(500);
            ctx.result("Error al eliminar el producto");
        }
    }



    public static void mostrarCatalogoSimple(Context ctx) {
    try {
        List<Producto> productos = ProductoDAO.obtenerTodos();
        Map<String, Object> modelo = new HashMap<>();
        modelo.put("productos", productos);

        Usuario usuario = ctx.sessionAttribute("usuario");
        if (usuario != null) {
            modelo.put("usuario", usuario);
            System.out.println("Usuario en sesión: " + usuario.getUsername());
        } else {
            System.out.println("No hay usuario en sesión");
        }

        String mensaje = ctx.sessionAttribute("mensaje");
        if (mensaje != null && !mensaje.isEmpty()) {
            modelo.put("mensaje", mensaje);
            ctx.sessionAttribute("mensaje", null);
        }

        if (!productos.isEmpty()) {
            modelo.put("id", productos.get(0).getId()); // Ejemplo: pasa el ID del primer producto
        }

        ctx.render("catalogo_simple.ftl", modelo);
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