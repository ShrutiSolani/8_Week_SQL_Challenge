## A. Customer Journey
Based off the 8 sample customers provided in the sample from the subscriptions table, write a brief description about each customer’s onboarding journey.

Table 2: subscriptions

|customer_id	|plan_id|	start_date|
|-------------|-------|-----------|
|1	          | 0	    | 2020-08-01|
|1	          | 1	    | 2020-08-08|
|2	          | 0	    | 2020-09-20|
|2	          | 3	    | 2020-09-27|
|11	          | 0	    | 2020-11-19|
|11	          | 4	    | 2020-11-26|
|13	          | 0	    | 2020-12-15|
|13	          | 1	    | 2020-12-22|
|13	          | 2	    | 2021-03-29|
|15	          | 0	    | 2020-03-17|
|15	          | 2	    | 2020-03-24|
|15	          | 4	    | 2020-04-29|
|16	          | 0	    | 2020-05-31|
|16	          | 1	    | 2020-06-07|
|16	          | 3	    | 2020-10-21|
|18	          | 0	    | 2020-07-06|
|18	          | 2	    | 2020-07-13|
|19	          | 0	    | 2020-06-22|
|19	          | 2	    | 2020-06-29|
|19	          | 3	    | 2020-08-29|
          

customer_id	| plan_id	| start_date	          | plan_name	| price
 -------------      |---------| ------------------------    | ----------------  |------
1	          | 0	| 2020-08-01T00:00:00.000Z	| trial	          | 0.00
1	          | 1	| 2020-08-08T00:00:00.000Z	| basic monthly	| 9.90
2	          | 0	| 2020-09-20T00:00:00.000Z	| trial	          | 0.00
2	          | 3	| 2020-09-27T00:00:00.000Z	| pro annual	| 199.00
11	          | 0	| 2020-11-19T00:00:00.000Z	| trial	          | 0.00
11	          | 4	| 2020-11-26T00:00:00.000Z	| churn	          | null
12	          | 0	| 2020-09-22T00:00:00.000Z	| trial	          | 0.00
12	          | 1	| 2020-09-29T00:00:00.000Z	| basic monthly	| 9.90
13	          | 0	| 2020-12-15T00:00:00.000Z	| trial	          | 0.00
13	          | 1	| 2020-12-22T00:00:00.000Z	| basic monthly	| 9.90
13	          | 2	| 2021-03-29T00:00:00.000Z	| pro monthly	| 19.90
15	          | 0	| 2020-03-17T00:00:00.000Z	| trial	          | 0.00
15	          | 2	| 2020-03-24T00:00:00.000Z	| pro monthly	| 19.90
15	          | 4	| 2020-04-29T00:00:00.000Z	| churn	          | null
16	          | 0	| 2020-05-31T00:00:00.000Z	| trial	          | 0.00
16	          | 1	| 2020-06-07T00:00:00.000Z	| basic monthly	| 9.90
16	          | 3	| 2020-10-21T00:00:00.000Z	| pro annual	| 199.00
18	          | 0	| 2020-07-06T00:00:00.000Z	| trial	          | 0.00
18	          | 2	| 2020-07-13T00:00:00.000Z	| pro monthly	| 19.90
19	          | 0	| 2020-06-22T00:00:00.000Z	| trial	          | 0.00
19	          | 2	| 2020-06-29T00:00:00.000Z	| pro monthly	| 19.90
19	          | 3	| 2020-08-29T00:00:00.000Z	| pro annual	| 199.00


All customers first took a trial plan for 7 days.
After a week from trial plan, customer 1, 13 and 16 took plan 1 i.e. BASIC MONTHLY plan of $9.90 whereas customer 15, 18 and 19 subscribed to a pro monthly plan.
While customer 11 unsubscribed after trial customer 2, 16 and 19 eventually subscried to pro annual plan of $199.00.
