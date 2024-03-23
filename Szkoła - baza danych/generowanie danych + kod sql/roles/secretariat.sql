-- Sekretariat - wysyłanie dyplomów, raporty bilokacji, informacje o pracownikach i uczniach
CREATE ROLE [SecretariatRole];

GRANT EXECUTE ON [dbo].[SendDiploma] TO [SecretariatRole];

GRANT SELECT ON [dbo].[EmployeeStatistics] TO [SecretariatRole];
GRANT SELECT ON [dbo].[Loaners] TO [SecretariatRole];
GRANT SELECT ON [dbo].[AttendanceListForEachSession] TO [SecretariatRole];
GRANT SELECT ON [dbo].[GeneralAttendance] TO [SecretariatRole];
GRANT SELECT ON [dbo].[NumberOfPeopleRegisteredForEvents] TO [SecretariatRole];
