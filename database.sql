-- creacion de la base de datos
CREATE DATABASE pizzeria_don_piccolo;
USE pizzeria_don_piccolo;

-- //////////////////////////////////////////////// --
-- creacion de las tablas, ¡¡cuidado con el orden!!

-- TABLA zona
CREATE TABLE zona (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(45),
    distancia_metros INT,
    costo_fijo DECIMAL(10,2)
);

-- TABLA persona
CREATE TABLE persona (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(45),
    telefono VARCHAR(45),
    direccion VARCHAR(45),
    correo VARCHAR(45)
);

-- TABLA cliente (hereda persona)
CREATE TABLE cliente (
    id INT PRIMARY KEY,
    pedidos_realizados INT,
    FOREIGN KEY (id) REFERENCES persona(id)
);

-- TABLA repartidores (hereda persona)
CREATE TABLE repartidores (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(45),
    estado ENUM('disponible','ocupado','inactivo'),
    id_zona INT,
    FOREIGN KEY (id_zona) REFERENCES zona(id),
    FOREIGN KEY (id) REFERENCES persona(id)
);

-- TABLA vendedor (hereda persona)
CREATE TABLE vendedor (
    id INT PRIMARY KEY AUTO_INCREMENT,
    usuario VARCHAR(45),
    contrasena VARCHAR(45),
    FOREIGN KEY (id) REFERENCES persona(id)
);

-- TABLA pedidos
CREATE TABLE pedidos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    fecha_hora DATETIME,
    entrega ENUM('local','domicilio'),
    estado ENUM('pendiente','preparando','entregado','cancelado'),
    total DECIMAL(10,2),
    id_cliente INT,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id)
);

-- TABLA pago
CREATE TABLE pago (
    id INT PRIMARY KEY AUTO_INCREMENT,
    IVA DECIMAL(10,2),
    forma_pago ENUM('efectivo','tarjeta','app'),
    total_pagado DECIMAL(10,2),
    id_pedido INT,
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id)
);

-- TABLA domicilios
CREATE TABLE domicilios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    hora_salida DATETIME,
    hora_entrega DATETIME NULL DEFAULT NULL, -- null por defecto ayudara al trigger 
    precio_envio DECIMAL(10,2),
    total_domicilio DECIMAL(10,2),
    id_repartidor INT,
    id_pedido INT,
    id_vendedor INT,
    FOREIGN KEY (id_repartidor) REFERENCES repartidores(id),
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id),
    FOREIGN KEY (id_vendedor) REFERENCES vendedor(id)
);

-- TABLA pizzas
CREATE TABLE pizzas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(45),
    tamano ENUM('personal','mediana','familiar'),
    tipo ENUM('especial','vegetariana','clasica'),
    precio_unitario DECIMAL(10,2)
);

-- TABLA detalle_pedidos (tabla intermedia)
CREATE TABLE detalle_pedidos (
    id_pedido INT,
    id_pizza INT,
    cantidad_pizzas INT,
    subtotal DECIMAL(10,2),
    PRIMARY KEY (id_pedido, id_pizza),
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id),
    FOREIGN KEY (id_pizza) REFERENCES pizzas(id)
);

-- TABLA ingredientes
CREATE TABLE ingredientes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tipo_ingrediente ENUM('harina','salsa','queso','carne','vegetales','otros'),
    descripcion VARCHAR(45),
    stock INT,
    alerta_stock INT,
    costo_unitario DECIMAL(10,2)
);

-- TABLA pizza_ingredientes (tabla intermedia)
CREATE TABLE pizza_ingredientes (
    id_pizza INT,
    id_ingrediente INT,
    cantidad_ingrediente INT,
    PRIMARY KEY (id_pizza, id_ingrediente),
    FOREIGN KEY (id_pizza) REFERENCES pizzas(id),
    FOREIGN KEY (id_ingrediente) REFERENCES ingredientes(id)
);

-- //////////////////////////////////////////////// --
-- insercion de datos de prueba, ¡¡cuidado con el orden!!

-- ZONA
INSERT INTO zona (nombre, distancia_metros, costo_fijo) VALUES
('Centro', 500, 3000),
('Norte', 1200, 5000),
('Sur', 1800, 6000),
('Occidente', 2000, 6500),
('Oriente', 1500, 5500),
('Industrial', 2500, 7000),
('Comercial', 800, 3500),
('Universitaria', 900, 4000),
('Residencial', 1300, 4500),
('Rural', 3000, 9000);

