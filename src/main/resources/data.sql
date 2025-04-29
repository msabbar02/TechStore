-- Crear base de datos (si no existe)
CREATE DATABASE IF NOT EXISTS techstore;
USE techstore;

-- Tabla usuario
CREATE TABLE IF NOT EXISTS usuario (
                                       id INT PRIMARY KEY AUTO_INCREMENT,
                                       nombre VARCHAR(50) NOT NULL,
                                       apellido VARCHAR(50) NOT NULL,
                                       direccion VARCHAR(100) NOT NULL,
                                       username VARCHAR(50) UNIQUE NOT NULL,
                                       password VARCHAR(255) NOT NULL,
                                       rol VARCHAR(20) NOT NULL DEFAULT 'lector',
                                       fotoPerfil VARCHAR(255),
                                       CONSTRAINT chk_rol CHECK (rol IN ('admin', 'lector'))
);

-- Tabla producto
CREATE TABLE IF NOT EXISTS producto (
                                        id INT PRIMARY KEY AUTO_INCREMENT,
                                        nombre VARCHAR(100) NOT NULL,
                                        descripcion TEXT,
                                        precio DECIMAL(10,2) NOT NULL,
                                        imagenUrl VARCHAR(255),
                                        CONSTRAINT chk_precio CHECK (precio >= 0)
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

-- Tabla detalle_orden (necesaria para relacionar productos con órdenes)
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

-- Insertar usuarios de prueba
INSERT INTO usuario (nombre, apellido, direccion, username, password, rol) VALUES
                                                                               ('Admin', 'Tech', 'Calle Admin 1', 'admin', 'admin123', 'admin'),
                                                                               ('Usuario', 'Normal', 'Calle Lector 42', 'lector', 'lector123', 'lector');

-- Insertar productos de prueba
INSERT INTO producto (nombre, descripcion, precio, imagenUrl) VALUES
                                                                  ('Portátil Gaming', 'Potente portátil con GPU dedicada', 1299.99, 'https://via.placeholder.com/300x200?text=Portatil'),
                                                                  ('Monitor 4K', 'Pantalla UHD de 27 pulgadas', 399.99, 'https://via.placeholder.com/300x200?text=Monitor'),
                                                                  ('Teclado Mecánico', 'Retroiluminado RGB con switches azules', 89.90, 'https://via.placeholder.com/300x200?text=Teclado'),
                                                                  ('Ratón Inalámbrico', 'Ergonómico y preciso', 49.99, 'https://via.placeholder.com/300x200?text=Raton'),
                                                                  ('Auriculares Gaming', 'Sonido envolvente 7.1 con micrófono', 69.99, 'https://via.placeholder.com/300x200?text=Auriculares');

-- Crear índices para mejorar el rendimiento
CREATE INDEX idx_orden_usuario ON orden(usuario_id);
CREATE INDEX idx_detalle_orden ON detalle_orden(orden_id);