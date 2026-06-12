# Data Dictionary for the Gold Layer

# Overview
The Gold Layer is the business-level data representation of the data warehouse, structured to support analytical and reporting use cases. It consists of dimension tables and fact tables that model specific business metrics.

All data in the Gold Layer has been cleaned, transformed, and enriched through the Bronze and Silver layers before arriving here. This layer is the primary source for dashboards, reports, and business intelligence tools.

## [1. gold.dim_customers](scripts/gold)
- Purpose: Stores customer details with demographic and geographic data.
- Columns:

| Column Name | Data Type | Description |
|---|---|---|
| customer_key | INT | Unique surrogate key identifier for each customer. Primary key for this table. |
| customer_id | INT | Unique numerical identifier assigned to each customer. |
| customer_number | NVARCHAR(50) | Alphanumeric identifier representing the customer, used for tracking and refrence. |
| first_name | NVARCHAR(50) | Customer first name. |
| last_name | NVARCHAR(50) | Customer last name. |
| country | NVARCHAR(50) | The country the customer reside in (e.g. 'South Africa'). |
| marital status | NVARCHAR(50) | Marital status for the customer (e.g. 'Single', 'Married'). |
| gender| NVARCHAR(50) | Gender of the customer (e.g. 'Male', 'Female', 'N/A'). |
| birthdate | DATE | Date of birth of the customer as YYYY-MM-DD (1974-04-15). |
|create_date | DATE | Date when the customer record was created in the system. |
## Notes
- marital_status is derived from raw codes: S → Single, M → Married, anything else → N/A.
- gender is derived from raw codes: F → Female, M → Male, anything else → N/A.
- Duplicate customer records are handled using ROW_NUMBER() in the silver layer, keeping the most recent record per customer_id.
---
## [2. gold.dim_products](scripts/gold)

- Purpose: Provides information about products and their attributes.
- Columns:

| Column Name | Data Type | Description |
|---|---|---|
| product_key | INT | Unique surrogate identifier for each product record. Primary key of this table. |
| product_id | INT | Unique identifier for each product record for internal tracking and refrencing. |
| product_number | NVARCHAR(50) | Structure alphanumeric code representing the product for inventory or categorization. |
|categor_id | NVARCHAR(50) | Unique identifier for the product's category. |
| category | NVARCHAR(50) Broader classification of the product (e.g. Bikes, Clothing) to group the items related to each. |
| subcategory | NVARCHAR(50) | Detailed classification of the product type within the catergory attribute. |
| maintainance | NVARCHAR(50) | Indicates whether the product requires maintaince ( 'Yes', 'No'). |
| cost | INT | Cost of the product, measure in monetary units. |
| product_line | NVARCHAR(50) | Specific product line to which the product belongs to (e.g. 'Road', 'Mountain', 'Standard'). |
| start_date | DATE | Date when the product became available for sale or use, stored in the system. |
## Notes 
- category_id is derived by extracting the first 5 characters of the original prd_key and replacing hyphens with underscores.
- product_line is standardized from raw codes: M → Mountain, R → Road, S → Standard, anything else → N/A.
- cost null values are defaulted to 0 to avoid calculation errors in reporting.
---
## [3. gold.fact_sales](scripts/gold)
- Purpose: Stores transactional sales data for analytical purposes. Central fact table in the star schema, linked to both the customer and product dimension tables via surrogate keys.
- Columns:

|Column Name | Data Type | Description |
|---|---|---|
| order number | NVARCHAR(50) | Unique alphanumeric identifier for each sales order (e.g. 'SO208516'). |
| product_key | INT | Surrogate key linking order to the product dimension table. |
| customer_key | INT | Surrogate key linking order to the customer dimension table. |
| order_date | DATE | Date when the order date was placed, stored in the system. |
| shipment_date | DATE | Date when the order was/is shipped to the customer. |
| due_date | DATE | Date when the order payment is due. |
| sales_amount | INT | Total monetary value of the sale for the line product/item, in currency unit (e.g. 34). |
| quantity | Number of products in units ordered for the line (e.g. 2). |
| price | Price per unit of the product ordered for the line item, in currency units (e.g. 325). |
## Notes
- order_date is validated to ensure it is never greater than due_date. Invalid dates are set to NULL.
- product_key and customer_key are surrogate keys generated in the gold layer and must always reference valid records in gold.dim_products and gold.dim_customers respectively.
