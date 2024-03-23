-- Procedura do tworzenia nowego webinaru.
CREATE OR ALTER PROCEDURE AddWebinar
    @WebinarName nvarchar(max),
    @Description nvarchar(max),
    @StartDate datetime,
    @EndDate datetime,
    @WebinarLink nvarchar(max),
    @LecturerID int,
    @TranslatorID int,
    @LanguageID int,
    @Price money
AS
BEGIN
    -- Insert into Products table
    INSERT INTO Products(Price, AdvancePayment, ProductType)
    VALUES (@Price, NULL, 'webinar')

    -- Get the last inserted ProductID
    DECLARE @ProductID int
    SET @ProductID = SCOPE_IDENTITY()

    -- Insert into Webinars table
    INSERT INTO Webinars(WebinarID, WebinarName, Description, StartDate, EndDate, WebinarLink, LecturerID, TranslatorID, LanguageID)
    VALUES (@ProductID, @WebinarName, @Description, @StartDate, @EndDate, @WebinarLink, @LecturerID, @TranslatorID, @LanguageID)
END;
GO

-- Procedura do modyfikacji danych webinaru.
CREATE OR ALTER PROCEDURE ModifyWebinarData
    @WebinarID INT,
    @WebinarName NVARCHAR(MAX),
    @Description NVARCHAR(MAX),
    @StartDate DATETIME,
    @EndDate DATETIME,
    @RecordingLink NVARCHAR(MAX) = NULL,
    @WebinarLink NVARCHAR(MAX),
    @LecturerID INT,
    @LanguageID INT,
    @RecordingReleaseDate DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if the WebinarID exists in the Webinars table
    IF EXISTS (SELECT 1 FROM Webinars WHERE WebinarID = @WebinarID)
    BEGIN
        -- Update the Webinars table with the provided data
        UPDATE Webinars
        SET 
            WebinarName = @WebinarName,
            Description = @Description,
            StartDate = @StartDate,
            EndDate = @EndDate,
            RecordingLink = CASE WHEN @RecordingLink = '' THEN NULL ELSE @RecordingLink END,
            WebinarLink = @WebinarLink,
            LecturerID = @LecturerID,
            LanguageID = @LanguageID,
            RecordingReleaseDate = CASE WHEN @RecordingReleaseDate = '' THEN NULL ELSE @RecordingReleaseDate END
        WHERE WebinarID = @WebinarID;

        -- Return success message or handle any additional logic as needed
        PRINT 'Webinar data has been modified successfully.';
    END
    ELSE
    BEGIN
        -- Handle the case where the WebinarID does not exist
        PRINT 'Webinar with ID ' + CAST(@WebinarID AS NVARCHAR(MAX)) + ' does not exist.';
    END
END;
GO

-- Procedura do usuwania webinaru.
CREATE OR ALTER PROCEDURE DeleteWebinar @WebinarID INT
AS
BEGIN
    -- Transaction ensures all or nothing operation
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Step 1: Delete from WebinarsAttendence
        DELETE FROM WebinarsAttendence
        WHERE WebinarID = @WebinarID;

        -- Step 2: Delete from WebinarParticipants
        DELETE FROM WebinarParticipants
        WHERE WebinarID = @WebinarID;

        -- Step 3: Delete the webinar from Webinars
        DELETE FROM Webinars
        WHERE WebinarID = @WebinarID;

        -- If everything is okay, commit the transaction
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- If there is an error, roll back the transaction
        ROLLBACK TRANSACTION;
        THROW; -- Re-throw the caught exception to the caller
    END CATCH
END;
GO

-- Procedura do otwarcia webinaru przez uczestnika.
CREATE OR ALTER PROCEDURE OpenWebinar @WebinarParticipantID INT
AS
BEGIN
    DECLARE @WebinarID INT;
    DECLARE @CurrentTime DATETIME = GETDATE();
    DECLARE @WebinarLink NVARCHAR(MAX);

    -- Find the WebinarID associated with the participant
    SELECT @WebinarID = WebinarID FROM WebinarParticipants WHERE WebinarParticipantID = @WebinarParticipantID;

    -- Check if the Webinar is currently ongoing
    IF EXISTS (SELECT 1 FROM Webinars WHERE WebinarID = @WebinarID AND StartDate <= @CurrentTime AND EndDate >= @CurrentTime)
    BEGIN
        -- Check if the participant is not already marked as present
        IF NOT EXISTS (SELECT 1 FROM WebinarsAttendence WHERE WebinarParticipantID = @WebinarParticipantID AND WebinarID = @WebinarID)
        BEGIN
            -- Mark the participant as present
            INSERT INTO WebinarsAttendence (WebinarID, WebinarParticipantID, WasPresent)
            VALUES (@WebinarID, @WebinarParticipantID, 1);
        END

        -- Get the webinar link
        SELECT @WebinarLink = WebinarLink FROM Webinars WHERE WebinarID = @WebinarID;

    -- Return the link to the caller or perform any other needed action with it
    SELECT @WebinarLink AS WebinarLink;
