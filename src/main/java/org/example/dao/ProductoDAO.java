

package org.example.dao;

import org.example.model.Producto;
import org.example.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * DAO optimizado para acceso a productos con cacheo
 */
public class ProductoDAO {
    private static final Logger logger = LoggerFactory.getLogger(ProductoDAO.class);
    
    // Caché para productos populares
    private static final Map<Integer, Producto> PRODUCTOS_CACHE = new ConcurrentHashMap<>(100);
    private static final Map<Integer, Long> CACHE_TIMESTAMP = new ConcurrentHashMap<>(100);
    private static final long CACHE_EXPIRY = 120000; // 2 minutos
    
    // Caché para listados de productos
    private static List<Producto> ALL_PRODUCTOS_CACHE = null;
    private static long ALL_PRODUCTOS_TIMESTAMP = 0;
    
    /**
     * Guardar un nuevo producto
     */
    public static void guardar(Producto producto) {
        long startTime = System.currentTimeMillis();
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Transaction tx = session.beginTransaction();
            session.persist(producto);
            tx.commit();
            
            // Invalidar caché de listado
            ALL_PRODUCTOS_CACHE = null;
            
            long endTime = System.currentTimeMillis();
            logger.debug("Producto guardado en {}ms", (endTime - startTime));
        } catch (Exception e) {
            logger.error("Error al guardar producto: {}", e.getMessage());
            throw e;
        }
    }
    
    /**
     * Actualizar un producto existente
     */
    public static void actualizar(Producto producto) {
        long startTime = System.currentTimeMillis();
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Transaction tx = session.beginTransaction();
            session.merge(producto);
            tx.commit();
            
            // Actualizar caché
            PRODUCTOS_CACHE.put(producto.getId(), producto);
            CACHE_TIMESTAMP.put(producto.getId(), System.currentTimeMillis());
            
            // Invalidar caché de listado
            ALL_PRODUCTOS_CACHE = null;
            
            long endTime = System.currentTimeMillis();
            logger.debug("Producto actualizado en {}ms", (endTime - startTime));
        } catch (Exception e) {
            logger.error("Error al actualizar producto: {}", e.getMessage());
            throw e;
        }
    }
    
    /**
     * Obtener un producto por ID (con caché)
     */
    public static Producto obtenerPorId(int id) {
        // Verificar si está en caché y si es válido
        Producto cached = PRODUCTOS_CACHE.get(id);
        Long timestamp = CACHE_TIMESTAMP.get(id);
        
        if (cached != null && timestamp != null && 
            System.currentTimeMillis() - timestamp < CACHE_EXPIRY) {
            logger.debug("Producto {} obtenido desde caché", id);
            return cached;
        }
        
        // Si no está en caché o expiró
        long startTime = System.currentTimeMillis();
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Producto producto = session.get(Producto.class, id);
            
            // Almacenar en caché si existe
            if (producto != null) {
                PRODUCTOS_CACHE.put(id, producto);
                CACHE_TIMESTAMP.put(id, System.currentTimeMillis());
            }
            
            long endTime = System.currentTimeMillis();
            logger.debug("Producto {} obtenido desde DB en {}ms", id, (endTime - startTime));
            
            return producto;
        } catch (Exception e) {
            logger.error("Error al obtener producto por ID {}: {}", id, e.getMessage());
            return null;
        }
    }
    
    /**
     * Eliminar un producto por ID
     */
    public static void eliminar(int id) {
        long startTime = System.currentTimeMillis();
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Transaction tx = session.beginTransaction();
            Producto producto = session.get(Producto.class, id);
            if (producto != null) {
                session.remove(producto);
            }
            tx.commit();
            
            // Eliminar de caché
            PRODUCTOS_CACHE.remove(id);
            CACHE_TIMESTAMP.remove(id);
            
            // Invalidar caché de listado
            ALL_PRODUCTOS_CACHE = null;
            
            long endTime = System.currentTimeMillis();
            logger.debug("Producto {} eliminado en {}ms", id, (endTime - startTime));
        } catch (Exception e) {
            logger.error("Error al eliminar producto {}: {}", id, e.getMessage());
            throw e;
        }
    }
    
    /**
     * Obtener todos los productos de forma optimizada
     */
    public static List<Producto> obtenerTodos() {
        // Verificar si el listado está en caché y es válido
        if (ALL_PRODUCTOS_CACHE != null && 
            System.currentTimeMillis() - ALL_PRODUCTOS_TIMESTAMP < CACHE_EXPIRY) {
            logger.debug("Lista de productos obtenida desde caché");
            return new ArrayList<>(ALL_PRODUCTOS_CACHE);
        }
        
        long startTime = System.currentTimeMillis();
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            // Usar consultas optimizadas y activar caché
            Query<Producto> query = session.createQuery("FROM Producto ORDER BY nombre", Producto.class);
            query.setCacheable(true);
            query.setHint("org.hibernate.cacheable", true);
            
            List<Producto> productos = query.list();
            
            // Guardar en caché
            ALL_PRODUCTOS_CACHE = new ArrayList<>(productos);
            ALL_PRODUCTOS_TIMESTAMP = System.currentTimeMillis();
            
            // Precarga individual de productos en caché
            for (Producto producto : productos) {
                PRODUCTOS_CACHE.put(producto.getId(), producto);
                CACHE_TIMESTAMP.put(producto.getId(), System.currentTimeMillis());
            }
            
            long endTime = System.currentTimeMillis();
            logger.debug("Lista de {} productos obtenida desde DB en {}ms", 
                    productos.size(), (endTime - startTime));
            
            return productos;
        } catch (Exception e) {
            logger.error("Error al obtener todos los productos: {}", e.getMessage());
            return new ArrayList<>();
        }
    }
    
    /**
     * Buscar productos por nombre o descripción
     */
    public static List<Producto> buscar(String termino) {
        if (termino == null || termino.trim().isEmpty()) {
            return obtenerTodos();
        }
        
        long startTime = System.currentTimeMillis();
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String searchTerm = "%" + termino.toLowerCase() + "%";
            
            Query<Producto> query = session.createQuery(
                "FROM Producto WHERE LOWER(nombre) LIKE :termino OR LOWER(descripcion) LIKE :termino", 
                Producto.class
            );
            query.setParameter("termino", searchTerm);
            query.setCacheable(true);
            
            List<Producto> resultados = query.list();
            
            long endTime = System.currentTimeMillis();
            logger.debug("Búsqueda '{}' completada en {}ms, {} resultados", 
                    termino, (endTime - startTime), resultados.size());
            
            return resultados;
        } catch (Exception e) {
            logger.error("Error en búsqueda de productos con término '{}': {}", 
                    termino, e.getMessage());
            return new ArrayList<>();
        }
    }
    
    /**
     * Obtener productos por categoría
     */
    public static List<Producto> obtenerPorCategoria(String categoria) {
        if (categoria == null || categoria.trim().isEmpty()) {
            return obtenerTodos();
        }
        
        long startTime = System.currentTimeMillis();
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Producto> query = session.createQuery(
                "FROM Producto WHERE categoria = :categoria", 
                Producto.class
            );
            query.setParameter("categoria", categoria);
            query.setCacheable(true);
            
            List<Producto> resultados = query.list();
            
            long endTime = System.currentTimeMillis();
            logger.debug("Listado para categoría '{}' completado en {}ms, {} resultados", 
                    categoria, (endTime - startTime), resultados.size());
            
            return resultados;
        } catch (Exception e) {
            logger.error("Error al obtener productos por categoría '{}': {}", 
                    categoria, e.getMessage());
            return new ArrayList<>();
        }
    }
    
    /**
     * Precarga todos los productos en caché
     * Útil para inicialización
     */
    public static void precargarCache() {
        obtenerTodos();
    }
    
    /**
     * Invalidar caché completa (útil después de operaciones masivas)
     */
    public static void invalidarCache() {
        PRODUCTOS_CACHE.clear();
        CACHE_TIMESTAMP.clear();
        ALL_PRODUCTOS_CACHE = null;
        logger.info("Caché de productos invalidada");
    }
}

   