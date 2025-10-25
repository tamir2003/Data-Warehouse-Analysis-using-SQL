# Data-Warehouse-Analysis-using-SQL      

**📊 Data Warehouse Analytics Project
📌 Overview**

This project demonstrates the design and implementation of a Data Warehouse for Analytics. It covers the end-to-end pipeline from database creation, schema design, and data loading (ETL) to advanced SQL reporting and analytics.
The warehouse consolidates customer, product, and sales data into a star schema (fact + dimension model) and enables business intelligence reporting for customer behavior, product performance, and sales trends.

**🏗️ Project Architecture**

Database Creation & Schema Setup
Database: DataWarehouseAnalytics
Schema: gold (for curated business-ready tables)

**---------Star Schema Design-----**

**Dimension Tables:**
dim_customers – Customer profile and demographics
dim_products – Product catalog with categories and cost

**Fact Table:**
fact_sales – Sales transactions (order-level data)

**ETL (Extract, Transform, Load):**
Data loaded using BULK INSERT from CSV files.
Tables truncated and refreshed for reproducibility.

**📂 Data Model:** 
fact_sales → Contains transaction details (order, customer, product, sales, quantity).
dim_customers → Contains customer demographics.
dim_products → Contains product hierarchy (category, subcategory).

**🔑 Analysis & Reports**
The project includes multiple types of analysis:

**1. Exploratory Analysis**

Database & schema exploration (tables, columns, metadata).
Unique values in countries, categories, and product hierarchies.
Date range checks for historical coverage.

**2. Key Metrics**

Total Sales, Total Quantity, Total Orders, Total Customers, Average Price.
Business KPI snapshot query (all measures in a single output).
<img width="658" height="277" alt="Screenshot 2025-10-25 172701" src="https://github.com/user-attachments/assets/65b3302f-5ab8-4940-bdd6-df78051185cb" />


**3. Magnitude Analysis**

Customers by country & gender.
Products by category with cost and revenue.
Sales contribution by categories & customers.

**4. Ranking Analysis**

Top 5 highest revenue products.
Bottom 5 worst-performing products.
Top 10 customers by revenue.
Customers with fewest orders.
<img width="347" height="207" alt="Screenshot 2025-10-25 172822" src="https://github.com/user-attachments/assets/811cbd26-e6da-4556-8c26-393cbb1ebe08" />
<img width="539" height="482" alt="Screenshot 2025-10-25 172858" src="https://github.com/user-attachments/assets/6c7a259a-75d9-48e5-ba19-46f7dfd45b17" />
<img width="409" height="286" alt="Screenshot 2025-10-25 172912" src="https://github.com/user-attachments/assets/ca8ba341-4905-4178-aba9-ea33da9c6bba" />



**5. Time-Series Analysis**

Sales trends by year/month.
Cumulative running totals & moving averages.
Year-over-Year (YoY) growth using LAG().
<img width="378" height="250" alt="Screenshot 2025-10-25 173049" src="https://github.com/user-attachments/assets/1e882227-0f91-4129-9da0-00a77de526eb" />
<img width="526" height="360" alt="Screenshot 2025-10-25 173113" src="https://github.com/user-attachments/assets/5fc0cbd1-0c4d-43bc-8105-f4e95fc2d263" />



**6. Segmentation**
   
Product segmentation by cost range.
Customer segmentation: VIP, Regular, New based on lifespan & spending.
<img width="527" height="439" alt="Screenshot 2025-10-25 173202" src="https://github.com/user-attachments/assets/768870dd-06b2-4a58-81ef-363ac669bb93" />
<img width="746" height="335" alt="Screenshot 2025-10-25 173249" src="https://github.com/user-attachments/assets/72b9a271-94a8-42d3-9835-99b5b823b709" />



**7. Part-to-Whole Analysis**

Contribution of each category to total sales (% share).

**📑 Business Reports**

**1. Customer Report (report_customers)**

Includes customer profile, age group, segment, total sales, total orders, recency, average order value, and monthly spend.
<img width="1366" height="768" alt="Screenshot (50)" src="https://github.com/user-attachments/assets/be54b444-badb-498b-a279-d76fbe70b2cf" />


**2. Product Report (report_products)**

Includes product details, total sales, total orders, average selling price, revenue segment (High/Mid/Low performer), recency, and monthly revenue.
<img width="1366" height="768" alt="Screenshot (51)" src="https://github.com/user-attachments/assets/e499926e-bec8-440b-8f0f-a7f0bf8bb2e0" />
<img width="1366" height="768" alt="Screenshot (55)" src="https://github.com/user-attachments/assets/f4aa88aa-db3e-42a6-88ad-1a510b1126a0" />



**📊 Key Insights**

--Customer Segmentation: VIP customers (≥12 months & > $5k spending) drive significant revenue.
--Product Insights: High-performing products generate >$50k revenue; low performers need optimization.
--Time Trends: Sales show seasonal patterns with clear growth in specific periods.
--Category Contribution: Few categories dominate revenue contribution (Pareto principle).

**🛠️ Tools & Technologies**

SQL Server (T-SQL) → Database design, ETL, analytics.
CSV Files → Data sources for customers, products, and sales.
Star Schema Modeling → Fact & Dimension design.
Window Functions & Aggregations → Advanced reporting queries.
