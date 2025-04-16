package org.example.controller;

import io.javalin.http.Context;
import io.javalin.http.UploadedFile;
import org.example.dao.ProductoDAO;
import org.example.model.Producto;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;

public class ProductoController {

    // Mostrar dashboard (admin)
    public static void mostrarDashboard(Context ctx) {
        List<Producto> productos = ProductoDAO.obtenerTodos();
        System.out.println("Dashboard - productos: " + productos.size());
        ctx.attribute("productos", productos);
        ctx.render("dashboard.ftl");
    }

    // Mostrar catálogo (lector)
    public static void mostrarCatalogo(Context ctx) {
        List<Producto> productos = ProductoDAO.obtenerTodos();
        System.out.println("Index - productos: " + productos.size());
        ctx.attribute("productos", productos);
        ctx.render("index.ftl");
    }

    public static void formularioNuevo(Context ctx) {
        ctx.render("producto-form.ftl");
    }

    public static void crearProducto(Context ctx) {
        Producto p = new Producto();
        p.setNombre(ctx.formParam("nombre"));
        p.setDescripcion(ctx.formParam("descripcion"));
        p.setPrecio(Double.parseDouble(ctx.formParam("precio")));
        UploadedFile uploaded = ctx.uploadedFile("imagen");
        if (uploaded != null) {
            String nombreArchivo = System.currentTimeMillis() + "-" + uploaded.filename();
            Path destino = Paths.get("uploads", nombreArchivo);

            try (InputStream input = uploaded.content()) {
                Files.copy(input, destino, StandardCopyOption.REPLACE_EXISTING);
                p.setImagenUrl("/uploads/" + nombreArchivo);
            } catch (IOException e) {
                e.printStackTrace();
                ctx.status(500).result("Error al subir la imagen");
                return;
            }
        }

        ProductoDAO.guardar(p);
        ctx.redirect("/dashboard");
    }

    public static void formularioEditar(Context ctx) {
        int id = Integer.parseInt(ctx.pathParam("id"));
        Producto producto = ProductoDAO.buscarPorId(id);
        ctx.attribute("producto", producto);
        ctx.render("producto-form.ftl");
    }

    public static void editarProducto(Context ctx) {
        int id = Integer.parseInt(ctx.pathParam("id"));
        Producto producto = ProductoDAO.buscarPorId(id);

        producto.setNombre(ctx.formParam("nombre"));
        producto.setDescripcion(ctx.formParam("descripcion"));
        producto.setPrecio(Double.parseDouble(ctx.formParam("precio")));
        producto.setImagenUrl(ctx.formParam("imagenUrl"));

        ProductoDAO.actualizar(producto);
        ctx.redirect("/dashboard");
    }

    public static void eliminarProducto(Context ctx) {
        int id = Integer.parseInt(ctx.pathParam("id"));
        ProductoDAO.eliminar(id);
        ctx.redirect("/dashboard");
    }

    public static void comprarProducto(Context ctx) {
        int id = Integer.parseInt(ctx.pathParam("id"));
        Producto producto = ProductoDAO.buscarPorId(id);
        ctx.attribute("producto", producto);
        ctx.render("detalle-producto.ftl");
    }

    public static void añadirAlCarrito(Context ctx) {
        int id = Integer.parseInt(ctx.pathParam("id"));
        Producto producto = ProductoDAO.buscarPorId(id);

        List<Producto> carrito = ctx.sessionAttribute("carrito");
        if (carrito == null) {
            carrito = new ArrayList<>();
        }

        carrito.add(producto);
        ctx.sessionAttribute("carrito", carrito);
        ctx.redirect("/carrito");
    }

    public static void verCarrito(Context ctx) {
        List<Producto> carrito = ctx.sessionAttribute("carrito");
        if (carrito == null) {
            carrito = new ArrayList<>();
        }
        ctx.attribute("carrito", carrito);
        ctx.render("carrito.ftl");
    }
}
