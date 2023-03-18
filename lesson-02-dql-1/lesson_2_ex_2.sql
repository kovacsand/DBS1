SET SCHEMA 'goodreads';

SELECT page_count
FROM book
WHERE title = 'City in the Sky';

SELECT count(*)
FROM book
WHERE publisher = 'Faolan''s Pen Publishing Inc.';

SELECT title, avg_rating, isbn
FROM book
WHERE isbn is not null;

SELECT count(*)
FROM author
WHERE middle_name is null;

SELECT title
FROM book
WHERE title LIKE '%City%';

SELECT count(*)
FROM book
WHERE year_published = 2019 AND avg_rating BETWEEN 3.8 AND 4.1;

SELECT count(*)
FROM book
WHERE shelf LIKE 'read';

SELECT sum(page_count)
FROM book
WHERE  extract(year from date_finished) = 2019;

SELECT count(*), sum(page_count)
FROM book;

SELECT max(page_count), min(page_count), avg(page_count)
FROM book;
