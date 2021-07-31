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


|plan_id|number	|total	|percentage|
|-------| ------|-------|----------|
|1	    |546 	|546	|100.0     |
|2	    |325 	|539 	|60.3      |
|3	    |37	    |258	|14.3      |
|4	    |92	    |307	|30.0      |
