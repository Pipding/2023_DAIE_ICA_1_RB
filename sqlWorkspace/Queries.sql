-- First, you are required to write three core SQL queries to perform the following tasks:

-- 1.   List the total budget allocated for projects in each country, along with the count of projects per country.
--      Display sorted by the total budget in descending order
SELECT CustomerCountry as Country, SUM(Budget) AS 'TotalBudget', COUNT(ProjectID) AS "ProjectCount" FROM Projects JOIN Customers C on Projects.CustomerID = C.CustomerID GROUP BY CustomerCountry ORDER BY TotalBudget DESC;




-- 2.   List the average development time for projects, categorized by the number of assets used.

-- Get the asset counts
SELECT ProjectName, (JULIANDAY(EndDate) - JULIANDAY(StartDate)) AS DaysTaken, COUNT(AssetID) AS AssetCount FROM Projects LEFT JOIN Assets A on Projects.ProjectID = A.ProjectID GROUP BY ProjectName;