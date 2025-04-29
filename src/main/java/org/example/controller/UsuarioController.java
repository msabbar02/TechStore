package org.example.controller;

import io.javalin.http.Context;
import io.javalin.http.UploadedFile;
import org.example.dao.UsuarioDAO;
import org.example.model.Usuario;
import org.example.util.FileUtil;
import org.example.util.PasswordUtil;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class UsuarioController {

    private static final Logger logger = LoggerFactory.getLogger(UsuarioController.class);
    
    // Caché de sesiones para reducir consultas a la base de datos
    private static final Map<Integer, Usuario> CACHE_USUARIOS = new ConcurrentHashMap<>(50);
    public static final long CACHE_TIMEOUT_MS = 300000; // 5 minutos
    public static final Map<Integer, Long> CACHE_TIMESTAMPS = new ConcurrentHashMap<>(50);

    /**
     * Muestra el perfil del usuario actual
     */
    public static void mostrarPerfil(Context ctx) {
        Usuario usuario = ctx.sessionAttribute("usuario");
        if (usuario == null) {
            logger.warn("Intento de acceder al perfil sin sesión");
            ctx.redirect("/login");
            return;
        }
        
        logger.info("Mostrando perfil para usuario: {}", usuario.getUsername());
        
        // Sólo incluir mensajes si existen y tienen contenido
        Map<String, Object> model = new HashMap<>();
        model.put("usuario", usuario);
        
        String mensaje = ctx.sessionAttribute("mensaje");
        if (mensaje != null && !mensaje.isEmpty()) {
            model.put("mensaje", mensaje);
            ctx.sessionAttribute("mensaje", null); // Limpiar mensaje después de usarlo
        }
        
        String error = ctx.sessionAttribute("error");
        if (error != null && !error.isEmpty()) {
            model.put("error", error);
            ctx.sessionAttribute("error", null); // Limpiar error después de usarlo
        }
        
        ctx.render("perfil.ftl", model);
    }

    public static void actualizarPerfil(Context ctx) {
        Usuario usuarioSesion = ctx.sessionAttribute("usuario");

        if (usuarioSesion == null) {
            logger.warn("Intento de actualizar perfil sin sesión");
            ctx.redirect("/login");
            return;
        }

        try {
            Usuario usuarioActual = UsuarioDAO.obtenerPorId(usuarioSesion.getId());
            if (usuarioActual == null) {
                ctx.sessionAttribute("error", "Usuario no encontrado");
                ctx.redirect("/perfil");
                return;
            }

            // Actualizar campos básicos
            usuarioActual.setNombre(ctx.formParam("nombre"));
            usuarioActual.setApellido(ctx.formParam("apellido"));
            usuarioActual.setDireccion(ctx.formParam("direccion"));

            // Manejar nueva contraseña si se proporciona
            String newPassword = ctx.formParam("newPassword");
            if (newPassword != null && !newPassword.trim().isEmpty()) {
                usuarioActual.setPassword(PasswordUtil.hashPassword(newPassword));
            }

            // Procesar la foto de perfil
            UploadedFile foto = ctx.uploadedFile("fotoPerfil");
            if (foto != null && foto.size() > 0) {
                String nombreArchivo = System.currentTimeMillis() + "_" +
                        usuarioActual.getUsername() + "_" +
                        foto.filename();
                String rutaGuardado = "uploads/usuarios/" + nombreArchivo;

                // Asegurar que el directorio existe
                new File("uploads/usuarios").mkdirs();

                // Guardar el archivo
                try (InputStream input = foto.content();
                     FileOutputStream output = new FileOutputStream(rutaGuardado)) {
                    input.transferTo(output);
                }

                // Actualizar la URL de la foto en el usuario
                usuarioActual.setFotoPerfil("/uploads/usuarios/" + nombreArchivo);
            }

            // Guardar cambios
            UsuarioDAO.actualizar(usuarioActual);

            // Actualizar la sesión con el usuario actualizado
            ctx.sessionAttribute("usuario", usuarioActual);

            // Agregar mensaje de éxito
            ctx.sessionAttribute("mensaje", "Perfil actualizado correctamente");

            // Redireccionar según el rol
            if ("admin".equalsIgnoreCase(usuarioActual.getRol())) {
                ctx.redirect("/dashboard");
            } else {
                ctx.redirect("/catalogo_simple");
            }

        } catch (Exception e) {
            logger.error("Error al actualizar perfil: {}", e.getMessage());
            ctx.sessionAttribute("error", "Error al actualizar el perfil: " + e.getMessage());
            ctx.redirect("/perfil");
        }
    }

    public static void obtenerUsuario(Context ctx) {
        try {
            String idStr = ctx.pathParam("id");
            int id = Integer.parseInt(idStr);
            
            Usuario usuario = UsuarioDAO.obtenerPorId(id);
            
            if (usuario != null) {
                Map<String, Object> usuarioSeguro = new HashMap<>();
                usuarioSeguro.put("id", usuario.getId());
                usuarioSeguro.put("nombre", usuario.getNombre());
                usuarioSeguro.put("apellido", usuario.getApellido());
                usuarioSeguro.put("direccion", usuario.getDireccion());
                usuarioSeguro.put("username", usuario.getUsername());
                usuarioSeguro.put("fotoPerfil", usuario.getFotoPerfil());
                
                ctx.json(usuarioSeguro);
            } else {
                ctx.status(404).json(Map.of("error", "Usuario no encontrado"));
            }
        } catch (NumberFormatException e) {
            ctx.status(400).json(Map.of("error", "ID de usuario no válido"));
        } catch (Exception e) {
            ctx.status(500).json(Map.of("error", "Error al obtener el usuario"));
        }
    }

    public static void cambiarRol(Context ctx) {
        Usuario adminUsuario = ctx.sessionAttribute("usuario");
        if (adminUsuario == null || !"admin".equalsIgnoreCase(adminUsuario.getRol())) {
            ctx.status(403).json(Map.of("error", "No autorizado"));
            return;
        }

        try {
            int userId = Integer.parseInt(ctx.pathParam("id"));
            String nuevoRol = ctx.formParam("rol");

            if (nuevoRol == null || (!nuevoRol.equalsIgnoreCase("user") && !nuevoRol.equalsIgnoreCase("admin"))) {
                ctx.status(400).json(Map.of("error", "Rol no válido"));
                return;
            }

            Usuario usuario = UsuarioDAO.obtenerPorId(userId);
            if (usuario == null) {
                ctx.status(404).json(Map.of("error", "Usuario no encontrado"));
                return;
            }

            usuario.setRol(nuevoRol);
            UsuarioDAO.actualizar(usuario);
            
            ctx.json(Map.of("success", true, "message", "Rol actualizado correctamente"));
        } catch (NumberFormatException e) {
            ctx.status(400).json(Map.of("error", "ID de usuario no válido"));
        } catch (Exception e) {
            ctx.status(500).json(Map.of("error", "Error al cambiar el rol"));
        }
    }

    public static void listarUsuarios(Context ctx) {
        Usuario adminUsuario = ctx.sessionAttribute("usuario");
        if (adminUsuario == null || !"admin".equalsIgnoreCase(adminUsuario.getRol())) {
            ctx.redirect("/login");
            return;
        }

        try {
            var usuarios = UsuarioDAO.obtenerTodos();
            ctx.attribute("usuarios", usuarios);
            ctx.render("usuarios.ftl");
        } catch (Exception e) {
            ctx.attribute("error", "Error al obtener la lista de usuarios");
            ctx.redirect("/dashboard");
        }
    }
}