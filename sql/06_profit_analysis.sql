/* =====================================================
   PROFIT ANALYSIS
   =====================================================

   This section focuses on profitability rather than
   revenue alone. The goal is to understand product
   margins, identify the most profitable products,
   and analyze regional profitability.

===================================================== */


-- =====================================================
-- 1. Overall profit margin
-- =====================================================
-- Business goal:
-- Calculate the overall profitability of sales by
-- comparing total revenue with total product cost.

SELECT
    SUM(sod.LineTotal) AS total_revenue,
    SUM(p.StandardCost * sod.OrderQty) AS total_cost,
    SUM(sod.LineTotal) - SUM(p.StandardCost * sod.OrderQty) AS total_profit,
    (SUM(sod.LineTotal) - SUM(p.StandardCost * sod.OrderQty))
        * 100.0 / SUM(sod.LineTotal) AS profit_margin_percent
FROM Sales.SalesOrderDetail sod
JOIN Production.Product p
    ON sod.ProductID = p.ProductID;



-- =====================================================
-- 2. Products with the highest profit
-- =====================================================
-- Business goal:
-- Identify which products generate the highest total
-- profit and margin.

SELECT
    p.Name AS product_name,
    SUM(sod.LineTotal) AS total_revenue,
    SUM(p.StandardCost * sod.OrderQty) AS total_cost,
    SUM(sod.LineTotal) - SUM(p.StandardCost * sod.OrderQty) AS total_profit,
    (SUM(sod.LineTotal) - SUM(p.StandardCost * sod.OrderQty))
        * 100.0 / SUM(sod.LineTotal) AS profit_margin_percent
FROM Sales.SalesOrderDetail sod
JOIN Production.Product p
    ON sod.ProductID = p.ProductID
GROUP BY
    p.Name
ORDER BY
    total_profit DESC;



-- =====================================================
-- 3. Regions with the highest profitability
-- =====================================================
-- Business goal:
-- Determine which geographic regions generate the
-- highest profit and profit margins.

SELECT
    st.Name AS region,
    SUM(sod.LineTotal) AS total_revenue,
    SUM(p.StandardCost * sod.OrderQty) AS total_cost,
    SUM(sod.LineTotal) - SUM(p.StandardCost * sod.OrderQty) AS total_profit,
    (SUM(sod.LineTotal) - SUM(p.StandardCost * sod.OrderQty))
        * 100.0 / SUM(sod.LineTotal) AS profit_margin_percent
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh
    ON sod.SalesOrderID = soh.SalesOrderID
JOIN Production.Product p
    ON sod.ProductID = p.ProductID
JOIN Sales.SalesTerritory st
    ON soh.TerritoryID = st.TerritoryID
GROUP BY
    st.Name
ORDER BY
    total_profit DESC;
