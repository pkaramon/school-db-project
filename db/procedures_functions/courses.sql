-- Procedura tworząca kurs.
CREATE OR ALTER PROCEDURE CreateCourse
    @CourseName nvarchar(max),
    @Description nvarchar(max),
    @StartDate datetime,
    @EndDate datetime,
    @CoordinatorID int,
    @MaxStudents int = NULL,  -- Nullable
    @LanguageID int,
    @Price money,
    @AdvancePayment money
AS
BEGIN
    -- Insert into Products table and capture the new ProductID
    DECLARE @NewProductID int;

    INSERT INTO Products (Price, AdvancePayment, ProductType)
    VALUES (@Price, @AdvancePayment, 'course');

    SET @NewProductID = SCOPE_IDENTITY();

    -- Insert into Courses table using the new ProductID
    INSERT INTO Courses (CourseID, CourseName, Description, StartDate, EndDate, CoordinatorID, MaxStudents, LanguageID)
    VALUES (@NewProductID, @CourseName, @Description, @StartDate, @EndDate, @CoordinatorID, @MaxStudents, @LanguageID);

    -- Print confirmation message
    PRINT 'Course created successfully.';
END;
GO

-- Procedura modyfikująca kurs.
CREATE OR ALTER PROCEDURE ModifyCourse
    @CourseID int,
    @NewCourseName nvarchar(max) = NULL,
    @NewDescription nvarchar(max) = NULL,
    @NewStartDate datetime = NULL,
    @NewEndDate datetime = NULL,
    @NewCoordinatorID int = NULL,
    @NewMaxStudents int = NULL,
    @NewLanguageID int = NULL
AS
BEGIN
    -- Update the Courses table
    UPDATE Courses
    SET CourseName = COALESCE(@NewCourseName, CourseName),
        Description = COALESCE(@NewDescription, Description),
        StartDate = COALESCE(@NewStartDate, StartDate),
        EndDate = COALESCE(@NewEndDate, EndDate),
        CoordinatorID = COALESCE(@NewCoordinatorID, CoordinatorID),
        MaxStudents = COALESCE(@NewMaxStudents, MaxStudents),
        LanguageID = COALESCE(@NewLanguageID, LanguageID)
    WHERE CourseID = @CourseID;

    -- Print confirmation message
    PRINT 'Course data updated successfully.';
END;
GO


-- Procedura tworząca moduł kursu.
CREATE OR ALTER PROCEDURE CreateModule
    @CourseID int,
    @ModuleName nvarchar(max),
    @ModuleDescription nvarchar(max)
AS
BEGIN
    -- Insert the new module into the Modules table
    INSERT INTO Modules (CourseID, ModuleName, ModuleDescription)
    VALUES (@CourseID, @ModuleName, @ModuleDescription);

    -- Print confirmation message
    PRINT 'Module created successfully.';
END;
GO

-- Procedura modyfikująca moduł kursu.
CREATE OR ALTER PROCEDURE ModifyModule
    @ModuleID int,
    @NewModuleName nvarchar(max) = NULL,
    @NewModuleDescription nvarchar(max) = NULL
AS
BEGIN
    -- Update the Modules table
    UPDATE Modules
    SET ModuleName = COALESCE(@NewModuleName, ModuleName),
        ModuleDescription = COALESCE(@NewModuleDescription, ModuleDescription)
    WHERE ModuleID = @ModuleID;

    -- Print confirmation message
    PRINT 'Module updated successfully.';
END;
GO

-- Procedura usuwająca moduł kursu.
CREATE OR ALTER PROCEDURE DeleteModule
    @ModuleID int
AS
BEGIN
    -- Delete the specified module from the Modules table
    DELETE FROM Modules
    WHERE ModuleID = @ModuleID;

    -- Print confirmation message
    PRINT 'Module deleted successfully.';
END;
GO


