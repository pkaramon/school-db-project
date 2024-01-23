
-- Funkcja pobierająca liczbę dni dostępu do nagrań webinarów.
CREATE OR ALTER FUNCTION dbo.GetRecordingAccessDays(@WebinarID INT)
RETURNS INT
AS
BEGIN
    DECLARE @NumberOfDays INT;

    -- Try to find a specific rule for the given WebinarID
    SELECT @NumberOfDays = NumberOfDays
    FROM RecordingAccessTime
    WHERE WebinarID = @WebinarID
          AND StartDate <= GETDATE() 
          AND (EndDate IS NULL OR EndDate > GETDATE());

    -- If no specific rule found, look for a general rule
    IF @NumberOfDays IS NULL
    BEGIN
        SELECT @NumberOfDays = NumberOfDays
        FROM RecordingAccessTime
        WHERE WebinarID IS NULL
              AND StartDate <= GETDATE() 
              AND (EndDate IS NULL OR EndDate > GETDATE());
    END

    -- Return the number of days
    RETURN @NumberOfDays;
END;
GO

-- Funkcja pobierająca minimalny procent obecności wymagany do zaliczenia kursu.
CREATE OR ALTER FUNCTION dbo.GetMinAttendancePercentageForCourse(@CourseID INT)
RETURNS DECIMAL(6, 4)
AS
BEGIN
    DECLARE @MinAttendancePercentage DECIMAL(6, 4);

    -- Try to find a specific rule for the given CourseID
    SELECT @MinAttendancePercentage = AttendancePercentage
    FROM MinAttendancePercentageToPassCourse
    WHERE CourseID = @CourseID
          AND StartDate <= GETDATE()
          AND (EndDate IS NULL OR EndDate > GETDATE());

    -- If no specific rule found, look for a general rule (CourseID is NULL)
    IF @MinAttendancePercentage IS NULL
    BEGIN
        SELECT @MinAttendancePercentage = AttendancePercentage
        FROM MinAttendancePercentageToPassCourse
        WHERE CourseID IS NULL
              AND StartDate <= GETDATE()
              AND (EndDate IS NULL OR EndDate > GETDATE());
    END

    -- Return the minimum attendance percentage
    RETURN @MinAttendancePercentage;
END;
GO

-- Funkcja pobierająca minimalny procent obecności wymagany do zaliczenia stażu.
CREATE OR ALTER FUNCTION dbo.GetMinAttendancePercentageForInternship(@InternshipID INT)
RETURNS DECIMAL(6, 4)
AS
BEGIN
    DECLARE @MinAttendancePercentage DECIMAL(6, 4);

    -- Try to find a specific rule for the given InternshipID
    SELECT @MinAttendancePercentage = AttendancePercentage
    FROM MinAttendancePercentageToPassInternship
    WHERE InternshipID = @InternshipID
          AND StartDate <= GETDATE()
          AND (EndDate IS NULL OR EndDate > GETDATE());

    -- If no specific rule found, look for a general rule (InternshipID is NULL)
    IF @MinAttendancePercentage IS NULL
    BEGIN
        SELECT @MinAttendancePercentage = AttendancePercentage
        FROM MinAttendancePercentageToPassInternship
        WHERE InternshipID IS NULL
              AND StartDate <= GETDATE()
              AND (EndDate IS NULL OR EndDate > GETDATE());
    END

    -- Return the minimum attendance percentage
    RETURN @MinAttendancePercentage;
END;
GO

-- Funkcja pobierająca minimalny procent obecności wymagany do zaliczenia studiów.
CREATE OR ALTER FUNCTION dbo.GetMinAttendancePercentageForStudies(@StudiesID INT)
RETURNS DECIMAL(6, 4)
AS
BEGIN
    DECLARE @MinAttendancePercentage DECIMAL(6, 4);

    -- Try to find a specific rule for the given StudiesID
    SELECT @MinAttendancePercentage = AttendancePercentage
    FROM MinAttendancePercentageToPassStudies
    WHERE StudiesID = @StudiesID
          AND StartDate <= GETDATE()
          AND (EndDate IS NULL OR EndDate > GETDATE());

    -- If no specific rule found, look for a general rule (StudiesID is NULL)
    IF @MinAttendancePercentage IS NULL
    BEGIN
        SELECT @MinAttendancePercentage = AttendancePercentage
        FROM MinAttendancePercentageToPassStudies
        WHERE StudiesID IS NULL
              AND StartDate <= GETDATE()
              AND (EndDate IS NULL OR EndDate > GETDATE());
    END

    -- Return the minimum attendance percentage
    RETURN @MinAttendancePercentage;
END;
GO

-- Funkcja pobierająca maksymalną liczbę dni na dokonanie płatności przed rozpoczęciem kursu.
CREATE OR ALTER FUNCTION dbo.GetMaxDaysForPaymentBeforeCourseStart(@CourseID INT)
RETURNS INT
AS
BEGIN
    DECLARE @MaxDaysForPayment INT;

    -- Try to find a specific rule for the given CourseID
    SELECT @MaxDaysForPayment = NumberOfDays
    FROM MaxDaysForPaymentBeforeCourseStart
    WHERE CourseID = @CourseID
          AND StartDate <= GETDATE()
          AND (EndDate IS NULL OR EndDate > GETDATE());

    -- If no specific rule found, look for a general rule (CourseID is NULL)
    IF @MaxDaysForPayment IS NULL
    BEGIN
        SELECT @MaxDaysForPayment = NumberOfDays
        FROM MaxDaysForPaymentBeforeCourseStart
        WHERE CourseID IS NULL
              AND StartDate <= GETDATE()
              AND (EndDate IS NULL OR EndDate > GETDATE());
    END

    -- Return the maximum days for payment
    RETURN @MaxDaysForPayment;
END;
GO

