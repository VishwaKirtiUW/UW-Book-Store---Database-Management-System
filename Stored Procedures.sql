USE GROUP4IMT543;

GO
CREATE PROCEDURE InsertApparelColor
@ColorName VARCHAR(20)
AS
INSERT INTO APPAREL_COLOR(COLOR_NAME)
VALUES(@ColorName);

EXEC InsertApparelColor
@ColorName='Red'

EXEC InsertApparelColor
@ColorName='Blue'

EXEC InsertApparelColor
@ColorName='Green'

EXEC InsertApparelColor
@ColorName='Yellow'

EXEC InsertApparelColor
@ColorName='White'

SELECT * FROM APPAREL_COLOR

--InsertApparelSize
GO
CREATE PROCEDURE InsertApparelSize
@SizeAbbr VARCHAR(5),
@SizeDesc VARCHAR(255)
AS
INSERT INTO SIZE(SIZE_ABBR,SIZE_DESC)
VALUES(@SizeAbbr,@SizeDesc);

EXEC InsertApparelSize
@SizeAbbr='XS',
@SizeDesc='Extra Small'

EXEC InsertApparelSize
@SizeAbbr='S',
@SizeDesc='Small'

EXEC InsertApparelSize
@SizeAbbr='M',
@SizeDesc='Medium'

EXEC InsertApparelSize
@SizeAbbr='L',
@SizeDesc='Large'

EXEC InsertApparelSize
@SizeAbbr='XL',
@SizeDesc='Extra Large'

SELECT * FROM [SIZE]
GO
--InsertIntoGender
CREATE PROCEDURE InsertGender
@Gender VARCHAR(50)
AS 
INSERT INTO GENDER(GENDER_NAME)
VALUES(@Gender)

EXEC InsertGender
@Gender='Male'

EXEC InsertGender
@Gender='Female'

EXEC InsertGender
@Gender='Non-Binary'

SELECT * FROM GENDER
GO

--InsertIntoInk
CREATE PROCEDURE InsertInkColor
@InkColor VARCHAR(50)
AS 
INSERT INTO INK_COLOR(INK_COLOR_NAME)
VALUES(@InkColor)

EXEC InsertInkColor
@InkColor='Black';


EXEC InsertInkColor
@InkColor='Blue';


EXEC InsertInkColor
@InkColor='Red';


EXEC InsertInkColor
@InkColor='Green';


EXEC InsertInkColor
@InkColor='Purple';


SELECT * FROM INK_COLOR
GO
--DELETE FROM INK_COLOR

--DBCC CHECKIDENT (INK_COLOR, RESEED, 0)
--DROP PROCEDURE InsertInkColor

--Insert Into Author
CREATE PROCEDURE InsertAuthor
@Fname VARCHAR(50),
@Lname VARCHAR(50),
@Gender VARCHAR(50)
AS
DECLARE @GenderID INT
SET @GenderID=(SELECT GENDER_ID FROM GENDER WHERE GENDER_NAME=@Gender)
INSERT INTO AUTHOR(FNAME,LANME,GENDER_ID)
VALUES(@Fname,@Lname,@GenderID)

EXEC InsertAuthor
@Fname='Dale',
@Lname='Carnegie',
@Gender='Female'

EXEC InsertAuthor
@Fname='Charlotte',
@Lname='Brontë',
@Gender='Female'

EXEC InsertAuthor
@Fname='Benjamin',
@Lname='Graham',
@Gender='Male'

EXEC InsertAuthor
@Fname='Paulo',
@Lname='Coelho',
@Gender='Male'

EXEC InsertAuthor
@Fname='Jim',
@Lname='Shooter',
@Gender='Male'

SELECT * FROM AUTHOR
GO

--Insert Into Publisher
CREATE PROCEDURE InsertPublisher
@Publisher VARCHAR(255)
AS
INSERT INTO PUBLISHER(PUBLISHER_NAME)
VALUES(@Publisher)

EXEC InsertPublisher
@Publisher='Simon & Schuster'

EXEC InsertPublisher
@Publisher='Smith, Elder & Co.'

EXEC InsertPublisher
@Publisher='Harper'

EXEC InsertPublisher
@Publisher='HarperCollins'

EXEC InsertPublisher
@Publisher='Marvel Comics'

SELECT * FROM PUBLISHER
GO
--DELETE FROM PUBLISHER
--DBCC CHECKIDENT (PUBLISHER, RESEED, 0)

--DROP PROCEDURE InsertPublisher

--Insert Into Genre
CREATE PROCEDURE InsertGenre
@Genre VARCHAR(255)
AS 
INSERT INTO GENRE(GENRE_NAME)
VALUES(@Genre)

EXEC InsertGenre
@Genre='Comics'

EXEC InsertGenre
@Genre='Fantasy Fiction'

EXEC InsertGenre
@Genre='Investment'

EXEC InsertGenre
@Genre='Romance novel'

EXEC InsertGenre
@Genre='Self-help'
GO

