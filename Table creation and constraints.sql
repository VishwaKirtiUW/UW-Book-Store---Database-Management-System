--- IMT 543 University database

--CREATE DATABASE GROUP4IMT543
USE GROUP4IMT543;
--DROP DATABASE GROUP4IMT543

CREATE TABLE PRODUCT_TYPE(
    PRODUCT_TYPE_ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    PRODUCT_TYPE_NAME VARCHAR(50) NOT NULL
);

CREATE TABLE PRODUCT(
    PRODUCT_ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    PRODUCT_NAME VARCHAR(50) NOT NULL,
    PRODUCT_TYPE_ID INT CONSTRAINT FK_PRODUCT_PRODUCTTYPE FOREIGN KEY REFERENCES PRODUCT_TYPE(PRODUCT_TYPE_ID) NOT NULL,
    PRICE FLOAT NOT NULL
);

CREATE TABLE NOTEBOOK(
    PRODUCT_ID INT PRIMARY KEY CONSTRAINT FK_NOTEBOOK_PRODUCT FOREIGN KEY REFERENCES PRODUCT(PRODUCT_ID) NOT NULL,
    PAGES INT,
    COVER VARCHAR(50)
);

CREATE TABLE GENDER(
    GENDER_ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    GENDER_NAME VARCHAR(50) NOT NULL
);

CREATE TABLE AUTHOR(
    AUTHOR_ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    FNAME VARCHAR(50) NOT NULL,
    LANME VARCHAR(50) NOT NULL,
    GENDER_ID INT NOT NULL CONSTRAINT FK_GENDER_AUTHOR FOREIGN KEY REFERENCES GENDER(GENDER_ID)
)

CREATE TABLE PUBLISHER(
    PUBLISHER_ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    PUBLISHER_NAME VARCHAR(255) NOT NULL
);

CREATE TABLE GENRE(
    GENRE_ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    GENRE_NAME VARCHAR(255) NOT NULL
);

CREATE TABLE BOOK(
    PRODUCT_ID INT PRIMARY KEY CONSTRAINT FK_BOOK_PRODUCT FOREIGN KEY REFERENCES PRODUCT(PRODUCT_ID) NOT NULL,
    ISBN VARCHAR(50) NOT NULL,
    AUTHOR_ID INT NOT NULL CONSTRAINT FK_BOOK_AUTHOR FOREIGN KEY REFERENCES AUTHOR(AUTHOR_ID),
    PUBLISHER_ID INT NOT NULL CONSTRAINT FK_BOOK_PUBLISHER FOREIGN KEY REFERENCES PUBLISHER(PUBLISHER_ID),
    GENRE_ID INT NOT NULL CONSTRAINT FK_BOOK_GENRE FOREIGN KEY REFERENCES GENRE(GENRE_ID)
);

CREATE TABLE INK_COLOR(
    INK_COLOR_ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    INK_COLOR_NAME VARCHAR(50) NOT NULL
);

CREATE TABLE PEN(
    PRODUCT_ID INT PRIMARY KEY CONSTRAINT FK_PEN_PRODUCT FOREIGN KEY REFERENCES PRODUCT(PRODUCT_ID) NOT NULL,
    INK_TYPE VARCHAR(50) NOT NULL,
    INK_COLOR_ID INT CONSTRAINT FK_PEN_INKCOLOR FOREIGN KEY REFERENCES INK_COLOR(INK_COLOR_ID) NOT NULL
);

CREATE TABLE SIZE(
    SIZE_ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    SIZE_ABBR VARCHAR(5) NOT NULL,
    SIZE_DESC VARCHAR(255) NOT NULL
);

CREATE TABLE APPAREL_COLOR(
    COLOR_ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    COLOR_NAME VARCHAR(20) NOT NULL
);

CREATE TABLE APPAREL(
    PRODUCT_ID INT PRIMARY KEY CONSTRAINT FK_APPAREL_PRODUCT FOREIGN KEY REFERENCES PRODUCT(PRODUCT_ID) NOT NULL,
    GENDER_ID INT CONSTRAINT FK_APPAREL_GENDER FOREIGN KEY REFERENCES GENDER(GENDER_ID) NOT NULL,
    SIZE_ID INT CONSTRAINT FK_APPAREL_SIZE FOREIGN KEY REFERENCES SIZE(SIZE_ID) NOT NULL,
    COLOR_ID INT CONSTRAINT FK_APPAREL_COLOR FOREIGN KEY REFERENCES APPAREL_COLOR(COLOR_ID) NOT NULL
);

