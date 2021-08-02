**Query #1**
-- How many customers has Foodie-Fi ever had?

    SELECT COUNT(DISTINCT CUSTOMER_ID)
    FROM FOODIE_FI.SUBSCRIPTIONS;

| count |
| ----- |
| 1000  |

---
**Query #2**
-- What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value

    SELECT DATE_TRUNC('MONTH', START_DATE) AS START_DATE, COUNT(PLAN_ID)
    FROM FOODIE_FI.SUBSCRIPTIONS
    WHERE PLAN_ID = 0
    GROUP BY DATE_TRUNC('MONTH', START_DATE);

| start_date               | count |
| ------------------------ | ----- |
| 2020-01-01T00:00:00.000Z | 88    |
| 2020-02-01T00:00:00.000Z | 68    |
| 2020-03-01T00:00:00.000Z | 94    |
| 2020-04-01T00:00:00.000Z | 81    |
| 2020-05-01T00:00:00.000Z | 88    |
| 2020-06-01T00:00:00.000Z | 79    |
| 2020-07-01T00:00:00.000Z | 89    |
| 2020-08-01T00:00:00.000Z | 88    |
| 2020-09-01T00:00:00.000Z | 87    |
| 2020-10-01T00:00:00.000Z | 79    |
| 2020-11-01T00:00:00.000Z | 75    |
| 2020-12-01T00:00:00.000Z | 84    |

---
**Query #3**
-- What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name

    SELECT DATE_TRUNC('MONTH', START_DATE) AS START_DATE, SUB.PLAN_ID, PLAN_NAME, COUNT(SUB.PLAN_ID)
    FROM FOODIE_FI.SUBSCRIPTIONS SUB JOIN FOODIE_FI.PLANS PL ON SUB.PLAN_ID = PL.PLAN_ID 
    WHERE START_DATE > '2020-12-31'
    GROUP BY DATE_TRUNC('MONTH', START_DATE), SUB.PLAN_ID, PLAN_NAME
    ORDER BY START_DATE;


| start_date               | plan_id | plan_name     | count |
| ------------------------ | ------- | ------------- | ----- |
| 2021-01-01T00:00:00.000Z | 1       | basic monthly | 8     |
| 2021-01-01T00:00:00.000Z | 2       | pro monthly   | 26    |
| 2021-01-01T00:00:00.000Z | 3       | pro annual    | 24    |
| 2021-01-01T00:00:00.000Z | 4       | churn         | 19    |
| 2021-02-01T00:00:00.000Z | 2       | pro monthly   | 12    |
| 2021-02-01T00:00:00.000Z | 3       | pro annual    | 17    |
| 2021-02-01T00:00:00.000Z | 4       | churn         | 18    |
| 2021-03-01T00:00:00.000Z | 2       | pro monthly   | 15    |
| 2021-03-01T00:00:00.000Z | 3       | pro annual    | 9     |
| 2021-03-01T00:00:00.000Z | 4       | churn         | 21    |
| 2021-04-01T00:00:00.000Z | 2       | pro monthly   | 7     |
| 2021-04-01T00:00:00.000Z | 3       | pro annual    | 13    |
| 2021-04-01T00:00:00.000Z | 4       | churn         | 13    |
    
---
**Query #4**
-- What is the customer count and percentage of customers who have churned rounded to 1 decimal place?

    SELECT COUNT(CASE WHEN PLAN_ID = 4 THEN 1 END) AS CUSTOMER_COUNT, COUNT(DISTINCT CUSTOMER_ID) AS TOTAL_CUSTOMERS, ROUND(COUNT(CASE WHEN PLAN_ID = 4 THEN 1 END)* 100.0 / COUNT(DISTINCT CUSTOMER_ID), 1) AS PERCENTAGE
    FROM FOODIE_FI.SUBSCRIPTIONS;

| customer_count | total_customers | percentage |
| -------------- | --------------- | ---------- |
| 307            | 1000            | 30.7       |

---
**Query #5**
-- How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?

    CREATE TABLE PREV_PLAN AS (
      SELECT *, LAG(PLAN_ID, 1) OVER(PARTITION BY CUSTOMER_ID ORDER BY START_DATE) AS PREV_PLAN_ID
      FROM FOODIE_FI.SUBSCRIPTIONS
    );


    SELECT COUNT(DISTINCT CUSTOMER_ID) AS CUSTOMER_COUNT, ROUND(COUNT(DISTINCT CUSTOMER_ID)* 100.0 / 1000, 1)  AS CHURN_AFTER_TRIAL
    FROM PREV_PLAN
    WHERE PREV_PLAN_ID = 0 AND PLAN_ID = 4;

| customer_count | churn_after_trial |
| -------------- | ----------------- |
| 92             | 9.2               |

---
**Query #6**
-- What is the number and percentage of customer plans after their initial free trial?

CREATE TABLE PREV_PLAN AS (
      SELECT *, LAG(PLAN_ID, 1) OVER(PARTITION BY CUSTOMER_ID ORDER BY START_DATE) AS PREV_PLAN_ID
      FROM FOODIE_FI.SUBSCRIPTIONS
    );
    
CREATE TABLE CONVERSIONS AS (
  SELECT PLAN_ID, COUNT(*) AS TOTAL
  FROM PREV_PLAN
  WHERE PLAN_ID IS NOT NULL
  GROUP BY PLAN_ID
  ORDER BY PLAN_ID
);

