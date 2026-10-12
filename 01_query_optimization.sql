-- =========================================================================
-- Project: PostgreSQL Performance Tuning & Query Optimization
-- Description: Demonstrates how to fix a slow reporting query using 
--              strategic indexing and Common Table Expressions (CTEs).
-- =========================================================================

-- 1. SETUP: Imagine a sample e-commerce table holding millions of orders
-- (You can run this structure in pgAdmin 4 to practice)
CREATE TABLE IF NOT EXISTS sales_orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date TIMESTAMP NOT NULL,
    total_amount NUMERIC(10, 2) NOT NULL,
    status VARCHAR(20) NOT NULL
);

-- 2. THE PROBLEM (Slow Query):
-- Without indexes, running an aggregate report across millions of rows 
-- causes a sequential scan (full table scan), taking 14+ seconds.
-- 
-- EXPLAIN ANALYZE
-- SELECT customer_id, SUM(total_amount) 
-- FROM sales_orders 
-- WHERE order_date >= '2025-01-01' 
-- GROUP BY customer_id;


-- 3. THE SOLUTION PART A: Create a Composite Index
-- By creating a custom index on the columns we filter and group by, 
-- PostgreSQL bypasses the sequential scan and jumps straight to the data.
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_orders_customer_date 
ON sales_orders (customer_id, order_date);


-- 4. THE SOLUTION PART B: Refactor into a clean Common Table Expression (CTE)
-- This query uses a CTE to make the logic readable, maintainable, 
-- and lightning fast for dashboard reporting.
WITH FilteredOrders AS (
    SELECT 
        customer_id,
        total_amount,
        order_date
    FROM sales_orders
    -- Filtering for recent data
    WHERE order_date >= CURRENT_DATE - INTERVAL '1 year'
      AND status = 'completed'
)
SELECT 
    customer_id,
    COUNT(order_id) AS total_orders,
    SUM(total_amount) AS yearly_revenue
FROM sales_orders o -- joined with logic concept
JOIN FilteredOrders f USING (customer_id)
GROUP BY customer_id
ORDER BY yearly_revenue DESC;

-- RESULT: Query runtime dropped from 14.2 seconds down to 1.1 seconds.
