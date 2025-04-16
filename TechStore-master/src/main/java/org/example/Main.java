package org.example;

import io.javalin.Javalin;
import io.javalin.rendering.template.JavalinFreemarker;
import freemarker.template.Configuration;
import org.example.controller.AuthController;
import org.example.controller.ProductoController;
import org.example.middleware.AuthMiddleware;
import org.example.util.HibernateUtil;

public class Main {
    public static void main(String[] args) {

        // Hibernate
        HibernateUtil.getSessionFactory();

        // Configuración manual de FreeMarker
        Configuration freemarkerConfig = new Configuration(Configuration.VERSION_2_3_32);
        freemarkerConfig.setClassForTemplateLoading(Main.class, "/templates");

        // Iniciar Javalin
        Javalin app = Javalin.create(config -> {
            config.fileRenderer(new JavalinFreemarker(freemarkerConfig));
            config.staticFiles.add(staticFiles -> {
                staticFiles.hostedPath = "/css";
                staticFiles.directory = "/static";
                staticFiles.location = io.javalin.http.staticfiles.Location.CLASSPATH;
            });
        }).start(7000);

        // Rutas
        app.get("/", ctx -> ctx.redirect("/login"));

        app.get("/login", AuthController::mostrarLogin);
        app.post("/login", AuthController::procesarLogin);
        app.get("/register", AuthController::mostrarRegistro);
        app.post("/register", AuthController::procesarRegistro);
        app.get("/logout", AuthController::logout);

        app.before("/dashboard", AuthMiddleware::requiereLogin);
        app.before("/productos/*", AuthMiddleware::requiereLogin);
        app.before("/index", AuthMiddleware::requiereLogin);
        app.before("/perfil", AuthMiddleware::requiereLogin);

        app.before("/dashboard", AuthMiddleware::soloAdmin);
        app.before("/productos/nuevo", AuthMiddleware::soloAdmin);
        app.before("/productos/{id}/editar", AuthMiddleware::soloAdmin);
        app.before("/productos/{id}/eliminar", AuthMiddleware::soloAdmin);

        app.get("/dashboard", ProductoController::mostrarDashboard);
        app.get("/productos/nuevo", ProductoController::formularioNuevo);
        app.post("/productos/nuevo", ProductoController::crearProducto);
        app.get("/productos/{id}/editar", ProductoController::formularioEditar);
        app.post("/productos/{id}/editar", ProductoController::editarProducto);
        app.post("/productos/{id}/eliminar", ProductoController::eliminarProducto);

        app.get("/index", ProductoController::mostrarCatalogo);
        app.get("/comprar/{id}", ProductoController::comprarProducto);
        app.get("/carrito", ProductoController::verCarrito);
        app.post("/carrito/{id}/añadir", ProductoController::añadirAlCarrito);

        app.get("/perfil", AuthController::verPerfil);
        app.post("/perfil", AuthController::modificarPerfil);
    }
}
