
-- Widok prezentujący konflikty terminów zajęć dla użytkowników
CREATE OR ALTER VIEW ActivityConflicts AS
WITH AUX AS (
    SELECT WP.UserID, W.StartDate, W.EndDate, 'webinar' as 'ActivityType', W.WebinarID as 'ActivityID'
    FROM Webinars W 
    JOIN WebinarParticipants WP ON WP.WebinarID = W.WebinarID
    UNION
    SELECT CP.UserID, ISNULL(CSS.StartDate, COS.StartDate), ISNULL(CSS.StartDate, COS.StartDate),
        'CourseSession', CS.CourseSessionID
    FROM CoursesSessions CS 
    JOIN Modules M ON M.ModuleID = CS.ModuleID
    JOIN Courses C ON C.CourseID = M.CourseID
    JOIN CourseParticipants CP ON CP.CourseID = C.CourseID
    LEFT JOIN CourseStationarySessions CSS ON CSS.CourseStationarySessionID = CS.CourseSessionID
    LEFT JOIN CourseOnlineSessions COS ON COS.CourseOnlineSessionID = CS.CourseSessionID
    WHERE CSS.CourseStationarySessionID IS NOT NULL OR COS.CourseOnlineSessionID IS NOT NULL
    UNION
    SELECT STU.UserID, SS.StartDate, SS.EndDate, 'StudiesSession', SS.StudiesSessionID
    FROM StudiesSessions SS
    JOIN Subjects S ON S.SubjectID = SS.SubjectID
    JOIN Studies ST ON ST.StudiesID = S.StudiesID
    JOIN Students STU ON STU.StudiesID = ST.StudiesID
    UNION
    SELECT PSSP.UserID, SS.StartDate, SS.EndDate, 'PublicStudySession', PSSP.PublicStudySessionParticipantID
    FROM PublicStudySessions PSS 
    JOIN PublicStudySessionParticipants PSSP ON PSSP.PublicStudySessionID = PSS.PublicStudySessionID
    JOIN StudiesSessions SS ON SS.StudiesSessionID = PSS.StudiesSessionID
)
SELECT 
    a1.UserID, 
    P.FirstName, 
    P.LastName, 
    P.Phone,
    P.Email,
    a1.StartDate AS 'Activity_1_Start', 
    a1.EndDate AS 'Activity_1_End', 
    a1.ActivityType as 'Activity_1_Type',
    a1.ActivityID as 'Activity_1_ID',
    a2.StartDate AS 'Activity_2_Start', 
    a2.EndDate AS 'Activity_2_End',
    a2.ActivityType AS 'Activity_2_Type',
    a2.ActivityID AS 'Activity2_ID'
FROM 
    AUX a1
JOIN 
    AUX a2 
ON 
    a1.UserID = a2.UserID AND 
    a1.StartDate < a2.EndDate AND 
    a1.EndDate > a2.StartDate AND
    a1.StartDate < a2.StartDate
JOIN People P ON P.PersonID = a1.UserID
WHERE 
    a1.UserID = a2.UserID;
GO

-- Widok prezentujący bieżącą ofertę edukacyjną (webinary, kursy, studia)
CREATE OR ALTER VIEW SchoolOffer AS
SELECT 
        W.WebinarID as 'ProductID',
       'Webinar' as'ProductType',
        W.WebinarName,
        W.Description,
        Price as 'TotalPrice',
        NULL as 'AdvancePayment',
        StartDate,
        EndDate
FROM Webinars W 
JOIN Products P ON W.WebinarID = P.ProductID AND P.ClosedAt IS NULL
UNION
SELECT C.CourseID, 'Course', C.CourseName, C.[Description], P.Price, P.AdvancePayment, C.StartDate, C.EndDate
FROM Courses C 
JOIN Products P ON P.ProductID = C.CourseID AND P.ClosedAt IS NULL AND C.StartDate > GETDATE()
UNION
SELECT S.StudiesID, 'Studies', S.Name, S.[Description], P.Price, P.AdvancePayment, S.StartDate, S.EndDate
FROM Studies S
JOIN Products P ON P.ProductID = S.StudiesID AND P.ClosedAt IS NULL
WHERE S.StartDate > GETDATE()
UNION
SELECT 
        PSS.PublicStudySessionID,
       'Public Study Session',
       'Sesja również dla osób z zewnątrz' + S.[Description],
        S.[Description],
        P.Price, 
        P.AdvancePayment,
        SS.StartDate,
        SS.EndDate
