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
WHERE
    Status IS 'Completed'
GROUP BY D.DeveloperID
ORDER BY SuccessfulProjects DESC
LIMIT 3;





-- Next, you are also required to demonstrate the following three general SQL concepts using
-- no fewer than three distinct SQL statements:
-- 1. SELECT with LIKE and OR
-- 2. SELECT with DISTINCT and ORDER BY
-- 3. Subquery with SELECT



-- 1.  Order all developers with "designer" or "engineer" in their specialization by years of experience

SELECT
    Name, Specialization, ExperienceYears
FROM Developers
WHERE
    LOWER(Specialization) LIKE '%designer'
    OR
    LOWER(Specialization) LIKE '%engineer'
ORDER BY ExperienceYears DESC;



-- 2. Select all project leads and sort alphabetically
SELECT DISTINCT Name
FROM Developers
    JOIN ProjectDevelopers PD ON Developers.DeveloperID = PD.DeveloperID
    JOIN Projects P ON PD.ProjectID = P.ProjectID
WHERE
    LOWER(Role) IS 'lead'
ORDER BY Name ASC;



-- 3. Get names and specializations of all developers who have worked on more than 1 project

-- The subquery is justified here because the WHERE condition acts on the computed ProjectCount, which is an aggregate
-- call. This isn't allowed in SQLite so a subquery is required
SELECT
    Name,
    Specialization,
    ProjectCount
FROM (
    SELECT
        Name,
        Specialization,
        COUNT(ProjectID) AS ProjectCount
    FROM ProjectDevelopers
    JOIN Developers D on D.DeveloperID = ProjectDevelopers.DeveloperID
    GROUP BY D.DeveloperID
)
WHERE ProjectCount > 1
ORDER BY ProjectCount DESC;





-- Other queries

-- Get the number of devs on each project (including assets)
SELECT
    Projects.ProjectID,
    Count(DISTINCT A.AssetID) AS AssetCount,
    Count(DISTINCT DeveloperID) AS DevCount
FROM Projects
    LEFT JOIN Assets A on Projects.ProjectID = A.ProjectID
    LEFT JOIN AssetsDevelopers AD on A.AssetID = AD.AssetID
GROUP BY Projects.ProjectID;
