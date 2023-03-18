/* SQL SUBQUERIES

- one row, one column
- many rows, one column
- many rows, many columns

A subquery is a query (= inner query) that is nested into another query (= outer query) and is executed before the outer

Consider: */

SET SCHEMA 'dvdrental';

SELECT customer_id, first_name, last_name
FROM customer
WHERE customer_id = (SELECT MAX(customer_id) FROM customer);

-- If we only look at the subquery itself

SELECT MAX(customer_id)
FROM customer;

-- i.e. we have actually "only" written

SELECT customer_id, first_name, last_name
FROM customer
WHERE customer_id = 599;

/* TYPES OF SUBQUERIES

noncorrelated: the subquery operates independently of the outer query
correlated: the subquery points to columns in the outer query and therefore cannot stand alone

NONCORRELATED

The following is an example of a scalar subquery

 */
SELECT city_id, city
FROM city
WHERE country_id <>
      (SELECT country_id FROM country WHERE country = 'India');

-- What does this query return?

-- If one had returned several rows in the subquery above, we would get an error:
SELECT city_id, city
FROM city
WHERE country_id <>
      (SELECT country_id
       FROM country
       WHERE country <> 'India');

-- Here's the subquery alone
SELECT country_id
FROM country
WHERE country <> 'India';

-- MANY ROWS, SINGLE COLUMN --
-- However, there are four operators we can use if our sub contains multiple rows
-- IN and NOT IN
-- ALL and ANY

-- We have already seen examples of the use of IN
SELECT country_id
FROM country
WHERE country IN ('Canada', 'Mexico');

-- What does this query return? Could be replaced with OR

-- What if we would like to use this list in a condition to inquire about
-- something completely third? consider
SELECT city_id, city
FROM city
WHERE country_id IN
      (SELECT country_id
       FROM country
       WHERE country IN ('Canada', 'Mexico'));
-- What does this query return?

-- But what if we want all the cities that are not in Canada or Mexico
SELECT city_id, city
FROM city
WHERE country_id NOT IN
      (SELECT country_id
       FROM country
       WHERE country IN ('Canada', 'Mexico'));

-- ALL should always be used with a comparison
SELECT first_name, last_name
FROM customer
WHERE customer_id <> ALL
      (SELECT customer_id
       FROM payment
       WHERE amount = 0);
-- The above returns all customers who have never received a film for DKK 0, ie. for free

-- We could have also done
SELECT first_name, last_name
FROM customer
WHERE customer_id NOT IN
      (SELECT customer_id
       FROM payment
       WHERE amount = 0);
-- ALL can in some cases be the same as NOT IN.

-- Is the above the same as the one below?
SELECT first_name, last_name
FROM customer
WHERE customer_id IN
      (SELECT customer_id
       FROM payment
       WHERE amount != 0);

-- Here is a slightly more complex example
SELECT customer_id, COUNT(*)
FROM rental
GROUP BY customer_id
HAVING COUNT(*) > ALL
       (SELECT COUNT(*)
        FROM rental r
                 INNER JOIN customer c ON r.customer_id = c.customer_id
                 INNER JOIN address a ON c.address_id = a.address_id
                 INNER JOIN city ct ON a.city_id = ct.city_id
                 INNER JOIN country co ON ct.country_id = co.country_id
        WHERE co.country IN ('United States', 'Mexico', 'Canada')
        GROUP BY r.customer_id
       );

-- Lad os undersøge subquery'en
SELECT COUNT(*)
FROM rental r
         INNER JOIN customer c ON r.customer_id = c.customer_id
         INNER JOIN address a ON c.address_id = a.address_id
         INNER JOIN city ct ON a.city_id = ct.city_id
         INNER JOIN country co ON ct.country_id = co.country_id
WHERE co.country IN ('United States', 'Mexico', 'Canada')
GROUP BY r.customer_id;
-- It returns how many movies each customer in North America has rented.
-- The external then returns the customers who have rented more films than any / all of the
-- North American customer, yes there is only 1 who meets this condition.


-- In the above, customers should have rented more movies than all of the North American ones
-- What if we just wanted the customers who have rented more movies than any of the North Americans?

SELECT r.customer_id, COUNT(*)
FROM rental r
         INNER JOIN customer c ON r.customer_id = c.customer_id
         INNER JOIN address a ON c.address_id = a.address_id
         INNER JOIN city ct ON a.city_id = ct.city_id
         INNER JOIN country co ON ct.country_id = co.country_id