FROM PublicStudySessions PSS 
JOIN Products P ON P.ProductID = PSS.PublicStudySessionID AND P.ClosedAt IS NULL
JOIN StudiesSessions SS ON SS.StudiesSessionID = PSS.StudiesSessionID
JOIN Subjects S ON S.SubjectID = SS.SubjectID
WHERE SS.StartDate > GETDATE();
GO

-- Widok prezentujący harmonogram pracy pracowników
CREATE OR ALTER VIEW EmployeeTimeTable AS
WITH EmployeeData AS (
    SELECT E.EmployeeID, P.FirstName + ' ' + P.LastName as 'FullName'
    FROM Employees E
    JOIN People P ON P.PersonID = E.EmployeeID
)
SELECT 'Stationary Course Session' as 'Session Type',
        CSS.CourseStationarySessionID 'SessionID',
        ED.EmployeeID as 'EmployeeID',
        ED.FullName as 'FullName',
        CSS.StartDate, CSS.EndDate
FROM CourseStationarySessions CSS 
JOIN CoursesSessions CS ON CS.CourseSessionID = CSS.CourseStationarySessionID
JOIN EmployeeData ED ON ED.EmployeeID = CS.LecturerID
UNION
SELECT 'Online Course Session',
        COS.CourseOnlineSessionID,
        ED.EmployeeID,
        ED.FullName,
        COS.StartDate, 
        COS.EndDate
FROM CourseOnlineSessions COS
JOIN CoursesSessions CS ON CS.CourseSessionID = COS.CourseOnlineSessionID
JOIN EmployeeData ED ON ED.EmployeeID = CS.LecturerID
UNION 
SELECT 'Webinar', W.WebinarID, ED.EmployeeID, ED.FullName, W.StartDate, W.EndDate
FROM Webinars W 
JOIN EmployeeData ED ON ED.EmployeeID = W.LecturerID
UNION 
SELECT 'Studies Session',
        SS.StudiesSessionID, 
        ED.EmployeeID, 
        ED.FullName,
        SS.StartDate,
        SS.EndDate
FROM StudiesSessions SS
JOIN EmployeeData ED ON ED.EmployeeID = SS.LecturerID;
GO


-- Widok prezentujący statystyki dotyczące aktywności pracowników
CREATE OR ALTER VIEW EmployeeStatistics AS
SELECT 
    E.EmployeeID,
    P.FirstName, 
    P.LastName,
    (
        SELECT COUNT(*)
        FROM Webinars W
        WHERE W.LecturerID = E.EmployeeID
    ) as 'WebinarsConducted',
    (
        SELECT COUNT(*)
        FROM Courses C
        WHERE C.CoordinatorID = E.EmployeeID
    ) as 'CoursesCoordinated',
    (
        SELECT COUNT(*)
        FROM Studies S 
        WHERE S.CoordinatorID = E.EmployeeID
    ) as 'StudiesCoordinated',
    (
        SELECT COUNT(*)
        FROM StudiesSessions SS
        WHERE SS.LecturerID = E.EmployeeID AND SS.EndDate >  GETDATE()
    ) as 'StudiesSessionsConducted',
    (
        SELECT COUNT(COS.CourseOnlineSessionID) + COUNT(CSS.CourseStationarySessionID)
        FROM CoursesSessions CS 
        LEFT JOIN CourseOnlineSessions COS ON
             COS.CourseOnlineSessionID = CS.CourseSessionID AND COS.StartDate < GETDATE()
        LEFT JOIN CourseStationarySessions CSS ON 
             CSS.CourseStationarySessionID = CS.CourseSessionID AND CSS.EndDate < GETDATE()
        WHERE CS.LecturerID = E.EmployeeID
    ) as 'CourseSessionsConducted'

FROM Employees E 
JOIN People P ON P.PersonID = E.EmployeeID;
GO

