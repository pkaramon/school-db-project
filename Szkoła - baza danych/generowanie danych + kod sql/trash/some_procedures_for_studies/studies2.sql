CREATE PROCEDURE AddFieldOfStudy
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