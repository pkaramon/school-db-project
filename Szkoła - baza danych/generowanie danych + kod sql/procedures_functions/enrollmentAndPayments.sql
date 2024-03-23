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
GO