-- Widok prezentujący łączne przychody z różnych produktów edukacyjnych
CREATE OR ALTER VIEW TotalIncomeForProducts AS
WITH ProductsIncome AS (
    SELECT 
        W.WebinarID AS 'ProductID',
    'Webinar' AS 'ProductType',
        W.WebinarName AS 'ProductName',
        W.Description,
        W.StartDate AS 'Date',
        W.LecturerID AS 'MainEmployeeId'
    FROM Webinars W

    UNION

    SELECT 
        C.CourseID,
    'Course',
        C.CourseName,
        C.Description,
        C.StartDate,
        C.CoordinatorID
    FROM Courses C

    UNION

    SELECT 
        S.StudiesID,
    'Studies',
        S.Name,
        S.Description,
        CONVERT(datetime, S.StartDate) AS 'Date',
        S.CoordinatorID
    FROM Studies S

  UNION

  SELECT 
    P.PublicStudySessionID,
    'Public study session',
    S.SubjectName,
    P.Description,
    SS.StartDate,
    SS.LecturerID
  FROM PublicStudySessions P
  JOIN StudiesSessions SS ON SS.StudiesSessionID = P.StudiesSessionID
  JOIN Subjects S ON SS.SubjectID = S.SubjectID
)
SELECT 
    PI.ProductID,
  PI.ProductType,
    PI.ProductName,
  ISNULL(SUM(P.Price),0) as 'Income',
    PI.Description,
    PI.Date,
    PP.FirstName + ' ' + PP.LastName AS 'MainEmployee'
FROM ProductsIncome PI
JOIN Employees E ON E.EmployeeID = PI.MainEmployeeId
JOIN People PP ON PP.PersonID = E.EmployeeID
LEFT JOIN Payments P ON P.ProductID = PI.ProductID AND P.Status='Successful'
GROUP BY PI.ProductID, PI.ProductType, PI.ProductName, PI.Description, PI.Date, PP.FirstName + ' ' + PP.LastName
HAVING PI.Date < GETDATE();
GO

-- Widok prezentujący miesięczne i roczne podsumowanie przychodów według typów produktów
CREATE OR ALTER VIEW RevenueSummaryByProductType AS
SELECT
    ISNULL(CAST(YEAR(P.Date) AS NVARCHAR(4)), 'Total') AS RevenueYear,
    CASE 
        WHEN MONTH(P.Date) IS NULL THEN 'Total'
        ELSE CAST(MONTH(P.Date) AS NVARCHAR(2)) 
    END AS RevenueMonth,
    COALESCE(Pr.ProductType, 'All Types') AS ProductType,
    SUM(P.Price) AS TotalRevenue
FROM
    Payments P
INNER JOIN
    Products Pr ON P.ProductID = Pr.ProductID
WHERE
    P.Status = 'Successful'
GROUP BY
    YEAR(P.Date),
    MONTH(P.Date),
    ROLLUP(Pr.ProductType);
GO



-- Widok prezentujący harmonogram zajęć dla wszystkich użytkowników
CREATE OR ALTER VIEW TimeTableForAllUsers AS
SELECT 
    S.UserID,
    'studies session' as 'type',
    SS.StartDate as 'StartDate',
    SS.EndDate as 'EndDate',
    P.FirstName + ' ' + P.LastName as 'Lecturer',
    CASE 
        WHEN SSS.StationaryStudiesSessionID IS NULL THEN 'online'
        ELSE SSS.Country + ' ' + SSS.PostalCode + ' ' + SSS.City + ' ' + SSS.Address + ' ' + SSS.ClassroomNumber
    END as 'Place'
FROM Students S
JOIN Studies ON Studies.StudiesID = S.StudiesID
JOIN Subjects ON Subjects.StudiesID = Studies.StudiesID
JOIN StudiesSessions SS ON SS.SubjectID = Subjects.SubjectID
JOIN Employees E ON E.EmployeeID = SS.LecturerID
JOIN People P ON E.EmployeeID = P.PersonID
LEFT JOIN StationaryStudiesSessions SSS ON SSS.StationaryStudiesSessionID = SS.StudiesSessionID
LEFT JOIN OnlineStudiesSessions OSS ON OSS.OnlineStudiesSessionID = SS.StudiesSessionID
UNION
SELECT 
    Wp.UserID, 
    'webinar',
    W.StartDate,
    W.EndDate,
    P.FirstName + ' ' + P.LastName,
    'online'
