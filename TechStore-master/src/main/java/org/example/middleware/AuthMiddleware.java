package org.example.middleware;

import io.javalin.http.Context;
import org.example.model.Usuario;

public class AuthMiddleware {

    // Verifica si hay sesión activa
    public static void requiereLogin(Context ctx) {
        Usuario usuario = ctx.sessionAttribute("usuario");
        if (usuario == null) {
            ctx.redirect("/login");
        }
    }

    // Verifica si el usuario es admin
    public static void soloAdmin(Context ctx) {
        Usuario usuario = ctx.sessionAttribute("usuario");
        if (usuario == null || !"admin".equals(usuario.getRol())) {
            ctx.status(403).attribute("error", "No tienes permisos para acceder a esta página.");
            ctx.render("error.ftl");

        }
    }
}
