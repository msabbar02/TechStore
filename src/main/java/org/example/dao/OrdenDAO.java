package org.example.dao;

import org.example.model.DetalleOrden;
import org.example.model.ItemCarrito;
import org.example.model.Orden;
import org.example.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class OrdenDAO {
    
    public static void guardar(Orden orden) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.persist(orden);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
            throw e;
        }
    }

    public static List<Orden> obtenerOrdenesDeUsuario(Long usuarioId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery(
                "FROM Orden o WHERE o.usuario.id = :usuarioId ORDER BY o.fecha DESC", 
                Orden.class)
                .setParameter("usuarioId", usuarioId)
                .list();
        }
    }

    public static Orden obtenerPorId(Long ordenId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Orden.class, ordenId);
        }
    }

    public static void eliminar(Orden orden) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.delete(orden);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
            throw e;
        }
    }
    public static void actualizar(Orden orden) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.update(orden);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
            throw e;
        }
    }

    public static void eliminarItemCarrito(ItemCarrito item) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.delete(item);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
            throw e;
        }
    }

    public static void eliminarItemCarritoPorOrden(Orden orden) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            for (DetalleOrden item : orden.getDetalles()) {
                session.delete(item);
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
            throw e;
        }
    }


    public static void vaciarCarrito(int id) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            List<ItemCarrito> items = session.createQuery(
                "FROM ItemCarrito ic WHERE ic.usuario.id = :usuarioId",
                ItemCarrito.class)
                .setParameter("usuarioId", id)
                .list();
            for (ItemCarrito item : items) {
                session.delete(item);
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
            throw e;
        }
    }

    public static List<Orden> obtenerTodasOrdenes() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM Orden", Orden.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }
}