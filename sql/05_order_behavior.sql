/* =========================================================
   05_ORDER_BEHAVIOR.SQL
   ORDER PATTERN ANALYSIS
   =========================================================

   This section focuses on operational order behavior.
   The goal is to understand how customers place orders,
   what the typical order size looks like, and whether
   there are seasonal patterns in order activity.

===================================================== */


-- =====================================================
-- 1. Average number of items per order
-- =====================================================
-- Business goal:
-- Understand how many product items are typically
-- included in a single order.

-- Step 1: calculate number of items per order
WITH order_items AS (
    SELECT
        SalesOrderID,
        COUNT(*) AS number_of_items
    FROM Sales.SalesOrderDetail
    GROUP BY SalesOrderID
)

-- Step 2: calculate average items per order
SELECT
    AVG(number_of_items) AS average_items_per_order
FROM order_items;



-- =====================================================
-- 2. Average order value (AOV)
-- =====================================================
-- Business goal:
-- Measure the typical monetary value of a customer order.

SELECT
    AVG(TotalDue) AS average_order_value,
    MIN(TotalDue) AS minimum_order_value,
    MAX(TotalDue) AS maximum_order_value
FROM Sales.SalesOrderHeader;



-- =====================================================
-- 3. Order distribution over time
-- =====================================================
-- Business goal:
-- Analyze how the number of orders evolves over time.

SELECT
    YEAR(OrderDate) AS order_year,
    MONTH(OrderDate) AS order_month,
    COUNT(SalesOrderID) AS number_of_orders
FROM Sales.SalesOrderHeader
GROUP BY
    YEAR(OrderDate),
    MONTH(OrderDate)
ORDER BY
    order_year,
    order_month;



-- =====================================================
-- 4. Order seasonality
-- =====================================================
-- Business goal:
-- Identify seasonal patterns in order activity by month.

SELECT
    MONTH(OrderDate) AS order_month,
    COUNT(SalesOrderID) AS number_of_orders
FROM Sales.SalesOrderHeader
GROUP BY
    MONTH(OrderDate)
ORDER BY
    order_month;
