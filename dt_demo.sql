USE DATABASE dt_mv_demo_db;
USE SCHEMA demo_schema;

-- Create a Dynamic Table to summarize sales by product, targeting a 1-minute lag
-- Note: 'WAREHOUSE' is required for DTs to define compute resources for refresh.
-- Replace 'YOUR_WAREHOUSE_NAME' with an actual warehouse you have access to.
-- If you don't have one, create a small one: CREATE WAREHOUSE MY_DEMO_WH WITH WAREHOUSE_SIZE = 'XSMALL';
CREATE OR REPLACE DYNAMIC TABLE DT_PRODUCT_SALES_SUMMARY
TARGET_LAG = '1 MINUTE'
WAREHOUSE = 'YOUR_WAREHOUSE_NAME' -- IMPORTANT: Replace with your actual warehouse name
AS
SELECT
    PRODUCT_NAME,
    COUNT(*) AS TOTAL_SALES,
    SUM(SALE_AMOUNT) AS TOTAL_REVENUE
FROM
    RAW_SALES
GROUP BY
    PRODUCT_NAME;

-- Query the Dynamic Table
SELECT * FROM DT_PRODUCT_SALES_SUMMARY ORDER BY PRODUCT_NAME;

-- --- Demonstrate DT Refresh Behavior ---

-- Insert MORE new data into the base table
INSERT INTO RAW_SALES (SALE_ID, PRODUCT_NAME, SALE_AMOUNT, SALE_DATE) VALUES
(8, 'Headphones', 150.00, '2024-01-05'),
(9, 'Monitor', 350.00, '2024-01-05');

-- Verify new data in base table
SELECT * FROM RAW_SALES ORDER BY SALE_ID;

-- Query the Dynamic Table AGAIN
-- Wait for a minute or two. The new data should automatically appear.
-- Dynamic Tables are continuously refreshed in the background.
SELECT * FROM DT_PRODUCT_SALES_SUMMARY ORDER BY PRODUCT_NAME;

-- Show DT definition and status
DESCRIBE DYNAMIC TABLE DT_PRODUCT_SALES_SUMMARY;
SHOW DYNAMIC TABLES; -- Look for the 'state' and 'refresh_mode' columns


--Observations for DT:
--The DT also provides fast query performance.
--After inserting new data into the base table, the DT automatically picked up the changes based on its TARGET_LAG. You don't need to manually refresh.
--DTs are more flexible with SQL (can include JOINs, window functions, etc., across multiple tables).
--They require a specified WAREHOUSE for continuous refresh.


-- Step 4: Key Differences & Use Cases
--Let's summarize the main distinctions.
-- You can query both to see their current state side-by-side
SELECT 'Materialized View' AS TYPE, PRODUCT_NAME, TOTAL_SALES, TOTAL_REVENUE FROM MV_PRODUCT_SALES_SUMMARY
UNION ALL
SELECT 'Dynamic Table' AS TYPE, PRODUCT_NAME, TOTAL_SALES, TOTAL_REVENUE FROM DT_PRODUCT_SALES_SUMMARY
ORDER BY TYPE, PRODUCT_NAME;