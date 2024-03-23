CREATE PROCEDURE UpdateSubjectMakeUpPossibility
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
