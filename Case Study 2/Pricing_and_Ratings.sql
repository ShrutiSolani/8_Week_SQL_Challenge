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
