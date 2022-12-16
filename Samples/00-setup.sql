-- 00-Setup.SQL
-- Use this script to setup our Synapse SQL Serverless Logical Data Warehouse (LDW)

-- Create our Logical Data Warehouse: ContosoLDW
IF EXISTS (
	SELECT DB_ID('ContosoLDW')
)
BEGIN
	DROP DATABASE ContosoLDW
END

CREATE DATABASE ContosoLDW
GO

USE ContosoLDW
GO

-- Create an external data source
-- LOCATION: Provide Azure storage account name and blob container name.
-- CREDENTIAL: Provide the credential created in the previous step.

CREATE EXTERNAL DATA SOURCE AzureStorage_west_public
WITH 
(  
    LOCATION = 'wasbs://contosoretaildw-tables@contosoretaildw.blob.core.windows.net/'
); 
GO

-- The data is stored in text files in Azure blob storage, and each field is separated with a delimiter. 
-- Run this [CREATE EXTERNAL FILE FORMAT][] command to specify the format of the data in the text files. 
-- The Contoso data is uncompressed and pipe delimited.

CREATE EXTERNAL FILE FORMAT TextFileFormat 
WITH 
(   FORMAT_TYPE = DELIMITEDTEXT
,	FORMAT_OPTIONS	(   FIELD_TERMINATOR = '|'
					,	STRING_DELIMITER = ''
					,	USE_TYPE_DEFAULT = FALSE 
					)
);
GO

-- To create a place to store the Contoso data in your database, create a schema.

CREATE SCHEMA [asb];
GO
