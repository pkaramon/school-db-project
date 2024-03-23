CREATE PROCEDURE AddStudySemester
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