--Insert Into ProductType
CREATE PROCEDURE InsertProductType
@ProductType VARCHAR(50)
AS
INSERT INTO PRODUCT_TYPE(PRODUCT_TYPE_NAME)
VALUES(@ProductType)

EXEC InsertProductType
@ProductType='Book'

EXEC InsertProductType
@ProductType='Notebook'

EXEC InsertProductType
@ProductType='Pen'

EXEC InsertProductType
@ProductType='Apparel'

SELECT * FROM PRODUCT_TYPE

GO
--Insert Into ProductBook


CREATE PROCEDURE GetAuthorID
@AuthorFname VARCHAR(20),
@AuthorLname VARCHAR(20),
@AuthorID INT OUTPUT
AS
SET @AuthorID=(SELECT AUTHOR_ID FROM AUTHOR WHERE FNAME=@AuthorFname AND LANME=@AuthorLname )
GO



CREATE PROCEDURE GetPublisherID
@PublisherName VARCHAR(50),
@PublisherID INT OUTPUT
AS
SET @PublisherID=(SELECT PUBLISHER_ID FROM PUBLISHER WHERE PUBLISHER_NAME=@PublisherName)
GO

CREATE PROCEDURE GetGenreID
@Genre VARCHAR(20),
@GenreID INT OUTPUT
AS
SET @GenreID=(SELECT GENRE_ID FROM GENRE WHERE GENRE_NAME=@Genre)
GO

CREATE PROCEDURE GetProductTypeID
@ProductType VARCHAR(50),
@ProductTypeID INT OUTPUT
AS
SET @ProductTypeID=(SELECT PRODUCT_TYPE_ID FROM PRODUCT_TYPE WHERE PRODUCT_TYPE_NAME=@ProductType)
GO

CREATE PROCEDURE InsertBook
@AFname VARCHAR(50),
@ALname VARCHAR(50),
@PubName VARCHAR(50),
@GenreName VARCHAR(20),
@ProductName VARCHAR(50),
@ISBN VARCHAR(50),
@ProductTypeName VARCHAR(20),
@Price FLOAT
AS
DECLARE @AID INT, @PID INT,@GID INT,@PTID INT, @ProductID INT

EXEC GetAuthorID
@AuthorFname=@AFname,
@AuthorLname = @ALname,
@AuthorID=@AID OUTPUT

EXEC GetPublisherID
@PublisherName=@PubName,
@PublisherID=@PID OUTPUT

EXEC GetGenreID
@Genre=@GenreName,
@GenreID=@GID OUTPUT

EXEC GetProductTypeID
@ProductType=@ProductTypeName,
@ProductTypeID=@PTID OUTPUT

BEGIN TRAN T1
    INSERT INTO PRODUCT(PRODUCT_NAME,PRODUCT_TYPE_ID,PRICE)
    VALUES(@ProductName,@PTID,@Price)

    SET @ProductID=scope_identity()
    INSERT INTO BOOK(PRODUCT_ID,ISBN,AUTHOR_ID,PUBLISHER_ID,GENRE_ID)
    VALUES(@ProductID,@ISBN,@AID,@PID,@GID)

IF @@ERROR <> 0
    BEGIN
        PRINT 'Transaction Failure, Check your Arguments'
        ROLLBACK TRAN T1
    END
ELSE
    COMMIT TRAN T1
GO


EXEC InsertBook
@AFname='Dale',
@ALname='Carnegie',
@PubName='Simon & Schuster',
@GenreName='Self-help',
@ProductName='How to Win Friends and Influence People',
@ISBN='12345678',
@ProductTypeName='Book',
@Price=11.85

EXEC InsertBook
@AFname='Charlotte',
@ALname='Brontë',
@PubName='Smith, Elder & Co.',
@GenreName='Romance novel',
@ProductName='Jane Eyre',
@ISBN='12345670',
@ProductTypeName='Book',
@Price=4.99

EXEC InsertBook
@AFname='Benjamin',
@ALname='Graham',
@PubName='Harper',
@GenreName='Investment',
@ProductName='The Intelligent Investor',
@ISBN='12345690',
@ProductTypeName='Book',
@Price=8.99

EXEC InsertBook
@AFname='Paulo',
@ALname='Coelho',
@PubName='HarperCollins',
@GenreName='Fantasy Fiction',
@ProductName='The Alchemist',
@ISBN='12395670',
@ProductTypeName='Book',
@Price=12.99

EXEC InsertBook
@AFname='Jim',
@ALname='Shooter',
@PubName='Marvel Comics',
@GenreName='Comics',
@ProductName='Marvel Superheroes Secret Wars',
@ISBN='12945670',
@ProductTypeName='Book',
@Price=16.99

SELECT * FROM PRODUCT
SELECT * FROM BOOK
GO
--Insert Notebook

CREATE PROCEDURE InsertNotebook
@ProductName VARCHAR(50),
@ProductTypeName VARCHAR(50),
@Price FLOAT,
@Pages INT,
@Cover VARCHAR(50)
AS
DECLARE @PTID INT,@ProductID INT

EXEC GetProductTypeID
@ProductType=@ProductTypeName,
@ProductTypeID=@PTID OUTPUT

