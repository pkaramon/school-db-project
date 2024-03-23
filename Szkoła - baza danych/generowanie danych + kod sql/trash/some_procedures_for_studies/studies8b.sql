CREATE PROCEDURE AddOnlineStudySession
    @SubjectID INT,
    @StartDate DATE,
    @EndDate DATE,
    @LecturerID INT,
    @MaxStudents INT,
    @TranslatorID INT,
    @LanguageID INT,
    @WebinarLink NVARCHAR(MAX),
    @RecordingLink NVARCHAR(MAX)
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
        INSERT INTO OnlineStudiesSessions (WebinarLink, RecordingLink)
        VALUES (@WebinarLink, @RecordingLink);

        PRINT 'Nowa OnlineStudySession została dodana.';
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
