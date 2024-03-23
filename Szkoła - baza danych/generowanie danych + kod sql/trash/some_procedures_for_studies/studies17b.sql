CREATE PROCEDURE ModifyStudiesSessionAttendance
    @SessionID INT,
    @StudentID INT,
    @Completed BIT
AS
BEGIN
    SET NOCOUNT ON;

    -- Sprawdź czy istnieje student o podanym StudentID
    IF NOT EXISTS (SELECT 1 FROM Students WHERE StudentID = @StudentID)
    BEGIN
        PRINT 'Student o podanym StudentID nie istnieje.';
        RETURN 1;  -- Przerwij wykonanie procedury
    END

    -- Sprawdź czy istnieje StudiesSession o podanym SessionID
    IF NOT EXISTS (SELECT 1 FROM StudiesSessions WHERE StudiesSessionID = @SessionID)
    BEGIN
        PRINT 'StudiesSession o podanym SessionID nie istnieje.';
        RETURN 1;  -- Przerwij wykonanie procedury
    END

    -- Sprawdź czy istnieje wpis dla danego studenta i sesji
    IF EXISTS (SELECT 1 FROM StudiesSessionsAttendence WHERE SessionID = @SessionID AND StudentID = @StudentID)
    BEGIN
        -- Zaktualizuj istniejący wpis w StudiesSessionsAttendence
        UPDATE StudiesSessionsAttendence
        SET Completed = @Completed
        WHERE SessionID = @SessionID AND StudentID = @StudentID;

        PRINT 'Zaktualizowano obecność na zajęciach.';
        RETURN 0;
    END
    ELSE
    BEGIN
        PRINT 'Nie istnieje wpis dla tego studenta na tych zajęciach.';
    END
    RETURN 1;
END;
