CREATE PROCEDURE DeleteStudyDirection
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