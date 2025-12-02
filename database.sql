-- creacion de la base de datos
CREATE DATABASE pizzeria_don_piccolo;
USE pizzeria_don_piccolo;

-- //////////////////////////////////////////////// --
-- creacion de las tablas

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

-- TABLA zona
CREATE TABLE zona (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(45),
    distancia_metros INT,
    costo_fijo DECIMAL(10,2)
);

-- TABLA domicilios
CREATE TABLE domicilios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    hora_salida DATETIME,
    hora_entrega DATETIME,
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