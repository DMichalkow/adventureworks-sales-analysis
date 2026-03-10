/* =========================================================
   01_SALES_OVERVIEW.SQL
   SALES TREND ANALYSIS
   =========================================================

   Objective:
   Analyze revenue performance over time and measure
   short-term and long-term growth dynamics.

   Key metrics:
   - Monthly revenue
   - Number of orders
   - Average Order Value (AOV)
   - Month-over-Month growth (MoM)
   - Year-over-Year growth (YoY)

========================================================= */


-- =====================================================
-- STEP 1: Monthly Revenue Aggregation
-- =====================================================
-- Aggregate revenue and order volume at the monthly level

WITH sales AS (
    SELECT
        YEAR(soh.OrderDate) AS sales_year,
        MONTH(soh.OrderDate) AS sales_month,
        SUM(sod.LineTotal) AS total_sales,
        COUNT(DISTINCT soh.SalesOrderID) AS number_of_orders
    FROM Sales.SalesOrderHeader AS soh
    JOIN Sales.SalesOrderDetail AS sod
        ON soh.SalesOrderID = sod.SalesOrderID
    GROUP BY
        YEAR(soh.OrderDate),
        MONTH(soh.OrderDate)
),

-- =====================================================
-- STEP 2: Time Comparison Metrics
-- =====================================================
-- Calculate previous month and same month last year

compare AS (
    SELECT
        sales_year,
        sales_month,
        total_sales,
        number_of_orders,
        LAG(total_sales) OVER (
            ORDER BY sales_year, sales_month
        ) AS previous_month,
        LAG(total_sales) OVER (
            PARTITION BY sales_month
            ORDER BY sales_year
        ) AS previous_year_same_month
    FROM sales
),

-- =====================================================
-- STEP 3: KPI Calculations
-- =====================================================
-- Calculate MoM growth, YoY growth and AOV

sales_data AS (
    SELECT
        sales_year,
        sales_month,
        total_sales,
        previous_month,
        previous_year_same_month,
        number_of_orders,

        total_sales - previous_month AS mom_growth_amount,

        ROUND(
            (total_sales - previous_month) * 100.0 /
            NULLIF(previous_month, 0),
        2) AS mom_growth_percent,

        CAST(total_sales AS DECIMAL(18,2)) /
            NULLIF(number_of_orders, 0) AS average_order_value,

        total_sales - previous_year_same_month AS yoy_growth_amount,

        ROUND(
            (total_sales - previous_year_same_month) * 100.0 /
            NULLIF(previous_year_same_month, 0),
        2) AS yoy_growth_percent

    FROM compare
),

-- =====================================================
-- STEP 4: Trend Classification & Ranking
-- =====================================================
-- Classify growth and rank months by revenue

final_data AS (
    SELECT
        sales_year,
        sales_month,
        total_sales,
        previous_month,
        mom_growth_amount,
        mom_growth_percent,
        average_order_value,

        CASE 
            WHEN mom_growth_percent IS NULL THEN 'No Data'
            WHEN mom_growth_percent > 0 THEN 'Growth'
            WHEN mom_growth_percent < 0 THEN 'Decline'
            ELSE 'Stable'
        END AS growth_trend,

        RANK() OVER (
            PARTITION BY sales_year
            ORDER BY total_sales DESC
        ) AS sales_rank,

        previous_year_same_month,
        yoy_growth_amount,
        yoy_growth_percent,

        CASE 
            WHEN yoy_growth_percent IS NULL THEN 'No Data'
            WHEN yoy_growth_percent > 0 THEN 'YoY Growth'
            WHEN yoy_growth_percent < 0 THEN 'YoY Decline'
            ELSE 'YoY Stable'
        END AS yoy_trend

    FROM sales_data
)

-- =====================================================
-- FINAL RESULT
-- =====================================================

SELECT *
FROM final_data
ORDER BY sales_year, sales_month;
