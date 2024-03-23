-- Procedura do tworzenia semestru studiów.
CREATE OR ALTER PROCEDURE CreateSemesterOfStudies
    @Price money,
    @AdvancePayment money,
    @Name nvarchar(max),
    @Description nvarchar(max),
    @CoordinatorID int,
    @StartDate date,
    @EndDate date,
    @MaxStudents int,
    @LanguageID int,
    @FieldOfStudiesID int,
    @SemesterNumber int
AS
BEGIN
    -- Insert into Products table with 'studies' as the ProductType
    INSERT INTO Products (Price, AdvancePayment, ProductType)
    VALUES (@Price, @AdvancePayment, 'studies')

    -- Capture the newly inserted ProductID
    DECLARE @NewProductID int = SCOPE_IDENTITY()

    -- Insert into Studies table
    INSERT INTO Studies (StudiesID, Name, Description, CoordinatorID, StartDate, EndDate, MaxStudents, LanguageID, FieldOfStudiesID, SemesterNumber)
    VALUES (@NewProductID, @Name, @Description, @CoordinatorID, @StartDate, @EndDate, @MaxStudents, @LanguageID, @FieldOfStudiesID, @SemesterNumber)
END;
GO

-- Procedura do usuwania sesji.
CREATE OR ALTER PROCEDURE DeleteSession (
  @SessionID INT
)
AS
BEGIN
  IF EXISTS(
      SELECT PublicStudySessionID FROM PublicStudySessions WHERE PublicStudySessionID = @SessionID
  )
  BEGIN
      RAISERROR ('Cannot delete public sessions', 10, 1)
  END
  IF NOT EXISTS(
      SELECT StudiesSessionID FROM StudiesSessions WHERE StudiesSessionID = @SessionID
  )
  BEGIN
      RAISERROR ('Study session does not exist', 10, 1)
  END
  DELETE FROM StudiesSessions WHERE StudiesSessionID = @SessionID
  PRINT 'Successfully deleted data for study session ' + CAST(@SessionID AS NVARCHAR(10));
END;
GO

-- Funkcja sprawdzająca, czy użytkownik ukończył dany produkt (kurs, webinar, etc.).
CREATE OR ALTER FUNCTION CheckIfUserCompletedProduct (
@UserID INT,
@ProductID INT
)
RETURNS BIT
AS
BEGIN
IF EXISTS (
    SELECT * FROM Students
    WHERE UserID = @UserID AND StudiesID = @ProductID  AND Completed = 1
)
BEGIN
    RETURN 1
END
IF EXISTS(
    SELECT * FROM CourseParticipants
    WHERE UserID = @UserID AND CourseID = @ProductID  AND Completed = 1
)
BEGIN
    RETURN 1
END
IF EXISTS(
    SELECT * FROM WebinarsAttendence WA
JOIN WebinarParticipants WP ON WP.WebinarParticipantID = WA.WebinarParticipantID
    WHERE WP.UserID = @UserID AND WP.WebinarID = @ProductID AND WA.WasPresent = 1
)
BEGIN
    RETURN 1
END
IF EXISTS(
    SELECT * FROM PublicStudySessionsAttendanceForOutsiders A
    JOIN PublicStudySessionParticipants PS ON 
    PS.PublicStudySessionParticipantID = A.PublicStudySessionParticipantID
    WHERE UserID = @UserID AND PS.PublicStudySessionParticipantID = @ProductID AND Completed = 1
)
BEGIN
    RETURN 1
END
RETURN 0
END;
GO

-- Procedura do dodawania udziału w zajęciach zamiennych.
CREATE OR ALTER PROCEDURE InsertMadeUpAttendance (
  @StudentID INT,
  @ProductID INT,
  @SubjectID INT
)
AS
BEGIN
  IF NOT EXISTS(
      SELECT * FROM SubjectMakeUpPossibilities
      WHERE ProductID = @ProductID AND SubjectID = @SubjectID
  )
  BEGIN
      RAISERROR ('This is not a valid make-up possibility.', 10, 1)
  END
  IF EXISTS(
      SELECT * FROM MadeUpAttendance
      WHERE StudentID = @StudentID AND ProductID=@ProductID
  )
  BEGIN
      RAISERROR ('This student already made up the attendance using this product', 10, 1)
  END

  DECLARE @attendance BIT