-- Funkcja pobierająca maksymalną liczbę dni na dokonanie płatności przed rozpoczęciem studiów.
CREATE OR ALTER FUNCTION dbo.GetMaxDaysForPaymentBeforeStudiesStart(@StudiesID INT)
RETURNS INT
AS
BEGIN
    DECLARE @MaxDaysForPayment INT;

    -- Try to find a specific rule for the given StudiesID
    SELECT @MaxDaysForPayment = NumberOfDays
    FROM MaxDaysForPaymentBeforeStudiesStart
    WHERE StudiesID = @StudiesID
          AND StartDate <= GETDATE()
          AND (EndDate IS NULL OR EndDate > GETDATE());

    -- If no specific rule found, look for a general rule (StudiesID is NULL)
    IF @MaxDaysForPayment IS NULL
    BEGIN
        SELECT @MaxDaysForPayment = NumberOfDays
        FROM MaxDaysForPaymentBeforeStudiesStart
        WHERE StudiesID IS NULL
              AND StartDate <= GETDATE()
              AND (EndDate IS NULL OR EndDate > GETDATE());
    END

    -- Return the maximum days for payment
    RETURN @MaxDaysForPayment;
END;
GO

-- Funkcja pobierająca liczbę dni trwania stażu.
CREATE OR ALTER FUNCTION dbo.GetDaysInInternship(@InternshipID INT)
RETURNS INT
AS
BEGIN
    DECLARE @DaysInInternship INT;

    -- Try to find a specific rule for the given InternshipID
    SELECT @DaysInInternship = NumberOfDays
    FROM DaysInInternship
    WHERE InternshipID = @InternshipID
          AND StartDate <= GETDATE()
          AND (EndDate IS NULL OR EndDate > GETDATE());

    -- If no specific rule found, look for a general rule (InternshipID is NULL)
    IF @DaysInInternship IS NULL
    BEGIN
        SELECT @DaysInInternship = NumberOfDays
        FROM DaysInInternship
        WHERE InternshipID IS NULL
              AND StartDate <= GETDATE()
              AND (EndDate IS NULL OR EndDate > GETDATE());
    END

    -- Return the number of days in the internship
    RETURN @DaysInInternship;
END;
GO

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
GO-- Procedura do tworzenia nowego webinaru.
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
GO-- Procedura do tworzenia nowej osoby w bazie danych.
CREATE OR ALTER PROCEDURE CreateNewPerson
    @FirstName NVARCHAR(MAX),
    @LastName NVARCHAR(500),
    @BirthDate DATE,
    @Address NVARCHAR(500),
    @City NVARCHAR(500),
    @Region NVARCHAR(500),
    @PostalCode NVARCHAR(20),
    @Country NVARCHAR(500),
    @Phone NVARCHAR(20),
    @Email NVARCHAR(500)
AS
BEGIN
    INSERT INTO People (
        FirstName,
        LastName,
        BirthDate,
        Address,
        City,
        Region,
        PostalCode,
        Country,
        Phone,
        Email
    )
    VALUES (
        @FirstName,
        @LastName,
        @BirthDate,
        @Address,
        @City,
        @Region,
        @PostalCode,
        @Country,
        @Phone,
        @Email
    );

    -- Print confirmation message
    PRINT 'New person added successfully.';
END;
GO

-- Procedura do aktualizacji danych osobowych istniejącej osoby.
CREATE OR ALTER PROCEDURE UpdatePersonData
    @PersonID INT,
    @NewFirstName NVARCHAR(MAX) = NULL,
    @NewLastName NVARCHAR(500) = NULL,
    @NewBirthDate DATE = NULL,
    @NewAddress NVARCHAR(500) = NULL,
    @NewCity NVARCHAR(500) = NULL,
    @NewRegion NVARCHAR(500) = NULL,
    @NewPostalCode NVARCHAR(20) = NULL,
    @NewCountry NVARCHAR(500) = NULL,
    @NewPhone NVARCHAR(20) = NULL,
    @NewEmail NVARCHAR(500) = NULL
AS
BEGIN
    -- Update only the fields that are provided (non-null)
    UPDATE People
    SET FirstName = COALESCE(@NewFirstName, FirstName),
        LastName = COALESCE(@NewLastName, LastName),
        BirthDate = COALESCE(@NewBirthDate, BirthDate),
        Address = COALESCE(@NewAddress, Address),
        City = COALESCE(@NewCity, City),
        Region = COALESCE(@NewRegion, Region),
        PostalCode = COALESCE(@NewPostalCode, PostalCode),
        Country = COALESCE(@NewCountry, Country),
        Phone = COALESCE(@NewPhone, Phone),
        Email = COALESCE(@NewEmail, Email)
    WHERE PersonID = @PersonID;

    -- Print confirmation message
    PRINT 'Person data updated successfully.';
END;
GO


-- Procedura do usunięcia osoby z bazy danych.
CREATE OR ALTER PROCEDURE RemovePerson
    @PersonID INT
AS
BEGIN
    DELETE FROM People
    WHERE PersonID = @PersonID;

    -- Print confirmation message
    PRINT 'Person removed successfully.';
END;
GO

-- Procedura do dodawania nowego użytkownika.
CREATE OR ALTER PROCEDURE AddUser
    @FirstName NVARCHAR(MAX),
    @LastName NVARCHAR(500),
    @BirthDate DATE,
    @Address NVARCHAR(500),
    @City NVARCHAR(500),
    @Region NVARCHAR(500),
    @PostalCode NVARCHAR(20),
    @Country NVARCHAR(500),
    @Phone NVARCHAR(20),
    @Email NVARCHAR(500),
    @UserID INT OUTPUT  -- Output parameter to return the generated UserID
AS
BEGIN
    BEGIN TRY
        -- Insert user data into People table
        INSERT INTO People (
            FirstName, LastName, BirthDate, Address, City, Region, PostalCode, Country, Phone, Email
        )
        VALUES (
            @FirstName, @LastName, @BirthDate, @Address, @City, @Region, @PostalCode, @Country, @Phone, @Email
        );

        -- Get the generated UserID (same as PersonID)
        SET @UserID = SCOPE_IDENTITY();

        -- Insert user data into Users table
        INSERT INTO Users (UserID)
        VALUES (@UserID);

        -- Print confirmation message
        PRINT 'User added successfully.';
    END TRY
    BEGIN CATCH
        -- Handle any errors (e.g., check constraint violations)
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;
GO

-- Procedura do dodawania nowego pracownika.
CREATE OR ALTER PROCEDURE AddEmployee
    @FirstName NVARCHAR(MAX),
    @LastName NVARCHAR(500),
    @BirthDate DATE,
    @Address NVARCHAR(500),
    @City NVARCHAR(500),
    @Region NVARCHAR(500),
    @PostalCode NVARCHAR(20),
    @Country NVARCHAR(500),
    @Phone NVARCHAR(20),
    @Email NVARCHAR(500),
    @HireDate DATE,
    @EmployeeID INT OUTPUT  -- Output parameter to return the generated EmployeeID
