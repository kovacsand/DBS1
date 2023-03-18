SET SCHEMA 'goodreads_v2';

SELECT first_name, last_name
FROM author
WHERE id = 23;

SELECT *
FROM book
WHERE id = 24358527;

SELECT COUNT(*)
FROM profile;

SELECT COUNT(*)
FROM profile
WHERE first_name = 'Jaxx';

SELECT first_name, COUNT(*)
FROM author
GROUP BY first_name
HAVING COUNT(*) > 2
ORDER BY COUNT(*) DESC;

SELECT title, page_count
FROM book
WHERE page_count IS NOT NULL
ORDER BY page_count DESC;

SELECT *
FROM book
WHERE year_published = 2017;

SELECT publisher_name
FROM publisher
WHERE id IN (
    SELECT publisher_id
    FROM book
    WHERE title = 'Tricked (The Iron Druid Chronicles,  #4)'
);

SELECT type
FROM binding_type
WHERE id = (
    SELECT binding_id
    FROM book
    WHERE title = 'Fly by Night'
);

SELECT COUNT(*)
FROM book
WHERE isbn IS NULL;

SELECT COUNT(*)
FROM author
WHERE middle_name IS NOT NULL;

SELECT author_id, COUNT(*)
FROM book
GROUP BY author_id
ORDER BY COUNT(*) DESC;

SELECT MAX(page_count)
FROM book;

SELECT title
FROM book
WHERE page_count = (
    SELECT MAX(page_count)
    FROM book
);

SELECT COUNT(*)
FROM book
WHERE id IN (
    SELECT book_id
    FROM book_read
    WHERE status = 'read'
      AND profile_id IN (
        SELECT id
        FROM profile
        WHERE profile_name = 'Venom_Fate'
    )
);

SELECT COUNT(*)
FROM book
WHERE author_id IN (
    SELECT id
    FROM author
    WHERE CONCAT(first_name, ' ', last_name) = 'Brandon Sanderson'
      AND middle_name IS NULL
);

SELECT COUNT(*)
FROM book_read
WHERE status = 'read'
  AND book_id IN (
    SELECT id
    FROM book
    WHERE title = 'Gullstruck Island'
);

SELECT COUNT(*)
FROM book
WHERE id IN (
    SELECT book_id
    FROM co_authors
    WHERE author_id IN (
        SELECT id
        FROM author
        WHERE first_name = 'Ray'
          AND last_name = 'Porter'
          AND middle_name IS NULL
    )
);

SELECT first_name, middle_name, last_name
FROM author
WHERE id = (SELECT author_id FROM book WHERE title LIKE '%The Summer Dragon%');

SELECT type
FROM binding_type
WHERE id = (SELECT binding_id FROM book WHERE title = 'Dead Iron (Age of Steam,  #1)');

SELECT type, COUNT(*)
FROM binding_type
         JOIN book b on binding_type.id = b.binding_id
GROUP BY binding_id, binding_type.type
ORDER by type;

SELECT profile_name, COUNT(*)
FROM profile
         JOIN book_read br on profile.id = br.profile_id
WHERE status = 'read'
GROUP BY profile_name
ORDER BY profile_name;

SELECT genre
FROM genre
WHERE id IN (
    SELECT genre_id
    FROM book_genre
             JOIN book b on book_genre.book_id = b.id
    WHERE title = 'Hand of Mars (Starship''s Mage,  #2)'
);

SELECT DISTINCT first_name, middle_name, last_name
FROM author
WHERE id IN (
    SELECT author_id
    FROM co_authors
    WHERE book_id = (SELECT id FROM book WHERE title = 'Dark One')
)
   OR id IN (SELECT author_id FROM book WHERE title = 'Dark One');

