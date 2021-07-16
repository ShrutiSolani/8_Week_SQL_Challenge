## Query 1

-- 1. What is the total amount each customer spent at the restaurant?

    SELECT CUSTOMER_ID, SUM(PRICE)
    FROM DANNYS_DINER.SALES JOIN DANNYS_DINER.MENU
    ON DANNYS_DINER.SALES.PRODUCT_ID = DANNYS_DINER.MENU.PRODUCT_ID
    GROUP BY CUSTOMER_ID;

  -- Another Approach
    SELECT CUSTOMER_ID, SUM(PRICE)
    FROM DANNYS_DINER.SALES, DANNYS_DINER.MENU
    WHERE DANNYS_DINER.SALES.PRODUCT_ID = DANNYS_DINER.MENU.PRODUCT_ID
    GROUP BY CUSTOMER_ID

| customer_id | sum |
| ----------- | --- |
| B           | 74  |
| C           | 36  |
| A           | 76  |

---


## Query 2
-- 2. How many days has each customer visited the restaurant?

    SELECT CUSTOMER_ID, COUNT(DISTINCT ORDER_DATE)
    FROM DANNYS_DINER.SALES 
    GROUP BY CUSTOMER_ID;

| customer_id | count |
| ----------- | ----- |
| A           | 4     |
| B           | 6     |
| C           | 2     |

---

## Query 3
-- 3. What was the first item from the menu purchased by each customer?

    SELECT CUSTOMER_ID, PRODUCT_NAME 
    FROM(
    	SELECT RANK() OVER(PARTITION BY DANNYS_DINER.SALES.CUSTOMER_ID ORDER BY ORDER_DATE ASC) AS GIVEN_RANK, CUSTOMER_ID, PRODUCT_NAME
    FROM DANNYS_DINER.SALES, DANNYS_DINER.MENU
    WHERE DANNYS_DINER.SALES.PRODUCT_ID = DANNYS_DINER.MENU.PRODUCT_ID
    ) 
    AS RANKED
    WHERE RANKED.GIVEN_RANK = 1;

| customer_id | product_name |
| ----------- | ------------ |
| A           | curry        |
| A           | sushi        |
| B           | curry        |
| C           | ramen        |
| C           | ramen        |

---

## Query 4
-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

    SELECT PRODUCT_NAME, COUNT(*)
    FROM DANNYS_DINER.SALES, DANNYS_DINER.MENU
    WHERE DANNYS_DINER.SALES.PRODUCT_ID = DANNYS_DINER.MENU.PRODUCT_ID
    GROUP BY PRODUCT_NAME
    ORDER BY COUNT(*) DESC
    LIMIT 1;

| product_name | count |
| ------------ | ----- |
| ramen        | 8     |

---

## Query 5
-- 5. Which item was the most popular for each customer?

    WITH ranked AS (
        SELECT RANK() OVER(PARTITION BY customer_id ORDER BY num DESC) AS ranking, customer_id, product_name
        FROM(
            SELECT customer_id, product_name, COUNT(*) as num
            FROM DANNYS_DINER.SALES JOIN DANNYS_DINER.MENU ON DANNYS_DINER.sales.product_id = DANNYS_DINER.menu.product_id
            GROUP BY customer_id, product_name
            ORDER BY num DESC
        ) AS max_orders
    )
    
    SELECT customer_id, product_name
    FROM ranked
    WHERE ranking = 1;


| customer_id | product_name |
| ----------- | ------------ |
| A           | ramen        |
| B           | sushi        |
| B           | curry        |
| B           | ramen        |
| C           | ramen        |

---

## Query 6
-- 6. Which item was purchased first by the customer after they became a member?

