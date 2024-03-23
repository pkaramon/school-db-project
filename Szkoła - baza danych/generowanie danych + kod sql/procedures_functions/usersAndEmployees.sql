-- Procedura do tworzenia nowej osoby w bazie danych.
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
