# Data Dictionary for the Gold Layer
# Overview
The Gold Layer is a business_level data representation, structured to support analytical and reporting use cases. It consists of 'dimension tables' and 'fact tables' for specific business metircs.

## 2. gold.dim_customers
- Purpose: Stores customer details with demographic and geagraphic data.
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

---
## 1. gold.dim_products

- Purpose: Provides information about the products their attributes
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

---
## 3. gold.fact_sales
- Purpose: Store transactional sales data analytical purposes.
- Columns:

|Column Name | Data Type | Description |
|---|---|---|
| order number | NVARCHAR(50) | Unique alphanumeric identifier for each sales order (e.g. 'SO208516'). |
| product_key | INT | Surrogate key linking order to the product dimension table. |
| customer_key | INT | Surrogate key linking order to the customer dimension table. |
|
## Column Descriptions

| Column Name | Data Type | Description |
|---|---|---|
| `product_id` | INT | Unique surrogate identifier for each product record. Primary key of this table. | 
| `product_number` | VARCHAR(50) | The original product number sourced from the CRM system. Used to trace back to source systems. | 
| `product_name` | VARCHAR(50) | Full descriptive name of the product. Cleaned and trimmed from source data. | 
| `category_id` | VARCHAR(50) | Identifier for the product category. Derived by extracting and transforming the first segment of the original product key. | 
| `category` | VARCHAR(50) | High level grouping of the product. Sourced from the ERP product category table. | 
| `subcategory` | VARCHAR(50) | More granular grouping under the main category. Sourced from the ERP product category table. | 
| `maintainance` | VARCHAR(50) | Indicates whether the product requires maintenance. Sourced from ERP system. | 
| `cost` | DECIMAL | The standard cost of the product. Null values have been defaulted to 0 during silver layer cleaning. | 
| `product_line` | VARCHAR(50) | The product line the product belongs to. Standardized from single character codes during silver layer transformation. |
| `start_date` | DATE | The date the product became active. Derived from the product start date in the source system. |

---

## Notes

- This table is built in the **gold layer** and should not be modified directly.
- All transformations and cleaning are handled in the **silver layer** stored procedures.
- `category_id` is derived from the first 5 characters of the original `prd_key` column in the bronze layer, with hyphens replaced by underscores.
- `product_line` values are standardized from raw codes: `M` → `Mountain`, `R` → `Road`, `S` → `Standard`, anything else → `N/A`.
- `cost` null values are defaulted to `0` to avoid calculation errors in reporting.
- `start_date` reflects the product activation date and is used alongside historical records to track product changes over time.

---

## Relationships

| Related Table | Join Key | Relationship |
|---|---|---|
| `gold.fact_sales` | `product_id` | One-to-Many |
| `gold.dim_categories` | `category_id` | Many-to-One |

---

## Source Tables

| Layer | Table Name |
|---|---|
| Bronze | `bronze.crm_prd_info` |
| Silver | `silver.crm_prd_info` |
