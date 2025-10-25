/*===============================================================================
📊 CUSTOMER & PRODUCT REPORT CREATION SCRIPT
===============================================================================
📘 Purpose:
    - Generate analytical reports for customers and products.
    - Provide segmentation, KPIs, and behavioral insights for data-driven decisions.

📈 Reports Created:
    1️⃣ gold.report_customers
    2️⃣ gold.report_products

🧩 Key Techniques Used:
    - Common Table Expressions (CTEs)
    - Aggregations (SUM, COUNT, AVG)
    - Conditional Logic (CASE)
    - Window & Date Functions (DATEDIFF, GETDATE)
===============================================================================*/


/*===============================================================================
1️⃣ CUSTOMER REPORT
===============================================================================
Purpose:
    - Consolidates key customer metrics and behaviors.

Highlights:
    1. Includes demographic & transaction fields.
    2. Segments customers into VIP, Regular, and New.
    3. Aggregates key metrics:
       - total orders
       - total sales
       - total quantity
       - total products
       - lifespan (in months)
    4. Calculates KPIs:
       - recency
       - average order value (AOV)
       - average monthly spend
===============================================================================*/

-- =============================================================================
-- 🧾 Create View: gold.report_customers
-- =============================================================================
IF OBJECT_ID('gold.report_customers', 'V') IS NOT NULL
    DROP VIEW gold.report_customers;
GO

CREATE VIEW gold.report_customers AS

WITH base_query AS (
/*---------------------------------------------------------------------------  
1️⃣ Base Query: Retrieve core columns from fact_sales and dim_customers  
---------------------------------------------------------------------------*/
    SELECT
        f.order_number,
        f.product_key,
        f.order_date,
        f.sales_amount,
        f.quantity,
        c.customer_key,
        c.customer_number,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        DATEDIFF(YEAR, c.birthdate, GETDATE()) AS age
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c
        ON c.customer_key = f.customer_key
    WHERE order_date IS NOT NULL
),

customer_aggregation AS (
/*---------------------------------------------------------------------------  
2️⃣ Customer Aggregations: Summarize key metrics at the customer level  
---------------------------------------------------------------------------*/
    SELECT 
        customer_key,
        customer_number,
        customer_name,
        age,
        COUNT(DISTINCT order_number) AS total_orders,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        COUNT(DISTINCT product_key) AS total_products,
        MAX(order_date) AS last_order_date,
        DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan
    FROM base_query
    GROUP BY 
        customer_key,
        customer_number,
        customer_name,
        age
)

/*---------------------------------------------------------------------------  
3️⃣ Final Output: Customer Segmentation & KPI Calculation  
---------------------------------------------------------------------------*/
SELECT
    customer_key,
    customer_number,
    customer_name,
    age,

    -- 🎯 Age Grouping
    CASE 
         WHEN age < 20 THEN 'Under 20'
         WHEN age BETWEEN 20 AND 29 THEN '20-29'
         WHEN age BETWEEN 30 AND 39 THEN '30-39'
         WHEN age BETWEEN 40 AND 49 THEN '40-49'
         ELSE '50 and above'
    END AS age_group,

    -- 👥 Customer Segmentation
    CASE 
        WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
        WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
        ELSE 'New'
    END AS customer_segment,

    last_order_date,
    DATEDIFF(MONTH, last_order_date, GETDATE()) AS recency,
    total_orders,
    total_sales,
    total_quantity,
    total_products,
    lifespan,

    -- 💵 Average Order Value (AOV)
    CASE 
        WHEN total_orders = 0 THEN 0
        ELSE total_sales / total_orders
    END AS avg_order_value,

    -- 💰 Average Monthly Spend
    CASE 
        WHEN lifespan = 0 THEN total_sales
        ELSE total_sales / lifespan
    END AS avg_monthly_spend

FROM customer_aggregation;
GO



/*===============================================================================
2️⃣ PRODUCT REPORT
===============================================================================
Purpose:
    - Consolidates key product performance and sales behavior.

Highlights:
    1. Includes product, category, and cost details.
    2. Segments products into performance tiers.
    3. Aggregates:
       - total orders
       - total sales
       - total quantity
       - total customers
       - lifespan (months)
    4. Calculates KPIs:
       - recency
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================*/

-- =============================================================================
-- 📦 Create View: gold.report_products
-- =============================================================================
IF OBJECT_ID('gold.report_products', 'V') IS NOT NULL
    DROP VIEW gold.report_products;
GO

CREATE VIEW gold.report_products AS

WITH base_query AS (
/*---------------------------------------------------------------------------  
1️⃣ Base Query: Retrieve sales and product information  
---------------------------------------------------------------------------*/
    SELECT
        f.order_number,
        f.order_date,
        f.customer_key,
        f.sales_amount,
        f.quantity,
        p.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    WHERE order_date IS NOT NULL
),

product_aggregations AS (
/*---------------------------------------------------------------------------  
2️⃣ Product Aggregations: Summarize at the product level  
---------------------------------------------------------------------------*/
    SELECT
        product_key,
        product_name,
        category,
        subcategory,
        cost,
        DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
        MAX(order_date) AS last_sale_date,
        COUNT(DISTINCT order_number) AS total_orders,
        COUNT(DISTINCT customer_key) AS total_customers,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)), 1) AS avg_selling_price
    FROM base_query
    GROUP BY
        product_key,
        product_name,
        category,
        subcategory,
        cost
)

/*---------------------------------------------------------------------------  
3️⃣ Final Output: Product Segmentation & KPI Calculation  
---------------------------------------------------------------------------*/
SELECT 
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    last_sale_date,
    DATEDIFF(MONTH, last_sale_date, GETDATE()) AS recency_in_months,

    -- 🏆 Product Segment
    CASE
        WHEN total_sales > 50000 THEN 'High-Performer'
        WHEN total_sales >= 10000 THEN 'Mid-Range'
        ELSE 'Low-Performer'
    END AS product_segment,

    lifespan,
    total_orders,
    total_sales,
    total_quantity,
    total_customers,
    avg_selling_price,

    -- 💵 Average Order Revenue (AOR)
    CASE 
        WHEN total_orders = 0 THEN 0
        ELSE total_sales / total_orders
    END AS avg_order_revenue,

    -- 💰 Average Monthly Revenue
    CASE
        WHEN lifespan = 0 THEN total_sales
        ELSE total_sales / lifespan
    END AS avg_monthly_revenue

FROM product_aggregations;
GO


/*===============================================================================
✅ COMPLETION MESSAGE
===============================================================================*/
PRINT '✅ Views [gold.report_customers] and [gold.report_products] created successfully.';
