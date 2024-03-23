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
