# AdventureWorks Sales Analysis

## Business Questions

This project aims to answer several key business questions based on the AdventureWorks 2019 sales database:

- How has revenue evolved over time?
- Which products generate the highest sales?
- Who are the most valuable customers?
- How is revenue distributed across regions?
- What are the typical order patterns and seasonality?
- Which products and regions generate the highest profitability?

## Project Overview

This project presents a comprehensive sales performance analysis based on the AdventureWorks 2019 database.

The objective is to evaluate revenue dynamics, product performance, customer behavior, and business drivers using SQL-based analysis.

The project is structured into several analytical modules.

---

## Business Objective

To identify growth patterns, revenue concentration, seasonality effects, and structural risks in order to support data-driven business decisions.

---

## Project Modules

### 1. Sales Overview (Completed)
Analysis of revenue trends and performance dynamics.

Scope:
- Monthly revenue aggregation
- Month-over-Month (MoM) growth
- Year-over-Year (YoY) growth
- Average Order Value (AOV)
- Monthly ranking within each year
- Trend classification
- Seasonality observations

Files:
- `sql/01_sales_overview.sql`
- `insights/01_sales_overview.md`

---

### 2. Product Performance (Completed)
Revenue contribution and product concentration analysis.

Scope:
- Top revenue-generating products
- Revenue share (% contribution)
- Pareto (80/20) analysis
- Product ranking per year

Files:
- `sql/02_product_performance.sql`
- `insights/02_product_performance.md`

---

### 3. Customer Analysis (Completed)
Analysis of customer purchasing behavior and customer value.

Scope:
- Revenue per customer  
- Top customers by revenue  
- Number of orders per customer  
- Average order value per customer  
- Customer segmentation based on revenue  

Files:
- `sql/03_customer_analysis.sql`
- `insights/03_customer_analysis.md`

---

### 4. Regional Analysis (Completed)
Analysis of geographic sales distribution and regional performance.

Scope:
- Sales per region  
- Regional share of total revenue  
- Ranking of regions by revenue  
- Regional sales trends over time

Files:
- `sql/04_regional_analysis.sql`
- `insights/04_regional_analysis.md`

---

### 5. Order Behavior Analysis (Completed)
Analysis of operational order patterns.

Scope:
- Average number of items per order  
- Average order value  
- Distribution of orders over time  
- Seasonality of order activity 

Files:
- `sql/05_order_behavior.sql`
- `insights/05_order_behavior.md`

---

### 6. Profitability Analysis (Completed)
Analysis of sales profitability across products and regions.

Scope:
- Overall profit margin  
- Products with the highest profitability  
- Regional profitability comparison  

Files:
- `sql/06_profit_analysis.sql`
- `insights/06_profit_analysis.md`

---

## Data Source

The analysis is based on the AdventureWorks 2019 sample database provided by Microsoft.

The database contains transactional sales data including:

- orders
- customers
- products
- territories
- sales details

It is commonly used for learning and demonstrating SQL-based data analysis.

The dataset represents a typical relational transactional sales database.

---

## Tools & Technologies

- SQL Server
- T-SQL
- Window Functions (LAG, RANK)
- Aggregations & KPI calculations
- Excel (data validation)

---

## Analytical Techniques Demonstrated

- Time-series analysis (MoM, YoY)
- Window functions
- Revenue concentration analysis
- KPI calculation and interpretation
- Business-oriented insights generation

---

## Project Summary

This project demonstrates practical SQL skills applied to a realistic sales dataset.

The analysis covers revenue trends, product performance, customer behavior, regional performance, operational order patterns, and overall business profitability.

