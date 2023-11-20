USE AdventureWorks2022


-------------------------------------------------------------------------------
-- Some basic queries
--------------------------------------------------------------------------------

-- View all from the Products Table

SELECT 
	*
FROM 
	Production.Product
ORDER BY 
	Name ASC;


-- View Product Number and ListPrice, Order By ListPrice
SELECT Name,
    ProductNumber,
    ListPrice AS Price
FROM 
	Production.Product
WHERE
	ListPrice > 0
ORDER BY 
	ListPrice ASC;


-- List the ProductNumber and ListPrice as Price of all Products in Line R that took less than 10 days to manufacture
SELECT Name,
    ProductNumber,
    ListPrice AS Price
FROM 
	Production.Product
WHERE 
	ProductLine = 'R'
    AND DaysToManufacture < 10
ORDER BY 
	Name ASC;

--------------------------------------------------------------------------------------------------------------
-- Joins
-------------------------------------------------------------------------------------------------------------

SELECT 
	p.Name AS ProductName,
    NonDiscountSales = (OrderQty * UnitPrice),
    Discounts = ((OrderQty * UnitPrice) * UnitPriceDiscount)
FROM 
	Production.Product AS p
LEFT JOIN 
	Sales.SalesOrderDetail AS sod ON p.ProductID = sod.ProductID
GROUP BY
	p.Name,
	OrderQty,
	UnitPriceDiscount,
	UnitPrice
HAVING 
	((OrderQty * UnitPrice) * UnitPriceDiscount) > 0
ORDER BY 
	ProductName DESC;

--------------------------------------------------------------------------------------------------------------------------
-- Using More Temp/Deleted Tables
--------------------------------------------------------------------------------------------------------------------------

IF OBJECT_ID('dbo.CheapProducts', 'U') IS NOT NULL
DROP TABLE dbo.CheapProducts;

ALTER DATABASE AdventureWorks2022 SET RECOVERY BULK_LOGGED;

SELECT *
--INTO dbo.AdditionalProducts
FROM 
	Production.Product
WHERE 
	ListPrice > $25
    AND ListPrice < $100;

ALTER DATABASE AdventureWorks2022 SET RECOVERY FULL;

IF OBJECT_ID('dbo.CheapProducts', 'U') IS NOT NULL
DROP TABLE dbo.CheapProducts;

----------------------------------------------------------------------------------
-- Sub-query examples
---------------------------------------------------------------------------------

SELECT 
	DISTINCT Name
FROM 
	Production.Product AS p
WHERE EXISTS (
    SELECT 
		*
    FROM 
		Production.ProductModel AS pm
    WHERE 
		p.ProductModelID = pm.ProductModelID
        AND Name LIKE 'Long-Sleeve Logo Jersey%'
);

-- OR

SELECT 
	DISTINCT Name
FROM 
	Production.Product AS p
WHERE 
	p.ProductModelID IN (
    SELECT 
		pm.ProductModelID
    FROM 
		Production.ProductModel AS pm
    WHERE 
		p.ProductModelID = pm.ProductModelID
        AND Name LIKE 'Long-Sleeve Logo Jersey%'
);


SELECT 
	p1.ProductModelID
FROM 
	Production.Product AS p1
GROUP BY 
	p1.ProductModelID
HAVING 
	MAX(p1.ListPrice) >= (
    SELECT 
		AVG(p2.ListPrice) * 2
    FROM 
		Production.Product AS p2
    WHERE 
		p1.ProductModelID = p2.ProductModelID
);


SELECT DISTINCT 
	pp.LastName,
    pp.FirstName
FROM 
	Person.Person pp
INNER JOIN 
	HumanResources.Employee e ON e.BusinessEntityID = pp.BusinessEntityID
WHERE 
	pp.BusinessEntityID IN (
    SELECT 
		SalesPersonID
    FROM 
		Sales.SalesOrderHeader
    WHERE 
		SalesOrderID IN (
        SELECT 
			SalesOrderID
        FROM 
			Sales.SalesOrderDetail
        WHERE 
			ProductID IN (
            SELECT 
				ProductID
            FROM 
				Production.Product p
            WHERE 
				ProductNumber = 'BK-M68B-42'
        )
    )
);


-------------------------------------------------------------------------------------
-- Aggregate Functions
-------------------------------------------------------------------------------------

SELECT 
	ProductID,
    AVG(OrderQty) AS AverageQuantity,
    SUM(LineTotal) AS Total
FROM 
	Sales.SalesOrderDetail
GROUP BY 
	ProductID
HAVING 
	SUM(LineTotal) > $1000000.00
    AND AVG(OrderQty) < 3;


-------------------------------------------------------------------------------------
-- More Joins
-------------------------------------------------------------------------------------

