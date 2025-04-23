package org.example.util;

import org.example.model.*;
import org.hibernate.SessionFactory;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;
import org.hibernate.cfg.Configuration;
import org.hibernate.cfg.Environment;
import org.hibernate.service.ServiceRegistry;

import java.util.Properties;

/**
 * Clase utilitaria para gestionar la configuración de Hibernate y proveer acceso
 * a la SessionFactory para realizar operaciones con la base de datos.
 * Versión optimizada para mejorar rendimiento.
 */
public class HibernateUtil {
    private static final SessionFactory sessionFactory;
    
    static {
        try {
            // Configuración con mejoras de rendimiento
            Configuration configuration = new Configuration();
            
            // Propiedades optimizadas para rendimiento
            Properties properties = new Properties();
            
            // Configuración básica
            properties.put(Environment.DRIVER, "org.h2.Driver");
            properties.put(Environment.URL, "jdbc:h2:./techstoredb");
            properties.put(Environment.USER, "sa");
            properties.put(Environment.PASS, "");
            properties.put(Environment.DIALECT, "org.hibernate.dialect.H2Dialect");
            
            // Mejoras de rendimiento
            properties.put(Environment.POOL_SIZE, "10"); // Incrementar el pool de conexiones
            properties.put(Environment.STATEMENT_BATCH_SIZE, "50"); // Procesamiento por lotes
            properties.put(Environment.ORDER_INSERTS, "true");
            properties.put(Environment.ORDER_UPDATES, "true");
            properties.put(Environment.BATCH_VERSIONED_DATA, "true");
            
            // Caché de segundo nivel
            properties.put(Environment.USE_SECOND_LEVEL_CACHE, "true");
            properties.put(Environment.USE_QUERY_CACHE, "true");
            properties.put(Environment.CACHE_REGION_FACTORY, "org.hibernate.cache.jcache.JCacheRegionFactory");
            
            // Evitar operaciones innecesarias
            properties.put(Environment.AUTO_CLOSE_SESSION, "true");
            properties.put(Environment.USE_MINIMAL_PUTS, "true");
            
            // Reducir logs para mejorar rendimiento
            properties.put(Environment.SHOW_SQL, "false");
            properties.put(Environment.FORMAT_SQL, "false");
            
            configuration.setProperties(properties);
            
            // Registrar las entidades
            configuration.addAnnotatedClass(Usuario.class);
            configuration.addAnnotatedClass(Producto.class);
            configuration.addAnnotatedClass(Orden.class);
            configuration.addAnnotatedClass(DetalleOrden.class);
            configuration.addAnnotatedClass(ItemCarrito.class);
            
            ServiceRegistry serviceRegistry = new StandardServiceRegistryBuilder()
                    .applySettings(configuration.getProperties()).build();
            
            sessionFactory = configuration.buildSessionFactory(serviceRegistry);
        } catch (Throwable ex) {
            // Manejar errores en la inicialización
            System.err.println("Error al inicializar la SessionFactory: " + ex);
            throw new ExceptionInInitializerError(ex);
        }
    }
    
    /**
     * Devuelve la instancia de SessionFactory para abrir sesiones de Hibernate
     * @return SessionFactory configurada
     */
    public static SessionFactory getSessionFactory() {
        return sessionFactory;
    }
    
    /**
     * Cierra la SessionFactory para liberar recursos cuando la aplicación finaliza
     */
    public static void shutdown() {
        if (sessionFactory != null && !sessionFactory.isClosed()) {
            sessionFactory.close();
        }
    }
}