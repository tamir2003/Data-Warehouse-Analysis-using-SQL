/*===============================================================================
🌟 DATABASE EXPLORATION & INSIGHTS SCRIPT
===============================================================================
📘 Purpose:
    - Explore database structure, schemas, and metadata.
    - Analyze key dimensions, measures, and data distributions.
    - Identify top-performing entities and overall business metrics.

📂 Schema:
    - gold.dim_customers
    - gold.dim_products
    - gold.fact_sales

📊 Topics Covered:
    1️⃣ Database Exploration  
    2️⃣ Dimensions Exploration  
    3️⃣ Date Range Exploration  
    4️⃣ Measures Exploration  
    5️⃣ Magnitude Analysis  
    6️⃣ Ranking Analysis
===============================================================================*/


/*===============================================================================
1️⃣ DATABASE EXPLORATION
===============================================================================
Purpose:
    - To explore the structure of the database, including table lists and columns.
===============================================================================*/

-- 🔍 Retrieve a list of all tables in the database
SELECT 
    TABLE_CATALOG, 
    TABLE_SCHEMA, 
    TABLE_NAME, 
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES;

-- 🧱 Retrieve all columns for a specific table (dim_customers)
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    IS_NULLABLE, 
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';

-- 🧱 Retrieve all columns for a specific table (fact_sales)
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    IS_NULLABLE, 
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'fact_sales';

-- 🧱 Retrieve all columns for a specific table (dim_products)
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    IS_NULLABLE, 
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_products';


/*===============================================================================
2️⃣ DIMENSIONS EXPLORATION
===============================================================================
Purpose:
    - To explore the structure and distinct values of dimension tables.
===============================================================================*/

-- 🌍 Unique customer countries
SELECT DISTINCT 
    country 
FROM gold.dim_customers
ORDER BY country;

-- 🏷️ Unique product categories, subcategories, and product names
SELECT DISTINCT 
    category, 
    subcategory, 
    product_name 
FROM gold.dim_products
ORDER BY category, subcategory, product_name;


/*===============================================================================
3️⃣ DATE RANGE EXPLORATION
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
===============================================================================*/

-- ⏳ First and last order date, and total range in months
SELECT 
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS order_range_months
FROM gold.fact_sales;

-- 👶 Youngest and oldest customer based on birthdate
SELECT
    MIN(birthdate) AS oldest_birthdate,
    DATEDIFF(YEAR, MIN(birthdate), GETDATE()) AS oldest_age,
    MAX(birthdate) AS youngest_birthdate,
    DATEDIFF(YEAR, MAX(birthdate), GETDATE()) AS youngest_age
FROM gold.dim_customers;


/*===============================================================================
4️⃣ MEASURES EXPLORATION (KEY METRICS)
===============================================================================
Purpose:
    - To calculate aggregated metrics and gain quick business insights.
===============================================================================*/

-- 💰 Total Sales
SELECT SUM(sales_amount) AS total_sales FROM gold.fact_sales;

-- 📦 Total Quantity Sold
SELECT SUM(quantity) AS total_quantity FROM gold.fact_sales;

-- 💵 Average Selling Price
SELECT AVG(price) AS avg_price FROM gold.fact_sales;

-- 🧾 Total Orders
SELECT COUNT(DISTINCT order_number) AS total_orders FROM gold.fact_sales;

-- 🧩 Total Products
SELECT COUNT(DISTINCT product_name) AS total_products FROM gold.dim_products;

-- 👥 Total Customers
SELECT COUNT(customer_key) AS total_customers FROM gold.dim_customers;

-- 🛍️ Total Customers Who Placed Orders
SELECT COUNT(DISTINCT customer_key) AS total_customers_with_orders FROM gold.fact_sales;

-- 📈 Combined Business Metrics Report
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Average Price', AVG(price) FROM gold.fact_sales
UNION ALL
SELECT 'Total Orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total Products', COUNT(DISTINCT product_name) FROM gold.dim_products
UNION ALL
SELECT 'Total Customers', COUNT(customer_key) FROM gold.dim_customers;


/*===============================================================================
5️⃣ MAGNITUDE ANALYSIS
===============================================================================
Purpose:
    - To quantify and compare data across categories and dimensions.
===============================================================================*/

-- 🌎 Total Customers by Country
SELECT
    country,
    COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY country
ORDER BY total_customers DESC;

-- 🚻 Total Customers by Gender
SELECT
    gender,
    COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY gender
ORDER BY total_customers DESC;

-- 🏷️ Total Products by Category
SELECT
    category,
    COUNT(product_key) AS total_products
FROM gold.dim_products
GROUP BY category
ORDER BY total_products DESC;

-- 💸 Average Cost per Category
SELECT
    category,
    AVG(cost) AS avg_cost
FROM gold.dim_products
GROUP BY category
ORDER BY avg_cost DESC;

-- 💰 Total Revenue by Category
SELECT
    p.category,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
GROUP BY p.category
ORDER BY total_revenue DESC;

-- 👤 Total Revenue by Customer
SELECT
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY 
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_revenue DESC;

-- 📦 Distribution of Sold Items by Country
SELECT
    c.country,
    SUM(f.quantity) AS total_sold_items
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY c.country
ORDER BY total_sold_items DESC;


/*===============================================================================
6️⃣ RANKING ANALYSIS
===============================================================================
Purpose:
    - To rank products, customers, and other entities based on performance.
===============================================================================*/

-- 🥇 Top 5 Products by Highest Revenue
SELECT TOP 5
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC;

-- 🧮 Ranking Products Using Window Functions
SELECT *
FROM (
    SELECT
        p.product_name,
        SUM(f.sales_amount) AS total_revenue,
        RANK() OVER (ORDER BY SUM(f.sales_amount) DESC) AS rank_products
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON p.product_key = f.product_key
    GROUP BY p.product_name
) AS ranked_products
WHERE rank_products <= 5;

-- 🧾 Bottom 5 Products (Lowest Revenue)
SELECT TOP 5
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue ASC;

-- 💎 Top 10 Customers by Total Revenue
SELECT TOP 10
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY 
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_revenue DESC;

-- 🧍‍♂️ Bottom 3 Customers (Fewest Orders)
SELECT TOP 3
    c.customer_key,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY 
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_orders ASC;
