# 🏢 Data Warehouse Analysis using SQL  

---

## 📊 Project Overview  

This project demonstrates the **design and implementation of a Data Warehouse for Analytics**.  
It covers the **end-to-end data pipeline** — from database creation, schema design, and data loading (ETL), to advanced SQL reporting and analytics.  

The warehouse consolidates **customer**, **product**, and **sales** data into a **star schema** (fact + dimension model), enabling **business intelligence reporting** for customer behavior, product performance, and sales trends.

---

## 🏗️ Project Architecture  

### ⚙️ Database & Schema Setup  
- **Database:** `DataWarehouseAnalytics`  
- **Schema:** `gold` (for curated, business-ready tables)  

---

### 🧩 Star Schema Design  

**Dimension Tables:**  
- `dim_customers` – Customer profile and demographics  
- `dim_products` – Product catalog with categories and cost  

**Fact Table:**  
- `fact_sales` – Sales transactions (order-level data)  

---

### 🔄 ETL (Extract, Transform, Load)  
- Data loaded using **BULK INSERT** from CSV files  
- Tables truncated and refreshed for reproducibility  
- Ensures clean, consistent, and version-controlled datasets  

---

## 📂 Data Model  

| Table | Description |
|--------|--------------|
| `fact_sales` | Contains transaction details (order, customer, product, sales, quantity) |
| `dim_customers` | Contains customer demographics and attributes |
| `dim_products` | Contains product hierarchy (category, subcategory) |

---

## 🔍 Analysis & Reports  

This project includes multiple analysis modules using SQL queries and analytical functions.  

---

### 1️⃣ Exploratory Analysis  
- Database & schema exploration (tables, columns, metadata)  
- Unique values in **countries**, **categories**, and **product hierarchies**  
- Date range validation for historical coverage  

---

### 2️⃣ Key Metrics  
- **Total Sales**  
- **Total Quantity**  
- **Total Orders**  
- **Total Customers**  
- **Average Price**  
- Business KPI snapshot query (all measures in one output)  

---

### 3️⃣ Magnitude Analysis  
- Customers by **country** and **gender**  
- Products by **category** with cost and revenue metrics  
- Sales contribution by **categories** & **customers**  

---

### 4️⃣ Ranking Analysis  
- Top 5 highest revenue products  
- Bottom 5 lowest performing products  
- Top 10 customers by revenue  
- Customers with the fewest orders  

---

### 5️⃣ Time-Series Analysis  
- Sales trends by **year** and **month**  
- Cumulative running totals & moving averages  
- **Year-over-Year (YoY)** growth using `LAG()` function  

---

### 6️⃣ Segmentation  
- **Product segmentation:** based on cost ranges  
- **Customer segmentation:** VIP, Regular, and New (based on lifespan & spending)  

---

### 7️⃣ Part-to-Whole Analysis  
- Contribution of each category to **total sales (%)**  

---

## 📑 Business Reports  

### 🧾 1. Customer Report (`report_customers`)  
Includes:  
- Customer profile  
- Age group & segment  
- Total sales & total orders  
- Recency & average order value  
- Monthly spend  

<img width="1366" height="768" alt="Screenshot (50)" src="https://github.com/user-attachments/assets/be54b444-badb-498b-a279-d76fbe70b2cf" />  

---

### 📦 2. Product Report (`report_products`)  
Includes:  
- Product details  
- Total sales & total orders  
- Average selling price  
- Revenue segment (High / Mid / Low performer)  
- Recency & monthly revenue  

<img width="1366" height="768" alt="Screenshot (51)" src="https://github.com/user-attachments/assets/e499926e-bec8-440b-8f0f-a7f0bf8bb2e0" />  
<img width="1366" height="768" alt="Screenshot (55)" src="https://github.com/user-attachments/assets/f4aa88aa-db3e-42a6-88ad-1a510b1126a0" />  

---

## 📊 Key Insights  

- **Customer Segmentation:**  
  VIP customers (≥12 months & > $5k spending) drive significant revenue.  

- **Product Insights:**  
  High-performing products generate >$50k revenue, while low performers need optimization.  

- **Time Trends:**  
  Sales exhibit seasonal patterns with growth in specific months.  

- **Category Contribution:**  
  Few product categories dominate revenue — following the **Pareto (80/20) principle**.  

---

## 🛠️ Tools & Technologies  

| Tool | Purpose |
|------|----------|
| **SQL Server (T-SQL)** | Database design, ETL, and analytics |
| **CSV Files** | Data sources for customers, products, and sales |
| **Star Schema Modeling** | Fact & Dimension design for reporting |
| **Window Functions & Aggregations** | Used for ranking, segmentation, and time-series analysis |

---

## 🚀 Summary  

This project showcases how SQL can be used to build a **Data Warehouse Analytics System** from scratch —  
covering data modeling, ETL, and analytical reporting for business insights.  

It provides a scalable framework for data-driven decision-making in **sales and customer analytics**.

---

### 🔖 Tags  
`#SQLServer` `#DataWarehouse` `#ETL` `#DataAnalytics` `#BusinessIntelligence` `#StarSchema` `#SQLProject`