-- PERSONA
INSERT INTO persona (nombre, telefono, direccion, correo) VALUES

-- cliente
('Carlos Pérez', '3001234567', 'Cra 12 # 45-13', 'carlos@gmail.com'),
('María Gómez', '3019876543', 'Cll 20 # 15-22', 'maria@gmail.com'),
('Juan Torres', '3024567891', 'Av 3 # 10-50', 'juan@gmail.com'),
('Laura Serrano', '3004569871', 'Cll 33 # 21-44', 'laura@gmail.com'),
('Pedro López', '3012223344', 'Cra 55 # 12-90', 'pedro@gmail.com'),
('Sandra Ramírez', '3028899001', 'Cll 14 # 1-22', 'sandra@gmail.com'),
('David Arias', '3001112233', 'Av 6 # 88-20', 'david@gmail.com'),
('Nicolás Rojas', '3019988776', 'Cll 8 # 92-15', 'nicolas@gmail.com'),
('Camila Silva', '3023344556', 'Cra 71 # 34-60', 'camila@gmail.com'),
('Andrés Herrera', '3006677889', 'Cll 97 # 33-10', 'andres@gmail.com'),

-- Repartidores
('Jorge Martínez', '3009988776', 'Cll 44 # 12-08', 'jorge@gmail.com'),
('Felipe Castaño', '3011122334', 'Cra 19 # 33-22', 'felipe@gmail.com'),
('Luis Mendoza', '3022233445', 'Av 10 # 66-99', 'luis@gmail.com'),
('Esteban Londoño', '3003344556', 'Cll 70 # 11-90', 'esteban@gmail.com'),
('Daniel Ortiz', '3015566778', 'Cra 9 # 30-55', 'daniel@gmail.com'),

-- Vendedores
('Lucía Cárdenas', '3001122554', 'Cll 1 # 22-33', 'lucia@gmail.com'),
('Andrea Acosta', '3016677889', 'Cra 2 # 33-44', 'andrea@gmail.com'),
('Oscar Salazar', '3027788991', 'Cll 5 # 55-66', 'oscar@gmail.com'),
('Kevin Morales', '3009988775', 'Cra 6 # 77-88', 'kevin@gmail.com'),
('Tatiana Gómez', '3018899001', 'Cll 8 # 22-11', 'tatiana@gmail.com');

-- CLIENTE
INSERT INTO cliente (id, pedidos_realizados) VALUES
(1, 5),
(2, 2),
(3, 7),
(4, 1),
(5, 10),
(6, 3),
(7, 6),
(8, 4),
(9, 9),
(10, 2);

-- VENDEDOR
INSERT INTO vendedor (id, usuario, contrasena) VALUES
(16, 'luciaC', 'pass123'),
(17, 'andreaA', 'pass234'),
(18, 'oscarS', 'pass345'),
(19, 'kevinM', 'pass456'),
(20, 'tatianaG', 'pass567');

-- REPARTIDORES
INSERT INTO repartidores (id, estado, id_zona) VALUES
(11, 'disponible', 1),
(12, 'ocupado', 2),
(13, 'disponible', 3),
(14, 'inactivo', 4),
(15, 'disponible', 5);

-- INGREDIENTES
INSERT INTO ingredientes (tipo_ingrediente, descripcion, stock, alerta_stock, costo_unitario) VALUES
('harina', 'Harina de trigo 1kg', 50, 10, 3500),
('salsa', 'Salsa de tomate artesanal', 40, 10, 2000),
('queso', 'Mozzarella', 30, 10, 4500),
('carne', 'Pepperoni premium', 25, 5, 6000),
('vegetales', 'Champiñones frescos', 15, 5, 5000),
('vegetales', 'Pimentón verde', 20, 5, 2500),
('carne', 'Jamón especial', 18, 5, 5500),
('otros', 'Aceitunas negras', 12, 5, 3000),
('otros', 'Orégano', 40, 10, 1000),
('vegetales', 'Piña en cubos', 20, 5, 3500);

-- PIZZAS
INSERT INTO pizzas (nombre, tamano, tipo, precio_unitario) VALUES
('Hawaiana', 'familiar', 'especial', 32000),
('Pepperoni', 'familiar', 'clasica', 34000),
('Carnes', 'mediana', 'especial', 30000),
('Pollo Champiñón', 'mediana', 'especial', 31000),
('Vegetariana', 'mediana', 'vegetariana', 28000),
('Mexicana', 'familiar', 'especial', 35000),
('Napolitana', 'personal', 'clasica', 18000),
('Campesina', 'personal', 'clasica', 17000),
('Pollo BBQ', 'mediana', 'especial', 31000),
('Tres Quesos', 'personal', 'clasica', 19000);

