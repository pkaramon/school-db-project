CREATE PROCEDURE ModifyStudySession
    @StudySessionID INT,
    @SubjectID INT,
    @StartDate DATE,
    @EndDate DATE,
    @LecturerID INT,
    @MaxStudents INT,
    @TranslatorID INT,
    @LanguageID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Sprawdź czy StudySession o podanym ID istnieje
    IF EXISTS (SELECT 1 FROM StudiesSessions WHERE StudiesSessionID = @StudySessionID)
    BEGIN
        -- Sprawdź dodatkowe warunki
        IF EXISTS (SELECT 1 FROM Employees WHERE EmployeeID = @LecturerID)
            AND @StartDate < @EndDate
            AND @MaxStudents > 0
            AND EXISTS (SELECT 1 FROM Employees WHERE EmployeeID = @TranslatorID)
            AND EXISTS (SELECT 1 FROM Languages WHERE LanguageID = @LanguageID)
        BEGIN
            -- Modyfikuj istniejący rekord
            UPDATE StudiesSessions
            SET
                SubjectID = @SubjectID,
                StartDate = @StartDate,
                EndDate = @EndDate,
                LecturerID = @LecturerID,
                MaxStudents = @MaxStudents,
                TranslatorID = @TranslatorID,
                LanguageID = @LanguageID
            WHERE StudiesSessionID = @StudySessionID;

            PRINT 'StudySession został pomyślnie zaktualizowany.';
            RETURN 0;
        END
        ELSE
        BEGIN
            PRINT 'Nie spełniono dodatkowych warunków (LecturerID, StartDate < EndDate, MaxStudents > 0, TranslatorID, LanguageID).';
        END
    END
    ELSE
    BEGIN
        PRINT 'StudySession o podanym ID nie istnieje.';
    END
    RETURN 0;
END;
