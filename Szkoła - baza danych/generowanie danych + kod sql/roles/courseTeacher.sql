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
