-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2024-01-20 23:14:45.46

-- tables
-- Table: CartHistory
CREATE TABLE CartHistory (
    CartHistoryID int  NOT NULL IDENTITY,
    UserID int  NOT NULL,
    ProductID int  NOT NULL,
    AddedAt datetime  NOT NULL,
    RemovedAt datetime  NOT NULL,
    CONSTRAINT CartHistory_AddedAt CHECK (AddedAt <= GetDate()),
    CONSTRAINT CartHIstory_RemovedAt CHECK (RemovedAt >= AddedAt AND RemovedAt <= GetDate()),
    CONSTRAINT CartHistory_pk PRIMARY KEY  (CartHistoryID)
);

-- Table: Carts
CREATE TABLE Carts (
    UserID int  NOT NULL,
    ProductID int  NOT NULL,
    AddedAt datetime  NOT NULL DEFAULT GEtDATE(),
    CONSTRAINT Carts_AddedAtIsValid CHECK (AddedAt <= GetDate()),
    CONSTRAINT Carts_pk PRIMARY KEY  (UserID,ProductID)
);

-- Table: CourseOfflineSessions
CREATE TABLE CourseOfflineSessions (
    CourseOfflineSessionID int  NOT NULL,
    Link nvarchar(max)  NOT NULL,
    Description nvarchar(max)  NOT NULL,
    UploadedAt datetime  NOT NULL DEFAULT GETDATE(),
    CONSTRAINT CourseOfflineSessions_UploadedAtIsValid CHECK (UploadedAt <= GETDATE() ),
    CONSTRAINT CourseOfflineSessions_pk PRIMARY KEY  (CourseOfflineSessionID)
);

-- Table: CourseOnlineSessions
CREATE TABLE CourseOnlineSessions (
    CourseOnlineSessionID int  NOT NULL,
    StartDate datetime  NOT NULL,
    EndDate datetime  NOT NULL,
    WebinarLink nvarchar(max)  NOT NULL,
    RecordingLink nvarchar(max)  NULL,
    CONSTRAINT CourseOnlineSessions_DateIntervalCheck CHECK (StartDate < EndDate),
    CONSTRAINT CourseOnlineSessions_pk PRIMARY KEY  (CourseOnlineSessionID)
);

-- Table: CourseParticipants
CREATE TABLE CourseParticipants (
    CourseParticipantID int  NOT NULL IDENTITY,
    UserID int  NOT NULL,
    CourseID int  NOT NULL,
    CoursePrice money  NOT NULL,
    EntryFee money  NOT NULL,
    EntryFeePaymentID int  NULL,
    RemainingPaymentID int  NULL,
    FullPricePaymentID int  NULL,
    DuePostponedPayment datetime  NULL,
    AddedAt datetime  NOT NULL DEFAULT GETDATE(),
    Completed bit  NOT NULL,
    CONSTRAINT CourseParticipants_PriceCheck CHECK (CoursePrice >= 0),
    CONSTRAINT CourseParticpants_EntryFeeCheck CHECK (EntryFee >= 0 and EntryFee <= CoursePrice),
    CONSTRAINT CourseParticipants_pk PRIMARY KEY  (CourseParticipantID)
);

-- Table: CourseSessionsAttendance
CREATE TABLE CourseSessionsAttendance (
    CourseParticipantID int  NOT NULL,
    CourseSessionID int  NOT NULL,
    Completed bit  NOT NULL,
    CONSTRAINT CourseSessionsAttendance_pk PRIMARY KEY  (CourseSessionID,CourseParticipantID)
);

-- Table: CourseStationarySessions
CREATE TABLE CourseStationarySessions (
    CourseStationarySessionID int  NOT NULL,
    StartDate datetime  NOT NULL,
    EndDate datetime  NOT NULL,
    Address nvarchar(500)  NOT NULL,
    City nvarchar(500)  NOT NULL,
    Country nvarchar(500)  NOT NULL,
    PostalCode nvarchar(20)  NOT NULL,
    ClassroomNumber nvarchar(30)  NOT NULL,
    MaxStudents int  NOT NULL,
    CONSTRAINT CourseStationarySessions_DateIntervalIsValid CHECK (StartDate < EndDate),
    CONSTRAINT CourseStationarySessions_PostalCodeIsValid CHECK (PostalCode LIKE '[0-9][0-9]-[0-9][0-9][0-9]' OR PostalCode LIKE '[0-9][0-9][0-9][0-9][0-9]' OR PostalCode LIKE '[0-9][0-9][0-9][0-9][0-9][0-9]'),
    CONSTRAINT CourseStationarySessions_MaxStudentsIValid CHECK (MaxStudents > 0),
    CONSTRAINT CourseStationarySessions_pk PRIMARY KEY  (CourseStationarySessionID)
);

-- Table: Courses
CREATE TABLE Courses (
    CourseID int  NOT NULL,
    CourseName nvarchar(max)  NOT NULL,
    Description nvarchar(max)  NOT NULL,
    StartDate datetime  NOT NULL,
    EndDate datetime  NOT NULL,
    CoordinatorID int  NOT NULL,
    MaxStudents int  NULL,
    LanguageID int  NOT NULL,
    CONSTRAINT Course_MaxStudents CHECK (MaxStudents is NULL OR (MaxStudents > 0) ),
    CONSTRAINT Course_DateIntervalIsValid CHECK (StartDate < EndDate),
    CONSTRAINT Courses_pk PRIMARY KEY  (CourseID)
);

-- Table: CoursesSessions
CREATE TABLE CoursesSessions (
    CourseSessionID int  NOT NULL IDENTITY,
    LanguageID int  NOT NULL,
    ModuleID int  NOT NULL,
    LecturerID int  NOT NULL,
    TranslatorID int  NULL,
    CONSTRAINT CoursesSessions_pk PRIMARY KEY  (CourseSessionID)
);

-- Table: DaysInInternship
CREATE TABLE DaysInInternship (
    DaysInInternshipID int  NOT NULL IDENTITY,
    StartDate datetime  NOT NULL,
    EndDate datetime  NULL,
    NumberOfDays int  NOT NULL,
    InternshipID int  NULL,
    CONSTRAINT DaysInInternship_DateIntervalIsValid CHECK (StartDate < EndDate),
    CONSTRAINT DaysInInternship_NumberOfDaysIsValid CHECK (NumberOfDays > 0),
    CONSTRAINT DaysInInternship_pk PRIMARY KEY  (DaysInInternshipID)
);

-- Table: DiplomasSent
CREATE TABLE DiplomasSent (
    DiplomaSentID int  NOT NULL IDENTITY,
    UserID int  NOT NULL,
    SentAt datetime  NOT NULL DEFAULT GETDATE(),
    ProductID int  NOT NULL,
    DiplomaFile nvarchar(max)  NULL,
    CONSTRAINT DiplomasSent_pk PRIMARY KEY  (DiplomaSentID)
);

