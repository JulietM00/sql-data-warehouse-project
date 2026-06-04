/*
=======================================================
Stored Procedure: Load Silver Layer From Bronze to Silver Layer
=======================================================
Script Purpose:
- This stored procedure is designed to load data from the Bronze layer to the Silver layer in a data warehouse environment.
- It performs data transformation and cleansing operations to ensure that the data in the Silver layer is of high quality and ready for analysis.

The procedure includes the following steps:
- Truncating existing data in the Silver layer tables to ensure a fresh load.
- Inserting transformed and cleansed data from the Bronze layer into the corresponding Silver layer tables.

The transformations include:
- Standardizing
- Handling null or invalid values 
- Calculating derived columns (e.g., end date for products, sales amount based on quantity and price)
- The procedure also includes error handling to catch and log any issues that occur during the loading process, ensuring that any problems can be diagnosed and addressed promptly.
- Overall, this stored procedure is a critical component of the ETL (Extract, Transform, Load) process in the data warehouse, ensuring that the Silver layer contains clean and reliable data for downstream analytics and reporting.

Parameters: None

Usage Example:
EXEC silver.load_silver;
*/


CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN

DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
BEGIN TRY 
SET @batch_start_time = GETDATE();
PRINT'================================================='
PRINT'Loading Silver Layer'
PRINT'================================================='


PRINT'-------------------------------------------------'
PRINT'Loading CRM Tables'
PRINT'-------------------------------------------------'

SET @start_time = GETDATE();
PRINT '>> Truncating Table: silver.crm_cust_info';
TRUNCATE TABLE silver.crm_cust_info;
PRINT '>> Inserting Data into silver.crm_cust_info';
INSERT INTO silver.crm_cust_info(

cst_id,
cst_key,
cst_firstname,
cst_lastname,
cst_marital_status,
cst_gndr,
cst_create_date
)
SELECT 
cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,
CASE WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
     WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
     ELSE 'N/A'
     END cst_marital_status,
CASE WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
     WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
     ELSE 'N/A'
     END cst_gndr,
cst_create_date
FROM bronze.crm_cust_info
SET @end_time = GETDATE();
PRINT'Duration:  ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(50)) + ' seconds';
PRINT'-------------------------------------------------'


SET @start_time = GETDATE();
PRINT '>> Truncating Table: silver.crm_prd_info';
TRUNCATE TABLE silver.crm_prd_info;
PRINT '>> Inserting Data into silver.crm_prd_info';
INSERT INTO silver.crm_prd_info(
prd_id,
prd_key,
cat_id,
prd_nm,
prd_cost,
prd_line,
prd_start_dt,
prd_end_dt
)
SELECT 
prd_id,
REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
prd_nm,
ISNULL(prd_cost, 0) AS prd_cost,
CASE WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
	 WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
	 WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Standard'
	 ELSE 'N/A' END AS prd_line,-- Standardize product line values and handle unexpected values
CAST(prd_start_dt AS DATE) AS prd_start_dt,
CAST(
    LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - 1
    AS DATE
) AS prd_end_dt --Calculate end date as one day before the next start date for the same product key
FROM bronze.crm_prd_info
SET @end_time = GETDATE();
PRINT'Duration:  ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(50)) + ' seconds';
PRINT'-------------------------------------------------'


SET @start_time = GETDATE();
PRINT '>> Truncating Table: silver.crm_sales_detals';
TRUNCATE TABLE silver.crm_sales_detals;
PRINT '>> Inserting Data into silver.crm_sales_detals';
INSERT INTO silver.crm_sales_detals(
sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_ord_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_qualtity,
sls_price
)
SELECT 
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    
    CASE 
        WHEN sls_ord_dt = 0 OR LEN(sls_ord_dt) != 8 THEN NULL
        WHEN TRY_CONVERT(DATE, CAST(sls_ord_dt AS VARCHAR)) > TRY_CONVERT(DATE, CAST(sls_due_dt AS VARCHAR)) THEN NULL
        ELSE TRY_CONVERT(DATE, CAST(sls_ord_dt AS VARCHAR))
    END AS sls_ord_dt, -- Validate order date and ensure it is not greater than ship date or due date, otherwise set to NULL

    -- Ship Date
    CASE 
        WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL 
        ELSE TRY_CONVERT(DATE, CAST(sls_ship_dt AS VARCHAR))
    END AS sls_ship_dt,-- Validate ship date and ensure it is in correct format, otherwise set to NULL

    -- Due Date
    CASE 
        WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL 
        ELSE TRY_CONVERT(DATE, CAST(sls_due_dt AS VARCHAR))
    END AS sls_due_dt,-- Validate due date and ensure it is in correct format, otherwise set to NULL

    CASE WHEN sls_price IS NOT NULL AND sls_price > 0
					AND (sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_qualtity * sls_price)
					THEN sls_qualtity * sls_price
				ELSE sls_sales
				END AS sls_sales,
    sls_qualtity,
    CASE WHEN sls_price IS NULL OR sls_price <= 0 
	THEN ABS(sls_sales) / NULLIF(sls_qualtity, 0)
	ELSE ABS(sls_price)