FROM Webinars W 
JOIN WebinarParticipants WP ON WP.WebinarID = W.WebinarID
JOIN Employees E ON W.LecturerID = E.EmployeeID
JOIN People P ON P.PersonID = E.EmployeeID
UNION
SELECT
    CP.UserID,
    'course session',
    ISNULL(CSS.StartDate, CONS.StartDate),
    ISNULL(CSS.EndDate, CONS.EndDate),
    P.FirstName + ' ' + P.LastName,
    CASE
        WHEN CSS.CourseStationarySessionID IS NOT NULL THEN
            CSS.Country + ' ' + CSS.PostalCode + ' ' + CSS.City + ' ' + CSS.Address + ' ' + CSS.ClassroomNumber
        ELSE 'online'
    END
FROM CourseParticipants CP
JOIN Courses C ON C.CourseID = CP.CourseID
JOIN Modules M ON M.CourseID = C.CourseID
JOIN CoursesSessions CS ON CS.ModuleID = M.ModuleID
JOIN Employees E ON E.EmployeeID = CS.LecturerID
JOIN People P ON P.PersonID = E.EmployeeID
LEFT JOIN CourseStationarySessions CSS ON CSS.CourseStationarySessionID = CS.CourseSessionID
LEFT JOIN CourseOnlineSessions CONS ON CONS.CourseOnlineSessionID = CS.CourseSessionID
WHERE CSS.CourseStationarySessionID IS NOT NULL OR CONS.CourseOnlineSessionID IS NOT NULL
UNION
SELECT
    PSSP.UserID,
    'public study session', 
    SS.StartDate as 'StartDate',
    SS.EndDate as 'EndDate',
    P.FirstName + ' ' + P.LastName, 
    CASE 
        WHEN SSS.StationaryStudiesSessionID IS NULL THEN 'online'
        ELSE SSS.Country + ' ' + SSS.PostalCode + ' ' + SSS.City + ' ' + SSS.Address + ' ' + SSS.ClassroomNumber
    END as 'Place'
FROM PublicStudySessionParticipants PSSP
JOIN PublicStudySessions PSS ON PSS.PublicStudySessionID = PSSP.PublicStudySessionID
JOIN StudiesSessions SS ON SS.StudiesSessionID = PSS.StudiesSessionID
LEFT JOIN StationaryStudiesSessions SSS ON SSS.StationaryStudiesSessionID = SS.StudiesSessionID
LEFT JOIN OnlineStudiesSessions OSS ON OSS.OnlineStudiesSessionID = SS.StudiesSessionID
JOIN Employees E ON E.EmployeeID = SS.LecturerID
JOIN People P ON P.PersonID = E.EmployeeID;
GO



-- Widok prezentujący listę dłużników
CREATE OR ALTER VIEW Loaners AS
WITH UserDetails AS (
    SELECT 
        U.UserID,
        P.FirstName + ' ' + P.LastName AS 'FullName',
        P.Email,
        P.Phone
    FROM 
        Users U
    JOIN People P ON P.PersonID = U.UserID
)
SELECT 
    UD.UserID,
    UD.FullName,
    UD.Email,
    UD.Phone,
    WP.WebinarID AS 'ProductIDToPay',
    'Webinar' AS 'ProductType',
    W.WebinarName AS 'ProductName',
    WP.WebinarPrice AS 'LoanAmount',
    WP.DuePostponedPayment AS 'PaymentDue'
FROM 
    WebinarParticipants WP 
JOIN UserDetails UD ON UD.UserID = WP.UserID
JOIN Webinars W ON W.WebinarID = WP.WebinarID
WHERE 
    WP.DuePostponedPayment IS NOT NULL AND WP.FullPricePaymentID IS NULL

UNION

SELECT 
    UD.UserID,
    UD.FullName,
    UD.Email,
    UD.Phone,
    CP.CourseID AS 'ProductIDToPay',
    'Course' AS 'ProductType',
    C.CourseName AS 'ProductName',
    CP.CoursePrice AS 'LoanAmount',
    CP.DuePostponedPayment AS 'PaymentDue'
FROM 
    CourseParticipants CP 
