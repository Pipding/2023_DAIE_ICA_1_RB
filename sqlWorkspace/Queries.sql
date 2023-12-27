-- First, you are required to write three core SQL queries to perform the following tasks:

-- 1.   List the total budget allocated for projects in each country, along with the count of projects per country.
--      Display sorted by the total budget in descending order
SELECT CustomerCountry as Country, SUM(Budget) AS 'TotalBudget', COUNT(ProjectID) AS "ProjectCount" FROM Projects JOIN Customers C on Projects.CustomerID = C.CustomerID GROUP BY CustomerCountry ORDER BY TotalBudget DESC;
