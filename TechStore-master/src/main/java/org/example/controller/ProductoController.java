package org.example.controller;

import io.javalin.http.Context;
import org.example.dao.ProductoDAO;
import org.example.model.Producto;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class ProductoController {

    // Mostrar dashboard para admin
   public static void mostrarDashboard(Context ctx) {
       try {
           Map<Integer, Producto> productos = ProductoDAO.obtenerTodos();
           System.out.println("Productos enviados al dashboard: " + productos);
           ctx.attribute("productos", productos);
           ctx.render("dashboard.ftl");
       } catch (Exception e) {
           e.printStackTrace();
           ctx.status(500).result("Error al cargar el dashboard");
       }
   }

    // Mostrar formulario nuevo producto
    public static void formularioNuevo(Context ctx) {
        ctx.render("producto-form.ftl");
    }

    // Crear producto
    public static void crearProducto(Context ctx) {
        Producto p = new Producto();
        p.setNombre(ctx.formParam("nombre"));
        p.setDescripcion(ctx.formParam("descripcion"));
        p.setPrecio(Double.parseDouble(ctx.formParam("precio")));
        p.setImagenUrl(ctx.formParam("imagenUrl"));

        ProductoDAO.guardar(p);
        ctx.redirect("/dashboard");
    }

    // Mostrar formulario de edición
    public static void formularioEditar(Context ctx) {
        int id = Integer.parseInt(ctx.pathParam("id"));
        Producto producto = ProductoDAO.buscarPorId(id);
        ctx.attribute("producto", producto);
        ctx.render("producto-form.ftl");
    }

    // Editar producto
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

    // Eliminar producto
    public static void eliminarProducto(Context ctx) {
        int id = Integer.parseInt(ctx.pathParam("id"));
        ProductoDAO.eliminar(id);
        ctx.redirect("/dashboard");
    }

    // Mostrar catálogo al usuario lector
   public static void mostrarCatalogo(Context ctx) {
       String nombre = ctx.queryParam("nombre");
       String precioMin = ctx.queryParam("precioMin");
       String precioMax = ctx.queryParam("precioMax");

       List<Producto> productos = ProductoDAO.obtenerConFiltros(nombre, precioMin, precioMax);
       ctx.attribute("productos", productos);
       ctx.render("index.ftl");
   }

    // Ver detalle del producto (comprar)
    public static void comprarProducto(Context ctx) {
        int id = Integer.parseInt(ctx.pathParam("id"));
        Producto producto = ProductoDAO.buscarPorId(id);
        ctx.attribute("producto", producto);
        ctx.render("detalle-producto.ftl");
    }

    // Añadir al carrito (guardado en sesión)
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

    // Ver carrito
    public static void verCarrito(Context ctx) {
        List<Producto> carrito = ctx.sessionAttribute("carrito");
        if (carrito == null) {
            carrito = new ArrayList<>();
        }
        ctx.attribute("carrito", carrito);
        ctx.render("carrito.ftl");
    }
}