DECLARE @UserID INT

SELECT @UserID = UserID FROM 
Students WHERE Students.StudentID = @StudentID;

  SET @attendance = dbo.CheckIfUserCompletedProduct(@UserID, @ProductID)

  IF (@attendance = 1)
  BEGIN
      INSERT INTO MadeUpAttendance (SubjectID, ProductID, StudentID)
      VALUES (@SubjectID, @ProductID, @StudentID)
  END
  PRINT 'Succesfully made-up attendance'
END;
GO

-- Procedura do dodawania lub modyfikacji obecności na pojedynczym spotkaniu studyjnym
CREATE OR ALTER PROCEDURE AddOrModifyPublicStudySessionAttendance(
  @ParticipantID INT,
  @SessionID INT,
  @Completed BIT
)
AS
BEGIN
  IF EXISTS(
      SELECT * FROM PublicStudySessionsAttendanceForOutsiders
      WHERE PublicStudySessionID = @SessionID AND PublicStudySessionParticipantID = @ParticipantID
  )
  BEGIN
      UPDATE PublicStudySessionsAttendanceForOutsiders
      SET
          Completed = @Completed
      WHERE
          PublicStudySessionParticipantID = @ParticipantID
      AND PublicStudySessionID = @SessionID
      PRINT 'Attendance already exists. Successfuly modified attendance'
  END
  ELSE
  BEGIN
      INSERT INTO PublicStudySessionsAttendanceForOutsiders (PublicStudySessionID, PublicStudySessionParticipantID, Completed)
      VALUES (@SessionID, @ParticipantID, @Completed)
      PRINT 'Successfully inserted attendance'
  END
END;
GO

-- Procedura do usuwania obecności na pojedynczym spotkaniu studyjnym
CREATE OR ALTER PROCEDURE DeletePublicStudySessionAttendance(
  @ParticipantID INT,
  @SessionID INT
)
AS
BEGIN
  IF EXISTS(
      SELECT * FROM PublicStudySessionsAttendanceForOutsiders
      WHERE PublicStudySessionID = @SessionID AND PublicStudySessionParticipantID = @ParticipantID
  )
  BEGIN
      DELETE FROM PublicStudySessionsAttendanceForOutsiders
      WHERE PublicStudySessionID = @SessionID AND PublicStudySessionParticipantID = @ParticipantID
      PRINT 'Succesfully deleted attendance.'
  END
  ELSE
  BEGIN
      PRINT 'This attendance does not exist.'
  END
END;
GO

-- Procedura do dodawania nowego kierunku studiów.
CREATE OR ALTER PROCEDURE AddFieldOfStudy
  @Name NVARCHAR(MAX),
  @Description NVARCHAR(MAX)
AS
BEGIN
  SET NOCOUNT ON;

  -- Add a new field of study
  INSERT INTO FieldsOfStudies (Name, Description)
  VALUES (@Name, @Description);
  RETURN 0;
END;
GO

-- Procedura do usuwania kierunku studiów.
CREATE OR ALTER PROCEDURE DeleteFieldOfStudies
  @FieldOfStudiesID INT
AS
BEGIN
  SET NOCOUNT ON;

-- Check if there are studies in the given field of study
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
      PRINT('Field of studies cannot be removed because there are studies in it.')
  END
  RETURN 1;
END;
GO



-- Procedura do modyfikacji danych studiów.
CREATE OR ALTER PROCEDURE ModifyStudies
  @StudiesID int,
  @Name nvarchar(max) = NULL,
  @Description nvarchar(max) = NULL,
  @CoordinatorID int = NULL,
  @StartDate Date = NULL,
  @EndDate Date = NULL,
  @MaxStudents int = NULL,
  @LanguageID int = NULL,
  @FieldOfStudiesID int = NULL,
  @SemesterNumber int = NULL
