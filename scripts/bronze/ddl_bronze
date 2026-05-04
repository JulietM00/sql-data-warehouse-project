/*
========================================================================================
DDL Script: Create Tables for CRM and ERP Systems in 'bronze' Schema
========================================================================================

This script creates the necessary tables in the 'bronze' schema for a CRM and ERP system.
It includes tables for customer information, product information, sales details, location data, product categories, and customer demographics.
Each table is defined with appropriate columns and data types to store relevant information for the CRM and ERP processes.

*/
IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_cust_info;
GO
CREATE TABLE  bronze.crm_cust_info(
cst_id INT,
cst_key NVARCHAR(50),
cst_firstname NVARCHAR(50),
cst_lastname NVARCHAR(50),
cst_marital_status NVARCHAR(50),
cst_gndr NVARCHAR(50),
cst_create_date DATE
);
GO

CREATE TABLE bronze.crm_prd_info(
prd_id INT,
prd_key NVARCHAR(50),
prd_nm NVARCHAR(50),
prd_cost INT,
prd_line NVARCHAR(50),
prd_start_dt DATETIME,
prd_end_dt DATETIME
);
GO


CREATE TABLE bronze.crm_sales_detals(
sls_ord_num NVARCHAR(50),
sls_prd_key NVARCHAR(50),
sls_cust_id INT,
sls_ord_dt INT,
sls_ship_dt INT,
sls_due_dt INT,
sls_sales INT,
sls_qualtity INT,
sls_price INT
);


CREATE TABLE bronze.erp_loc_a101(
cid NVARCHAR(50),
cntry NVARCHAR(50)
);
GO

CREATE TABLE bronze.erp_px_cat_g1v2(
id NVARCHAR(50),
cat NVARCHAR(50),
subcat NVARCHAR(50),
maintainance NVARCHAR(50)
);

CREATE TABLE bronze.erp_cust_az12(
cid NVARCHAR(50),
bdate DATE,
gender NVARCHAR(50)
);


