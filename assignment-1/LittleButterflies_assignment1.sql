SET SCHEMA 'students_movies';

-- 1. Produce a list of students, first and last name sorted alphabetically by firstname

SELECT f_name, l_name
FROM students
ORDER BY f_name;

-- 2. How many students are there?
SELECT COUNT(*)
FROM students;

-- 3. How many students are Romanian?
SELECT COUNT(*)
FROM students
WHERE nationality = 'Romanian';

-- 4. How many students are not Czech?
SELECT COUNT(*)
FROM students
WHERE NOT nationality = 'Czech';


-- 5. How many students were semi lazy, and wrote only a short review, less than 50 characters
-- hint: google how to find the length of a varchar value
SELECT COUNT(*)
FROM students
WHERE LENGTH(review) < 50;


-- 6. How many students watched Fight Club?
-- Requirement: You must use a join.

SELECT COUNT(s.movie_id)
FROM students s
         JOIN movies m ON m.id = s.movie_id
WHERE m.title = 'Fight Club';


-- 7. Create a list of the average ratings of each movie sorted from highest to lowest
-- Requirement: You must return a column with title and a column with average rating
-- Supply two-decimal precision on rating
SELECT title, ROUND(AVG(rating), 2)
FROM students s
         JOIN movies m ON m.id = s.movie_id
GROUP BY title, movie_id
ORDER BY AVG(rating) DESC;


-- 8. How many phone numbers are not danish? (i.e. do not start with +45)
SELECT COUNT(*)
FROM students
WHERE phone NOT LIKE '+45%';


-- 9. Student numbers which do n0t start with 31 may indicate it's a student,
-- who has studied something else before Software Engineering, and this programme is their second choice.
-- How many "second-choice Software Engineering" students are there?
SELECT COUNT(*)
FROM students
WHERE email NOT LIKE '31%';



-- 10. Produce a list of of student first names, and how many students have that first name.
-- Only return names having a count greater than one descending order of count
SELECT f_name, COUNT(*)
FROM students
GROUP BY f_name
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC;


-- 11. Produce a list of years and how many students were born in that year, put the oldest at the top
-- hint: google how to extract the year value from a data

SELECT EXTRACT(YEAR FROM dob) a, COUNT(students)
FROM students
GROUP BY a
ORDER BY a ASC;

-- 12. How many students are born in each city?
-- Only return cities with a count of more than 1 and descending order.

SELECT COUNT(*) a, birth_town
FROM students
GROUP BY birth_town
HAVING COUNT(*) > 1
ORDER BY a DESC;


-- 13. Produce an overview of how many students are from each nationality. State in descending order.
SELECT COUNT(*) a, nationality
FROM students
GROUP BY nationality
ORDER BY a DESC;


-- 14. How many reviews contain the word "great"/"Great"
SELECT COUNT(*)
FROM students
WHERE LOWER(review) LIKE '%great%';



-- 15. Which movie (the title) has received the most 10 star ratings
-- Only return the title of that movie and the count of 10-star ratings

SELECT COUNT(rating) c, m.title
FROM students s
         JOIN movies m ON m.id = s.movie_id
WHERE rating = 10
GROUP BY title
ORDER BY c DESC
LIMIT 1;


-- 16. Produce a list of movie title and how many students watched each movie

SELECT COUNT(s.id), m.title
FROM students s
         JOIN movies m ON m.id = s.movie_id
GROUP BY s.movie_id, m.title;


-- 17. Produce a list of how many students per class watched each movie,
-- display students::class, movies::title, and the count and
-- order by movie title, then class and then number of watches

SELECT class, COUNT(s.id), m.title
FROM students s
         JOIN movies m ON m.id = s.movie_id
GROUP BY m.title, s.class, s.movie_id;


-- 18. Create a list of the classes and their average rating?
-- Place the class with the highest average rating at the top
-- Display class name and average rating with two decimal precision
SELECT class, ROUND(AVG(rating), 2) a
FROM students
GROUP BY class
ORDER BY a DESC;



-- 19. Create a list of the groups and their average rating.
-- Place the group with the highest average rating at the top
-- Display group name, class and average rating with two decimal precision
-- Only return the groups with the top 10 ratings
SELECT group_name, class, ROUND(AVG(rating), 2) a
FROM students
GROUP BY group_name, class
ORDER BY a DESC
LIMIT 10;


-- 20. Create a list of the groups and their average rating
-- Place the group with the highest average rating at the top
-- And the group with the lowest average rating at the bottom
-- Display group name, class and average rating with two decimal precision
-- Only return the groups with the top 5 ratings and bottom 5 ratings

(SELECT group_name, class, ROUND(AVG(rating), 2) a
 FROM students
 GROUP BY group_name, class
 ORDER BY a DESC
 LIMIT 5)

UNION ALL
(SELECT group_name, class, ROUND(AVG(rating), 2) a
 FROM students
 GROUP BY group_name, class
 ORDER BY a DESC
 OFFSET 18);



