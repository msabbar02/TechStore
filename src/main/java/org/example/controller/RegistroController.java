package org.example.controller;

import io.javalin.http.Context;
import org.example.dao.UsuarioDAO;
import org.example.model.Usuario;
import org.example.util.PasswordUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.HashMap;
import java.util.Map;

/**
 * Controlador para manejar el registro de nuevos usuarios
 */
public class RegistroController {
    
    private static final Logger logger = LoggerFactory.getLogger(RegistroController.class);
    
    /**
     * Muestra el formulario de registro
     */
    public static void mostrarFormulario(Context ctx) {
        ctx.render("register.ftl");
    }
    
    /**
     * Procesa el registro de un nuevo usuario
     */
    public static void procesarRegistro(Context ctx) {
        try {
            // Obtener los datos del formulario
            String nombre = ctx.formParam("nombre");
            String apellido = ctx.formParam("apellido");
            String username = ctx.formParam("username");
            String password = ctx.formParam("password");
            String confirmPassword = ctx.formParam("confirmPassword");
            String direccion = ctx.formParam("direccion");
            
            // Validar que todos los campos requeridos estén presentes
            if (nombre == null || apellido == null || username == null || 
                password == null || confirmPassword == null) {
                
                Map<String, Object> modelo = new HashMap<>();
                modelo.put("error", "Todos los campos son obligatorios");
                ctx.render("register.ftl", modelo);
                return;
            }
            
            // Validar que las contraseñas coincidan
            if (!password.equals(confirmPassword)) {
                Map<String, Object> modelo = new HashMap<>();
                modelo.put("error", "Las contraseñas no coinciden");
                ctx.render("register.ftl", modelo);
                return;
            }
            
            // Verificar si el username ya existe
            if (UsuarioDAO.buscarPorUsername(username) != null) {
                Map<String, Object> modelo = new HashMap<>();
                modelo.put("error", "El nombre de usuario ya está en uso");
                ctx.render("register.ftl", modelo);
                return;
            }
            
            // Crear el nuevo usuario
            Usuario nuevoUsuario = new Usuario();
            nuevoUsuario.setNombre(nombre);
            nuevoUsuario.setApellido(apellido);
            nuevoUsuario.setUsername(username);
            nuevoUsuario.setDireccion(direccion);
            
            // Hashear la contraseña antes de guardarla
            String hashedPassword = PasswordUtil.hashPassword(password);
            nuevoUsuario.setPassword(hashedPassword);
            
            // Asignar rol "lector" por defecto
            nuevoUsuario.setRol("lector");
            
            // Asignar avatar por defecto
            nuevoUsuario.setFotoPerfil("/img/default-avatar.png");
            
            // Guardar el usuario en la base de datos
            UsuarioDAO.guardar(nuevoUsuario);
            
            logger.info("Nuevo usuario registrado: " + username);
            
            // Redirigir a la página de login con mensaje de éxito
            ctx.redirect("/login?registroExitoso=true");
            
        } catch (Exception e) {
            logger.error("Error en el registro de usuario: " + e.getMessage(), e);
            
            Map<String, Object> modelo = new HashMap<>();
            modelo.put("error", "Error al registrar el usuario: " + e.getMessage());
            ctx.render("register.ftl", modelo);
        }
    }
}
