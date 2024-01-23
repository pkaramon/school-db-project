-- Trigger zapisujący w tabeli PeopleDataChangeHistory zmiany danych osób, takie jak imię, nazwisko, data urodzenia, adres, miasto, region, kod pocztowy, kraj, email i telefon.
CREATE OR ALTER TRIGGER tr_People_AfterUpdate
ON People
AFTER UPDATE
AS
BEGIN
    -- Insert the changed data into the PeopleDataChangeHistory table
    INSERT INTO PeopleDataChangeHistory (
        PersonID,
        ChangedAt,
        New_FirstName,
        Old_FirstName,
        New_LastName,
        Old_LastName,
        New_BirthDate,
        Old_BirthDate,
        New_Address,
        Old_Address,
        New_City,
        Old_City,
        New_Region,
        Old_Region,
        New_PostalCode,
        Old_PostalCode,
        New_Country,
        Old_Country,
        New_Email,
        Old_Email,
        New_Phone,
        Old_Phone
    )
    SELECT
        i.PersonID,
        GETDATE(),
        i.FirstName,
        d.FirstName,
        i.LastName,
        d.LastName,
        i.BirthDate,
        d.BirthDate,
        i.Address,
        d.Address,
        i.City,
        d.City,
        i.Region,
        d.Region,
        i.PostalCode,
        d.PostalCode,
        i.Country,
        d.Country,
        i.Email,
        d.Email,
        i.Phone,
        d.Phone
    FROM
        inserted i
    JOIN
        deleted d ON i.PersonID = d.PersonID
    WHERE
        i.FirstName <> d.FirstName
        OR i.LastName <> d.LastName
        OR i.BirthDate <> d.BirthDate
        OR i.Address <> d.Address
        OR i.City <> d.City
        OR i.Region <> d.Region
        OR i.PostalCode <> d.PostalCode
        OR i.Country <> d.Country
        OR i.Email <> d.Email
        OR i.Phone <> d.Phone;
END;
GO

-- Trigger rejestrujący w tabeli CartHistory usunięcie produktu z koszyka, zawierający informacje o użytkowniku, produkcie, dacie dodania i usunięcia.
CREATE OR ALTER TRIGGER trg_RemoveProductFromCart
ON Carts
AFTER DELETE
AS
BEGIN
    INSERT INTO CartHistory (UserID, ProductID, AddedAt, RemovedAt)
    SELECT d.UserID, d.ProductID, d.AddedAt, GETDATE()
    FROM deleted d;
END;
GO

-- Trigger zapisujący w tabeli ProductPriceChangeHistory zmiany ceny i zaliczki produktów, zawierający identyfikator produktu, starą i nową cenę, starą i nową zaliczkę oraz datę zmiany.
CREATE OR ALTER TRIGGER RecordPriceChange
ON Products
AFTER UPDATE
AS
BEGIN
    -- Insert the price change into the ProductPriceChangeHistory table
    INSERT INTO ProductPriceChangeHistory (ProductID, Old_Price, New_Price, Old_AdvancePayment, New_AdvancePayment, ChangedAt)
    SELECT 
        d.ProductID,
        d.Price, -- Old price
        i.Price, -- New price
        d.AdvancePayment, -- Old advance payment
        i.AdvancePayment, -- New advance payment
        GETDATE()
    FROM deleted d
    INNER JOIN inserted i ON d.ProductID = i.ProductID
    WHERE d.Price <> i.Price OR d.AdvancePayment <> i.AdvancePayment;
