CREATE PROCEDURE ModifyStationaryStudiesSession
    @StationaryStudiesSessionID INT,
    @Adress NVARCHAR(500),
    @City NVARCHAR(500),
    @Country NVARCHAR(500),
    @PostalCode NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    -- Sprawdź czy OnlineStudiesSession o podanym ID istnieje
    IF EXISTS (SELECT 1 FROM OnlineStudiesSessions WHERE OnlineStudiesSessionID = @StationaryStudiesSessionID)
    BEGIN
        -- Modyfikuj istniejący rekord
        UPDATE StationaryStudiesSessions
        SET
            Address = @Adress,
            City = @City,
            Country = @Country,
            PostalCode = @PostalCode
        WHERE StationaryStudiesSessionID = @StationaryStudiesSessionID;

        PRINT 'StationaryStudiesSession został pomyślnie zaktualizowany.';
        RETURN 0;
    END
    ELSE
    BEGIN
        PRINT 'StationaryStudiesSession o podanym ID nie istnieje.';
    END
    RETURN 1;
END;