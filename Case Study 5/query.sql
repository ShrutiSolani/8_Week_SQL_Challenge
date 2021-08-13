-- In a single query, perform the following operations and generate a new table in the data_mart schema named clean_weekly_sales:

-- Convert the week_date to a DATE format

-- Add a week_number as the second column for each week_date value, for example any value from the 1st of January to 7th of January will be 1, 8th to 14th will be 2 etc

-- Add a month_number with the calendar month for each week_date value as the 3rd column

-- Add a calendar_year column as the 4th column containing either 2018, 2019 or 2020 values

-- Add a new column called age_band after the original segment column using the following mapping on the number inside the segment value
-- 1	Young Adults
-- 2	Middle Aged
-- 3 or 4	Retirees

-- Add a new demographic column using the following mapping for the first letter in the segment values:
-- segment	demographic
-- C	Couples
-- F	Families

-- Ensure all null string values with an "unknown" string value in the original segment column as well as the new age_band and demographic columns

-- Generate a new avg_transaction column as the sales value divided by transactions rounded to 2 decimal places for each record

DROP TABLE IF EXISTS DATA_MART.CLEAN_WEEKLY_SALES;
CREATE TABLE CLEAN_WEEKLY_SALES AS(
  SELECT CAST(WEEK_DATE AS DATE) AS WEEK_DATE,
  CASE
  WHEN EXTRACT (DAY FROM  CAST(WEEK_DATE AS DATE)) >= 1 AND EXTRACT (DAY FROM CAST(WEEK_DATE AS DATE)) <= 7 THEN 1 
  WHEN EXTRACT (DAY FROM  CAST(WEEK_DATE AS DATE)) > 7 AND  EXTRACT (DAY FROM CAST(WEEK_DATE AS DATE))<= 14 THEN 2
  WHEN EXTRACT (DAY FROM CAST(WEEK_DATE AS DATE)) > 14 AND EXTRACT (DAY FROM CAST(WEEK_DATE AS DATE)) <= 21 THEN 3
  WHEN EXTRACT (DAY FROM CAST(WEEK_DATE AS DATE)) > 21 AND EXTRACT (DAY FROM  CAST(WEEK_DATE AS DATE)) <= 28 THEN 4
    ELSE 5
    END AS WEEK_NUMBER,
  EXTRACT (MONTH FROM (CAST(WEEK_DATE AS DATE))) AS MONTH_NUMBER,
  EXTRACT (YEAR FROM CAST(WEEK_DATE AS DATE)) AS CALENDAR_YEAR,
  REGION,
  PLATFORM,
  CASE
  WHEN SEGMENT LIKE 'null' THEN 'Unkown'
   ELSE SEGMENT
    END AS SEGMENT,
 CASE
 WHEN SEGMENT LIKE '%1' THEN 'Young Adults'
 WHEN SEGMENT LIKE '%2' THEN 'Middle Aged'
 WHEN SEGMENT LIKE '%3' OR SEGMENT LIKE '%4' THEN 'Retirees'
 ELSE'Unkown'
 END AS AGE_BAND,
  CASE
 WHEN SEGMENT LIKE 'C%' THEN 'Young Adults'
 WHEN SEGMENT LIKE 'F%' THEN 'Middle Aged'
 ELSE 'Unkown'
 END AS DEMOGRAPHIC,
CUSTOMER_TYPE,
TRANSACTIONS,
SALES,
ROUND((SALES / TRANSACTIONS), 2) AS AVG_TRANSACTION
FROM data_mart.weekly_sales
);

-- SELECT * FROM DATA_MART.CLEAN_WEEKLY_SALES
