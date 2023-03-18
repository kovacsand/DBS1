SET SCHEMA 'dvdrental';

--Q1 List of all stores
SELECT *
FROM store;

--Q2 List of films (title and description) longer than 120 minutes.
SELECT title, description
FROM film
WHERE length > 120;

--Q3 addresses of each store?
SELECT *
FROM address
WHERE address_id IN (
    SELECT address_id
    FROM store
);

--Q4 name of the customer who lives in the city 'Apeldoorn'
SELECT first_name, last_name
FROM customer
WHERE address_id IN (
    SELECT address_id
    FROM address
    WHERE city_id IN (
        SELECT city_id
        FROM city
        WHERE city = 'Apeldoorn'
        )
    );

--Q5 categories of the film 'ARABIA DOGMA'
SELECT name
FROM category
WHERE category_id IN (
    SELECT category_id
    FROM film_category
    WHERE film_id IN (
        SELECT film_id
        FROM film
        WHERE title = 'ARABIA DOGMA'
        )
    );

--Q6 Which actors (their names) were in the film 'INTERVIEW LIAISONS'?
SELECT first_name, last_name
FROM actor
WHERE actor_id IN (
    SELECT actor_id
    FROM film_actor
    WHERE film_id IN (
        SELECT film_id
        FROM film
        WHERE title = 'INTERVIEW LIAISONS'
        )
    );

--Q7 name of the staff who rented a copy of 'HUNCHBACK IMPOSSIBLE' to customer KURT EMMONS?
SELECT first_name, last_name
FROM staff
WHERE staff_id = (
    SELECT staff_id
    FROM rental
    WHERE customer_id = (SELECT customer_id FROM customer WHERE customer.first_name = 'KURT' AND customer.last_name = 'EMMONS')
        AND inventory_id IN (
            SELECT inventory_id
            FROM inventory
            WHERE film_id = (SELECT film_id FROM film WHERE title = 'HUNCHBACK IMPOSSIBLE')
        )
    );


--Q8 how many inventory items are available at each store
SELECT COUNT(inventory_id)
FROM inventory
GROUP BY store_id;

--Q9 How many times have VIVIAN RUIZ rented something?
SELECT COUNT(*)
FROM rental
WHERE customer_id = (
    SELECT customer_id
    FROM customer
    WHERE first_name = 'VIVIAN' AND last_name = 'RUIZ'
    );





--EXAM CASES
SELECT title
FROM film
WHERE rating = 'R' AND rental_duration = 8;

SELECT first_name, last_name
FROM customer JOIN rental r on customer.customer_id = r.customer_id
WHERE EXTRACT(year FROM rental_date) = 2005 AND EXTRACT(month FROM rental_date) = 6 AND EXTRACT(day FROM rental_date) = 14
ORDER BY last_name;

SELECT film_id, title
FROM film
WHERE film_id NOT IN (
    SELECT film_id
    FROM inventory
    )
ORDER BY title;