END AS sls_price -- Recalculate price based on sales and quantity if price is missing or invalid, otherwise take absolute value of price to ensure it's positive

FROM bronze.crm_sales_detals
SET @end_time = GETDATE();
PRINT'Duration:  ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(50)) + ' seconds';
PRINT'-------------------------------------------------'


PRINT'-------------------------------------------------'
PRINT'Loading ERP Tables'
PRINT'-------------------------------------------------'

SET @start_time = GETDATE();
PRINT '>> Truncating Table: silver.erp_cust_az12';
TRUNCATE TABLE silver.erp_cust_az12;
PRINT '>> Inserting Data into silver.erp_cust_az12';
INSERT INTO silver.erp_cust_az12(
cid,
bdate,
gender
)
SELECT
CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid)) --remove 'NAS' prefix from cid values
ELSE cid
END AS cid,
CASE WHEN bdate > GETDATE() THEN NULL
ELSE bdate
END AS bdate, --future birthdates are set to NULL
CASE WHEN UPPER(TRIM(gender)) IN ('F', 'FEMALE') THEN 'Female'
WHEN UPPER(TRIM(gender)) IN ('M', 'MALE') THEN 'Male'
ELSE 'N/A'
END AS gender--standardize gender values and handle unexpected values
FROM bronze.erp_cust_az12
SET @end_time = GETDATE();
PRINT'Duration:  ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(50)) + ' seconds';
PRINT'-------------------------------------------------'


SET @start_time = GETDATE();
PRINT '>> Truncating Table: silver.erp_loc_a101';
TRUNCATE TABLE silver.erp_loc_a101;
PRINT '>> Inserting Data into silver.erp_loc_a101';
INSERT INTO silver.erp_loc_a101(
cid, 
cntry
)
SELECT 
REPLACE(cid, '-', '') cid, -- remove dashes from cid values for consistency with other tables
CASE  WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
WHEN TRIM(cntry) IN ('GB', 'UK') THEN 'United Kingdom'
WHEN TRIM(cntry) ='JP' THEN 'Japan'
WHEN TRIM(cntry) ='DE' THEN 'Germany'
WHEN TRIM(cntry) ='FR' THEN 'France'
WHEN TRIM(cntry) ='AU' THEN 'Australia'
WHEN TRIM(cntry) ='CA' THEN 'Canada'
WHEN TRIM(cntry) ='CN' THEN 'China'
WHEN TRIM(cntry) ='ES' THEN 'Spain'
WHEN TRIM(cntry) ='IT' THEN 'Italy'
WHEN TRIM(cntry) ='IN' THEN 'India'
WHEN TRIM(cntry) ='BR' THEN 'Brazil'
WHEN TRIM(cntry) ='MX' THEN 'Mexico'
WHEN TRIM(cntry) ='ZA' THEN 'South Africa'
WHEN TRIM(cntry) ='KR' THEN 'South Korea'
WHEN TRIM(cntry) ='SE' THEN 'Sweden'
WHEN TRIM(cntry) ='NL' THEN 'Netherlands'
WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'N/A'
ELSE TRIM(cntry)
END AS cntry -- standardize country codes to full country names and handle unexpected values

FROM bronze.erp_loc_a101
SET @end_time = GETDATE();
PRINT'Duration:  ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(50)) + ' seconds';
PRINT'-------------------------------------------------';


SET @start_time = GETDATE();
PRINT '>> Truncating Table: silver.erp_px_cat_g1v2';
TRUNCATE TABLE silver.erp_px_cat_g1v2;
PRINT '>> Inserting Data into silver.erp_px_cat_g1v2';
INSERT INTO silver.erp_px_cat_g1v2(
id,
cat,
subcat,
maintainance
)
SELECT id,
cat,
subcat,
maintainance
FROM bronze.erp_px_cat_g1v2 -- No transformations needed for this table as the data is already clean and standardized
SET @end_time = GETDATE();
PRINT'Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(50)) + ' seconds';
PRINT'-------------------------------------------------';


SET @batch_end_time = GETDATE();
PRINT'================================================';
PRINT'Finished Loading Silver Layer';
PRINT'Total Duration:  ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR(50)) + ' seconds';
PRINT'================================================';
END TRY
BEGIN CATCH
PRINT'=================================================';
PRINT'Erro Occured While Loading Silver Layer';
PRINT'Error Message: ' + ERROR_MESSAGE();
PRINT'Error Message: ' + CAST(ERROR_NUMBER() AS NVARCHAR(50));
PRINT'Error Message: ' + CAST(ERROR_STATE() AS NVARCHAR(50));
PRINT'==================================================';
END CATCH
END




