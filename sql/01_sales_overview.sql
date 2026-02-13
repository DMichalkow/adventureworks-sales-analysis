-- =====================================================
-- 01_sales_overview.sql
-- Monthly Revenue Analysis
-- Short-term (MoM) and Long-term (YoY) Growth
-- =====================================================


-- -------------------------------------
-- Step 1: Monthly Aggregation
-- Aggregate revenue and order volume at monthly level
-- -------------------------------------
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

-- -------------------------------------
-- Step 2: Add Time-Based References
-- Calculate previous month and same month previous year
-- -------------------------------------
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

-- -------------------------------------
-- Step 3: KPI Calculations
-- Compute MoM and YoY growth metrics
-- -------------------------------------
sales_data AS (
    SELECT
        sales_year,
        sales_month,
        total_sales,
        previous_month,
        previous_year_same_month,
        number_of_orders,

        -- Month-over-Month Growth
        total_sales - previous_month AS mom_growth_amount,
        ROUND(
            (total_sales - previous_month) * 100.0 /
            NULLIF(previous_month, 0),
        2) AS mom_growth_percent,

        -- Average Order Value
        CAST(total_sales AS DECIMAL(18,2)) /
            NULLIF(number_of_orders, 0) AS average_order_value,

        -- Year-over-Year Growth
        total_sales - previous_year_same_month AS yoy_growth_amount,
        ROUND(
            (total_sales - previous_year_same_month) * 100.0 /
            NULLIF(previous_year_same_month, 0),
        2) AS yoy_growth_percent

    FROM compare
),

-- -------------------------------------
-- Step 4: Trend Classification & Ranking
-- Categorize performance and rank months within each year
-- -------------------------------------
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

-- -------------------------------------
-- Final Output: Chronological View
-- -------------------------------------
SELECT *
FROM final_data
ORDER BY sales_year, sales_month;

