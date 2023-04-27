
GO
-- In this SQL Script a data dump of a craftsman company that repairs shutters is analyzed. The goal was to highlight those items/services which are most esential for the company
-- I only provide my sql script and the results without any personal information because of data privacy. May be someone finds this useful and can use some of the queries I used :), 
-- Since I just got a dump of the database from the software that the company uses to write invoices to customers, I just ran some queries on the data to get insight about the schema of the tables
-- and kept those that seem to be relevant. The newly creaded tables and the tables that could be used are then imported into Power BI. Since these 

-- NEEDED FOR ADRESSES/Customer Info, etc. (May not all be needed)
-- SELECT *
-- FROM [dbo].ADDRESS
-- SELECT *
-- FROM [dbo].CUSTOMER
-- SELECT *
-- FROM [dbo].CUSTOMERSYSTEM

-- Could be useful for getting document numbers and filter for RE (Bills)
-- SELECT *
-- FROM [dbo].DOCFAVO

-- Actual document / can filter the total amount of a bill and filter the adress / "gemeinde" !merge those two and filter the columns 
-- SELECT *
-- FROM [dbo].DOCUMENTFOOT
-- SELECT *
-- FROM [dbo].DOCUMENTHEAD

-- All columns I need for further analysis from DOCUMENTFOOT and DOCUMENTHEAD
-- SELECT DOCUMENTNUMBER,GRANDTOTAL, TOPNO, VATRATE, GRANDTOTAL + (GRANDTOTAL * (VATRATE/100)) AS 'GRANDTOTALVAT'
-- FROM [dbo].DOCUMENTFOOT
-- SELECT DOCUMENTNUMBER, CITY01, POSTALCODE1, DOCUMENTDATE, NAME21, REFERENCE
-- FROM [dbo].DOCUMENTHEAD

-- create a new table and store every valuable information of DOCUMENTFOOT and DOCUMENTHEAD in it<
--CREATE TABLE invoice_information(
-- 	DOCUMENTNUMBER varchar(255),
--	TOTALAMOUNT decimal(38,10),
--	INVOICETYPE varchar(255),
--	VATRATE decimal(38,10),
--	TOTALAMOUNTAFTERVAT decimal(38,10),
--	CITY varchar(255),
--	POSTALCODE varchar(20),
--	INVOICEDATE varchar(255),
--	RECEIVER varchar(255),
--	REFERENCE varchar(4000),
-- 	PRIMARY KEY (DOCUMENTNUMBER)
--	)ARY KEY (DOCUMENTNUMBER)
--	)

-- INSERT INTO dbo.invoice_information(DOCUMENTNUMBER,TOTALAMOUNT,INVOICETYPE,VATRATE,TOTALAMOUNTAFTERVAT,CITY,POSTALCODE,INVOICEDATE,RECEIVER,REFERENCE)
-- SELECT 
--	[dbo].DOCUMENTFOOT.DOCUMENTNUMBER, 
--	GRANDTOTAL, 
--	TOPNO, 
--	VATRATE,
--	GRANDTOTAL + (GRANDTOTAL * (VATRATE/100)) as 'GRANDTOTALVAT', 
--	CITY01,
--	POSTALCODE1,
--	DOCUMENTDATE,
--	NAME21,
--	REFERENCE
-- FROM [dbo].DOCUMENTFOOT, [dbo].DOCUMENTHEAD
-- WHERE [dbo].DOCUMENTFOOT.DOCUMENTNUMBER = [dbo].DOCUMENTHEAD.DOCUMENTNUMBER
-- AND [dbo].DOCUMENTFOOT.DOCUMENTNUMBER LIKE '%-RE'
-- Overdue notice -> Can give insight about "bad customers"
-- SELECT * 
-- FROM [dbo].THIRDPARTYDOCUMENTS

-- The above queries delivers basic information of the invoices, but no insight about the items/services that are billed in these invoices.
-- To find the table which stores the wanted information I used this query to filter for table that has the Column "DOCUMENTNUMBER". 
-- Then I just looked at the TableNames to find the table that is likely to store infomartion about billed times/services.

-- SELECT col.name AS 'ColumnName',
-- tab.name AS 'TableName'
-- FROM sys.columns col
-- JOIN sys.tables tab ON col.object_id =
-- tab.object_id
-- WHERE col.name = 'DOCUMENTNUMBER'
-- ORDER BY TableName, ColumnName

-- Information about items/services that are billed. 
-- SELECT * 
-- FROM dbo.GOODSELLINGDAYBOOK-- This completes the Process of finding the information needed for the analyzation so far. The next steps will be done in Power BI to find valuable informations-- SELECT * 
-- FROM dbo.GOODSELLINGDAYBOOK
-- WHERE MATERIALNO LIKE '%Rolladen aus Kunst%'

GO