-- Table: EmployeeRoles
CREATE TABLE EmployeeRoles (
    EmployeeRoleEntryID int  NOT NULL IDENTITY,
    EmployeeID int  NOT NULL,
    RoleID int  NOT NULL,
    CONSTRAINT EmployeeRoles_ak_1 UNIQUE (EmployeeRoleEntryID, RoleID),
    CONSTRAINT EmployeeRoles_pk PRIMARY KEY  (EmployeeRoleEntryID)
);

-- Table: Employees
CREATE TABLE Employees (
    EmployeeID int  NOT NULL,
    HireDate date  NOT NULL,
    IsActive bit  NOT NULL,
    CONSTRAINT id PRIMARY KEY  (EmployeeID)
);

-- Table: Exams
CREATE TABLE Exams (
    ExamID int  NOT NULL IDENTITY,
    SubjectID int  NOT NULL,
    StartDate datetime  NOT NULL,
    EndDate datetime  NOT NULL,
    Country nvarchar(500)  NOT NULL,
    City nvarchar(500)  NOT NULL,
    PostalCode nvarchar(500)  NOT NULL,
    Address nvarchar(500)  NOT NULL,
    CONSTRAINT Exams_DateInteralIsValid CHECK (StartDate < EndDate),
    CONSTRAINT Exams_PostalCodeIsValid CHECK (PostalCode LIKE '[0-9][0-9]-[0-9][0-9][0-9]' OR PostalCode LIKE '[0-9][0-9][0-9][0-9][0-9]' OR PostalCode LIKE '[0-9][0-9][0-9][0-9][0-9][0-9]'),
    CONSTRAINT Exams_pk PRIMARY KEY  (ExamID)
);

-- Table: ExamsGrades
CREATE TABLE ExamsGrades (
    StudentID int  NOT NULL,
    ExamID int  NOT NULL,
    FinalGrade decimal(2,1)  NOT NULL,
    CONSTRAINT FinalExams_FinalGradeIsValid CHECK (FinalGrade IN (2.0, 3.0, 3.5, 4.0, 4.5, 5.0)),
    CONSTRAINT ExamsGrades_pk PRIMARY KEY  (StudentID,ExamID)
);

-- Table: FieldsOfStudies
CREATE TABLE FieldsOfStudies (
    FieldOfStudiesID int  NOT NULL IDENTITY,
    Name nvarchar(max)  NOT NULL,
    Description nvarchar(max)  NOT NULL,
    CONSTRAINT FieldsOfStudies_pk PRIMARY KEY  (FieldOfStudiesID)
);

-- Table: InternshipDetails
CREATE TABLE InternshipDetails (
    StudentID int  NOT NULL,
    IntershipID int  NOT NULL,
    CompletedAt date  NULL,
    Completed bit  NOT NULL,
    CompanyName nvarchar(500)  NOT NULL,
    City nvarchar(500)  NOT NULL,
    Country nvarchar(500)  NOT NULL,
    PostalCode nvarchar(500)  NOT NULL,
    Address nvarchar(500)  NOT NULL,
    CONSTRAINT InternshipDetails_CompletedAtIsValid CHECK (CompletedAt <= GetDate()),
    CONSTRAINT InternshipDetails_PostalCodeIsValid CHECK (PostalCode LIKE '[0-9][0-9]-[0-9][0-9][0-9]' OR PostalCode LIKE '[0-9][0-9][0-9][0-9][0-9]' OR PostalCode LIKE '[0-9][0-9][0-9][0-9][0-9][0-9]'),
    CONSTRAINT InternshipDetails_pk PRIMARY KEY  (IntershipID,StudentID)
);

-- Table: Internships
CREATE TABLE Internships (
    InternshipID int  NOT NULL IDENTITY,
    StudiesID int  NOT NULL,
    Description nvarchar(max)  NOT NULL,
    StartDate date  NOT NULL,
    EndDate date  NOT NULL,
    CONSTRAINT Internships_DateIntervalIsValid CHECK (StartDate < EndDate),
    CONSTRAINT Internships_pk PRIMARY KEY  (InternshipID)
);

-- Table: Languages
CREATE TABLE Languages (
    LanguageID int  NOT NULL IDENTITY,
    LanguageName nvarchar(200)  NOT NULL,
    CONSTRAINT LanguageName UNIQUE (LanguageName),
    CONSTRAINT Languages_pk PRIMARY KEY  (LanguageID)
);

-- Table: MadeUpAttendance
CREATE TABLE MadeUpAttendance (
    MadeUpAttendanceID int  NOT NULL IDENTITY,
    SubjectID int  NOT NULL,
    ProductID int  NOT NULL,
    StudentID int  NOT NULL,
    CONSTRAINT MadeUpAttendance_ak_1 UNIQUE (SubjectID, ProductID, StudentID),
    CONSTRAINT MadeUpAttendance_pk PRIMARY KEY  (MadeUpAttendanceID)
);

-- Table: MaxDaysForPaymentBeforeCourseStart
CREATE TABLE MaxDaysForPaymentBeforeCourseStart (
    MaxDaysForPaymentBeforeCourseStartID int  NOT NULL IDENTITY,
    StartDate datetime  NOT NULL,
    EndDate datetime  NULL,
    NumberOfDays int  NOT NULL,
    CourseID int  NULL,
    CONSTRAINT MaxDaysForPaymentBeforeCourseStart_DateIntervalIsValid CHECK (StartDate < EndDate),
    CONSTRAINT MaxDaysForPaymentBeforeCourseStart_NumberOfDaysIValid CHECK (NumberOfDays > 0),
    CONSTRAINT MaxDaysForPaymentBeforeCourseStart_pk PRIMARY KEY  (MaxDaysForPaymentBeforeCourseStartID)
);

-- Table: MaxDaysForPaymentBeforeStudiesStart
CREATE TABLE MaxDaysForPaymentBeforeStudiesStart (
    MaxDaysForPaymentBeforeStudiesStartID int  NOT NULL IDENTITY,
    StartDate datetime  NOT NULL,
    EndDate datetime  NULL,
    NumberOfDays int  NOT NULL,
    StudiesID int  NOT NULL,
    CONSTRAINT MaxDaysForPaymentBeforeStudiesStart_DateIntervalIsValid CHECK (EndDate > StartDate),
    CONSTRAINT MaxDaysForPaymentBeforeStudiesStart_NumberOfDaysIsValid CHECK (NumberOfDays > 0),
    CONSTRAINT MaxDaysForPaymentBeforeStudiesStart_pk PRIMARY KEY  (MaxDaysForPaymentBeforeStudiesStartID)
);

-- Table: MinAttendancePercentageToPassCourse
CREATE TABLE MinAttendancePercentageToPassCourse (
    MinAttendancePercentageToPassCourseID int  NOT NULL IDENTITY,
    StartDate datetime  NOT NULL,
    EndDate datetime  NULL,
    AttendancePercentage decimal(6,4)  NOT NULL,
    CourseID int  NULL,
    CONSTRAINT MinAttendancePercentageToPassCourse_DateIntervalIsValid CHECK ((StartDate < EndDate)),
    CONSTRAINT MinAttendancePercentageToPassCourse_AttendencePercentageIsValid CHECK ((AttendancePercentage >= 0) and (AttendancePercentage <= 1)),
    CONSTRAINT MinAttendancePercentageToPassCourse_pk PRIMARY KEY  (MinAttendancePercentageToPassCourseID)
);