-- Procedura modyfikująca sesję online kursu.
CREATE OR ALTER PROCEDURE ModifyOnlineCourseSession
    @CourseSessionID int,
    @LanguageID int = NULL,
    @ModuleID int = NULL,
    @LecturerID int = NULL,
    @TranslatorID int = NULL,
    @StartDate datetime = NULL,
    @EndDate datetime = NULL,
    @WebinarLink nvarchar(max) = NULL,
    @RecordingLink nvarchar(max) = NULL
AS
BEGIN
    -- Update the general course session details
    UPDATE CoursesSessions
    SET LanguageID = COALESCE(@LanguageID, LanguageID),
        ModuleID = COALESCE(@ModuleID, ModuleID),
        LecturerID = COALESCE(@LecturerID, LecturerID),
        TranslatorID = COALESCE(@TranslatorID, TranslatorID)
    WHERE CourseSessionID = @CourseSessionID;

    -- Update the online-specific details
    UPDATE CourseOnlineSessions
    SET StartDate = COALESCE(@StartDate, StartDate),
        EndDate = COALESCE(@EndDate, EndDate),
        WebinarLink = COALESCE(@WebinarLink, WebinarLink),
        RecordingLink = COALESCE(@RecordingLink, RecordingLink)
    WHERE CourseOnlineSessionID = @CourseSessionID;

    PRINT 'Online course session modified successfully.';
END;
GO

-- Procedura modyfikująca sesję offline kursu.
CREATE OR ALTER PROCEDURE ModifyOfflineCourseSession
    @CourseSessionID int,
    @LanguageID int = NULL,
    @ModuleID int = NULL,
    @LecturerID int = NULL,
    @TranslatorID int = NULL,
    @Link nvarchar(max) = NULL,
    @Description nvarchar(max) = NULL
AS
BEGIN
    -- Update the general course session details
    UPDATE CoursesSessions
    SET LanguageID = COALESCE(@LanguageID, LanguageID),
        ModuleID = COALESCE(@ModuleID, ModuleID),
        LecturerID = COALESCE(@LecturerID, LecturerID),
        TranslatorID = COALESCE(@TranslatorID, TranslatorID)
    WHERE CourseSessionID = @CourseSessionID;

    -- Update the offline-specific details
    UPDATE CourseOfflineSessions
    SET Link = COALESCE(@Link, Link),
        Description = COALESCE(@Description, Description)
    WHERE CourseOfflineSessionID = @CourseSessionID;

    PRINT 'Offline course session modified successfully.';
END;
GO

-- Procedura modyfikująca stacjonarną sesję kursu.
CREATE OR ALTER PROCEDURE ModifyStationaryCourseSession
    @CourseSessionID int,
    @LanguageID int = NULL,
    @ModuleID int = NULL,
    @LecturerID int = NULL,
    @TranslatorID int = NULL,
    @StartDate datetime = NULL,
    @EndDate datetime = NULL,
    @Address nvarchar(500) = NULL,
    @City nvarchar(500) = NULL,
    @Country nvarchar(500) = NULL,
    @PostalCode nvarchar(20) = NULL,
    @ClassroomNumber nvarchar(30) = NULL,
    @MaxStudents int = NULL
AS
BEGIN
    -- Update the general course session details
    UPDATE CoursesSessions
    SET LanguageID = COALESCE(@LanguageID, LanguageID),
        ModuleID = COALESCE(@ModuleID, ModuleID),
        LecturerID = COALESCE(@LecturerID, LecturerID),
        TranslatorID = COALESCE(@TranslatorID, TranslatorID)
    WHERE CourseSessionID = @CourseSessionID;

    -- Update the stationary-specific details
    UPDATE CourseStationarySessions
    SET StartDate = COALESCE(@StartDate, StartDate),
        EndDate = COALESCE(@EndDate, EndDate),
        Address = COALESCE(@Address, Address),
        City = COALESCE(@City, City),
        Country = COALESCE(@Country, Country),
        PostalCode = COALESCE(@PostalCode, PostalCode),
        ClassroomNumber = COALESCE(@ClassroomNumber, ClassroomNumber),
        MaxStudents = COALESCE(@MaxStudents, MaxStudents)
    WHERE CourseStationarySessionID = @CourseSessionID;

    PRINT 'Stationary course session modified successfully.';
