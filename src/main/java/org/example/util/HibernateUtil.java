package org.example.util;

import org.example.model.*;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;
import org.hibernate.cfg.Environment;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;
import java.util.stream.Collectors;

public class HibernateUtil {
    private static final Logger logger = LoggerFactory.getLogger(HibernateUtil.class);
    private static final SessionFactory sessionFactory;

    static {
        try {
            logger.info("Inicializando Hibernate con configuración programática");
            
            // Crear configuración programática en lugar de usar XML
            Configuration configuration = new Configuration();

            // Configurar propiedades de Hibernate
            Properties settings = new Properties();
            settings.put(Environment.DRIVER, "com.mysql.cj.jdbc.Driver");
            settings.put(Environment.URL, "jdbc:mysql://localhost:3306/techstore?serverTimezone=UTC");
            settings.put(Environment.USER, "root");
            settings.put(Environment.PASS, "root");
            settings.put(Environment.DIALECT, "org.hibernate.dialect.MySQLDialect");

            // Otras configuraciones
            settings.put(Environment.SHOW_SQL, "true");
            settings.put(Environment.FORMAT_SQL, "true");
            settings.put(Environment.HBM2DDL_AUTO, "update");
            settings.put(Environment.ENABLE_LAZY_LOAD_NO_TRANS, "true");
            
            // Configuraciones de caché
            settings.put(Environment.USE_SECOND_LEVEL_CACHE, "false");
            settings.put(Environment.USE_QUERY_CACHE, "false");
            
            configuration.setProperties(settings);
            
            // Mapear las entidades
            configuration.addAnnotatedClass(Usuario.class);
            configuration.addAnnotatedClass(Producto.class);
            configuration.addAnnotatedClass(Orden.class);
            configuration.addAnnotatedClass(DetalleOrden.class);
            configuration.addAnnotatedClass(ItemCarrito.class);

            sessionFactory = configuration.buildSessionFactory();
            
            // Cargar datos iniciales si no existen
            cargarDatosIniciales();
            
            logger.info("SessionFactory inicializada correctamente");
        } catch (Throwable ex) {
            logger.error("Error al inicializar la SessionFactory: {}", ex.getMessage());
            ex.printStackTrace();
            throw new ExceptionInInitializerError(ex);
        }
    }

    private static void cargarDatosIniciales() {
        try (Session session = sessionFactory.openSession()) {
            // Verificar si ya hay usuarios en la base de datos
            Long cantidadUsuarios = session.createQuery("SELECT COUNT(u) FROM Usuario u", Long.class).uniqueResult();
            
            if (cantidadUsuarios == 0) {
                logger.info("No se encontraron usuarios, creando usuarios iniciales manualmente");
                
                Transaction tx = session.beginTransaction();
                
                // Crear usuario admin
                Usuario admin = new Usuario();
                admin.setNombre("Admin");
                admin.setApellido("Sistema");
                admin.setDireccion("Dirección Administrativa");
                admin.setUsername("admin");
                admin.setPassword("admin"); // Contraseña simple sin hash
                admin.setRol("admin");
                admin.setFotoPerfil("/img/default-avatar.png");
                session.persist(admin);
                
                // Crear usuario lector
                Usuario lector = new Usuario();
                lector.setNombre("Usuario");
                lector.setApellido("Regular");
                lector.setDireccion("Dirección Usuario");
                lector.setUsername("lector");
                lector.setPassword("lector"); // Contraseña simple sin hash
                lector.setRol("lector");
                lector.setFotoPerfil("/img/default-avatar.png");
                session.persist(lector);
                
                // Crear productos de ejemplo
                Producto p1 = new Producto();
                p1.setNombre("Smartphone Galaxy S23");
                p1.setDescripcion("Smartphone con 8GB RAM, 128GB almacenamiento");
                p1.setPrecio(799.99);
                p1.setExistencias(10);
                p1.setImagenUrl("/img/default-product.jpg");
                session.persist(p1);
                
                Producto p2 = new Producto();
                p2.setNombre("Laptop Pro X1");
                p2.setDescripcion("Laptop con Intel i7, 16GB RAM, 512GB SSD");
                p2.setPrecio(1299.99);
                p2.setExistencias(5);
                p2.setImagenUrl("/img/default-product.jpg");
                session.persist(p2);
                
                Producto p3 = new Producto();
                p3.setNombre("Smartwatch Series 8");
                p3.setDescripcion("Reloj inteligente con monitor cardíaco");
                p3.setPrecio(349.99);
                p3.setExistencias(15);
                p3.setImagenUrl("/img/default-product.jpg");
                session.persist(p3);
                
                tx.commit();
                
                logger.info("Usuarios y productos iniciales creados correctamente");
            } else {
                logger.info("Ya existen usuarios en la base de datos, no se cargarán datos iniciales");
            }
        } catch (Exception e) {
            logger.error("Error al cargar datos iniciales: {}", e.getMessage(), e);
        }
    }

    public static SessionFactory getSessionFactory() {
        return sessionFactory;
    }

    public static void shutdown() {
        if (sessionFactory != null && !sessionFactory.isClosed()) {
            sessionFactory.close();
        }
    }
}