BEGIN TRAN T1
    INSERT INTO PRODUCT(PRODUCT_NAME,PRODUCT_TYPE_ID,PRICE)
    VALUES(@ProductName,@PTID,@Price)

    SET @ProductID=scope_identity()
    INSERT INTO NOTEBOOK(PRODUCT_ID,PAGES,COVER)
    VALUES(@ProductID,@Pages,@Cover)

IF @@ERROR <> 0
    BEGIN
        PRINT 'Transaction Failure, Check your Arguments'
        ROLLBACK TRAN T1
    END
ELSE
    COMMIT TRAN T1
GO

EXEC InsertNotebook
@ProductName='Spiral Sketchpad',
@ProductTypeName='Notebook',
@Price=13.25,
@Pages=100,
@Cover='Soft Cover'

EXEC InsertNotebook
@ProductName='Spiral Ruled Travel Journal',
@ProductTypeName='Notebook',
@Price=17.99,
@Pages=60,
@Cover='Hard Cover'

EXEC InsertNotebook
@ProductName='Mintra Office Legal Pads - NARROW RULED',
@ProductTypeName='Notebook',
@Price=4.99,
@Pages=50,
@Cover='Back Cover Only'

EXEC InsertNotebook
@ProductName='Paperage Lined Journal',
@ProductTypeName='Notebook',
@Price=9.65,
@Pages=100,
@Cover='Hard Cover'

EXEC InsertNotebook
@ProductName='Rite in the Rain Notebook',
@ProductTypeName='Notebook',
@Price=3.89,
@Pages=50,
@Cover='Weatherproof Top-Spiral'

SELECT * FROM NOTEBOOK
SELECT * FROM PRODUCT
GO

--Insert Apparel
CREATE PROCEDURE GetGenderID
@Gender VARCHAR(20),
@GenderID INT OUTPUT
AS
SET @GenderID=(SELECT GENDER_ID FROM GENDER WHERE GENDER_NAME=@Gender)
GO

CREATE PROCEDURE GetColorID
@Color VARCHAR(20),
@ColorID INT OUTPUT
AS
SET @ColorID=(SELECT COLOR_ID FROM APPAREL_COLOR WHERE COLOR_NAME=@Color)
GO


CREATE PROCEDURE GetSizeID
@Size VARCHAR(5),
@SizeID INT OUTPUT
AS
SET @SizeID=(SELECT SIZE_ID FROM SIZE WHERE SIZE_ABBR=@Size)
GO

CREATE PROCEDURE InsertApparel
@ProductName VARCHAR(50),
@ProductTypeName VARCHAR(50),
@Price FLOAT,
@GenderName VARCHAR(50),
@SizeAbbr VARCHAR(5),
@ColorName VARCHAR(50)
AS
DECLARE @PTID INT, @ProductID INT, @GID INT, @CID INT,@SID INT

EXEC GetSizeID
@Size=@SizeAbbr,
@SizeID=@SID OUTPUT

EXEC GetProductTypeID
@ProductType=@ProductTypeName,
@ProductTypeID=@PTID OUTPUT

EXEC GetColorID
@Color=@ColorName,
@ColorID=@CID OUTPUT

EXEC GetGenderID
@Gender=@GenderName,
@GenderID=@GID OUTPUT

BEGIN TRAN T1
    INSERT INTO PRODUCT(PRODUCT_NAME,PRODUCT_TYPE_ID,PRICE)
    VALUES(@ProductName,@PTID,@Price)

    SET @ProductID=scope_identity()
    INSERT INTO APPAREL(PRODUCT_ID,GENDER_ID,SIZE_ID,COLOR_ID)
    VALUES(@ProductID,@GID,@SID,@CID)

IF @@ERROR <> 0
    BEGIN
        PRINT 'Transaction Failure, Check your Arguments'
        ROLLBACK TRAN T1
    END
ELSE
    COMMIT TRAN T1
GO

EXEC InsertApparel
@ProductName ='Cotton T-shirt',
@ProductTypeName='Apparel',
@Price =15.99,
@GenderName ='Non-Binary',
@SizeAbbr='S',
@ColorName='White'

EXEC InsertApparel
@ProductName ='Scarf',
@ProductTypeName='Apparel',
@Price =5.99,
@GenderName ='Non-Binary',
@SizeAbbr='S',
@ColorName='Yellow'

EXEC InsertApparel
@ProductName ='Sweatshirt',
@ProductTypeName='Apparel',
@Price =27.99,
@GenderName ='Non-Binary',
@SizeAbbr='M',
@ColorName='Red'

EXEC InsertApparel
@ProductName ='Sweatshirt',
@ProductTypeName='Apparel',
@Price =27.99,
@GenderName ='Non-Binary',
@SizeAbbr='L',
@ColorName='Red'

EXEC InsertApparel
@ProductName ='Joggers',
@ProductTypeName='Apparel',
@Price =18.99,
@GenderName ='Female',
@SizeAbbr='M',
@ColorName='Blue'

SELECT * FROM APPAREL
SELECT * FROM PRODUCT