AS
BEGIN
  -- Update the Studies table
  UPDATE Studies
  SET 
      Name = ISNULL(@Name, Name),
      Description = ISNULL(@Description, Description),
      CoordinatorID = ISNULL(@CoordinatorID, CoordinatorID),
      StartDate = ISNULL(@StartDate, StartDate),
      EndDate = ISNULL(@EndDate, EndDate),
      MaxStudents = ISNULL(@MaxStudents, MaxStudents),
      LanguageID = ISNULL(@LanguageID, LanguageID),
      FieldOfStudiesID = ISNULL(@FieldOfStudiesID, FieldOfStudiesID),
      SemesterNumber = ISNULL(@SemesterNumber, SemesterNumber)
  WHERE StudiesID = @StudiesID;
END;
GO


-- Procedura do tworzenia przedmiotu.
CREATE OR ALTER PROCEDURE CreateSubject
  @StudiesID int,
  @Description nvarchar(max),
  @CoordinatorID int,
  @SubjectName nvarchar(max)
AS
BEGIN
  -- Insert the new subject into the Subjects table
  INSERT INTO Subjects (StudiesID, Description, CoordinatorID, SubjectName)
  VALUES (@StudiesID, @Description, @CoordinatorID, @SubjectName);
END;
GO

-- Procedura do modyfikacji przedmiotu.
CREATE OR ALTER PROCEDURE ModifySubject
  @SubjectID int,
  @StudiesID int = NULL,
  @Description nvarchar(max) = NULL,
  @CoordinatorID int = NULL,
  @SubjectName nvarchar(max) = NULL
AS
BEGIN
  -- Update the Subjects table
  UPDATE Subjects
  SET 
      StudiesID = COALESCE(@StudiesID, StudiesID),
      Description = COALESCE(@Description, Description),
      CoordinatorID = COALESCE(@CoordinatorID, CoordinatorID),
      SubjectName = COALESCE(@SubjectName, SubjectName)
  WHERE SubjectID = @SubjectID;
END;
GO


-- Procedura do modyfikacji sesji studiów.
CREATE OR ALTER PROCEDURE ModifyStudySession
  @StudiesSessionID int,
  @SubjectID int = NULL,
  @StartDate datetime = NULL,
  @EndDate datetime = NULL,
  @LecturerID int = NULL,
  @MaxStudents int = NULL,
  @TranslatorID int = NULL,
  @LanguageID int = NULL
AS
BEGIN
  UPDATE StudiesSessions
  SET 
      SubjectID = COALESCE(@SubjectID, SubjectID),
      StartDate = COALESCE(@StartDate, StartDate),
      EndDate = COALESCE(@EndDate, EndDate),
      LecturerID = COALESCE(@LecturerID, LecturerID),
      MaxStudents = COALESCE(@MaxStudents, MaxStudents),
      TranslatorID = COALESCE(@TranslatorID, TranslatorID),
      LanguageID = COALESCE(@LanguageID, LanguageID)
  WHERE StudiesSessionID = @StudiesSessionID;
END;
GO

-- Procedura do dodawania sesji stacjonarnych studiów.
CREATE OR ALTER PROCEDURE CreateStationaryStudySession
  @SubjectID int,
  @StartDate datetime,
  @EndDate datetime,
  @LecturerID int,
  @MaxStudents int,
  @TranslatorID int = NULL,
  @LanguageID int,
  @Address nvarchar(500),
  @City nvarchar(500),
  @Country nvarchar(500),
  @PostalCode nvarchar(20),
  @ClassroomNumber nvarchar(30)
AS
BEGIN
  -- Insert into StudiesSessions table
  INSERT INTO StudiesSessions (SubjectID, StartDate, EndDate, LecturerID, MaxStudents, TranslatorID, LanguageID)
  VALUES (@SubjectID, @StartDate, @EndDate, @LecturerID, @MaxStudents, @TranslatorID, @LanguageID);

  -- Capture the newly created StudiesSession ID
  DECLARE @NewSessionID int;
  SET @NewSessionID = SCOPE_IDENTITY();

  -- Insert the location details into StationaryStudiesSessions
  INSERT INTO StationaryStudiesSessions (StationaryStudiesSessionID, Address, City, Country, PostalCode, ClassroomNumber)
  VALUES (@NewSessionID, @Address, @City, @Country, @PostalCode, @ClassroomNumber);