--- 1. Creating Customer, Store, State and Order table
--- 2. Code to insert 5 records into each of these coloumns
--- 3. Stored Procedure:
---		1. Inserting data into Orders Table
---		2. Creating stored procedure to insert data into 'Pen' Table
--- 4. Business Rule - The age of the customer that orders from the book store should be greater than or equal to 8
--- 5. Computed column -  Find total amount spend by each customer

USE GROUP4IMT543

--- 1. Creating tables
CREATE TABLE CUSTOMERS (
    Customer_ID INTEGER IDENTITY(1, 1) PRIMARY KEY,
    Customer_Fname VARCHAR(50) NOT NULL,
    Customer_Lname VARCHAR(50) NOT NULL,
    Customer_Email VARCHAR(100) NOT NULL UNIQUE,
    Customer_Phone CHAR(10),
	Birth_Date DATE NOT NULL,
    Customer_Zipcode INT NOT NULL,
    Customer_Street_Address VARCHAR(100),
    Customer_City VARCHAR(100),
    Customer_State CHAR(2) FOREIGN KEY REFERENCES STATES(State_Abbr) NOT NULL
);


CREATE TABLE STORE (
    Store_ID INT IDENTITY(1,1) PRIMARY KEY,
    Store_Name VARCHAR(100),
    Store_Zip INT NOT NULL,
    Street_Address VARCHAR(100) NOT NULL,
    Store_City VARCHAR(100) NOT NULL,
    Store_State CHAR(2) FOREIGN KEY REFERENCES STATES(State_Abbr) NOT NULL
);


CREATE TABLE STATES (
	State_Abbr CHAR(2) PRIMARY KEY,
	State_Name VARCHAR(20)
);


CREATE TABLE ORDERS(
    Order_ID INT IDENTITY(1,1) PRIMARY KEY,
    Customer_ID INT FOREIGN KEY REFERENCES CUSTOMERS(Customer_ID) NOT NULL,
    Total_Cost FLOAT NOT NULL,
    Order_Date DATE NOT NULL,
    Store_ID INT FOREIGN KEY REFERENCES STORE(Store_ID)
);


--- 2. Inserting into Customer, Store and State tables

--- 1. STATES
INSERT INTO STATES (State_Abbr, State_Name)
VALUES ('WA', 'Washington'), 
		('CA', 'California'), 
		('OR', 'Oregon'), 
		('TX', 'Texas'), 
		('IL', 'Illinois')
SELECT * FROM STATES

--- 2. CUSTOMERS
INSERT INTO CUSTOMERS (Customer_Fname, Customer_Lname, Customer_Email, Customer_Phone, Birth_Date, Customer_Zipcode, 
Customer_Street_Address, Customer_City, Customer_State)
VALUES
('Al', 'Martini', 'am@gmail.com', '3056536017', '13 September, 1995', 98106, '9241 13th Ave SW', 'Seattle',
(SELECT State_Abbr FROM STATES WHERE State_Name = 'Washington')),

('Adam', 'Jacobs', 'aj@gmail.com', '2061236432', '15 May, 1993', 98101, '1932 Raccoon Run', 'Seattle',
(SELECT State_Abbr FROM STATES WHERE State_Name = 'Washington')),

('Jeffrey', 'Ambrose', 'ja@gmail.com', '2066798820', '9 March, 1998', 98109, '3152 Union Street', 'Seattle',
(SELECT State_Abbr FROM STATES WHERE State_Name = 'Washington')),

('Anna', 'Hawkins', 'ah@gmail.com', '2067210022', '12 December, 1992', 98118, '1847 Union Street', 'Seattle',
(SELECT State_Abbr FROM STATES WHERE State_Name = 'Washington')),

