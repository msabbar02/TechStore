-- Crear base de datos (si no existe)
CREATE DATABASE IF NOT EXISTS techstore;
USE techstore;

-- Tabla usuario
CREATE TABLE IF NOT EXISTS usuario (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    direccion VARCHAR(100),
    username VARCHAR(50) UNIQUE,
    password VARCHAR(50),
    rol VARCHAR(20),
    fotoPerfil VARCHAR(255)
);

-- Tabla producto
CREATE TABLE IF NOT EXISTS producto (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    descripcion TEXT,
    precio DECIMAL(10,2),
    imagenUrl VARCHAR(255)
);

-- Insertar usuarios
INSERT INTO usuario (nombre, apellido, direccion, username, password, rol, fotoPerfil) VALUES
('Admin', 'Tech', 'Calle Admin 1', 'admin', 'admin123', 'admin', 'https://via.placeholder.com/80'),
('Usuario', 'Normal', 'Calle Lector 42', 'lector', 'lector123', 'lector', 'https://via.placeholder.com/80');

-- Insertar productos
INSERT INTO producto (nombre, descripcion, precio, imagenUrl) VALUES
('Portátil Gaming', 'Potente portátil con GPU dedicada', 1299.99, 'https://via.placeholder.com/300x200?text=Portatil'),
('Monitor 4K', 'Pantalla UHD de 27 pulgadas', 399.99, 'https://via.placeholder.com/300x200?text=Monitor'),
('Teclado Mecánico', 'Retroiluminado RGB con switches azules', 89.90, 'https://via.placeholder.com/300x200?text=Teclado'),
('Ratón Inalámbrico', 'Ergonómico y preciso', 49.99, 'https://via.placeholder.com/300x200?text=Raton'),
('Auriculares Gaming', 'Sonido envolvente 7.1 con micrófono', 69.99, 'https://via.placeholder.com/300x200?text=Auriculares');
