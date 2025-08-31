-- ===================================================================================
-- UNIFIED QUERY FOR COHORT ANALYSIS
-- ===================================================================================
-- This is a unified query that generates all metrics required for the project's three visualizations.
-- The project asks for three separate queries. To generate the specific query for each task,
-- you can comment out the metric blocks in the final SELECT statement that are not needed.

-- For Visualization 1 (Retention Rate): Keep the "Time-Based Retention Rates" block and cohort_month/total_customers.
-- For Visualization 2 (Repeat Purchase Rate): Keep the "Order-Based Repeat Purchase Rates" block and cohort_month/total_customers.
-- For Visualization 3 (Cohort Size): Keep only the "COUNT(DISTINCT customer_id)" line and cohort_month.
-- ===================================================================================

-- Unified Retention Rate and Repeat Purchase Rate by Cohort
-- This query generates a single, aggregated table to power multiple dashboard visualizations,
-- including cohort size, time-based retention, and order-based repeat purchase rates.

-- CTE 1: Order Sequencing
-- The first step is to understand each customer's journey. We use ROW_NUMBER() to
-- assign a sequence number (1st order, 2nd order, etc.) to every order for every customer. GROUP BY does not work here - see query 'DA114.5-create_cohort_analysis-DELTA'
CREATE OR REPLACE TABLE cohort_analysis USING DELTA AS
WITH order_sequence AS (
  SELECT
    customer_id,
    order_date,
    order_id,
    sales,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS order_sequence
  FROM workspace.bigquery_db_cohortdb.ecom_orders
),

-- CTE 2: Customer-Level Metrics
-- Transforms the data from an order-level view to a customer-centric one
-- Calculates all key lifetime metrics for each individual customer
customer_cohorts AS (
  SELECT
    customer_id,
    -- Efficiently pivot the data to get the first order date on its own column.
    MIN(CASE WHEN order_sequence = 1 THEN order_date END) AS first_order_date,
    -- Pivot again to get the second order date, which is crucial for time-based retention.
    MIN(CASE WHEN order_sequence = 2 THEN order_date END) AS second_order_date,
    -- The highest order sequence number for a customer equals their total number of orders.
    MAX(order_sequence) AS total_orders,
    SUM(sales) AS total_sales
    -- Bonus: not required but possibly generates valuable insights
  FROM order_sequence
  GROUP BY customer_id
),

-- CTE 3: Final Cohort Preparation
-- This CTE prepares the customer-level data for the final cohort-based aggregation.
-- It assigns each customer to a cohort and calculates the time to their second purchase.
cohort_analysis AS (
  SELECT
    -- Use date_trunc to group customers into monthly cohorts based on their first purchase.
    CAST(date_trunc('month', first_order_date) AS date) AS cohort_month,
    customer_id,
    total_orders,
    total_sales,
    -- Calculate the number of full elapsed months between the 1st and 2nd purchase.
    -- This provides a precise, floating-period measure of return time. See also: https://docs.databricks.com/gcp/en/sql/language-manual/functions/date_diff
    CASE
      WHEN second_order_date IS NOT NULL 
      THEN date_diff(MONTH, first_order_date, second_order_date)
      ELSE NULL
    END AS months_to_second_order
  FROM customer_cohorts
  WHERE first_order_date IS NOT NULL
)

-- Final Aggregation: Combine all metrics at the cohort level.
SELECT
  cohort_month,
  
  -- Metric 1: Cohort Size (for Visualization 3)
  COUNT(DISTINCT customer_id) AS new_customers,
  
  -- Bonus Metrics: High-level overview of cohort quality.
  ROUND(AVG(total_sales),2) AS avg_ltv,
  ROUND(AVG(total_orders),2) avg_orders,
  
  -- Metric 2: Time-Based Retention Rates (for Visualization 1)
  -- The logic here calculates retention within a floating period of N full months.
  -- "retention_rate_1m" measures retention within the first full month (e.g., Jan 15 -> Feb 14). Metrics retention_rate_2m and retention_rate_3m are cumulative.
  ROUND(SUM(CASE WHEN months_to_second_order = 0 THEN 1 ELSE 0 END) * 1.0 / COUNT(DISTINCT customer_id), 2) AS retention_rate_1m,
  ROUND(SUM(CASE WHEN months_to_second_order <= 1 THEN 1 ELSE 0 END) * 1.0 / COUNT(DISTINCT customer_id), 2) AS retention_rate_2m,
  ROUND(SUM(CASE WHEN months_to_second_order <= 2 THEN 1 ELSE 0 END) * 1.0 / COUNT(DISTINCT customer_id), 2) AS retention_rate_3m,
  
  -- Metric 3: Order-Based Repeat Purchase Rates (for Visualization 2)
  -- This measures a different dimension of loyalty: the depth of purchasing, regardless of time. Metrics repeat_rate_3rd- and repeat_rate_4th_order are cumulative.
  ROUND(SUM(CASE WHEN total_orders >= 2 THEN 1 ELSE 0 END) * 1.0 / COUNT(DISTINCT customer_id), 2) AS repeat_rate_2nd_order,
  ROUND(SUM(CASE WHEN total_orders >= 3 THEN 1 ELSE 0 END) * 1.0 / COUNT(DISTINCT customer_id), 2) AS repeat_rate_3rd_order,
  ROUND(SUM(CASE WHEN total_orders >= 4 THEN 1 ELSE 0 END) * 1.0 / COUNT(DISTINCT customer_id), 2) AS repeat_rate_4th_order

FROM cohort_analysis
WHERE total_orders > 0  -- A safe-guard to ensure only customers with orders are included.
GROUP BY cohort_month
ORDER BY cohort_month