package org.example.dao;

import org.example.model.Usuario;
import org.example.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

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
            return session.createQuery("FROM Usuario WHERE username = :u AND password = :p", Usuario.class)
                    .setParameter("u", username)
                    .setParameter("p", password)
                    .uniqueResult();
        }
    }

    public static Usuario buscarPorUsername(String username) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM Usuario WHERE username = :u", Usuario.class)
                    .setParameter("u", username)
                    .uniqueResult();
        }
    }

    public static void actualizar(Usuario usuario) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Transaction tx = session.beginTransaction();
            session.merge(usuario);
            tx.commit();
        }
    }
}
