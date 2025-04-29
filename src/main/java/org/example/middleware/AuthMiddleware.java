package org.example.middleware;
    
import io.javalin.http.Context;
import org.example.model.Usuario;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
    
    public class AuthMiddleware {
        private static final Logger logger = LoggerFactory.getLogger(AuthMiddleware.class);
    
        // Verifica si hay sesión activa
        public static void requiereLogin(Context ctx) {
            Usuario usuario = ctx.sessionAttribute("usuario");
            if (usuario == null) {
                logger.warn("Intento de acceso a ruta protegida sin sesión: {}", ctx.path());
                ctx.sessionAttribute("redirectAfterLogin", ctx.path());
                ctx.redirect("/login");
            } else {
                logger.info("Acceso permitido a ruta protegida para: {}", usuario.getUsername());
            }
        }
    
        // Verifica si el usuario es admin
        public static void soloAdmin(Context ctx) {
            Usuario usuario = ctx.sessionAttribute("usuario");
            if (usuario == null || !"admin".equalsIgnoreCase(usuario.getRol())) {
                ctx.status(403);
                ctx.attribute("error", "No tienes permisos para acceder a esta página.");
                ctx.render("error.ftl");
            }
        }
    }