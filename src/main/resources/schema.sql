-- Definición del esquema de la base de datos para TechStore

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

-- Insertar usuarios de prueba (solo si la tabla está vacía)
INSERT INTO usuario (nombre, apellido, direccion, username, password, rol, fotoPerfil)
SELECT 'Admin', 'Tech', 'Calle Admin 1', 'admin', 'admin', 'admin', '/img/default-avatar.png'
WHERE NOT EXISTS (SELECT 1 FROM usuario WHERE username = 'admin');

INSERT INTO usuario (nombre, apellido, direccion, username, password, rol, fotoPerfil)
SELECT 'Usuario', 'Normal', 'Calle Lector 42', 'lector', 'lector', 'lector', '/img/default-avatar.png'
WHERE NOT EXISTS (SELECT 1 FROM usuario WHERE username = 'lector');

-- Insertar productos de prueba (solo si la tabla está vacía)
INSERT INTO producto (nombre, descripcion, precio, existencias, imagenUrl)
SELECT 'Portátil Gaming', 'Potente portátil con GPU dedicada', 1299.99, 10, '/img/default-product.jpg'
WHERE NOT EXISTS (SELECT 1 FROM producto WHERE nombre = 'Portátil Gaming');

INSERT INTO producto (nombre, descripcion, precio, existencias, imagenUrl)
SELECT 'Monitor 4K', 'Pantalla UHD de 27 pulgadas', 399.99, 15, '/img/default-product.jpg'
WHERE NOT EXISTS (SELECT 1 FROM producto WHERE nombre = 'Monitor 4K');

INSERT INTO producto (nombre, descripcion, precio, existencias, imagenUrl)
SELECT 'Teclado Mecánico', 'Retroiluminado RGB con switches azules', 89.90, 20, '/img/default-product.jpg'
WHERE NOT EXISTS (SELECT 1 FROM producto WHERE nombre = 'Teclado Mecánico');

INSERT INTO producto (nombre, descripcion, precio, existencias, imagenUrl)
SELECT 'Ratón Inalámbrico', 'Ergonómico y preciso', 49.99, 30, '/img/default-product.jpg'
WHERE NOT EXISTS (SELECT 1 FROM producto WHERE nombre = 'Ratón Inalámbrico');

INSERT INTO producto (nombre, descripcion, precio, existencias, imagenUrl)
SELECT 'Auriculares Gaming', 'Sonido envolvente 7.1 con micrófono', 69.99, 25, '/img/default-product.jpg'
WHERE NOT EXISTS (SELECT 1 FROM producto WHERE nombre = 'Auriculares Gaming');

-- Crear índices para mejorar el rendimiento
CREATE INDEX IF NOT EXISTS idx_orden_usuario ON orden(usuario_id);
CREATE INDEX IF NOT EXISTS idx_detalle_orden ON detalle_orden(orden_id);
CREATE INDEX IF NOT EXISTS idx_detalle_producto ON detalle_orden(producto_id);
CREATE INDEX IF NOT EXISTS idx_usuario_username ON usuario(username);
