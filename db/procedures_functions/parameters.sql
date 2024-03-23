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

