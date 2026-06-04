/*
=======================================================
Quality Checks for Silver Layer Tables
========================================================
Script Purpose:
This script performs a series of data quality checks on the Silver layer tables in a data warehouse environment.
The checks are designed to identify potential issues with the data, such as null values, duplicates, inconsistent formatting, and out-of-range values.
- The script is organized by table, with specific checks tailored to the expected data quality issues for each table.The checks include:
-- Checking for null values in critical columns (e.g., primary keys, dates, sales amounts)
- Checking for duplicate records based on primary keys
- Checking for unwanted spaces in string fields
- Checking for invalid date values (e.g., future dates, dates before a certain threshold)
- Checking for data consistency (e.g., sales amount should equal quantity multiplied by price)
- Checking for unexpected values in categorical fields (e.g., marital status, product lines

Usage Notes:
- The script should be run after the Silver layer has been loaded with data from the Bronze layer, as it relies on the presence of data in the Silver tables.
*/



--======================================================
-- Checking 'silver.crm_cust_info'
--======================================================
-- Check for NULLs or Duplicates in Primary Keys
-- Expectation: No Results
SELECT 
cst_id,
COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Check for unwanted spaces
-- Expectations: No Results
SELECT cst_key
FROM silver.crm_cust_info
WHERE cst_key != TRIM(cst_key);

-- Data Standardization & Consistency
SELECT DISTINCT 
cst_marital_status
FROM silver.crm_cust_info;

--======================================================
-- Checking 'silver.crm_prd_info'
--======================================================

-- Check for NULLs or Duplicates in Primary Keys
-- Expectation: No Results
SELECT 
prd_id,
COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Check for unwanted spaces
-- Expectations: No Results
SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Check for invalid dates
-- Expectations: No Results
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost <= 0 OR  prd_cost IS NULL;

-- Data Standardization & Consistency
-- Check for unexpected product lines
-- Expectations: No Results
SELECT DISTINCT prd_line
FROM silver.crm_prd_info;

-- Check for products with start date greater than end date
-- Expectations: No Results
SELECT *
FROM silver.crm_prd_info
WHERE prd_start_dt > prd_end_dt;


--======================================================
-- Checking 'silver.crm_sales_detals'
--======================================================

-- Check for Invalid Dates
-- Expectations: No Results
SELECT 
ISNULL(sls_ship_dt,0) sls_ship_dt
FROM bronze.crm_sales_detals
WHERE sls_ship_dt <= 0 or
LEN(sls_ship_dt) != 8 
or sls_ship_dt > 20500101 or
sls_ship_dt < 19000101;

-- Check for uneven order dates (order date should not be greater than ship date or due date)
-- Expectations: No Results
SELECT *
FROM bronze.crm_sales_detals
WHERE sls_ord_dt > sls_ship_dt
OR sls_ord_dt > sls_due_dt;

-- Check for data consistency between sales, quantity and price
-- Expectations: No Results
SELECT
sls_sales,
sls_qualtity,
sls_price
FROM silver.crm_sales_detals
WHERE sls_sales != sls_qualtity * sls_price
OR sls_sales  IS NULL 
OR sls_qualtity IS NULL
OR sls_price IS NULL
OR sls_sales <= 0
OR sls_qualtity <= 0
OR sls_price <= 0
ORDER BY sls_sales, sls_qualtity, sls_price;


--======================================================
-- Checking 'silver.erp_cust_az12'
--======================================================

-- Identify Out of Range Birthdates
-- Check for Birthdates between 1977-09-21 and current date
SELECT DISTINCT
bdate
FROM silver.erp_cust_az12
WHERE bdate <= '1977-09-21'
OR bdate > GETDATE();

-- Data Standardization & Consistency
SELECT DISTINCT gender
FROM silver.erp_cust_az12;


--======================================================
-- Checking 'silver.erp_loc_a101'
--======================================================

-- Data Standardization & Consistency
SELECT DISTINCT cntry
FROM silver.erp_loc_a101
ORDER BY cntry;


--======================================================
-- Checking 'silver.erp_px_cat_g1v2'
--======================================================

-- Check for unwanted spaces
-- Expectations: No Results
SELECT *
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat)
OR subcat != TRIM(subcat)
OR maintainance != TRIM(maintainance);


-- Data Standardization & Consistency
SELECT DISTINCT maintainance
FROM silver.erp_px_cat_g1v2;
