use sakila;

SELECT f.title
FROM film as f
WHERE not exists(SELECT i.film_id FROM inventory as i where i.film_id = f.film_id);

SELECT f.title, i2.inventory_id
FROM film as f
         INNER JOIN inventory i2 on f.film_id = i2.film_id
WHERE exists(SELECT i.film_id
             FROM inventory as i
             WHERE i.film_id = f.film_id
               AND not exists(SELECT r.inventory_id FROM rental as r WHERE r.inventory_id = i.inventory_id));


SELECT c.first_name, c.last_name, s.store_id, f.title
FROM customer as c
INNER JOIN store s on c.store_id = s.store_id
INNER JOIN inventory i on s.store_id = i.store_id
INNER JOIN film f on i.film_id = f.film_id
WHERE exists(SELECT r.customer_id FROM rental as r where c.customer_id = r.customer_id AND r.return_date is not null);


SELECT s.store_id, sum(p.amount) as `total_sales($)`
FROM store as s
         INNER JOIN inventory i on s.store_id = i.store_id
         INNER JOIN rental r on i.inventory_id = r.inventory_id
         INNER JOIN payment p on r.rental_id = p.rental_id
group by s.store_id;

SELECT fa.actor_id, a.first_name, a.last_name, count(*) as film
FROM film_actor as fa
         INNER JOIN actor a on fa.actor_id = a.actor_id
group by fa.actor_id
order by 4 desc;
