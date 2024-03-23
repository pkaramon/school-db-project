-- Administrator - zarządza bazą danych, nieograniczone uprawnienia
CREATE ROLE AdministratorRole;

GRANT CONTROL ON DATABASE::u_karamon TO [AdministratorRole];
GRANT VIEW DEFINITION TO [AdministratorRole];
GRANT VIEW DATABASE STATE TO [AdministratorRole];