AS
BEGIN
    BEGIN TRY
        -- Insert employee data into People table
        INSERT INTO People (
            FirstName, LastName, BirthDate, Address, City, Region, PostalCode, Country, Phone, Email
        )
        VALUES (
            @FirstName, @LastName, @BirthDate, @Address, @City, @Region, @PostalCode, @Country, @Phone, @Email
        );

        -- Get the generated EmployeeID (same as PersonID)
        SET @EmployeeID = SCOPE_IDENTITY();

        -- Insert employee data into Employees table
        INSERT INTO Employees (EmployeeID, HireDate, IsActive)
        VALUES (@EmployeeID, @HireDate, 1); -- IsActive is set to 1 by default

        -- Print confirmation message
        PRINT 'Employee added successfully.';
    END TRY
    BEGIN CATCH
        -- Handle any errors (e.g., check constraint violations)
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;
GO

-- Procedura do dodawania produktu do koszyka użytkownika.
CREATE OR ALTER PROCEDURE AddProductToCart
    @UserID INT,
    @ProductID INT
AS
BEGIN
    -- Check if the product is not already in the cart
    IF NOT EXISTS (SELECT 1 FROM Carts WHERE UserID = @UserID AND ProductID = @ProductID)
    BEGIN
        -- Insert the product into the cart if it doesn't already exist
        INSERT INTO Carts (UserID, ProductID, AddedAt)
        VALUES (@UserID, @ProductID, GETDATE());

        PRINT 'Product added to the cart successfully.';
    END
    ELSE
    BEGIN
        PRINT 'Product already exists in the cart.';
    END;
END;
GO

-- Procedura do usuwania produktu z koszyka użytkownika.
CREATE OR ALTER PROCEDURE RemoveProductFromCart
    @UserID INT,
    @ProductID INT
AS
BEGIN
    -- Delete the product from the cart (Carts table)
    DELETE FROM Carts
    WHERE UserID = @UserID AND ProductID = @ProductID;

    PRINT 'Product removed from the cart successfully.';
END;
GO

-- Procedura do wysyłania dyplomu.
CREATE OR ALTER PROCEDURE SendDiploma
    @UserID int,
    @ProductID int,
    @DiplomaData nvarchar(max)  -- This parameter represents the diploma data
AS
BEGIN
    -- Insert the diploma sending record into the DiplomasSent table
    INSERT INTO DiplomasSent (UserID, ProductID, DiplomaFile)
    VALUES (@UserID, @ProductID, @DiplomaData);

    -- Print confirmation message
    PRINT 'Diploma sent successfully.';
END;
GO

-- Procedura do dodawania nowej roli.
CREATE OR ALTER PROCEDURE AddRole
    @RoleName nvarchar(200)
AS
BEGIN
    -- Insert the new role into the Roles table
    INSERT INTO Roles (RoleName)
    VALUES (@RoleName);

    -- Print confirmation message
    PRINT 'Role added successfully.';
END;
GO

-- Procedura do modyfikacji roli.
CREATE OR ALTER PROCEDURE ModifyRole
    @RoleID int,
    @NewRoleName nvarchar(200)
AS
BEGIN
    -- Update the Roles table
    UPDATE Roles
    SET RoleName = @NewRoleName
    WHERE RoleID = @RoleID;

    -- Print confirmation message
    PRINT 'Role updated successfully.';
END;
GO


-- Procedura do dodawania roli pracownikowi.
CREATE OR ALTER PROCEDURE AddEmployeeRole
    @EmployeeID int,
    @RoleID int
AS
BEGIN
    -- Insert a new association of role and employee into the EmployeeRoles table
    INSERT INTO EmployeeRoles (EmployeeID, RoleID)
    VALUES (@EmployeeID, @RoleID);

    -- Print confirmation message
    PRINT 'Role added to employee successfully.';
END;
GO

-- Procedura do usuwania roli od pracownika.
CREATE OR ALTER PROCEDURE RemoveEmployeeRole
    @EmployeeID int,
    @RoleID int
AS
BEGIN
    -- Delete the role-employee association from the EmployeeRoles table
    DELETE FROM EmployeeRoles
    WHERE EmployeeID = @EmployeeID AND RoleID = @RoleID;

    -- Print confirmation message
    PRINT 'Role removed from employee successfully.';
END;
GO

-- Procedura do zmiany ceny produktu.
CREATE OR ALTER PROCEDURE ChangeProductPrice
    @ProductID int,
    @NewPrice money,
    @NewAdvancePayment money = NULL
AS
BEGIN
    -- Update the product price in the Products table
    UPDATE Products
    SET Price = @NewPrice,
        AdvancePayment = @NewAdvancePayment
    WHERE ProductID = @ProductID;

    -- Print confirmation message
    PRINT 'Product price updated successfully.';
END;
GO

