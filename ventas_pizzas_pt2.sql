-- Une las tablas necesarias para encontrar la cantidad total
-- de cada categoría de pizza solicitada.

SELECT 
    pizza_types.category,
    SUM(order_datails.quantity) AS cantidad
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_datails ON order_datails.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY cantidad DESC;

-- Determinar la distribución de pedidos por hora del día.

SELECT 
    HOUR(order_time) AS hour, COUNT(order_id) AS orden_conteo
FROM
    orders
GROUP BY HOUR(order_time);


-- Une las tablas relevantes para encontrar la distribución de pizzas por categoría.

SELECT 
    category, COUNT(name)
FROM
    pizza_types
GROUP BY category;


-- Agrupa los pedidos por fecha y calcula el número promedio de pizzas pedidas por día.

SELECT 
round(AVG(cantidad),0) AS prom_pizzas_pedidas
FROM
    (SELECT 
        orders.order_date, SUM(order_datails.quantity) AS cantidad
    FROM
        orders
    JOIN order_datails ON orders.order_id = order_datails.order_id
    GROUP BY orders.order_date) AS cantidad_pedidos;
    
-- Determinar los 3 tipos de pizza más pedidos según los ingresos.

SELECT 
    pizza_types.name,
    SUM(order_datails.quantity * pizzas.price) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_datails ON order_datails.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY revenue DESC
LIMIT 3;


-- Calcule la contribución porcentual de cada tipo de pizza a los ingresos totales.
SELECT 
    pizza_types.category,
    round((SUM(order_datails.quantity * pizzas.price) / (SELECT 
            ROUND(SUM(order_datails.quantity * pizzas.price),
                        2) AS ventas_totales
        FROM
            order_datails
                JOIN
            pizzas ON pizzas.pizza_id = order_datails.pizza_id) )*100,2) AS ingresos
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_datails ON order_datails.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY ingresos DESC;


-- Analizar los ingresos acumulados generados a lo largo del tiempo.

select order_date,
sum(ingresos) over(order by order_date) as cum_revenue
from
(select orders.order_date,
sum(order_datails.quantity * pizzas.price) as ingresos
from order_datails join pizzas
on order_datails.pizza_id = pizzas.pizza_id
join orders
on orders.order_id = order_datails.order_id
group by orders.order_date) as ventas;


-- Determinar los 3 tipos de pizza más pedidos en función de los ingresos de cada categoría de pizza. 


select name, ingresos from
(select category, name, ingresos,
rank() over (partition by category order by ingresos desc) as rn
from
(select pizza_types.category, pizza_types.name,
sum((order_datails.quantity) * pizzas.price) as ingresos
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_datails
on order_datails.pizza_id = pizzas.pizza_id
group by pizza_types.category, pizza_types.name) as a) as b
where rn <= 3;