('Vanessa', 'Sikora', 'vs@gmail.com', '2537788232', '7 January, 2000', 98101, '2058 Dale Avenue', 'Seattle',
(SELECT State_Abbr FROM STATES WHERE State_Name = 'Washington'))
SELECT * FROM CUSTOMERS

--- 3. STORE
INSERT INTO STORE (Store_Name, Store_Zip, Street_Address, Store_City, Store_State)
VALUES 
('Bookmark for Life', 98008, '15903 Vincent Rd NW', 'Bellevue', (SELECT State_Abbr FROM STATES WHERE State_Name = 'Washington')),
('The Page Sage', 99224, '2004 S Royal St', 'Spokane', (SELECT State_Abbr FROM STATES WHERE State_Name = 'Washington')),
('The Wordsmith', 98370, '3014 277th Ave SE', 'Fall City', (SELECT State_Abbr FROM STATES WHERE State_Name = 'Washington')),
('Word World', 94043, '487 E Middlefield Rd', 'Mountain View', (SELECT State_Abbr FROM STATES WHERE State_Name = 'California')),
('Book wise', 94124, '58 Middle Point Rd','San Francisco', (SELECT State_Abbr FROM STATES WHERE State_Name = 'California'))
SELECT * FROM STORE


--- 3. Two (2) stored procedures (again, each student) to populate transaction-tables that include the following:
--- a) at least two (2) input parameters
--- b) at least two (2) variables 

--- 1st Stored Procedure - ORDERS SPROC - Inserting data into Orders Table
--- Nested -> Customer_ID and Store_ID


GO
CREATE PROCEDURE GetCustomerID
@CustFname VARCHAR(50),
@CustLname VARCHAR(50),
@CustEmail VARCHAR(100),
@Cust_ID INT OUTPUT
AS
SET @Cust_ID  = (SELECT Customer_ID from CUSTOMERS 
					WHERE Customer_Fname=@CustFname
					AND Customer_Lname=@CustLname
					And Customer_Email=@CustEmail)
GO

CREATE PROCEDURE GetStoreID
@StoreName VARCHAR(100),
@StoreZip INT,
@Store_ID INT OUTPUT
AS
SET @Store_ID = (SELECT Store_ID FROM STORE
					WHERE Store_Name=@StoreName
					AND Store_Zip=@StoreZip)
GO


--- Because there will be multiple records of product and quantity so need to pass a table.
--- For example - Order has 2 books, 5 pens and 1 Apparel then there will be 3 records for thhe ProductNameQuantity table

--- Passing table as a parameter because one customer can have mutiple products in there order
CREATE TYPE ProductNameQuantity AS TABLE
	(
		ProductName varchar(100),
		Quantity INT
	)
	GO

--- Calculating the total cost of the single order by a customer
CREATE PROCEDURE GetTotalCost
@PrQ ProductNameQuantity READONLY,
@totalCost FLOAT OUTPUT
AS
	WITH tempTable AS 
	(
		SELECT P.PRODUCT_ID, P.PRODUCT_NAME, P.PRICE, PQ.Quantity, (P.PRICE * Quantity) AS ProductCost 
		FROM PRODUCT AS P
		JOIN @PrQ AS PQ ON P.PRODUCT_NAME= PQ.ProductName
	)
	SELECT @totalCost = SUM(ProductCost) FROM tempTable
GO

CREATE PROCEDURE InsertOrders
@CuFname VARCHAR(50),
@CuLname VARCHAR(50),
@CuEmail VARCHAR(100),
@SName VARCHAR(100),
@SZip INT,
@Order_Date DATE,
@PrQ ProductNameQuantity READONLY

