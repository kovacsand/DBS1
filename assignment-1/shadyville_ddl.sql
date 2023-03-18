DROP SCHEMA IF EXISTS shadyville;
CREATE SCHEMA shadyville;
SET SCHEMA 'shadyville';

CREATE TABLE airports (
    id INTEGER,
    abbreviation CHAR(3) UNIQUE,
    full_name TEXT,
    city TEXT,
    PRIMARY KEY (id)
);

CREATE TABLE people (
    id INTEGER,
    name TEXT,
    phone_number VARCHAR(15) UNIQUE,
    passport_number BIGINT,
    license_plate VARCHAR(10) UNIQUE,
    PRIMARY KEY (id)
);

CREATE TABLE bank_accounts (
    account_number INTEGER PRIMARY KEY,
    person_id INTEGER,
    creation_year INTEGER,
    FOREIGN KEY (person_id)
        REFERENCES people (id)
);

CREATE TABLE atm_transactions (
    id INTEGER,
    account_number INTEGER,
    year INTEGER,
    month INTEGER,
    day INTEGER,
    atm_location TEXT,
    transaction_type TEXT,
    amount INTEGER,
    PRIMARY KEY (id),
    FOREIGN KEY (account_number)
        REFERENCES bank_accounts (account_number)
);

CREATE TABLE courthouse_security_logs (
    id INTEGER,
    year INTEGER,
    month INTEGER,
    day INTEGER,
    hour INTEGER,
    minute INTEGER,
    activity TEXT,
    license_plate TEXT REFERENCES people (license_plate),
    PRIMARY KEY (id)
);

CREATE TABLE crime_scene_reports (
    id INTEGER,
    year INTEGER,
    month INTEGER,
    day INTEGER,
    street TEXT,
    description TEXT,
    PRIMARY KEY (id)
);
CREATE TABLE flights (
    id INTEGER,
    origin_airport_id INTEGER,
    destination_airport_id INTEGER,
    year INTEGER,
    month INTEGER,
    day INTEGER,
    hour INTEGER,
    minute INTEGER,
    PRIMARY KEY (id),
    FOREIGN KEY (origin_airport_id)
        REFERENCES airports (id),
    FOREIGN KEY (destination_airport_id)
        REFERENCES airports (id)
);
CREATE TABLE interviews (
    id INTEGER,
    name TEXT,
    year INTEGER,
    month INTEGER,
    day INTEGER,
    transcript TEXT,
    PRIMARY KEY (id)
);
CREATE TABLE passengers (
    flight_id INTEGER,
    passport_number BIGINT,
    seat TEXT,
    FOREIGN KEY (flight_id)
        REFERENCES flights (id)
);

CREATE TABLE phone_calls (
    id INTEGER,
    caller TEXT,
    receiver TEXT,
    year INTEGER,
    month INTEGER,
    day INTEGER,
    duration INTEGER,
    PRIMARY KEY (id)
);