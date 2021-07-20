-- Query 1
-- How many pizzas were ordered?

    SELECT COUNT(*) AS TOTAL_PIZZAS
    FROM PIZZA_RUNNER.CUSTOMER_ORDERS;

| total_pizzas |
| ------------ |
| 14           |

---
-- Query 2
-- How many unique customer orders were made?

    SELECT COUNT(DISTINCT ORDER_ID) AS UNIQUE_CUSTOMER_ORDERS
    FROM PIZZA_RUNNER.CUSTOMER_ORDERS;

| unique_customer_orders |
| ---------------------- |
| 10                     |

---

-- Query 3
-- How many successful orders were delivered by each runner?

    SELECT PIZZA_RUNNER.RUNNER_ORDERS.RUNNER_ID, COUNT(*) AS ORDERS
    FROM PIZZA_RUNNER.RUNNER_ORDERS
    WHERE PIZZA_RUNNER.RUNNER_ORDERS.CANCELLATION IS NULL
    GROUP BY PIZZA_RUNNER.RUNNER_ORDERS.RUNNER_ID;

| runner_id | orders |
| --------- | ------ |
| 1         | 4      |
| 2         | 3      |
| 3         | 1      |

---
