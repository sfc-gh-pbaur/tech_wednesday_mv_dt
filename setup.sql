USE ROLE sysadmin;
USE WAREHOUSE compute_wh;

-- Create a new database for the demo (optional, but good practice)
CREATE DATABASE IF NOT EXISTS DT_MV_DEMO_DB;

-- Use the newly created database
USE DATABASE DT_MV_DEMO_DB;

-- Create a schema for our objects
CREATE SCHEMA IF NOT EXISTS DEMO_SCHEMA;

-- Use the schema
USE SCHEMA DEMO_SCHEMA;

-- Create a base table for sales data
CREATE OR REPLACE TABLE RAW_SALES (
    SALE_ID INT,
    PRODUCT_NAME VARCHAR(100),
    SALE_AMOUNT DECIMAL(10, 2),
    SALE_DATE DATE
);

-- Insert initial data into the base table
INSERT INTO RAW_SALES (SALE_ID, PRODUCT_NAME, SALE_AMOUNT, SALE_DATE) VALUES
(1, 'Laptop', 1200.00, '2024-01-01'),
(2, 'Mouse', 25.00, '2024-01-01'),
(3, 'Keyboard', 75.00, '2024-01-02'),
(4, 'Monitor', 300.00, '2024-01-03'),
(5, 'Laptop', 1500.00, '2024-01-03');

-- Verify initial data
SELECT * FROM RAW_SALES ORDER BY SALE_ID;