CREATE DATABASE customer;

USE customer;
CREATE TABLE regular (CUSTOMEregularR_ID int, CUSTOMER_NAME varchar(20), PHONE numeric(10));

ALTER TABLE regular
ADD address varchar(50);

ALTER TABLE regular
RENAME COLUMN address to ADDRESS;

ALTER TABLE regular
DROP COLUMN ADDRESS;

ALTER TABLE regular
MODIFY COLUMN PHONE numeric(12);

INSERT INTO regular
VALUES (001, "John", 4848085104);

INSERT INTO regular
VALUES (002, "Roger", 126848965);

INSERT INTO regular
VALUES (003, "Dylan", 15878965268),
 (004, "Arthur", 1689856598),
 (005, "Joseph", 1597896524);
 
INSERT INTO customer.regular
VALUES(006, "Jackson", 4566987745);
 
USE customer;
UPDATE regular 
SET PHONE = '1372408504'
WHERE CUSTOMER_ID = 2;

DELETE FROM regular
WHERE CUSTOMER_ID = 5;

SELECT CUSTOMER_ID, CUSTOMER_NAME, PHONE
FROM regular
WHERE CUSTOMER_ID >2 AND CUSTOMER_ID<4;

SELECT *
FROM customer.regular;

TRUNCATE TABLE regular;
DROP TABLE regular;
DROP DATABASE customer;

SELECT *
FROM facebook_campaign.dataset_facebook_improved_1
WHERE lifetime_post_total_impressions > 3000
ORDER BY lifetime_post_total_impressions DESC
;

SELECT `type`, production_studio, SUM(lifetime_post_total_reach) AS TOTAL_LIFETIME_REACH, SUM(lifetime_post_total_impressions) AS TOTAL_LIFETIME_IMPRESSIONS
FROM facebook_campaign.dataset_facebook_improved_1
GROUP BY `type`, production_studio
HAVING `type` = 'Photo' && TOTAL_LIFETIME_IMPRESSIONS > 20000
ORDER BY TOTAL_LIFETIME_IMPRESSIONS DESC
;

GRANT SELECT ON facebook_campaign.dataset_facebook_improved_1 TO Hank;
REVOKE SELECT ON facebook_campaign.dataset_facebook_improved_1 FROM Hank;
DENY SELECT ON facebook_campaign.dataset_facebook_improved_1 TO Hank;

ALTER TABLE customer.regular
ADD PRIMARY KEY (CUSTOMER_ID);

ALTER TABLE customer.regular
ADD FOREIGN KEY (CUSTOMER_NAME)
REFERENCES facebook_campaign.dataset_facebook_improved_1(production_studio);

ALTER TABLE customer.regular
ADD UNIQUE (CUSTOMER_NAME);

ALTER TABLE customer.regular
ADD CHECK (LENGTH(CUSTOMER_NAME) > 5);

ALTER TABLE customer.regular
MODIFY COLUMN CUSTOMER_NAME VARCHAR(30) NOT NULL;

ALTER TABLE customer.regular
ADD COLUMN COMPANY VARCHAR(30) NOT NULL;

ALTER TABLE customer.regular
MODIFY COLUMN COMPANY DEFAULT 99999;

ALTER TABLE customer.regular
DROP CONSTRAINT NOT NULL;

ALTER TABLE customer.regular
DROP PRIMARY KEY;



UPDATE customer.regular
SET COMPANY = 'animationfeast'
WHERE CUSTOMER_NAME = 'John';

UPDATE customer.regular
SET COMPANY = 'production_photo'
WHERE CUSTOMER_NAME = 'Roger';

UPDATE customer.regular
SET COMPANY = 'purei'
WHERE CUSTOMER_NAME = 'Dylan';

UPDATE customer.regular
SET COMPANY = 'socialyn '
WHERE CUSTOMER_NAME = 'Arthur';

UPDATE customer.regular
SET COMPANY = 'whooshi'
WHERE CUSTOMER_NAME = 'Joseph';

UPDATE customer.regular
SET COMPANY = 'production_photo'
WHERE CUSTOMER_NAME = 'Jackson';

INSERT INTO customer.regular
VALUES (7, "Johnny", 4568774565, 'socialyn'),
		(8, "Rick", 789456123, 'self_made');
        
SELECT cus.CUSTOMER_NAME AS 'Customer Name', fb.production_studio AS 'Studio', SUM(fb.total_interactions) AS 'Total Interactions'
FROM facebook_campaign.dataset_facebook_improved_1 AS fb
LEFT JOIN customer.regular AS cus
ON fb.production_studio = cus.COMPANY
GROUP BY cus.CUSTOMER_NAME, fb.production_studio
ORDER BY SUM(fb.total_interactions) DESC;

UPDATE  customer.regular
SET COMPANY = 'sociallab'
WHERE CUSTOMER_NAME = 'Johnny';

UPDATE customer.regular
SET COMPANY = 'socialyn'
WHERE CUSTOMER_NAME = 'Dylan';

UPDATE customer.regular
SET COMPANY = 'socialyn '
WHERE CUSTOMER_NAME = 'Jackson';