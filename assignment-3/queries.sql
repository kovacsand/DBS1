SET SCHEMA 'dvdrental';

--Question 1
SELECT title
FROM film
WHERE rating = 'R' AND rental_duration >= 8;
--No such movies

--Question 2
SELECT film_id, title, rating
FROM film
WHERE title = 'Highball Potter';
--TODO change the rating to G from R

UPDATE film
SET rating = 'G'
WHERE title = 'Highball Potter';


--Question 3
SELECT first_name, last_name
FROM customer
WHERE customer_id IN (
    SELECT customer_id
    FROM rental
    WHERE rental_date BETWEEN '2005-06-14' AND '2005-06-15'
)
ORDER BY last_name;

--Question 4
SELECT film_id, title
FROM film
WHERE film_id NOT IN (
    SELECT DISTINCT film_id
    FROM inventory
)
ORDER BY title;
--42 movies are not in inventory

--Question 5
SELECT first_name, last_name
FROM customer
WHERE last_name LIKE ('%Q%') OR last_name LIKE ('%q%');
--7 customer with Q or q in their last name

--Question 6
SELECT film_id, title
FROM film
WHERE film_id IN
(
    SELECT film_id
    FROM inventory
    WHERE inventory_id IN (
        SELECT inventory_id
        FROM rental
        WHERE return_date IS NULL
))
ORDER BY title;
--If a movie hasn't been rented out yet at all, does that mean that it hasn't been returned either?
--Based on the possible answers, it does not

--Question 7
SELECT c.customer_id, SUM(rental_rate)
FROM customer AS c, rental AS r, inventory AS i, film AS f
WHERE c.customer_id = r.customer_id AND r.inventory_id = i.inventory_id AND i.film_id = f.film_id
GROUP BY c.customer_id
ORDER BY SUM(rental_rate) DESC;
--Looks like no customer has a total payment between 180 and 240 :/
--But it's probably a wrong solution, because I'm using the film to get the rental_date instead of the payment table

SELECT customer_id, SUM(amount)
FROM payment
GROUP BY customer_id
HAVING SUM(amount) BETWEEN 180 AND 240
ORDER BY SUM(amount) DESC;
--This is using the payment table and I have 6 customers

SELECT first_name, last_name
FROM customer
WHERE customer_id IN (
    SELECT customer_id
    FROM payment
    GROUP BY customer_id
    HAVING SUM(amount) BETWEEN 180 AND 240
);

--Question 8
SELECT c.name, SUM(rental_rate)
FROM category AS c, film_category AS fc, film AS f, inventory AS i, rental AS r
WHERE c.category_id = fc.category_id AND fc.film_id = f.film_id AND f.film_id = i.film_id AND r.inventory_id = i.film_id
GROUP BY c.name
ORDER BY SUM(rental_rate) DESC
LIMIT 5;
--This is not on the list :(
--Again, wrong solution, it doesn't use the payment table

SELECT c.name, SUM(amount)
FROM category AS c, film_category AS fc, film AS f, inventory AS i, rental AS r, payment AS p
WHERE c.category_id = fc.category_id AND fc.film_id = f.film_id AND f.film_id = i.film_id AND i.inventory_id = r.inventory_id AND r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY SUM(amount) DESC
LIMIT 5;
--Yay, this is correct

DROP VIEW top_five_genres;

CREATE VIEW top_five_genres AS
SELECT c.name, SUM(amount)
FROM category AS c, film_category AS fc, film AS f, inventory AS i, rental AS r, payment AS p
WHERE c.category_id = fc.category_id AND fc.film_id = f.film_id AND f.film_id = i.film_id AND i.inventory_id = r.inventory_id AND r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY SUM(amount) DESC
LIMIT 5;

SELECT * FROM top_five_genres;

--Question 10
--Incorrect on WiseFlow, the FROM should be city, not country
SELECT city_id, city
FROM city
WHERE country_id IN
(   SELECT country_id
    FROM country
    WHERE country
    IN ('Canada', 'Mexico'));


--Question 11
SELECT customer_id, COUNT(*)
FROM rental
GROUP BY customer_id
HAVING COUNT(*) > ALL
    (SELECT COUNT(*)
     FROM rental r
        INNER JOIN customer c on c.customer_id = r.customer_id
        INNER JOIN address a on a.address_id = c.address_id
        INNER JOIN city ct on ct.city_id = a.city_id
        INNER JOIN country co on co.country_id = ct.country_id
     WHERE co.country IN ('United States', 'Mexico', 'Canada')
     GROUP BY r.customer_id
    );
--I'm a bit confused about all and any in the answers