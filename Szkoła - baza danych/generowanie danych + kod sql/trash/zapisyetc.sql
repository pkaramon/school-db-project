CREATE OR ALTER FUNCTION dbo.CanUserPurchaseCourse(@UserID INT, @CourseID INT)
RETURNS BIT
AS
BEGIN
    DECLARE @CanPurchase BIT = 1; -- Default: user can purchase the course

    -- Check if the course is closed
    IF EXISTS (SELECT 1 FROM Products WHERE ProductID = @CourseID AND ClosedAt IS NOT NULL AND ClosedAt <= GETDATE())
    BEGIN
        SET @CanPurchase = 0; -- Course is closed
    END

    -- Check if user is already enrolled in the course
    IF @CanPurchase = 1 AND EXISTS (SELECT 1 FROM CourseParticipants WHERE UserID = @UserID AND CourseID = @CourseID)
    BEGIN
        SET @CanPurchase = 0; -- User is already enrolled
    END

    -- Check if the course has a maximum student limit and if it's reached
    IF @CanPurchase = 1
    BEGIN
        DECLARE @MaxStudents INT;
        SELECT @MaxStudents = MaxStudents FROM Courses WHERE CourseID = @CourseID;

    IF @MaxStudents IS NOT NULL
    BEGIN
        DECLARE @CurrentEnrollments INT;
        SELECT @CurrentEnrollments = COUNT(*) FROM CourseParticipants WHERE CourseID = @CourseID;

        IF @CurrentEnrollments >= @MaxStudents
        BEGIN
            SET @CanPurchase = 0; -- No more seats available
        END
    END
END

-- Check if it's not too late to purchase the course
IF @CanPurchase = 1
BEGIN
    DECLARE @MaxDaysForPayment INT;
    SET @MaxDaysForPayment = dbo.GetMaxDaysForPaymentBeforeCourseStart(@CourseID);
    DECLARE @CourseStartDate DATETIME;
    SELECT @CourseStartDate = StartDate FROM Courses WHERE CourseID = @CourseID;

    IF GETDATE() > DATEADD(DAY, -@MaxDaysForPayment, @CourseStartDate)
    BEGIN
        SET @CanPurchase = 0; -- Too late to purchase the course
    END
END

RETURN @CanPurchase;
END;
GO


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


CREATE OR ALTER FUNCTION dbo.CanUserPurchaseWebinar(@UserID INT, @WebinarID INT)
RETURNS BIT
AS
BEGIN
    DECLARE @CanPurchase BIT;

    -- Check if the user can purchase the webinar
    SELECT @CanPurchase =
        CASE
            WHEN P.ClosedAt IS NULL AND
                 (
                     (GETDATE() <= W.StartDate AND WP.WebinarParticipantID IS NULL) OR
                     (GETDATE() > W.EndDate)
                 )
                THEN 1
            ELSE 0
        END
    FROM Webinars W
    LEFT JOIN WebinarParticipants WP ON W.WebinarID = WP.WebinarID AND WP.UserID = @UserID
    LEFT JOIN Products P ON W.WebinarID = P.ProductID
    WHERE W.WebinarID = @WebinarID;

    -- Return 1 if the user can purchase, otherwise 0
    RETURN @CanPurchase;
END;
GO

  
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
END
GO

CREATE OR ALTER PROCEDURE ProcessPayment
    @UserID int,
    @ProductID int,
    @Price money,
    @Status nvarchar(300)
AS
BEGIN
    -- Insert payment record and capture the PaymentID
    DECLARE @PaymentID int;
    INSERT INTO Payments (UserID, ProductID, Price, Date, Status)
    VALUES (@UserID, @ProductID, @Price, GETDATE(), @Status);

    SET @PaymentID = SCOPE_IDENTITY();

    -- If payment failed, exit the procedure
    IF @Status = 'Failed'
        RETURN;

    -- Determine the product type and prices
    DECLARE @ProductType nvarchar(max);
    DECLARE @ProductPrice money, @AdvancePayment money, @RemainingPayment money;
    SELECT @ProductType = ProductType, @ProductPrice = Price, @AdvancePayment = AdvancePayment 
    FROM Products 
    WHERE ProductID = @ProductID;

    -- Process payment based on product type
    IF @ProductType = 'webinar'
    BEGIN
        IF dbo.CanUserPurchaseWebinar(@UserID, @ProductID) = 1
        BEGIN
            INSERT INTO WebinarParticipants (UserID, WebinarID, WebinarPrice, FullPricePaymentID)
            VALUES (@UserID, @ProductID, @ProductPrice, @PaymentID);
        END
    END
    ELSE IF @ProductType = 'public study session'
    BEGIN
        IF dbo.CanUserPurchasePublicStudySession(@UserID, @ProductID) = 1
        BEGIN
            INSERT INTO PublicStudySessionParticipants (UserID, PublicStudySessionID, SessionPrice, FullPricePaymentID)
            VALUES (@UserID, @ProductID, @ProductPrice, @PaymentID);
        END
    END
    ELSE IF @ProductType = 'course'
    BEGIN
        SET @RemainingPayment = @ProductPrice - @AdvancePayment;

        IF dbo.CanUserPurchaseCourse(@UserID, @ProductID) = 1
        BEGIN
      IF @Price = @ProductPrice
      BEGIN
        -- Full price payment
        INSERT INTO CourseParticipants (UserID, CourseID, CoursePrice, FullPricePaymentID, AddedAt, Completed)
        VALUES (@UserID, @ProductID, @ProductPrice, @PaymentID, GETDATE(), 0);
      END
      ELSE IF @Price = @AdvancePayment
      BEGIN
        -- Advance payment
        INSERT INTO CourseParticipants (UserID, CourseID, CoursePrice, EntryFee, EntryFeePaymentID, AddedAt, Completed)
        VALUES (@UserID, @ProductID, @ProductPrice, @AdvancePayment, @PaymentID, GETDATE(), 0);
      END
    END
        ELSE IF @Price = @RemainingPayment
        BEGIN
            -- Remaining payment
            UPDATE CourseParticipants SET RemainingPaymentID = @PaymentID WHERE UserID = @UserID AND CourseID = @ProductID;
        END

    END
    ELSE IF @ProductType = 'studies'
    BEGIN
        SET @RemainingPayment = @ProductPrice - @AdvancePayment;

        IF dbo.CanUserPurchaseStudies(@UserID, @ProductID) = 1
        BEGIN
            IF @Price = @ProductPrice
            BEGIN
                -- Full price payment
                INSERT INTO Students (UserID, StudiesID, StudiesPrice, FullPaymentID, AddedAt, Completed)
                VALUES (@UserID, @ProductID, @ProductPrice, @PaymentID, GETDATE(), 0);
            END
            ELSE IF @Price = @AdvancePayment
            BEGIN
                -- Advance payment
                INSERT INTO Students (UserID, StudiesID, StudiesPrice, EntryFee, EntryFeePaymentID, AddedAt, Completed)
                VALUES (@UserID, @ProductID, @ProductPrice, @AdvancePayment, @PaymentID, GETDATE(), 0);
            END
        END
            ELSE IF @Price = @RemainingPayment
            BEGIN
                -- Remaining payment
                UPDATE Students SET RemainingPaymentID = @PaymentID WHERE UserID = @UserID AND StudiesID = @ProductID;
            END
    END
END;
GO

