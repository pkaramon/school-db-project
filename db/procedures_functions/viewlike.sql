-- Funkcja zwracająca harmonogram pracownika w określonym przedziale czasowym
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