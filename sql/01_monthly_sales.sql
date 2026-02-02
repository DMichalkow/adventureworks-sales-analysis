-- =====================================================
-- Monthly Sales Analysis (Year / Month)
-- Database: AdventureWorks 2019
-- Goal: Identify sales trends and seasonality over time
-- =====================================================

SELECT
    YEAR(soh.OrderDate)  AS sales_year,
    MONTH(soh.OrderDate) AS sales_month,
    SUM(sod.LineTotal)   AS total_sales
FROM Sales.SalesOrderHeader AS soh
JOIN Sales.SalesOrderDetail AS sod
    ON soh.SalesOrderID = sod.SalesOrderID
GROUP BY
    YEAR(soh.OrderDate),
    MONTH(soh.OrderDate)
ORDER BY
    sales_year,
    sales_month;
