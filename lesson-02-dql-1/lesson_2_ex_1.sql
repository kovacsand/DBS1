SET SCHEMA 'simple_imdb';

SELECT year
FROM shows
WHERE title LIKE 'Black Mirror';

SELECT name
FROM people
WHERE id = 103785;

SELECT name
FROM people
WHERE id IN (
    SELECT person_id
    FROM stars
    WHERE show_id IN (
        SELECT id
        FROM shows
        WHERE title LIKE 'The Office'
          AND year = 2005
    )
);

SELECT genre
FROM genres
WHERE show_id IN (
    SELECT id
    FROM shows
    WHERE title LIKE 'Stranger Things' AND year = 2016
);

SELECT title
FROM shows
WHERE id IN (
    SELECT show_id
    FROM stars
    WHERE person_id IN (
        SELECT id
        FROM people
        WHERE name LIKE 'Jennifer Aniston'
    )
);

SELECT DISTINCT genre
FROM genres;

SELECT title
FROM shows
WHERE year = 1970;

SELECT name, birth
FROM people
WHERE id IN (
    SELECT person_id
    FROM stars
) AND birth > 1955 AND birth < 1965;

SELECT title
FROM shows
WHERE id IN (
    SELECT show_id
    FROM ratings
    WHERE rating = 9.9
);

SELECT title, year
FROM shows
WHERE title LIKE '%Titanic%';