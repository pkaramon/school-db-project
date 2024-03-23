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
