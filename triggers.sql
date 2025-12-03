-- Trigger de actualización automática de stock de ingredientes cuando se realiza un pedido.
DELIMITER //
CREATE TRIGGER descontar_stock_ingredientes
AFTER INSERT ON detalle_pedidos
FOR EACH ROW
BEGIN
    UPDATE ingredientes i LEFT JOIN pizza_ingredientes pi ON pi.id_ingrediente = i.id
    SET i.stock = i.stock - (pi.cantidad_ingrediente * NEW.cantidad_pizzas) -- restar con la cantidad de un ingrediente por pizza
    WHERE pi.id_pizza = NEW.id_pizza;
END //
DELIMITER ;
-- /// para probar el trigger /// --
SELECT i.id, i.descripcion, i.stock FROM ingredientes i JOIN pizza_ingredientes pi ON pi.id_ingrediente = i.id WHERE pi.id_pizza = 5;
INSERT INTO pedidos (fecha_hora, entrega, estado, total, id_cliente) VALUES (NOW(), 'local', 'pendiente', 0, 1);
INSERT INTO detalle_pedidos (id_pedido, id_pizza, cantidad_pizzas, subtotal) VALUES (11, 5, 2, 0); -- usar el id_pedido que corresponda
SELECT i.id, i.descripcion, i.stock FROM ingredientes i JOIN pizza_ingredientes pi ON pi.id_ingrediente = i.id WHERE pi.id_pizza = 5;



-- Trigger de auditoría que registre en una tabla historial_precios cada vez que se modifique el precio de una pizza.
-- crear la tabla historial_precios
CREATE TABLE historial_precios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_pizza INT,
    precio_anterior DECIMAL(10,2),
    precio_nuevo DECIMAL(10,2),
    fecha_cambio DATETIME,
    FOREIGN KEY (id_pizza) REFERENCES pizzas(id)
);
-- trigger
DELIMITER //
CREATE TRIGGER auditoria_precios
BEFORE UPDATE ON pizzas
FOR EACH ROW
BEGIN
    IF NEW.precio_unitario <> OLD.precio_unitario THEN
        INSERT INTO historial_precios(id_pizza, precio_anterior, precio_nuevo, fecha_cambio)
        VALUES (OLD.id, OLD.precio_unitario, NEW.precio_unitario, NOW());
    END IF;
END //
DELIMITER ;
-- /// para probar el trigger /// --
SELECT * FROM pizzas WHERE id = 5;
UPDATE pizzas SET precio_unitario = 25000 WHERE id = 5;
SELECT * FROM historial_precios ORDER BY fecha_cambio DESC;


-- Trigger para marcar repartidor como “disponible” nuevamente cuando termina un domicilio, añadiendo tambien el cambio automatico de estado del pedido a “entregado”
DELIMITER //
CREATE TRIGGER tr_entrega_domicilio
AFTER UPDATE ON domicilios
FOR EACH ROW
BEGIN
    -- si la hora_entrega fue registrada
    IF NEW.hora_entrega IS NOT NULL AND OLD.hora_entrega IS NULL THEN      
        -- marcar el pedido como entregado
        UPDATE pedidos SET estado = 'entregado' WHERE id = NEW.id_pedido;
        -- cambiar estado del repartidor a disponible
        UPDATE repartidores SET estado = 'disponible' WHERE id = NEW.id_repartidor;
    END IF;
END //
DELIMITER ;
-- /// para probar el trigger /// --
INSERT INTO pedidos (fecha_hora, entrega, estado, total, id_cliente) VALUES (NOW(), 'domicilio', 'pendiente', 0, 1);
SELECT LAST_INSERT_ID() AS pedido_creado;
SELECT id, estado FROM repartidores WHERE id = 12;
INSERT INTO domicilios(hora_salida,hora_entrega,precio_envio,total_domicilio,id_repartidor,id_pedido,id_vendedor) VALUES(NOW(),NULL,0,0,12,12,18); -- colocar el id_pedido que corresponda
select * from domicilios;
UPDATE domicilios SET hora_entrega = NOW() WHERE id = 11; -- id domicilios que corresponda
select * from domicilios;
SELECT id, estado FROM pedidos WHERE id = 12; -- id pedido que corresponda
SELECT id, estado FROM repartidores WHERE id = 12;