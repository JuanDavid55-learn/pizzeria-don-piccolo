-- Función para calcular el total de un pedido (sumando precios de pizzas + costo de envío + IVA).
DELIMITER //
CREATE FUNCTION calcular_total_pedido(p_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE subtotal_pizzas DECIMAL(10,2) DEFAULT 0;
    DECLARE costo_envio DECIMAL(10,2) DEFAULT 0;
    DECLARE total_final DECIMAL(10,2) DEFAULT 0;

    -- obtener subtotal de los productos del pedido
    SELECT SUM(dp.subtotal) INTO subtotal_pizzas FROM detalle_pedidos dp WHERE dp.id_pedido = p_id;

    -- obtener costo de envío (se busca la zona del repartidor asociado al domicilio)
    SELECT IFNULL(z.costo_fijo, 0) INTO costo_envio FROM domicilios d
    LEFT JOIN repartidores r ON r.id = d.id_repartidor
    LEFT JOIN zona z ON z.id = r.id_zona
    WHERE d.id_pedido = p_id
    LIMIT 1;

    -- total final con IVA 19%
    SET total_final = (subtotal_pizzas + costo_envio) * 1.19;

    RETURN total_final;
END //
DELIMITER ;

SELECT calcular_total_pedido(5); -- consulta de ejemplo

-- Función para calcular la ganancia neta diaria (ventas - costos de ingredientes).
DELIMITER //
CREATE FUNCTION ganancia_neta(fecha_busqueda DATE)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE ventas DECIMAL(10,2);
    DECLARE costo DECIMAL(10,2);

    -- total ventas del día
    SELECT SUM(pg.total_pagado) INTO ventas FROM pedidos p LEFT JOIN pago pg ON pg.id_pedido = p.id WHERE DATE(p.fecha_hora) = fecha_busqueda;

    -- costo de ingredientes utilizados
    SELECT SUM(pi.cantidad_ingrediente * i.costo_unitario) INTO costo FROM pedidos p
    LEFT JOIN detalle_pedidos dp ON dp.id_pedido = p.id
    LEFT JOIN pizza_ingredientes pi ON dp.id_pizza = pi.id_pizza
    LEFT JOIN ingredientes i ON i.id = pi.id_ingrediente
    WHERE DATE(p.fecha_hora) = fecha_busqueda;

    RETURN ventas - costo;
END //
DELIMITER ;

SELECT ganancia_neta('2025-12-01'); -- consulta de ejemplo

-- Procedimiento para cambiar automáticamente el estado del pedido a “entregado” cuando se registre la hora de entrega.

-- procediemiento normal, el funcional esta en triggers.sql en el Trigger para marcar repartidor como “disponible”
DELIMITER //
CREATE PROCEDURE marcar_entregado(IN p_id INT)
BEGIN
    UPDATE pedidos SET estado = 'entregado' WHERE id = p_id;

END //
DELIMITER ;

CALL marcar_entregado(13); -- consulta de ejemplo