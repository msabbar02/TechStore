package org.example.dao;

import org.example.model.Producto;
import org.example.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ProductoDAO {

    public static void guardar(Producto producto) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Transaction tx = session.beginTransaction();
            session.persist(producto);
            tx.commit();
        }
    }

    public static void actualizar(Producto producto) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Transaction tx = session.beginTransaction();
            session.merge(producto);
            tx.commit();
        }
    }

    public static void eliminar(int id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Transaction tx = session.beginTransaction();
            Producto producto = session.get(Producto.class, id);
            if (producto != null) {
                session.remove(producto);
            }
            tx.commit();
        }
    }

    public static Producto buscarPorId(int id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Producto.class, id);
        }
    }

    public static List<Producto> obtenerTodos() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            List<Producto> productos = session.createQuery("from Producto", Producto.class).list();
            System.out.println("Productos obtenidos como lista: " + productos.size());
            return productos;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }



    public static List<Producto> obtenerConFiltros(String nombre, String precioMin, String precioMax) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "from Producto p where 1=1";
            if (nombre != null && !nombre.isEmpty()) {
                hql += " and lower(p.nombre) like :nombre";
            }
            if (precioMin != null && !precioMin.isEmpty()) {
                hql += " and p.precio >= :precioMin";
            }
            if (precioMax != null && !precioMax.isEmpty()) {
                hql += " and p.precio <= :precioMax";
            }

            var query = session.createQuery(hql, Producto.class);
            if (nombre != null && !nombre.isEmpty()) {
                query.setParameter("nombre", "%" + nombre.toLowerCase() + "%");
            }
            if (precioMin != null && !precioMin.isEmpty()) {
                query.setParameter("precioMin", Double.parseDouble(precioMin));
            }
            if (precioMax != null && !precioMax.isEmpty()) {
                query.setParameter("precioMax", Double.parseDouble(precioMax));
            }

            List<Producto> productos = query.list();
            System.out.println("Productos obtenidos con filtros: " + productos);
            return productos;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

}
