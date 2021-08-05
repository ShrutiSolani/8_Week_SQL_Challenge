---
**Query #1**
-- What is the unique count and total amount for each transaction type?

    SELECT TXN_TYPE, COUNT(DISTINCT CUSTOMER_ID), SUM(TXN_AMOUNT)
    FROM DATA_BANK.CUSTOMER_TRANSACTIONS
    GROUP BY TXN_TYPE;

| txn_type   | count | sum     |
| ---------- | ----- | ------- |
| deposit    | 500   | 1359168 |
| purchase   | 448   | 806537  |
| withdrawal | 439   | 793003  |

---
