-- First, you are required to write three core SQL queries to perform the following tasks:

-- 1.   List the total budget allocated for projects in each country, along with the count of projects per country.
--      Display sorted by the total budget in descending order
SELECT
    CustomerCountry AS Country,
    SUM(Budget) AS 'TotalBudget',
    COUNT(ProjectID) AS "ProjectCount"
FROM Projects
    JOIN Customers C ON
        Projects.CustomerID = C.CustomerID
GROUP BY CustomerCountry
ORDER BY TotalBudget DESC;






-- 2.   List the average development time for projects, categorized by the number of assets used.

-- Uses a sub-query to calculate the number of days taken & asset count for each project
-- Then queries the average dev time when grouped by asset count
SELECT
    AVG(DaysTaken) AS AverageDevTime,
    AssetCount
FROM (
    SELECT
        COUNT(AssetID) AS AssetCount,
        (JULIANDAY(EndDate) - JULIANDAY(StartDate)) AS DaysTaken
    FROM Projects
        LEFT JOIN Assets A ON
            Projects.ProjectID = A.ProjectID
    GROUP BY Projects.ProjectID
)
GROUP BY AssetCount;



-- 3.   List the top three developers based on the number of successful projects they’ve been involved in.
--      Display the results.

SELECT
    Name,
    COUNT(ProjectDevelopers.ProjectID) AS SuccessfulProjects
FROM ProjectDevelopers
    LEFT JOIN Projects P ON
        ProjectDevelopers.ProjectID = P.ProjectID
    JOIN Developers D ON
        ProjectDevelopers.DeveloperID = D.DeveloperID
WHERE Status IS 'Completed'
GROUP BY D.DeveloperID
ORDER BY SuccessfulProjects DESC
LIMIT 3;