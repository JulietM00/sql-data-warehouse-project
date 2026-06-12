# 🏗️ SQL Data Warehouse Project

A full end-to-end data warehouse built from scratch using **SQL Server**, following the **Medallion Architecture** (Bronze → Silver → Gold). This project covers ETL pipeline development, data cleaning, data modeling, and business-ready reporting layers.

---

## 📌 Project Overview

The goal of this project is to build a modern data warehouse that consolidates sales data from **ERP** and **CRM** source systems, ensuring data quality and enabling data-driven decision-making through analytics and reporting.

The warehouse integrates data across three key business domains:
- 👤 **Customer Information** — demographic and geographic data
- 📦 **Product Information** — product attributes, categories, and classifications
- 💰 **Sales Transactions** — order details, shipment, pricing, and quantities

---

## 🏛️ Data Architecture

This project follows the **Medallion Architecture** with three layers:

```
📂 Bronze Layer  →  Raw data ingested as-is from CSV source files
        ↓
📂 Silver Layer  →  Cleaned, standardized, and transformed data
        ↓
📂 Gold Layer    →  Business-ready star schema for reporting and analytics
```

### Bronze Layer
- Stores raw data exactly as it comes from the source systems
- No transformations applied
- Acts as the single source of truth for all raw data
- Tables: `bronze.crm_cust_info`, `bronze.crm_prd_info`, `bronze.crm_sales_details`, `bronze.erp_cust_az12`, `bronze.erp_loc_a101`

### Silver Layer
- Data is cleaned, standardized, and normalized
- Key transformations include:
  - Trimming whitespace from string columns
  - Standardizing categorical codes (e.g. `M` → `Married`, `F` → `Female`)
  - Handling null values (e.g. defaulting null costs to `0`)
  - Fixing invalid date values using `TRY_CONVERT`
  - Removing duplicate records using `ROW_NUMBER()`
  - Splitting product keys into `prd_key` and `cat_id` for better readability
  - Calculating product end dates using `LEAD()` window function

### Gold Layer
- Business-ready data modeled into a **Star Schema**
- Consists of dimension tables and a central fact table
- Optimized for analytical queries and reporting

---

## ⭐ Star Schema

```
                    gold.dim_customers
                           |
                           | customer_key
                           |
gold.dim_products ——— gold.fact_sales
    product_key               |
                              |
                         order_number
```

| Table | Type | Description |
|---|---|---|
| `gold.dim_customers` | Dimension | Customer demographic and geographic details |
| `gold.dim_products` | Dimension | Product attributes and classifications |
| `gold.fact_sales` | Fact | Transactional sales data |

---

## 🗂️ Repository Structure

```
sql-data-warehouse-project/
│
├── datasets/                   # Raw CSV source files
│   ├── crm_cust_info.csv
│   ├── crm_prd_info.csv
│   ├── crm_sales_details.csv
│   ├── erp_cust_az12.csv
│   └── erp_loc_a101.csv
│
├── scripts/
│   ├── bronze/                 # Scripts to load raw data into bronze layer
│   ├── silver/                 # Stored procedures for cleaning and transformation
│   └── gold/                   # Scripts to build dimension and fact tables
│
├── documents/
│   ├── data_dictionary.md      # Full data dictionary for the gold layer
│   └── data_catalog.md         # Data catalog for gold.dim_products
│
└── README.md
```

---

## 🔧 Tech Stack

| Tool | Purpose |
|---|---|
| **SQL Server** | Database engine for hosting the warehouse |
| **SSMS** | SQL Server Management Studio for development |
| **T-SQL** | Query language for ETL and transformations |
| **Git & GitHub** | Version control and collaboration |
| **DrawIO** | Data architecture and flow diagrams |
| **CSV Files** | Source data files for ingestion |

---

## 🚀 Getting Started

### Prerequisites
- SQL Server Express (or higher)
- SQL Server Management Studio (SSMS)
- Git

### Steps to Run

1. **Clone the repository**
```bash
git clone https://github.com/JulietM00/sql-data-warehouse-project.git
```

2. **Create the database**
```sql
CREATE DATABASE DataWarehouse;
```

3. **Load Bronze Layer** — Run scripts in `/scripts/bronze/` to ingest raw CSV data

4. **Load Silver Layer** — Run stored procedures in `/scripts/silver/` to clean and transform data

5. **Load Gold Layer** — Run scripts in `/scripts/gold/` to build the star schema

6. **Query the Gold Layer** — Start analysing using `gold.dim_customers`, `gold.dim_products`, and `gold.fact_sales`

---

## 📊 Key SQL Concepts Covered

- ✅ Stored Procedures for ETL automation
- ✅ Window Functions (`ROW_NUMBER()`, `LEAD()`)
- ✅ `TRY_CONVERT` for safe date casting
- ✅ `CASE` statements for data standardization
- ✅ Multi-table `JOIN`s for data enrichment
- ✅ Duplicate detection and removal
- ✅ Surrogate key generation
- ✅ Star Schema modeling

---

## 📖 Documentation

- 📄 [Data Dictionary](documents/data_dictionary.md) — Full column-level documentation for all gold layer tables
- 📄 [Data Catalog](documents/data_catalog.md) — Catalog for `gold.dim_products`
- 📄 [Naming Conventions](documents/naming_conventions.md) — Naming standards for tables, columns, and stored procedures

---

## 👩‍💻 Author

**Juliet M.**
- GitHub: [@JulietM00](https://github.com/JulietM00)

---

## 🙏 Acknowledgements

Special thanks to [Baraa Khatib Salkini](https://github.com/DataWithBaraa) from **Data With Baraa** for the inspiration, guidance, and best practices that shaped the foundation of this project.
