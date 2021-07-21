**Schema (PostgreSQL v13)**
-- CLEANING CUSTOMER_ORDERS

    DROP TABLE IF EXISTS CLEAN_CUSTOMER_ORDERS;

    CREATE TABLE CLEAN_CUSTOMER_ORDERS AS(
      SELECT PIZZA_RUNNER.CUSTOMER_ORDERS.ORDER_ID,
      PIZZA_RUNNER.CUSTOMER_ORDERS.CUSTOMER_ID,
      PIZZA_RUNNER.CUSTOMER_ORDERS.PIZZA_ID,
      CASE
      WHEN PIZZA_RUNNER.CUSTOMER_ORDERS.EXCLUSIONS = '' THEN NULL
      WHEN PIZZA_RUNNER.CUSTOMER_ORDERS.EXCLUSIONS = 'null' THEN NULL
      ELSE PIZZA_RUNNER.CUSTOMER_ORDERS.EXCLUSIONS
      END AS EXCLUSIONS,
      CASE
      WHEN PIZZA_RUNNER.CUSTOMER_ORDERS.EXTRAS = '' THEN NULL
      WHEN PIZZA_RUNNER.CUSTOMER_ORDERS.EXTRAS = 'null' THEN NULL
      ELSE PIZZA_RUNNER.CUSTOMER_ORDERS.EXTRAS
      END AS EXTRAS,
      PIZZA_RUNNER.CUSTOMER_ORDERS.ORDER_TIME
      
      FROM PIZZA_RUNNER.CUSTOMER_ORDERS
    );

    SELECT * FROM CLEAN_CUSTOMER_ORDERS;

| order_id | customer_id | pizza_id | exclusions | extras | order_time               |
| -------- | ----------- | -------- | ---------- | ------ | ------------------------ |
| 1        | 101         | 1        |            |        | 2020-01-01T18:05:02.000Z |
| 2        | 101         | 1        |            |        | 2020-01-01T19:00:52.000Z |
| 3        | 102         | 1        |            |        | 2020-01-02T23:51:23.000Z |
| 3        | 102         | 2        |            |        | 2020-01-02T23:51:23.000Z |
| 4        | 103         | 1        | 4          |        | 2020-01-04T13:23:46.000Z |
| 4        | 103         | 1        | 4          |        | 2020-01-04T13:23:46.000Z |
| 4        | 103         | 2        | 4          |        | 2020-01-04T13:23:46.000Z |
| 5        | 104         | 1        |            | 1      | 2020-01-08T21:00:29.000Z |
| 6        | 101         | 2        |            |        | 2020-01-08T21:03:13.000Z |
| 7        | 105         | 2        |            | 1      | 2020-01-08T21:20:29.000Z |
| 8        | 102         | 1        |            |        | 2020-01-09T23:54:33.000Z |
| 9        | 103         | 1        | 4          | 1, 5   | 2020-01-10T11:22:59.000Z |
| 10       | 104         | 1        |            |        | 2020-01-11T18:34:49.000Z |
| 10       | 104         | 1        | 2, 6       | 1, 4   | 2020-01-11T18:34:49.000Z |

---


-- CLEANING RUNNER_ORDERS
    DROP TABLE IF EXISTS CLEAN_RUNNER_ORDERS;

    CREATE TABLE CLEAN_RUNNER_ORDERS AS (
      SELECT PIZZA_RUNNER.RUNNER_ORDERS.ORDER_ID,
      PIZZA_RUNNER.RUNNER_ORDERS.RUNNER_ID,
      CASE
      WHEN PIZZA_RUNNER.RUNNER_ORDERS.PICKUP_TIME = 'null' THEN NULL
      ELSE PIZZA_RUNNER.RUNNER_ORDERS.PICKUP_TIME
      END AS PICKUP_TIME,
      CASE 
      WHEN PIZZA_RUNNER.RUNNER_ORDERS.DISTANCE = 'null' THEN NULL
      WHEN PIZZA_RUNNER.RUNNER_ORDERS.DISTANCE LIKE '%km' THEN
      REGEXP_REPLACE(PIZZA_RUNNER.RUNNER_ORDERS.DISTANCE,'[[:alpha:]]','','g')
      ELSE PIZZA_RUNNER.RUNNER_ORDERS.DISTANCE
      END AS DISTANCE,
      CASE 
      WHEN PIZZA_RUNNER.RUNNER_ORDERS.DURATION = 'null' THEN NULL
      WHEN PIZZA_RUNNER.RUNNER_ORDERS.DURATION LIKE '%m%' 
      THEN REGEXP_REPLACE(PIZZA_RUNNER.RUNNER_ORDERS.DURATION,'[[:alpha:]]','','g')
      ELSE PIZZA_RUNNER.RUNNER_ORDERS.DURATION
      END AS DURATION,
      CASE 
      WHEN PIZZA_RUNNER.RUNNER_ORDERS.CANCELLATION = 'null' THEN NULL
      WHEN PIZZA_RUNNER.RUNNER_ORDERS.CANCELLATION = '' THEN NULL
      ELSE PIZZA_RUNNER.RUNNER_ORDERS.CANCELLATION
      END AS CANCELLATION
      
      FROM PIZZA_RUNNER.RUNNER_ORDERS
    );

    SELECT * FROM CLEAN_RUNNER_ORDERS;

| order_id | runner_id | pickup_time         | distance | duration | cancellation            |
| -------- | --------- | ------------------- | -------- | -------- | ----------------------- |
| 1        | 1         | 2020-01-01 18:15:34 | 20       | 32       |                         |
| 2        | 1         | 2020-01-01 19:10:54 | 20       | 27       |                         |
| 3        | 1         | 2020-01-03 00:12:37 | 13.4     | 20       |                         |
| 4        | 2         | 2020-01-04 13:53:03 | 23.4     | 40       |                         |
| 5        | 3         | 2020-01-08 21:10:57 | 10       | 15       |                         |
| 6        | 3         |                     |          |          | Restaurant Cancellation |
| 7        | 2         | 2020-01-08 21:30:45 | 25       | 25       |                         |
| 8        | 2         | 2020-01-10 00:15:02 | 23.4     | 15       |                         |
| 9        | 2         |                     |          |          | Customer Cancellation   |
| 10       | 1         | 2020-01-11 18:50:20 | 10       | 10       |                         |

---