SELECT 
	pp.FirstName,
    pp.LastName,
    e.NationalIDNumber
FROM 
	HumanResources.Employee AS e WITH (INDEX (AK_Employee_NationalIDNumber))
INNER JOIN 
	Person.Person AS pp ON e.BusinessEntityID = pp.BusinessEntityID
WHERE 
	LastName = 'Johnson';

-- Or to force a table scan by using INDEX = 0, the engine is forced to scan using an index.

SELECT 
	pp.LastName,
    pp.FirstName,
    e.JobTitle
FROM 
	HumanResources.Employee AS e WITH (INDEX = 0)
INNER JOIN 
	Person.Person AS pp ON e.BusinessEntityID = pp.BusinessEntityID
WHERE 
	LastName = 'Johnson';


---------------------------------------------------------------------------------------------------
-- Union and Union All
---------------------------------------------------------------------------------------------------

SELECT 
	BusinessEntityID,
    JobTitle,
    HireDate,
    VacationHours,
    SickLeaveHours
FROM 
	HumanResources.Employee AS e1
WHERE
	e1.VacationHours BETWEEN 50 AND 100

UNION

SELECT 
	BusinessEntityID,
    JobTitle,
    HireDate,
    VacationHours,
    SickLeaveHours
FROM 
	HumanResources.Employee AS e2
WHERE
	e2.SickLeaveHours >= 50
	AND e2.SickLeaveHours <= 100
OPTION (MERGE UNION);


-----------------------------------------------------------------------------------------------------
-- UNION and Union All with Temp Tables Examples
-----------------------------------------------------------------------------------------------------

IF OBJECT_ID('dbo.EmployeeOne', 'U') IS NOT NULL
DROP TABLE dbo.EmployeeOne;

IF OBJECT_ID('dbo.EmployeeTwo', 'U') IS NOT NULL
DROP TABLE dbo.EmployeeTwo;

IF OBJECT_ID('dbo.EmployeeThree', 'U') IS NOT NULL
DROP TABLE dbo.EmployeeThree;

-- Creating tables
SELECT 
	pp.LastName, 
	pp.FirstName, 
	e.JobTitle
INTO dbo.EmployeeOne
FROM 
	Person.Person AS pp
INNER JOIN 
	HumanResources.Employee AS e ON e.BusinessEntityID = pp.BusinessEntityID
WHERE 
	LastName = 'Johnson';


SELECT 
	pp.LastName, 
	pp.FirstName, 
	e.JobTitle
INTO dbo.EmployeeTwo
FROM 
	Person.Person AS pp
INNER JOIN 
	HumanResources.Employee AS e ON e.BusinessEntityID = pp.BusinessEntityID
WHERE 
	LastName = 'Johnson';


SELECT 
	pp.LastName, 
	pp.FirstName, 
	e.JobTitle
INTO dbo.EmployeeThree
FROM 
	Person.Person AS pp
INNER JOIN 
	HumanResources.Employee AS e ON e.BusinessEntityID = pp.BusinessEntityID
WHERE 
	LastName = 'Johnson';


-- Union ALL
SELECT 
	LastName, 
	FirstName, 
	JobTitle
FROM 
	dbo.EmployeeOne

UNION ALL

SELECT 
	LastName, 
	FirstName, 
	JobTitle
FROM 
	dbo.EmployeeTwo

UNION ALL

SELECT 
	LastName, 
	FirstName, 
	JobTitle
FROM 
	dbo.EmployeeThree;

-- Union
SELECT 
	LastName, 
	FirstName, 
	JobTitle
FROM 
	dbo.EmployeeOne

UNION

SELECT 
	LastName, 
	FirstName, 
	JobTitle
FROM 
	dbo.EmployeeTwo

UNION

SELECT 
	LastName, 
	FirstName, 
	JobTitle
FROM 
	dbo.EmployeeThree;

SELECT 
	LastName, 
	FirstName, 
	JobTitle
FROM 
	dbo.EmployeeOne

-- Alternative Union/Union All
UNION ALL

(
    SELECT 
		LastName, 
		FirstName, 
		JobTitle
    FROM 
		dbo.EmployeeTwo

    UNION

    SELECT 
		LastName, 
		FirstName, 
		JobTitle
    FROM 
		dbo.EmployeeThree
);

-- Alternatively, apply Union While Creating the tables into EmployeeOne

SELECT 
	pp.LastName, 
	pp.FirstName, 
	e.JobTitle
INTO dbo.EmployeeOne
FROM 
	Person.Person AS pp
INNER JOIN 
	HumanResources.Employee AS e ON e.BusinessEntityID = pp.BusinessEntityID
WHERE 
	LastName = 'Johnson'

UNION

