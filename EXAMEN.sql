/*
La Pizzería Don Piccolo desea mejorar el control de sus pedidos. Cada pedido incluye información del cliente, las pizzas solicitadas, la fecha del pedido,
el método de pago y el estado (pendiente, en preparación, entregado, cancelado). Actualmente, el gerente necesita consultar, validar y actualizar los
pedidos de manera más eficiente.

Tu tarea consiste en diseñar y consultar datos del módulo de pedidos para optimizar la gestión diaria de órdenes y estados.


Objetivo del examen
Modelar correctamente la tabla de pedidos, relacionarla con clientes y pizzas, y crear consultas SQL funcionales que permitan obtener información útil 
para la toma de decisiones.


Requerimientos del examen:

1. Creación de tabla de pedidos
Crear una tabla pedidos con los siguientes campos:
    id_pedido (PK, autoincremental)
    id_cliente (FK que apunte a clientes)
    fecha_pedido (DATE)
    metodo_pago (VARCHAR)   
    estado (ENUM: 'pendiente', 'preparacion', 'entregado', 'cancelado')
    total (DECIMAL(10,2))

2. Creación de tabla intermedia
Crear una tabla pedido_pizza que relacione los pedidos con las pizzas.
Campos mínimos: id_pedido, id_pizza, cantidad.

3. Consulta de pedidos por cliente
Consulta SQL que muestre el nombre del cliente, el ID del pedido, el total y el estado del pedido.

4. Consulta de pedidos entregados en un rango de fechas
Mostrar los pedidos con estado entregado cuya fecha esté entre dos fechas dadas (usa BETWEEN).

5. Consulta de resumen de pedidos por método de pago
Mostrar cuántos pedidos se hicieron por cada método de pago y el total acumulado (GROUP BY).

6. Consulta de clientes frecuentes
Mostrar los clientes que tengan más de 5 pedidos en total (usa HAVING COUNT(*) > 5).
*/

---///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////---
--                                                        DESARROLLO                                                                           --
---///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////---


/*la entrega de este examen estara basada en la base de datos echa durante el examen, por lo que hay que tener en cuenta que las tablas pedidos,
clientes, pizzas y la tabla intermedia pedido_pizza correspondientes a los puntos 1 y 2 ya estan hechas. */


-- 3. Consulta de pedidos por cliente

SELECT c.id AS id_cliente, p.nombre, pd.id AS id_pedido, pd.total FROM cliente c LEFT JOIN persona p ON p.id= c.id
LEFT JOIN pedidos pd ON pd.id_cliente=c.id;

-- 4. Consulta de pedidos entregados en un rango de fechas

SELECT p.id, p.fecha_hora, p.estado, p.total, c.id AS id_cliente FROM pedidos p
LEFT JOIN cliente c ON c.id = p.id_cliente WHERE p.estado = 'entregado' AND p.fecha_hora BETWEEN '2025-12-01' AND '2025-12-06';

-- 6. Consulta de clientes frecuentes

SELECT c.id, p.nombre, COUNT(pd.id) AS total_pedidos FROM cliente c LEFT JOIN persona p ON p.id= c.id LEFT JOIN pedidos pd ON pd.id_cliente=c.id GROUP BY c.id;
