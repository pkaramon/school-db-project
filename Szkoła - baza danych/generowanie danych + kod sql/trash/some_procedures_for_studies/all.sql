CREATE OR ALTER PROCEDURE AddFieldOfStudy
    @Name NVARCHAR(MAX),
    @Description NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    -- Dodaj nowy kierunek studiów
    DECLARE @NewFieldOfStudyID int;
    SET @NewFieldOfStudyID = SCOPE_IDENTITY();
    INSERT INTO FieldsOfStudies (Name, Description)
    VALUES (@Name, @Description);
    PRINT 'Added field of study.';
    RETURN 0;
END;

CREATE OR ALTER PROCEDURE DeleteStudyDirection
    @FieldOfStudiesID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Sprawdź, czy istnieją studia na danym kierunku
    IF NOT EXISTS (SELECT 1 FROM Studies WHERE FieldOfStudiesID = @FieldOfStudiesID)
    BEGIN
        BEGIN TRANSACTION;

        -- Usuń kierunek studiów
        DELETE FROM FieldsOfStudies WHERE FieldOfStudiesID = @FieldOfStudiesID;

        COMMIT;
        RETURN 0;
    END
    ELSE
    BEGIN
        PRINT('Nie można usunąć kierunku studiów, ponieważ istnieją związane studia.')
    END
    RETURN 1;
END;

CREATE OR ALTER PROCEDURE AddStudySemester
    @Name NVARCHAR(max),
    @Description NVARCHAR(max),
    @CoordinatorID INT,
    @StartDate DATE,
    @EndDate DATE,
    @MaxStudents INT,
    @LanguageID INT,
    @FieldOfStudiesID INT,
    @SemesterNumber INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Sprawdź, czy podany numer semestru już istnieje
    IF NOT EXISTS (SELECT 1 FROM Studies WHERE SemesterNumber = @SemesterNumber AND FieldOfStudiesID = @FieldOfStudiesID)
    BEGIN
        -- Sprawdź, czy daty są poprawne
        IF @StartDate < @EndDate
        BEGIN
            -- Dodaj nowy semestr
            INSERT INTO Studies VALUES (@Name, @Description, @CoordinatorID, @StartDate, @EndDate, @MaxStudents, @LanguageID, @FieldOfStudiesID, @SemesterNumber);

            PRINT 'Semestr został dodany.';
            RETURN 0;
        END
        ELSE
        BEGIN
            PRINT('Data rozpoczęcia semestru musi być wcześniejsza niż data zakończenia.');
        END
    END
    ELSE
    BEGIN
        PRINT('Semestr o podanym numerze już istnieje.');
    END;
    RETURN 1;
END;

CREATE OR ALTER PROCEDURE ModifyStudies
    @StudiesID INT,
    @Name NVARCHAR(max),
    @Description NVARCHAR(max),
    @CoordinatorID INT,
    @StartDate DATE,
    @EndDate DATE,
    @MaxStudents INT,
    @LanguageID INT,
    @FieldOfStudiesID INT,
    @SemesterNumber INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Sprawdź, czy StartDate < EndDate, MaxStudents > 0, istnieją CoordinatorID, LanguageID, FieldOfStudiesID, SemesterNumber > 0
    IF (@StartDate < @EndDate AND
        @MaxStudents > 0 AND
        EXISTS (SELECT 1 FROM Employees WHERE EmployeeID = @CoordinatorID) AND
        EXISTS (SELECT 1 FROM Languages WHERE LanguageID = @LanguageID) AND
        EXISTS (SELECT 1 FROM FieldsOfStudies WHERE FieldOfStudiesID = @FieldOfStudiesID) AND
        @SemesterNumber > 0)
    BEGIN
        -- Modyfikuj dane semestru studiów
        UPDATE Studies
        SET Name = @Name,
            Description = @Description,
            CoordinatorID = @CoordinatorID,
            StartDate = @StartDate,
            EndDate = @EndDate,
            MaxStudents = @MaxStudents,
            LanguageID = @LanguageID,
            FieldOfStudiesID = @FieldOfStudiesID,
            SemesterNumber = @SemesterNumber
        WHERE StudiesID = @StudiesID; 

        PRINT 'Dane semestru studiów zostały zaktualizowane.';
        RETURN 0;
    END
    ELSE
    BEGIN
        PRINT 'Nie spełniono warunków modyfikacji danych semestru studiów.';
    END
    RETURN 1;
END;

