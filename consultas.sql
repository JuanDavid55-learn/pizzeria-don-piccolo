-- Clientes con pedidos entre dos fechas (BETWEEN).
SELECT p.id AS id_pedido, p.fecha_hora, c.id AS id_cliente FROM pedidos p 
LEFT JOIN cliente c ON c.id = p.id_cliente WHERE p.fecha_hora BETWEEN '2025-12-01' AND '2025-12-06';

-- Pizzas más vendidas (GROUP BY y COUNT).
SELECT pi.nombre, SUM(dp.cantidad_pizzas) AS total_vendidas FROM pizzas pi
LEFT JOIN detalle_pedidos dp ON dp.id_pizza = pi.id GROUP BY pi.id ORDER BY total_vendidas DESC;

-- Pedidos por repartidor (JOIN).
SELECT r.id, COUNT(d.id) AS entregas FROM domicilios d
JOIN repartidores r ON r.id = d.id_repartidor GROUP BY r.id;

-- Promedio de entrega por zona (AVG y JOIN).
SELECT z.nombre, AVG(TIMESTAMPDIFF(MINUTE, d.hora_salida, d.hora_entrega)) AS promedio_minutos FROM domicilios d 
JOIN repartidores r ON r.id = d.id_repartidor JOIN zona z ON z.id = r.id_zona GROUP BY z.id;

-- Clientes que gastaron más de un monto (HAVING).
SELECT c.id, p.nombre, SUM(pg.total_pagado) AS total_gastado FROM cliente c 
JOIN persona p ON p.id = c.id JOIN pedidos pd ON pd.id_cliente = c.id 
JOIN pago pg ON pg.id_pedido = pd.id GROUP BY c.id HAVING total_gastado > 50000; -- modificar el monto

-- Búsqueda por coincidencia parcial de nombre de pizza (LIKE).
SELECT * FROM pizzas WHERE nombre LIKE '%%'; -- colocar en % % para buscar

-- Subconsulta para obtener los clientes frecuentes (más de 5 pedidos mensuales).
SELECT c.id, p.nombre, COUNT(pd.id) AS total_pedidos FROM cliente c JOIN persona p ON p.id= c.id
JOIN pedidos pd ON pd.id_cliente=c.id WHERE MONTH(pd.fecha_hora) = 12 -- colocar mes que corresponda
GROUP BY c.id HAVING total_pedidos > 5; -- para hacer la prueba se necesita insertar mas pedidos o bien reduzca la condicional a 2
