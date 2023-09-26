-- create database for china customes codes 
CREATE DATABASE CUSTOMS_DATABASE;

-- create tables for different length of hts code
USE CUSTOMS_DATABASE;
SELECT * FROM china_hts_2_digits;
SELECT * FROM china_hts_4_digits;
SELECT * FROM china_hts_6_digits ORDER BY HTS6 DESC LIMIT 5;
SELECT COUNT(*) FROM china_hts_6_digits;
SELECT * FROM china_hts_8_digits ORDER BY HTS8 DESC LIMIT 10;

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

-- check imported us export raw table
SELECT * FROM us_export_concordance_2023 ORDER BY hts10 DESC LIMIT 10;

-- create us key table
CREATE TABLE us_hts_digits_key
(`CODES_2D` INT NOT NULL,
`CODES_4D` INT NOT NULL,
`CODES_6D` BIGINT NOT NULL,
`CODES_8D` BIGINT NOT NULL,
`CODES_10D` BIGINT NOT NULL);

-- I just realized that 2 digits, 4 digits, ... hts code should simply name by hts2, hts4, ...
-- So, I am changing the china hts codes again here.

-- change column name in china_hts_2_digits table
ALTER TABLE china_hts_2_digits
CHANGE CODES HTS2 INT;
ALTER TABLE china_hts_4_digits
CHANGE CODES HTS4 INT;
ALTER TABLE china_hts_6_digits
CHANGE CODES HTS6 BIGINT;
ALTER TABLE china_hts_8_digits
CHANGE CODES HTS8 BIGINT;
ALTER TABLE china_hts_digits_key
CHANGE CODES_2D HTS2 INT,
CHANGE CODES_4D HTS4 INT,
CHANGE CODES_6D HTS6 BIGINT,
CHANGE CODES_8D HTS8 BIGINT;

DROP TABLE us_hts_6_digits;

-- create 6 digits table
CREATE TABLE us_hts_6_digits
(`HTS6` BIGINT NOT NULL,
`DESCRIPTION` VARCHAR(100),
`DESCRIPTION_DETAIL` VARCHAR(200));

-- create 8 digits table
CREATE TABLE us_hts_8_digits
(`HTS8` BIGINT NOT NULL,
`DESCRIPTION` VARCHAR(100),
`DESCRIPTION_DETAIL` VARCHAR(200));

-- create 10 digits table
CREATE TABLE us_hts_10_digits
(`HTS10` BIGINT NOT NULL,
`DESCRIPTION` VARCHAR(100),
`DESCRIPTION_DETAIL` VARCHAR(200));

-- create all digits table
CREATE TABLE us_hts_all_digits
(`HTS2` INT NOT NULL,
`HTS4` INT NOT NULL,
`HTS6` BIGINT NOT NULL,
`HTS8` BIGINT NOT NULL,
`HTS10` BIGINT NOT NULL,
`DESCRIPTION` VARCHAR(100),
`DESCRIPTION_DETAIL` VARCHAR(200));

-- add a temp column to us_hts_6_digits table
ALTER TABLE us_hts_6_digits
ADD COLUMN HTS_temp BIGINT;
ALTER TABLE us_hts_6_digits
MODIFY COLUMN DESCRIPTION VARCHAR(100),
MODIFY COLUMN DESCRIPTION_DETAIL VARCHAR(200);

-- insert into us 6 digits table
INSERT INTO us_hts_6_digits(HTS6, `DESCRIPTION`, DESCRIPTION_DETAIL)
SELECT LEFT(hts10,6), description_short, description_long
FROM us_export_concordance_2023; 

-- insert into us 8 digits table
INSERT INTO us_hts_8_digits(HTS8, `DESCRIPTION`, DESCRIPTION_DETAIL)
SELECT LEFT(hts10,8), description_short, description_long
FROM us_export_concordance_2023; 

