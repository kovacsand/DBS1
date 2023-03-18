SET SCHEMA 'students_movies';

--3d creating the new tables
DROP TABLE Classes;
CREATE TABLE IF NOT EXISTS Classes(
    name    VARCHAR(20) PRIMARY KEY
);

DROP TABLE students;
ALTER TABLE students ADD FOREIGN KEY(class) REFERENCES Classes(name);

DROP TABLE Teachers;
CREATE TABLE IF NOT EXISTS Teachers(
    name    VARCHAR(60)
,   staffId VARCHAR(6)  PRIMARY KEY
);

DROP TABLE StudentInstructors;
CREATE TABLE IF NOT EXISTS StudentInstructors(
    student_id  DECIMAL(6)  PRIMARY KEY
,   name        VARCHAR(60)
);

DROP TABLE CourseRatings;
CREATE TABLE IF NOT EXISTS CourseRatings(
    value       DECIMAL(1)  CHECK (value BETWEEN 1 AND 5)
,   student_id  VARCHAR(6)
,   course_id   VARCHAR(3)
,   class       VARCHAR(12)
,   FOREIGN KEY(student_id) REFERENCES students(id)
,   FOREIGN KEY(course_id, class) REFERENCES Courses(course_id, class)
,   PRIMARY KEY(student_id, course_id, class)
);

DROP TABLE Courses;
CREATE TABLE IF NOT EXISTS Courses(
    term            VARCHAR(20)
,   name            VARCHAR(200)
,   course_id       VARCHAR(3)
,   ects            DECIMAL(20) CHECK (ects BETWEEN 0 AND 30)
,   class           VARCHAR(20)
,   has_workshop    BOOLEAN
,   desc_updated    DATE
,   FOREIGN KEY(class) REFERENCES Classes(name)
,   PRIMARY KEY(course_id, class)
);

DROP TABLE StudentInstructsCourse;
CREATE TABLE IF NOT EXISTS StudentInstructsCourse(
    student_id  DECIMAL(6)
,   course_id   VARCHAR(10)
,   class       VARCHAR(20)
,   FOREIGN KEY(student_id) REFERENCES studentinstructors(student_id)
,   FOREIGN KEY(course_id, class) REFERENCES courses(course_id, class)
,   PRIMARY KEY(student_id, course_id, class)
);

DROP TABLE TeacherTeachesCourse;
CREATE TABLE IF NOT EXISTS TeacherTeachesCourse(
    staffId     VARCHAR(6)
,   course_id   VARCHAR(10)
,   class       VARCHAR(20)
,   FOREIGN KEY(staffId) REFERENCES Teachers(staffId)
,   FOREIGN KEY(course_id, class) REFERENCES Courses(course_id, class)
,   PRIMARY KEY (staffId, course_id, class)
);

--3e inserting data----------------------------------------------------------

DELETE FROM Classes ;
INSERT INTO Classes VALUES ('IT-DBS1X-S22'),
                           ('IT-DBS1Y-S22'),
                           ('IT-DBS1Z-S22'),
                           ('IT-1X-A21'),
                           ('IT-1Y-A21'),
                           ('IT-1Z-A21');

INSERT INTO Teachers VALUES ('Allan Henriksen', 'ALHE'),
                            ('Kasper Knop Rasmussen', 'KASR'),
                            ('Mona Wendel Andersen', 'MWA'),
                            ('Richard Brooks', 'RIB');
--I don't know the other teachers :(

INSERT INTO StudentInstructors VALUES (297111, 'Ionut Grosu'),
                                      (304312, 'Maria-Bianca Militaru'),
                                      (280066, 'Karla Jajic');
--Same, they're only for our class

DELETE FROM Courses;
INSERT INTO Courses VALUES ('Autumn 2021', 'Discrete Mathematics and Algorithms', 'DMA', 5, 'IT-1X-A21', true,'2021-08-01'),
                           ('Autumn 2021', 'Responsive Web Design', 'RWD', 5, 'IT-1X-A21', false,'2021-08-01'),
                           ('Autumn 2021', 'Semester Project: Single User System', 'SEP', 10, 'IT-1X-A21', false,'2021-08-01'),
                           ('Autumn 2021', 'Software Development with UML and Java', 'SDJ', 10, 'IT-1X-A21', true,'2021-08-01'),

                           ('Autumn 2021', 'Discrete Mathematics and Algorithms', 'DMA', 5, 'IT-1Y-A21', true,'2021-08-01');

INSERT INTO TeacherTeachesCourse VALUES ('ALHE', 'SDJ', 'IT-1X-A21'),
                                        ('KASR', 'RWD', 'IT-1X-A21'),
                                        ('ALHE', 'SEP', 'IT-1X-A21'),
                                        ('MWA', 'SEP', 'IT-1X-A21'),
                                        ('RIB', 'DMA', 'IT-1X-A21'),

                                        ('RIB', 'DMA', 'IT-1Y-A21');

INSERT INTO StudentInstructsCourse VALUES (280066, 'DMA', 'IT-1X-A21'),
                                          (280066, 'DMA', 'IT-1Y-A21'),
                                          (297111, 'SDJ', 'IT-1X-A21'),
                                          (304312, 'SDJ', 'IT-1X-A21');

INSERT INTO CourseRatings VALUES --Andras
                                 (1, 315241, 'SDJ', 'IT-1X-A21'),
                                 (3, 315241, 'SEP', 'IT-1X-A21'),
                                 (2, 315241, 'RWD', 'IT-1X-A21'),
                                 (2, 315241, 'DMA', 'IT-1X-A21'),
                                 --Bety
                                 (4, 315186, 'SDJ', 'IT-1X-A21'),
                                 (4, 315186, 'SEP', 'IT-1X-A21'),
                                 (3, 315186, 'RWD', 'IT-1X-A21'),
                                 (4, 315186, 'DMA', 'IT-1X-A21'),
                                 --James
                                 (3, 315203, 'SDJ', 'IT-1X-A21'),
                                 (2, 315203, 'SEP', 'IT-1X-A21'),
                                 (2, 315203, 'RWD', 'IT-1X-A21'),
                                 (5, 315203, 'DMA', 'IT-1X-A21'),
                                 --Ouafa
                                 (3, 315211, 'SDJ', 'IT-1X-A21'),
                                 (4, 315211, 'SEP', 'IT-1X-A21'),
                                 (4, 315211, 'RWD', 'IT-1X-A21'),
                                 (4, 315211, 'DMA', 'IT-1X-A21'),
                                 --Sofia
                                 (3, 315209, 'SDJ', 'IT-1X-A21'),
                                 (3, 315209, 'SEP', 'IT-1X-A21'),
                                 (4, 315209, 'RWD', 'IT-1X-A21'),
                                 (3, 315209, 'DMA', 'IT-1X-A21');
