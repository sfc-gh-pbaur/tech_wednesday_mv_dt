-- Create a Materialized View to summarize sales by product
CREATE MATERIALIZED VIEW MV_PRODUCT_SALES_SUMMARY
AS
SELECT
    PRODUCT_NAME,
    COUNT(*) AS TOTAL_SALES,
    SUM(SALE_AMOUNT) AS TOTAL_REVENUE
FROM
    RAW_SALES
GROUP BY
    PRODUCT_NAME;

-- Query the Materialized View
SELECT * FROM MV_PRODUCT_SALES_SUMMARY ORDER BY PRODUCT_NAME;

-- --- Demonstrate MV Refresh Behavior ---

-- Insert new data into the base table
INSERT INTO RAW_SALES (SALE_ID, PRODUCT_NAME, SALE_AMOUNT, SALE_DATE) VALUES
(6, 'Webcam', 50.00, '2024-01-04'),
(7, 'Laptop', 1300.00, '2024-01-04');

-- Verify new data in base table
SELECT * FROM RAW_SALES ORDER BY SALE_ID;

-- Query the Materialized View AGAIN
-- Notice: The new data (Webcam, additional Laptop sale) is NOT yet reflected.
SELECT * FROM MV_PRODUCT_SALES_SUMMARY ORDER BY PRODUCT_NAME;

-- Materialized Views refresh automatically, but there can be a delay.
-- For demonstration purposes, you can manually refresh to see immediate updates.
-- In a real scenario, Snowflake handles this.
-- ALTER MATERIALIZED VIEW MV_PRODUCT_SALES_SUMMARY REFRESH; -- Uncomment and run if you want to force refresh

-- Query the Materialized View AFTER a potential refresh (or manual refresh)
-- Now, the new data should be reflected.
SELECT * FROM MV_PRODUCT_SALES_SUMMARY ORDER BY PRODUCT_NAME;

-- Show MV definition
DESCRIBE MATERIALIZED VIEW MV_PRODUCT_SALES_SUMMARY;


-- Observations for MV:
--The MV provides fast query performance because data is pre-computed.
--After inserting new data into the base table, the MV did not immediately reflect the changes. It requires an automatic background refresh (or a manual REFRESH for demo purposes).
--MVs have certain limitations on the SQL constructs they can use (e.g., no JOINs on multiple tables, no window functions, etc., in simpler MVs).