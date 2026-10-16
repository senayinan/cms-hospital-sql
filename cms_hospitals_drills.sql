-- CMS Hospitals SQL Drills
-- Data: CMS Provider Data Catalog (data.cms.gov/provider-data/topics/hospitals)

USE cms_hospitals;


-- Drill 1: How many hospitals in each state have a 5-star summary rating?
-- "How many per state" -> COUNT + GROUP BY state; no JOIN, all columns in hcahps_hospital
SELECT s.`State`, COUNT(*) AS hospitals
FROM hcahps_hospital AS s
WHERE s.`HCAHPS Measure ID` = 'H_STAR_RATING'
AND s.`Patient Survey Star Rating` = '5'
GROUP BY s.`State`
ORDER BY hospitals DESC;


-- Drill 2: Names of Missouri hospitals with a 5-star summary rating.
-- "Which ones" -> list names, no GROUP BY; three WHERE conditions
SELECT s.`Facility Name`
FROM hcahps_hospital AS s
WHERE s.`HCAHPS Measure ID` = 'H_STAR_RATING'
AND s.`Patient Survey Star Rating` = '5'
AND s.`State` = 'MO';


-- Drill 3: Missouri hospitals' names and summary star rating, highest first, excluding 'Not Available'.
-- "Which ones" -> list, no GROUP BY; <> means "not equal"; ORDER BY rating DESC
SELECT s.`Facility Name`, s.`Patient Survey Star Rating`
FROM hcahps_hospital AS s
WHERE s.`HCAHPS Measure ID` = 'H_STAR_RATING'
AND s.`Patient Survey Star Rating` <> 'Not Available'
AND s.`State` = 'MO'
ORDER BY s.`Patient Survey Star Rating` DESC;


-- Drill 4: How many Missouri hospitals have a summary star rating of 4 or 5?
-- (>= '4' would also match 'Not Available', because the column is text)
SELECT COUNT(*)
FROM hcahps_hospital AS s
WHERE s.`HCAHPS Measure ID` = 'H_STAR_RATING'
AND s.`Patient Survey Star Rating` IN ('4', '5')
AND s.`State` = 'MO';


-- Drill 5: How many Missouri hospitals have a summary star rating of 1 or 2?
SELECT COUNT(*)
FROM hcahps_hospital s
WHERE s.`HCAHPS Measure ID` = 'H_STAR_RATING'
AND s.`Patient Survey Star Rating` IN ('1', '2')
AND s.`State` = 'MO';



-- Drill 6: For each state, how many hospitals have a summary star rating of 'Not Available'? Most first.
-- "How many per state" -> COUNT + GROUP BY state
SELECT s.`State`, COUNT(*) AS hospitals
FROM hcahps_hospital s
WHERE s.`HCAHPS Measure ID` = 'H_STAR_RATING'
AND s.`Patient Survey Star Rating` = 'Not Available'
GROUP BY s.`State`
ORDER BY hospitals DESC;