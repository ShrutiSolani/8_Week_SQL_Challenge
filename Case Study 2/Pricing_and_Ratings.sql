**Query #1**
-- If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?

    SELECT 
    SUM(CASE WHEN PIZZA_ID = 1 THEN 12 ELSE 10 END) AS EARNINGS
    FROM PIZZA_RUNNER.CLEAN_CUSTOMER_ORDERS;

| earnings |
| -------- |
| 160      |

---
**Query #2**
-- What if there was an additional $1 charge for any pizza extras?
-- Add cheese is $1 extra

    SELECT SUM(CASE WHEN PIZZA_ID = 1 THEN 12 ELSE 10 END) +
    SUM( CASE WHEN EXTRAS IS NOT NULL THEN 1 ELSE 0 END ) AS NEW_EARNINGS
    FROM PIZZA_RUNNER.CLEAN_CUSTOMER_ORDERS;

| new_earnings |
| ------------ |
| 164          |

---
**Query #3**
-- The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, 
-- how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data 
-- for ratings for each successful customer order between 1 to 5.


    DROP TABLE IF EXISTS RATINGS;
    CREATE TABLE RATINGS (
      "CUSTOMER_ID" INTEGER,
      "ORDER_ID" INTEGER,
      "RUNNER_ID" INTEGER,
      "RATING" INTEGER
    );

    INSERT INTO RATINGS("CUSTOMER_ID", "ORDER_ID", "RUNNER_ID", "RATING")
    VALUES
    ('101', '1', '1', 5),
    ('101', '2', '1', 5),
    ('102', '3' ,'1', 4),
    ('103', '4' ,'2', 4),
    ('104', '5' ,'3', 3),
    ('105', '7' ,'2', 5),
    ('102','8', '2', 4),
    ('104', '10', '1', 4);

    SELECT * FROM RATINGS;

| CUSTOMER_ID | ORDER_ID | RUNNER_ID | RATING |
| ----------- | -------- | --------- | ------ |
| 101         | 1        | 1         | 5      |
| 101         | 2        | 1         | 5      |
| 102         | 3        | 1         | 4      |
| 103         | 4        | 2         | 4      |
| 104         | 5        | 3         | 3      |
| 105         | 7        | 2         | 5      |
| 102         | 8        | 2         | 4      |
| 104         | 10       | 1         | 4      |

---
**Query #4**
-- Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
-- customer_id
-- order_id
-- runner_id
-- rating
-- order_time
-- pickup_time
-- Time between order and pickup
-- Delivery duration
-- Average speed
-- Total number of pizzas


    SELECT CO.CUSTOMER_ID, CO.ORDER_ID, RUNNER_ID, "RATING", CO.ORDER_TIME, RO.PICKUP_TIME, EXTRACT(MINUTE FROM AVG(CAST(PICKUP_TIME AS TIMESTAMP) - ORDER_TIME)) AS TIME_TO_PREPARE, RO.DURATION, ROUND(AVG(CAST(DISTANCE AS DECIMAL) / CAST(DURATION AS DECIMAL)), 2) AS AVG_SPEED, COUNT(*) AS PIZZAS_DELIVERED
    FROM PIZZA_RUNNER.CLEAN_CUSTOMER_ORDERS AS CO INNER JOIN PIZZA_RUNNER.CLEAN_RUNNER_ORDERS AS RO ON CO.ORDER_ID = RO.ORDER_ID INNER JOIN RATINGS ON CO.ORDER_ID = RATINGS."ORDER_ID" 
    WHERE RO.CANCELLATION IS NULL
    GROUP BY CO.CUSTOMER_ID, CO.ORDER_ID, RUNNER_ID, "RATING", CO.ORDER_TIME, RO.PICKUP_TIME, RO.DURATION
    ORDER BY CO.CUSTOMER_ID, CO.ORDER_ID;

| customer_id | order_id | runner_id | RATING | order_time               | pickup_time         | time_to_prepare | duration | avg_speed | pizzas_delivered |
| ----------- | -------- | --------- | ------ | ------------------------ | ------------------- | --------------- | -------- | --------- | ---------------- |
| 101         | 1        | 1         | 5      | 2020-01-01T18:05:02.000Z | 2020-01-01 18:15:34 | 10              | 32       | 0.63      | 1                |
| 101         | 2        | 1         | 5      | 2020-01-01T19:00:52.000Z | 2020-01-01 19:10:54 | 10              | 27       | 0.74      | 1                |
| 102         | 3        | 1         | 4      | 2020-01-02T23:51:23.000Z | 2020-01-03 00:12:37 | 21              | 20       | 0.67      | 2                |
| 102         | 8        | 2         | 4      | 2020-01-09T23:54:33.000Z | 2020-01-10 00:15:02 | 20              | 15       | 1.56      | 1                |
| 103         | 4        | 2         | 4      | 2020-01-04T13:23:46.000Z | 2020-01-04 13:53:03 | 29              | 40       | 0.59      | 3                |
| 104         | 5        | 3         | 3      | 2020-01-08T21:00:29.000Z | 2020-01-08 21:10:57 | 10              | 15       | 0.67      | 1                |
| 104         | 10       | 1         | 4      | 2020-01-11T18:34:49.000Z | 2020-01-11 18:50:20 | 15              | 10       | 1.00      | 2                |
| 105         | 7        | 2         | 5      | 2020-01-08T21:20:29.000Z | 2020-01-08 21:30:45 | 10              | 25       | 1.00      | 1                |

---
**Query #5**
-- If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and 
-- each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?

    SELECT 
        SUM(CASE WHEN PIZZA_ID = 1 THEN 12 ELSE 10 END) AS EARNINGS,
        SUM(CASE WHEN DURATION IS NOT NULL THEN 0.30* CAST(DURATION AS INTEGER) ELSE 0 END) AS EXPENDITURE
    FROM PIZZA_RUNNER.CLEAN_CUSTOMER_ORDERS AS CO,  PIZZA_RUNNER.CLEAN_RUNNER_ORDERS AS RO
    WHERE CO.ORDER_ID = RO.ORDER_ID;

| earnings | expenditure |
| -------- | ----------- |
| 160      | 88.20       |

---
