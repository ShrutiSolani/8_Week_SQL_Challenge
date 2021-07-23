**Schema (PostgreSQL v13)**

    CREATE SCHEMA pizza_runner;
    SET search_path = pizza_runner;
    
    DROP TABLE IF EXISTS runners;
    CREATE TABLE runners (
      "runner_id" INTEGER,
      "registration_date" DATE
    );
    INSERT INTO runners
      ("runner_id", "registration_date")
    VALUES
      (1, '2021-01-01'),
      (2, '2021-01-03'),
      (3, '2021-01-08'),
      (4, '2021-01-15');
    
    
    DROP TABLE IF EXISTS customer_orders;
    CREATE TABLE customer_orders (
      "order_id" INTEGER,
      "customer_id" INTEGER,
      "pizza_id" INTEGER,
      "exclusions" VARCHAR(4),
      "extras" VARCHAR(4),
      "order_time" TIMESTAMP
    );
    
    INSERT INTO customer_orders
      ("order_id", "customer_id", "pizza_id", "exclusions", "extras", "order_time")
    VALUES
      ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
      ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
      ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
      ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
      ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
      ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
      ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
      ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
      ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
      ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
      ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
      ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
      ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
      ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');
    
    
    DROP TABLE IF EXISTS runner_orders;
    CREATE TABLE runner_orders (
      "order_id" INTEGER,
      "runner_id" INTEGER,
      "pickup_time" VARCHAR(19),
      "distance" VARCHAR(7),
      "duration" VARCHAR(10),
      "cancellation" VARCHAR(23)
    );
    
    INSERT INTO runner_orders
      ("order_id", "runner_id", "pickup_time", "distance", "duration", "cancellation")
    VALUES
      ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
      ('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
      ('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
      ('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
      ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
      ('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
      ('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
      ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
      ('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
      ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');
    
    
    DROP TABLE IF EXISTS pizza_names;
    CREATE TABLE pizza_names (
      "pizza_id" INTEGER,
      "pizza_name" TEXT
    );
    INSERT INTO pizza_names
      ("pizza_id", "pizza_name")
    VALUES
      (1, 'Meatlovers'),
      (2, 'Vegetarian');
    
    
    DROP TABLE IF EXISTS pizza_recipes;
    CREATE TABLE pizza_recipes (
      "pizza_id" INTEGER,
      "toppings" TEXT
    );
    INSERT INTO pizza_recipes
      ("pizza_id", "toppings")
    VALUES
      (1, '1, 2, 3, 4, 5, 6, 8, 10'),
      (2, '4, 6, 7, 9, 11, 12');
    
    
    DROP TABLE IF EXISTS pizza_toppings;
    CREATE TABLE pizza_toppings (
      "topping_id" INTEGER,
      "topping_name" TEXT
    );
    INSERT INTO pizza_toppings
      ("topping_id", "topping_name")
    VALUES
      (1, 'Bacon'),
      (2, 'BBQ Sauce'),
      (3, 'Beef'),
      (4, 'Cheese'),
      (5, 'Chicken'),
      (6, 'Mushrooms'),
      (7, 'Onions'),
      (8, 'Pepperoni'),
      (9, 'Peppers'),
      (10, 'Salami'),
      (11, 'Tomatoes'),
      (12, 'Tomato Sauce');
      
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

---

**Query #1**

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
**Query #2**

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
**Query #3**

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

[View on DB Fiddle](https://www.db-fiddle.com/f/7VcQKQwsS3CTkGRFG7vu98/65)
