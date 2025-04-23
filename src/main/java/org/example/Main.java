package org.example;

import freemarker.cache.*;
import freemarker.template.Configuration;
import freemarker.template.TemplateExceptionHandler;
import io.javalin.Javalin;
import io.javalin.http.Context;
import io.javalin.http.staticfiles.Location;
import io.javalin.rendering.template.JavalinFreemarker;
import org.example.controller.*;
import org.example.middleware.AuthMiddleware;
import org.example.model.Usuario;
import org.example.util.ErrorHandler;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

/**
 * Clase principal que inicializa la aplicación web TechStore
 */
public class Main {
    private static final Logger logger = LoggerFactory.getLogger(Main.class);

    public static void main(String[] args) {
        logger.info("Iniciando aplicación TechStore...");
        
        // Configurar Freemarker para renderizado de plantillas
        Configuration freemarkerConfig = configurarFreemarker();
        
        // Crear y configurar la aplicación Javalin
        Javalin app = crearAplicacion(freemarkerConfig);
        
        // Configurar manejo de errores
        configurarManejoErrores(app);
        
        // Configurar todas las rutas
        configurarRutas(app);
        
        // Iniciar la aplicación
        logger.info("Iniciando aplicación en el puerto 7000");
        app.start(7000);
        logger.info("Aplicación iniciada en el puerto 7000");
    }
    