-- Funkcja zwracająca historię płatności dla danego użytkownika.
CREATE OR ALTER FUNCTION getCourseAttendance(@CourseID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        cp.CourseParticipantID,
        u.UserID,
        pe.FirstName AS UserFirstName,
        pe.LastName AS UserLastName,
        CASE 
            WHEN cos.CourseOfflineSessionID IS NOT NULL THEN 'Offline'
            WHEN con.CourseOnlineSessionID IS NOT NULL THEN 'Online'
            WHEN cst.CourseStationarySessionID IS NOT NULL THEN 'Stationary'
            ELSE 'Unknown'
        END AS SessionType,
        COALESCE(NULL, con.StartDate, cst.StartDate) AS StartDate,
        COALESCE(NULL, con.EndDate, cst.EndDate) AS EndDate,
        cs.ModuleID,
        m.ModuleName,
        e.PersonID AS LecturerID,
        e.FirstName AS LecturerFirstName,
        e.LastName AS LecturerLastName,
    ca.Completed as 'Completed'
    FROM 
        CourseParticipants cp
    INNER JOIN 
        Users u ON cp.UserID = u.UserID
    INNER JOIN 
        People pe ON u.UserID = pe.PersonID
  INNER JOIN
       Courses co ON co.CourseID = cp.CourseID
    INNER JOIN 
    Modules m ON  co.CourseID = m.CourseID
    INNER JOIN 
        CoursesSessions cs ON cs.ModuleID = m.ModuleID
    LEFT JOIN 
        CourseOfflineSessions cos ON cs.CourseSessionID = cos.CourseOfflineSessionID
    LEFT JOIN 
        CourseOnlineSessions con ON cs.CourseSessionID = con.CourseOnlineSessionID
    LEFT JOIN 
        CourseStationarySessions cst ON cs.CourseSessionID = cst.CourseStationarySessionID
    LEFT JOIN 
        People e ON cs.LecturerID = e.PersonID
  LEFT JOIN 
    CourseSessionsAttendance ca ON ca.CourseSessionID = cs.CourseSessionID AND ca.CourseParticipantID = cp.CourseParticipantID
    WHERE 
        cp.CourseID = @CourseID
);
GO
-- Funkcja sprawdzająca, czy użytkownik może zakupić płatny webinar.
CREATE OR ALTER  FUNCTION dbo.CanUserPurchasePaidWebinar
(
    @UserID INT,
    @WebinarID INT
)
RETURNS BIT
AS
BEGIN
    DECLARE @StartDate DATETIME
    DECLARE @RecordingReleaseDate DATE
    DECLARE @CanPurchase BIT = 0

    -- Retrieve Webinar Start Date and Recording Release Date
    SELECT 
        @StartDate = StartDate, 
        @RecordingReleaseDate = RecordingReleaseDate
    FROM 
        Webinars
    WHERE 
        WebinarID = @WebinarID

    -- Check if current date is before the Webinar's Start Date
    IF GETDATE() < @StartDate
    BEGIN
        -- Check if the user is not already enrolled
        IF NOT EXISTS (
            SELECT 1
            FROM WebinarParticipants
            WHERE UserID = @UserID AND WebinarID = @WebinarID
        )
        BEGIN
            -- User can purchase access to the webinar
            SET @CanPurchase = 1
        END
    END
    ELSE
    BEGIN
        -- After the Webinar has started, check if the recording is released
        IF @RecordingReleaseDate IS NOT NULL AND GETDATE() >= @RecordingReleaseDate
        BEGIN
            -- User can purchase access to the webinar recording
            SET @CanPurchase = 1
        END
    END

    -- Return the result
    RETURN @CanPurchase
END;
GO

-- Procedura zapisująca użytkownika na bezpłatny webinar.
CREATE OR ALTER PROCEDURE EnrollUserToFreeWebinar
    @UserID INT,
    @WebinarID INT
AS
BEGIN
    -- Check if the webinar is free
    IF EXISTS (
        SELECT 1
        FROM Products P
        JOIN Webinars W ON W.WebinarID = P.ProductID
        WHERE W.WebinarID = @WebinarID AND P.Price = 0
    )
    BEGIN
        -- Check if the user is already enrolled in the webinar
        IF NOT EXISTS (
            SELECT 1
            FROM WebinarParticipants
            WHERE UserID = @UserID AND WebinarID = @WebinarID
        )
        BEGIN
            -- Insert user into WebinarParticipants
            INSERT INTO WebinarParticipants (UserID, WebinarID, WebinarPrice)
            VALUES (@UserID, @WebinarID, 0)
        END
        ELSE
        BEGIN
            -- Raise an error if the user is already enrolled
            RAISERROR ('User is already enrolled in this webinar.', 16, 1);
        END
    END
    ELSE
    BEGIN
        -- Raise an error if the webinar is not free
        RAISERROR ('The specified webinar is not free.', 16, 1);
    END
END;
GO


-- Procedura przetwarzająca płatność za webinar.
CREATE OR ALTER PROCEDURE ProcessWebinarPayment
    @UserID INT,
    @WebinarID INT,
    @Price MONEY,
    @Status NVARCHAR(300)
AS
BEGIN
    -- Insert the payment record
    INSERT INTO Payments (UserID, ProductID, Price, Date, Status)
    VALUES (@UserID, @WebinarID, @Price, GETDATE(), @Status)

    -- Get the last inserted PaymentID
    DECLARE @PaymentID INT
    SELECT @PaymentID = SCOPE_IDENTITY()

    -- If the payment failed, just exit the procedure
    IF @Status = 'Failed'
    BEGIN
        RETURN
    END

  DECLARE @DuePostponedPayment datetime;
  DECLARE @FullPricePaymentID int;
  DECLARE @UsersPrice money;
  SELECT 
    @FullPricePaymentID=FullPricePaymentID,
    @DuePostponedPayment = DuePostponedPayment,
    @UsersPrice=WebinarPrice
  FROM WebinarParticipants WHERE UserID=@UserID AND WebinarID=@WebinarID;

  IF @DuePostponedPayment IS NOT NULL AND @FullPricePaymentID IS NULL AND @UsersPrice=@Price
  BEGIN
    UPDATE WebinarParticipants
    SET FullPricePaymentID=@PaymentID
    WHERE UserID=@UserID AND WebinarID=@WebinarID;
    RETURN;
  END


    -- Check if the price matches the actual webinar price
    IF NOT EXISTS (
        SELECT 1
        FROM Products P
        JOIN Webinars W ON W.WebinarID = P.ProductID
        WHERE W.WebinarID = @WebinarID AND P.Price = @Price
    )
    BEGIN
        RAISERROR('The specified price does not match the actual webinar price.', 16, 1)
        RETURN
    END


    -- Double check using CanUserPurchasePaidWebinar
    IF dbo.CanUserPurchasePaidWebinar(@UserID, @WebinarID) = 1
    BEGIN
        -- Enroll the user to the webinar
        INSERT INTO WebinarParticipants (UserID, WebinarID, WebinarPrice, FullPricePaymentID)
        VALUES (@UserID, @WebinarID, @Price, @PaymentID)
    END
    ELSE
    BEGIN
        RAISERROR('The user cannot purchase the webinar at this time.', 16, 1)
    END
END;
GO

