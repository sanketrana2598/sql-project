select * from [students_dataset (1)]
select count(*) from [students_dataset (1)]
sp_help  [students_dataset (1)]

--to find duplicates
SELECT Student_ID, COUNT(*) AS Duplicate_Count
FROM [students_dataset (1)]
GROUP BY Student_ID
HAVING COUNT(*) > 1
--to find null 

SELECT *
FROM [students_dataset (1)]
WHERE Student_ID IS NULL
   OR Country IS NULL
   OR Academic_Level IS NULL
   OR Daily_Usage_Hours IS NULL
   OR Mental_Health_Score IS NULL
   OR Sleep_Hours IS NULL
   OR Addicted_Score IS NULL
   OR Most_Used_Platform IS NULL


  -- Find the top 3 countries with the highest average Daily_Usage_Hours among Undergraduate students.
   SELECT top 3 country, avg(Daily_Usage_Hours) AS Avg_Usage ,Academic_Level
FROM [students_dataset (1)] where academic_level ='undergraduate'group by Academic_Level,country order by Avg_Usage desc

--Find students whose Sleep_Hours is below the average sleep hours of their academic level.
SELECT Student_ID,Sleep_Hours
FROM [students_dataset (1)]
WHERE Sleep_Hours < (
    SELECT AVG(Sleep_Hours)
    FROM [students_dataset (1)])

	--Find students who rank in the top 2 of Daily_Usage_Hours within their country using a window function.
	--using cte
	WITH RankedStudents AS (
    SELECT Student_ID, Country, Daily_Usage_Hours,
           DENSE_RANK() OVER (PARTITION BY Country ORDER BY Daily_Usage_Hours DESC) AS ranking
    FROM [students_dataset (1)]
)
SELECT *
FROM RankedStudents
WHERE ranking <= 2

--Find the correlation-like relationship: Which country has the highest average Daily_Usage_Hours to average Sleep_Hours ratio?
SELECT Country,
       AVG(Daily_Usage_Hours) / NULLIF(AVG(Sleep_Hours), 0) AS Usage_Sleep_Ratio
FROM [students_dataset (1)]
GROUP BY Country
ORDER BY Usage_Sleep_Ratio DESC

--Find the percentage of students addicted (Addicted_Score ≥ 7) in each academic level.
SELECT Academic_Level,
       100.0 * SUM(CASE WHEN Addicted_Score >= 7 THEN 1 ELSE 0 END) / COUNT(*) AS Addiction_Percentage
FROM [students_dataset (1)]
GROUP BY Academic_Level

--List each student’s , country, and academic level, along with the average Daily Usage Hours of their country.
SELECT s.Student_ID, s.Country, s.Academic_Level, s.Daily_Usage_Hours,
       c.Avg_Usage
FROM [students_dataset (1)] s
INNER JOIN (
    SELECT Country, AVG(Daily_Usage_Hours) AS Avg_Usage
    FROM [students_dataset (1)]
    GROUP BY Country
) c
ON s.Country = c.Country

SELECT Student_ID, Country, Academic_Level, avg(Daily_Usage_Hours) as avg_hrs ,( select avg (Daily_Usage_Hours) from [students_dataset (1)]) as avg_column
FROM [students_dataset (1)] group by country,Student_ID,Academic_Level 



--Find all students who belong to countries where at least one student has a Mental Health Score < 3.

SELECT s.Student_ID,  s.Country,Mental_Health_Score
FROM [students_dataset (1)] s
WHERE EXISTS (
    SELECT 1
    FROM [students_dataset (1)] x
    WHERE x.Country = s.Country
      AND x.Mental_Health_Score < 3
)


SELECT Student_ID,  Country,Mental_Health_Score
FROM [students_dataset (1)] 
WHERE (
     Mental_Health_Score < 3)


--Get the list of students for whom there exists another student in the same country with a higher Addicted Score.

SELECT s.Student_ID,  s.Country, s.Addicted_Score
FROM [students_dataset (1)] s
WHERE EXISTS (
    SELECT 1
    FROM [students_dataset (1)] x
    WHERE x.Country = s.Country
      AND x.Addicted_Score > s.Addicted_Score
)

--Find students who belong to countries that exist in the top 3 countries with highest average Daily Usage Hours.

SELECT s.Student_ID,  s.Country, s.Daily_Usage_Hours
FROM [students_dataset (1)] s
WHERE EXISTS (
    SELECT TOP 3 Country
    FROM [students_dataset (1)]
    GROUP BY Country
    ORDER BY AVG(Daily_Usage_Hours) DESC
) 

select 
select top 3 country ,student_ID ,avg(daily_usage_hours) as avg_hrs from [students_dataset (1)] group by country,student_ID order by avg_hrs desc
