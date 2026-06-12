/*
==============================================================
DDL Script: Create Views for Gold Layer in Data Warehouse
==============================================================
Purpose:
This script creates views in the 'gold' schema for a data warehouse. 
The views are designed to provide a dimensional model for customers and products, as well as a fact table for sales (Star Schema).
The views integrate data from the 'silver' schema, which contains cleaned and transformed data from the CRM and ERP systems.
 each view is created with the necessary joins and transformations to ensure data consistency and integrity to producea clean and business-ready dataset for analysis and reporting.

 Usage:
 These views can be used in reporting tools, dashboards, and for ad-hoc analysis to gain insights into customer behavior, product performance, and sales trends.
*/



-- Create dimension: gold.dim_customers 
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
 DROP VIEW gold.dim_customers;
GO
CREATE VIEW gold.dim_customers AS 
SELECT 
ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
ci.cst_id AS customer_id,
ci.cst_key AS customer_number,
ci.cst_firstname AS first_name,
ci.cst_lastname AS last_name,
cl.cntry AS country,
ci.cst_marital_status AS marital_status,
CASE WHEN ci.cst_gndr != 'N/A' THEN ci.cst_gndr  -- CRM is the master table for gender info
ELSE COALESCE(ca.gender, 'N/A') 
END AS gender,
ca.bdate AS birthdate,
ci.cst_create_date AS create_date
FROM  silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 cl
ON ci.cst_key = cl.cid
 
GO
  
-- Create dimension: gold.dim_products
CREATE VIEW gold.dim_products AS
SELECT
ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,
pn.prd_id AS product_id,
pn.prd_key AS product_number,
pn.prd_nm AS product_name,
pn.cat_id AS category_id,
pc.cat AS category,
pc.subcat AS subcategory,
pc.maintainance,
pn.prd_cost AS cost,
pn.prd_line AS product_line,
pn.prd_start_dt AS start_date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pn.cat_id = pc.id
WHERE prd_end_dt IS NULL --Filter ot all historical data

GO

-- Create fact table: gold.fact_sales
CREATE VIEW gold.fact_sales AS
SELECT
sd.sls_ord_num AS order_number,
pr.product_key,
c.customer_id,
sd.sls_ord_dt AS order_date,
sd.sls_ship_dt AS shipment_date,
sd.sls_due_dt AS due_date,
sd.sls_sales AS sales_amount,
sd.sls_qualtity AS quantity,
sd.sls_price AS price
FROM silver.crm_sales_detals sd
LEFT JOIN gold.dim_products pr
ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers c
ON sd.sls_cust_id = c.customer_id  

GO