-- Table: MinAttendancePercentageToPassInternship
CREATE TABLE MinAttendancePercentageToPassInternship (
    MinAttendancePercentageToPassInternshipID int  NOT NULL IDENTITY,
    StartDate datetime  NOT NULL,
    EndDate datetime  NULL,
    AttendancePercentage decimal(6,4)  NOT NULL,
    InternshipID int  NULL,
    CONSTRAINT MinAttendancePercentageToPassInternship_DateIntervalIsValid CHECK (StartDate < EndDate),
    CONSTRAINT MinAttendancePercentageToPassInternship_PercentageIsValid CHECK (AttendancePercentage BETWEEN 0 AND 1.0),
    CONSTRAINT MinAttendancePercentageToPassInternship_pk PRIMARY KEY  (MinAttendancePercentageToPassInternshipID)
);

-- Table: MinAttendancePercentageToPassStudies
CREATE TABLE MinAttendancePercentageToPassStudies (
    MinAttendancePercentageToPassStudiesID int  NOT NULL IDENTITY,
    StartDate datetime  NOT NULL,
    EndDate datetime  NULL,
    AttendancePercentage decimal(6,4)  NOT NULL,
    StudiesID int  NULL,
    CONSTRAINT MinAttendancePercentageToPassStudies_DateIntervalIsValid CHECK (StartDate < EndDate),
    CONSTRAINT MinAttendancePercentageToPassStudies_PercentageIsValid CHECK (AttendancePercentage BETWEEN 0 AND 1),
    CONSTRAINT MinAttendancePercentageToPassStudies_pk PRIMARY KEY  (MinAttendancePercentageToPassStudiesID)
);

-- Table: Modules
CREATE TABLE Modules (
    ModuleID int  NOT NULL IDENTITY,
    CourseID int  NOT NULL,
    ModuleName nvarchar(max)  NOT NULL,
    ModuleDescription nvarchar(max)  NOT NULL,
    CONSTRAINT Modules_pk PRIMARY KEY  (ModuleID)
);

-- Table: OnlineStudiesSessions
CREATE TABLE OnlineStudiesSessions (
    OnlineStudiesSessionID int  NOT NULL,
    WebinarLink nvarchar(max)  NOT NULL,
    RecordingLink nvarchar(max)  NULL,
    CONSTRAINT OnlineStudiesSessions_pk PRIMARY KEY  (OnlineStudiesSessionID)
);

-- Table: Payments
CREATE TABLE Payments (
    PaymentID int  NOT NULL IDENTITY,
    UserID int  NOT NULL,
    ProductID int  NOT NULL,
    Price money  NOT NULL,
    Date datetime  NOT NULL,
    Status nvarchar(300)  NOT NULL,
    CONSTRAINT Payments_Price CHECK (Price >= 0),
    CONSTRAINT Payments_Status CHECK (Status in ('Successful', 'Failed')),
    CONSTRAINT Payments_Date CHECK (Date <= GetDate()),
    CONSTRAINT Payments_pk PRIMARY KEY  (PaymentID)
);

-- Table: People
CREATE TABLE People (
    PersonID int  NOT NULL IDENTITY,
    FirstName nvarchar(max)  NOT NULL,
    LastName nvarchar(500)  NOT NULL,
    BirthDate date  NOT NULL,
    Address nvarchar(500)  NOT NULL,
    City nvarchar(500)  NOT NULL,
    Region nvarchar(500)  NOT NULL,
    PostalCode nvarchar(20)  NOT NULL,
    Country nvarchar(500)  NOT NULL,
    Phone nvarchar(20)  NOT NULL,
    Email nvarchar(500)  NOT NULL,
    CONSTRAINT People_EmailValid CHECK (Email LIKE '%@%'),
    CONSTRAINT People_BirthDateValid CHECK (BirthDate <= GetDate()),
    CONSTRAINT People_PhoneIsValid CHECK ((ISNUMERIC([Phone])=(1))),
    CONSTRAINT People_PostalCodeIsValid CHECK (PostalCode LIKE '[0-9][0-9]-[0-9][0-9][0-9]' OR PostalCode LIKE '[0-9][0-9][0-9][0-9][0-9]' OR PostalCode LIKE '[0-9][0-9][0-9][0-9][0-9][0-9]'),
    CONSTRAINT Person_pk PRIMARY KEY  (PersonID)
);

if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'People', null,null))
BEGIN
    EXEC sp_dropextendedproperty
        @name = N'MS_Description',
        @level0type = N'SCHEMA',
    	@level0name = 'dbo',
    	@level1type = N'TABLE',
        @level1name = 'People';
END; 

EXEC sp_addextendedproperty
    @name  = N'MS_Description',
    @value = N'Dane osobowe użytkowników oraz pracowników.',
    @level0type = N'SCHEMA',
    @level0name = 'dbo',
    @level1type = N'TABLE',
    @level1name = 'People';
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'TABLE', 'People', 'COLUMN','FirstName'))
BEGIN
     EXEC sp_dropextendedproperty
          @name = N'MS_Description',
          @level0type = N'SCHEMA',
          @level0name = 'dbo',
          @level1type = N'TABLE',
          @level1name = 'People',
          @level2type = N'COLUMN',
          @level2name = 'FirstName';
END; 


EXEC sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Komentarz do firstname
',
     @level0type = N'SCHEMA',
     @level0name = 'dbo',
     @level1type = N'TABLE',
     @level1name = 'People',
     @level2type = N'COLUMN',
     @level2name = 'FirstName';

-- Table: PeopleDataChangeHistory
CREATE TABLE PeopleDataChangeHistory (
    PersonDataChangeHistoryID int  NOT NULL IDENTITY,
    PersonID int  NOT NULL,
    ChangedAt datetime  NOT NULL,
    New_FirstName nvarchar(max)  NOT NULL,
    Old_FirstName nvarchar(max)  NOT NULL,
    New_LastName nvarchar(500)  NOT NULL,
    Old_LastName nvarchar(500)  NOT NULL,
    New_BirthDate date  NOT NULL,
    Old_BirthDate date  NOT NULL,
    New_Address nvarchar(500)  NOT NULL,
    Old_Address nvarchar(500)  NOT NULL,
    New_City nvarchar(500)  NOT NULL,
    Old_City nvarchar(500)  NOT NULL,
    New_Region nvarchar(500)  NOT NULL,
    Old_Region nvarchar(500)  NOT NULL,
    New_PostalCode nvarchar(20)  NOT NULL,
    Old_PostalCode nvarchar(500)  NOT NULL,
    New_Country nvarchar(500)  NOT NULL,
    Old_Country nvarchar(500)  NOT NULL,
    New_Email nvarchar(500)  NOT NULL,
    Old_Email nvarchar(500)  NOT NULL,
    New_Phone nvarchar(20)  NOT NULL,
    Old_Phone nvarchar(500)  NOT NULL,
    CONSTRAINT PeopleDataChangeHistory_ChangedAtIsValid CHECK (ChangedAt <= GetDate()),
    CONSTRAINT PeopleDataChangeHistory_NewPostalCodeIsValid CHECK (New_PostalCode LIKE '[0-9][0-9]-[0-9][0-9][0-9]' OR New_PostalCode LIKE '[0-9][0-9][0-9][0-9][0-9]' OR New_PostalCode LIKE '[0-9][0-9][0-9][0-9][0-9][0-9]'),
    CONSTRAINT PeopleDataChangeHistory_New_EmailValid CHECK (New_Email LIKE '%@%'),
    CONSTRAINT PeopleDataChangeHistory_New_BirthDate CHECK (New_BirthDate <= GetDate()),
    CONSTRAINT PeopleDataChangeHistory_New_Phone CHECK (ISNUMERIC(New_Phone)=(1)),
    CONSTRAINT PersonDataChangeHistory_pk PRIMARY KEY  (PersonDataChangeHistoryID)
);

