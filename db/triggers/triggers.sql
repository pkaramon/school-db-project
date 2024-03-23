-- Trigger zapisujący w tabeli PeopleDataChangeHistory zmiany danych osób, takie jak imię, nazwisko, data urodzenia, adres, miasto, region, kod pocztowy, kraj, email i telefon.
CREATE OR ALTER TRIGGER tr_People_AfterUpdate
ON People
AFTER UPDATE
AS
BEGIN
    -- Insert the changed data into the PeopleDataChangeHistory table
    INSERT INTO PeopleDataChangeHistory (
        PersonID,
        ChangedAt,
        New_FirstName,
        Old_FirstName,
        New_LastName,
        Old_LastName,
        New_BirthDate,
        Old_BirthDate,
        New_Address,
        Old_Address,
        New_City,
        Old_City,
        New_Region,
        Old_Region,
        New_PostalCode,
        Old_PostalCode,
        New_Country,
        Old_Country,
        New_Email,
        Old_Email,
        New_Phone,
        Old_Phone
    )
    SELECT
        i.PersonID,
        GETDATE(),
        i.FirstName,
        d.FirstName,
        i.LastName,
        d.LastName,
        i.BirthDate,
        d.BirthDate,
        i.Address,
        d.Address,
        i.City,
        d.City,
        i.Region,
        d.Region,
        i.PostalCode,
        d.PostalCode,
        i.Country,
        d.Country,
        i.Email,
        d.Email,
        i.Phone,
        d.Phone
    FROM
        inserted i
    JOIN
        deleted d ON i.PersonID = d.PersonID
    WHERE
        i.FirstName <> d.FirstName
        OR i.LastName <> d.LastName
        OR i.BirthDate <> d.BirthDate
        OR i.Address <> d.Address
        OR i.City <> d.City
        OR i.Region <> d.Region
        OR i.PostalCode <> d.PostalCode
        OR i.Country <> d.Country
        OR i.Email <> d.Email
        OR i.Phone <> d.Phone;
END;
GO

-- Trigger rejestrujący w tabeli CartHistory usunięcie produktu z koszyka, zawierający informacje o użytkowniku, produkcie, dacie dodania i usunięcia.
CREATE OR ALTER TRIGGER trg_RemoveProductFromCart
ON Carts
AFTER DELETE
AS
BEGIN
    INSERT INTO CartHistory (UserID, ProductID, AddedAt, RemovedAt)
    SELECT d.UserID, d.ProductID, d.AddedAt, GETDATE()
    FROM deleted d;
END;
GO

-- Trigger zapisujący w tabeli ProductPriceChangeHistory zmiany ceny i zaliczki produktów, zawierający identyfikator produktu, starą i nową cenę, starą i nową zaliczkę oraz datę zmiany.
CREATE OR ALTER TRIGGER RecordPriceChange
ON Products
AFTER UPDATE
AS
BEGIN
    -- Insert the price change into the ProductPriceChangeHistory table
    INSERT INTO ProductPriceChangeHistory (ProductID, Old_Price, New_Price, Old_AdvancePayment, New_AdvancePayment, ChangedAt)
    SELECT 
        d.ProductID,
        d.Price, -- Old price
        i.Price, -- New price
        d.AdvancePayment, -- Old advance payment
        i.AdvancePayment, -- New advance payment
        GETDATE()
    FROM deleted d
    INNER JOIN inserted i ON d.ProductID = i.ProductID
    WHERE d.Price <> i.Price OR d.AdvancePayment <> i.AdvancePayment;
END;
GO