-- Funkcja sprawdzająca, czy użytkownik może zakupić kurs.
CREATE OR ALTER  FUNCTION CanUserPurchaseCourse
(
    @UserID INT,
    @CourseID INT
)
RETURNS BIT
AS
BEGIN
    DECLARE @CanPurchase BIT = 0
    DECLARE @CourseStartDate DATETIME
    DECLARE @MaxStudents INT
    DECLARE @CurrentEnrollmentCount INT
    DECLARE @MaxDaysForPayment INT
    DECLARE @CourseClosed BIT

    -- Get course start date and MaxStudents
    SELECT 
        @CourseStartDate = StartDate, 
        @MaxStudents = MaxStudents,
        @CourseClosed = CASE WHEN ClosedAt IS NULL THEN 0 ELSE 1 END
    FROM Courses
  JOIN Products P ON P.ProductID = Courses.CourseID
    WHERE CourseID = @CourseID

    -- Get the current number of enrolled students
    SELECT @CurrentEnrollmentCount = COUNT(*)
    FROM CourseParticipants
    WHERE CourseID = @CourseID

    -- Check if it's too late to make the payment
    SELECT @MaxDaysForPayment = dbo.GetMaxDaysForPaymentBeforeCourseStart(@CourseID)

    -- Check if user is already enrolled
    IF NOT EXISTS (
        SELECT 1
        FROM CourseParticipants
        WHERE UserID = @UserID AND CourseID = @CourseID
    )
    BEGIN
        -- Check if course is not closed, within the payment window, and not full
        IF @CourseClosed = 0 AND 
           GETDATE() < DATEADD(DAY, -@MaxDaysForPayment, @CourseStartDate) AND 
           (@MaxStudents IS NULL OR @CurrentEnrollmentCount < @MaxStudents)
        BEGIN
            SET @CanPurchase = 1
        END
    END

    RETURN @CanPurchase
END;
GO

-- Procedura przetwarzająca płatność za kurs.
CREATE OR ALTER PROCEDURE ProcessCoursePayment
    @UserID INT,
    @CourseID INT,
    @Price MONEY,
    @Status NVARCHAR(300)
AS
BEGIN
    -- Declare variable to store the new PaymentID
    DECLARE @NewPaymentID INT;

    -- Insert the payment record and store the new PaymentID
    INSERT INTO Payments (UserID, ProductID, Price, Date, Status)
    VALUES (@UserID, @CourseID, @Price, GETDATE(), @Status);

    -- Get the last inserted PaymentID
    SET @NewPaymentID = SCOPE_IDENTITY();

    -- If payment failed, do nothing more
    IF @Status = 'Failed'
        RETURN;

    -- Check if user is already enrolled in the course
    IF NOT EXISTS (SELECT * FROM CourseParticipants WHERE UserID = @UserID AND CourseID = @CourseID)
    BEGIN

        -- User is not enrolled, check if they can purchase the course
        DECLARE @CanPurchase BIT = dbo.CanUserPurchaseCourse(@UserID, @CourseID);
        IF @CanPurchase = 1
        BEGIN
      -- Get course details
      DECLARE @CoursePrice MONEY, @EntryFee MONEY;
      SELECT @CoursePrice = Price, @EntryFee = AdvancePayment FROM Products WHERE ProductID = @CourseID;

            -- Check if payment is full price or advance payment
            IF @Price IN (@CoursePrice, @EntryFee)
            BEGIN
                -- Insert into CourseParticipants
                INSERT INTO CourseParticipants (UserID, CourseID, CoursePrice, EntryFee, EntryFeePaymentID, FullPricePaymentID, AddedAt, Completed)
                VALUES (@UserID, @CourseID, @CoursePrice, @EntryFee, 
                        CASE WHEN @Price = @EntryFee THEN @NewPaymentID ELSE NULL END,
                        CASE WHEN @Price = @CoursePrice THEN @NewPaymentID ELSE NULL END,
                        GETDATE(), 0);
            END
            ELSE
            BEGIN
                -- Raise error: Price does not match
                RAISERROR('Payment amount does not match course fees.', 16, 1);
                RETURN;
            END
        END
        ELSE
        BEGIN
            -- Raise error: Cannot purchase course
            RAISERROR('User cannot purchase the course.', 16, 1);
            RETURN;
        END
    END
    ELSE
    BEGIN
        -- User is already enrolled, check remaining payment
        DECLARE @RemainingPrice MONEY, @MaxDaysForPayment INT, @CourseStartDate DATETIME, @UserCoursePrice MONEY;
    SELECT @RemainingPrice = CoursePrice-EntryFee,
         @UserCoursePrice=CoursePrice
    FROM CourseParticipants WHERE UserID=@UserID AND CourseID=@CourseID;
        SELECT @CourseStartDate = StartDate 
        FROM Courses 
        WHERE CourseID = @CourseID;
        SET @MaxDaysForPayment = dbo.GetMaxDaysForPaymentBeforeCourseStart(@CourseID);

    DECLARE @FullPaymentID int;
    DECLARE @EntryFeePaymentID int;
    DECLARE @RemainingPaymentID int;
    DECLARE @DuePostponedPayment datetime;

    SELECT @FullPaymentID = FullPricePaymentID, @EntryFeePaymentID=EntryFeePaymentID,
        @RemainingPaymentID=RemainingPaymentID, @DuePostponedPayment = DuePostponedPayment
    FROM CourseParticipants
    WHERE UserID=@UserID AND CourseID = @CourseID;


    IF @FullPaymentID IS NULL AND @EntryFeePaymentID IS NULL AND @RemainingPaymentID IS NULL AND 
      @DuePostponedPayment IS NOT NULL AND @Price=@UserCoursePrice
    BEGIN
      UPDATE CourseParticipants
      SET FullPricePaymentID=@NewPaymentID
      WHERE UserID=@UserID AND CourseID=@CourseID;
      RETURN;
    END


        IF @Price = @RemainingPrice AND GETDATE() < DATEADD(DAY, -@MaxDaysForPayment, @CourseStartDate) AND
           NOT EXISTS (SELECT * FROM CourseParticipants WHERE UserID = @UserID AND CourseID = @CourseID AND RemainingPaymentID IS NOT NULL)
        BEGIN
            -- Update CourseParticipants with remaining payment
            UPDATE CourseParticipants
            SET RemainingPaymentID = @NewPaymentID
            WHERE UserID = @UserID AND CourseID = @CourseID;
        END
        ELSE
        BEGIN
            -- Raise error: Invalid payment or conditions not met
            RAISERROR('Invalid payment amount or conditions for remaining payment not met.', 16, 1);
            RETURN;
        END
    END
