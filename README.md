# Proyecto Pizzeria Don Piccolo.

    Juan David Barrera Torres
    S1

    CAMPUSLANDS
    CAJASAN
    BUCARAMANGA
    2025

## Estructura Del Proyecto.
    /pizzeria-don-piccolo/
     ├── database.sql
     ├── funciones.sql
     ├── triggers.sql
     ├── vistas.sql
     ├── consultas.sql
     └── README.md

## Introducción.
La presente documentación describe el diseño y construcción de la base de datos del sistema de gestión de pedidos y domicilios de la empresa Pizzería Don Piccolo.
El propósito de este sistema es mejorar el control sobre los clientes, pedidos, pizzas, ingredientes, repartidores, domicilios y pagos, reduciendo errores y optimizando el tiempo de atención.

El proyecto contempla la elaboración de un modelo entidad–relación (ER), un modelo lógico normalizado y la definición de las tablas requeridas para su implementación en MySQL.

## Caso de Estudio.
Pizzería Don Piccolo manejaba sus pedidos de forma manual, lo que generaba retrasos en la preparación de pedidos, información inconsistente sobre clientes, falta de control sobre inventario mala asignación de repartidores y dificultad para calcular pagos y costos

El nuevo sistema debe permitir:

- Registrar clientes
- Registrar pedidos de pizzas
- Controlar ingredientes y su stock
- Gestionar repartidores y zonas de entrega
- Registrar domicilios asociados a pedidos
- Registrar pagos y totales
- Calcular costos como subtotal, envío e IVA
- Consultas analíticas como pizzas más vendidas, clientes frecuentes, etc.

## Construcción del Modelo E.R 
### ¿Qué es un Modelo E.R?

El Modelo Entidad–Relación (ER) es una representación gráfica usada en el diseño de bases de datos para mostrar:

- Las entidades (objetos del negocio: Cliente, Pedido, Pizza, etc.)

- Sus atributos (nombre, precio, estado, stock…)

- Las relaciones entre ellas (un pedido contiene muchas pizzas)

Este modelo permite comprender el sistema de manera visual antes de crear las tablas.

### Gráfica.
![](Captura%20desde%202025-12-02%2011-11-20.png)

### Descripción. 
El modelo ER de Pizzería Don Piccolo está compuesto por las siguientes entidades:

- Persona: contiene datos básicos como nombre, teléfono, dirección y correo.

- Cliente: especialización de Persona; representa a los compradores.

- Vendedor: el empleado que toma el pedido en el sistema.

- Repartidor: encargado de entregar los domicilios.

- Pedidos: registra toda la información del pedido realizado.

- Detalle_pedidos: tabla intermedia entre pedidos y pizzas.

- Pizzas: catálogo de pizzas disponibles.

- Ingredientes: insumos usados para las pizzas.

- Pizza_ingredientes: tabla intermedia que relaciona pizzas con ingredientes.

- Zona: zonas de cobertura con costo fijo de domicilio.

- Domicilios: información del envío de un pedido.

- Pago: tabla donde se registra el pago final del pedido.

Cada entidad está relacionada de acuerdo con el flujo real del negocio.

### Descripción Técnica
A nivel técnico:

- El motor de base de datos utilizado es MySQL.

- Se implementaron claves primarias compuestas en tablas intermedias.

- Se aplicó normalización hasta 3NF para evitar redundancia.

- Se utilizaron claves foráneas para mantener integridad referencial.

- Enumeraciones (ENUM) se usaron para controlar estados y métodos de pago.

- Se mantuvo consistencia en tipos de datos y restricciones NOT NULL.

## Normalización del Modelo Lógico
¿Qué es la normalización?

La normalización es un proceso que organiza la información en una base de datos para:

- Reducir redundancia

- Evitar inconsistencias

- Garantizar integridad

- ptimizar el funcionamiento del sistema

La normalización se aplica por formas normales (NF).
En este proyecto se aplica hasta la Tercera Forma Normal (3NF), recomendada para sistemas transaccionales.

### La primera forma normal – 1NF 
Un modelo está en Primera Forma Normal si:

- No hay grupos repetitivos

- Cada columna contiene solo un valor atómico

- No hay listas o campos multivaluados

- Todas las filas son identificables por una clave primaria

**¿Cómo se aplica en la base de datos?** 

✔ Cada entidad tiene una clave primaria

✔ No existen columnas con valores múltiples (por ejemplo ingredientes separados por comas)

✔ Las tablas intermedias solucionan relaciones N:M

✔ Todos los atributos contienen datos atómicos

**Ejemplos:**

- Ingredientes por pizza → se normaliza mediante pizza_ingredientes

- Pizzas en un pedido → se normaliza mediante detalle_pedidos

### La segunda forma normal – 2NF
Una tabla está en Segunda Forma Normal si:

- Está en 1NF

- Todos los atributos dependen completamente de la clave primaria

- No existen dependencias parciales en claves compuestas

**Aplicación en la base de datos**

✔ Las tablas con claves compuestas (detalle_pedidos, pizza_ingredientes) NO contienen atributos que dependan solo de una parte de la clave.

**Ejemplos:**

- En detalle_pedidos, subtotal depende de (id_pedido, id_pizza)

- En pizza_ingredientes, cantidad_ingrediente depende de la combinación completa

Ningún atributo depende solo de id_pedido o solo de id_pizza.

### La tercera forma normal – 3NF
Una tabla está en Tercera Forma Normal si:

- Está en 2NF

- No hay dependencias transitivas (A depende de B, que depende de C)

**Aplicación en la base de datos**

✔ No existen columnas que dependan de otras que no son la clave.

**Ejemplos:**

- En pago, el IVA y el total dependen solo del id_pedido

- En domicilios, el costo del envío depende solo de la zona asociada

- En ingredientes, el costo unitario depende solo del ingrediente, no de otra entidad

No hay atributos calculados que generen dependencias no deseadas.