AS

	DECLARE @Cu_ID INT, @S_ID INT, @tCost FLOAT

	EXEC GetCustomerID
	@CustFname=@CuFname,
	@CustLname=@CuLname,
	@CustEmail=@CuEmail,
	@Cust_ID=@Cu_ID OUTPUT

	IF @Cu_ID IS NULL
	  BEGIN
			PRINT 'Cannot find Cu_ID for the given Customer name or Email'
			RAISERROR ('@Cu_ID appears to be NULL', 11,1)
			RETURN
		END

	EXEC GetStoreID
	@StoreName=@SName,
	@StoreZip=@Szip,
	@Store_ID=@S_ID OUTPUT

	IF @S_ID IS NULL
	  BEGIN
			PRINT 'Cannot find S_ID for the given Store Name or Zip'
			RAISERROR ('@S_ID appears to be NULL', 11,1)
			RETURN
		END

	EXEC GetTotalCost
	@PrQ=@PrQ,
	@totalCost=@tCost OUTPUT

	BEGIN TRAN T1
	INSERT INTO ORDERS (Customer_ID, Total_Cost, Order_Date, Store_ID)
	VALUES (@Cu_ID, @tCost, @Order_Date, @S_ID)
	IF @@ERROR <> 0
		BEGIN
			PRINT 'Something went wrong while inserting into ORDERS'
			ROLLBACK TRAN T1
		END
	ELSE
		COMMIT TRAN T1
GO

--- Inserting 5 Records into Order Table 
DECLARE @PrQ6 ProductNameQuantity
INSERT INTO @PrQ6 VALUES ('Scarf', 1)
INSERT INTO @PrQ6 VALUES ('Spiral Sketchpad', 2)
INSERT INTO @PrQ6 VALUES ('Joggers', 2)

EXEC InsertOrders
@CuFname='Vanessa', 
@CuLname='Sikora',
@CuEmail= 'vs@gmail.com',
@SName='Book wise',
@SZip=94124,
@Order_Date = 'May 11, 2020',
@PrQ = @PrQ6



DECLARE @PrQ7 ProductNameQuantity
INSERT INTO @PrQ7 VALUES ('Sweatshirt', 1)
INSERT INTO @PrQ7 VALUES ('Joggers', 1)
INSERT INTO @PrQ7 VALUES ('Sharpie S-Gel', 2)

EXEC InsertOrders
@CuFname='Anna', 
@CuLname='Hawkins',
@CuEmail= 'ah@gmail.com',
@SName='Bookmark for Life',
@SZip=98008,
@Order_Date = 'October 15, 2020',
@PrQ = @PrQ7



DECLARE @PrQ8 ProductNameQuantity
INSERT INTO @PrQ8 VALUES ('Jane Eyre', 1)
INSERT INTO @PrQ8 VALUES ('Spiral Sketchpad', 2)
INSERT INTO @PrQ8 VALUES ('Uni-ball Vision', 2)

EXEC InsertOrders
@CuFname='Jeffrey', 
@CuLname='Ambrose',
@CuEmail= 'ja@gmail.com',
@SName='The Wordsmith',
@SZip=98370,
@Order_Date = ' April 11, 2020',
@PrQ = @PrQ8 


DECLARE @PrQ9 ProductNameQuantity
INSERT INTO @PrQ9 VALUES ('Scarf', 2)
INSERT INTO @PrQ9 VALUES ('The Alchemist', 1)
INSERT INTO @PrQ9 VALUES ('Sharpie S-Gel', 2)

EXEC InsertOrders
@CuFname='Adam', 
@CuLname='Jacobs',
@CuEmail= 'aj@gmail.com',
@SName='Book wise',
@SZip=94124,
@Order_Date = 'February 18, 2020',
@PrQ = @PrQ9

select * From CUSTOMERS
select * from PRODUCT

DECLARE @PrQ13 ProductNameQuantity
INSERT INTO @PrQ13 VALUES ('Cotton T-shirt', 2)
INSERT INTO @PrQ13 VALUES ('Marvel Superheroes Secret Wars', 3)
INSERT INTO @PrQ13 VALUES ('Sharpie S-Gel', 2)
INSERT INTO @PrQ13 VALUES ('Joggers', 1)

EXEC InsertOrders
@CuFname='Anna', 
@CuLname='Hawkins',
@CuEmail= 'ah@gmail.com',
@SName='Bookmark for Life',
@SZip=98008,
@Order_Date = 'September 3, 2020',
@PrQ = @PrQ13


--- 2nd Stored Procedure - Creating stored procedure to insert data into 'Pen' Table
--- Insert Into ProductBook

GO
CREATE PROCEDURE GetInkColorID
@InkColor VARCHAR(50),
@InkColorID INT OUTPUT
AS
SET @InkColorID=(SELECT INK_COLOR_ID FROM INK_COLOR WHERE INK_COLOR_NAME=@InkColor)
GO

