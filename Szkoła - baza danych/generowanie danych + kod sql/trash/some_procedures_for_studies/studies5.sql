CREATE PROCEDURE ModifyStudies
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