CREATE OR ALTER PROCEDURE AddSubjectStudies
    @StudiesID INT,
    @Description NVARCHAR(max),
    @CoordinatorID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Sprawdź, czy istnieje studium o podanym StudiesID
    IF EXISTS (SELECT 1 FROM Studies WHERE StudiesID = @StudiesID)
    BEGIN
        -- Sprawdź, czy istnieje koordynator o podanym CoordinatorID
        IF EXISTS (SELECT 1 FROM Employees WHERE EmployeeID = @CoordinatorID)
        BEGIN
            -- Dodaj nowy przedmiot do tabeli Subjects
            INSERT INTO Subjects (StudiesID, Description, CoordinatorID)
            VALUES (@StudiesID, @Description, @CoordinatorID);

            PRINT 'Przedmiot został dodany do studiów.';
            RETURN 0;
        END
        ELSE
        BEGIN
            PRINT 'Koordynator o podanym CoordinatorID nie istnieje.';
        END
    END
    ELSE
    BEGIN
        PRINT 'Studium o podanym StudiesID nie istnieje.';
    END
    RETURN 1;
END;

CREATE OR ALTER PROCEDURE ModifySubjectStudies
    @SubjectID INT,
    @StudiesID INT,
    @Description NVARCHAR(max),
    @CoordinatorID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Sprawdź, czy istnieją CoordinatorID i StudiesID
    IF (EXISTS (SELECT 1 FROM Employees WHERE EmployeeID = @CoordinatorID) AND
        EXISTS (SELECT 1 FROM Studies WHERE StudiesID = @StudiesID))
    BEGIN
        -- Modyfikuj przedmiot w tabeli Subjects
        UPDATE Subjects
        SET StudiesID = @StudiesID,
            Description = @Description,
            CoordinatorID = @CoordinatorID
        WHERE SubjectID = @SubjectID;

        PRINT 'Przedmiot został zaktualizowany.';
        RETURN 0;
    END
    ELSE
    BEGIN
        PRINT 'Nie spełniono warunków modyfikacji przedmiotu.';
    END
    RETURN 1;
END;

CREATE OR ALTER PROCEDURE AddStudySession
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

CREATE OR ALTER PROCEDURE AddOnlineStudySession
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

CREATE OR ALTER PROCEDURE ModifyStudySession
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

CREATE OR ALTER PROCEDURE ModifyOnlineStudySession
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

CREATE OR ALTER PROCEDURE AddStationaryStudySession
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

CREATE OR ALTER PROCEDURE ModifyStationaryStudiesSession
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

CREATE OR ALTER PROCEDURE AddSubjectMakeUpPossibility
    @SubjectID INT,
    @ProductID INT,
    @AttendanceValue INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Sprawdź czy istnieją podane wartości
    IF EXISTS (SELECT 1 FROM Subjects WHERE SubjectID = @SubjectID) AND
       EXISTS (SELECT 1 FROM Products WHERE ProductID = @ProductID) AND
       @AttendanceValue > 0
    BEGIN
        -- Dodaj nowy wpis do SubjectMakeUpPossibilities
        INSERT INTO SubjectMakeUpPossibilities (SubjectID, ProductID, AttendanceValue)
        VALUES (@SubjectID, @ProductID, @AttendanceValue);

        PRINT 'Dodano nowy wpis do SubjectMakeUpPossibilities.';
        RETURN 0;
    END
    ELSE
    BEGIN
        PRINT 'Podane wartości są nieprawidłowe.';
        RETURN 1;
    END
END;

CREATE OR ALTER PROCEDURE UpdateSubjectMakeUpPossibility
    @SubjectID INT,
    @ProductID INT,
    @AttendanceValue INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Sprawdź czy istnieją podane wartości
    IF EXISTS (SELECT 1 FROM Subjects WHERE SubjectID = @SubjectID) AND
       EXISTS (SELECT 1 FROM Products WHERE ProductID = @ProductID) AND
       @AttendanceValue > 0
    BEGIN
        -- Modyfikuj istniejący wpis w SubjectMakeUpPossibilities
        UPDATE SubjectMakeUpPossibilities
        SET AttendanceValue = @AttendanceValue
        WHERE SubjectID = @SubjectID AND ProductID = @ProductID;

        PRINT 'Zaktualizowano wpis w SubjectMakeUpPossibilities.';
        RETURN 0;
    END
    ELSE
    BEGIN
        PRINT 'Podane wartości są nieprawidłowe.';
        RETURN 1;
    END
END;

CREATE OR ALTER PROCEDURE RemoveSubjectMakeUpPossibility
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

CREATE OR ALTER PROCEDURE AddStudiesSessionAttendance
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

CREATE OR ALTER PROCEDURE ModifyStudiesSessionAttendance
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

CREATE OR ALTER PROCEDURE AddPublicStudySession
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