JOIN UserDetails UD ON UD.UserID = CP.UserID
JOIN Courses C ON C.CourseID = CP.CourseID
WHERE 
    CP.DuePostponedPayment IS NOT NULL AND CP.FullPricePaymentID IS NULL AND CP.EntryFeePaymentID IS NULL AND CP.RemainingPaymentID IS NULL

UNION

SELECT 
    UD.UserID,
    UD.FullName,
    UD.Email,
    UD.Phone,
    S.StudiesID AS 'ProductIDToPay',
    'Studies' AS 'ProductType',
    SS.Name AS 'ProductName',
    S.StudiesPrice - ISNULL(EFP.Price, 0) - ISNULL(RPP.Price, 0) AS 'LoanAmount',
    S.DuePostponedPayment AS 'PaymentDue'
FROM 
    Students S
JOIN UserDetails UD ON UD.UserID = S.UserID
JOIN Studies SS ON SS.StudiesID = S.StudiesID
LEFT JOIN Payments EFP ON EFP.PaymentID = S.EntryFeePaymentID
LEFT JOIN Payments RPP ON RPP.PaymentID = S.RemainingPaymentID
WHERE 
    S.DuePostponedPayment IS NOT NULL AND (S.EntryFeePaymentID IS NULL OR S.RemainingPaymentID IS NULL)

UNION

SELECT 
    UD.UserID,
    UD.FullName,
    UD.Email,
    UD.Phone,
    P.PublicStudySessionID AS 'ProductIDToPay',
    'Public Study Session' AS 'ProductType',
    S.SubjectName AS 'ProductName',
    P.SessionPrice AS 'LoanAmount',
    P.DuePostponedPayment AS 'PaymentDue'
FROM 
    PublicStudySessionParticipants P
JOIN UserDetails UD ON UD.UserID = P.UserID
JOIN PublicStudySessions PS ON PS.PublicStudySessionID = P.PublicStudySessionID
JOIN StudiesSessions SS ON SS.StudiesSessionID = PS.StudiesSessionID
JOIN Subjects S ON S.SubjectID = SS.SubjectID
WHERE 
    P.DuePostponedPayment IS NOT NULL AND P.FullPricePaymentID IS NULL;
GO


-- Widok prezentujący frekwencje na zajęciach
CREATE OR ALTER VIEW AttendanceListForEachSession AS
WITH SessionsAttendance AS
(SELECT 
  'Studies Session' as 'SessionType',
  S.UserID,
  SS.StudiesSessionID as 'SessionID',
  SS.StartDate,
  SS.EndDate,
  SA.Completed
FROM StudiesSessions SS 
JOIN StudiesSessionsAttendence SA ON SA.SessionID = SS.StudiesSessionID
JOIN Students S ON S.StudentID = SA.StudentID
JOIN Subjects SUB ON SUB.SubjectID = SS.SubjectID
WHERE SS.EndDate < GETDATE()
UNION
SELECT 
  'Public Study Session',
  PSP.UserID,
  PSP.PublicStudySessionID,
  SS.StartDate,
  SS.EndDate,
  PA.Completed
FROM PublicStudySessions PS 
JOIN StudiesSessions SS ON SS.StudiesSessionID = PS.StudiesSessionID
JOIN PublicStudySessionsAttendanceForOutsiders PA
  ON PA.PublicStudySessionID=PS.PublicStudySessionID
JOIN PublicStudySessionParticipants PSP 
  ON PSP.PublicStudySessionParticipantID = PA.PublicStudySessionParticipantID
UNION
SELECT 
  'Course Offline Session', 
  CP.UserID,
  CS.CourseOfflineSessionID,
  CS.UploadedAt,
  NULL,
  CA.Completed
FROM CourseOfflineSessions CS
JOIN CourseSessionsAttendance CA ON CA.CourseSessionID = CS.CourseOfflineSessionID
JOIN CourseParticipants CP ON CP.CourseParticipantID = CA.CourseParticipantID
UNION
SELECT
  'Course Online Session',
  CP.UserID,
  CS.CourseOnlineSessionID,
  CS.StartDate,
  CS.EndDate,
  CA.Completed
FROM CourseOnlineSessions CS
JOIN CourseSessionsAttendance CA ON CA.CourseSessionID = CS.CourseOnlineSessionID
JOIN CourseParticipants CP ON CP.CourseParticipantID = CA.CourseParticipantID
UNION
SELECT 
  'Course Stationary Session', 
  CP.UserID,
  CS.CourseStationarySessionID,
  CS.StartDate,
  CS.EndDate,
  CA.Completed
FROM CourseStationarySessions CS
JOIN CourseSessionsAttendance CA ON CA.CourseSessionID = CS.CourseStationarySessionID
JOIN CourseParticipants CP ON CP.CourseParticipantID = CA.CourseParticipantID
UNION
SELECT
  'Webinar', 
  WP.UserID,
  W.WebinarID,
  W.StartDate,
  W.EndDate,
  WA.WasPresent
FROM Webinars W
JOIN WebinarsAttendence WA ON WA.WebinarID = W.WebinarID
JOIN WebinarParticipants WP ON WP.WebinarParticipantID = WA.WebinarParticipantID)
SELECT 
  P.FirstName,
  P.LastName,
  SA.UserID,
  SA.SessionType,
  SA.SessionID,
  SA.StartDate,
  SA.EndDate,
  SA.Completed
