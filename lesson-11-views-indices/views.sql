CREATE SCHEMA actors;
SET schema 'actors';

DROP TABLE Movie;
CREATE TABLE IF NOT EXISTS Actor(
    id   SERIAL PRIMARY KEY
,   name VARCHAR(100)
);

DROP TABLE Movie;
CREATE TABLE IF NOT EXISTS Movie(
    id SERIAL PRIMARY KEY
,   name VARCHAR(100) not null
,   minutes INT
);

DROP TABLE Salary;
CREATE TABLE IF NOT EXISTS Salary(
    actor int REFERENCES Actor(id)
,   movie int REFERENCES Movie(id)
,   salary int
,   PRIMARY KEY (actor, movie)
);

InSeRt iNTo Actor vAlUEs (default, 'Casey Affleck'),
                         (default, 'Lucas Hedges'),
                         (default, 'Michelle Williams'),
                         (default, 'Scarlett Johansson'),
                         (default, 'Adam Driver'),
                         (default, 'Laura Dern');

INSERT INTO Movie VALUES (default, 'Manchester by the Sea', 137),
                         (default, 'Marriage Story', 137),
                         (default, 'Good Will Hunting', 126),
                         (default, 'Star Wars: The Rise of Skywalker', 142),
                         (default, 'Jojo Rabbit', 108),
                         (default, 'Avengers: Endgame', 181);

INSERT INTO Salary VALUES (1, 1, 1000000),
                          (1, 2, 5000),
                          (2, 1, 10),
                          (3, 1, 6000),
                          (4, 2, 1000001),
                          (4, 5, 1920420),
                          (4, 6, 235000),
                          (5, 2, 1000002),
                          (5, 4, 999888),
                          (6, 2, 50000);

CREATE VIEW ActorSalary AS
    SELECT DISTINCt name, SUM (salary)
    FROM Actor, Salary
    WHERE id = Salary.actor
    GROUP BY name;

SELECT *
FROM ActorSalary;