END;
GO

-- Procedura usuwająca sesję kursu.
CREATE OR ALTER PROCEDURE DeleteCourseSession
    @CourseSessionID int
AS
BEGIN
    -- Delete the course session from the CoursesSessions table
    -- Associated records in other session tables will be deleted automatically due to ON DELETE CASCADE constraints
    DELETE FROM CoursesSessions WHERE CourseSessionID = @CourseSessionID;

    PRINT 'Course session and its associated records deleted successfully.';
END;
GO

-- Procedura aktualizująca obecność na kursie.
CREATE OR ALTER PROCEDURE UpdateAttendance
    @CourseParticipantID int,
    @CourseSessionID int,
    @WasPresent bit
AS
BEGIN
    IF EXISTS (SELECT 1 FROM CourseSessionsAttendance WHERE CourseParticipantID = @CourseParticipantID AND CourseSessionID = @CourseSessionID)
    BEGIN
        -- Update existing record
        UPDATE CourseSessionsAttendance
        SET Completed = @WasPresent
        WHERE CourseParticipantID = @CourseParticipantID AND CourseSessionID = @CourseSessionID;
    END
    ELSE
    BEGIN
        -- Insert new record
        INSERT INTO CourseSessionsAttendance (CourseParticipantID, CourseSessionID, Completed)
        VALUES (@CourseParticipantID, @CourseSessionID, @WasPresent);
    END

    PRINT 'Attendance record updated successfully.';
END;
GO

-- Procedura usuwająca obecność na kursie.
CREATE OR ALTER PROCEDURE DeleteAttendance
    @CourseParticipantID int,
    @CourseSessionID int
AS
BEGIN
    -- Delete the attendance record
    DELETE FROM CourseSessionsAttendance
    WHERE CourseParticipantID = @CourseParticipantID AND CourseSessionID = @CourseSessionID;

    PRINT 'Attendance record deleted successfully.';
END;
GO


-- Procedura odtwarzająca nagranie sesji offline.
CREATE OR ALTER PROCEDURE PlayOfflineSessionRecording
    @CourseParticipantID int,
    @CourseOfflineSessionID int,
    @SessionLink nvarchar(max) OUTPUT
AS
BEGIN
    -- Check if attendance already exists
    IF NOT EXISTS (SELECT 1 FROM CourseSessionsAttendance WHERE CourseParticipantID = @CourseParticipantID AND CourseSessionID = @CourseOfflineSessionID)
    BEGIN
        -- Insert attendance record as 'present' if it doesn't exist
        INSERT INTO CourseSessionsAttendance (CourseParticipantID, CourseSessionID, Completed)
        VALUES (@CourseParticipantID, @CourseOfflineSessionID, 1);
    END

    -- Retrieve the link to the offline session
    SELECT @SessionLink = Link FROM CourseOfflineSessions WHERE CourseOfflineSessionID = @CourseOfflineSessionID;

    -- Return the session link
    RETURN;
END;
GO

-- Funkcja pobierająca link do nagrania sesji online.
CREATE OR ALTER FUNCTION GetOnlineSessionRecordingLink
(
    @CourseOnlineSessionID int
)
RETURNS nvarchar(max)
AS
BEGIN
    DECLARE @RecordingLink nvarchar(max);

    -- Retrieve the link to the online session recording
    SELECT @RecordingLink = RecordingLink 
    FROM CourseOnlineSessions 
    WHERE CourseOnlineSessionID = @CourseOnlineSessionID;

    -- Return the session recording link
    RETURN @RecordingLink;
END;
GO

-- Procedura aktualizująca obecność na sesji kursu.
CREATE OR ALTER PROCEDURE UpdateCourseSessionAttendance
    @CourseParticipantID int,
    @CourseSessionID int,
    @WasPresent bit
