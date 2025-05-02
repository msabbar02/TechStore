package org.example;

import freemarker.cache.*;
import freemarker.template.Configuration;
import freemarker.template.TemplateExceptionHandler;
import io.javalin.Javalin;
import io.javalin.http.staticfiles.Location;
import io.javalin.rendering.template.JavalinFreemarker;
import org.example.controller.*;
import org.example.middleware.AuthMiddleware;
import org.example.model.ItemCarrito;
import org.example.model.Usuario;
import org.example.util.ErrorHandler;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Main {
    private static final Logger logger = LoggerFactory.getLogger(Main.class);

    public static void main(String[] args) {
        logger.info("Iniciando aplicación TechStore...");

        Configuration freemarkerConfig = configurarFreemarker();
        Javalin app = crearAplicacion(freemarkerConfig);

        configurarManejoErrores(app);
        configurarRutas(app);

        logger.info("Iniciando aplicación en el puerto 7000");
        app.start(7000);
        logger.info("Aplicación iniciada en el puerto 7000");
        System.out.println("Aplicación iniciada en el puerto 7000: http://localhost:7000");
    }

    private static Configuration configurarFreemarker() {
        Configuration freemarkerConfig = new Configuration(Configuration.VERSION_2_3_32);
        try {
            TemplateLoader[] loaders = new TemplateLoader[]{
                    new FileTemplateLoader(new File("src/main/resources/templates")),
                    new ClassTemplateLoader(Main.class, "/templates")
            };
            MultiTemplateLoader mtl = new MultiTemplateLoader(loaders);
            freemarkerConfig.setTemplateLoader(mtl);
            freemarkerConfig.setDefaultEncoding("UTF-8");
            freemarkerConfig.setOutputEncoding("UTF-8");
            freemarkerConfig.setTemplateExceptionHandler(TemplateExceptionHandler.HTML_DEBUG_HANDLER);
            freemarkerConfig.setLogTemplateExceptions(true);
            freemarkerConfig.setWrapUncheckedExceptions(true);
            logger.info("Freemarker configurado correctamente");
        } catch (Exception e) {
            logger.error("Error configurando Freemarker", e);
        }
        return freemarkerConfig;
    }

    private static Javalin crearAplicacion(Configuration freemarkerConfig) {
        return Javalin.create(config -> {
            config.fileRenderer(new JavalinFreemarker(freemarkerConfig));

            config.staticFiles.add(staticFiles -> {
                staticFiles.hostedPath = "/img";
                staticFiles.directory = "/templates/img";
                staticFiles.location = Location.CLASSPATH;
            });

            config.staticFiles.add(staticFiles -> {
                staticFiles.hostedPath = "/";
                staticFiles.directory = "/static";
                staticFiles.location = Location.CLASSPATH;
            });

            config.staticFiles.add(staticFiles -> {
                staticFiles.hostedPath = "/uploads";
                staticFiles.directory = "uploads";
                staticFiles.location = Location.EXTERNAL;
            });

            config.http.maxRequestSize = 10 * 1024 * 1024;
            config.http.defaultContentType = "text/html; charset=UTF-8";

            config.plugins.enableCors(cors -> {
                cors.add(corsConfig -> {
                    corsConfig.allowCredentials = true;
                    corsConfig.reflectClientOrigin = true;
                });
            });

            logger.info("Aplicación Javalin configurada correctamente");
        });
    }

    private static void configurarRutas(Javalin app) {
        configurarRutasPublicas(app);
        configurarRutasAutenticacion(app);
        configurarMiddlewareAutenticacion(app);
        configurarRutasProductos(app);
        configurarRutasUsuarios(app);
        configurarRutasCarritoYPedidos(app);
        logger.info("Rutas configuradas correctamente");
    }

    private static void configurarRutasPublicas(Javalin app) {
        app.get("/", ctx -> {
            try {
                Usuario usuario = ctx.sessionAttribute("usuario");
                if (usuario != null) {
                    if ("admin".equals(usuario.getRol())) {
                        ctx.redirect("/dashboard");
                    } else {
                        ctx.redirect("/catalogo_simple");
                    }
                    return;
                }
                Map<String, Object> modelo = new HashMap<>();
                modelo.put("timestamp", System.currentTimeMillis());
                ctx.render("index.ftl", modelo);
            } catch (Exception e) {
                logger.error("Error al mostrar la página de inicio: {}", e.getMessage(), e);
                ErrorHandler.handleException(e, ctx);
            }
        });

        app.get("/index", ctx -> ctx.redirect("/"));
        app.get("/acerca", ctx -> ctx.render("acerca.ftl"));
        app.get("/terminos", ctx -> ctx.render("terminos.ftl"));
    }

    private static void configurarRutasAutenticacion(Javalin app) {
        app.get("/login", AuthController::mostrarLogin);
        app.post("/login", AuthController::procesarLogin);
        app.get("/logout", ctx -> ctx.redirect("/"));
        app.post("/logout", AuthController::logout);
        app.get("/registro", AuthController::mostrarRegistro);
        app.post("/registro", AuthController::procesarRegistro);
    }

    private static void configurarMiddlewareAutenticacion(Javalin app) {
        app.before("/perfil", AuthMiddleware::requiereLogin);
        app.before("/perfil/*", AuthMiddleware::requiereLogin);
        app.before("/carrito", AuthMiddleware::requiereLogin);
        app.before("/carrito/*", AuthMiddleware::requiereLogin);
        app.before("/orden/*", AuthMiddleware::requiereLogin);
        app.before("/ordenes", AuthMiddleware::requiereLogin);
        app.before("/catalogo_simple", AuthMiddleware::requiereLogin);
        app.before("/dashboard", AuthMiddleware::soloAdmin);
        app.before("/dashboard/*", AuthMiddleware::soloAdmin);
        app.before("/admin/*", AuthMiddleware::soloAdmin);
    }

    private static void configurarRutasProductos(Javalin app) {
        app.get("/catalogo_simple", ProductoController::mostrarCatalogoSimple);
        app.get("/producto/{id}", ProductoController::mostrarDetalle);
        app.get("/dashboard", ProductoController::mostrarDashboard);
        app.get("/productos", ProductoController::listarProductos);
        app.get("/productos/nuevo", ProductoController::formularioNuevo);
        app.post("/productos/guardar", ProductoController::crearProducto);
        app.get("/productos/{id}/editar", ProductoController::formularioEditar);
        app.post("/productos/{id}/actualizar", ProductoController::actualizarProducto);
        app.post("/productos/{id}/eliminar", ProductoController::eliminarProducto);

        app.get("/api/productos", ProductoController::obtenerTodosProductos);
        app.get("/api/producto/{id}", ProductoController::obtenerProducto);
        app.get("/api/carrito/contador", ctx -> {
            List<ItemCarrito> carrito = ctx.sessionAttribute("carrito");
            int cantidad = 0;
            if (carrito != null) {
                for (ItemCarrito item : carrito) {
                    cantidad += item.getCantidad();
                }
            }
            ctx.json(Map.of("cantidad", cantidad));
        });
    }

    private static void configurarRutasUsuarios(Javalin app) {
        app.get("/perfil", UsuarioController::mostrarPerfil);
        app.post("/perfil/actualizar", UsuarioController::actualizarPerfil);
        app.get("/admin/usuarios", UsuarioController::listarUsuarios);
        app.get("/api/usuario/{id}", UsuarioController::obtenerUsuario);
        app.get("/admin/usuarios/{id}/editar", UsuarioController::formularioEditarUsuario);
        app.post("/admin/usuario/{id}/rol", UsuarioController::cambiarRol);
        app.post("/admin/usuario/{id}/eliminar", UsuarioController::eliminarUsuario);
        app.post("/admin/usuarios/{id}/actualizar", UsuarioController::actualizarUsuarioPorAdmin);

    }

    private static void configurarRutasCarritoYPedidos(Javalin app) {
        app.get("/carrito", CarritoController::mostrarCarrito);
        app.post("/carrito/agregar", CarritoController::agregarAlCarrito);
        app.post("/carrito/actualizar", CarritoController::actualizarCantidad);
        app.post("/carrito/eliminar", CarritoController::eliminarDelCarrito);
        app.post("/carrito/vaciar", CarritoController::vaciarCarrito);

        app.post("/orden/crear", OrdenController::crearOrden);
        app.get("/orden/{id}", OrdenController::mostrarOrden);
        app.get("/ordenes", OrdenController::listarOrdenes);
        app.get("/admin/ordenes", OrdenController::listarTodasOrdenes);
        app.post("/admin/orden/{id}/estado", OrdenController::actualizarEstadoOrden);
    }

    private static void configurarManejoErrores(Javalin app) {
        app.exception(Exception.class, (e, ctx) -> {
            logger.error("Error no controlado en ruta {}: {}", ctx.path(), e.getMessage(), e);
            try {
                ErrorHandler.handleException(e, ctx);
            } catch (Exception ex) {
                logger.error("Error secundario en manejador de errores: {}", ex.getMessage(), ex);
                ctx.status(500);
                ctx.contentType("text/html");
                ctx.result("<h1>Error del servidor</h1><p>Lo sentimos, ha ocurrido un error inesperado.</p><a href='/'>Volver al inicio</a>");
            }
        });

        app.error(404, ErrorHandler::handle404);
        app.error(401, ErrorHandler::handle401);
        app.error(403, ErrorHandler::handle403);
        app.error(500, ctx -> {
            logger.error("Error 500 en: {}", ctx.path());
            ctx.status(500);
            try {
                Map<String, Object> model = new HashMap<>();
                model.put("mensaje", "Error interno del servidor");
                model.put("error", "Ha ocurrido un error al procesar tu solicitud.");
                ctx.render("error.ftl", model);
            } catch (Exception e) {
                ctx.contentType("text/html");
                ctx.result("<h1>Error interno del servidor</h1><p>Lo sentimos, ha ocurrido un error inesperado.</p><a href='/'>Volver al inicio</a>");
            }
        });
        logger.info("Manejo de errores configurado correctamente");
    }
}