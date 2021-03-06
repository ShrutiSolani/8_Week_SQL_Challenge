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

    WITH RANKED AS(
    	SELECT RANK() OVER(PARTITION BY DANNYS_DINER.SALES.CUSTOMER_ID ORDER BY ORDER_DATE) AS RANKING, DANNYS_DINER.SALES.CUSTOMER_ID, PRODUCT_ID, ORDER_DATE
        FROM DANNYS_DINER.SALES, DANNYS_DINER.MEMBERS
        WHERE DANNYS_DINER.SALES.CUSTOMER_ID = DANNYS_DINER.MEMBERS.CUSTOMER_ID AND DANNYS_DINER.SALES.ORDER_DATE >= DANNYS_DINER.MEMBERS.JOIN_DATE 
      )
    
    SELECT RANKED.CUSTOMER_ID, DANNYS_DINER.MENU.PRODUCT_NAME
    FROM ranked, DANNYS_DINER.MENU
    WHERE ranking = 1 AND RANKED.PRODUCT_ID = DANNYS_DINER.MENU.PRODUCT_ID;

| customer_id | product_name |
| ----------- | ------------ |
| B           | sushi        |
| A           | curry        |

---

## Query 7
-- 7. Which item was purchased just before the customer became a member?

    WITH RANKED AS(
    	SELECT RANK() OVER(PARTITION BY DANNYS_DINER.SALES.CUSTOMER_ID ORDER BY ORDER_DATE DESC) AS RANKING, DANNYS_DINER.SALES.CUSTOMER_ID, PRODUCT_ID, ORDER_DATE
        FROM DANNYS_DINER.SALES, DANNYS_DINER.MEMBERS
        WHERE DANNYS_DINER.SALES.CUSTOMER_ID = DANNYS_DINER.MEMBERS.CUSTOMER_ID AND DANNYS_DINER.SALES.ORDER_DATE < DANNYS_DINER.MEMBERS.JOIN_DATE 
      )
    
    SELECT RANKED.CUSTOMER_ID, DANNYS_DINER.MENU.PRODUCT_NAME
    FROM ranked, DANNYS_DINER.MENU
    WHERE ranking = 1 AND RANKED.PRODUCT_ID = DANNYS_DINER.MENU.PRODUCT_ID;

| customer_id | product_name |
| ----------- | ------------ |
| B           | sushi        |
| A           | sushi        |
| A           | curry        |

---

## Query 8
-- 8. What is the total items and amount spent for each member before they became a member?

    WITH RANKED AS(
    	SELECT RANK() OVER(PARTITION BY DANNYS_DINER.SALES.CUSTOMER_ID ORDER BY ORDER_DATE DESC) AS RANKING, DANNYS_DINER.SALES.CUSTOMER_ID, PRODUCT_ID, ORDER_DATE
        FROM DANNYS_DINER.SALES, DANNYS_DINER.MEMBERS
        WHERE DANNYS_DINER.SALES.CUSTOMER_ID = DANNYS_DINER.MEMBERS.CUSTOMER_ID AND DANNYS_DINER.SALES.ORDER_DATE < DANNYS_DINER.MEMBERS.JOIN_DATE 
      )
    
    SELECT RANKED.CUSTOMER_ID, COUNT(RANKED.RANKING), SUM(PRICE)
    FROM ranked, DANNYS_DINER.MENU
    WHERE RANKED.PRODUCT_ID = DANNYS_DINER.MENU.PRODUCT_ID
    GROUP BY RANKED.CUSTOMER_ID;

| customer_id | count | sum |
| ----------- | ----- | --- |
| B           | 3     | 40  |
| A           | 2     | 25  |

---

## Query 9
-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

    WITH POINTS AS (
      SELECT *,
      CASE WHEN DANNYS_DINER.MENU.PRODUCT_NAME = 'sushi' THEN 2*DANNYS_DINER.MENU.PRICE
      ELSE DANNYS_DINER.MENU.PRICE 
      END AS PT
      FROM DANNYS_DINER.SALES, DANNYS_DINER.MENU
      WHERE DANNYS_DINER.SALES.PRODUCT_ID = DANNYS_DINER.MENU.PRODUCT_ID
    )
    
    SELECT CUSTOMER_ID, SUM(PT) AS POINTS
    FROM POINTS
    GROUP BY CUSTOMER_ID;

| customer_id | points |
| ----------- | ------ |
| B           | 94     |
| C           | 36     |
| A           | 86     |

---

## Query 10
-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, 
-- not just sushi - how many points do customer A and B have at the end of January?

    WITH member_order_points AS (
        SELECT
            DANNYS_DINER.sales.customer_id,
            DANNYS_DINER.sales.order_date,
            DANNYS_DINER.members.join_date,
            DANNYS_DINER.menu.product_name,
            DANNYS_DINER.menu.price,
            CASE WHEN DANNYS_DINER.sales.order_date >= DANNYS_DINER.members.join_date
                  AND DANNYS_DINER.sales.order_date < DANNYS_DINER.members.join_date + 7 THEN 2*DANNYS_DINER.menu.price
                 
            ELSE DANNYS_DINER.menu.price END AS points
        FROM DANNYS_DINER.sales
        LEFT JOIN DANNYS_DINER.menu
            ON DANNYS_DINER.sales.product_id = DANNYS_DINER.menu.product_id
        INNER JOIN DANNYS_DINER.members
            ON DANNYS_DINER.sales.customer_id = DANNYS_DINER.members.customer_id
    )
    
    SELECT
        customer_id,
        SUM(points)
    FROM member_order_points AS mop
    WHERE order_date <= '2021-01-31'
    GROUP BY customer_id
    ORDER BY customer_id;