END;
GO

-- Procedura do modyfikacji sesji stacjonarnych studiów.
CREATE OR ALTER PROCEDURE ModifyStationaryStudySession
  @StudiesSessionID int,
  @SubjectID int = NULL,
  @StartDate datetime = NULL,
  @EndDate datetime = NULL,
  @LecturerID int = NULL,
  @MaxStudents int = NULL,
  @TranslatorID int = NULL,
  @LanguageID int = NULL,
  @Address nvarchar(500) = NULL,
  @City nvarchar(500) = NULL,
  @Country nvarchar(500) = NULL,
  @PostalCode nvarchar(20) = NULL,
  @ClassroomNumber nvarchar(30) = NULL
AS
BEGIN
  -- Update the StudiesSessions table
  EXEC ModifyStudySession @StudiesSessionID, @SubjectID, @StartDate, @EndDate, @LecturerID, @MaxStudents, @TranslatorID, @LanguageID;

  -- Update the StationaryStudiesSessions table
  UPDATE StationaryStudiesSessions
  SET 
      Address = COALESCE(@Address, Address),
      City = COALESCE(@City, City),
      Country = COALESCE(@Country, Country),
      PostalCode = COALESCE(@PostalCode, PostalCode),
      ClassroomNumber = COALESCE(@ClassroomNumber, ClassroomNumber)
  WHERE StationaryStudiesSessionID = @StudiesSessionID;
END;
GO

-- Procedura do dodawania sesji online studiów.
CREATE OR ALTER PROCEDURE AddOnlineStudySession
  @SubjectID int,
  @StartDate datetime,
  @EndDate datetime,
  @LecturerID int,
  @MaxStudents int,
  @TranslatorID int = NULL,
  @LanguageID int,
  @WebinarLink nvarchar(max),
  @RecordingLink nvarchar(max) = NULL
AS
BEGIN
  -- Insert into StudiesSessions table
  INSERT INTO StudiesSessions (SubjectID, StartDate, EndDate, LecturerID, MaxStudents, TranslatorID, LanguageID)
  VALUES (@SubjectID, @StartDate, @EndDate, @LecturerID, @MaxStudents, @TranslatorID, @LanguageID);

  -- Capture the newly created StudiesSession ID
  DECLARE @NewSessionID int;
  SET @NewSessionID = SCOPE_IDENTITY();

  -- Insert the online studies session details
  INSERT INTO OnlineStudiesSessions (OnlineStudiesSessionID, WebinarLink, RecordingLink)
  VALUES (@NewSessionID, @WebinarLink, @RecordingLink);
END;
GO

-- Procedura do modyfikacji sesji online studiów.
CREATE OR ALTER PROCEDURE ModifyOnlineStudySession
  @OnlineStudiesSessionID int,
  @WebinarLink nvarchar(max) = NULL,
  @RecordingLink nvarchar(max) = NULL,
  -- Parameters for modifying StudiesSessions fields
  @SubjectID int = NULL,
  @StartDate datetime = NULL,
  @EndDate datetime = NULL,
  @LecturerID int = NULL,
  @MaxStudents int = NULL,
  @TranslatorID int = NULL,
  @LanguageID int = NULL
AS
BEGIN
  -- Update the OnlineStudiesSessions table
  UPDATE OnlineStudiesSessions
  SET 
      WebinarLink = COALESCE(@WebinarLink, WebinarLink),
      RecordingLink = COALESCE(@RecordingLink, RecordingLink)
  WHERE OnlineStudiesSessionID = @OnlineStudiesSessionID;

  -- Update the StudiesSessions table
  IF @SubjectID IS NOT NULL OR @StartDate IS NOT NULL OR @EndDate IS NOT NULL OR @LecturerID IS NOT NULL OR @MaxStudents IS NOT NULL OR @TranslatorID IS NOT NULL OR @LanguageID IS NOT NULL
  BEGIN
      EXEC ModifyStudySession 
          @StudiesSessionID = @OnlineStudiesSessionID,
          @SubjectID = @SubjectID, 
          @StartDate = @StartDate, 
          @EndDate = @EndDate, 
          @LecturerID = @LecturerID, 
          @MaxStudents = @MaxStudents, 
          @TranslatorID = @TranslatorID, 
          @LanguageID = @LanguageID;
  END
