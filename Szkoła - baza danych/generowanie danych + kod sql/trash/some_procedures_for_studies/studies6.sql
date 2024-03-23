CREATE PROCEDURE AddSubjectStudies
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