/*
============================================================
Stored Procedure: Load Bronze Layer From Sources to Bronze
============================================================
Script Purpose: 
- This stored procedure is designed to load data into the 'bronze' layer of a data warehouse.
- The 'bronze' layer typically contains raw, unprocessed data that has been ingested from various sources.
- It performs the following steps:
- Truncates existing data from the target tables in the 'bronze' schema to ensure that only fresh data is loaded.
- Uses BULK INSERT command to load data from CSV files located on the local file system into the respective tables in the 'bronze' schema.
 
 Parameters: The procedure does not take any parameters. It is designed to be executed as a standalone process to refresh the data in the 'bronze' layer.

 Usage Example:
EXEC bronze.load_bronze;
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
BEGIN TRY
	
SET @batch_start_time = GETDATE();
PRINT'================================';
PRINT'Loading Bronze Layer'
PRINT'================================';


PRINT'--------------------------------';
PRINT'Loading CRM Tables'
PRINT'--------------------------------';

SET @start_time = GETDATE();
PRINT'>>Truncating table: bronze.crm_cust_info';
TRUNCATE TABLE bronze.crm_cust_info;

SET @start_time = GETDATE();
PRINT'>>Inserting Data Into: bronze.crm_cust_info';
BULK INSERT bronze.crm_cust_info
FROM 'C:\Users\Administrator\Downloads\Data Warehp\source_crm\cust_info.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '0x0a',
	TABLOCK
);
SET @end_time = GETDATE();
PRINT 'Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(50)) + ' seconds';
PRINT'--------------------------------';


SET @start_time = GETDATE();
PRINT'>>Truncating table: bronze.crm_prd_info';
TRUNCATE TABLE bronze.crm_prd_info;

PRINT'>>Inserting Data Into: bronze.crm_prd_info';
BULK INSERT bronze.crm_prd_info
FROM 'C:\Users\Administrator\Downloads\Data Warehp\source_crm\prd_info.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '0x0a',
	TABLOCK
);
SET @end_time = GETDATE();
PRINT 'Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(50)) + ' seconds';
PRINT'--------------------------------';

SET @start_time = GETDATE();
PRINT'>>Truncating table: bronze.crm_sales_detals';
TRUNCATE TABLE bronze.crm_sales_detals

PRINT'>>Inserting Data Into: bronze.crm_sales_detals';
BULK INSERT bronze.crm_sales_detals
FROM 'C:\Users\Administrator\Downloads\Data Warehp\source_crm\sales_details.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '0x0a',
	TABLOCK
);
SET @end_time = GETDATE();
PRINT 'Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(50)) + ' seconds';
PRINT'--------------------------------';


PRINT'--------------------------------'
PRINT'Loading ERP Tables'
PRINT'--------------------------------'

SET @start_time = GETDATE();
PRINT'>>Truncating table: bronze.erp_loc_a101';
TRUNCATE TABLE bronze.erp_loc_a101

PRINT'>>Inserting Data Into: bronze.erp_loc_a101';
BULK INSERT bronze.erp_loc_a101
FROM 'C:\Users\Administrator\Downloads\Data Warehp\source_erp\loc_a101.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '0x0a',
	TABLOCK
);
SET @end_time = GETDATE();
PRINT 'Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(50)) + ' seconds';
PRINT'--------------------------------';



SET @start_time = GETDATE();
PRINT'>>Truncating table: bronze.erp_cust_az12';
TRUNCATE TABLE bronze.erp_cust_az12

PRINT'>>Inserting Data Into: bronze.erp_cust_az12';
BULK INSERT bronze.erp_cust_az12
FROM 'C:\Users\Administrator\Downloads\Data Warehp\source_erp\cust_az12.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '0x0a',
	TABLOCK
);
SET @end_time = GETDATE();
PRINT 'Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(50)) + ' seconds';
PRINT'--------------------------------';



SET @start_time = GETDATE();
PRINT'>>Truncating table: bronze.erp_px_cat_g1v2';
TRUNCATE TABLE bronze.erp_px_cat_g1v2

PRINT'>>Inserting Data Into: bronze.erp_px_cat_g1v2';
BULK INSERT bronze.erp_px_cat_g1v2
FROM 'C:\Users\Administrator\Downloads\Data Warehp\source_erp\px_cat_g1v2.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '0x0a',
	TABLOCK
);
SET @end_time = GETDATE();
PRINT 'Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(50)) + ' seconds';
PRINT'--------------------------------';

SET @batch_end_time = GETDATE();
PRINT'================================';
PRINT'Finished Loading Bronze Layer'
PRINT'Batch Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR(50)) + ' seconds';
PRINT'================================';
END TRY
BEGIN CATCH 
PRINT'================================';
PRINT'Error Occured While Loading Bronze Layer'
PRINT'Error Massage: ' + ERROR_MESSAGE();
PRINT'Error Messgae:' + CAST(ERROR_NUMBER() AS NVARCHAR(50));
PRINT'Error Message:' + CAST(ERROR_STATE() AS NVARCHAR(50));
PRINT'===============================';
END CATCH
END