END;
GO


-- Procedura do dodawania egzaminu.
CREATE OR ALTER PROCEDURE AddExam
  @SubjectID int,
  @StartDate datetime,
  @EndDate datetime,
  @Country nvarchar(500),
  @City nvarchar(500),
  @PostalCode nvarchar(500),
  @Address nvarchar(500)
AS
BEGIN
  INSERT INTO Exams (SubjectID, StartDate, EndDate, Country, City, PostalCode, Address)
  VALUES (@SubjectID, @StartDate, @EndDate, @Country, @City, @PostalCode, @Address);
END;
GO

-- Procedura do modyfikacji egzaminu.
CREATE OR ALTER PROCEDURE ModifyExam
  @ExamID int,
  @SubjectID int = NULL,
  @StartDate datetime = NULL,
  @EndDate datetime = NULL,
  @Country nvarchar(500) = NULL,
  @City nvarchar(500) = NULL,
  @PostalCode nvarchar(500) = NULL,
  @Address nvarchar(500) = NULL
AS
BEGIN
  UPDATE Exams
  SET SubjectID = COALESCE(@SubjectID, SubjectID),
      StartDate = COALESCE(@StartDate, StartDate),
      EndDate = COALESCE(@EndDate, EndDate),
      Country = COALESCE(@Country, Country),
      City = COALESCE(@City, City),
      PostalCode = COALESCE(@PostalCode, PostalCode),
      Address = COALESCE(@Address, Address)
  WHERE ExamID = @ExamID;
END;
GO

-- Procedura do aktualizacji oceny z egzaminu.
CREATE OR ALTER PROCEDURE UpdateExamGrade
  @StudentID int,
  @ExamID int,
  @FinalGrade decimal(2,1)
AS
BEGIN
  IF EXISTS (SELECT 1 FROM ExamsGrades WHERE StudentID = @StudentID AND ExamID = @ExamID)
  BEGIN
      UPDATE ExamsGrades
      SET FinalGrade = @FinalGrade
      WHERE StudentID = @StudentID AND ExamID = @ExamID;
  END
  ELSE
  BEGIN
      INSERT INTO ExamsGrades (StudentID, ExamID, FinalGrade)
      VALUES (@StudentID, @ExamID, @FinalGrade);
  END
END;
GO


-- Procedura do usuwania oceny z egzaminu.
CREATE OR ALTER PROCEDURE DeleteExamGrade
  @StudentID int,
  @ExamID int
AS
BEGIN
  DELETE FROM ExamsGrades WHERE StudentID = @StudentID AND ExamID = @ExamID;
END;
GO

-- Procedura do dodawania stażu.
CREATE OR ALTER PROCEDURE AddInternship
  @StudiesID int,
  @Description nvarchar(max),
  @StartDate date,
  @EndDate date
AS
BEGIN
  INSERT INTO Internships (StudiesID, Description, StartDate, EndDate)
  VALUES (@StudiesID, @Description, @StartDate, @EndDate);

  PRINT 'Internship added successfully.';
END;
GO

-- Procedura do modyfikacji danych stażu.
CREATE OR ALTER PROCEDURE ModifyInternship
  @InternshipID int,
  @NewDescription nvarchar(max) = NULL,
  @NewStartDate date = NULL,
  @NewEndDate date = NULL
AS
BEGIN
  UPDATE Internships
  SET Description = COALESCE(@NewDescription, Description),
      StartDate = COALESCE(@NewStartDate, StartDate),
      EndDate = COALESCE(@NewEndDate, EndDate)
  WHERE InternshipID = @InternshipID;

  PRINT 'Internship modified successfully.';
END;
GO

-- Procedura do aktualizacji szczegółów stażu dla danego studenta.
CREATE OR ALTER PROCEDURE UpdateInternshipDetail
  @StudentID int,
  @InternshipID int,
  @CompletedAt date = NULL,
  @Completed bit,
  @CompanyName nvarchar(500),
  @City nvarchar(500),
  @Country nvarchar(500),
  @PostalCode nvarchar(500),
  @Address nvarchar(500)
