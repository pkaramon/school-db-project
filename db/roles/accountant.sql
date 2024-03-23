-- Księgowa - ma dostęp do widoków związanych z finansami
CREATE ROLE [AccountantRole];
GRANT SELECT ON [dbo].[TotalIncomeForProducts] TO [AccountantRole];
GRANT SELECT ON [dbo].[RevenueSummaryByProductType] TO [AccountantRole];
GRANT SELECT ON [dbo].[Loaners] TO [AccountantRole];