FROM SessionsAttendance SA
JOIN People P ON SA.UserID = P.PersonID;
GO


-- Widok prezentujący ogólne statystyki frekwencji na zajęciach
CREATE OR ALTER VIEW GeneralAttendance AS
WITH StudiesSessionsInfo AS (
  SELECT 
    SS.StudiesSessionID, 
    CASE
      WHEN PS.StudiesSessionID IS NULL THEN 'Study Session'
      ELSE 'Study Session & Public'
    END as 'type',
    S.SubjectName + ' ' + CAST(SS.StudiesSessionID as VARCHAR(10)) as SessionName,

    (
      SELECT COUNT(SU.StudentID)
      FROM Subjects SUB
      JOIN Studies ST ON  SUB.StudiesID = ST.StudiesID
      JOIN Students SU ON SU.StudiesID = ST.StudiesID
      WHERE SUB.SubjectID = S.SubjectID
    ) + (
      SELECT COUNT(*)
      FROM PublicStudySessionParticipants PS2
      WHERE PS2.PublicStudySessionID = PS.PublicStudySessionID
    ) as 'PeopleEnlisted', 
    (
      SELECT COUNT(*)
      FROM StudiesSessionsAttendence SA
      WHERE SA.SessionID = SS.StudiesSessionID AND Completed=1
    ) + (
      SELECT COUNT(*)
      FROM PublicStudySessionsAttendanceForOutsiders PSA
      WHERE PSA.PublicStudySessionID = PS.PublicStudySessionID AND Completed=1
    ) as 'NumberOfPeoplePresent'
  FROM StudiesSessions SS 
  LEFT JOIN PublicStudySessions PS ON PS.StudiesSessionID = SS.StudiesSessionID
  JOIN Subjects S ON S.SubjectID = SS.SubjectID
  WHERE SS.EndDate < GETDATE()
)
SELECT 'Webinar' as Type, Web.WebinarName as SessionName, COUNT(*) as PeopleEnlisted, SUM(CAST(W.WasPresent as INT)) as NumOfPeoplePresent, ROUND(100*SUM(CAST(W.WasPresent as float))/COUNT(*), 2) as Percentage
FROM WebinarsAttendence As W
INNER JOIN Webinars as Web on Web.WebinarID = W.WebinarID
WHERE Web.EndDate < GETDATE()
GROUP BY W.WebinarID, Web.WebinarName
UNION
SELECT 'Course Session' as Type, M.ModuleName as SessionName, COUNT(*) as PeopleEnlisted, SUM(CAST(C.Completed as INT)) as NumOfPeoplePresent, ROUND(100*SUM(CAST(C.Completed as float))/COUNT(*), 2) as Percentage
FROM CourseSessionsAttendance As C
INNER JOIN CoursesSessions as CS on CS.CourseSessionID = C.CourseSessionID
INNER JOIN Modules as M on CS.ModuleID = M.ModuleID
GROUP BY C.CourseSessionID, M.ModuleName
UNION
SELECT I.type,I.SessionName,I.PeopleEnlisted,I.NumberOfPeoplePresent,
  CASE 
  WHEN I.PeopleEnlisted > 0 THEN
    ROUND(100*(CAST(I.NumberOfPeoplePresent AS FLOAT))/ CAST(I.PeopleEnlisted AS FLOAT), 2)
  ELSE 
    0
  END
