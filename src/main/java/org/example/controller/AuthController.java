package org.example.controller;

import io.javalin.http.Context;
import org.example.dao.UsuarioDAO;
import org.example.model.Usuario;

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
        String nombre = ctx.formParam("nombre");
        String apellido = ctx.formParam("apellido");
        String direccion = ctx.formParam("direccion");
        String username = ctx.formParam("username");
        String password = ctx.formParam("password");
        String fotoPerfil = ctx.formParam("fotoPerfil");

        if (UsuarioDAO.buscarPorUsername(username) != null) {
            ctx.attribute("error", "El nombre de usuario ya existe.");
            ctx.render("register.ftl");
            return;
        }

        Usuario nuevo = new Usuario();
        nuevo.setNombre(nombre);
        nuevo.setApellido(apellido);
        nuevo.setDireccion(direccion);
        nuevo.setUsername(username);
        nuevo.setPassword(password);
        nuevo.setFotoPerfil(fotoPerfil);
        nuevo.setRol("lector"); // siempre lector al registrarse

        UsuarioDAO.guardar(nuevo);
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
        usuario.setFotoPerfil(ctx.formParam("fotoPerfil"));

        UsuarioDAO.actualizar(usuario);
        ctx.redirect("/perfil");
    }
}
