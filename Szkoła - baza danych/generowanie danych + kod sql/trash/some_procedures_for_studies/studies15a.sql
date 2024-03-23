CREATE PROCEDURE AddSubjectMakeUpPossibility
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