FROM StudiesSessionsInfo I;
GO

-- Widok prezentujący liste osób zapisanych na przyszłe wydarzenia
CREATE OR ALTER VIEW NumberOfPeopleRegisteredForEvents AS
SELECT CSS.StartDate as'StartDate',
     CSS.EndDate, 
       'Stationary' as 'StationaryOrOnline',
       'course session' as 'Type',
       P.FirstName + ' ' + P.LastName as 'Lecturer', 
       COUNT(CP.CourseParticipantID) as 'PeopleRegistered'
FROM CourseStationarySessions CSS 
JOIN CoursesSessions CS ON CS.CourseSessionID=CSS.CourseStationarySessionID
JOIN Employees E ON E.EmployeeID = CS.LecturerID
JOIN People P ON P.PersonID = E.EmployeeID
JOIN Modules M ON M.ModuleID = CS.ModuleID
JOIN Courses C ON C.CourseID = M.CourseID
JOIN CourseParticipants CP ON CP.CourseID = C.CourseID
WHERE CSS.StartDate > GETDATE()
GROUP BY CSS.StartDate,CSS.EndDate,  P.FirstName + ' ' + P.LastName
UNION 
SELECT COS.StartDate,
     COS.EndDate,
       'Online',
       'course session',
       P.FirstName + ' ' + P.LastName, 
       COUNT(CP.CourseParticipantID)
FROM CourseOnlineSessions COS 
JOIN CoursesSessions CS ON CS.CourseSessionID=COS.CourseOnlineSessionID
JOIN Employees E ON E.EmployeeID = CS.LecturerID
JOIN People P ON P.PersonID = E.EmployeeID
JOIN Modules M ON M.ModuleID = CS.ModuleID
JOIN Courses C ON C.CourseID = M.CourseID
JOIN CourseParticipants CP ON CP.CourseID = C.CourseID
WHERE COS.StartDate > GETDATE()
GROUP BY COS.CourseOnlineSessionID, COS.StartDate,COS.EndDate, P.FirstName + ' ' + P.LastName
UNION
SELECT W.StartDate,
     W.EndDate, 
        'Online',
        'webinar',
        P.FirstName + ' ' + P.LastName,
        COUNT(WP.WebinarParticipantID)
FROM Webinars W
JOIN WebinarParticipants WP ON WP.WebinarID = W.WebinarID
JOIN Employees E ON E.EmployeeID = W.LecturerID
JOIN People P ON P.PersonID = E.EmployeeID
WHERE W.EndDate > GETDATE()
GROUP BY W.WebinarID, W.StartDate, W.EndDate, P.FirstName + ' ' + P.LastName
UNION
SELECT SS.StartDate, SS.EndDate,  
    CASE
        WHEN OSS.OnlineStudiesSessionID  IS NULL THEN 'Stationary'
        ELSE 'Online'
    END,
    'studies sessions',
    P.FirstName + ' ' + P.LastName
    'studies session',
    COUNT(Students.StudentID) + COUNT(SSS.StationaryStudiesSessionID)
FROM StudiesSessions SS
LEFT JOIN PublicStudySessions PSS ON PSS.StudiesSessionID = SS.StudiesSessionID
LEFT JOIN PublicStudySessionParticipants PSSP ON PSSP.PublicStudySessionID = PSS.PublicStudySessionID
LEFT JOIN OnlineStudiesSessions OSS ON OSS.OnlineStudiesSessionID = SS.StudiesSessionID
LEFT JOIN StationaryStudiesSessions SSS ON SSS.StationaryStudiesSessionID = SS.StudiesSessionID
JOIN Employees E ON E.EmployeeID = SS.LecturerID
JOIN People P ON E.EmployeeID = P.PersonID
JOIN Subjects S ON S.SubjectID = SS.SubjectID
JOIN Studies ON Studies.StudiesID = S.StudiesID
JOIN Students ON Students.StudiesID = Studies.StudiesID 
WHERE SS.EndDate > GETDATE()
GROUP BY SS.StudiesSessionID, SS.StartDate,SS.EndDate, SS.StudiesSessionID, OSS.OnlineStudiesSessionID, P.FirstName + ' ' + P.LastName;
GO
