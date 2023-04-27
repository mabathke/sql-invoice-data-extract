GO
-- This SQL script analyzes a data dump of a shutter repair company to identify the items and services that are most essential for the business. The goal was to gain insight into the schema 
-- of the database tables and identify relevant data for analysis. The script and resulting queries have been shared without any personal information to protect data privacy. I hope that 
-- others may find these queries useful for their own analysis. Once the relevant tables were identified, they were imported into Power BI for further analysis.

-- NEEDED FOR ADRESSES/Customer Info, etc. (May not be needed at all)
-- SELECT *
-- FROM [dbo].ADDRESS
-- SELECT *v
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
-- SELECT DOCUMENTNUMBER,TOTALAMOUNT, TOPNO, VATRATE, GRANDTOTAL
-- FROM [dbo].DOCUMENTFOOT
-- SELECT DOCUMENTNUMBER, CITY01, POSTALCODE1, DOCUMENTDATE, NAME21, REFERENCE
-- FROM [dbo].DOCUMENTHEAD

-- create a new table and store every valuable information of DOCUMENTFOOT and DOCUMENTHEAD in it<
CREATE TABLE invoice_information(
 	DOCUMENTNUMBER varchar(255),
	TOTALAMOUNT decimal(38,10),
	INVOICETYPE varchar(255),
	VATRATE decimal(38,10),
	TOTALAMOUNTAFTERVAT decimal(38,10),
	CITY varchar(255),
	POSTALCODE varchar(20),
	INVOICEDATE varchar(255),
	RECEIVER varchar(255),
	REFERENCE varchar(4000),
 	PRIMARY KEY (DOCUMENTNUMBER)
	)

 INSERT INTO dbo.invoice_information(DOCUMENTNUMBER,TOTALAMOUNT,INVOICETYPE,VATRATE,TOTALAMOUNTAFTERVAT,CITY,POSTALCODE,INVOICEDATE,RECEIVER,REFERENCE)
 SELECT 
	[dbo].DOCUMENTFOOT.DOCUMENTNUMBER, 
	TOTALAMOUNT, 
	TOPNO, 
	VATRATE,
	GRANDTOTAL, 
	CITY01,
	POSTALCODE1,
	DOCUMENTDATE,
	NAME21,
	REFERENCE
 FROM [dbo].DOCUMENTFOOT, [dbo].DOCUMENTHEAD
 WHERE [dbo].DOCUMENTFOOT.DOCUMENTNUMBER = [dbo].DOCUMENTHEAD.DOCUMENTNUMBER
 AND [dbo].DOCUMENTFOOT.DOCUMENTNUMBER LIKE '%-RE'
-- Overdue notice -> Can give insight about "bad customers"
-- SELECT *
-- FROM [dbo].THIRDPARTYDOCUMENTS

-- Create new table that holds information about the reminders sent to each customer
 CREATE TABLE reminder(
	DOCUMENTNUMBER varchar(20),
	CREATIONDATE varchar(8),
	DESCRIPTION varchar(2000),
	PERSONNO varchar(40),
	PRIMARY KEY (DOCUMENTNUMBER)
 )

 INSERT INTO [dbo].reminder
 SELECT DOCUMENTNUMBER, CREATIONDATE, DESCRIPTION, U_PERSONNO
 FROM [dbo].THIRDPARTYDOCUMENTS
 WHERE DESCRIPTION LIKE '%Mahnung%'

-- next there will be a new table that holds the "worst customer" which means the customer that recieved the most reminders
 CREATE TABLE worstCustomer(
	PERSON varchar(40),
	COUNTREMINDER int,
	PRIMARY KEY (PERSON)
 )

 INSERT INTO worstCustomer
 SELECT PERSONNO, COUNT(*)
 FROM [dbo].reminder
 GROUP BY PERSONNO
 ORDER BY COUNT(*) DESC
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
-- FROM dbo.GOODSELLINGDAYBOOK

-- After doing some dashboarding I noticed that some names for the items / services are just some cryptic strings. So I took a look at the actual (physical) invoices a
-- and filtered the top 4. After getting some insights from the person writing the invoices it seems that are the only 4 products that are actively sold from those 
-- with the cryptic names.

 UPDATE [dbo].GOODSELLINGDAYBOOK
 SET MATERIALNO = 'ROMA P-Strang Alu Motor '
 WHERE MATERIALNO LIKE '%2952a494%' 

 UPDATE [dbo].GOODSELLINGDAYBOOK
 SET MATERIALNO = 'ROMA P-Strang Kunststoff Gurt'
 WHERE MATERIALNO LIKE '%6aa5e4ef%'

 UPDATE [dbo].GOODSELLINGDAYBOOK
 SET MATERIALNO = 'ROMA P-Strang Alu Gurt'
 WHERE MATERIALNO LIKE '%06f2f87%'

 UPDATE [dbo].GOODSELLINGDAYBOOK
 SET MATERIALNO = 'ROMA P-Strang Kunststoff Motor'
 WHERE MATERIALNO LIKE '%a17e44d3%'
-- This completes the Process of finding the information needed for the analyzation so far. The next steps will be done in Power BI to find valuable informations

GO
