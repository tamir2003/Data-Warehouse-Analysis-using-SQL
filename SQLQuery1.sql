/*===============================================================================
🏗️ DATABASE CREATION & SCHEMA INITIALIZATION SCRIPT
===============================================================================
📘 Purpose:
    - Creates a new database named 'DataWarehouseAnalytics'.
    - Drops and recreates it if it already exists.
    - Defines a schema named 'gold' for organized data storage.
    - Creates and populates dimension & fact tables with CSV data.

📁 Files Used:
    - gold.dim_customers.csv
    - gold.dim_products.csv
    - gold.fact_sales.csv

⚙️ Requirements:
    - Microsoft SQL Server
    - CSV files located in: C:\sql\sql-data-analytics-project\datasets\csv-files\
===============================================================================*/


/*===============================================================================
1️⃣ CREATE DATABASE
===============================================================================*/

USE master;
GO

-- 🔄 Drop and recreate the 'DataWarehouseAnalytics' database if it exists
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouseAnalytics')
BEGIN
    PRINT 'Database already exists. Dropping and recreating...';
    ALTER DATABASE DataWarehouseAnalytics SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouseAnalytics;
END;
GO

-- 🆕 Create the 'DataWarehouseAnalytics' database
CREATE DATABASE DataWarehouseAnalytics;
GO

-- Switch context to the new database
USE DataWarehouseAnalytics;
GO


/*===============================================================================
2️⃣ CREATE SCHEMAS
===============================================================================*/

-- 🏷️ Create the 'gold' schema for curated analytics-ready data
CREATE SCHEMA gold;
GO


/*===============================================================================
3️⃣ CREATE TABLES
===============================================================================*/

-- 👥 Dimension: Customers
CREATE TABLE gold.dim_customers (
    customer_key              INT,
    customer_id               INT,
    customer_number           NVARCHAR(50),
    first_name                NVARCHAR(50),
    last_name                 NVARCHAR(50),
    country                   NVARCHAR(50),
    marital_status            NVARCHAR(50),
    gender                    NVARCHAR(50),
    birthdate                 DATE,
    create_date               DATE
);
GO

-- 🛍️ Dimension: Products
CREATE TABLE gold.dim_products (
    product_key               INT,
    product_id                INT,
    product_number            NVARCHAR(50),
    product_name              NVARCHAR(50),
    category_id               NVARCHAR(50),
    category                  NVARCHAR(50),
    subcategory               NVARCHAR(50),
    maintenance               NVARCHAR(50),
    cost                      INT,
    product_line              NVARCHAR(50),
    start_date                DATE
);
GO

-- 💰 Fact: Sales
CREATE TABLE gold.fact_sales (
    order_number              NVARCHAR(50),
    product_key               INT,
    customer_key              INT,
    order_date                DATE,
    shipping_date             DATE,
    due_date                  DATE,
    sales_amount              INT,
    quantity                  TINYINT,
    price                     INT
);
GO


/*===============================================================================
4️⃣ LOAD DATA FROM CSV FILES
===============================================================================
Purpose:
    - Import data into each table from corresponding CSV files.
    - Uses BULK INSERT for high performance.
===============================================================================*/

-- 👥 Load Data: dim_customers
TRUNCATE TABLE gold.dim_customers;
GO

BULK INSERT gold.dim_customers
FROM 'C:\sql\sql-data-analytics-project\datasets\csv-files\gold.dim_customers.csv'
WITH (
    FIRSTROW = 2,              -- Skip header row
    FIELDTERMINATOR = ',',     -- CSV delimiter
    TABLOCK
);
GO


-- 🛍️ Load Data: dim_products
TRUNCATE TABLE gold.dim_products;
GO

BULK INSERT gold.dim_products
FROM 'C:\sql\sql-data-analytics-project\datasets\csv-files\gold.dim_products.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);
GO


-- 💰 Load Data: fact_sales
TRUNCATE TABLE gold.fact_sales;
GO

BULK INSERT gold.fact_sales
FROM 'C:\sql\sql-data-analytics-project\datasets\csv-files\gold.fact_sales.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);
GO


/*===============================================================================
✅ COMPLETION MESSAGE
===============================================================================*/

PRINT '✅ Database [DataWarehouseAnalytics] and schema [gold] created successfully.';
PRINT '✅ All tables loaded with CSV data.';
