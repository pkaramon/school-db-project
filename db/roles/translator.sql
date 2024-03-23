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