| customer_id | sum |
| ----------- | --- |
| A           | 127 |
| B           | 72  |

---

## Bonus Question 1
-- Join All The Things

    SELECT DANNYS_DINER.SALES.CUSTOMER_ID, ORDER_DATE, PRODUCT_NAME, PRICE, 
    CASE WHEN ORDER_DATE >= JOIN_DATE THEN 'Y'
    ELSE 'N'
    END AS MEMBER
    FROM DANNYS_DINER.SALES JOIN DANNYS_DINER.MENU ON DANNYS_DINER.SALES.PRODUCT_ID = DANNYS_DINER.MENU.PRODUCT_ID LEFT JOIN DANNYS_DINER.MEMBERS ON DANNYS_DINER.SALES.CUSTOMER_ID = DANNYS_DINER.MEMBERS.CUSTOMER_ID
    ORDER BY CUSTOMER_ID, ORDER_DATE;

| customer_id | order_date               | product_name | price | member |
| ----------- | ------------------------ | ------------ | ----- | ------ |
| A           | 2021-01-01T00:00:00.000Z | sushi        | 10    | N      |
| A           | 2021-01-01T00:00:00.000Z | curry        | 15    | N      |
| A           | 2021-01-07T00:00:00.000Z | curry        | 15    | Y      |
| A           | 2021-01-10T00:00:00.000Z | ramen        | 12    | Y      |
| A           | 2021-01-11T00:00:00.000Z | ramen        | 12    | Y      |
| A           | 2021-01-11T00:00:00.000Z | ramen        | 12    | Y      |
| B           | 2021-01-01T00:00:00.000Z | curry        | 15    | N      |
| B           | 2021-01-02T00:00:00.000Z | curry        | 15    | N      |
| B           | 2021-01-04T00:00:00.000Z | sushi        | 10    | N      |
| B           | 2021-01-11T00:00:00.000Z | sushi        | 10    | Y      |
| B           | 2021-01-16T00:00:00.000Z | ramen        | 12    | Y      |
| B           | 2021-02-01T00:00:00.000Z | ramen        | 12    | Y      |
| C           | 2021-01-01T00:00:00.000Z | ramen        | 12    | N      |
| C           | 2021-01-01T00:00:00.000Z | ramen        | 12    | N      |
| C           | 2021-01-07T00:00:00.000Z | ramen        | 12    | N      |

---

## Bonus Question 2
-- Rank All The Things
 
    SELECT *,
    CASE WHEN MEMBER = 'Y' THEN RANK() OVER(PARTITION BY CUSTOMER_ID, MEMBER ORDER BY ORDER_DATE) 
    ELSE NULL
    END AS RANKING
    FROM (
      SELECT DANNYS_DINER.SALES.CUSTOMER_ID, ORDER_DATE, PRODUCT_NAME, PRICE, 
    CASE WHEN ORDER_DATE >= JOIN_DATE THEN 'Y'
    ELSE 'N'
    END AS MEMBER
    FROM DANNYS_DINER.SALES JOIN DANNYS_DINER.MENU ON DANNYS_DINER.SALES.PRODUCT_ID = DANNYS_DINER.MENU.PRODUCT_ID LEFT JOIN DANNYS_DINER.MEMBERS ON DANNYS_DINER.SALES.CUSTOMER_ID = DANNYS_DINER.MEMBERS.CUSTOMER_ID
    ORDER BY CUSTOMER_ID, ORDER_DATE
    ) AS FROM_ALIAS;

| customer_id | order_date               | product_name | price | member | ranking |
| ----------- | ------------------------ | ------------ | ----- | ------ | ------- |
| A           | 2021-01-01T00:00:00.000Z | sushi        | 10    | N      |         |
| A           | 2021-01-01T00:00:00.000Z | curry        | 15    | N      |         |
| A           | 2021-01-07T00:00:00.000Z | curry        | 15    | Y      | 1       |
| A           | 2021-01-10T00:00:00.000Z | ramen        | 12    | Y      | 2       |
| A           | 2021-01-11T00:00:00.000Z | ramen        | 12    | Y      | 3       |
| A           | 2021-01-11T00:00:00.000Z | ramen        | 12    | Y      | 3       |
| B           | 2021-01-01T00:00:00.000Z | curry        | 15    | N      |         |
| B           | 2021-01-02T00:00:00.000Z | curry        | 15    | N      |         |
| B           | 2021-01-04T00:00:00.000Z | sushi        | 10    | N      |         |
| B           | 2021-01-11T00:00:00.000Z | sushi        | 10    | Y      | 1       |
| B           | 2021-01-16T00:00:00.000Z | ramen        | 12    | Y      | 2       |
| B           | 2021-02-01T00:00:00.000Z | ramen        | 12    | Y      | 3       |
| C           | 2021-01-01T00:00:00.000Z | ramen        | 12    | N      |         |
| C           | 2021-01-01T00:00:00.000Z | ramen        | 12    | N      |         |
| C           | 2021-01-07T00:00:00.000Z | ramen        | 12    | N      |         |

---
