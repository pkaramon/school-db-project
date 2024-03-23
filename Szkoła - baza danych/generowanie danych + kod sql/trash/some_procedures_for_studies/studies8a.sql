CREATE PROCEDURE AddStudySession
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

    -- Sprawdź, czy istnieje przedmiot o podanym SubjectID
    IF EXISTS (SELECT 1 FROM Subjects WHERE SubjectID = @SubjectID)
    BEGIN
        -- Sprawdź, czy istnieje pracownik o podanym LecturerID
        IF EXISTS (SELECT 1 FROM Employees WHERE EmployeeID = @LecturerID)
        BEGIN
            -- Sprawdź, czy istnieje Translator o podanym TranslatorID
            IF @TranslatorID IS NULL OR EXISTS (SELECT 1 FROM Employees WHERE EmployeeID = @TranslatorID)
            BEGIN
                -- Sprawdź, czy istnieje język o podanym LanguageID
                IF EXISTS (SELECT 1 FROM Languages WHERE LanguageID = @LanguageID)
                BEGIN
                    -- Sprawdź, czy daty są poprawne
                    IF @StartDate < @EndDate
                    BEGIN
                        -- Sprawdź, czy MaxStudents > 0
                        IF @MaxStudents > 0
                        BEGIN
                            -- Dodaj nowy wpis do tabeli StudiesSessions
                            INSERT INTO StudiesSessions (SubjectID, StartDate, EndDate, LecturerID, MaxStudents, TranslatorID, LanguageID)
                            VALUES (@SubjectID, @StartDate, @EndDate, @LecturerID, @MaxStudents, @TranslatorID, @LanguageID);

                            PRINT 'Sesja studiów została dodana.';
                            RETURN 0;
                        END
                        ELSE
                        BEGIN
                            PRINT 'Liczba maksymalnych studentów musi być większa niż 0.';
                        END
                    END
                    ELSE
                    BEGIN
                        PRINT 'Data rozpoczęcia musi być wcześniejsza niż data zakończenia.';
                    END
                END
                ELSE
                BEGIN
                    PRINT 'Język o podanym LanguageID nie istnieje.';
                END
            END
            ELSE
            BEGIN
                PRINT 'Tłumacz o podanym TranslatorID nie istnieje.';
            END
        END
        ELSE
        BEGIN
            PRINT 'Pracownik o podanym LecturerID nie istnieje.';
        END
    END
    ELSE
    BEGIN
        PRINT 'Przedmiot o podanym SubjectID nie istnieje.';
    END
    RETURN 1;
END;