---

**Query #1**
-- How many unique nodes are there on the Data Bank system?

    SELECT COUNT(DISTINCT NODE_ID)
    FROM DATA_BANK.CUSTOMER_NODES;

| count |
| ----- |
| 5     |

---
**Query #2**
-- What is the number of nodes per region?

    SELECT REGION_ID, COUNT(DISTINCT NODE_ID)
    FROM DATA_BANK.CUSTOMER_NODES
    GROUP BY REGION_ID
    ORDER BY REGION_ID;

| region_id | count |
| --------- | ----- |
| 1         | 5     |
| 2         | 5     |
| 3         | 5     |
| 4         | 5     |
| 5         | 5     |

---
**Query #3**
-- How many customers are allocated to each region?
    SELECT REGION_ID, COUNT(DISTINCT CUSTOMER_ID)
    FROM DATA_BANK.CUSTOMER_NODES
    GROUP BY REGION_ID
    ORDER BY REGION_ID;

| region_id | count |
| --------- | ----- |
| 1         | 110   |
| 2         | 105   |
| 3         | 102   |
| 4         | 95    |
| 5         | 88    |

---