-- PIZZA-INGREDIENTES
INSERT INTO pizza_ingredientes (id_pizza, id_ingrediente, cantidad_ingrediente) VALUES
(1, 1, 1),
(1, 2, 1),
(1, 3, 1),
(1,10,1),
(2, 1, 1),
(2, 2, 1),
(2, 4, 1),
(3, 1, 1),
(3, 4, 1),
(3, 7, 1),
(4, 1, 1),
(4, 5, 1),
(4, 7, 1),
(5, 1, 1),
(5, 6, 1),
(6, 1, 1),
(6, 4, 1),
(6, 9, 1),
(7, 1, 1),
(7, 9, 1),
(8, 1, 1),
(8, 6, 1),
(9, 1, 1),
(9, 7, 1),
(9, 9, 1),
(10,1,1),
(10,3,1),
(10,9,1);

-- PEDIDOS
INSERT INTO pedidos (fecha_hora, entrega, estado, total, id_cliente) VALUES
('2025-12-01 14:30:00', 'domicilio', 'entregado', 35000, 1),
('2025-12-02 18:10:00', 'local', 'entregado', 34000, 2),
('2025-12-03 12:20:00', 'domicilio', 'preparando', 32000, 3),
('2025-12-03 13:15:00', 'local', 'pendiente', 18000, 4),
('2025-12-04 19:40:00', 'domicilio', 'entregado', 45000, 5),
('2025-12-04 20:10:00', 'local', 'entregado', 31000, 6),
('2025-12-05 11:50:00', 'domicilio', 'entregado', 36000, 7),
('2025-12-05 22:10:00', 'local', 'cancelado', 0, 8),
('2025-12-06 10:30:00', 'domicilio', 'entregado', 41000, 9),
('2025-12-06 15:00:00', 'local', 'entregado', 30000, 10);

-- DETALLE-PEDIDOS
INSERT INTO detalle_pedidos VALUES
(1,1,1,32000),
(1,7,1,18000),
(2,2,1,34000),
(3,3,1,30000),
(4,7,1,18000),
(5,6,1,35000),
(6,4,1,31000),
(7,1,1,32000),
(8,8,1,17000),
(9,9,1,31000),
(10,10,1,19000),
(2,10,1,19000),
(3,7,1,18000),
(5,10,1,19000),
(6,8,1,17000),
(7,3,1,30000),
(8,2,1,34000),
(9,5,1,28000),
(10,1,1,32000),
(1,5,1,28000);

-- PAGO
INSERT INTO pago (IVA, forma_pago, total_pagado, id_pedido) VALUES
(5600, 'efectivo', 40600, 1),
(5440, 'tarjeta', 39440, 2),
(5120, 'app', 37120, 3),
(2880, 'efectivo', 20880, 4),
(7200, 'tarjeta', 52200, 5),
(4960, 'efectivo', 35960, 6),
(5760, 'app', 41760, 7),
(0, 'efectivo', 0, 8),
(6560, 'tarjeta', 47560, 9),
(4800, 'efectivo', 34800, 10);

-- DOMICILIOS
INSERT INTO domicilios (hora_salida, hora_entrega, precio_envio, total_domicilio, id_repartidor, id_pedido, id_vendedor) VALUES
('2025-12-01 14:35', '2025-12-01 14:50', 3000, 38000, 11, 1, 16),
('2025-12-03 12:25', '2025-12-03 12:40', 5000, 37000, 12, 3, 17),
('2025-12-04 19:45', '2025-12-04 20:00', 5500, 50500, 13, 5, 18),
('2025-12-05 11:55', '2025-12-05 12:10', 4500, 40500, 11, 7, 19),
('2025-12-06 10:35', '2025-12-06 11:00', 6000, 47000, 12, 9, 20),
('2025-12-02 14:00', '2025-12-02 14:20', 6500, 40500, 13, 3, 16),
('2025-12-03 17:00', '2025-12-03 17:15', 3000, 38000, 11, 1, 18),
('2025-12-04 10:00', '2025-12-04 10:30', 5000, 37000, 12, 3, 20),
('2025-12-05 19:00', '2025-12-05 19:20', 4500, 40500, 13, 7, 17),
('2025-12-06 21:00', '2025-12-06 21:30', 6000, 47000, 11, 9, 19);