END;
GO

-- Funkcja sprawdzająca, czy użytkownik może zakupić pojedyńcze spotkanie studyjne.
CREATE OR ALTER FUNCTION dbo.CanUserPurchasePublicStudySession(@UserID INT, @PublicStudySessionID INT)
RETURNS BIT
AS
BEGIN
    DECLARE @CanEnroll BIT = 1; -- Default: user can enroll

    -- Check if the session is still open
    IF EXISTS (SELECT 1 FROM Products WHERE ProductID = @PublicStudySessionID AND ClosedAt IS NOT NULL)
    OR GETDATE() >= (SELECT StartDate FROM PublicStudySessions PSS
          JOIN StudiesSessions SS ON PSS.StudiesSessionID = SS.StudiesSessionID
          WHERE PSS.PublicStudySessionID=@PublicStudySessionID)
    BEGIN
        SET @CanEnroll = 0; -- Session is closed
    END

    -- Check if user is already enrolled
    IF @CanEnroll = 1 AND EXISTS (SELECT 1 FROM PublicStudySessionParticipants WHERE UserID = @UserID AND PublicStudySessionID = @PublicStudySessionID)
    BEGIN
        SET @CanEnroll = 0; -- User is already enrolled
    END

    DECLARE @MaxStudents INT, @ExternalEnrollments INT, @OrdinaryEnrollments INT;

    -- Get the MaxStudents value for this session
    SELECT @MaxStudents = ss.MaxStudents 
    FROM PublicStudySessions pss
    INNER JOIN StudiesSessions ss ON pss.StudiesSessionID = ss.StudiesSessionID
    WHERE pss.PublicStudySessionID = @PublicStudySessionID;

    -- Count the number of external participants enrolled
    SELECT @ExternalEnrollments = COUNT(*) 
    FROM PublicStudySessionParticipants
    WHERE PublicStudySessionID = @PublicStudySessionID;

    -- Count the number of ordinary students enrolled
    SELECT @OrdinaryEnrollments = COUNT(*) 
    FROM Students s
    INNER JOIN Studies st ON st.StudiesID = s.StudiesID
    INNER JOIN Subjects sub ON sub.StudiesID = st.StudiesID
    INNER JOIN StudiesSessions ss ON ss.SubjectID = sub.SubjectID
    INNER JOIN PublicStudySessions pss ON pss.StudiesSessionID = ss.StudiesSessionID
    WHERE pss.PublicStudySessionID = @PublicStudySessionID;

    -- Check if the maximum number of students has been reached
    DECLARE @TotalEnrollments INT = @ExternalEnrollments + @OrdinaryEnrollments;
    IF @TotalEnrollments >= @MaxStudents
    BEGIN
        SET @CanEnroll = 0; -- Enrollment limit reached
    END

    RETURN @CanEnroll;
END;
GO

-- Procedura przetwarzająca płatność za publiczną sesję studiów.
CREATE OR ALTER PROCEDURE ProcessPublicStudySessionPayment
    @UserID INT,
    @PublicStudySessionID INT,
    @Price MONEY,
    @Status NVARCHAR(300)
AS
BEGIN
    -- Insert into Payments and store the new PaymentID
    DECLARE @NewPaymentID INT;
    INSERT INTO Payments (UserID, ProductID, Price, Date, Status)
    VALUES (@UserID, @PublicStudySessionID, @Price, GETDATE(), @Status);

    SET @NewPaymentID = SCOPE_IDENTITY();

    -- If the payment is unsuccessful, end the procedure
    IF @Status = 'Failed'
        RETURN;

    -- Check if the price matches the PublicStudySession price
    DECLARE @SessionPrice MONEY;
    SELECT @SessionPrice = P.Price
    FROM PublicStudySessions PSS
    JOIN Products P ON PSS.PublicStudySessionID = P.ProductID
    WHERE PSS.PublicStudySessionID = @PublicStudySessionID;

    IF @Price != @SessionPrice
    BEGIN
        RAISERROR('Incorrect price for the Public Study Session', 16, 1);
        RETURN;
    END

  DECLARE @DuePostponedPayment datetime;
  DECLARE @FullPaymentID int;
  DECLARE @UsersSessionPrice int;
  SELECT @DuePostponedPayment = DuePostponedPayment,
       @FullPaymentID=FullPricePaymentID,
       @UsersSessionPrice = SessionPrice
  FROM PublicStudySessionParticipants
  WHERE UserID=@UserID AND PublicStudySessionID=@PublicStudySessionID;

  IF @DuePostponedPayment IS NOT NULL AND @FullPaymentID IS NULL AND @UsersSessionPrice=@Price
  BEGIN
    UPDATE PublicStudySessionParticipants
    SET FullPricePaymentID=@NewPaymentID
    WHERE UserID=@UserID AND PublicStudySessionID=@PublicStudySessionID
    RETURN;
  END

    -- Check if the user can purchase the public study session
    IF dbo.CanUserPurchasePublicStudySession(@UserID, @PublicStudySessionID) = 0
    BEGIN
        RAISERROR('User cannot purchase this Public Study Session', 16, 1);
        RETURN;
    END

    -- Insert into PublicStudySessionParticipants and link the payment
    INSERT INTO PublicStudySessionParticipants (UserID, PublicStudySessionID, SessionPrice, AddedAt, FullPricePaymentID)
    VALUES (@UserID, @PublicStudySessionID, @Price, GETDATE(), @NewPaymentID);
END;
GO

