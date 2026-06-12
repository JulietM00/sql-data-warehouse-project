
/*
==============================================================
Quality Checks for Gold Layer
===============================================================
Script Purpose:
- This script performs quality checks on the 'gold' layer of the data warehouse, specifically on the 'dim_customers', 'dim_products', and 'fact_sales' views.
- The checks include verifying the uniqueness of keys in the dimension tables and ensuring referential integrity between the fact and dimension tables. 
- The expected results for these checks are outlined in the comments, and any deviations from these expectations may indicate data quality issues that need to be addressed.
- These checks are crucial for maintaining the integrity and reliability of the data in the gold layer, which is used for reporting and analysis.

Usage Notes:
- Run these after data loading Silver Layer.
- Investigate and resolve any discrepancies found during the checks.

*/
-- ==============================================================
-- Quality Check for 'gold.dim_customers'
-- ===============================================================
-- Check for duplicate customer keys in gold.dim_customers
-- Expecation: No Results
SELECT customer_key,
COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;
-- ==============================================================
-- Quality Check for 'gold.dim_products'
-- ===============================================================
-- Check for duplicate product keys in gold.dim_products
-- Expectation: No Results
SELECT product_key,
COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;
-- ==============================================================
-- Quality Check for 'gold.fact_sales'
-- ===============================================================
-- Check for missing customer keys in gold.fact_sales
-- Expectation: No Results
SELECT *
FROM gold.fact_sales fc
LEFT JOIN gold.dim_customers dc 
ON fc.customer_id = dc.customer_id
LEFT JOIN gold.dim_products dp
ON fc.product_key = dp.product_key
WHERE dc.customer_id IS NULL OR dp.product_key IS NULL;