AS
BEGIN
    IF EXISTS (SELECT 1 FROM CourseSessionsAttendance WHERE CourseParticipantID = @CourseParticipantID AND CourseSessionID = @CourseSessionID)
    BEGIN
        -- Update existing record
        UPDATE CourseSessionsAttendance
        SET Completed = @WasPresent
        WHERE CourseParticipantID = @CourseParticipantID AND CourseSessionID = @CourseSessionID;
    END
    ELSE
    BEGIN
        -- Insert new record
        INSERT INTO CourseSessionsAttendance (CourseParticipantID, CourseSessionID, Completed)
        VALUES (@CourseParticipantID, @CourseSessionID, @WasPresent);
    END
END;
GO

-- Usuń wpis do listy obecności.
CREATE OR ALTER PROCEDURE DeleteCourseSessionAttendance
    @CourseParticipantID int,
    @CourseSessionID int
AS
BEGIN
    -- Delete the attendance record
    DELETE FROM CourseSessionsAttendance
    WHERE CourseParticipantID = @CourseParticipantID AND CourseSessionID = @CourseSessionID;
END;
GO

-- Procedura zamykająca kurs. Sprawdza ona na podstawie obecności kto zaliczył kurs i wpisuje zaliczenie.
CREATE OR ALTER PROCEDURE CloseCourse(@CourseID INT)
AS
BEGIN
    -- Start the transaction
    BEGIN TRANSACTION

    BEGIN TRY
        -- Update the ClosedAt date for the course in Products table
        UPDATE Products
        SET ClosedAt = GETDATE()
        FROM Products
        INNER JOIN Courses ON Products.ProductID = Courses.CourseID
        WHERE Courses.CourseID = @CourseID

        -- Get the minimum attendance percentage for the course
        DECLARE @MinAttendancePercentage DECIMAL(6, 4)
        SELECT @MinAttendancePercentage = dbo.GetMinAttendancePercentageForCourse(@CourseID)

        -- Temporary table to store module attendance for each participant
        DECLARE @ModuleAttendanceStats TABLE (CourseParticipantID INT, ModuleID INT, AllSessionsCompleted BIT)

        -- Insert module attendance stats for each participant
        INSERT INTO @ModuleAttendanceStats (CourseParticipantID, ModuleID, AllSessionsCompleted)
        SELECT 
            cp.CourseParticipantID,
            cs.ModuleID,
            CASE WHEN COUNT(csa.CourseSessionID) = SUM(CASE WHEN csa.Completed = 1 THEN 1 ELSE 0 END) THEN 1 ELSE 0 END
        FROM 
            CourseParticipants cp
    INNER JOIN 
            CourseSessionsAttendance csa ON cp.CourseParticipantID = csa.CourseParticipantID
    INNER JOIN 
            CoursesSessions cs ON cs.CourseSessionID = csa.CourseSessionID
        WHERE 
            cp.CourseID = @CourseID
        GROUP BY 
            cp.CourseParticipantID, cs.ModuleID

        -- Update the CourseParticipants table for those who have completed the course
        UPDATE cp
        SET Completed = 1
        FROM CourseParticipants cp
        WHERE cp.CourseID = @CourseID
        AND 
        (
            SELECT CAST(CAST(SUM(CAST(mat.AllSessionsCompleted AS INT)) AS DECIMAL) / NULLIF(COUNT(mat.ModuleID), 0) AS DECIMAL(5, 2))
            FROM @ModuleAttendanceStats mat
            WHERE mat.CourseParticipantID = cp.CourseParticipantID
        ) >= @MinAttendancePercentage

        -- Commit the transaction
        COMMIT
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of error
        ROLLBACK

        PRINT('Couldnt close the course');
    END CATCH
END;
GO

-- Modyfikuj nagranie z CourseOnlineSession
CREATE OR ALTER PROCEDURE ModifyCourseOnlineSessionRecording
    @CourseOnlineSessionID INT,
    @NewRecordingLink NVARCHAR(MAX)
AS
BEGIN
    UPDATE CourseOnlineSessions
    SET RecordingLink = @NewRecordingLink
    WHERE CourseOnlineSessionID = @CourseOnlineSessionID;
END;
GO