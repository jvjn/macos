```sql
WITH original AS (
    SELECT 
         , 
         , 
         , 
         , 
         , 
         , 
         , 
         , 
         , 
         , 
     --SHOW COLUMNS
    FROM hive.scratch.oooooooooooooo
    WHERE ttttttt < DATE '2022-03-01'
)

, altered AS (
    SELECT 
         , 
         , 
         , 
         , 
         , 
         , 
         , 
         , 
         , 
         , 
         --SHOW COLUMNS
    FROM hive.scratch.aaaaaaaaaaaaaa
    WHERE ttttttt < DATE '2022-03-01'
)

SELECT o.
     , o.
     , o.
     , a.
     , a.
     , a.
FROM original AS o
FULL OUTER JOIN altered AS a
    ON o. = a.
    AND o. = a.
    AND o. = a.
WHERE o. IS NULL
   OR o. IS NULL
   OR o. IS NULL
   OR a. IS NULL
   OR a. IS NULL
   OR a. IS NULL
```

```sql
WITH original AS (
    SELECT 
         , 
         , 
         , 
         , 
         , 
         , 
         , 
         , 
         , 
         , 
     --SHOW COLUMNS
    FROM hive.scratch.oooooooooo
    WHERE tttttttttt < DATE '2022-03-01'
)

, altered AS (
    SELECT 
         , 
         , 
         , 
         , 
         , 
         , 
         , 
         , 
         , 
         , 
         --SHOW COLUMNS
    FROM hive.scratch.aaaaaaaaaa
    WHERE tttttttttt < DATE '2022-03-01'
)

SELECT o.
     , o.
     , o.
     , a.
     , a.
     , a.
FROM original AS o
INNER JOIN altered AS a
    ON o. = a.
    AND o. = a.
    AND o. = a.
WHERE o. <> a.
   OR o. <> a.
   OR o. <> a.
   OR o. <> a.
```


```sql
WITH base AS (
    SELECT abs(daily_net_balance_transaction_amount_usd_inflow + daily_net_balance_transaction_amount_usd_outflow -
               daily_net_balance_transaction_amount_usd) AS absolute_diff
    FROM hive.scratch.feature_source_payments_account_balances_unfiltered_41458
)

SELECT CASE
        WHEN /* ... */ THEN /* ... */
        ELSE 'unhandled' END AS category
     , ROUND(1.0*COUNT(1)/(SELECT COUNT(1) FROM base), 4) AS record_rate
     , COUNT(1) AS record_count
FROM base
GROUP BY 1
ORDER BY 3 DESC
```