-- insert into us 10 digits table
INSERT INTO us_hts_10_digits(HTS10, `DESCRIPTION`, DESCRIPTION_DETAIL)
SELECT hts10, description_short, description_long
FROM us_export_concordance_2023; 

-- insert into us 8 digits table
INSERT INTO us_hts_all_digits(HTS2, HTS4, HTS6, HTS8, HTS10, `DESCRIPTION`, DESCRIPTION_DETAIL)
SELECT LEFT(hts10,2), LEFT(hts10,4), LEFT(hts10,6), LEFT(hts10,8), hts10, description_short, description_long
FROM us_export_concordance_2023; 

SELECT us.HTS6, us.DESCRIPTION, us.DESCRIPTION_DETAIL, cn.HTS6, cn.DESCRIPTION
FROM us_hts_all_digits AS us
LEFT JOIN china_hts_6_digits AS cn
ON us.HTS6 = cn.HTS6
WHERE us.HTS6 = 850440;

-- check taiwan hts database
USE customs_database;
SELECT * 
FROM tw_hts_original
ORDER BY HTS10;

DROP TABLE tw_hts_original;

-- rename column name
ALTER TABLE tw_hts_original
CHANGE `ï»¿CODES` `HTS10` BIGINT;

-- replace all percent and dollar words into symbols
UPDATE tw_hts_original
SET UNIT_1_TAX = REPLACE(UNIT_1_TAX, ' PERCENT', "%"), 
	UNIT_2_TAX = REPLACE(UNIT_2_TAX, ' PERCENT', "%"),
    UNIT_3_TAX = REPLACE(UNIT_3_TAX, ' PERCENT', "%"),
    UNIT_1_TAX = REPLACE(UNIT_1_TAX, ' DOLLAR', "$"),
    UNIT_2_TAX = REPLACE(UNIT_2_TAX, ' DOLLAR', "$"),
    UNIT_3_TAX = REPLACE(UNIT_3_TAX, ' DOLLAR', "$")
WHERE UNIT_1_TAX LIKE '% PERCENT' OR
	  UNIT_2_TAX LIKE '% PERCENT' OR
      UNIT_3_TAX LIKE '% PERCENT' OR
      UNIT_1_TAX LIKE '% DOLLAR' OR
      UNIT_2_TAX LIKE '% DOLLAR' OR
      UNIT_3_TAX LIKE '% DOLLAR';

-- Duplicate taiwan hts original table
CREATE TABLE tw_hts_all_digits SELECT * FROM tw_hts_original;

-- add 4 new columns to all digits table
ALTER TABLE tw_hts_all_digits
ADD HTS2 INT NOT NULL,
ADD	HTS4 INT NOT NULL,
ADD HTS6 BIGINT NOT NULL,
ADD HTS8 BIGINT NOT NULL;

-- append data into newly created 4 columns
-- note these are to insert as new values
INSERT INTO tw_hts_all_digits(HTS2, HTS4, HTS6, HTS8)
SELECT LEFT(HTS10, 2), LEFT(HTS10, 4), LEFT(HTS10, 6), LEFT(HTS10, 8) 
FROM tw_hts_all_digits;

-- for updating the existing ones use the following
UPDATE tw_hts_all_digits
SET HTS2 = COALESCE(LEFT(HTS10,2), ''),
	HTS4 = COALESCE(LEFT(HTS10,4), ''),
    HTS6 = COALESCE(LEFT(HTS10,6), ''),
    HTS8 = COALESCE(LEFT(HTS10,8), '');

-- check all the columns in taiwan hts all digits table
SELECT * FROM tw_hts_all_digits;
SELECT DISTINCT(LEFT(HTS10,2)) FROM tw_hts_all_digits ORDER BY HTS10 DESC LIMIT 100;
SELECT HTS10 FROM tw_hts_all_digits
WHERE HTS10 = NULL;
-- there is a null value record

-- deleting a null value record from hts10 column
DELETE FROM tw_hts_all_digits WHERE HTS10 IS NULL;