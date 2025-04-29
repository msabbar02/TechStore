# TechStore - Tienda de Productos Tecnológicos

Aplicación web para la gestión de una tienda de productos tecnológicos, desarrollada con Java, Javalin y Hibernate.

## Características

- Catálogo de productos tecnológicos
- Carrito de compras
- Gestión de usuarios (admin y lectores)
- Panel de administración
- Historial de órdenes
- Perfiles de usuario

## Requisitos

- Java 17 o superior
- MySQL 8.0 o superior
- Maven 3.8 o superior

## Instalación

1. Clonar el repositorio:
   ```bash
   git clone https://github.com/tu-usuario/techstore.git
   cd techstore
   ```

2. Configurar la base de datos:
   - Crear una base de datos MySQL llamada `techstore`
   - Ejecutar el script `src/main/resources/data.sql` para crear las tablas e insertar datos de prueba

3. Configurar la conexión a la base de datos:
   - Editar el archivo `src/main/resources/hibernate.cfg.xml` con tus credenciales de MySQL

4. Compilar el proyecto:
   ```bash
   mvn clean package
   ```

5. Ejecutar la aplicación:
   ```bash
   java -jar target/techstore-1.0-SNAPSHOT.jar
   ```

6. Abrir la aplicación en el navegador:
   ```
   http://localhost:7000
   ```

## Usuarios predeterminados

- Administrador:
  - Usuario: admin
  - Contraseña: admin123

- Usuario normal:
  - Usuario: lector
  - Contraseña: lector123

## Estructura del proyecto

- `src/main/java/org/example/`: Código fuente de la aplicación
   - `controller/`: Controladores para manejar las peticiones HTTP
   - `dao/`: Objetos de acceso a datos para interactuar con la base de datos
   - `model/`: Modelos de dominio (entidades)
   - `middleware/`: Middleware para autenticación y autorización
   - `util/`: Clases de utilidad

- `src/main/resources/`: Recursos de la aplicación
   - `static/`: Archivos estáticos (CSS, JS, imágenes)
   - `templates/`: Plantillas Freemarker para las vistas
   - `hibernate.cfg.xml`: Configuración de Hibernate
   - `data.sql`: Script SQL para crear la base de datos

## Licencia

Este proyecto está bajo la Licencia MIT. Ver archivo LICENSE para más detalles.
