CREATE PROCEDURE ModifySubjectStudies
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