-- Table: ProductPriceChangeHistory
CREATE TABLE ProductPriceChangeHistory (
    ProductPriceChangeHistoryID int  NOT NULL IDENTITY,
    ProductID int  NOT NULL,
    Old_Price money  NOT NULL,
    New_Price money  NULL,
    Old_AdvancePayment money  NULL,
    New_AdvancePayment money  NULL,
    ChangedAt datetime  NOT NULL DEFAULT GETDATE(),
    CONSTRAINT ProductHistory_ChangedAtIsValid CHECK (ChangedAt <= GetDate()),
    CONSTRAINT ProductHIstory_NewPriceIsValid CHECK (New_price >= 0),
    CONSTRAINT ProductHistory_NewAdvancePaymentIsValid CHECK (New_AdvancePayment > 0),
    CONSTRAINT ProductPriceChangeHistory_pk PRIMARY KEY  (ProductPriceChangeHistoryID)
);

-- Table: Products
CREATE TABLE Products (
    ProductID int  NOT NULL IDENTITY,
    Price money  NOT NULL,
    AdvancePayment money  NULL,
    ProductType nvarchar(max)  NOT NULL,
    AddedAt datetime  NOT NULL DEFAULT GETDATE(),
    ClosedAt datetime  NULL,
    CONSTRAINT Products_PriceIsValid CHECK (Price >= 0),
    CONSTRAINT Products_AdvancePaymentIsValid CHECK ((AdvancePayment > 0 AND AdvancePayment < Price) OR (AdvancePayment IS NULL)),
    CONSTRAINT Products_ProductTypeIsValid CHECK (ProductType IN ('studies', 'course','webinar', 'public study session')),
    CONSTRAINT Products_AddedAtIsValid CHECK (AddedAt <= GetDate()),
    CONSTRAINT Products_ClosedAtIsValid CHECK (ClosedAt <= GetDate() AND ClosedAt >= AddedAt),
    CONSTRAINT Products_pk PRIMARY KEY  (ProductID)
);

-- Table: PublicStudySessionParticipants
CREATE TABLE PublicStudySessionParticipants (
    PublicStudySessionParticipantID int  NOT NULL IDENTITY,
    UserID int  NOT NULL,
    PublicStudySessionID int  NOT NULL,
    SessionPrice money  NOT NULL,
    DuePostponedPayment datetime  NULL,
    FullPricePaymentID int  NULL,
    AddedAt datetime  NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PublicStudySessionParticipants_SessionPriceIsValid CHECK (SessionPrice > 0),
    CONSTRAINT PublicStudySessionParticipants_pk PRIMARY KEY  (PublicStudySessionParticipantID)
);

-- Table: PublicStudySessions
CREATE TABLE PublicStudySessions (
    PublicStudySessionID int  NOT NULL,
    StudiesSessionID int  NOT NULL,
    Description nvarchar(max)  NOT NULL,
    CONSTRAINT PublicStudySessions_ak_1 UNIQUE (StudiesSessionID),
    CONSTRAINT PublicStudySessions_pk PRIMARY KEY  (PublicStudySessionID)
);

-- Table: PublicStudySessionsAttendanceForOutsiders
CREATE TABLE PublicStudySessionsAttendanceForOutsiders (
    PublicStudySessionID int  NOT NULL,
    PublicStudySessionParticipantID int  NOT NULL,
    Completed bit  NOT NULL,
    CONSTRAINT PublicStudySessionsAttendanceForOutsiders_pk PRIMARY KEY  (PublicStudySessionID,PublicStudySessionParticipantID)
);

-- Table: RecordingAccessTime
CREATE TABLE RecordingAccessTime (
    RecordingAcessTimeID int  NOT NULL IDENTITY,
    StartDate datetime  NOT NULL,
    EndDate datetime  NULL,
    NumberOfDays int  NOT NULL,
    WebinarID int  NULL,
    CONSTRAINT RecordingAccessTime_DateIntervalIsValid CHECK (StartDate < EndDate),
    CONSTRAINT RecordingAccessTime_NumberOfDaysIsValid CHECK (NumberOfDays >= 0),
    CONSTRAINT RecordingAccessTime_pk PRIMARY KEY  (RecordingAcessTimeID)
);

-- Table: Roles
CREATE TABLE Roles (
    RoleID int  NOT NULL IDENTITY,
    RoleName nvarchar(200)  NOT NULL,
    CONSTRAINT RoleName UNIQUE (RoleName),
    CONSTRAINT employeeType PRIMARY KEY  (RoleID)
);

-- Table: StationaryStudiesSessions
CREATE TABLE StationaryStudiesSessions (
    StationaryStudiesSessionID int  NOT NULL,
    Address nvarchar(500)  NOT NULL,
    City nvarchar(500)  NOT NULL,
    Country nvarchar(500)  NOT NULL,
    PostalCode nvarchar(20)  NOT NULL,
    ClassroomNumber nvarchar(30)  NOT NULL,
    CONSTRAINT StationaryStudiesSessions_PostalCodeIsValid CHECK (PostalCode LIKE '[0-9][0-9]-[0-9][0-9][0-9]' OR PostalCode LIKE '[0-9][0-9][0-9][0-9][0-9]' OR PostalCode LIKE '[0-9][0-9][0-9][0-9][0-9][0-9]'),
    CONSTRAINT StationaryStudiesSessions_pk PRIMARY KEY  (StationaryStudiesSessionID)
);

-- Table: Students
CREATE TABLE Students (
    StudentID int  NOT NULL IDENTITY,
    UserID int  NOT NULL,
    StudiesID int  NOT NULL,
    StudiesPrice money  NOT NULL,
    EntryFee money  NOT NULL,
    DuePostponedPayment datetime  NULL,
    EntryFeePaymentID int  NULL,
    RemainingPaymentID int  NULL,
    FullPaymentID int  NULL,
    AddedAt datetime  NOT NULL DEFAULT GETDATE(),
    Completed bit  NOT NULL DEFAULT 0,
    CONSTRAINT Students_PriceIsValid CHECK (StudiesPrice > 0),
    CONSTRAINT Students_EntryFeeIsValid CHECK (EntryFee > 0 AND EntryFee < StudiesPrice),
    CONSTRAINT Students_pk PRIMARY KEY  (StudentID)
);