END
ELSE
BEGIN
    -- Handle the case where the webinar is not ongoing
    RAISERROR('The webinar is not currently ongoing or does not exist.', 16, 1);
END
END;
GO

-- Procedura do wyświetlania nagrania webinaru.
CREATE OR ALTER PROCEDURE DisplayWebinarRecording @WebinarParticipantID INT
AS
BEGIN
    DECLARE @WebinarID INT;
    DECLARE @RecordingReleaseDate DATE;
    DECLARE @AddedAt DATETIME;
    DECLARE @RecordingLink NVARCHAR(MAX);
    DECLARE @AccessDays INT;
    DECLARE @AccessStartDate DATETIME;
    DECLARE @AccessEndDate DATETIME;

    -- Find the WebinarID and AddedAt for the participant
    SELECT @WebinarID = WebinarID, @AddedAt = AddedAt
    FROM WebinarParticipants
    WHERE WebinarParticipantID = @WebinarParticipantID;

    -- Get the recording release date and recording link for the webinar
    SELECT @RecordingReleaseDate = RecordingReleaseDate, @RecordingLink = RecordingLink
    FROM Webinars
    WHERE WebinarID = @WebinarID;

    -- Check if recording is available
    IF @RecordingReleaseDate IS NOT NULL AND @RecordingLink IS NOT NULL
    BEGIN
        -- Get the number of access days
        SET @AccessDays = dbo.GetRecordingAccessDays(@WebinarID);

        -- Calculate the start date for recording access using the later of RecordingReleaseDate or AddedAt
        SET @AccessStartDate = CASE 
                                WHEN @RecordingReleaseDate > @AddedAt THEN @RecordingReleaseDate 
                                ELSE @AddedAt 
                               END;

        -- Calculate the end date for recording access
        SET @AccessEndDate = DATEADD(DAY, @AccessDays, @AccessStartDate);

        -- Check if the current date is within the access period
        IF GETDATE() <= @AccessEndDate
        BEGIN
            -- Participant is within the access period, return the recording link
            SELECT @RecordingLink AS RecordingLink;
        END
        ELSE
        BEGIN
            -- Participant is not within the access period or other conditions not met
            RAISERROR('Access to the webinar recording is either not available or the access period has expired.', 16, 1
);
END
END
ELSE
BEGIN
-- Recording is not available for this webinar
RAISERROR('There is no recording available for this webinar.', 16, 1);
END
END;
GO


-- Procedura do aktualizacji brakującej obecności na webinarze.
CREATE OR ALTER PROCEDURE UpdateMissingWebinarAttendance
    @WebinarID INT
AS
BEGIN
    -- Insert attendance records only for participants who were not present (WasPresent = 0)
    INSERT INTO WebinarsAttendence (WebinarID, WebinarParticipantID, WasPresent)
    SELECT @WebinarID, WP.WebinarParticipantID, 0
    FROM WebinarParticipants WP
    LEFT JOIN WebinarsAttendence WA ON WP.WebinarParticipantID = WA.WebinarParticipantID AND WA.WebinarID = @WebinarID
    WHERE WP.WebinarID = @WebinarID
    AND WA.WebinarParticipantID IS NULL; -- Exclude participants who are already in the WebinarsAttendence table

    -- Print confirmation message for updating attendance list
    PRINT 'Updated attendance list for Webinar ' + CAST(@WebinarID AS NVARCHAR(10));
END;
GO
  
-- Procedura do zamknięcia webinaru.
CREATE OR ALTER PROCEDURE CloseWebinar
    @WebinarID INT
AS
BEGIN
    -- Update the ClosedAt column in the Products table for the specified WebinarID
    UPDATE Products
    SET ClosedAt = GETDATE()
    WHERE ProductID = @WebinarID;

    -- Print confirmation message
    PRINT 'Webinar with ID ' + CAST(@WebinarID AS NVARCHAR(10)) + ' has been closed.';
END;
GO

-- Procedura do modyfikacji nagrania z Webinaru.
CREATE OR ALTER PROCEDURE ModifyWebinarRecording
    @WebinarID INT,
    @NewRecordingLink NVARCHAR(MAX)
AS
BEGIN
    UPDATE Webinars
    SET RecordingLink = @NewRecordingLink
    WHERE WebinarID = @WebinarID;
END;
GO