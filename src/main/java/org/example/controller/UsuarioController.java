package org.example.controller;

import io.javalin.http.Context;
import io.javalin.http.UploadedFile;
import org.example.dao.UsuarioDAO;
import org.example.model.Usuario;
import org.example.util.FileUtil;
import org.example.util.PasswordUtil;

import java.io.File;
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
            // Obtener el usuario fresco desde la base de datos para evitar problemas de entidades desconectadas
            Usuario usuarioActual = UsuarioDAO.obtenerPorId(usuarioSesion.getId());
            if (usuarioActual == null) {
                logger.error("No se encontró el usuario en la base de datos: {}", usuarioSesion.getId());
                ctx.sessionAttribute("error", "Error al actualizar el perfil: Usuario no encontrado");
                ctx.redirect("/perfil");
                return;
            }
            
            logger.info("Actualizando perfil para usuario: {} (ID: {})", usuarioActual.getUsername(), usuarioActual.getId());
            
            // Obtener datos del formulario
            String nombre = ctx.formParam("nombre");
            String apellido = ctx.formParam("apellido");
            String direccion = ctx.formParam("direccion");
            String newPassword = ctx.formParam("newPassword");
            
            // Actualizar campos básicos
            if (nombre != null && !nombre.trim().isEmpty()) {
                usuarioActual.setNombre(nombre.trim());
                logger.info("Nombre actualizado: {}", nombre.trim());
            }
            
            if (apellido != null && !apellido.trim().isEmpty()) {
                usuarioActual.setApellido(apellido.trim());
                logger.info("Apellido actualizado: {}", apellido.trim());
            }
            
            if (direccion != null) { // Permitir dirección vacía
                usuarioActual.setDireccion(direccion.trim());
                logger.info("Dirección actualizada: {}", direccion.trim());
            }
            
            if (newPassword != null && !newPassword.trim().isEmpty()) {
                String hashedPassword = PasswordUtil.hashPassword(newPassword);
                System.out.println("Nueva contraseña hasheada: " + hashedPassword);
                usuarioActual.setPassword(hashedPassword);
                logger.info("Contraseña actualizada para usuario: {}", usuarioActual.getUsername());
            }
            
            // Procesar la foto de perfil
            UploadedFile uploadedFile = ctx.uploadedFile("fotoPerfil");
            if (uploadedFile != null && uploadedFile.size() > 0) {
                try {
                    // Validar tamaño máximo (2MB)
                    if (uploadedFile.size() > 2 * 1024 * 1024) {
                        throw new IllegalArgumentException("La imagen no debe superar los 2MB");
                    }
                    
                    // Validar tipo de archivo
                    String contentType = uploadedFile.contentType();
                    if (contentType == null || !(
                        contentType.equals("image/jpeg") || 
                        contentType.equals("image/png") || 
                        contentType.equals("image/gif"))) {
                        throw new IllegalArgumentException("Formato de imagen no válido. Use JPG, PNG o GIF");
                    }
                    
                    // Generar nombre único para la imagen
                    String nombreOriginal = uploadedFile.filename();
                    String extension = nombreOriginal.substring(nombreOriginal.lastIndexOf("."));
                    String nombreArchivo = System.currentTimeMillis() + "_" + usuarioActual.getUsername() + extension;
                    
                    // Asegurarse de que exista el directorio
                    File uploadDir = new File("src/main/resources/static/img");
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }
                    
                    // Guardar el archivo
                    String rutaArchivo = "src/main/resources/static/img/" + nombreArchivo;
                    FileUtil.streamToFile(uploadedFile.content(), rutaArchivo);
                    
                    // Eliminar foto anterior si existe y no es la predeterminada
                    String fotoAnterior = usuarioActual.getFotoPerfil();
                    if (fotoAnterior != null && !fotoAnterior.contains("default-avatar")) {
                        String rutaAnterior = fotoAnterior.replace("/img/", "src/main/resources/static/img/");
                        File fileAnterior = new File(rutaAnterior);
                        if (fileAnterior.exists()) {
                            fileAnterior.delete();
                        }
                    }
                    
                    // Actualizar la URL de la foto de perfil
                    usuarioActual.setFotoPerfil("/img/" + nombreArchivo);
                    logger.info("Foto de perfil actualizada para usuario: {}", usuarioActual.getUsername());
                } catch (Exception e) {
                    logger.error("Error al guardar la foto de perfil: ", e);
                    // Continuamos con el resto de la actualización sin establecer un mensaje de error
                }
            }
    
            // Guardar cambios
            try {
                logger.info("Guardando cambios en la base de datos para usuario ID: {}", usuarioActual.getId());
                UsuarioDAO.actualizar(usuarioActual);
                logger.info("Perfil actualizado correctamente en la base de datos para: {}", usuarioActual.getUsername());
            } catch (Exception e) {
                logger.error("Error al guardar en la base de datos: {}", e.getMessage(), e);
                throw new RuntimeException("Error al guardar los cambios en la base de datos", e);
            }
    
            // Actualizar la sesión con los datos nuevos
            ctx.sessionAttribute("usuario", usuarioActual);
            
            // Mensaje de éxito
            ctx.sessionAttribute("mensaje", "¡Perfil actualizado correctamente!");
            
            // Redirigir a la página correspondiente según el rol del usuario
            if ("admin".equalsIgnoreCase(usuarioActual.getRol())) {
                ctx.redirect("/dashboard");
            } else {
                ctx.redirect("/catalogo_simple");  // Redirección corregida
            }
            
        } catch (Exception e) {
            logger.error("Error al actualizar perfil: {}", e.getMessage(), e);
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