SELECT title
FROM book
WHERE id = (
    SELECT book_id
    FROM book_read
    WHERE status = 'read'
    GROUP BY book_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

SELECT title, type
FROM book
         JOIN binding_type bt on book.binding_id = bt.id
WHERE page_count IS NOT NULL
ORDER BY page_count DESC
LIMIT 10;

SELECT genre, COUNT(*)
FROM genre
         JOIN book_genre bg on genre.id = bg.genre_id
         JOIN book b on bg.book_id = b.id
GROUP BY genre
ORDER BY COUNT(*) DESC;

SELECT publisher_name, COUNT(*)
FROM publisher
         JOIN book b on publisher.id = b.publisher_id
GROUP BY publisher_name
ORDER BY COUNT(*) DESC;

SELECT title
FROM book
WHERE id = (
    SELECT book_id
    FROM book_read
    GROUP BY book_id
    ORDER BY AVG(rating) DESC
    LIMIT 1
);

SELECT COUNT(*)
FROM book_read
         JOIN profile p on book_read.profile_id = p.id
WHERE profile_name = 'radiophobia'
  AND EXTRACT(YEAR FROM book_read.date_finished) = 2018;

SELECT EXTRACT(YEAR FROM book_read.date_finished), COUNT(*)
FROM book_read
         JOIN profile p on book_read.profile_id = p.id
WHERE profile_name = 'radiophobia'
GROUP BY EXTRACT(YEAR FROM book_read.date_finished)
ORDER BY EXTRACT(YEAR FROM book_read.date_finished);

SELECT title
FROM book,
     book_read
WHERE id = book_id
GROUP BY title
ORDER BY AVG(rating) DESC
LIMIT 10;

SELECT title, AVG(rating)
FROM book,
     book_read
WHERE id = book_id
GROUP BY title
ORDER BY AVG(rating) ASC
LIMIT 1;

SELECT title
FROM book
WHERE id NOT IN (
    SELECT book_id
    FROM book_read
    WHERE status = 'read'
);

SELECT profile_name, COUNT(*)
FROM profile
         JOIN book_read br on profile.id = br.profile_id
WHERE status = 'read'
GROUP BY profile_id, profile_name
ORDER BY COUNT(*) DESC
LIMIT 1;

SELECT profile_name, SUM(page_count)
FROM profile
         JOIN book_read br on profile.id = br.profile_id
         JOIN book b on br.book_id = b.id
GROUP BY profile_name
ORDER BY SUM(page_count) DESC
LIMIT 10;

SELECT profile_name, date_finished - date_started
FROM profile
         JOIN book_read br on profile.id = br.profile_id
         JOIN book b on br.book_id = b.id
WHERE title = 'Oathbringer (The Stormlight Archive,  #3)'
ORDER BY date_finished - date_started;

--MORE IDEAS
--genre most books
SELECT genre, COUNT(*)
FROM genre
         JOIN book_genre bg on genre.id = bg.genre_id
GROUP BY genre
ORDER BY COUNT(*) DESC;

--each reader's most popular genre
SELECT profile_name, genre, COUNT(*) AS read_per_genre
FROM genre
         JOIN book_genre bg on genre.id = bg.genre_id
         JOIN book b on bg.book_id = b.id
         JOIN book_read br on b.id = br.book_id
         JOIN profile p on br.profile_id = p.id
GROUP BY profile_name, genre
ORDER BY COUNT(*) DESC;

--most popular type of binding
SELECT type, COUNT(*)
FROM binding_type JOIn book b on binding_type.id = b.binding_id
GROUP BY type
ORDER BY COUNT(*) DESC
LIMIT 1;

--how many books each author has written
SELECT first_name, middle_name, last_name, COUNT(*)
FROM author JOIN book b on author.id = b.author_id
GROUP BY author.id
ORDER BY COUNT(*) DESC;

--how many pages each author has written
SELECT first_name, middle_name, last_name, SUM(page_count) AS number_of_pages
FROM author JOIN book b on author.id = b.author_id
GROUP BY author.id
HAVING SUM(page_count) IS NOT NULL
ORDER BY SUM(page_count) DESC;

--Are there two authors with the same first name?
SELECT first_name, COUNT(*)
FROM author
GROUP BY first_name
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC;