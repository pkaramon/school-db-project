--Nauczyciel akademicki może tworzyć przedmioty/zajęcia, egzaminy, dodawać oceny z egzaminów, wpisywać obecności, tworzyć staże, wpisywać zaliczenia ze stażu, aktualizować ich dane
CREATE ROLE [AcademicTeacherRole];

GRANT EXECUTE ON [CreateSubject] TO [AcademicTeacherRole];
GRANT EXECUTE ON [ModifySubject] TO [AcademicTeacherRole];
GRANT EXECUTE ON [CreateSemesterOfStudies] TO [AcademicTeacherRole];
GRANT EXECUTE ON [AddExam] TO [AcademicTeacherRole];
GRANT EXECUTE ON [ModifyExam] TO [AcademicTeacherRole];
GRANT EXECUTE ON [UpdateExamGrade] TO [AcademicTeacherRole];
GRANT EXECUTE ON [AddInternship] TO [AcademicTeacherRole];
GRANT EXECUTE ON [ModifyInternship] TO [AcademicTeacherRole];
GRANT EXECUTE ON [UpdateInternshipDetail] TO [AcademicTeacherRole];
GRANT EXECUTE ON [UpdateAttendance] TO [AcademicTeacherRole];

GRANT SELECT ON [AttendanceListForEachSession] TO [AcademicTeacherRole];
GRANT SELECT ON [GeneralAttendance] TO [AcademicTeacherRole];
-- Księgowa - ma dostęp do widoków związanych z finansami
CREATE ROLE [AccountantRole];
GRANT SELECT ON [dbo].[TotalIncomeForProducts] TO [AccountantRole];
GRANT SELECT ON [dbo].[RevenueSummaryByProductType] TO [AccountantRole];
GRANT SELECT ON [dbo].[Loaners] TO [AccountantRole];
-- Administrator - zarządza bazą danych, nieograniczone uprawnienia
CREATE ROLE AdministratorRole;

GRANT CONTROL ON DATABASE::u_karamon TO [AdministratorRole];
GRANT VIEW DEFINITION TO [AdministratorRole];
GRANT VIEW DATABASE STATE TO [AdministratorRole];
-- Nauczyciel związany z kursami Może tworzyć modyfikować kursy, zajęcia, moduły, wpisywać obecności
CREATE ROLE [CoursesTeacherRole];

GRANT EXECUTE ON [CreateCourse] TO [CoursesTeacherRole];
GRANT EXECUTE ON [ModifyCourse] TO [CoursesTeacherRole];
GRANT EXECUTE ON [CreateModule] TO [CoursesTeacherRole];
GRANT EXECUTE ON [ModifyModule] TO [CoursesTeacherRole];
GRANT EXECUTE ON [DeleteModule] TO [CoursesTeacherRole];

GRANT EXECUTE ON [ModifyOnlineCourseSession] TO [CoursesTeacherRole];
GRANT EXECUTE ON [ModifyOfflineCourseSession] TO [CoursesTeacherRole];
GRANT EXECUTE ON [ModifyStationaryCourseSession] TO [CoursesTeacherRole];
GRANT EXECUTE ON [DeleteCourseSession] TO [CoursesTeacherRole];

GRANT EXECUTE ON [UpdateAttendance] TO [CoursesTeacherRole];
GRANT EXECUTE ON [DeleteAttendance] TO [CoursesTeacherRole];
GRANT EXECUTE ON [UpdateCourseSessionAttendance] TO [CoursesTeacherRole];
GRANT EXECUTE ON [DeleteCourseSessionAttendance] TO [CoursesTeacherRole];
-- Dyrektor - odroczenie płatności, widoki dotyczące finansów, wyników pracowników, nadawanie pracownikom ról. Utworzenie/modyfikacja studiów. Utworzenie/modyfikacja kierunku studiów. Dostęp do raportów finansowych dostęp do raportów dotyczących pracowników.
CREATE ROLE HeadMasterRole;

GRANT SELECT ON TotalIncomeForProducts TO HeadMasterRole;
GRANT SELECT ON RevenueSummaryByProductType TO HeadMasterRole;

GRANT EXECUTE ON AddEmployee TO HeadMasterRole;
GRANT EXECUTE ON AddRole TO HeadMasterRole;
GRANT EXECUTE ON ModifyRole TO HeadMasterRole;
GRANT EXECUTE ON AddEmployeeRole TO HeadMasterRole;
GRANT EXECUTE ON RemoveEmployeeRole TO HeadMasterRole;

GRANT EXECUTE ON CreateSemesterOfStudies TO HeadMasterRole;
GRANT EXECUTE ON ModifyStudies TO HeadMasterRole;
GRANT EXECUTE ON AddFieldOfStudy TO HeadMasterRole;
GRANT EXECUTE ON DeleteFieldOfStudies TO HeadMasterRole;

GRANT SELECT ON EmployeeStatistics TO HeadMasterRole;
GRANT SELECT ON EmployeeTimeTable TO HeadMasterRole;
GRANT SELECT ON ActivityConflicts TO HeadMasterRole;

GRANT EXECUTE ON EnrollUserWithoutImmediatePayment TO HeadMasterRole;
GRANT EXECUTE ON ChangeProductPrice TO HeadMasterRole;

-- Sekretariat - wysyłanie dyplomów, raporty bilokacji, informacje o pracownikach i uczniach
CREATE ROLE [SecretariatRole];

GRANT EXECUTE ON [dbo].[SendDiploma] TO [SecretariatRole];

GRANT SELECT ON [dbo].[EmployeeStatistics] TO [SecretariatRole];
GRANT SELECT ON [dbo].[Loaners] TO [SecretariatRole];
GRANT SELECT ON [dbo].[AttendanceListForEachSession] TO [SecretariatRole];
GRANT SELECT ON [dbo].[GeneralAttendance] TO [SecretariatRole];
GRANT SELECT ON [dbo].[NumberOfPeopleRegisteredForEvents] TO [SecretariatRole];
-- Tłumacz - dodawanie/modyfikacja nagrania w celu dodania tłumaczenia
CREATE ROLE TranslatorRole;

GRANT EXECUTE ON ModifyOnlineCourseSession TO TranslatorRole;
GRANT EXECUTE ON ModifyOnlineStudySession TO TranslatorRole;
GRANT EXECUTE ON ModifyOnlineStudiesSessionRecording TO TranslatorRole;
GRANT EXECUTE ON ModifyWebinarRecording TO TranslatorRole;

GRANT SELECT ON Webinars TO TranslatorRole;
GRANT SELECT ON CoursesSessions TO TranslatorRole;
GRANT SELECT ON CourseOnlineSessions TO TranslatorRole;
GRANT SELECT ON CourseOfflineSessions TO TranslatorRole;
GRANT SELECT ON StudiesSessions TO TranslatorRole;
GRANT SELECT ON OnlineStudiesSessions TO TranslatorRole;
-- Wykładowcy webinariów - tworzenie/modyfikacja webinarów
CREATE ROLE [WebinarLecturerRole];

GRANT EXECUTE ON [dbo].[AddWebinar] TO [WebinarLecturerRole];
GRANT EXECUTE ON [dbo].[ModifyWebinarData] TO [WebinarLecturerRole];
GRANT EXECUTE ON [dbo].[DeleteWebinar] TO [WebinarLecturerRole];
GRANT EXECUTE ON [dbo].[ModifyWebinarRecording] TO [WebinarLecturerRole];
GRANT EXECUTE ON [dbo].[CloseWebinar] TO [WebinarLecturerRole];