-- Table: Studies
CREATE TABLE Studies (
    StudiesID int  NOT NULL,
    Name nvarchar(max)  NOT NULL,
    Description nvarchar(max)  NOT NULL,
    CoordinatorID int  NOT NULL,
    StartDate Date  NOT NULL,
    EndDate Date  NOT NULL,
    MaxStudents int  NOT NULL,
    LanguageID int  NOT NULL,
    FieldOfStudiesID int  NOT NULL,
    SemesterNumber int  NOT NULL,
    CONSTRAINT Studies_DateIntervalIsValid CHECK (StartDate < EndDate),
    CONSTRAINT Studies_MaxStudentsIsValid CHECK (MaxStudents > 0),
    CONSTRAINT Studies_SemesterIsValid CHECK (SemesterNumber >= 1),
    CONSTRAINT Studies_pk PRIMARY KEY  (StudiesID)
);

-- Table: StudiesSessions
CREATE TABLE StudiesSessions (
    StudiesSessionID int  NOT NULL IDENTITY,
    SubjectID int  NOT NULL,
    StartDate datetime  NOT NULL,
    EndDate datetime  NOT NULL,
    LecturerID int  NOT NULL,
    MaxStudents int  NOT NULL,
    TranslatorID int  NULL,
    LanguageID int  NOT NULL,
    CONSTRAINT StudiesSessions_DateIntervalIsValid CHECK (StartDate < EndDate),
    CONSTRAINT MaxStudentsVerification CHECK (MaxStudents > 0),
    CONSTRAINT StudiesSessions_pk PRIMARY KEY  (StudiesSessionID)
);

-- Table: StudiesSessionsAttendence
CREATE TABLE StudiesSessionsAttendence (
    SessionID int  NOT NULL,
    StudentID int  NOT NULL,
    Completed bit  NOT NULL,
    CONSTRAINT StudiesSessionsAttendence_pk PRIMARY KEY  (SessionID,StudentID)
);

-- Table: SubjectMakeUpPossibilities
CREATE TABLE SubjectMakeUpPossibilities (
    SubjectID int  NOT NULL,
    ProductID int  NOT NULL,
    AttendanceValue int  NOT NULL,
    CONSTRAINT SubjectMakeUpPossibilities_AttendanceValue CHECK (AttendanceValue > 0),
    CONSTRAINT SubjectMakeUpPossibilities_pk PRIMARY KEY  (SubjectID,ProductID)
);

-- Table: Subjects
CREATE TABLE Subjects (
    SubjectID int  NOT NULL IDENTITY,
    StudiesID int  NOT NULL,
    Description nvarchar(max)  NOT NULL,
    CoordinatorID int  NOT NULL,
    SubjectName nvarchar(max)  NOT NULL,
    CONSTRAINT SubjectID PRIMARY KEY  (SubjectID)
);

-- Table: Users
CREATE TABLE Users (
    UserID int  NOT NULL,
    CONSTRAINT Users_pk PRIMARY KEY  (UserID)
);

-- Table: WebinarParticipants
CREATE TABLE WebinarParticipants (
    WebinarParticipantID int  NOT NULL IDENTITY,
    UserID int  NOT NULL,
    WebinarID int  NOT NULL,
    WebinarPrice money  NOT NULL,
    DuePostponedPayment datetime  NULL,
    FullPricePaymentID int  NULL,
    AddedAt datetime  NOT NULL DEFAULT GETDATE(),
    CONSTRAINT WebinarParticipants_WebinarPrice CHECK (WebinarPrice >= 0),
    CONSTRAINT WebinarParticipants_FulPricePaymentID CHECK (FullPricePaymentID IS NOT NULL OR  (DuePostponedPayment IS NOT NULL OR      WebinarPrice = 0)),
    CONSTRAINT WebinarParticipants_pk PRIMARY KEY  (WebinarParticipantID)
);

-- Table: Webinars
CREATE TABLE Webinars (
    WebinarID int  NOT NULL,
    WebinarName nvarchar(max)  NOT NULL,
    Description nvarchar(max)  NOT NULL,
    StartDate datetime  NOT NULL,
    EndDate datetime  NOT NULL,
    RecordingLink nvarchar(max)  NULL,
    WebinarLink nvarchar(max)  NOT NULL,
    LecturerID int  NOT NULL,
    TranslatorID int  NULL,
    LanguageID int  NOT NULL,
    RecordingReleaseDate date  NULL,
    CONSTRAINT Webinars_RecodingReleaseDateValid CHECK (RecordingReleaseDate >= EndDate),
    CONSTRAINT Webinars_RecodingLinkRelationWithRecordingReleaseDate CHECK ((RecordingReleaseDate IS NULL AND RecordingLink IS NULL) OR (RecordingReleaseDate IS NOT NULL AND RecordingLink IS NOT NULL)),
    CONSTRAINT Webinars_DateRangeIsValid CHECK (StartDate < EndDate),
    CONSTRAINT Webinars_pk PRIMARY KEY  (WebinarID)
);

-- Table: WebinarsAttendence
CREATE TABLE WebinarsAttendence (
    WebinarID int  NOT NULL,
    WebinarParticipantID int  NOT NULL,
    WasPresent bit  NOT NULL,
    CONSTRAINT WebinarsAttendence_pk PRIMARY KEY  (WebinarID,WebinarParticipantID)
);

-- foreign keys
-- Reference: AttendanceForOutsiders (table: PublicStudySessionsAttendanceForOutsiders)
ALTER TABLE PublicStudySessionsAttendanceForOutsiders ADD CONSTRAINT AttendanceForOutsiders
    FOREIGN KEY (PublicStudySessionParticipantID)
    REFERENCES PublicStudySessionParticipants (PublicStudySessionParticipantID);

-- Reference: CartHistory_Products (table: CartHistory)
ALTER TABLE CartHistory ADD CONSTRAINT CartHistory_Products
    FOREIGN KEY (ProductID)
    REFERENCES Products (ProductID);

-- Reference: CartHistory_Users (table: CartHistory)
ALTER TABLE CartHistory ADD CONSTRAINT CartHistory_Users
    FOREIGN KEY (UserID)
    REFERENCES Users (UserID);

-- Reference: Carts_Products (table: Carts)
ALTER TABLE Carts ADD CONSTRAINT Carts_Products
    FOREIGN KEY (ProductID)
    REFERENCES Products (ProductID);

-- Reference: Carts_Users (table: Carts)
ALTER TABLE Carts ADD CONSTRAINT Carts_Users
    FOREIGN KEY (UserID)
    REFERENCES Users (UserID);

-- Reference: CourseOfflineSessions_CoursesSessions (table: CourseOfflineSessions)
ALTER TABLE CourseOfflineSessions ADD CONSTRAINT CourseOfflineSessions_CoursesSessions
    FOREIGN KEY (CourseOfflineSessionID)
    REFERENCES CoursesSessions (CourseSessionID)
    ON DELETE  CASCADE;

