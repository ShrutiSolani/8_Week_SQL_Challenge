-- Query 1
--How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

    SELECT TO_CHAR(REGISTRATION_DATE, 'W') AS WEEK, COUNT(*)
    FROM PIZZA_RUNNER.RUNNERS
    GROUP BY WEEK
    ORDER BY WEEK;

| week | count |
| ---- | ----- |
| 1    | 2     |
| 2    | 1     |
| 3    | 1     |

---
-- Query 2
-- What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

    SELECT RUNNER_ID , EXTRACT(MINUTE FROM AVG(CAST(PICKUP_TIME AS TIMESTAMP) - ORDER_TIME)) AS AVERAGE_TIME
    FROM PIZZA_RUNNER.CLEAN_CUSTOMER_ORDERS AS CO JOIN PIZZA_RUNNER.CLEAN_RUNNER_ORDERS AS RO ON CO.ORDER_ID = RO.ORDER_ID
    WHERE RO.PICKUP_TIME IS NOT NULL 
    GROUP BY RUNNER_ID
    ORDER BY RUNNER_ID;

| runner_id | average_time |
| --------- | ------------ |
| 1         | 15           |
| 2         | 23           |
| 3         | 10           |

---
-- Query 3
-- Is there any relationship between the number of pizzas and how long the order takes to prepare?

    SELECT CO.ORDER_ID, COUNT(*) AS PIZZAS_DELIVERED, EXTRACT(MINUTE FROM AVG(CAST(PICKUP_TIME AS TIMESTAMP) - ORDER_TIME)) AS TIME_TO_PREPARE
    FROM PIZZA_RUNNER.CLEAN_CUSTOMER_ORDERS AS CO JOIN PIZZA_RUNNER.CLEAN_RUNNER_ORDERS AS RO ON CO.ORDER_ID = RO.ORDER_ID 
    GROUP BY CO.ORDER_ID
    ORDER BY PIZZAS_DELIVERED;

| order_id | pizzas_delivered | time_to_prepare |
| -------- | ---------------- | --------------- |
| 8        | 1                | 20              |
| 7        | 1                | 10              |
| 1        | 1                | 10              |
| 9        | 1                |                 |
| 5        | 1                | 10              |
| 6        | 1                |                 |
| 2        | 1                | 10              |
| 3        | 2                | 21              |
| 10       | 2                | 15              |
| 4        | 3                | 29              |

---
-- Query 4
-- What was the average distance travelled for each customer?

    SELECT CUSTOMER_ID, ROUND(AVG(CAST(DISTANCE AS DECIMAL)), 2)
    FROM PIZZA_RUNNER.CLEAN_CUSTOMER_ORDERS AS CO JOIN PIZZA_RUNNER.CLEAN_RUNNER_ORDERS AS RO ON CO.ORDER_ID = RO.ORDER_ID
    GROUP BY CUSTOMER_ID
    ORDER BY CUSTOMER_ID;

| customer_id | round |
| ----------- | ----- |
| 101         | 20.00 |
| 102         | 16.73 |
| 103         | 23.40 |
| 104         | 10.00 |
| 105         | 25.00 |

---
-- Query 5
-- What was the difference between the longest and shortest delivery times for all orders?

    SELECT (MAX(CAST(DURATION AS DECIMAL)) - MIN(CAST(DURATION AS DECIMAL))) AS DIFFERENCE
    FROM PIZZA_RUNNER.CLEAN_RUNNER_ORDERS;

| difference |
| ---------- |
| 30         |

---
-- Query 6
-- What was the average speed for each runner for each delivery and do you notice any trend for these values?

    SELECT RUNNER_ID, ORDER_ID, ROUND(AVG(CAST(DISTANCE AS DECIMAL) / CAST(DURATION AS DECIMAL)), 2) AS "KM/MIN"
    FROM PIZZA_RUNNER.CLEAN_RUNNER_ORDERS
    WHERE CANCELLATION IS NULL
    GROUP BY RUNNER_ID, ORDER_ID
    ORDER BY RUNNER_ID, ORDER_ID;

| runner_id | order_id | KM/MIN |
| --------- | -------- | ------ |
| 1         | 1        | 0.63   |
| 1         | 2        | 0.74   |
| 1         | 3        | 0.67   |
| 1         | 10       | 1.00   |
| 2         | 4        | 0.59   |
| 2         | 7        | 1.00   |
| 2         | 8        | 1.56   |
| 3         | 5        | 0.67   |


---
-- Query 7
-- What is the successful delivery percentage for each runner?

    SELECT RUNNER_ID, ROUND((CAST(SUM(CASE WHEN CANCELLATION IS NOT NULL THEN 0 ELSE 1 END) AS DECIMAL) / COUNT(ORDER_ID))*100, 2) AS SUCCESS_PERCENT                         FROM PIZZA_RUNNER.CLEAN_RUNNER_ORDERS
    GROUP BY RUNNER_ID
    ORDER BY RUNNER_ID;

| runner_id | success_percent |
| --------- | --------------- |
| 1         | 100.00          |
| 2         | 75.00           |
| 3         | 50.00           |

---
