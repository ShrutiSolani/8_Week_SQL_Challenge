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

    SELECT DATE_TRUNC('MONTH', START_DATE) AS START_DATE, PLAN_ID, COUNT(PLAN_ID)
    FROM FOODIE_FI.SUBSCRIPTIONS
    WHERE START_DATE > '2020-12-31'
    GROUP BY DATE_TRUNC('MONTH', START_DATE), PLAN_ID
    ORDER BY START_DATE;

| start_date               | plan_id | count |
| ------------------------ | ------- | ----- |
| 2021-01-01T00:00:00.000Z | 4       | 19    |
| 2021-01-01T00:00:00.000Z | 1       | 8     |
| 2021-01-01T00:00:00.000Z | 3       | 24    |
| 2021-01-01T00:00:00.000Z | 2       | 26    |
| 2021-02-01T00:00:00.000Z | 3       | 17    |
| 2021-02-01T00:00:00.000Z | 4       | 18    |
| 2021-02-01T00:00:00.000Z | 2       | 12    |
| 2021-03-01T00:00:00.000Z | 3       | 9     |
| 2021-03-01T00:00:00.000Z | 2       | 15    |
| 2021-03-01T00:00:00.000Z | 4       | 21    |
| 2021-04-01T00:00:00.000Z | 4       | 13    |
| 2021-04-01T00:00:00.000Z | 3       | 13    |
| 2021-04-01T00:00:00.000Z | 2       | 7     |

---
