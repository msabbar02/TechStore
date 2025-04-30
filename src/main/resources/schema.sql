-- Crear base de datos si no existe
DROP DATABASE IF EXISTS techstore;
CREATE DATABASE IF NOT EXISTS techstore CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE techstore;

-- Tabla usuario
CREATE TABLE IF NOT EXISTS usuario (
                                       id INT PRIMARY KEY AUTO_INCREMENT,
                                       nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    direccion VARCHAR(100),
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    rol VARCHAR(20) NOT NULL DEFAULT 'lector',
    fotoPerfil VARCHAR(255) DEFAULT '/img/default-avatar.png',
    CONSTRAINT chk_rol CHECK (rol IN ('admin', 'lector'))
    );

-- Tabla producto
CREATE TABLE IF NOT EXISTS producto (
                                        id INT PRIMARY KEY AUTO_INCREMENT,
                                        nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10,2) NOT NULL,
    existencias INT NOT NULL DEFAULT 10,
    imagenUrl VARCHAR(255) DEFAULT '/img/default-product.jpg',
    CONSTRAINT chk_precio CHECK (precio >= 0),
    CONSTRAINT chk_existencias CHECK (existencias >= 0)
    );

-- Tabla orden
CREATE TABLE IF NOT EXISTS orden (
                                     id INT PRIMARY KEY AUTO_INCREMENT,
                                     usuario_id INT NOT NULL,
                                     fecha_compra TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                     estado VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE',
    total DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES usuario(id),
    CONSTRAINT chk_estado CHECK (estado IN ('PENDIENTE', 'COMPLETADA', 'CANCELADA'))
    );

-- Tabla detalle_orden
CREATE TABLE IF NOT EXISTS detalle_orden (
                                             id INT PRIMARY KEY AUTO_INCREMENT,
                                             orden_id INT NOT NULL,
                                             producto_id INT NOT NULL,
                                             cantidad INT NOT NULL,
                                             precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (orden_id) REFERENCES orden(id),
    FOREIGN KEY (producto_id) REFERENCES producto(id),
    CONSTRAINT chk_cantidad CHECK (cantidad > 0)
    );

-- Insertar usuarios
INSERT INTO usuario (nombre, apellido, direccion, username, password, rol, fotoPerfil)
VALUES
    ('Admin', 'Tech', 'Calle Admin 1', 'admin', 'admin', 'admin', '/img/default-avatar.png'),
    ('Usuario', 'Normal', 'Calle Lector 42', 'lector', 'lector', 'lector', '/img/default-avatar.png'),
    ('Moha', 'Sabbir', 'Calle Nueva 123', 'moha', 'moha123', 'lector', '/img/default-avatar.png');

-- Insertar productos
INSERT INTO producto (nombre, descripcion, precio, existencias, imagenUrl)
VALUES
    ('Portátil Gaming', 'Potente portátil con GPU dedicada', 1299.99, 10, '/img/default-product.jpg'),
    ('Monitor 4K', 'Pantalla UHD de 27 pulgadas', 399.99, 15, '/img/default-product.jpg'),
    ('Teclado Mecánico', 'Retroiluminado RGB con switches azules', 89.90, 20, '/img/default-product.jpg'),
    ('Ratón Inalámbrico', 'Ergonómico y preciso', 49.99, 30, '/img/default-product.jpg'),
    ('Auriculares Gaming', 'Sonido envolvente 7.1 con micrófono', 69.99, 25, '/img/default-product.jpg');

-- Insertar órdenes para usuario 'moha'
-- Primero necesitamos el id de moha

-- Suponiendo que moha es id 3 (porque los otros dos son admin y lector)
INSERT INTO orden (usuario_id, estado, total)
VALUES
    (3, 'PENDIENTE', 1449.98),
    (3, 'COMPLETADA', 399.99);

-- Insertar detalles de órdenes
INSERT INTO detalle_orden (orden_id, producto_id, cantidad, precio_unitario, subtotal)
VALUES
    (1, 1, 1, 1299.99, 1299.99),
    (1, 4, 3, 49.99, 149.97),
    (2, 2, 1, 399.99, 399.99);
