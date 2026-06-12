# **Naming Conventions**
This document outlines the naming conventions used for schemas, tables, views, columns, and other objects in the data warehouse.

## **Table of Contents**
1. [General Principles](#general-principles)
2. [Table Naming Conventions](#table-naming-conventions)
   - [Bronze Rules](#bronze-rules)
   - [Silver Rules](#silver-rules)
   - [Gold Rules](#gold-rules)
3. [Column Naming Conventions](#column-naming-conventions)
   - [Surrogate Keys](#surrogate-keys)
   - [Technical Columns](#technical-columns)
4. [Stored Procedure Naming Conventions](#stored-procedure-naming-conventions)

---

## **General Principles**
- **Naming Convention**: Use snake_case, with lowercase letters and underscores (`_`) to separate words.
- **Language**: Use English for all names.
- **Avoid Reserved Words**: Do not use SQL reserved words as object names.

---

## **Table Naming Conventions**

### **Bronze Rules**
- All names must start with the source system name, and table names must match their original names without renaming.
- **`<sourcesystem>_<entity>`**
  - `<sourcesystem>`: Name of the source system (e.g., `crm`, `erp`).
  - `<entity>`: Exact table name from the source system.
  - Examples:
    - `crm_cust_info` → Customer information from the CRM system.
    - `crm_prd_info` → Product information from the CRM system.
    - `crm_sales_details` → Sales transaction data from the CRM system.
    - `erp_cust_az12` → Customer data from the ERP system.
    - `erp_loc_a101` → Location data from the ERP system.

### **Silver Rules**
- All names must start with the source system name, and table names must match their original names without renaming.
- **`<sourcesystem>_<entity>`**
  - `<sourcesystem>`: Name of the source system (e.g., `crm`, `erp`).
  - `<entity>`: Exact table name from the source system.
  - Examples:
    - `crm_cust_info` → Cleaned customer information from the CRM system.
    - `crm_prd_info` → Cleaned product information from the CRM system.
    - `crm_sales_details` → Cleaned sales transaction data from the CRM system.

### **Gold Rules**
- All names must use meaningful, business-aligned names for tables, starting with the category prefix.
- **`<category>_<entity>`**
  - `<category>`: Describes the role of the table, such as `dim` (dimension) or `fact` (fact table).
  - `<entity>`: Descriptive name of the table, aligned with the business domain (e.g., `customers`, `products`, `sales`).
  - Examples:
    - `dim_customers` → Dimension table for customer data.
    - `dim_products` → Dimension table for product data.
    - `fact_sales` → Fact table containing sales transactions.

#### **Glossary of Category Patterns**

| Pattern | Meaning | Example(s) |
|---|---|---|
| `dim_` | Dimension table | `dim_customers`, `dim_products` |
| `fact_` | Fact table | `fact_sales` |

---

## **Column Naming Conventions**

### **Surrogate Keys**
- All primary keys in dimension tables must use the suffix `_key`.
- **`<table_name>_key`**
  - `<table_name>`: Refers to the name of the table or entity the key belongs to.
  - `_key`: A suffix indicating that this column is a surrogate key.
  - Examples:
    - `customer_key` → Surrogate key in the `dim_customers` table.
    - `product_key` → Surrogate key in the `dim_products` table.

### **Technical Columns**
- All technical columns must start with the prefix `dwh_`, followed by a descriptive name indicating the column's purpose.
- **`dwh_<column_name>`**
  - `dwh`: Prefix exclusively for system-generated metadata.
  - `<column_name>`: Descriptive name indicating the column's purpose.
  - Example:
    - `dwh_create_date` → System-generated column used to store the date when the record was loaded into the warehouse.

### **Bronze & Silver Column Prefixes**
- Columns in bronze and silver tables use a short table-specific prefix to make joins easier to read and to identify the source table at a glance.
- **`<prefix>_<column_description>`**

| Prefix | Table | Example |
|---|---|---|
| `cst_` | Customer tables | `cst_id`, `cst_firstname`, `cst_gndr` |
| `prd_` | Product tables | `prd_id`, `prd_key`, `prd_nm`, `prd_cost` |
| `sls_` | Sales tables | `sls_ord_num`, `sls_prd_key`, `sls_ord_dt` |
| `cat_` | Category-derived columns | `cat_id` |

### **Gold Layer Column Names**
- Gold layer columns use full descriptive names without prefixes for business readability.
- Example:
  - `first_name`, `last_name`, `country`, `order_date`, `sales_amount`, `product_line`

---

## **Stored Procedure Naming Conventions**
- All stored procedures used for loading data must follow the naming pattern:
- **`load_<layer>`**
  - `<layer>`: Represents the layer being loaded, such as `bronze`, `silver`, or `gold`.
  - Examples:
    - `load_bronze` → Stored procedure for loading data into the Bronze layer.
    - `load_silver` → Stored procedure for loading data into the Silver layer.
    - `load_gold` → Stored procedure for loading data into the Gold layer.
