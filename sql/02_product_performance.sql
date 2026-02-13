-- =====================================================
-- 02_product_performance.sql
-- Revenue Concentration & Pareto Analysis
-- =====================================================

-- -----------------------------------------------------
-- Step 1: Aggregate revenue and quantity per product
-- -----------------------------------------------------
WITH product_aggregation AS (
    SELECT
        p.ProductID AS product_id,
        p.Name AS product_name,
        SUM(sod.LineTotal) AS total_revenue,
        SUM(sod.OrderQty) AS total_quantity
    FROM Production.Product AS p
    INNER JOIN Sales.SalesOrderDetail AS sod
        ON sod.ProductID = p.ProductID
    GROUP BY
        p.ProductID,
        p.Name
),

-- -----------------------------------------------------
-- Step 2: Calculate revenue share and cumulative revenue
-- -----------------------------------------------------
product_metrics AS (
    SELECT
        product_id,
        product_name,
        total_revenue,
        total_quantity,

        -- Share of total revenue (%)
        ROUND(
            total_revenue * 100.0 /
            SUM(total_revenue) OVER (),
        2) AS revenue_share_percent,

        -- Cumulative revenue (running total)
        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_revenue,

        SUM(total_revenue) OVER () AS total_revenue_overall

    FROM product_aggregation
),

-- -----------------------------------------------------
-- Step 3: Calculate cumulative percentage and Pareto segment
-- -----------------------------------------------------
pareto_analysis AS (
    SELECT
        product_id,
        product_name,
        total_revenue,
        total_quantity,
        revenue_share_percent,
        cumulative_revenue,

        ROUND(
            cumulative_revenue * 100.0 /
            total_revenue_overall,
        2) AS cumulative_percent,

        CASE
            WHEN 
                ROUND(
                    cumulative_revenue * 100.0 /
                    total_revenue_overall,
                2) <= 80
            THEN 'Top 80%'
            ELSE 'Remaining 20%'
        END AS pareto_segment

    FROM product_metrics
)

-- -----------------------------------------------------
-- Step 4: Revenue concentration summary
-- -----------------------------------------------------
SELECT
    COUNT(*) AS total_products,
    SUM(CASE WHEN pareto_segment = 'Top 80%' THEN 1 ELSE 0 END) AS top_80_products,
    ROUND(
        SUM(CASE WHEN pareto_segment = 'Top 80%' THEN 1 ELSE 0 END) * 100.0 /
        COUNT(*),
    2) AS percent_of_products_in_top_80
FROM pareto_analysis;

