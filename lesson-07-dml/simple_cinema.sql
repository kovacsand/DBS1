--Creating Schema
DROP SCHEMA IF EXISTS simple_cinema;
CREATE SCHEMA simple_cinema;
SET SCHEMA 'simple_cinema';

--Creating domains
DROP TABLE Cinema;
CREATE TABLE IF NOT EXISTS Cinema(
    city        VARCHAR(15)     PRIMARY KEY
);

INSERT INTO cinema VALUES('Horsens');

DROP TABLE CinemaHall;

CREATE TABLE IF NOT EXISTS CinemaHall(
    letter      CHAR(1)         NOT NULL
,   city        VARCHAR(15)     NOT NULL REFERENCES Cinema(city)
,   PRIMARY KEY (letter, city)
,   FOREIGN KEY (city) REFERENCES Cinema(city)
);

DROP TABLE Movie;
CREATE TABLE IF NOT EXISTS Movie(
    movieId     INT             CHECK (movieId BETWEEN 1000 AND 9999) PRIMARY KEY
,   title       VARCHAR(100)     NOT NULL
,   description VARCHAR(500)    NOT NULL
);

DROP TABLE Showing;

CREATE TABLE IF NOT EXISTS Showing(
    time    TIME        NOT NULL
,   date    DATE        NOT NULL
,   movieId INT
,   city    VARCHAR(15)
,   hall    CHAR(1)
,   PRIMARY KEY (hall, city, movieId, time, date)
,   FOREIGN KEY (movieId) REFERENCES Movie(movieId)
,   FOREIGN KEY (hall, city) REFERENCES CinemaHall(letter, city)
);