SELECT 
	pp.LastName, 
	pp.FirstName, 
	e.JobTitle
FROM 
	Person.Person AS pp
INNER JOIN 
	HumanResources.Employee AS e ON e.BusinessEntityID = pp.BusinessEntityID
WHERE 
	LastName = 'Johnson'

UNION

SELECT 
	pp.LastName, 
	pp.FirstName, 
	e.JobTitle
FROM 
	Person.Person AS pp
INNER JOIN 
	HumanResources.Employee AS e ON e.BusinessEntityID = pp.BusinessEntityID
WHERE 
	LastName = 'Johnson';


-- Drop the tables
IF OBJECT_ID('dbo.EmployeeOne', 'U') IS NOT NULL
DROP TABLE dbo.EmployeeOne;

IF OBJECT_ID('dbo.EmployeeTwo', 'U') IS NOT NULL
DROP TABLE dbo.EmployeeTwo;

IF OBJECT_ID('dbo.EmployeeThree', 'U') IS NOT NULL
DROP TABLE dbo.EmployeeThree;


-----------------------------------------------------------------------------------------------
-- UPDATE FUNCTION
-----------------------------------------------------------------------------------------------

IF OBJECT_ID ('dbo.Table1', 'U') IS NOT NULL  
    DROP TABLE dbo.Table1;  
 
IF OBJECT_ID ('dbo.Table2', 'U') IS NOT NULL  
    DROP TABLE dbo.Table2;  
 
CREATE TABLE dbo.Table1   
    (Col1 TINYINT NOT NULL, Col2 DECIMAL(3,2) NOT NULL);  
 
CREATE TABLE dbo.Table2   
    (Col1 TINYINT PRIMARY KEY NOT NULL, Col2 DECIMAL(3,2) NOT NULL);  

INSERT INTO dbo.Table1 VALUES(1, 10.0), (1, 20.0);  
INSERT INTO dbo.Table2 VALUES(1, 0.0);  

UPDATE dbo.Table2   
SET dbo.Table2.Col2 = dbo.Table2.Col2 + dbo.Table1.Col2 
FROM dbo.Table2   
    INNER JOIN dbo.Table1   
    ON (dbo.Table2.Col1 = dbo.Table1.Col1);  

SELECT Col1, Col2  
FROM dbo.Table2; 

-- Drop the tables

IF OBJECT_ID ('dbo.Table1', 'U') IS NOT NULL  
    DROP TABLE dbo.Table1;  
 
IF OBJECT_ID ('dbo.Table2', 'U') IS NOT NULL  
    DROP TABLE dbo.Table2;  


----------------------------------------------------------------------------------------
-- Some Questions From SQL Zoo
----------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------
-- Find the number of left racing socks ('Racing Socks, L') ordered by CompanyName 'Riding Cycles'
---------------------------------------------------------------------------------------------------------------

SELECT
	SUM(sod.orderqty)
FROM
	Production.Product p
INNER JOIN
	Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
INNER JOIN
	Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
INNER JOIN 
	Sales.Customer cus ON soh.CustomerID = cus.CustomerID
WHERE
	(p.Name = 'Racing Socks, L') 
	--AND ()


----------------------------------------------------------------------------------------------------------------------------
-- A "Single Item Order" is a customer order where only one item is ordered.
-- Show the SalesOrderID and the UnitPrice for every Single Item Order
----------------------------------------------------------------------------------------------------------------------------

WITH SIO (
	SalesOrderID,
	Items) AS (
	SELECT
		SalesOrderID,
		SUM(OrderQty) AS Items
	FROM
		Sales.SalesOrderDetail
	GROUP BY 
		SalesOrderID
	HAVING
		SUM(OrderQty) = 1
	)
SELECT
		SalesOrderID,
		UnitPrice
FROM
	Sales.SalesOrderDetail
WHERE
	SalesOrderID IN (SELECT SalesOrderID FROM SIO)

-- Alternatively using sub-queries

SELECT
		SalesOrderID,
		UnitPrice
FROM
	Sales.SalesOrderDetail
WHERE
	SalesOrderID IN (
	SELECT
		SalesOrderID
	FROM
		Sales.SalesOrderDetail
	GROUP BY 
		SalesOrderID
	HAVING
		SUM(OrderQty) = 1
)



--- Actual Temp Table
--USE tempdb;
--GO

--IF OBJECT_ID(N'#Bicycles', N'U') IS NOT NULL
--DROP TABLE #Bicycles;

--SELECT *
--INTO #Bicycles
--FROM AdventureWorks2022.Production.Product
--WHERE ProductNumber LIKE 'BK%';

---- Drop the table
--IF OBJECT_ID(N'#Bicycles', N'U') IS NOT NULL
--DROP TABLE #Bicycles;
--GO



GO