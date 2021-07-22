--How many pizzas were ordered?

    SELECT COUNT(*) AS TOTAL_PIZZAS_ORDERED
    FROM CLEAN_CUSTOMER_ORDERS;

| total_pizzas_ordered |
| -------------------- |
| 14                   |

---
--How many unique customer orders were made?

    SELECT COUNT(DISTINCT ORDER_TIME) AS UNIQUE_CUSTOMER_ORDERS
    FROM CLEAN_CUSTOMER_ORDERS;

| unique_customer_orders |
| ---------------------- |
| 10                     |

---
--How many successful orders were delivered by each runner?

    SELECT RUNNER_ID, COUNT(*)
    FROM CLEAN_RUNNER_ORDERS
    WHERE CANCELLATION IS NULL
    GROUP BY RUNNER_ID;

| runner_id | count |
| --------- | ----- |
| 1         | 4     |
| 2         | 3     |
| 3         | 1     |

---
--How many of each type of pizza was delivered?

    SELECT CLEAN_CUSTOMER_ORDERS.PIZZA_ID, PIZZA_NAME, COUNT(*)
    FROM CLEAN_CUSTOMER_ORDERS JOIN CLEAN_RUNNER_ORDERS
    ON CLEAN_CUSTOMER_ORDERS.ORDER_ID = CLEAN_RUNNER_ORDERS.ORDER_ID
    JOIN PIZZA_RUNNER.PIZZA_NAMES ON CLEAN_CUSTOMER_ORDERS.PIZZA_ID = PIZZA_RUNNER.PIZZA_NAMES.PIZZA_ID
    WHERE CLEAN_RUNNER_ORDERS.CANCELLATION IS NULL
    GROUP BY CLEAN_CUSTOMER_ORDERS.PIZZA_ID, PIZZA_RUNNER.PIZZA_NAMES.PIZZA_NAME;

| pizza_id | pizza_name | count |
| -------- | ---------- | ----- |
| 1        | Meatlovers | 9     |
| 2        | Vegetarian | 3     |

---
--How many Vegetarian and Meatlovers were ordered by each customer?

    SELECT CUSTOMER_ID,
        SUM (CASE WHEN PIZZA_RUNNER.CLEAN_CUSTOMER_ORDERS.PIZZA_ID = 1 THEN 1 ELSE 0 END) AS "MEATLOVERS",
        SUM (CASE WHEN PIZZA_RUNNER.CLEAN_CUSTOMER_ORDERS.PIZZA_ID = 2 THEN 1 ELSE 0 END) AS "VEGETARIAN"
        FROM PIZZA_RUNNER.CLEAN_CUSTOMER_ORDERS JOIN PIZZA_RUNNER.PIZZA_NAMES ON PIZZA_RUNNER.CLEAN_CUSTOMER_ORDERS.PIZZA_ID = PIZZA_RUNNER.PIZZA_NAMES.PIZZA_ID
        GROUP BY CUSTOMER_ID
        ORDER BY CUSTOMER_ID;

| customer_id | MEATLOVERS | VEGETARIAN |
| ----------- | ---------- | ---------- |
| 101         | 2          | 1          |
| 102         | 2          | 1          |
| 103         | 3          | 1          |
| 104         | 3          | 0          |
| 105         | 0          | 1          |

---
--What was the maximum number of pizzas delivered in a single order?

    SELECT CO.ORDER_ID, COUNT(*) MAX_PIZZAS_DELIVERED
    FROM PIZZA_RUNNER.CLEAN_CUSTOMER_ORDERS AS CO JOIN PIZZA_RUNNER.CLEAN_RUNNER_ORDERS AS RO ON CO.ORDER_ID = RO.ORDER_ID 
    GROUP BY CO.ORDER_ID
    ORDER BY MAX_PIZZAS_DELIVERED DESC
    LIMIT 1;

| order_id | max_pizzas_delivered |
| -------- | -------------------- |
| 4        | 3                    |

---
--For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

    SELECT CO.CUSTOMER_ID, 
    SUM( CASE WHEN EXCLUSIONS IS NULL AND EXTRAS IS NULL THEN 1 ELSE 0 END) AS "NO CHANGES",
    SUM( CASE WHEN EXCLUSIONS IS NOT NULL OR EXTRAS IS NOT NULL THEN 1 ELSE 0 END) AS "AT LEAST 1 CHANGE"
    FROM PIZZA_RUNNER.CLEAN_CUSTOMER_ORDERS AS CO JOIN PIZZA_RUNNER.CLEAN_RUNNER_ORDERS AS RO ON CO.ORDER_ID = RO.ORDER_ID
    WHERE CANCELLATION IS NULL
    GROUP BY CO.CUSTOMER_ID
    ORDER BY CO.CUSTOMER_ID;

| customer_id | NO CHANGES | AT LEAST 1 CHANGE |
| ----------- | ---------- | ----------------- |
| 101         | 2          | 0                 |
| 102         | 3          | 0                 |
| 103         | 0          | 3                 |
| 104         | 1          | 2                 |
| 105         | 0          | 1                 |

---
--How many pizzas were delivered that had both exclusions and extras?

    SELECT COUNT(*) AS PIZZAS_WITH_EXCLUSIONS_AND_EXTRAS
    FROM PIZZA_RUNNER.CLEAN_CUSTOMER_ORDERS AS CO JOIN PIZZA_RUNNER.CLEAN_RUNNER_ORDERS AS RO ON CO.ORDER_ID = RO.ORDER_ID
    WHERE CANCELLATION IS NULL AND EXCLUSIONS IS NOT NULL AND EXTRAS IS NOT NULL;

| pizzas_with_exclusions_and_extras |
| --------------------------------- |
| 1                                 |

---
--What was the total volume of pizzas ordered for each hour of the day?

    SELECT EXTRACT(HOUR FROM ORDER_TIME) AS HOUR, COUNT(*) AS TOTAL_VOLUME
    FROM PIZZA_RUNNER.CUSTOMER_ORDERS
    GROUP BY HOUR
    ORDER BY HOUR;

| hour | total_volume |
| ---- | ------------ |
| 11   | 1            |
| 13   | 3            |
| 18   | 3            |
| 19   | 1            |
| 21   | 3            |
| 23   | 3            |

---
--What was the volume of orders for each day of the week?

    SELECT TO_CHAR(ORDER_TIME, 'DAY') AS DAY, COUNT(*) AS TOTAL_VOLUME
    FROM PIZZA_RUNNER.CUSTOMER_ORDERS
    GROUP BY DAY
    ORDER BY DAY;

| day       | total_volume |
| --------- | ------------ |
| FRIDAY    | 1            |
| SATURDAY  | 5            |
| THURSDAY  | 3            |
| WEDNESDAY | 5            |

---

