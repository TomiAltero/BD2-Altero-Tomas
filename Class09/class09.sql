--ejercicio 1
SELECT co.country_id AS 'Country ID', co.country AS 'Country', COUNT(ci.city_id) AS 'Cantidad Ciudades'
FROM city ci
INNER JOIN country co ON ci.country_id=co.country_id
GROUP BY co.country_id;

--ejercicio 2
select co.country, count(*) as amount_cities from city ci
inner join country co on co.country_id = ci.country_id
group by co.country_id
having 10<amount_cities
order by amount_cities desc;

--ejercicio 3
select first_name,last_name,a.*, 
(select count(*) from rental r where r.customer_id=c.customer_id) as total_films_rented, 
(select sum(amount) from payment p where p.customer_id=c.customer_id) as total_money_spent 
from customer c
inner join address a on c.address_id=a.address_id
order by total_money_spent desc; 

--ejercicio 4
SELECT c.`name` AS 'Nombre', AVG(f.`length`)
FROM category c
INNER JOIN film_category fc ON c.category_id = fc.category_id
INNER JOIN film f ON fc.film_id = f.film_id
GROUP BY c.`name`
ORDER BY AVG(f.`length`) DESC;

--ejercicio 5
SELECT f.rating AS 'Rating', SUM(p.amount) AS 'Gasto Total'
FROM film f
INNER JOIN inventory i ON f.film_id = i.film_id
INNER JOIN rental r ON i.inventory_id = r.inventory_id
INNER JOIN payment p ON r.rental_id = p.rental_id
GROUP BY f.rating
ORDER BY SUM(p.amount) DESC;
