/* =====================================================
   CUSTOMER ANALYSIS
   AdventureWorks 2019
   =====================================================

   This section focuses on customer purchasing behavior
   and customer value. The goal is to identify high-value
   customers, analyze their contribution to revenue,
   and understand the distribution of customer segments.

===================================================== */


-- =====================================================
-- 1. Revenue per customer
-- =====================================================
-- Business goal:
-- Identify the most valuable customers based on
-- total revenue generated and purchasing activity.

-- Metrics calculated:
-- - number_of_orders
-- - total_revenue
-- - average_order_value (AOV)

SELECT
    soh.CustomerID,
    COUNT(soh.SalesOrderID) AS number_of_orders,
    SUM(soh.TotalDue) AS total_revenue,
    AVG(soh.TotalDue) AS average_order_value
FROM Sales.SalesOrderHeader soh
GROUP BY
    soh.CustomerID
ORDER BY
    total_revenue DESC;



-- =====================================================
-- 2. Top 10 customers by revenue
-- =====================================================
-- Business goal:
-- Identify the top-performing customers who generate
-- the highest revenue for the company.

-- Technique used:
-- - CTE (Common Table Expression)
-- - Window function RANK() to rank customers by revenue

WITH top_customers AS (
    SELECT
        soh.CustomerID,
        COUNT(soh.SalesOrderID) AS number_of_orders,
        SUM(soh.TotalDue) AS total_revenue,
        AVG(soh.TotalDue) AS average_order_value
    FROM Sales.SalesOrderHeader soh
    GROUP BY soh.CustomerID
)

SELECT TOP 10
    CustomerID,
    number_of_orders,
    total_revenue,
    average_order_value,
    RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank
FROM top_customers
ORDER BY total_revenue DESC;



-- =====================================================
-- 3. Customer segmentation based on total revenue
-- =====================================================
-- Business goal:
-- Segment customers based on the total revenue they
-- generate to understand the distribution of
-- high-value vs low-value clients.

-- Segments:
-- VIP        : revenue > 50,000
-- High Value : 10,000 - 50,000
-- Medium     : 1,000 - 10,000
-- Low        : < 1,000

-- Step 1: calculate revenue per customer

WITH customers AS (
    SELECT
        soh.CustomerID,
        COUNT(soh.SalesOrderID) AS number_of_orders,
        SUM(soh.TotalDue) AS total_revenue
    FROM Sales.SalesOrderHeader soh
    GROUP BY soh.CustomerID
),

-- Step 2: assign revenue segment

customer_segments AS (
    SELECT
        CustomerID,
        total_revenue,
        CASE
            WHEN total_revenue > 50000 THEN 'VIP'
            WHEN total_revenue BETWEEN 10000 AND 50000 THEN 'High Value'
            WHEN total_revenue BETWEEN 1000 AND 10000 THEN 'Medium'
            ELSE 'Low'
        END AS segment
    FROM customers
)

-- Step 3: aggregate segment statistics

SELECT
    segment,
    COUNT(CustomerID) AS number_of_customers,
    SUM(total_revenue) AS total_revenue
FROM customer_segments
GROUP BY segment
ORDER BY total_revenue DESC;
