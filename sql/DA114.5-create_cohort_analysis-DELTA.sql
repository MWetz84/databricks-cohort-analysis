CREATE OR REPLACE TABLE cohort_analysis USING DELTA AS
WITH all_orders AS (
  select
    customer_id,
    order_date as date
  from
    workspace.bigquery_db_cohortdb.ecom_orders
  ORDER BY
    customer_id,
    order_date
),
first_order AS (
  SELECT
    customer_id,
    MIN(date) AS date
  FROM
    all_orders
  GROUP BY
    customer_id
  ORDER BY
    customer_id
),
second_order AS (
  SELECT
    all_orders.customer_id As customer_id,
    MIN(all_orders.date) AS date
  FROM
    all_orders
      LEFT JOIN first_order
        ON all_orders.customer_id = first_order.customer_id
  WHERE
    all_orders.date > first_order.date
  GROUP BY
    all_orders.customer_id
  ORDER BY
    customer_id
)

SELECT
  fo.customer_id,
  fo.date AS first_order,
  so.date AS second_order,
  -- CREATE TABLE does not allow spaces - even when escaped with backticks, renamed target cols to first_order & second_order
  date_diff(so.date, fo.date) AS date_diff
FROM
  first_order fo
    LEFT JOIN second_order so
      ON fo.customer_id = so.customer_id
ORDER BY
  fo.customer_id
;
/*
This above query was created according to the instructions in MS Campus (DA114.5). This query cannot be used for further analysis, because there 3 customers, which orders multiple times on the same day and the GROUP BY logic would not cover that. Proof:


SELECT
  customer_id,
  order_date,
  COUNT(order_id)
FROM bigquery_db_cohortdb.ecom_orders
GROUP BY 1,2
ORDER BY 3 DESC

Futher analysis is conducted in query 'DA114.5-Project_Cohort_Analysis-unified_query'
*/