AS
BEGIN
  IF EXISTS (SELECT 1 FROM InternshipDetails WHERE StudentID = @StudentID AND IntershipID = @InternshipID)
  BEGIN
      UPDATE InternshipDetails
      SET CompletedAt = @CompletedAt,
          Completed = @Completed,
          CompanyName = @CompanyName,
          City = @City,
          Country = @Country,
          PostalCode = @PostalCode,
          Address = @Address
      WHERE StudentID = @StudentID AND IntershipID = @InternshipID;
  END
  ELSE
  BEGIN
      INSERT INTO InternshipDetails (StudentID, IntershipID, CompletedAt, Completed, CompanyName, City, Country, PostalCode, Address)
      VALUES (@StudentID, @InternshipID, @CompletedAt, @Completed, @CompanyName, @City, @Country, @PostalCode, @Address);
  END

  PRINT 'Internship detail updated successfully.';
END;
GO

-- Procedura do usuwania szczegółów stażu.
CREATE OR ALTER PROCEDURE DeleteInternshipDetail
  @StudentID int,
  @InternshipID int
AS
BEGIN
  DELETE FROM InternshipDetails WHERE StudentID = @StudentID AND IntershipID= @InternshipID;

  PRINT 'Internship detail deleted successfully.';
END;
GO
  

-- Funkcja zwracająca szczegółową listę obecności dla danego semestru studiów.
CREATE OR ALTER FUNCTION getStudiesAttendance(@StudiesID INT)
RETURNS TABLE
AS
RETURN (
    SELECT 
        s.StudentID, 
        s.UserID, 
        p.FirstName, 
        p.LastName, 
        sub.SubjectID, 
        sub.SubjectName, 
        ss.StudiesSessionID AS SessionID,
        CASE
            WHEN sss.StationaryStudiesSessionID IS NOT NULL THEN 'Stationary'
            WHEN oss.OnlineStudiesSessionID IS NOT NULL THEN 'Online'
            ELSE 'Unknown'
        END AS SessionType,
        ss.StartDate, 
        ss.EndDate, 
        ssa.Completed
    FROM 
        StudiesSessions ss
    INNER JOIN 
        StudiesSessionsAttendence ssa ON ss.StudiesSessionID = ssa.SessionID
    INNER JOIN 
        Students s ON ssa.StudentID = s.StudentID
    INNER JOIN 
        People p ON s.UserID = p.PersonID
    INNER JOIN 
        Subjects sub ON ss.SubjectID = sub.SubjectID
    LEFT JOIN 
        StationaryStudiesSessions sss ON ss.StudiesSessionID = sss.StationaryStudiesSessionID
    LEFT JOIN 
        OnlineStudiesSessions oss ON ss.StudiesSessionID = oss.OnlineStudiesSessionID
    WHERE 
        sub.StudiesID = @StudiesID
);
GO

