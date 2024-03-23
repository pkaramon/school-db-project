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