CREATE PROCEDURE GettingProductTypeID
@ProductTypeN VARCHAR(50),
@ProductTypeID INT OUTPUT
AS
SET @ProductTypeID=(SELECT PRODUCT_TYPE_ID FROM PRODUCT_TYPE WHERE PRODUCT_TYPE_NAME=@ProductTypeN)
GO

CREATE PROCEDURE InsertPen
@IColor VARCHAR(50),
@ProductName VARCHAR(50),
@ProductTypeName VARCHAR(20),
@InkType VARCHAR(50),
@Price FLOAT
AS

DECLARE @INKID INT, @PTID INT, @ProductID INT

EXEC GetInkColorID
@InkColor = @IColor,
@InkColorID = @INKID OUTPUT

EXEC GettingProductTypeID
@ProductTypeN=@ProductTypeName,
@ProductTypeID=@PTID OUTPUT

BEGIN TRAN T1
    INSERT INTO PRODUCT (PRODUCT_NAME,PRODUCT_TYPE_ID,PRICE)
	VALUES(@ProductName, @PTID, @Price)
    
	SET @ProductID=scope_identity()
    
	INSERT INTO PEN (PRODUCT_ID, INK_TYPE, INK_COLOR_ID)
    VALUES(@ProductID, @InkType, @INKID)

IF @@ERROR <> 0
    BEGIN
        PRINT 'Transaction Failure, Check your Arguments'
        ROLLBACK TRAN T1
    END
ELSE
    COMMIT TRAN T1
GO

--- Inserting 5 Records into Pen Table 
EXEC InsertPen
@IColor = 'Black',
@ProductName='Pilot',
@ProductTypeName='Pen',
@InkType='Gel',
@Price=4.99

EXEC InsertPen
@IColor = 'Blue', 
@ProductName='Gel-Ocity',
@ProductTypeName='Pen',
@InkType='Gel',
@Price=6.99

EXEC InsertPen
@IColor = 'Black',
@ProductName='Sharpie S-Gel',
@ProductTypeName='Pen',
@InkType='Gel',
@Price=3.99

EXEC InsertPen
@IColor = 'Green',
@ProductName='Uni-ball Vision',
@ProductTypeName='Pen',
@InkType='Ball',
@Price=5.99

EXEC InsertPen
@IColor = 'Purple',
@ProductName='Zebra Pen Z-Grip',
@ProductTypeName='Pen',
@InkType='Ball',
@Price=6.79



--- 4. Business Rule -> Age of the customer >= 8
GO
CREATE FUNCTION CustomerAgeLimit()
RETURNS INTEGER
AS
BEGIN
	DECLARE @RET INTEGER = 0
	IF EXISTS (SELECT *
		FROM CUSTOMERS
		WHERE DATEDIFF(YEAR, Birth_Date, GETDATE()) < 8)
	BEGIN
		SET @RET = 1
	END
RETURN @RET
END
GO

ALTER TABLE CUSTOMERS
ADD CONSTRAINT CustomerAgeLimit
CHECK (dbo.CustomerAgeLimit()=0)


--- 5. Computed Column -> Find total amount spend by each customer
GO
CREATE FUNCTION AmountSpendByCustomer(@PK INT)
RETURNS NUMERIC(14, 2)
AS
BEGIN
	DECLARE @RET NUMERIC(14, 2) = (SELECT SUM(O.Total_Cost) FROM ORDERS AS O
									JOIN CUSTOMERS AS C ON O.Customer_ID = C.Customer_ID
									WHERE C.Customer_ID=@PK
									GROUP BY O.Customer_ID)
RETURN @RET
END
GO

ALTER TABLE CUSTOMERS
ADD TotalAmountSpend AS (dbo.AmountSpendByCustomer(Customer_ID))



--- To look at the data in all the coloumns
SELECT * FROM CUSTOMERS
Select * from ORDERS
SELECT * FROM STATES
SELECT * FROM STORE
SELECT * FROM PEN
SELECT * FROM PRODUCT
SELECT * FROM PRODUCT_TYPE
SELECt * FROM ORDER_PRODUCT

