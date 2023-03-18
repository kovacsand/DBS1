SET SCHEMA 'webshop';

--Q1 all customers whose first name starts with 'Jo'
SELECT customer_id, first_name, middle_name, last_name
FROM customer
WHERE first_name LIKE 'Jo%';

--Q2 first name contains 'ella' and who does not have a middle name
SELECT customer_id, first_name, middle_name, last_name
FROM customer
WHERE first_name LIKE '%ella%'
  AND middle_name IS NULL;

--Q3 customers who have ordered more than 4 items
SELECT first_name, last_name, COUNT(*)
FROM customer
         JOIN "order" o on customer.customer_id = o.customer_id
GROUP BY first_name, last_name
HAVING COUNT(*) > 4
ORDER BY COUNT(*) DESC, first_name;

--Q4 customer id of Neysa Aldins
SELECT customer_id
FROM customer
WHERE first_name = 'Neysa'
  AND last_name = 'Aldins';

--Q5 price of the most expensive product
SELECT product_price
FROM product
ORDER BY product_price DESC
LIMIT 1;

--Q6 most expensive product
SELECT product_id, product_name, product_price
FROM product
ORDER BY product_price DESC
LIMIT 1;

--Q7 the sum of the quantity ordered of the most expensive product
SELECT SUM(orderedproduct.quantity)
FROM orderedproduct
         JOIN product p on orderedproduct.product_id = p.product_id
WHERE p.product_id = (
    SELECT product.product_id
    FROM product
    ORDER BY product_price DESC
    LIMIT 1
);

--Q8 Who have ordered the most expensive product
SELECT CONCAT_WS(' ', first_name, middle_name, last_name)
FROM customer
         JOIN "order" o on customer.customer_id = o.customer_id
         JOIN orderedproduct o2 on o.order_id = o2.order_id
         JOIN product p on o2.product_id = p.product_id
WHERE p.product_id =
      (
          SELECT product.product_id
          FROM product
          ORDER BY product_price DESC
          LIMIT 1
      );

--Q9 the first name of all female customers whose last name's second letter is 'o', and who were born in the eighties
SELECT first_name
FROM customer
WHERE gender = 'F'
  AND last_name LIKE '_o%'
  AND EXTRACT(YEAR FROM birthdate) BETWEEN 1980 AND 1989;

--Q10 How many customers have not placed any orders?
SELECT COUNT(*)
FROM customer
WHERE customer_id NOT IN (SELECT customer_id FROM "order");

--Q11 Which customers have birthday today
SELECT concat_ws(' ', first_name, middle_name, last_name), date_part('YEAR', AGE(birthdate)) AS age
FROM customer
WHERE EXTRACT(month FROM birthdate) = EXTRACT(month FROM current_date)
AND EXTRACT(day FROM birthdate) = EXTRACT(day FROM current_date);

--Q12 first name and age of all customers from Denmark
SELECT first_name, DATE_PART('year', age(birthdate)) as age
FROM customer JOIN address a on customer.customer_id = a.customer_id JOIN zipcode z on a.zip_code = z.zip_code JOIN country c on z.country_code = c.country_code
WHERE country_name = 'Denmark';

--Q13 Find the name of the products, sorted alphabetically, who have reviews that contain any of the keywords: 'Great', 'Super', 'Excellent', 'Good' but with no case-sensitivity
SELECT product_name
FROM product JOIN review r on product.product_id = r.product_id
WHERE r.review_text ILIKE ('%Great%') OR r.review_text ILIKE ('%Super%') OR r.review_text ILIKE ('%Excellent%') OR r.review_text ILIKE ('%Good%')
ORDER BY product_name;

--Q14 Find the name of the products sorted alphabetically who have reviews that contain ALL of the keywords: 'Great', 'Super', 'Excellent', 'Good' but with no case-sensitivity.
SELECT product_name
FROM product JOIN review r on product.product_id = r.product_id
WHERE r.review_text ILIKE ('%Great%') AND r.review_text ILIKE ('%Super%') AND r.review_text ILIKE ('%Excellent%') AND r.review_text ILIKE ('%Good%')
ORDER BY product_name;
