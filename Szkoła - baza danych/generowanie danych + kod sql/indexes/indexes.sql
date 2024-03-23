-- Indeksy w tabeli Webinars: wykładowca, tłumacz, język, data rozpoczęcia, data zakończenia
CREATE INDEX idx_webinars ON Webinars (LecturerID, TranslatorID, LanguageID, StartDate, EndDate);

-- Indeksy w tabeli WebinarParticipants: użytkownik, webinar, ID płatności pełnej ceny
CREATE INDEX idx_webinarparticipants ON WebinarParticipants (UserID, WebinarID, FullPricePaymentID);

-- Indeksy w tabeli Courses: data rozpoczęcia, data zakończenia, koordynator, język
CREATE INDEX idx_courses ON Courses (StartDate, EndDate, CoordinatorID, LanguageID);

-- Indeksy w tabeli Payments: użytkownik, produkt, data
CREATE INDEX idx_payments ON Payments (UserID, ProductID, Date);

-- Indeksy w tabeli CoursesSessions: wykładowca, tłumacz, moduł
CREATE INDEX idx_coursessessions ON CoursesSessions (LecturerID, TranslatorID, ModuleID);

-- Indeksy w tabeli CourseOnlineSessions: data rozpoczęcia, data zakończenia
CREATE INDEX idx_courseonlinesessions ON CourseOnlineSessions (StartDate, EndDate);

-- Indeksy w tabeli CourseStationarySessions: data rozpoczęcia, data zakończenia
CREATE INDEX idx_coursestationarysessions ON CourseStationarySessions (StartDate, EndDate);

-- Indeksy w tabeli CourseParticipants: kurs, użytkownik, data dodania
CREATE INDEX idx_courseparticipants ON CourseParticipants (CourseID, UserID, AddedAt);

-- Indeksy w tabeli DaysInInternship: data rozpoczęcia, data zakończenia, staż
CREATE INDEX idx_daysininternship ON DaysInInternship (StartDate, EndDate, InternshipID);

-- Indeksy w tabeli DiplomasSent: użytkownik, data wysłania
CREATE INDEX idx_diplomassent ON DiplomasSent (UserID, SentAt);

-- Indeksy w tabeli EmployeeRoles: pracownik, rola
CREATE INDEX idx_employeeroles ON EmployeeRoles (EmployeeID, RoleID);

-- Indeksy w tabeli Exams: przedmiot, data rozpoczęcia, data zakończenia
CREATE INDEX idx_exams ON Exams (SubjectID, StartDate, EndDate);

-- Indeksy w tabeli ExamsGrades: student, egzamin
CREATE INDEX idx_examsgrades ON ExamsGrades (StudentID, ExamID);

-- Indeksy w tabeli InternshipDetails: student, data ukończenia
CREATE INDEX idx_internshipdetails ON InternshipDetails (StudentID, CompletedAt);

-- Indeksy w tabeli Internships: studia, data rozpoczęcia, data zakończenia
CREATE INDEX idx_internships ON Internships (StudiesID, StartDate, EndDate);

-- Indeksy w tabeli MaxDaysForPaymentBeforeCourseStart: data rozpoczęcia, data zakończenia, kurs
CREATE INDEX idx_maxdayspaymentcourse ON MaxDaysForPaymentBeforeCourseStart (StartDate, EndDate, CourseID);

-- Indeksy w tabeli MaxDaysForPaymentBeforeStudiesStart: data rozpoczęcia, data zakończenia, studia
CREATE INDEX idx_maxdayspaymentstudies ON MaxDaysForPaymentBeforeStudiesStart (StartDate, EndDate, StudiesID);

-- Indeksy w tabeli MinAttendancePercentageToPassCourse: data rozpoczęcia, data zakończenia, kurs
CREATE INDEX idx_minattendancecourse ON MinAttendancePercentageToPassCourse (StartDate, EndDate, CourseID);

-- Indeksy w tabeli MinAttendancePercentageToPassInternship: data rozpoczęcia, data zakończenia, staż
CREATE INDEX idx_minattendanceinternship ON MinAttendancePercentageToPassInternship (StartDate, EndDate, InternshipID);

-- Indeksy w tabeli MinAttendancePercentageToPassStudies: data rozpoczęcia, data zakończenia, studia
CREATE INDEX idx_minattendancestudies ON MinAttendancePercentageToPassStudies (StartDate, EndDate, StudiesID);

-- Indeksy w tabeli People: data urodzenia
CREATE INDEX idx_people ON People (BirthDate);

-- Indeksy w tabeli Products: cena, data dodania, data zamknięcia
CREATE INDEX idx_products ON Products (Price, AddedAt, ClosedAt);

-- Indeksy w tabeli RecordingAccessTime: data rozpoczęcia, data zakończenia, webinar
CREATE INDEX idx_recordingaccesstime ON RecordingAccessTime (StartDate, EndDate, WebinarID);

-- Indeksy w tabeli Students: użytkownik, studia, data dodania
CREATE INDEX idx_students ON Students (UserID, StudiesID, AddedAt);

-- Indeksy w tabeli Studies: data rozpoczęcia, data zakończenia, koordynator, język
CREATE INDEX idx_studies ON Studies (StartDate, EndDate, CoordinatorID, LanguageID);

-- Indeksy w tabeli StudiesSessions: przedmiot, data rozpoczęcia, data zakończenia, wykładowca, język
CREATE INDEX idx_studiessessions ON StudiesSessions (SubjectID, StartDate, EndDate, LecturerID, LanguageID);

-- Indeksy w tabeli Subjects: studia, koordynator
CREATE INDEX idx_subjects ON Subjects (StudiesID, CoordinatorID);

GO