-- Reference: CourseOnlineSessions_CoursesSessions (table: CourseOnlineSessions)
ALTER TABLE CourseOnlineSessions ADD CONSTRAINT CourseOnlineSessions_CoursesSessions
    FOREIGN KEY (CourseOnlineSessionID)
    REFERENCES CoursesSessions (CourseSessionID)
    ON DELETE  CASCADE;

-- Reference: CourseParticipants_Courses (table: CourseParticipants)
ALTER TABLE CourseParticipants ADD CONSTRAINT CourseParticipants_Courses
    FOREIGN KEY (CourseID)
    REFERENCES Courses (CourseID);

-- Reference: CourseParticipants_EntryFeePayments (table: CourseParticipants)
ALTER TABLE CourseParticipants ADD CONSTRAINT CourseParticipants_EntryFeePayments
    FOREIGN KEY (EntryFeePaymentID)
    REFERENCES Payments (PaymentID);

-- Reference: CourseParticipants_FullPricePayments (table: CourseParticipants)
ALTER TABLE CourseParticipants ADD CONSTRAINT CourseParticipants_FullPricePayments
    FOREIGN KEY (FullPricePaymentID)
    REFERENCES Payments (PaymentID);

-- Reference: CourseParticipants_RemainingPayments (table: CourseParticipants)
ALTER TABLE CourseParticipants ADD CONSTRAINT CourseParticipants_RemainingPayments
    FOREIGN KEY (RemainingPaymentID)
    REFERENCES Payments (PaymentID);

-- Reference: CourseParticipants_Users (table: CourseParticipants)
ALTER TABLE CourseParticipants ADD CONSTRAINT CourseParticipants_Users
    FOREIGN KEY (UserID)
    REFERENCES Users (UserID);

-- Reference: CourseSessionsAttendance_CourseParticipants (table: CourseSessionsAttendance)
ALTER TABLE CourseSessionsAttendance ADD CONSTRAINT CourseSessionsAttendance_CourseParticipants
    FOREIGN KEY (CourseParticipantID)
    REFERENCES CourseParticipants (CourseParticipantID)
    ON DELETE  CASCADE;

-- Reference: CourseSessionsAttendance_CoursesSessions (table: CourseSessionsAttendance)
ALTER TABLE CourseSessionsAttendance ADD CONSTRAINT CourseSessionsAttendance_CoursesSessions
    FOREIGN KEY (CourseSessionID)
    REFERENCES CoursesSessions (CourseSessionID)
    ON DELETE  CASCADE;

-- Reference: CourseStationarySessions_CoursesSessions (table: CourseStationarySessions)
ALTER TABLE CourseStationarySessions ADD CONSTRAINT CourseStationarySessions_CoursesSessions
    FOREIGN KEY (CourseStationarySessionID)
    REFERENCES CoursesSessions (CourseSessionID)
    ON DELETE  CASCADE;

-- Reference: CoursesSessions_Employees (table: CoursesSessions)
ALTER TABLE CoursesSessions ADD CONSTRAINT CoursesSessions_Employees
    FOREIGN KEY (LecturerID)
    REFERENCES Employees (EmployeeID);

-- Reference: CoursesSessions_Languages (table: CoursesSessions)
ALTER TABLE CoursesSessions ADD CONSTRAINT CoursesSessions_Languages
    FOREIGN KEY (LanguageID)
    REFERENCES Languages (LanguageID);

-- Reference: CoursesSessions_Modules (table: CoursesSessions)
ALTER TABLE CoursesSessions ADD CONSTRAINT CoursesSessions_Modules
    FOREIGN KEY (ModuleID)
    REFERENCES Modules (ModuleID)
    ON DELETE  CASCADE;

-- Reference: CoursesSessions_Translators (table: CoursesSessions)
ALTER TABLE CoursesSessions ADD CONSTRAINT CoursesSessions_Translators
    FOREIGN KEY (TranslatorID)
    REFERENCES Employees (EmployeeID);

-- Reference: Courses_Employees (table: Courses)
ALTER TABLE Courses ADD CONSTRAINT Courses_Employees
    FOREIGN KEY (CoordinatorID)
    REFERENCES Employees (EmployeeID);

-- Reference: Courses_Languages (table: Courses)
ALTER TABLE Courses ADD CONSTRAINT Courses_Languages
    FOREIGN KEY (LanguageID)
    REFERENCES Languages (LanguageID);

-- Reference: Courses_Products (table: Courses)
ALTER TABLE Courses ADD CONSTRAINT Courses_Products
    FOREIGN KEY (CourseID)
    REFERENCES Products (ProductID);

-- Reference: DaysOfPracticeLaws_Internships (table: DaysInInternship)
ALTER TABLE DaysInInternship ADD CONSTRAINT DaysOfPracticeLaws_Internships
    FOREIGN KEY (InternshipID)
    REFERENCES Internships (InternshipID);

-- Reference: DiplomasSent_Products (table: DiplomasSent)
ALTER TABLE DiplomasSent ADD CONSTRAINT DiplomasSent_Products
    FOREIGN KEY (ProductID)
    REFERENCES Products (ProductID);

-- Reference: DiplomasSent_Users (table: DiplomasSent)
ALTER TABLE DiplomasSent ADD CONSTRAINT DiplomasSent_Users
    FOREIGN KEY (UsersID)
    REFERENCES Users (UserID);

-- Reference: EmployeeCategories_Employees (table: EmployeeRoles)
ALTER TABLE EmployeeRoles ADD CONSTRAINT EmployeeCategories_Employees
    FOREIGN KEY (EmployeeID)
    REFERENCES Employees (EmployeeID)
    ON DELETE  CASCADE;

-- Reference: EmployeeRoles_Roles (table: EmployeeRoles)
ALTER TABLE EmployeeRoles ADD CONSTRAINT EmployeeRoles_Roles
    FOREIGN KEY (RoleID)
    REFERENCES Roles (RoleID)
    ON DELETE  CASCADE;

-- Reference: Employees_People (table: Employees)
ALTER TABLE Employees ADD CONSTRAINT Employees_People
    FOREIGN KEY (EmployeeID)
    REFERENCES People (PersonID);

-- Reference: ExamsGrades_Exams (table: ExamsGrades)
ALTER TABLE ExamsGrades ADD CONSTRAINT ExamsGrades_Exams
    FOREIGN KEY (ExamID)
    REFERENCES Exams (ExamID);

-- Reference: Exams_Subjects (table: Exams)
ALTER TABLE Exams ADD CONSTRAINT Exams_Subjects
    FOREIGN KEY (SubjectID)
    REFERENCES Subjects (SubjectID);

-- Reference: Grades_Students (table: ExamsGrades)
ALTER TABLE ExamsGrades ADD CONSTRAINT Grades_Students
    FOREIGN KEY (StudentID)
    REFERENCES Students (StudentID);

-- Reference: InternshipAttendence_Internships (table: InternshipDetails)
ALTER TABLE InternshipDetails ADD CONSTRAINT InternshipAttendence_Internships
    FOREIGN KEY (IntershipID)
    REFERENCES Internships (InternshipID);

-- Reference: InternshipDetails_Students (table: InternshipDetails)
ALTER TABLE InternshipDetails ADD CONSTRAINT InternshipDetails_Students
    FOREIGN KEY (StudentID)
    REFERENCES Students (StudentID);

