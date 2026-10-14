-- CMS Hospitals SQL Drills
-- Data: CMS Provider Data Catalog (data.cms.gov/provider-data/topics/hospitals)

USE cms_hospitals;


-- Drill 1: How many hospitals in each state have a 5-star summary rating?
-- "How many per state" -> COUNT + GROUP BY state; no JOIN, all columns in hcahps_hospital
SELECT s.`State`, COUNT(*) AS hospitals
FROM hcahps_hospital s
WHERE s.`HCAHPS Measure ID` = 'H_STAR_RATING'
AND s.`Patient Survey Star Rating` = '5'
GROUP BY s.`State`
ORDER BY hospitals DESC;


-- Drill 2: Names of Missouri hospitals with a 5-star summary rating.
-- "Which ones" -> list names, no GROUP BY; three WHERE conditions
SELECT s.`Facility Name`
FROM hcahps_hospital s
WHERE s.`HCAHPS Measure ID` = 'H_STAR_RATING'
AND s.`Patient Survey Star Rating` = '5'
AND s.`State` = 'MO';