-- SELECT * FROM CONVERSIONS;

SELECT PREV_PLAN.PLAN_ID, COUNT(DISTINCT CUSTOMER_ID) AS NUMBER, TOTAL, ROUND(COUNT(DISTINCT CUSTOMER_ID)*100.0/ TOTAL, 1) AS PERCENTAGE
FROM PREV_PLAN JOIN CONVERSIONS ON PREV_PLAN.PLAN_ID = CONVERSIONS.PLAN_ID
WHERE PREV_PLAN_ID = 0
GROUP BY PREV_PLAN.PLAN_ID, TOTAL;


| plan_id | number | total | percentage |
| ------- | ------ | ----- | ---------- |
| 1       | 546    | 546   | 100.0      |
| 2       | 325    | 539   | 60.3       |
| 3       | 37     | 258   | 14.3       |
| 4       | 92     | 307   | 30.0       |

---
**Query #7**
-- What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?

WITH next_date_cte AS (
    SELECT *,
            LEAD (start_date, 1) OVER (PARTITION BY customer_id ORDER BY start_date) AS next_date
    FROM foodie_fi.subscriptions
),
customers_on_date_cte AS (
    SELECT plan_id, COUNT(DISTINCT customer_id) AS customers
    FROM next_date_cte
    WHERE (next_date IS NOT NULL AND ('2020-12-31'::DATE > start_date AND '2020-12-31'::DATE < next_date))
        OR (next_date IS NULL AND '2020-12-31'::DATE > start_date)
    GROUP BY plan_id
)

SELECT plan_id, customers, ROUND(CAST(customers::FLOAT / 1000::FLOAT * 100 AS NUMERIC), 2) AS percent
FROM customers_on_date_cte;

| plan_id | customers | percent |
| ------- | --------- | ------- |
| 0       | 19        | 1.90    |
| 1       | 224       | 22.40   |
| 2       | 326       | 32.60   |
| 3       | 195       | 19.50   |
| 4       | 235       | 23.50   |
        
---
**Query #8**
-- How many customers have upgraded to an annual plan in 2020?

    SELECT COUNT(DISTINCT CUSTOMER_ID) AS TOTAL
    FROM FOODIE_FI.SUBSCRIPTIONS
    WHERE PLAN_ID = 3 AND EXTRACT(YEAR FROM START_DATE) = 2020;

| total |
| ----- |
| 195   |

---        
**Query #9**
-- How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi? 
        
    WITH TRIAL_START_DATE AS (
      SELECT CUSTOMER_ID, START_DATE
      FROM FOODIE_FI.SUBSCRIPTIONS
      WHERE PLAN_ID = 0
    ),
    ANNUAL_DATE AS (
      SELECT CUSTOMER_ID, START_DATE AS PRO_ANNUAL_UPGRADE_DATE
      FROM FOODIE_FI.SUBSCRIPTIONS
      WHERE PLAN_ID = 3
    )
    
    SELECT ROUND(AVG(PRO_ANNUAL_UPGRADE_DATE - START_DATE), 2) AS AVERAGE
    FROM TRIAL_START_DATE JOIN ANNUAL_DATE ON TRIAL_START_DATE.CUSTOMER_ID = ANNUAL_DATE.CUSTOMER_ID;

| average |
| ------- |
| 104.62  |

---
**Query #10**
-- Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)
    WITH TRIAL_START_DATE AS (
      SELECT CUSTOMER_ID, START_DATE
      FROM FOODIE_FI.SUBSCRIPTIONS
      WHERE PLAN_ID = 0
    ),
    ANNUAL_DATE AS (
      SELECT CUSTOMER_ID, START_DATE AS PRO_ANNUAL_UPGRADE_DATE
      FROM FOODIE_FI.SUBSCRIPTIONS
      WHERE PLAN_ID = 3
    ),
    WIDTH AS (
      SELECT WIDTH_BUCKET(PRO_ANNUAL_UPGRADE_DATE - START_DATE,0, 360, 12) AS DAYS_RANGE
      FROM ANNUAL_DATE JOIN TRIAL_START_DATE ON TRIAL_START_DATE.CUSTOMER_ID = ANNUAL_DATE.CUSTOMER_ID
    )
    
    SELECT (DAYS_RANGE-1)*30 || '-' || (DAYS_RANGE)*30, COUNT(*)
    FROM WIDTH
    GROUP BY DAYS_RANGE
    ORDER BY DAYS_RANGE;

| ?column? | count |
| -------- | ----- |
| 0-30     | 48    |
| 30-60    | 25    |
| 60-90    | 33    |
| 90-120   | 35    |
| 120-150  | 43    |
| 150-180  | 35    |
| 180-210  | 27    |
| 210-240  | 4     |
| 240-270  | 5     |
| 270-300  | 1     |
| 300-330  | 1     |
| 330-360  | 1     |

---
**Query #11**
-- How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

    CREATE TABLE PREV_PLAN AS (
          SELECT *, LAG(PLAN_ID, 1) OVER(PARTITION BY CUSTOMER_ID ORDER BY START_DATE) AS PREV_PLAN_ID
          FROM FOODIE_FI.SUBSCRIPTIONS
        );


    SELECT COUNT(*)
    FROM PREV_PLAN
    WHERE PREV_PLAN_ID = 2 AND PLAN_ID = 1;

| count |
| ----- |
| 0     |

---

