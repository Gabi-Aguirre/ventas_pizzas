create database local_pizza;

-- Recuperar el número total de pedidos realizados.

select count(order_id) AS orden_total from orders;

-- Calcule los ingresos totales generados por las ventas de pizza.
SELECT 
    ROUND(SUM(order_datails.quantity * pizzas.price),
            2) AS ventas_totales
FROM
    order_datails
        JOIN
    pizzas ON pizzas.pizza_id = order_datails.pizza_id;
    
    
-- Identifica la pizza con el precio más alto.

SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;


-- Identifique el tamaño de pizza más común solicitado.
SELECT 
    pizzas.size,
    COUNT(order_datails.order_datails_id) AS conteo_tamaño
FROM
    pizzas
        JOIN
    order_datails ON pizzas.pizza_id = order_datails.pizza_id
GROUP BY pizzas.size
ORDER BY conteo_tamaño DESC;


-- Enumere los 5 tipos de pizza más pedidos
-- junto con sus cantidades.
SELECT 
    pizza_types.name, SUM(order_datails.quantity) AS cantidad
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_datails ON order_datails.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY cantidad DESC
LIMIT 5;