CREATE PROCEDURE ModifyOnlineStudySession
    @OnlineStudiesSessionID INT,
    @WebinarLink NVARCHAR(MAX),
    @RecordingLink NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    -- Sprawdź czy OnlineStudiesSession o podanym ID istnieje
    IF EXISTS (SELECT 1 FROM OnlineStudiesSessions WHERE OnlineStudiesSessionID = @OnlineStudiesSessionID)
    BEGIN
        -- Modyfikuj istniejący rekord
        UPDATE OnlineStudiesSessions
        SET
            WebinarLink = @WebinarLink,
            RecordingLink = @RecordingLink
        WHERE OnlineStudiesSessionID = @OnlineStudiesSessionID;

        PRINT 'OnlineStudiesSession został pomyślnie zaktualizowany.';
        RETURN 0;
    END
    ELSE
    BEGIN
        PRINT 'OnlineStudiesSession o podanym ID nie istnieje.';
    END
    RETURN 1;
END;
