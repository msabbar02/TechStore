package org.example.controller;

import io.javalin.http.Context;
import org.example.dao.OrdenDAO;
import org.example.model.Orden;
import org.example.model.Producto;
import org.example.model.Usuario;
import org.jetbrains.annotations.NotNull;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class OrdenController {
    private static final Logger logger = LoggerFactory.getLogger(OrdenController.class);

    // En OrdenController.java
    // En OrdenController.java
    public static void listarOrdenes(Context ctx) {
        try {
            Usuario usuario = ctx.sessionAttribute("usuario");
            if (usuario == null) {
                ctx.redirect("/login");
                return;
            }

            List<Orden> ordenes = OrdenDAO.obtenerOrdenesDeUsuario((long) usuario.getId());

            Map<String, Object> modelo = new HashMap<>();
            modelo.put("ordenes", ordenes);
            modelo.put("usuario", usuario);

            // Cambiar a una plantilla específica de órdenes
            ctx.render("/ordenes.ftl", modelo);

        } catch (Exception e) {
            logger.error("Error al cargar las órdenes: {}", e.getMessage());
            ctx.status(500);
            ctx.result("Error al cargar las órdenes");
        }
    }

    public static void verDetalle(Context ctx) {
        try {
            Usuario usuario = ctx.sessionAttribute("usuario");
            if (usuario == null) {
                ctx.redirect("/login");
                return;
            }

            Long ordenId = Long.parseLong(ctx.pathParam("id"));
            Orden orden = OrdenDAO.obtenerPorId(ordenId);
            
            if (orden == null || orden.getUsuario().getId() != usuario.getId()) {
                ctx.status(404);
                ctx.result("Orden no encontrada");
                return;
            }

            Map<String, Object> modelo = new HashMap<>();
            modelo.put("orden", orden);
            modelo.put("usuario", usuario);
            
            ctx.render("templates/productos/detalle.ftl", modelo);
        } catch (Exception e) {
            e.printStackTrace();
            ctx.status(500);
            ctx.result("Error al cargar el detalle de la orden");
        }
    }

    public static void crearOrden(@NotNull Context context) {
        try {
            Usuario usuario = context.sessionAttribute("usuario");
            if (usuario == null) {
                context.redirect("/login");
                return;
            }

            Orden orden = new Orden();
            orden.setUsuario(usuario);
            orden.setEstado("PENDIENTE");
            orden.setTotal(0.0);

            OrdenDAO.guardar(orden);

            context.redirect("/ordenes");
        } catch (Exception e) {
            e.printStackTrace();
            context.status(500);
            context.result("Error al crear la orden");
        }
    }

    public static void mostrarOrden(@NotNull Context context) {
        try {
            Long ordenId = Long.parseLong(context.pathParam("id"));
            Orden orden = OrdenDAO.obtenerPorId(ordenId);
            if (orden == null) {
                context.status(404);
                context.result("Orden no encontrada");
                return;
            }

            Map<String, Object> modelo = new HashMap<>();
            modelo.put("orden", orden);
            context.render("ordenes/detalle.ftl", modelo);
        } catch (Exception e) {
            e.printStackTrace();
            context.status(500);
            context.result("Error al cargar la orden");
        }
    }

    public static void listarTodasOrdenes(@NotNull Context context) {
        try {
            List<Orden> ordenes = OrdenDAO.obtenerTodasOrdenes();
            Map<String, Object> modelo = new HashMap<>();
            modelo.put("ordenes", ordenes);
            context.render("/ordenes.ftl", modelo);
        } catch (Exception e) {
            e.printStackTrace();
            context.status(500);
            context.result("Error al cargar las órdenes");
        }
    }

    public static void actualizarEstadoOrden(Context ctx) {
        Long idOrden = Long.parseLong(ctx.pathParam("id"));
        String nuevoEstado = ctx.formParam("estado");

        Orden orden = OrdenDAO.obtenerPorId(idOrden);
        if (orden != null) {
            orden.setEstado(nuevoEstado.toUpperCase());
            OrdenDAO.actualizar(orden);
        }

        ctx.redirect("/dashboard#pedidosSection");
    }

}