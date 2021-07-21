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
