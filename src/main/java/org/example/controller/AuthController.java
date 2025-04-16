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

public class AuthController {

    // Mostrar login
    public static void mostrarLogin(Context ctx) {
        ctx.render("login.ftl");
    }

    // Procesar login
    public static void procesarLogin(Context ctx) {
        String username = ctx.formParam("username");
        String password = ctx.formParam("password");

        System.out.println("Intentando login con: " + username + " / " + password);

        Usuario usuario = UsuarioDAO.buscarPorUsernameYPassword(username, password);

        if (usuario != null) {
            ctx.sessionAttribute("usuario", usuario);

            System.out.println("Login correcto. Rol detectado: " + usuario.getRol());

            if ("admin".equalsIgnoreCase(usuario.getRol())) {
                System.out.println("Redirigiendo a /dashboard");
                ctx.redirect("/dashboard");
            } else if ("lector".equalsIgnoreCase(usuario.getRol())) {
                System.out.println("Redirigiendo a /index");
                ctx.redirect("/index");
            } else {
                System.out.println("Rol desconocido: " + usuario.getRol());
                ctx.attribute("error", "Rol no válido");
                ctx.render("login.ftl");
            }

        } else {
            System.out.println("Login fallido: usuario no encontrado");
            ctx.attribute("error", "Usuario o contraseña incorrectos");
            ctx.render("login.ftl");
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
        ctx.render("perfil.ftl");
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
        ctx.redirect("/perfil");
    }

}