WHERE country NOT IN ('United States', 'Mexico', 'Canada')
GROUP BY r.customer_id
HAVING COUNT(*) > ANY
       (SELECT COUNT(*)
        FROM rental r
                 INNER JOIN customer c ON r.customer_id = c.customer_id
                 INNER JOIN address a ON c.address_id = a.address_id
                 INNER JOIN city ct ON a.city_id = ct.city_id
                 INNER JOIN country co ON ct.country_id = co.country_id
        WHERE co.country IN ('United States', 'Mexico', 'Canada')
        GROUP BY r.customer_id
       );

-- Here is that another example
SELECT customer_id, SUM(amount)
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > ANY
       (SELECT SUM(p.amount)
        FROM payment p
                 INNER JOIN customer c ON p.customer_id = c.customer_id
                 INNER JOIN address a ON c.address_id = a.address_id
                 INNER JOIN city ct ON a.city_id = ct.city_id
                 INNER JOIN country co ON ct.country_id = co.country_id
        WHERE co.country IN ('Bolivia', 'Paraguay', 'Chile')
        GROUP BY co.country
       );

-- Let us first look at the sub
SELECT SUM(p.amount)
FROM payment p
         INNER JOIN customer c ON p.customer_id = c.customer_id
         INNER JOIN address a ON c.address_id = a.address_id
         INNER JOIN city ct ON a.city_id = ct.city_id
         INNER JOIN country co ON ct.country_id = co.country_id
WHERE co.country IN ('Bolivia', 'Paraguay', 'Chile')
GROUP BY co.country;

-- It returns the sum of rental costs for each of the three countries
-- The outer now returns all the customers who have spent MORE than each of
-- these countries!!

-- MANY ROWS, MANY COLUMNS -
-- In the following example, two subqueries are used to create a total subquery on two columns
SELECT fa.actor_id, fa.film_id
FROM film_actor fa
WHERE fa.actor_id IN
      (SELECT actor_id FROM actor WHERE last_name = 'MONROE')
  AND fa.film_id IN
      (SELECT film_id FROM film WHERE rating = 'PG');

-- Let us look at each sub
SELECT actor_id
FROM actor
WHERE last_name = 'MONROE';
SELECT film_id
FROM film
WHERE rating = 'PG';
-- So actor Monroe and not for children.
-- The outer then selects all the films in which MONROE is in a film unsuitable for children

-- NOTE: IN and '= ANY' gives the same result. Often IN is preferred

/* CORRELATED */
-- So this is where the sub depends on the outer and we can not run the sub without the outer
SELECT c.first_name, c.last_name
FROM customer c
WHERE 20 =
      (SELECT COUNT(*)
       FROM rental r
       WHERE r.customer_id = c.customer_id);

-- Let's run the sub
SELECT COUNT(*)
FROM rental r
WHERE r.customer_id = c.customer_id;
-- Hvad med et Join
SELECT r.customer_id, COUNT(*)
FROM rental r
         JOIN customer c ON r.customer_id = c.customer_id
GROUP BY r.customer_id;

-- Not possible

-- Another
SELECT c.first_name, c.last_name
FROM customer c
WHERE (SELECT SUM(p.amount)
       FROM payment p
       WHERE p.customer_id = c.customer_id)
          BETWEEN 180 AND 240;
-- All customers who have a total rental cost of between 180 and 240

-- The most frequently used operator in correlated subqueries is the EXISTS operator
SELECT c.first_name, c.last_name
FROM customer c
WHERE EXISTS
          (SELECT *
           FROM rental r
           WHERE r.customer_id = c.customer_id
             AND date(r.rental_date) < '2005-05-25');

-- You use EXISTS when you want to show that a relationship exists regardless of number.
-- In the example above, we find all customers who have rented at least 1 movie before May 25, 2005
-- regardless of how many movies were rented.
-- It can also be useful to use NOT EXIST

SELECT a.first_name, a.last_name
FROM actor a
WHERE NOT EXISTS
    (SELECT *
     FROM film_actor fa
              INNER JOIN film f ON f.film_id = fa.film_id
     WHERE fa.actor_id = a.actor_id
       AND f.rating = 'R');

-- The above finds all actor who have not been in an R-rated film.
-- You make a sub with actors who have been with and actors who are not
-- in that query.