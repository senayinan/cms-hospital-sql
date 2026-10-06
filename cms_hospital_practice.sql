-- CMS Hospitals SQL Practice
-- Data: CMS Provider Data Catalog (data.cms.gov/provider-data/topics/hospitals)


USE cms_hospitals;



-- Q0: Show every Missouri hospital's Facility ID, name, and each of its visits measures with the score.
-- No JOIN needed - all four columns exist in u (1,498 rows)
SELECT `Facility ID`, `Facility Name`, `Measure ID`, `Score`
FROM unplanned_hospital_visits_hospital
WHERE `State` = 'MO';



-- Q1: For Missouri hospitals, show name, hospital type, and each visits measure with its score.
-- INNER JOIN needed because Hospital Type is only in h
SELECT u.`Facility Name`, h.`Hospital Type`, u.`Measure ID`, u.`Score`
FROM unplanned_hospital_visits_hospital u
INNER JOIN hospital_general_information h
ON u.`Facility ID` = h.`Facility ID`
WHERE h.`State` = 'MO';



-- Q1 check: row count (should be 1,498 = 107 hospitals x 14 measures)
SELECT COUNT(*)
FROM unplanned_hospital_visits_hospital u
INNER JOIN hospital_general_information h
ON u.`Facility ID` = h.`Facility ID`
WHERE h.`State` = 'MO';



-- Q2: For Missouri hospitals - name, ownership, readmission measures only with their scores (642 rows)
SELECT h.`Facility Name`, h.`Hospital Ownership`, u.`Measure ID`, u.`Score`
FROM unplanned_hospital_visits_hospital u
INNER JOIN hospital_general_information h
ON u.`Facility ID` = h.`Facility ID`
WHERE h.`State` = 'MO'
AND u.`Measure ID` LIKE 'READM%';



-- Q3: Find Missouri hospitals with no data in the unplanned visits table.
-- LEFT JOIN keeps all hospitals; no rows in u means every u column is NULL
SELECT h.`Facility ID`, h.`Facility Name`, h.`Hospital Type`
FROM hospital_general_information h
LEFT JOIN unplanned_hospital_visits_hospital u
ON h.`Facility ID` = u.`Facility ID`
WHERE u.`Facility ID` IS NULL
AND h.`State` = 'MO';



-- Q3b: Find hospitals that have rows in u, but Number of Patients says 'Not Applicable'.
-- Row exists but holds text instead of a number (different from NULL in Q3)
SELECT DISTINCT h.`Facility ID`, h.`Facility Name`, h.`Hospital Type`
FROM hospital_general_information h
LEFT JOIN unplanned_hospital_visits_hospital u
ON h.`Facility ID` = u.`Facility ID`
WHERE u.`Number of Patients` = 'Not Applicable';


-- Q4: For each state, count hospitals with no data in the unplanned visits table, most first.
-- LEFT JOIN + GROUP BY state; counts add up to 629
SELECT h.`State`, COUNT(h.`Facility ID`) AS missing_hospitals
FROM hospital_general_information h
LEFT JOIN unplanned_hospital_visits_hospital u
ON h.`Facility ID` = u.`Facility ID`
WHERE u.`Facility ID` IS NULL
GROUP BY h.`State`
ORDER BY missing_hospitals DESC;

