-- Reference: Internships_Studies (table: Internships)
ALTER TABLE Internships ADD CONSTRAINT Internships_Studies
    FOREIGN KEY (StudiesID)
    REFERENCES Studies (StudiesID);

-- Reference: MadeUpAttendance_Students (table: MadeUpAttendance)
ALTER TABLE MadeUpAttendance ADD CONSTRAINT MadeUpAttendance_Students
    FOREIGN KEY (StudentID)
    REFERENCES Students (StudentID);

-- Reference: MadeUpAttendance_SubjectMakeUpPossibilities (table: MadeUpAttendance)
ALTER TABLE MadeUpAttendance ADD CONSTRAINT MadeUpAttendance_SubjectMakeUpPossibilities
    FOREIGN KEY (SubjectID,ProductID)
    REFERENCES SubjectMakeUpPossibilities (SubjectID,ProductID);

-- Reference: MaxDaysForPaymentBeforeCourseStart_Courses (table: MaxDaysForPaymentBeforeCourseStart)
ALTER TABLE MaxDaysForPaymentBeforeCourseStart ADD CONSTRAINT MaxDaysForPaymentBeforeCourseStart_Courses
    FOREIGN KEY (CourseID)
    REFERENCES Courses (CourseID);

-- Reference: MaxDaysForPaymentBeforeStudiesStart_Studies (table: MaxDaysForPaymentBeforeStudiesStart)
ALTER TABLE MaxDaysForPaymentBeforeStudiesStart ADD CONSTRAINT MaxDaysForPaymentBeforeStudiesStart_Studies
    FOREIGN KEY (StudiesID)
    REFERENCES Studies (StudiesID);

-- Reference: MinAttendancePercentageToPassCourse_Courses (table: MinAttendancePercentageToPassCourse)
ALTER TABLE MinAttendancePercentageToPassCourse ADD CONSTRAINT MinAttendancePercentageToPassCourse_Courses
    FOREIGN KEY (CourseID)
    REFERENCES Courses (CourseID);

-- Reference: MinAttendancePercentageToPassInternship_Internships (table: MinAttendancePercentageToPassInternship)
ALTER TABLE MinAttendancePercentageToPassInternship ADD CONSTRAINT MinAttendancePercentageToPassInternship_Internships
    FOREIGN KEY (InternshipID)
    REFERENCES Internships (InternshipID);

-- Reference: MinAttendancePercentageToPassStudies_Studies (table: MinAttendancePercentageToPassStudies)
ALTER TABLE MinAttendancePercentageToPassStudies ADD CONSTRAINT MinAttendancePercentageToPassStudies_Studies
    FOREIGN KEY (StudiesID)
    REFERENCES Studies (StudiesID);

-- Reference: Modules_Courses (table: Modules)
ALTER TABLE Modules ADD CONSTRAINT Modules_Courses
    FOREIGN KEY (CourseID)
    REFERENCES Courses (CourseID);

-- Reference: OnlineStudiesSessions_StudySessions (table: OnlineStudiesSessions)
ALTER TABLE OnlineStudiesSessions ADD CONSTRAINT OnlineStudiesSessions_StudySessions
    FOREIGN KEY (OnlineStudiesSessionID)
    REFERENCES StudiesSessions (StudiesSessionID)
    ON DELETE  CASCADE;

-- Reference: OrderHistory_Products (table: Payments)
ALTER TABLE Payments ADD CONSTRAINT OrderHistory_Products
    FOREIGN KEY (ProductID)
    REFERENCES Products (ProductID);

-- Reference: OrderHistory_Users (table: Payments)
ALTER TABLE Payments ADD CONSTRAINT OrderHistory_Users
    FOREIGN KEY (UserID)
    REFERENCES Users (UserID);

-- Reference: PeopleDataChangeHistory_People (table: PeopleDataChangeHistory)
ALTER TABLE PeopleDataChangeHistory ADD CONSTRAINT PeopleDataChangeHistory_People
    FOREIGN KEY (PersonID)
    REFERENCES People (PersonID);

-- Reference: ProductHistory_Products (table: ProductPriceChangeHistory)
ALTER TABLE ProductPriceChangeHistory ADD CONSTRAINT ProductHistory_Products
    FOREIGN KEY (ProductID)
    REFERENCES Products (ProductID)
    ON DELETE  CASCADE;

-- Reference: PublicStudySessionParticipants_Payments (table: PublicStudySessionParticipants)
ALTER TABLE PublicStudySessionParticipants ADD CONSTRAINT PublicStudySessionParticipants_Payments
    FOREIGN KEY (FullPricePaymentID)
    REFERENCES Payments (PaymentID);

-- Reference: PublicStudySessionParticipants_PublicStudySessions (table: PublicStudySessionParticipants)
ALTER TABLE PublicStudySessionParticipants ADD CONSTRAINT PublicStudySessionParticipants_PublicStudySessions
    FOREIGN KEY (PublicStudySessionID)
    REFERENCES PublicStudySessions (PublicStudySessionID);

-- Reference: PublicStudySessionsAttendanceForOutsiders_PublicStudySessions (table: PublicStudySessionsAttendanceForOutsiders)
ALTER TABLE PublicStudySessionsAttendanceForOutsiders ADD CONSTRAINT PublicStudySessionsAttendanceForOutsiders_PublicStudySessions
    FOREIGN KEY (PublicStudySessionID)
    REFERENCES PublicStudySessions (PublicStudySessionID);

-- Reference: PublicStudySessions_Products (table: PublicStudySessions)
ALTER TABLE PublicStudySessions ADD CONSTRAINT PublicStudySessions_Products
    FOREIGN KEY (PublicStudySessionID)
    REFERENCES Products (ProductID);

-- Reference: PublicStudySessions_StudiesSessions (table: PublicStudySessions)
ALTER TABLE PublicStudySessions ADD CONSTRAINT PublicStudySessions_StudiesSessions
    FOREIGN KEY (StudiesSessionID)
    REFERENCES StudiesSessions (StudiesSessionID)
    ON DELETE  CASCADE;

-- Reference: RecordingAccessTime_Webinars (table: RecordingAccessTime)
ALTER TABLE RecordingAccessTime ADD CONSTRAINT RecordingAccessTime_Webinars
    FOREIGN KEY (WebinarID)
    REFERENCES Webinars (WebinarID)
    ON DELETE  CASCADE;

-- Reference: StationaryStudiesSessions_StudySessions (table: StationaryStudiesSessions)
ALTER TABLE StationaryStudiesSessions ADD CONSTRAINT StationaryStudiesSessions_StudySessions
    FOREIGN KEY (StationaryStudiesSessionID)
    REFERENCES StudiesSessions (StudiesSessionID)
    ON DELETE  CASCADE;

-- Reference: Students_FullPayments (table: Students)
ALTER TABLE Students ADD CONSTRAINT Students_FullPayments
    FOREIGN KEY (RemainingPaymentID)
    REFERENCES Payments (PaymentID);

-- Reference: Students_Payments (table: Students)
ALTER TABLE Students ADD CONSTRAINT Students_Payments
    FOREIGN KEY (FullPaymentID)
    REFERENCES Payments (PaymentID);

