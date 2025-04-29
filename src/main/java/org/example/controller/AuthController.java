package org.example.controller;

import io.javalin.http.Context;
import io.javalin.http.UploadedFile;
import org.example.dao.UsuarioDAO;
import org.example.model.Usuario;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.HashMap;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class AuthController {

    // Mostrar login
    private static final Logger logger = LoggerFactory.getLogger(AuthController.class);

    // Mostrar login
        public static void mostrarLogin(Context ctx) {
            try {
                logger.info("Mostrando página de login");
                // Renderizamos directamente la plantilla sin modelo
                ctx.render("login.ftl", new HashMap<>());
            } catch (Exception e) {
                logger.error("Error al mostrar login: {}", e.getMessage(), e);
                // Respuesta simple HTML para evitar errores en cascada
                ctx.status(500);
                ctx.contentType("text/html");
                ctx.result("<h1>Error al cargar la página</h1><p>Por favor, intente nuevamente más tarde</p><a href='/'>Volver al inicio</a>");
            }
        }
    
    // Procesar login
        public static void procesarLogin(Context ctx) {
            String username = ctx.formParam("username");
            String password = ctx.formParam("password");
    
            // Validación básica de datos de entrada
            if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
                Map<String, Object> model = new HashMap<>();
                model.put("error", "Nombre de usuario y contraseña son requeridos");
                try {
                    ctx.render("login.ftl", model);
                } catch (Exception e) {
                    logger.error("Error al renderizar login con error: {}", e.getMessage());
                    ctx.status(400);
                    ctx.contentType("text/html");
                    ctx.result("<h1>Error de validación</h1><p>Nombre de usuario y contraseña son requeridos</p><a href='/login'>Volver al login</a>");
                }
                return;
            }
    
            try {
                logger.info("Intentando login para usuario: {}", username);
                
                // Primero intentar con el método normal de búsqueda
                Usuario usuario = UsuarioDAO.buscarPorUsernameYPassword(username, password);
                
                // Si no funciona y es admin, intentar con loginDirecto
                if (usuario == null && "admin".equalsIgnoreCase(username)) {
                    logger.info("Intentando login directo para admin");
                    usuario = UsuarioDAO.loginDirecto(username, password);
                }
        
                if (usuario != null) {
                    // Iniciar sesión
                    ctx.sessionAttribute("usuario", usuario);
                    logger.info("Login exitoso para: {} (Rol: {})", usuario.getUsername(), usuario.getRol());
                
                    // Redireccionar según el rol del usuario
                    if ("admin".equals(usuario.getRol())) {
                        ctx.redirect("/dashboard");
                    } else {
                        // Usuarios regulares van al catálogo
                        ctx.redirect("/catalogo_simple");
                    }
                } else {
                    logger.warn("Intento de login fallido para usuario: {}", username);
                    Map<String, Object> model = new HashMap<>();
                    model.put("error", "Credenciales inválidas");
                    try {
                        ctx.render("login.ftl", model);
                    } catch (Exception e) {
                        logger.error("Error al renderizar login con error: {}", e.getMessage());
                        ctx.status(401);
                        ctx.contentType("text/html");
                        ctx.result("<h1>Error de autenticación</h1><p>Credenciales inválidas</p><a href='/login'>Volver al login</a>");
                    }
                }
            } catch (Exception e) {
                logger.error("Error al procesar login: {}", e.getMessage(), e);
                try {
                    Map<String, Object> model = new HashMap<>();
                    model.put("error", "Error del sistema al procesar login");
                    ctx.render("login.ftl", model);
                } catch (Exception renderEx) {
                    ctx.status(500);
                    ctx.contentType("text/html");
                    ctx.result("<h1>Error al procesar el login</h1><p>Por favor, intente nuevamente más tarde</p><a href='/'>Volver al inicio</a>");
                }
        }
    }


    // Mostrar formulario de registro
    public static void mostrarRegistro(Context ctx) {
        ctx.render("register.ftl");
    }

    // Procesar registro
    public static void procesarRegistro(Context ctx) {
        Usuario usuario = new Usuario();

        String nombre = ctx.formParam("nombre");
        String apellido = ctx.formParam("apellido");
        String direccion = ctx.formParam("direccion");
        String rol = ctx.formParam("rol"); // Valor por defecto: lector
        String username = ctx.formParam("username");
        String password = ctx.formParam("password");

        usuario.setNombre(nombre);
        usuario.setApellido(apellido);
        usuario.setDireccion(direccion);
        usuario.setUsername(username);
        usuario.setPassword(password);
        usuario.setRol("lector");

        // Manejar imagen
        UploadedFile uploaded = ctx.uploadedFile("fotoPerfil");
        if (uploaded != null) {
            String nombreArchivo = System.currentTimeMillis() + "-" + uploaded.filename();
            Path destino = Paths.get("uploads", nombreArchivo);
            try (InputStream input = uploaded.content()) {
                Files.copy(input, destino, StandardCopyOption.REPLACE_EXISTING);
                usuario.setFotoPerfil("/uploads/" + nombreArchivo);
            } catch (IOException e) {
                e.printStackTrace();
                ctx.status(500).result("Error al subir foto de perfil");
                return;
            }
        }

        if (UsuarioDAO.buscarPorUsername(username) != null) {
            ctx.attribute("error", "El nombre de usuario ya existe.");
            ctx.render("register.ftl");
            return;
        }

        UsuarioDAO.guardar(usuario);
        ctx.redirect("/login");
    }


    // Cerrar sesión
    public static void logout(Context ctx) {
        ctx.req().getSession().invalidate();
        ctx.redirect("/login");
    }

    // Ver perfil
    public static void verPerfil(Context ctx) {
        Usuario usuario = ctx.sessionAttribute("usuario");
        ctx.attribute("usuario", usuario);
        ctx.render("usuario/perfil.ftl");
    }

    // Modificar perfil
    public static void modificarPerfil(Context ctx) {
        Usuario usuario = ctx.sessionAttribute("usuario");

        usuario.setNombre(ctx.formParam("nombre"));
        usuario.setApellido(ctx.formParam("apellido"));
        usuario.setDireccion(ctx.formParam("direccion"));

        // Subida de nueva foto de perfil (opcional)
        UploadedFile uploaded = ctx.uploadedFile("fotoPerfil");
        if (uploaded != null) {
            String nombreArchivo = System.currentTimeMillis() + "-" + uploaded.filename();
            Path destino = Paths.get("uploads", nombreArchivo);
            try (InputStream input = uploaded.content()) {
                Files.copy(input, destino, StandardCopyOption.REPLACE_EXISTING);
                usuario.setFotoPerfil("/uploads/" + nombreArchivo);
            } catch (IOException e) {
                e.printStackTrace();
                ctx.status(500).result("Error al subir nueva foto de perfil");
                return;
            }
        }

        UsuarioDAO.actualizar(usuario);
        ctx.redirect("usuario/perfil");
    }

}