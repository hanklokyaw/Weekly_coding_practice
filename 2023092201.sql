-- create database for china customes codes 
CREATE DATABASE CUSTOMS_DATABASE;

-- create tables for different length of hts code
USE CUSTOMS_DATABASE;
SELECT * FROM china_hts_2_digits;
SELECT * FROM china_hts_4_digits;
SELECT * FROM china_hts_6_digits ORDER BY CODES DESC LIMIT 5;
SELECT COUNT(*) FROM china_hts_6_digits;
SELECT * FROM china_hts_8_digits ORDER BY CODES DESC LIMIT 10;

-- drop 6 digits table
DROP TABLE china_hts_6_digits;

-- create 6 digits table manually
CREATE TABLE china_hts_6_digits
(`CODES` int NOT NULL,
`DESCRIPTION` varchar(200),
`YEAR` int,
`UNIT_1_CODES` varchar(20),
`UNIT_1_DESCRIPTION` varchar (20),
`UNIT_2_CODES` varchar(20),
`UNIT_2_DESCRIPTION` varchar(20));

-- add 2 digits column to 4 digits table as foreign key
ALTER TABLE china_hts_4_digits
ADD `CODES_2D` BIGINT;
UPDATE china_hts_4_digits
SET `CODES_2D` = LEFT(`CODES`, 2);

-- add 4 digits column to 6 digits table as foreign key
ALTER TABLE china_hts_6_digits
ADD `CODES_4D` BIGINT;
UPDATE china_hts_6_digits
SET `CODES_4D` = LEFT(`CODES`, 4);

-- add 6 digits column to 8 digits table as foreign key
ALTER TABLE china_hts_8_digits
ADD `CODES_6D` BIGINT;
UPDATE china_hts_8_digits
SET `CODES_6D` = LEFT(`CODES`, 6);

-- create a universal table to connect all 2,4,6,8 digits codes
CREATE TABLE china_hts_digits_key
(`CODES_2D` INT NOT NULL,
`CODES_4D` INT NOT NULL,
`CODES_6D` BIGINT NOT NULL,
`CODES_8D` BIGINT NOT NULL);

-- add codes from china_hts_8_digits table then concat into 8,6,4,2 digits columns
INSERT INTO china_hts_digits_key(`CODES_2D`, `CODES_4D`, `CODES_6D`, `CODES_8D`)
SELECT LEFT(`CODES`,2), LEFT(`CODES`, 4), LEFT(`CODES`,6), `CODES`
FROM china_hts_8_digits;

-- join tables and see the result
SELECT d2.CODES, d2.DESCRIPTION, d4.CODES, d4.DESCRIPTION, d6.CODES, d6.DESCRIPTION, d8.CODES, d8.DESCRIPTION
FROM china_hts_digits_key AS uni
LEFT JOIN china_hts_8_digits AS d8
ON uni.CODES_8D = d8.CODES
LEFT JOIN china_hts_6_digits AS d6
ON uni.CODES_6D = d6.CODES
LEFT JOIN china_hts_4_digits AS d4
ON uni.CODES_4D = d4.CODES
LEFT JOIN china_hts_2_digits AS d2
ON uni.CODES_2D = d2.CODES;