-- Funkcja sprawdzająca, czy użytkownik może zakupić studia.
CREATE OR ALTER FUNCTION dbo.CanUserPurchaseStudies(@UserID INT, @StudiesID INT)
RETURNS BIT
AS
BEGIN
    DECLARE @CanPurchase BIT = 1; -- Default: user can purchase the studies

    -- Check if the studies are still open
    IF EXISTS (SELECT 1 FROM Products WHERE ProductID = @StudiesID AND ClosedAt IS NOT NULL)
       OR GETDATE() > (SELECT StartDate FROM Studies WHERE StudiesID = @StudiesID)
    BEGIN
        SET @CanPurchase = 0; -- Studies are closed
    END

    -- Check if user is already enrolled in the studies
    IF @CanPurchase = 1 AND EXISTS (SELECT 1 FROM Students WHERE UserID = @UserID AND StudiesID = @StudiesID)
    BEGIN
        SET @CanPurchase = 0; -- User is already enrolled
    END

    -- Check if the maximum number of students has been reached
    IF @CanPurchase = 1
    BEGIN
        DECLARE @MaxStudents INT;
        SELECT @MaxStudents = MaxStudents FROM Studies WHERE StudiesID = @StudiesID;

        DECLARE @CurrentEnrollments INT;
        SELECT @CurrentEnrollments = COUNT(*) FROM Students WHERE StudiesID = @StudiesID;

        IF @CurrentEnrollments >= @MaxStudents
        BEGIN
            SET @CanPurchase = 0; -- Maximum number of students reached
        END
    END

    -- Check if it's not too late to purchase the studies
    IF @CanPurchase = 1
    BEGIN
        DECLARE @MaxDaysForPayment INT;
        SET @MaxDaysForPayment = dbo.GetMaxDaysForPaymentBeforeStudiesStart(@StudiesID);
        DECLARE @StudiesStartDate DATETIME;
        SELECT @StudiesStartDate = StartDate FROM Studies WHERE StudiesID = @StudiesID;

        IF GETDATE() > DATEADD(DAY, -@MaxDaysForPayment, @StudiesStartDate)
        BEGIN
            SET @CanPurchase = 0; -- Too late to enroll
        END
    END

    -- Check if user has completed the previous semester (if applicable)
    IF @CanPurchase = 1
    BEGIN
        DECLARE @SemesterNumber INT, @FieldOfStudiesID INT;
        SELECT @SemesterNumber = SemesterNumber, @FieldOfStudiesID = FieldOfStudiesID FROM Studies WHERE StudiesID = @StudiesID;

        IF @SemesterNumber > 1
        BEGIN
            DECLARE @PreviousSemesterID INT;
            SELECT @PreviousSemesterID = StudiesID FROM Studies 
            WHERE FieldOfStudiesID = @FieldOfStudiesID AND SemesterNumber = @SemesterNumber - 1;

            IF NOT EXISTS (SELECT 1 FROM Students WHERE UserID = @UserID AND StudiesID = @PreviousSemesterID AND Completed = 1)
            BEGIN
                SET @CanPurchase = 0; -- User did not complete the previous semester
            END
        END
    END

    RETURN @CanPurchase;
END;
GO

-- Procedura przetwarzająca płatność za studia.
CREATE OR ALTER PROCEDURE ProcessStudiesPayment
    @UserID int,
    @StudiesID int,
    @Price money,
    @Status nvarchar(300)
AS
BEGIN
    -- Declare a variable to store the newly created payment ID
    DECLARE @NewPaymentID int;

    -- Insert the payment into Payments table and store its ID
    INSERT INTO Payments (UserID, ProductID, Price, Date, Status)
    VALUES (@UserID, @StudiesID, @Price, GETDATE(), @Status);

    SET @NewPaymentID = SCOPE_IDENTITY();

    -- Exit if payment status is 'Failed'
    IF @Status = 'Failed' RETURN;

    -- Check if the user is not already a student for the specified studies
    IF NOT EXISTS (SELECT * FROM Students WHERE UserID = @UserID AND StudiesID = @StudiesID)
    BEGIN
        -- Check if the price is either EntryFee or Full Price
        DECLARE @EntryFee money, @FullPrice money;
        SELECT @EntryFee = AdvancePayment, @FullPrice = Price 
        FROM Products 
        WHERE ProductID = @StudiesID;

        -- Perform additional check
        IF dbo.CanUserPurchaseStudies(@UserID, @StudiesID) = 1
        BEGIN
            IF @Price = @EntryFee OR @Price = @FullPrice
            BEGIN
                -- Insert record into Students
                INSERT INTO Students (UserID, StudiesID, StudiesPrice, EntryFee, AddedAt, FullPaymentID, EntryFeePaymentID)
                VALUES (@UserID, @StudiesID, @FullPrice, @EntryFee, GETDATE(),
                        CASE WHEN @Price = @FullPrice THEN @NewPaymentID ELSE NULL END,
                        CASE WHEN @Price = @EntryFee THEN @NewPaymentID ELSE NULL END);
            END
            ELSE
            BEGIN
                RAISERROR('Invalid price amount.', 16, 1);
                RETURN;
            END
        END
        ELSE
        BEGIN
            RAISERROR('User cannot purchase these studies.', 16, 1);
            RETURN;
        END
    END
    ELSE
    BEGIN
        DECLARE @RemainingPrice money;
    DECLARE @StudiesPrice money;
    DECLARE @DuePostponedPayment datetime;
        SELECT @RemainingPrice = StudiesPrice - EntryFee ,
         @StudiesPrice = StudiesPrice,
         @DuePostponedPayment = DuePostponedPayment
        FROM Students 
        WHERE UserID = @UserID AND StudiesID = @StudiesID;

        -- Consult GetMaxDaysForPaymentBeforeStudiesStart
        DECLARE @MaxDaysForPayment int, @StudiesStartDate datetime, @RemainingPaymentID int,
          @EntryFeePaymentID int, @FullPaymentID int
        SELECT @MaxDaysForPayment = dbo.GetMaxDaysForPaymentBeforeStudiesStart(@StudiesID);
        SELECT @StudiesStartDate = (SELECT StartDate FROM Studies WHERE StudiesID=@StudiesID);
        SELECT @RemainingPaymentID = RemainingPaymentID,
               @EntryFeePaymentID = EntryFeePaymentID,
               @FullPaymentID = FullPaymentID
          FROM Students WHERE UserID = @UserID AND StudiesID=@StudiesID;

    IF @Price = @StudiesPrice AND @FullPaymentID IS NULL AND @EntryFeePaymentID IS NULL
      AND @RemainingPaymentID IS NULL AND @DuePostponedPayment IS NOT NULL
        BEGIN
        UPDATE Students 
        SET FullPaymentID = @NewPaymentID
        WHERE UserID = @UserID AND StudiesID = @StudiesID;	
      RETURN;
    END 


        IF @Price = @RemainingPrice AND GETDATE() < DATEADD(DAY, -@MaxDaysForPayment, @StudiesStartDate)
        AND @RemainingPaymentID IS NULL
        BEGIN
            -- Link up the remaining price payment
            UPDATE Students 
            SET RemainingPaymentID = @NewPaymentID 
            WHERE UserID = @UserID AND StudiesID = @StudiesID;
        END
        ELSE
        BEGIN
            RAISERROR('Payment amount does not match the remaining price or it is too late for payment.', 16, 1);
            RETURN;
        END

    END
