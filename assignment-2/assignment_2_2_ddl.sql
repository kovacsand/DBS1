CREATE SCHEMA blood_bank;

SET SCHEMA 'blood_bank';

CREATE TABLE IF NOT EXISTS donor(
    cpr             VARCHAR(10)  PRIMARY KEY
,   name            VARCHAR(60)
,   house_number    DECIMAL
,   street          VARCHAR(30)
,   city            VARCHAR(30)
,   postal_code     DECIMAL(4)
,   phone           DECIMAL(8)
,   blood_type      VARCHAR(3)  CHECK (blood_type IN ('O-', 'O+', 'B-', 'B+', 'A-', 'A+', 'AB-', 'AB+'))
,   last_reminder   DATE
);

CREATE TABLE IF NOT EXISTS blood_donations(
    id              SERIAL PRIMARY KEY
,   date            DATE
,   amount          DECIMAL(3)      CHECK (amount BETWEEN 300 AND 600)
,   blood_percent   DECIMAL(4,1)    CHECK (blood_percent BETWEEN 8.0 AND 11.0)
,   donor_id        VARCHAR(10)
,   FOREIGN KEY(donor_id) REFERENCES donor(cpr)
);

CREATE TABLE IF NOT EXISTS next_appointment(
    date        DATE
,   time        TIME
,   donor_cpr   VARCHAR(10)
,   FOREIGN KEY(donor_cpr) REFERENCES donor(cpr)
,   PRIMARY KEY (date, donor_cpr)
);

CREATE TABLE IF NOT EXISTS staff(
    initials        VARCHAR(4)  PRIMARY KEY
,   cpr             VARCHAR(10)
,   name            VARCHAR(60)
,   house_number    DECIMAL
,   street          VARCHAR(30)
,   city            VARCHAR(30)
,   postal_code     DECIMAL(4)
,   phone           DECIMAL(8)
,   hire_date       DATE
,   position        VARCHAR(30) CHECK (position IN ('nurse', 'biomedical assistant', 'intern'))
);

CREATE TABLE IF NOT EXISTS managed_by(
    collected_by_nurse_id       VARCHAR(4)
,   donation_id                 INTEGER
,   verified_by_nurse_initials  VARCHAR(4)
,   FOREIGN KEY(collected_by_nurse_id) REFERENCES staff(initials)
,   FOREIGN KEY(verified_by_nurse_initials) REFERENCES staff(initials)
,   FOREIGN KEY(donation_id) REFERENCES blood_donations(id)
,   PRIMARY KEY(donation_id)
);

--------------------INSERTING DATA-----------------------

INSERT INTO staff VALUES ('BB', '0101901234', 'Bob Bobson', '1', 'Sundvej', 'Horsens', 8700, 12345678, '2021-01-01', 'nurse'),
                         ('AA', '0202901234', 'Alica Alicason', '1', 'Sundvej', 'Horsens', 8700, 12345679, '2021-01-01', 'biomedical assistant'),
                         ('CC', '0303901234', 'Carls Carlson', '1', 'Sundvej', 'Horsens', 8700, 12345680, '2021-01-01', 'intern');

INSERT INTO donor VALUES ('87654321', 'Donor Giver', '9', 'Donorgade', 'Horsens', 8700, 87654321, 'A-', '2022-03-31'),
                         ('87654320', 'Donor Taker', '9', 'Donorgade', 'Horsens', 8700, 87654320, 'AB-', '2022-03-30');

INSERT INTO blood_donations VALUES (DEFAULT, '2022-03-01', 350, 10.2, '87654321'),
                                   (DEFAULT, '2022-03-01', 300, 10.23, '87654320');

INSERT INTO managed_by VALUES ('AA', 1, 'CC'),
                              ('AA', 2, 'BB');