-- Procedura do zamykania semestru studiów. Sprawdza czy dany student zdał egzaminy, zaliczył staże, ma odpowiednią obecność i jeżeli tak to wpisuje zaliczenie semestru studiów.
CREATE OR ALTER PROCEDURE CloseStudies(@StudiesID INT)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION

        -- Declare variables
        DECLARE @MinAttendancePercentage DECIMAL(6,4);

        -- Get minimum attendance percentage for the studies from the function
        SELECT @MinAttendancePercentage = dbo.GetMinAttendancePercentageForStudies(@StudiesID);

        -- Temporary table to store students' data
        CREATE TABLE #StudentData (
            StudentID INT,
            SubjectID INT,
            TotalSessions INT,
            AttendedSessions INT,
            MadeUpSessions INT,
            EffectiveAttendance DECIMAL(6,4),
            HasPassed BIT,
            InternshipCompleted BIT,
            ExamsPassed BIT
        );

        -- Populate the temporary table with initial data
        INSERT INTO #StudentData (StudentID, SubjectID, TotalSessions, AttendedSessions, MadeUpSessions, EffectiveAttendance, HasPassed)
        SELECT 
            s.StudentID,
            ss.SubjectID,
            (SELECT COUNT(*) FROM StudiesSessions ss2 WHERE ss2.SubjectID = ss.SubjectID) AS TotalSessions,
            SUM(CASE WHEN ssa.Completed = 1 THEN 1 ELSE 0 END) AS AttendedSessions,
            0 AS MadeUpSessions, -- Initial value, will be updated later
            0.0 AS EffectiveAttendance, -- Initial value, will be updated later
            0 AS HasPassed -- Initial value, will be updated later
        FROM Students s
        LEFT JOIN StudiesSessionsAttendence ssa ON s.StudentID = ssa.StudentID
        LEFT JOIN StudiesSessions ss ON ssa.SessionID = ss.StudiesSessionID
        WHERE s.StudiesID = @StudiesID
        GROUP BY s.StudentID, ss.SubjectID;


        -- Update the table with made up sessions
        UPDATE #StudentData
        SET MadeUpSessions = (
            SELECT SUM(smup.AttendanceValue)
            FROM MadeUpAttendance mup
            JOIN SubjectMakeUpPossibilities smup ON mup.SubjectID = smup.SubjectID AND mup.ProductID = smup.ProductID
            WHERE mup.StudentID = #StudentData.StudentID AND mup.SubjectID = #StudentData.SubjectID
        );

        -- Calculate effective attendance for each student in each subject
        UPDATE #StudentData
        SET EffectiveAttendance = (CAST(AttendedSessions AS DECIMAL) + CAST(MadeUpSessions AS DECIMAL)) / CAST(TotalSessions AS DECIMAL);

        -- Determine if the student has passed based on the effective attendance and minimum required attendance
        UPDATE #StudentData
        SET HasPassed = CASE WHEN EffectiveAttendance >= @MinAttendancePercentage THEN 1 ELSE 0 END;

        -- Check if each student has completed all internships
        UPDATE #StudentData
        SET InternshipCompleted = CASE 
            WHEN EXISTS (
                SELECT 1
                FROM InternshipDetails id
                JOIN Internships i ON id.IntershipID = i.InternshipID
                WHERE id.StudentID = #StudentData.StudentID AND i.StudiesID = @StudiesID AND id.Completed = 1
                GROUP BY id.StudentID
                HAVING COUNT(id.IntershipID) = (SELECT COUNT(InternshipID) FROM Internships WHERE StudiesID = @StudiesID)
            ) THEN 1
            ELSE 0
        END;

        -- Check if each student has passed all exams with a grade >= 3.0
        UPDATE #StudentData
        SET ExamsPassed = CASE 
            WHEN NOT EXISTS (
                SELECT 1
                FROM ExamsGrades eg
                JOIN Exams e ON eg.ExamID = e.ExamID
                JOIN Subjects sub ON e.SubjectID = sub.SubjectID
                WHERE eg.StudentID = #StudentData.StudentID AND sub.StudiesID = @StudiesID AND eg.FinalGrade < 3.0
            ) THEN 1
            ELSE 0
        END;

        -- Update the Students table to set Completed = 1 for those who passed everything
        UPDATE s
        SET s.Completed = 1
        FROM Students s
        JOIN #StudentData sd ON s.StudentID = sd.StudentID
        WHERE sd.HasPassed = 1 AND sd.InternshipCompleted = 1 AND sd.ExamsPassed = 1 AND s.StudiesID = @StudiesID;

        -- Final output of the procedure: StudentID, SubjectID, HasPassed, InternshipCompleted, ExamsPassed
        SELECT * FROM #StudentData;

        -- Clean up temporary table
        DROP TABLE #StudentData;

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        -- Error handling and rollback
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO


-- Procedura do modyfikacji nagarania ze studyjnego spotkania online.
CREATE OR ALTER PROCEDURE ModifyOnlineStudiesSessionRecording
    @OnlineStudiesSessionID INT,
    @NewRecordingLink NVARCHAR(MAX)
AS
BEGIN
    UPDATE OnlineStudiesSessions
    SET RecordingLink = @NewRecordingLink
    WHERE OnlineStudiesSessionID = @OnlineStudiesSessionID;
END;
GO