END;
GO

-- Procedura ogólna przetwarzająca płatność, delegująca do odpowiedniej procedury w zależności od rodzaju produktu.
CREATE OR ALTER PROCEDURE ProcessPayment
    @UserID int,
    @ProductID int,
    @Price money,
    @Status nvarchar(300)
AS
BEGIN
    -- Declare variable to store the product type
    DECLARE @ProductType nvarchar(max);

    -- Get the product type
    SELECT @ProductType = ProductType
    FROM Products
    WHERE ProductID = @ProductID;

    -- Check the product type and delegate to the appropriate procedure
    IF @ProductType = 'webinar'
    BEGIN
        -- Call ProcessWebinarPayment procedure
        EXEC ProcessWebinarPayment @UserID, @ProductID, @Price, @Status;
    END
    ELSE IF @ProductType = 'course'
    BEGIN
        -- Call ProcessCoursePayment procedure
        EXEC ProcessCoursePayment @UserID, @ProductID, @Price, @Status;
    END
    ELSE IF @ProductType = 'studies'
    BEGIN
        -- Call ProcessStudiesPayment procedure
        EXEC ProcessStudiesPayment @UserID, @ProductID, @Price, @Status;
    END
    ELSE IF @ProductType = 'public study session'
    BEGIN
        -- Call ProcessPublicStudySessionPayment procedure
        EXEC ProcessPublicStudySessionPayment @UserID, @ProductID, @Price, @Status;
    END
    ELSE
    BEGIN
        -- Handle unknown product types
        RAISERROR('Unknown product type.', 16, 1);
    END
END;
GO

-- Procedura umożliwiająca odroczenie płatności za produkt.
CREATE OR ALTER PROCEDURE EnrollUserWithoutImmediatePayment
    @UserID int,
    @ProductID int,
    @DuePostponedPayment datetime
AS
BEGIN
    -- Variables for product details
    DECLARE @ProductPrice money
    DECLARE @AdvancePayment money
    DECLARE @ProductType nvarchar(max)
    DECLARE @Exists bit

    -- Initialize the variable to check existence
    SET @Exists = 0

    -- Retrieve the price, advance payment, and type of the product from the Products table
    SELECT 
        @ProductPrice = Price, 
        @AdvancePayment = ISNULL(AdvancePayment, 0), 
        @ProductType = ProductType 
    FROM Products 
    WHERE ProductID = @ProductID

    -- Check if the user is already enrolled in the product
    IF @ProductType = 'studies'
    BEGIN
        IF EXISTS (SELECT 1 FROM Students WHERE UserID = @UserID AND StudiesID = @ProductID)
            SET @Exists = 1
    END
    ELSE IF @ProductType = 'course'
    BEGIN
        IF EXISTS (SELECT 1 FROM CourseParticipants WHERE UserID = @UserID AND CourseID = @ProductID)
            SET @Exists = 1
    END
    ELSE IF @ProductType = 'webinar'
    BEGIN
        IF EXISTS (SELECT 1 FROM WebinarParticipants WHERE UserID = @UserID AND WebinarID = @ProductID)
            SET @Exists = 1
    END
    ELSE IF @ProductType = 'public study session'
    BEGIN
        IF EXISTS (SELECT 1 FROM PublicStudySessionParticipants WHERE UserID = @UserID AND PublicStudySessionID = @ProductID)
            SET @Exists = 1
    END

    -- Insert the record only if the user is not already enrolled
    IF @Exists = 0
    BEGIN
        -- Insert logic based on product type
        IF @ProductType = 'studies'
        BEGIN
            INSERT INTO Students (UserID, StudiesID, StudiesPrice, EntryFee, DuePostponedPayment, Completed)
            VALUES (@UserID, @ProductID, @ProductPrice, @AdvancePayment, @DuePostponedPayment, 0)
        END
        ELSE IF @ProductType = 'course'
        BEGIN
            INSERT INTO CourseParticipants (UserID, CourseID, CoursePrice, EntryFee, DuePostponedPayment, Completed)
            VALUES (@UserID, @ProductID, @ProductPrice, @AdvancePayment, @DuePostponedPayment, 0)
        END
        ELSE IF @ProductType = 'webinar'
        BEGIN
            INSERT INTO WebinarParticipants (UserID, WebinarID, WebinarPrice, DuePostponedPayment)
            VALUES (@UserID, @ProductID, @ProductPrice, @DuePostponedPayment)
        END
        ELSE IF @ProductType = 'public study session'
        BEGIN
            INSERT INTO PublicStudySessionParticipants (UserID, PublicStudySessionID, SessionPrice, DuePostponedPayment)
            VALUES (@UserID, @ProductID, @ProductPrice, @DuePostponedPayment)
        END
    END
    ELSE
    BEGIN
        -- Handle the case where the user is already enrolled
        PRINT 'User is already enrolled in this product.'
    END
END;
GO-- Funkcja zwracająca harmonogram pracownika w określonym przedziale czasowym
CREATE OR ALTER FUNCTION GetEmployeeTimetable 
(
    @EmployeeID INT,
    @StartDate DATETIME,
    @EndDate DATETIME
)
RETURNS TABLE
AS
RETURN 
(
    SELECT * 
    FROM EmployeeTimeTable
    WHERE EmployeeID = @EmployeeID
      AND StartDate >= @StartDate
      AND EndDate <= @EndDate
);
GO

-- Funkcja zwracająca harmonogram zajęć użytkownika w określonym przedziale czasowym
CREATE OR ALTER FUNCTION GetUserTimeTable 
(
    @UserID INT,
    @StartDate DATETIME,
    @EndDate DATETIME
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        T.*
    FROM 
        TimeTableForAllUsers T
    WHERE 
        T.UserID = @UserID
        AND T.StartDate >= @StartDate
        AND T.EndDate <= @EndDate
);
GO