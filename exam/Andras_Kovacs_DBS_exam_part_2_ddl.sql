DROP SCHEMA IF EXISTS library CASCADE;
CREATE SCHEMA IF NOT EXISTS library;

SET SCHEMA 'library';

DROP TABLE IF EXISTS Loaner;
CREATE TABLE IF NOT EXISTS Loaner(
    id              INT             PRIMARY KEY
,   name            VARCHAR(200)    NOT NULL
,   phone_number    VARCHAR(8)      NOT NULL
);

DROP TABLE IF EXISTS Book_Details;
CREATE TABLE IF NOT EXISTS Book_Details(
    id              INT             PRIMARY KEY
,   isbn            CHAR(13)        NOT NULL
,   title           VARCHAR(149)    NOT NULL
,   edition         VARCHAR(200)    --It can be long, e.g. Limited Edition for author's centennial, but can also be empty
);

DROP TABLE IF EXISTS Topic;
CREATE TABLE IF NOT EXISTS Topic(
    book_id         INT             NOT NULL
,   topic           VARCHAR(200)    NOT NULL --Short description of the topic
,   PRIMARY KEY (book_id, topic)
,   FOREIGN KEY (book_id) REFERENCES Book_Details(id)
);

DROP TABLE IF EXISTS Book_Copy;
CREATE TABLE IF NOT EXISTS Book_Copy(
    details_id      INT             NOT NULL
,   copy_no         INT             NOT NULL CHECK (copy_no > 0)
,   condition       VARCHAR(8)      NOT NULL CHECK (condition IN ('worn', 'used', 'decent', 'pristine'))
,   PRIMARY KEY (details_id, copy_no)
,   FOREIGN KEY (details_id) REFERENCES Book_Details(id)
);

DROP TABLE IF EXISTS Book_Loaned;
CREATE TABLE IF NOT EXISTS Book_Loaned(
    details_id          INT     NOT NULL
,   copy_no             INT     NOT NULL
,   loaner_id           INT     NOT NULL
,   date_loaned         DATE    NOT NULL
,   final_return_date   DATE    NOT NULL    CHECK (final_return_date-date_loaned <= 31)
,   date_returned       DATE
,   PRIMARY KEY (details_id, copy_no, loaner_id, date_loaned)
,   FOREIGN KEY (details_id, copy_no)   REFERENCES Book_Copy(details_id, copy_no)
,   FOREIGN KEY (loaner_id)             REFERENCES Loaner(id)
);

INSERT INTO Book_Details VALUES
    (1, 1234567891011, 'Book One', 'First Edition')
,   (2, 1110987654321, 'Book Two', 'Special Edition');

INSERT INTO Topic VALUES
    (1, 'Database Systems')
,   (1, 'French Cuisine');

INSERT INTO Book_Copy VALUES
    (1, 1, 'pristine')
,   (1, 2, 'worn');

INSERT INTO Loaner VALUES
    (1, 'Bob Bobson', '12345678')
,   (2, 'Jens Jensen', '87654321');

INSERT INTO Book_Loaned VALUES
    (1, 1, 1, '2022-06-13', '2022-06-20', NULL)
,   (1, 2, 1, '2022-06-12', '2022-06-26', '2022-06-13');