-- Reference: Students_RemainingPayments (table: Students)
ALTER TABLE Students ADD CONSTRAINT Students_RemainingPayments
    FOREIGN KEY (EntryFeePaymentID)
    REFERENCES Payments (PaymentID);

-- Reference: Students_Studies (table: Students)
ALTER TABLE Students ADD CONSTRAINT Students_Studies
    FOREIGN KEY (StudiesID)
    REFERENCES Studies (StudiesID);

-- Reference: Students_Users (table: Students)
ALTER TABLE Students ADD CONSTRAINT Students_Users
    FOREIGN KEY (UserID)
    REFERENCES Users (UserID);

-- Reference: StudiesSessionsAttendence_Students (table: StudiesSessionsAttendence)
ALTER TABLE StudiesSessionsAttendence ADD CONSTRAINT StudiesSessionsAttendence_Students
    FOREIGN KEY (StudentID)
    REFERENCES Students (StudentID);

-- Reference: StudiesSessions_Employees (table: StudiesSessions)
ALTER TABLE StudiesSessions ADD CONSTRAINT StudiesSessions_Employees
    FOREIGN KEY (TranslatorID)
    REFERENCES Employees (EmployeeID);

-- Reference: StudiesSessions_Languages (table: StudiesSessions)
ALTER TABLE StudiesSessions ADD CONSTRAINT StudiesSessions_Languages
    FOREIGN KEY (LanguageID)
    REFERENCES Languages (LanguageID);

-- Reference: Studies_Employees (table: Studies)
ALTER TABLE Studies ADD CONSTRAINT Studies_Employees
    FOREIGN KEY (CoordinatorID)
    REFERENCES Employees (EmployeeID);

-- Reference: Studies_FieldsOfStudies (table: Studies)
ALTER TABLE Studies ADD CONSTRAINT Studies_FieldsOfStudies
    FOREIGN KEY (FieldOfStudiesID)
    REFERENCES FieldsOfStudies (FieldOfStudiesID);

-- Reference: Studies_Languages (table: Studies)
ALTER TABLE Studies ADD CONSTRAINT Studies_Languages
    FOREIGN KEY (LanguageID)
    REFERENCES Languages (LanguageID);

-- Reference: Studies_Products (table: Studies)
ALTER TABLE Studies ADD CONSTRAINT Studies_Products
    FOREIGN KEY (StudiesID)
    REFERENCES Products (ProductID);

-- Reference: Studies_Subjects (table: Subjects)
ALTER TABLE Subjects ADD CONSTRAINT Studies_Subjects
    FOREIGN KEY (StudiesID)
    REFERENCES Studies (StudiesID);

-- Reference: StudySessionsAttendence_StudySessions (table: StudiesSessionsAttendence)
ALTER TABLE StudiesSessionsAttendence ADD CONSTRAINT StudySessionsAttendence_StudySessions
    FOREIGN KEY (SessionID)
    REFERENCES StudiesSessions (StudiesSessionID)
    ON DELETE  CASCADE;

-- Reference: StudySessions_Employees (table: StudiesSessions)
ALTER TABLE StudiesSessions ADD CONSTRAINT StudySessions_Employees
    FOREIGN KEY (LecturerID)
    REFERENCES Employees (EmployeeID);

-- Reference: StudySessions_Subjects (table: StudiesSessions)
ALTER TABLE StudiesSessions ADD CONSTRAINT StudySessions_Subjects
    FOREIGN KEY (SubjectID)
    REFERENCES Subjects (SubjectID);

-- Reference: SubjectMakeUpPossibilities_Products (table: SubjectMakeUpPossibilities)
ALTER TABLE SubjectMakeUpPossibilities ADD CONSTRAINT SubjectMakeUpPossibilities_Products
    FOREIGN KEY (ProductID)
    REFERENCES Products (ProductID);

-- Reference: SubjectMakeUpPossibilities_Subjects (table: SubjectMakeUpPossibilities)
ALTER TABLE SubjectMakeUpPossibilities ADD CONSTRAINT SubjectMakeUpPossibilities_Subjects
    FOREIGN KEY (SubjectID)
    REFERENCES Subjects (SubjectID);

-- Reference: Subjects_Employees (table: Subjects)
ALTER TABLE Subjects ADD CONSTRAINT Subjects_Employees
    FOREIGN KEY (CoordinatorID)
    REFERENCES Employees (EmployeeID);

-- Reference: Users_People (table: Users)
ALTER TABLE Users ADD CONSTRAINT Users_People
    FOREIGN KEY (UserID)
    REFERENCES People (PersonID);

-- Reference: WebinarParticipants_Payments (table: WebinarParticipants)
ALTER TABLE WebinarParticipants ADD CONSTRAINT WebinarParticipants_Payments
    FOREIGN KEY (FullPricePaymentID)
    REFERENCES Payments (PaymentID)
    ON DELETE  CASCADE;

-- Reference: WebinarParticipants_Users (table: WebinarParticipants)
ALTER TABLE WebinarParticipants ADD CONSTRAINT WebinarParticipants_Users
    FOREIGN KEY (UserID)
    REFERENCES Users (UserID)
    ON DELETE  CASCADE;

-- Reference: WebinarParticipants_Webinars (table: WebinarParticipants)
ALTER TABLE WebinarParticipants ADD CONSTRAINT WebinarParticipants_Webinars
    FOREIGN KEY (WebinarID)
    REFERENCES Webinars (WebinarID)
    ON DELETE  CASCADE;

-- Reference: WebinarsAttendence_WebinarParticipants (table: WebinarsAttendence)
ALTER TABLE WebinarsAttendence ADD CONSTRAINT WebinarsAttendence_WebinarParticipants
    FOREIGN KEY (WebinarParticipantID)
    REFERENCES WebinarParticipants (WebinarParticipantID);

-- Reference: WebinarsAttendence_Webinars (table: WebinarsAttendence)
ALTER TABLE WebinarsAttendence ADD CONSTRAINT WebinarsAttendence_Webinars
    FOREIGN KEY (WebinarID)
    REFERENCES Webinars (WebinarID)
    ON DELETE  CASCADE;

-- Reference: Webinars_Languages (table: Webinars)
ALTER TABLE Webinars ADD CONSTRAINT Webinars_Languages
    FOREIGN KEY (LanguageID)
    REFERENCES Languages (LanguageID);

-- Reference: Webinars_Lecturers (table: Webinars)
ALTER TABLE Webinars ADD CONSTRAINT Webinars_Lecturers
    FOREIGN KEY (TranslatorID)
    REFERENCES Employees (EmployeeID);

-- Reference: Webinars_Products (table: Webinars)
ALTER TABLE Webinars ADD CONSTRAINT Webinars_Products
    FOREIGN KEY (WebinarID)
    REFERENCES Products (ProductID);

-- Reference: Webinars_Translators (table: Webinars)
ALTER TABLE Webinars ADD CONSTRAINT Webinars_Translators
    FOREIGN KEY (LecturerID)
    REFERENCES Employees (EmployeeID);

-- End of file.

