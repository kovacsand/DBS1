--The theft took place on July 28, 2020 on Chamberlin Street

SET SCHEMA 'shadyville';

--How many suspects do we have?
SELECT COUNT(*)
FROM people;
--200

--We know it happened on Chamberlin Street. Let's go through the crime scene reports, and search for the street name and the keyword theft
SELECT *
FROM crime_scene_reports
WHERE street = 'Chamberlin Street'
  AND description ILIKE '%theft%';
--Only one result. id = 295, description:
--Theft of the DBS Talisman took place at 10:15am at the Chamberlin Street courthouse. Interviews were conducted today with three witnesses who were present at the time — each of their interview transcripts mentions the courthouse.
--We now know the exact time: 10:15am

--Let's find those mentioned interviews
SELECT *
FROM interviews
WHERE day = 28
  AND month = 7
  AND year = 2020
  AND transcript ILIKE '%courthouse%';
--First interview: Thief leaving parking lot before 10:25am
--Second interview: Thief withdrawing money from the ATM on Fifer Street the same morning
--Third interview: Thief having a phone call for less than a minute between 10:15am and 10:25am. They are planning to leave Shadyville with the earliest flight tomorrow. Their accomplice is going to purchase the tickets.

--Let's check the security footage based on the first interview
SELECT *
FROM courthouse_security_logs
WHERE year = 2020
  AND month = 7
  AND day = 28
  AND hour = 10
  AND minute BETWEEN 15 AND 25
  AND activity = 'exit';
--8 cars left the parking lot in that timeframe, so we have 8 suspects

--Let's check the ATM transactions based on the second interview
SELECT *
FROM atm_transactions
WHERE year = 2020
  AND month = 7
  AND day = 28
  AND atm_location = 'Fifer Street'
  AND transaction_type = 'withdraw';
--8 transactions, 8 suspects (might not be the same)

--The security logs contain an id to identify people, and we can connect the transactions to bank accounts that have the same kind of id's. We just have to find the intersection of these, and if we're lucky, it's going to be less than 8 people.
SELECT *
FROM people
WHERE license_plate IN (
    SELECT courthouse_security_logs.license_plate
    FROM courthouse_security_logs
    WHERE year = 2020
      AND month = 7
      AND day = 28
      AND hour = 10
      AND minute BETWEEN 15 AND 25
      AND activity = 'exit'
)
  AND id IN (
    SELECT person_id
    FROM bank_accounts
             JOIN atm_transactions a on bank_accounts.account_number = a.account_number
    WHERE year = 2020
      AND month = 7
      AND day = 28
      AND atm_location = 'Fifer Street'
      AND transaction_type = 'withdraw'
);
--We have successfully identified 4 suspects, and now we have their passport numbers.
--The passport numbers are: [8496433585, 3592750733, 7049073643, 5773159633]


--Let's check the flights leaving Shadyville the day after the crime based on the third interview
SELECT *
FROM flights
WHERE year = 2020
  AND month = 7
  AND day = 29
  AND origin_airport_id = (SELECT id FROM airports WHERE city = 'Shadyville')
ORDER BY hour, minute
LIMIT 1;
--We have the first flight, it's id = 36, it goes to airport id = 4

--Let's check that airport with the id 4
SELECT *
FROM airports
WHERE id = 4;
--Ooooh, it's London, maybe Sherlock Holmes will give us a compliment

--We have the exact flight, and 4 suspects. Let's check if they were travelling on that flight using their passport numbers
SELECT *
FROM passengers
WHERE flight_id = 36
  AND passport_number IN (8496433585, 3592750733, 7049073643, 5773159633);
--We have two suspects left. But presumably, only one of them was making a call at that specific time mentioned in the third interview.
--Their passport numbers are: 8496433585, 5773159633

--Let's check for that call. We except one return, the thief
SELECT *
FROM phone_calls
WHERE year = 2020
  AND month = 7
  AND day = 28
  AND duration < 60
  AND caller IN (
    SELECT phone_number FROM people WHERE passport_number IN (8496433585, 5773159633)
);
--We found the thief, their number is (367) 555-5533, their accomplice's number is (375) 555-8161

--Now, let's end this investigation
SELECT *
FROM people
WHERE phone_number IN ('(367) 555-5533', '(375) 555-8161');
--To summarise
--The thief is Ernest, id = 686048, his passport number is 5773159633, his phone number is (367) 555-5533, and his license plate is 94KL13X. On the plane he was sitting in 4A. Nice, window seat.
--The thief was going to London, to the Heathrow Airport, (LHR)
--His accomplice is Berthold, id = 864400, he doesn't have a passport, his phone number is (375) 555-8161, and his license plate is 4V16VO0