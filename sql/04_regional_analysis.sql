-- =====================================================
-- 1. Sales per region
-- =====================================================
-- Business goal:
-- Identify which geographic regions generate
-- the highest total revenue.

SELECT
    st.Name AS region,
    SUM(soh.TotalDue) AS total_revenue
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesTerritory st
    ON soh.TerritoryID = st.TerritoryID
GROUP BY
    st.Name
ORDER BY
    total_revenue DESC;

-- =====================================================
-- 2. Regional revenue share
-- =====================================================
-- Business goal:
-- Measure the percentage contribution of each region
-- to the total company revenue.

WITH regional_sales AS (
    SELECT
        st.Name AS region,
        SUM(soh.TotalDue) AS total_revenue
    FROM Sales.SalesOrderHeader soh
    JOIN Sales.SalesTerritory st
        ON soh.TerritoryID = st.TerritoryID
    GROUP BY st.Name
)

SELECT
    region,
    total_revenue,
    total_revenue * 100.0 /
        SUM(total_revenue) OVER() AS revenue_share_percent
FROM regional_sales
ORDER BY total_revenue DESC;

-- =====================================================
-- 3. Regional ranking
-- =====================================================
-- Business goal:
-- Rank regions based on total revenue.

WITH regional_sales AS (
    SELECT
        st.Name AS region,
        SUM(soh.TotalDue) AS total_revenue
    FROM Sales.SalesOrderHeader soh
    JOIN Sales.SalesTerritory st
        ON soh.TerritoryID = st.TerritoryID
    GROUP BY st.Name
)

SELECT
    region,
    total_revenue,
    RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank
FROM regional_sales
ORDER BY revenue_rank;

-- =====================================================
-- 4. Regional sales trend
-- =====================================================
-- Business goal:
-- Analyze how revenue evolves over time across regions.

SELECT
    st.Name AS region,
    YEAR(soh.OrderDate) AS sales_year,
    SUM(soh.TotalDue) AS total_revenue
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesTerritory st
    ON soh.TerritoryID = st.TerritoryID
GROUP BY
    st.Name,
    YEAR(soh.OrderDate)
ORDER BY
    region,
    sales_year;