    /**
     * Configura Freemarker para el renderizado de plantillas
     */
    private static Configuration configurarFreemarker() {
        Configuration freemarkerConfig = new Configuration(Configuration.VERSION_2_3_32);
        try {
            // Configurar múltiples ubicaciones para buscar templates
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
    
    /**
     * Crea y configura la aplicación Javalin
     */
    private static Javalin crearAplicacion(Configuration freemarkerConfig) {
        return Javalin.create(config -> {
            // Configurar renderizador de plantillas
            config.fileRenderer(new JavalinFreemarker(freemarkerConfig));
            
            // Servir archivos estáticos desde classpath
            config.staticFiles.add(staticFiles -> {
                staticFiles.hostedPath = "/";
                staticFiles.directory = "/static";
                staticFiles.location = Location.CLASSPATH;
                staticFiles.precompress = false; // Deshabilitar precompresión
            });
            
            // Servir archivos subidos desde sistema de archivos
            config.staticFiles.add(staticFiles -> {
                staticFiles.hostedPath = "/uploads";
                staticFiles.directory = "uploads";
                staticFiles.location = Location.EXTERNAL;
            });
            
            // Configurar límites de tamaño para subida de archivos
            config.http.maxRequestSize = 10 * 1024 * 1024; // 10 MB 
            config.http.defaultContentType = "text/html; charset=UTF-8";
            
            // Configurar CORS
            config.plugins.enableCors(cors -> {
                cors.add(corsConfig -> {
                    corsConfig.allowCredentials = true;
                    corsConfig.reflectClientOrigin = true;
                });
            });
            
            logger.info("Aplicación Javalin configurada correctamente");
        });
    }
    
    /**
     * Configura todas las rutas de la aplicación
     */
    private static void configurarRutas(Javalin app) {
        // Rutas públicas (accesibles sin iniciar sesión)
        configurarRutasPublicas(app);
        
        // Rutas de autenticación
        configurarRutasAutenticacion(app);
        
        // Configurar middleware de autenticación
        configurarMiddlewareAutenticacion(app);
        
        // Rutas de productos
        configurarRutasProductos(app);
        
        // Rutas de usuario y perfil
        configurarRutasUsuarios(app);
        
        // Rutas de carrito y pedidos
        configurarRutasCarritoYPedidos(app);
        
        logger.info("Rutas configuradas correctamente");
    }
    
    /**
     * Configura las rutas públicas de la aplicación
     */
    private static void configurarRutasPublicas(Javalin app) {
        // Página de inicio
        app.get("/", ctx -> {
            try {
                logger.info("Mostrando página de inicio");
                
                // Comprobar si hay un usuario en sesión
                Usuario usuario = ctx.sessionAttribute("usuario");
                
                if (usuario != null) {
                    // Si el usuario está logueado, redirigir según rol
                    if ("admin".equals(usuario.getRol())) {
                        ctx.redirect("/dashboard");
                    } else {
                        ctx.redirect("/catalogo_simple");
                    }
                    return;
                }
                
                // Mostrar página de inicio para visitantes
                Map<String, Object> modelo = new HashMap<>();
                modelo.put("timestamp", System.currentTimeMillis());
                ctx.render("index.ftl", modelo);
                
            } catch (Exception e) {
                logger.error("Error al mostrar la página de inicio: {}", e.getMessage(), e);
                ErrorHandler.handleException(e, ctx);
            }
        });
        
        // Alias para la página de inicio
        app.get("/index", ctx -> ctx.redirect("/"));
        
        // Página de información
        app.get("/acerca", ctx -> {
            try {
                ctx.render("acerca.ftl");
            } catch (Exception e) {
                logger.error("Error al mostrar página de información: {}", e.getMessage(), e);
                ErrorHandler.handleException(e, ctx);
            }
        });
        
        // Términos y condiciones
        app.get("/terminos", ctx -> {
            try {
                ctx.render("terminos.ftl");
            } catch (Exception e) {
                logger.error("Error al mostrar términos: {}", e.getMessage(), e);
                ErrorHandler.handleException(e, ctx);
            }
        });
    }
    
    /**
     * Configura las rutas de autenticación
     */
    private static void configurarRutasAutenticacion(Javalin app) {
        // Login
        app.get("/login", AuthController::mostrarLogin);
        app.post("/login", AuthController::procesarLogin);
        
        // Registro
        app.get("/registro", AuthController::mostrarRegistro);
        app.post("/registro", AuthController::procesarRegistro);
        
        // Logout
        app.post("/logout", AuthController::logout);
        app.get("/logout", ctx -> {
            ctx.req().getSession().invalidate();
            ctx.redirect("/");
        });
    }
    
    /**
     * Configura el middleware de autenticación
     */
    private static void configurarMiddlewareAutenticacion(Javalin app) {
        // Proteger rutas que requieren autenticación
        app.before("/perfil", AuthMiddleware::requiereLogin);
        app.before("/perfil/*", AuthMiddleware::requiereLogin);
        app.before("/carrito", AuthMiddleware::requiereLogin);
        app.before("/carrito/*", AuthMiddleware::requiereLogin);
        app.before("/orden/*", AuthMiddleware::requiereLogin);
        app.before("/ordenes", AuthMiddleware::requiereLogin);
        app.before("/catalogo_simple", AuthMiddleware::requiereLogin);
        
        // Proteger rutas que requieren rol de administrador
        app.before("/dashboard", AuthMiddleware::soloAdmin);
        app.before("/dashboard/*", AuthMiddleware::soloAdmin);
        app.before("/admin/*", AuthMiddleware::soloAdmin);
    }
    
    /**
     * Configura las rutas relacionadas con productos
     */
    private static void configurarRutasProductos(Javalin app) {
        // Rutas para usuarios normales
        app.get("/catalogo_simple", ProductoController::mostrarCatalogoSimple);
        app.get("/producto/{id}", ProductoController::mostrarDetalle);

        // Rutas para administradores
        app.get("/dashboard", ProductoController::mostrarDashboard);
        app.get("/admin/productos", ProductoController::listarProductos);
        app.get("/admin/producto/nuevo", ProductoController::formularioNuevo);
        app.post("/admin/producto/crear", ProductoController::crearProducto);
        app.get("/admin/producto/{id}/editar", ProductoController::formularioEditar);
        app.post("/admin/producto/{id}/actualizar", ProductoController::actualizarProducto);
        app.post("/admin/producto/{id}/eliminar", ProductoController::eliminarProducto);

        // API de productos
        app.get("/api/productos", ProductoController::obtenerTodosProductos);
        app.get("/api/producto/{id}", ProductoController::obtenerProducto);
    }
    
    /**
     * Configura las rutas relacionadas con usuarios y perfiles
     */
    private static void configurarRutasUsuarios(Javalin app) {
        // Perfil de usuario
        app.get("/perfil", UsuarioController::mostrarPerfil);
        app.post("/perfil/actualizar", UsuarioController::actualizarPerfil);
        
        // Administración de usuarios (solo admin)
        app.get("/admin/usuarios", UsuarioController::listarUsuarios);
        app.get("/api/usuario/{id}", UsuarioController::obtenerUsuario);
        app.post("/api/usuario/¨{id}/rol", UsuarioController::cambiarRol);
    }
    
    /**
     * Configura las rutas relacionadas con el carrito y pedidos
     */
    private static void configurarRutasCarritoYPedidos(Javalin app) {
        // Carrito
        app.get("/carrito", CarritoController::mostrarCarrito);
        app.post("/carrito/agregar", CarritoController::agregarAlCarrito);
        app.post("/carrito/actualizar", CarritoController::actualizarCantidad);
        app.post("/carrito/eliminar", CarritoController::eliminarDelCarrito);
        app.post("/carrito/vaciar", CarritoController::vaciarCarrito);
        
        // Órdenes/Pedidos
        app.post("/orden/crear", OrdenController::crearOrden);
        app.get("/orden/{id}", OrdenController::mostrarOrden);
        app.get("/ordenes", OrdenController::listarOrdenes);
        
        // Gestión de órdenes (admin)
        app.get("/admin/ordenes", OrdenController::listarTodasOrdenes);
        app.post("/admin/orden/{id}/estado", OrdenController::actualizarEstadoOrden);
    }
    
    /**
     * Configura el manejo de errores de la aplicación
     */
    private static void configurarManejoErrores(Javalin app) {
        // Manejador general de excepciones
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
        
        // Manejadores para errores HTTP específicos
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