END;
GO
-- Trigger sprawdzający nakładanie się zakresów dat w wymaganiach dotyczących minimalnej frekwencji na kursach.
CREATE OR ALTER TRIGGER trg_CheckOverlap_MinAttendanceCourse
ON MinAttendancePercentageToPassCourse
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM MinAttendancePercentageToPassCourse m
        INNER JOIN inserted i ON m.CourseID = i.CourseID OR (m.CourseID IS NULL AND i.CourseID IS NULL)
        WHERE 
            m.MinAttendancePercentageToPassCourseID <> i.MinAttendancePercentageToPassCourseID AND
            (m.StartDate < COALESCE(i.EndDate, '9999-12-31') AND COALESCE(m.EndDate, '9999-12-31') > i.StartDate)
    )
    BEGIN
        RAISERROR ('Date range overlaps with existing entry.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

-- Trigger zapobiegający nakładaniu się zakresów dat w wymaganiach dotyczących minimalnej frekwencji na stażach.
CREATE OR ALTER TRIGGER trg_CheckOverlap_MinAttendanceInternship
ON MinAttendancePercentageToPassInternship
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM MinAttendancePercentageToPassInternship m
        INNER JOIN inserted i ON m.InternshipID = i.InternshipID OR (m.InternshipID IS NULL AND i.InternshipID IS NULL)
        WHERE 
            m.MinAttendancePercentageToPassInternshipID <> i.MinAttendancePercentageToPassInternshipID AND
            (m.StartDate < COALESCE(i.EndDate, '9999-12-31') AND COALESCE(m.EndDate, '9999-12-31') > i.StartDate)
    )
    BEGIN
        RAISERROR ('Date range overlaps with existing entry.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

-- Trigger kontrolujący nakładanie się zakresów dat w wymaganiach dotyczących minimalnej frekwencji na studiach.
CREATE OR ALTER TRIGGER trg_CheckOverlap_MinAttendanceStudies
ON MinAttendancePercentageToPassStudies
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM MinAttendancePercentageToPassStudies m
        INNER JOIN inserted i ON m.StudiesID = i.StudiesID OR (m.StudiesID IS NULL AND i.StudiesID IS NULL)
        WHERE 
            m.MinAttendancePercentageToPassStudiesID <> i.MinAttendancePercentageToPassStudiesID AND
            (m.StartDate < COALESCE(i.EndDate, '9999-12-31') AND COALESCE(m.EndDate, '9999-12-31') > i.StartDate)
    )
    BEGIN
        RAISERROR ('Date range overlaps with existing entry.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

-- Trigger sprawdzający nakładanie się zakresów dat w regulaminie maksymalnego czasu na zapłatę przed rozpoczęciem kursu.
CREATE OR ALTER TRIGGER trg_CheckOverlap_MaxDaysPaymentCourse
ON MaxDaysForPaymentBeforeCourseStart
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM MaxDaysForPaymentBeforeCourseStart m
        INNER JOIN inserted i ON m.CourseID = i.CourseID OR (m.CourseID IS NULL AND i.CourseID IS NULL)
        WHERE 
            m.MaxDaysForPaymentBeforeCourseStartID <> i.MaxDaysForPaymentBeforeCourseStartID AND
            (m.StartDate < COALESCE(i.EndDate, '9999-12-31') AND COALESCE(m.EndDate, '9999-12-31') > i.StartDate)
    )
    BEGIN
        RAISERROR ('Date range overlaps with existing entry.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

-- Trigger zapobiegający nakładaniu się zakresów dat dotyczących maksymalnego czasu na zapłatę przed rozpoczęciem studiów.
CREATE OR ALTER TRIGGER trg_CheckOverlap_MaxDaysPaymentStudies
ON MaxDaysForPaymentBeforeStudiesStart
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM MaxDaysForPaymentBeforeStudiesStart m
        INNER JOIN inserted i ON m.StudiesID = i.StudiesID
        WHERE 
            m.MaxDaysForPaymentBeforeStudiesStartID <> i.MaxDaysForPaymentBeforeStudiesStartID AND
            (m.StartDate < COALESCE(i.EndDate, '9999-12-31') AND COALESCE(m.EndDate, '9999-12-31') > i.StartDate)
    )
    BEGIN
        RAISERROR ('Date range overlaps with existing entry.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

-- Trigger kontrolujący nakładanie się zakresów dat w dostępie do nagrań webinarów.
CREATE OR ALTER TRIGGER trg_CheckOverlap_RecordingAccessTime
ON RecordingAccessTime
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM RecordingAccessTime m
        INNER JOIN inserted i ON m.WebinarID = i.WebinarID OR (m.WebinarID IS NULL AND i.WebinarID IS NULL)
        WHERE 
            m.RecordingAcessTimeID <> i.RecordingAcessTimeID AND
            (m.StartDate < COALESCE(i.EndDate, '9999-12-31') AND COALESCE(m.EndDate, '9999-12-31') > i.StartDate)
    )
    BEGIN
        RAISERROR ('Date range overlaps with existing entry.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

-- Trigger sprawdzający nakładanie się zakresów dat w określonych dniach stażu.
CREATE OR ALTER TRIGGER trg_CheckOverlap_DaysInInternship
ON DaysInInternship
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM DaysInInternship m
        INNER JOIN inserted i ON m.InternshipID = i.InternshipID OR (m.InternshipID IS NULL AND i.InternshipID IS NULL)
        WHERE 
            m.DaysInInternshipID <> i.DaysInInternshipID AND
            (m.StartDate < COALESCE(i.EndDate, '9999-12-31') AND COALESCE(m.EndDate, '9999-12-31') > i.StartDate)
    )
    BEGIN
        RAISERROR ('Date range overlaps with existing entry.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO