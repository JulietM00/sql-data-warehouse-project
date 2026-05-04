/*
==================================================================
Create Database and Schemas
==================================================================
Script Purpose:
- This script creates a new database named 'DataWarehouse' and sets up three schemas within it: 'bronze', 'silver', and 'gold'. 
- These schemas are typically used in data warehousing to organize data based on its level of processing and quality.
- The 'bronze' schema is often used for raw, unprocessed data, the 'silver' schema for cleaned and transformed data, and the 'gold' schema for highly curated and optimized data ready for analysis.

WARNING:
- Ensure that you have the necessary permissions to create databases and schemas on the SQL Server instance.
- If the 'DataWarehouse' database already exists, this script will fail. You may want to check for its existence before running the script or modify it to drop the database if it exists.
- You will need to drop the database if you want to run this script multiple times, as it does not include a check for existing databases or schemas.
*/


--For if you to check and drop the database if it already exists, you can use the following code before creating the database:

IF EXISTS(SELECT name FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
    END;
    GO


-- Create database named 'DataWarehouse;
USE master;
GO

CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
