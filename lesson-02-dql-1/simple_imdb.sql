SET SCHEMA 'simple_imdb';

--Q1 name of the person with id 103?
SELECT name
FROM people
WHERE id = 103;

--Q2 How many people has the name 'Jennifer'?
SELECT COUNT(*)
FROM people
WHERE name LIKE '%Jennifer%';

--Q3 How many people were born in 1967?
SELECT COUNT(*)
FROM people
WHERE birth = 1967;

--Q4 How many writers were born in 1967?
SELECT COUNT(*)
FROM people
WHERE birth = 1967 AND id IN (
    SELECT person_id
    FROM writers
    );

--Q5 How many episodes does the show 'The Young and the Restless' have?
SELECT episodes
FROM shows
WHERE title = 'The Young and the Restless';

--Q6 Which shows has 'Drew Barrymore' starred in?
SELECT title
FROM shows
WHERE id IN (
    SELECT show_id
    FROM stars
    WHERE person_id = (
        SELECT id
        FROM people
        WHERE name = 'Drew Barrymore'
        )
    );

--Q7 the genres of 'Voltz'?
SELECT genre
FROM genres
WHERE show_id = (
    SELECT id
    FROM shows
    WHERE title = 'Voltz'
    );

--Q8 names of the stars of 'The Young and the Restless'
SELECT name
FROM people
WHERE id IN (
    SELECT person_id
    FROM stars
    WHERE show_id = (SELECT id FROM shows WHERE title = 'The Young and the Restless')
    );

--Q9 the title and rating of the highest rated show(s)?
SELECT title, rating
FROM shows JOIN ratings r on shows.id = r.show_id
WHERE rating = (SELECT MAX(rating) FROM ratings);

--Q10 both stars and writers?
SELECT DISTINCT name
FROM people
WHERE id IN (SELECT person_id FROM stars) AND id IN (SELECT person_id FROM writers);

--Q11 both stars and writers of 'The Young and the Restless
SELECT name
FROM people
WHERE id IN (SELECT person_id FROM stars JOIN shows s on stars.show_id = s.id WHERE title = 'The Young and the Restless')
    OR id IN (SELECT person_id FROM writers JOIN shows s2 on writers.show_id = s2.id WHERE title = 'The Young and the Restless');
