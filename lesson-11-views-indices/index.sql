DROP SCHEMA postgres;
CREATE SCHEMA postgres;
SET SCHEMA 'postgres';

UPDATE pgbench_accounts SET abalance = round(random() * 30000000), filler = trim(to_char((aid-1) % 100000 + 1, '999999'));

UPDATE pgbench_branches SET bbalance = round(random() * 30000000), filler = to_char(bid, '000');

UPDATE pgbench_tellers SET tbalance = round(random() * 30000000), filler = to_char(tid, '0000');

--------------------------------Exercise 2------------------------

--Question a
SELECT COUNT(*)
FROM pgbench_branches;
--100 branches

--Question b
SELECT COUNT(*)
FROM pgbench_tellers;
--1000

--Question c
SELECT COUNT(*)
FROM pgbench_accounts;
--10 000 000

--Question d
SELECT bbalance
FROM pgbench_branches
ORDER BY bbalance DESC
LIMIT 1;
--29 874 267

--Question e
SELECT tbalance
FROM pgbench_tellers
ORDER BY tbalance DESC
LIMIT 1;
--29 972 196

--Question f
SELECT abalance
FROM pgbench_accounts
ORDER BY abalance DESC
LIMIT 1;
--29 999 999

--Question g
SELECT COUNT(*)
FROM pgbench_accounts
WHERE filler = '4321';
--100


