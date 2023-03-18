SET SCHEMA 'simple_imdb';

SELECT count(*)
FROM shows;

SELECT year, count(*)
FROM shows
GROUP BY year
ORDER BY year DESC;

--this is a comment
/*
 this is
 a multi-line
 comment
 */

SELECT count(*), rating
FROM ratings
GROUP BY rating
ORDER BY rating DESC;

SELECT count(*), genre
FROM genres
GROUP BY genre
ORDER BY genre;

SELECT name
FROM people
WHERE id IN (
    SELECT person_id
    FROM stars
    WHERE show_id IN (
        SELECT id
        FROM shows
        WHERE id IN (
            SELECT show_id
            FROM genres
            WHERE genre LIKE 'Adult'
        )
    )
);

SELECT count(*), birth
FROM people
WHERE birth IS NOT null
GROUP BY birth;
