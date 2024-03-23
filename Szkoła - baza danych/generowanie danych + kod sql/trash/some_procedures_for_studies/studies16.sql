CREATE PROCEDURE RemoveSubjectMakeUpPossibility
    @SubjectID INT,
    @ProductID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Sprawdź czy nie istnieje rekord w MadeUpAttendance
    IF NOT EXISTS (SELECT 1 FROM MadeUpAttendance WHERE SubjectID = @SubjectID AND ProductID = @ProductID)
    BEGIN
        -- Usuń wpis z SubjectMakeUpPossibilities
        DELETE FROM SubjectMakeUpPossibilities
        WHERE SubjectID = @SubjectID AND ProductID = @ProductID;

        PRINT 'Usunięto możliwość odrabiania.';
        RETURN 0;
    END
    ELSE
    BEGIN
        PRINT 'Nie można usunąć, istnieje rekord w MadeUpAttendance z tą możliwością odrabiania.';
    END
    RETURN 1;
END;