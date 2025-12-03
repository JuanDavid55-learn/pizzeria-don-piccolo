-- Vista de resumen de pedidos por cliente (nombre del cliente, cantidad de pedidos, total gastado).
CREATE VIEW vista_resumen_clientes AS
SELECT p.id AS id_cliente,per.nombre, COUNT(pd.id) AS total_pedidos, SUM(pg.total_pagado) AS total_gastado FROM cliente p 
JOIN persona per ON per.id = p.id JOIN pedidos pd ON pd.id_cliente = p.id JOIN pago pg ON pg.id_pedido = pd.id GROUP BY p.id;
-- visualizar
SELECT * FROM vista_resumen_clientes;

-- Vista de desempeño de repartidores (número de entregas, tiempo promedio, zona).
CREATE VIEW vista_desempeno_repartidores AS
SELECT r.id AS id_repartidor, z.nombre AS zona, COUNT(d.id) AS total_domicilios, AVG(TIMESTAMPDIFF(MINUTE, d.hora_salida, d.hora_entrega)) AS tiempo_promedio
FROM repartidores r LEFT JOIN domicilios d ON d.id_repartidor = r.id JOIN zona z ON z.id = r.id_zona GROUP BY r.id;
-- visualizar
SELECT * FROM vista_desempeno_repartidores;

-- Vista de stock de ingredientes por debajo del mínimo permitido.
CREATE VIEW vista_stock_bajo AS 
SELECT * FROM ingredientes WHERE stock <= alerta_stock;

-- realizar cambios para hacer prueba
UPDATE ingredientes SET stock =10 WHERE id = 9;

-- visualizar
SELECT * FROM vista_stock_bajo;
