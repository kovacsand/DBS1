SET SCHEMA 'dvdrental';

--Question 1
SELECT actor_id
FROM actor
WHERE first_name = 'Scarlett' AND last_name = 'Bening';

--Question 2
SELECT actor_id, COUNT(*) AS number_of_films
FROM film_actor
GROUP BY actor_id
ORDER BY COUNT(*) DESC
LIMIT 1;

--Question 3
SELECT country
FROM country
JOIN city c on country.country_id = c.country_id
JOIN address a on c.city_id = a.city_id
JOIN store s on a.address_id = s.address_id;

--Question 4
SELECT first_name, last_name
FROM customer
JOIN rental r on customer.customer_id = r.customer_id
JOIN inventory i on r.inventory_id = i.inventory_id
JOIN film f on i.film_id = f.film_id
WHERE rating = 'R'
GROUP BY first_name, last_name
ORDER BY COUNT(*) DESC
LIMIT 2;

--Question 5
SELECT COUNT(*)
FROM actor
WHERE last_name IN (
    SELECT last_name
    FROM actor
    GROUP BY last_name
    HAVING COUNT(*) > 1
);

--Question 6
SELECT first_name, last_name, SUM(amount)
FROM customer
JOIN payment p on customer.customer_id = p.customer_id
GROUP BY first_name, last_name
ORDER BY SUM(amount) DESC
LIMIT 1;

--Question 7
SELECT AVG(length)
FROM film;

SELECT ROUND(AVG(length), 2), name
FROM film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
GROUP BY name
ORDER BY AVG(length) DESC
LIMIT 5;

--Question 8
SELECT *
FROM film
         NATURAL JOIN inventory;

--Question 8
SELECT *
FROM film
NATURAL JOIN inventory;

SELECT *
FROM film
WHERE film.last_update IN (
    SELECT last_update
    FROM inventory
);

SELECT *
FROM film
WHERE film_id IN (
    SELECT film_id
    FROM inventory
);

--Question 9
SELECT COUNT(*)
FROM payment
JOIN customer c on c.customer_id = payment.customer_id
WHERE first_name = 'Willie';