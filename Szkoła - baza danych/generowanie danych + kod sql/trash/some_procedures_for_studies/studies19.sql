CREATE PROCEDURE AddPublicStudySession
    @StudiesSessionID INT,
    @Description NVARCHAR(MAX),
    @Price MONEY,
    @AdvancePayment MONEY
AS
BEGIN
    SET NOCOUNT ON;

    -- Sprawdź czy istnieje StudiesSession o podanym StudiesSessionID
    IF NOT EXISTS (SELECT 1 FROM StudiesSessions WHERE StudiesSessionID = @StudiesSessionID)
    BEGIN
        PRINT 'StudiesSession o podanym StudiesSessionID nie istnieje.';
        RETURN 1;  -- Przerwij wykonanie procedury
    END

    -- Sprawdź czy istnieje już wpis w PublicStudySessions dla danego StudiesSessionID
    IF NOT EXISTS (SELECT 1 FROM PublicStudySessions WHERE StudiesSessionID = @StudiesSessionID)
    BEGIN
        DECLARE @index INT
        SET @index = (SELECT max(ProductID) + 1 FROM Products)
        INSERT INTO Products(ProductID, Price, AdvancePayment, ProductType, AddedAt, ClosedAt)
        VALUES (@index, @Price, @AdvancePayment, 'PublicStudySession', GETDATE(), NULL)
        -- Dodaj nowy wpis do PublicStudySessions
        INSERT INTO PublicStudySessions (PublicStudySessionID, StudiesSessionID, Description)
        VALUES (@index, @StudiesSessionID, @Description);


        PRINT 'Dodano PublicStudySession.';
        RETURN 0;
    END
    ELSE
    BEGIN
        PRINT 'PublicStudySession dla tego StudiesSessionID już istnieje.';
    END
    RETURN 1;
END;
