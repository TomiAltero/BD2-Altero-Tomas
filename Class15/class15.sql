USE sakila;

-- QUERY 1
-- Crear una vista llamada list_of_customers, que contenga las siguientes columnas:
-- ID del cliente, nombre completo, dirección, código postal, teléfono,
-- ciudad, país, estado (activo/inactivo), y el ID de la tienda.

CREATE VIEW list_of_customers AS 
	SELECT cus.customer_id AS 'Customer ID', 
           CONCAT(cus.first_name, ' ', cus.last_name) AS 'Customer Name',
           a.address AS 'Address', 
           a.postal_code AS 'Zip code', 
           a.phone AS 'Phone', 
           ci.city AS 'City', 
           co.country AS 'Country',
           CASE WHEN cus.active = 1 THEN 'active' ELSE 'inactive' END AS 'Status', 
           cus.store_id AS 'Store ID' 
    FROM customer cus 
    INNER JOIN address a USING (address_id) 
    INNER JOIN city ci USING (city_id) 
    INNER JOIN country co USING (country_id);

SELECT * FROM list_of_customers;

-- QUERY 2
-- Crear una vista llamada film_details con las siguientes columnas:
-- ID de la película, título, descripción, categoría, precio, duración,
-- calificación, y actores (como una cadena separada por comas).

CREATE VIEW film_details AS
	SELECT f.film_id AS 'Film ID', 
           f.title AS 'Title', 
           f.description AS 'Description', 
           cat.name AS 'Category', 
           f.rental_rate AS 'Price',
           f.length AS 'Length', 
           f.rating AS 'Rating', 
           GROUP_CONCAT(' ', a.first_name, ' ', a.last_name) AS 'Actors'
    FROM film f 
    INNER JOIN film_category fc USING (film_id) 
    INNER JOIN category cat USING (category_id) 
    INNER JOIN film_actor fa USING (film_id) 
    INNER JOIN actor a USING (actor_id) 
    GROUP BY f.film_id, cat.name;

SELECT * FROM film_details;
DROP VIEW film_details;

-- QUERY 3
-- Crear una vista llamada sales_by_film_category que devuelva las columnas
-- categoría y total de alquileres por cada categoría de película.

CREATE VIEW sales_by_film_category_the_sequel AS
	SELECT c.name AS 'Category', 
           COUNT(r.rental_id) AS 'Total_rental' 
    FROM category c 
    INNER JOIN film_category USING (category_id) 
    INNER JOIN film f USING (film_id) 
    INNER JOIN inventory i USING (film_id) 
    INNER JOIN rental r USING (inventory_id) 
    GROUP BY c.category_id;

SELECT * FROM sales_by_film_category_the_sequel;

-- QUERY 4
-- Crear una vista llamada actor_information que muestre el ID del actor,
-- su nombre, apellido y el número de películas en las que ha actuado.

CREATE VIEW actor_information AS
	SELECT a.actor_id AS 'Actor ID', 
           a.first_name AS 'Name', 
           a.last_name AS 'Surname', 
           COUNT(fa.film_id) AS 'Films acted'
    FROM actor a 
    INNER JOIN film_actor fa USING (actor_id) 
    GROUP BY a.actor_id;

SELECT * FROM actor_information;

-- QUERY 5
-- Explicar la vista actor_info y el funcionamiento de la subconsulta.

SELECT * FROM actor_info;

/*
Esta vista tiene como objetivo mostrar información detallada de cada actor y las películas en las que han participado, agrupadas por categoría. 
El resultado incluye el ID del actor, su nombre y un campo llamado 'film_info' que combina las categorías y una lista de películas en las que ha actuado el actor.

El subquery encargado de construir 'film_info' funciona de la siguiente manera:
1. `GROUP_CONCAT` externo une el nombre de cada categoría con el resultado de la subconsulta interna.
2. La subconsulta interna obtiene todos los títulos de películas en las que el actor ha trabajado, filtrando por la categoría correspondiente y ordenando alfabéticamente.

De esta forma, el resultado final es una cadena en formato [categoría: película1, película2,...] para cada actor, permitiendo tener una visión global de su participación en distintas películas agrupadas por categoría.
*/

-- QUERY 6
-- Describir qué son las vistas materializadas y en qué situaciones son útiles.

-- Descripción sobre las vistas materializadas:

/*
Las vistas materializadas almacenan físicamente los resultados de una consulta en el disco, lo que las hace muy eficientes para acceder a grandes conjuntos de datos. 
A diferencia de las vistas convencionales, que generan los datos en el momento de la consulta, las vistas materializadas mantienen la información preprocesada y lista para ser consultada.

Estas vistas son útiles cuando las consultas son costosas en términos de tiempo y recursos, como cuando hay múltiples combinaciones de tablas o cálculos complejos. 
Sin embargo, dado que no se actualizan automáticamente, necesitan ser refrescadas manualmente para garantizar que los datos estén actualizados.

Algunos sistemas que soportan vistas materializadas son Oracle, PostgreSQL, Snowflake y BigQuery. En MySQL, aunque no se implementan de forma nativa, es posible simularlas utilizando triggers y tablas temporales para almacenar los resultados de consultas.
*/
