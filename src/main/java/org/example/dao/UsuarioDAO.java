package org.example.dao;

import org.example.model.Usuario;
import org.example.util.HibernateUtil;
import org.example.util.PasswordUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO {

    public static void guardar(Usuario usuario) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Transaction tx = session.beginTransaction();
            session.persist(usuario);
            tx.commit();
        }
    }

    public static Usuario buscarPorUsernameYPassword(String username, String password) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Usuario usuario = session.createQuery("FROM Usuario WHERE username = :u", Usuario.class)
                    .setParameter("u", username)
                    .uniqueResult();
            
            if (usuario != null) {
                System.out.println("Usuario encontrado: " + usuario.getUsername());
                System.out.println("Rol del usuario: " + usuario.getRol());
                
                String storedPassword = usuario.getPassword();
                // Primero intentar comparación directa (para contraseñas sin hash)
                if (password.equals(storedPassword)) {
                    System.out.println("Autenticación exitosa mediante comparación directa");
                    return usuario;
                }
                
                // Si hay formato de hash, intentar verificar
                boolean formatoValido = storedPassword != null && storedPassword.contains(":");
                if (formatoValido) {
                    boolean verificado = PasswordUtil.verificarPassword(password, storedPassword);
                    System.out.println("Resultado de verificación de contraseña hasheada: " + verificado);
                    
                    if (verificado) {
                        System.out.println("Autenticación exitosa mediante verificación hash");
                        return usuario;
                    }
                }
                
                System.out.println("Contraseña incorrecta para usuario: " + username);
            } else {
                System.out.println("No se encontró usuario con username: " + username);
            }
            return null;
        } catch (Exception e) {
            System.err.println("Error al buscar usuario por username y password: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    public static Usuario buscarPorUsername(String username) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM Usuario WHERE username = :u", Usuario.class)
                    .setParameter("u", username)
                    .uniqueResult();
        }
    }
    
    /**
     * Método para login directo con usuario admin (para recuperación)
     * Esto es temporal hasta solucionar los problemas de hash
     */
    public static Usuario loginDirecto(String username, String password) {
        if (!"admin".equalsIgnoreCase(username)) {
            return null; // Solo permitir admin para recuperación
        }
        
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Usuario usuario = session.createQuery("FROM Usuario WHERE username = :u", Usuario.class)
                    .setParameter("u", username)
                    .uniqueResult();
                    
            if (usuario != null) {
                // Actualizar a contraseña hasheada para futuros logins
                Transaction tx = session.beginTransaction();
                String newHashedPassword = PasswordUtil.hashPassword(password);
                System.out.println("Actualizando contraseña admin a hash: " + newHashedPassword);
                usuario.setPassword(newHashedPassword);
                session.merge(usuario);
                tx.commit();
                
                return usuario;
            }
            return null;
        } catch (Exception e) {
            System.err.println("Error en loginDirecto: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    public static void actualizar(Usuario usuario) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.merge(usuario);
            session.flush(); // Forzar la sincronización con la base de datos
            tx.commit();
            System.out.println("Usuario actualizado correctamente: " + usuario.getId() + " - " + usuario.getUsername());
        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            System.err.println("Error al actualizar usuario: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error al actualizar usuario", e);
        }
    }

    public static Usuario obtenerPorId(int id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Usuario.class, id);
        }
    }
    public static void eliminar(int id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Transaction tx = session.beginTransaction();
            try {
                Usuario usuario = session.get(Usuario.class, id);
                if (usuario != null) {
                    session.remove(usuario); // <-- aquí elimina en la BD
                }
                tx.commit();
            } catch (Exception e) {
                if (tx != null && tx.isActive()) {
                    tx.rollback();
                }
                throw new RuntimeException("Error al eliminar usuario", e);
            }
        }
    }



    public static List<Usuario> obtenerTodos() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM Usuario", Usuario.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }



}
