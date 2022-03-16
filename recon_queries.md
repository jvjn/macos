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
