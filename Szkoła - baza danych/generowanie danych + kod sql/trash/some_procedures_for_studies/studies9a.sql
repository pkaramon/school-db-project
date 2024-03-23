CREATE PROCEDURE AddStationaryStudySession
    @SubjectID INT,
    @StartDate DATE,
    @EndDate DATE,
    @LecturerID INT,
    @MaxStudents INT,
    @TranslatorID INT,
    @LanguageID INT,
    @Adress NVARCHAR(500),
    @City NVARCHAR(500),
    @Country NVARCHAR(500),
    @PostalCode NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    -- Sprawdź czy StudySession istnieje
    IF EXISTS (SELECT 1 FROM StudiesSessions WHERE SubjectID = @SubjectID)
    BEGIN
    DECLARE @i INT
    exec @i = AddStudySession @SubjectID, @StartDate, @EndDate, @LecturerID, @MaxStudents, @TranslatorID, @LanguageID;
    IF (@i = 0)
    BEGIN
        -- Dodaj nową OnlineStudySession
        INSERT INTO StationaryStudiesSessions (Address, City, Country, PostalCode)
        VALUES (@Adress, @City, @Country, @PostalCode);

        PRINT 'Nowa StationarySession została dodana.';
        RETURN 0;
        END
    BEGIN
    PRINT 'Nie udało się dodać nową sesję do StudySessions'
    END
    END
    ELSE
    BEGIN
        PRINT 'StudySession o podanym SubjectID nie istnieje.';
    END
    RETURN 1;
END;
