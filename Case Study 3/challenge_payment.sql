**Query #1**

    CREATE TABLE PAYMENTS
    (
      customer_id INTEGER,
      plan_id INTEGER,
      plan_name VARCHAR(13),
      payment_date DATE,
      amount DECIMAL(5,2),
      payment_order INTEGER
    );

There are no results to be displayed.

---
**Query #2**

    CREATE TABLE NEXT_PLAN AS (
       SELECT *, LEAD(PLAN_ID, 1) OVER(PARTITION BY CUSTOMER_ID ORDER BY START_DATE) AS NEXT_PLAN_ID, LEAD(START_DATE, 1) OVER(PARTITION BY CUSTOMER_ID ORDER BY START_DATE) AS NEXT_DATE
          FROM FOODIE_FI.SUBSCRIPTIONS
    );

There are no results to be displayed.

---
**Query #3**

    SELECT SUBS.CUSTOMER_ID, SUBS.PLAN_ID, PLAN_NAME, SUBS.START_DATE, NEXT_PLAN_ID, 
    (CASE WHEN NEXT_DATE IS NULL THEN '2020-12-08' ELSE NEXT_DATE END) AS END_DATE, PRICE
    FROM FOODIE_FI.SUBSCRIPTIONS AS SUBS JOIN FOODIE_FI.PLANS AS PLAN ON SUBS.PLAN_ID = PLAN.PLAN_ID LEFT JOIN NEXT_PLAN ON SUBS.CUSTOMER_ID = NEXT_PLAN.CUSTOMER_ID AND SUBS.PLAN_ID = NEXT_PLAN.PLAN_ID
    WHERE SUBS.PLAN_ID != 0
    ORDER BY SUBS.CUSTOMER_ID, SUBS.START_DATE
    LIMIT 20;

| customer_id | plan_id | plan_name     | start_date               | next_plan_id | end_date                 | price  |
| ----------- | ------- | ------------- | ------------------------ | ------------ | ------------------------ | ------ |
| 1           | 1       | basic monthly | 2020-08-08T00:00:00.000Z |              | 2020-12-08T00:00:00.000Z | 9.90   |
| 2           | 3       | pro annual    | 2020-09-27T00:00:00.000Z |              | 2020-12-08T00:00:00.000Z | 199.00 |
| 3           | 1       | basic monthly | 2020-01-20T00:00:00.000Z |              | 2020-12-08T00:00:00.000Z | 9.90   |
| 4           | 1       | basic monthly | 2020-01-24T00:00:00.000Z | 4            | 2020-04-21T00:00:00.000Z | 9.90   |
| 4           | 4       | churn         | 2020-04-21T00:00:00.000Z |              | 2020-12-08T00:00:00.000Z |        |
| 5           | 1       | basic monthly | 2020-08-10T00:00:00.000Z |              | 2020-12-08T00:00:00.000Z | 9.90   |
| 6           | 1       | basic monthly | 2020-12-30T00:00:00.000Z | 4            | 2021-02-26T00:00:00.000Z | 9.90   |
| 6           | 4       | churn         | 2021-02-26T00:00:00.000Z |              | 2020-12-08T00:00:00.000Z |        |
| 7           | 1       | basic monthly | 2020-02-12T00:00:00.000Z | 2            | 2020-05-22T00:00:00.000Z | 9.90   |
| 7           | 2       | pro monthly   | 2020-05-22T00:00:00.000Z |              | 2020-12-08T00:00:00.000Z | 19.90  |
| 8           | 1       | basic monthly | 2020-06-18T00:00:00.000Z | 2            | 2020-08-03T00:00:00.000Z | 9.90   |
| 8           | 2       | pro monthly   | 2020-08-03T00:00:00.000Z |              | 2020-12-08T00:00:00.000Z | 19.90  |
| 9           | 3       | pro annual    | 2020-12-14T00:00:00.000Z |              | 2020-12-08T00:00:00.000Z | 199.00 |
| 10          | 2       | pro monthly   | 2020-09-26T00:00:00.000Z |              | 2020-12-08T00:00:00.000Z | 19.90  |
| 11          | 4       | churn         | 2020-11-26T00:00:00.000Z |              | 2020-12-08T00:00:00.000Z |        |
| 12          | 1       | basic monthly | 2020-09-29T00:00:00.000Z |              | 2020-12-08T00:00:00.000Z | 9.90   |
| 13          | 1       | basic monthly | 2020-12-22T00:00:00.000Z | 2            | 2021-03-29T00:00:00.000Z | 9.90   |
| 13          | 2       | pro monthly   | 2021-03-29T00:00:00.000Z |              | 2020-12-08T00:00:00.000Z | 19.90  |
| 14          | 1       | basic monthly | 2020-09-29T00:00:00.000Z |              | 2020-12-08T00:00:00.000Z | 9.90   |
| 15          | 2       | pro monthly   | 2020-03-24T00:00:00.000Z | 4            | 2020-04-29T00:00:00.000Z | 19.90  |

---

