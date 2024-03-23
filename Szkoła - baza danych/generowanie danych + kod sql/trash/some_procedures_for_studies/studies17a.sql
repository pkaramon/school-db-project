CREATE PROCEDURE AddStudiesSessionAttendance
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
    IF NOT EXISTS (SELECT 1 FROM StudiesSessionsAttendence WHERE SessionID = @SessionID AND StudentID = @StudentID)
    BEGIN
        -- Dodaj nowy wpis do StudiesSessionsAttendence
        INSERT INTO StudiesSessionsAttendence (SessionID, StudentID, Completed)
        VALUES (@SessionID, @StudentID, @Completed);

        PRINT 'Dodano obecność na zajęciach.';
        RETURN 0;
    END
    ELSE
    BEGIN
        PRINT 'Obecność dla tego studenta na tych zajęciach już została dodana wcześniej.';
    END
    RETURN 1;
END;