-- 21. Which 5 nationalities have the highest average rating?
-- Return nationality and average rating (two decimal precision) in descending order.
SELECT nationality, ROUND(AVG(rating), 2) a
FROM students
GROUP BY nationality
ORDER BY a DESC
LIMIT 5;


-- 22. Which 5 nationalities have the lowest average rating?
-- Return nationality and average rating (two decimal precision) in ascending order.
SELECT nationality, ROUND(AVG(rating), 2) a
FROM students
GROUP BY nationality
ORDER BY a ASC
LIMIT 5;


-- 23. Which group gave Donnie Darko the lowest average rating?
-- Return the group name and rating (i.e. you should only return 1 row)
SELECT group_name, AVG(rating) a
FROM students
WHERE movie_id = (SELECT id
                  FROM movies
                  WHERE title LIKE 'Donnie Darko')
GROUP BY group_name
ORDER BY a ASC
LIMIT 1;

-- 24. How did the Polish students on average rate each movie?
-- Return title and average rating in descending order
SELECT m.title, AVG(s.rating) r
FROM students s
         JOIN movies m ON m.id = s.movie_id
WHERE s.nationality = 'Polish'
GROUP BY title
ORDER BY r DESC;


-- 25. Create a list with the average age per class
-- Return class name and average age ordered by highest avg age
-- Hint: If you use the AGE function you will get years, months, days, etc.
SELECT class, AVG(AGE(dob))
FROM students
GROUP BY class;



-- 26. What were the average rating of the roles?
-- Return the role and average rating (two decimal precision) in descending order
SELECT role, ROUND(AVG(rating), 2) r
FROM students
GROUP BY role
ORDER BY r DESC;

-- 27. Return a list of students who are developers and who gave Fight Club a rating between 7.5 and 9.5
-- and who are not Bulgarian, Danish, German, French or Italian.
-- Return the student's id, f_name, age in year, and rating, sort by age then rating both descending
SELECT id, f_name, EXTRACT(YEAR FROM dob), rating
FROM students
WHERE role = 'developer'
  AND nationality NOT IN (SELECT nationality
                          FROM students
                          WHERE nationality = 'Bulgarian'
                             OR nationality = 'Danish'
                             OR nationality = 'German'
                             OR nationality = 'French'
                             OR nationality = 'Italian')
  AND movie_id = (SELECT id FROM movies WHERE title = 'Fight Club')
  AND rating BETWEEN 7.5 AND 9.5
ORDER BY AGE(dob), rating DESC;


-- 28. Which nationality has the highest average age?
-- Return only that nationality and its average age in years (as a decimal)
SELECT AVG(AGE(dob)) a, nationality
FROM students
GROUP BY nationality
ORDER BY a DESC
LIMIT 1;


-- 29. In one of the questions above, you made a list of first names and
-- how many students that had that name. Which movies did the students with the most
-- frequent name watch? Return the id of the students and the title of the movies.
-- Requirement: You can not look up the name and then filter on the string 'Jakub'



SELECT m.title, substring(s.email,1,6) student_numer
FROM students s
    JOIN movies m ON m.id = s.movie_id
WHERE f_name IN(SELECT f_name
        FROM students
                 GROUP BY f_name
                 HAVING COUNT(*) > 1
                 ORDER BY COUNT(*) DESC);



-- 30. Create a table that displays each class name, the number of groups in each class, and the number of
-- distinct reviews of each class

SELECT class, COUNT(DISTINCT group_name) groups, COUNT(DISTINCT review) reviews
FROM students
GROUP BY class;


-- 31. Create a list of each class that also displays the sum of characters of all the distinct reviews
-- from each class. Return the class name, the sum of the characters of the distinct reviews and the length of the
-- longest review in each class. Sort from largest to smallest sum.
SELECT class, SUM(LENGTH(review)) all_reviews, MAX(LENGTH(review)) longest_review
FROM students
GROUP BY class;


-- 32. How many different nationalities are there in each class?
-- Return class name and number of nationalities
SELECT class, COUNT(DISTINCT nationality) number_of_nationalities
FROM students
GROUP BY class;


-- 33. How many students did not supply a phone number?
SELECT COUNT(*)
FROM students
WHERE phone IS NULL
   OR phone = '';

-- 34. How old is each movie?
-- Produce a list returning title, age of movie and the average rating of the movie (two decimal precision)
-- sorted by age of movie, then average rating
SELECT m.title, (2022 - m.release_year) age, ROUND(AVG(s.rating), 2) rating
FROM movies m
         JOIN students s ON m.id = s.movie_id
GROUP BY title, age
ORDER BY age, rating DESC;

-- another solution
SELECT COUNT(*) count, EXTRACT(YEAR FROM dob) a
FROM students
GROUP BY a
ORDER BY count DESC
LIMIT 5;


-- 36. How many students were born the same year one of the movies were released?
-- Return year of release and number of students born that year, sorted by year ascending
SELECT COUNT(*) count, EXTRACT(YEAR FROM dob) realise_year
FROM students
WHERE EXTRACT(YEAR FROM dob) IN (SELECT release_year
                                 FROM movies)
GROUP BY realise_year
ORDER BY realise_year;
