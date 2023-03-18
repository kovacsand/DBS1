--Creating Schema
DROP SCHEMA IF EXISTS dreamhouse;
CREATE SCHEMA dreamhouse;
SET SCHEMA 'dreamhouse';

--Creating domains
CREATE DOMAIN branchnumber AS CHAR(4) CHECK (VALUE BETWEEN 'B001' AND 'B999');
CREATE DOMAIN streetname AS VARCHAR(100);
CREATE DOMAIN staffnumber AS VARCHAR(4) CHECK (VALUE LIKE 'S%');
CREATE DOMAIN gender AS CHAR(1) CHECK (VALUE IN ('M', 'F'));
CREATE DOMAIN dob AS DATE CHECK (VALUE > to_date('01-Jan-1920', 'dd-Mon-yyyy'));
CREATE DOMAIN salary DECIMAL(7, 2) CHECK (VALUE >= 0);
CREATE DOMAIN ownernumber AS CHAR(4) CHECK (VALUE BETWEEN 'CO00' AND 'CO99');

--Creating tables
CREATE TABLE IF NOT EXISTS Branch(
    branchNo    branchnumber   PRIMARY KEY
,   street      streetname     NOT NULL
,   city        VARCHAR(20)    NOT NULL
,   postcode    VARCHAR(10)    NOT NULL
);

CREATE TABLE IF NOT EXISTS Staff(
    staffNo     staffnumber     PRIMARY KEY
,   fName       VARCHAR(15)     NOT NULL
,   lName       VARCHAR(15)     NOT NULL
,   position    VARCHAR(15)     NOT NULL
,   gender      gender          NOT NULL
,   dob         dob             NOT NULL
,   salary      salary          NOT NULL
,   branchNo    branchnumber    NOT NULL REFERENCES Branch(branchNo)
);

CREATE TABLE IF NOT EXISTS PrivateOwner(
    ownerNo     ownernumber     PRIMARY KEY
,   fName       VARCHAR(15)     NOT NULL
,   lName       VARCHAR(15)     NOT NULL
);