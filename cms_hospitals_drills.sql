-- CMS Hospitals SQL Drills
-- Data: CMS Provider Data Catalog (data.cms.gov/provider-data/topics/hospitals)

USE cms_hospitals;


-- Drill 1: How many hospitals in each state have a 5-star summary rating?
SELECT s.`State`, COUNT(*) AS hospitals
FROM hcahps_hospital AS s
WHERE s.`HCAHPS Measure ID` = 'H_STAR_RATING'
AND s.`Patient Survey Star Rating` = '5'
GROUP BY s.`State`
ORDER BY hospitals DESC;


-- Drill 2: Names of Missouri hospitals with a 5-star summary rating.
SELECT s.`Facility Name`
FROM hcahps_hospital AS s
WHERE s.`HCAHPS Measure ID` = 'H_STAR_RATING'
AND s.`Patient Survey Star Rating` = '5'
AND s.`State` = 'MO';


-- Drill 3: Missouri hospitals' names and summary star rating, highest first, excluding 'Not Available'.
SELECT s.`Facility Name`, s.`Patient Survey Star Rating`
FROM hcahps_hospital AS s
WHERE s.`HCAHPS Measure ID` = 'H_STAR_RATING'
AND s.`Patient Survey Star Rating` <> 'Not Available'
AND s.`State` = 'MO'
ORDER BY s.`Patient Survey Star Rating` DESC;


-- Drill 4: How many Missouri hospitals have a summary star rating of 4 or 5?
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
SELECT s.`State`, COUNT(*) AS hospitals
FROM hcahps_hospital AS s
WHERE s.`HCAHPS Measure ID` = 'H_STAR_RATING'
AND s.`Patient Survey Star Rating` = 'Not Available'
GROUP BY s.`State`
ORDER BY hospitals DESC;


-- Drill 7: For Missouri, how many hospitals are there of each Hospital Type? Most first.
SELECT h.`Hospital Type`, COUNT(*) AS hospitals
FROM hospital_general_information AS h
WHERE h.`State` = 'MO'
GROUP BY h.`Hospital Type`
ORDER BY hospitals DESC;



-- Drill 8: For Missouri, how many 5-star hospitals (summary rating) are there of each Hospital Type?
SELECT h.`Hospital Type`, COUNT(*) AS hospitals
FROM hospital_general_information AS h
INNER JOIN hcahps_hospital AS s
ON h.`Facility ID` = s.`Facility ID`
WHERE h.`State` = 'MO'
AND s.`HCAHPS Measure ID` = 'H_STAR_RATING'
AND s.`Patient Survey Star Rating` = '5'
GROUP BY h.`Hospital Type`
ORDER BY hospitals DESC;



-- Drill 9: Names and Hospital Type of Missouri hospitals with NO data in the patient survey table.
SELECT h.`Facility Name`, h.`Hospital Type`
FROM hospital_general_information AS h
LEFT JOIN hcahps_hospital AS s
ON h.`Facility ID` = s.`Facility ID`
WHERE h.`State` = 'MO'
AND s.`Facility ID` IS NULL;


-- Drill 10: How many Missouri hospitals have no data in the patient survey table?
SELECT COUNT(*)
FROM hospital_general_information AS h
LEFT JOIN hcahps_hospital AS s
ON h.`Facility ID` = s.`Facility ID`
WHERE h.`State` = 'MO'
AND s.`Facility ID` IS NULL;


-- Drill 11: For each state, how many hospitals have no data in the unplanned visits table? Most first.
SELECT h.`State`, COUNT(*) AS hospitals
FROM hospital_general_information AS h
LEFT JOIN unplanned_hospital_visits_hospital AS u
ON h.`Facility ID` = u.`Facility ID`
WHERE u.`Facility ID` IS NULL
GROUP BY `State`
ORDER BY hospitals DESC;



-- Drill 12: List the names of Missouri hospitals whose Emergency Services column says 'No'.
SELECT h.`Facility Name`
FROM hospital_general_information AS h
WHERE h.`State` = 'MO'
AND h.`Emergency Services` = 'No';


-- Drill 13: For Missouri, how many hospitals are there for each Hospital Ownership type? Most first.
SELECT h.`Hospital Ownership`, COUNT(*) AS hospitals
FROM hospital_general_information AS h
WHERE h.`State` = 'MO'
GROUP BY h.`Hospital Ownership`
ORDER BY hospitals DESC;


-- Drill 14: List the names and nurse communication star rating of Missouri hospitals, highest first. Leave out ‘Not Available’.
SELECT s.`Facility Name` AS hospitals, s.`Patient Survey Star Rating` AS ratings
FROM hcahps_hospital AS s
WHERE s.`State` = 'MO'
AND s.`HCAHPS Measure ID` = 'H_COMP_1_STAR_RATING'
AND s.`Patient Survey Star Rating` <>'Not Available' 
ORDER BY hospitals;


-- Drill 15: For Missouri, list each Hospital Type and how many of those hospitals have no data in the patient survey table.
SELECT h.`Hospital Type`, COUNT(*) AS hospitals
FROM hospital_general_information AS h
LEFT JOIN hcahps_hospital AS s
ON h.`Facility ID` = s.`Facility ID`
WHERE h.`State`= 'MO'
AND s.`Facility ID` IS NULL
GROUP BY h.`Hospital Type`;




-- Checkpoint: mixed questions


-- C1: Names of Missouri hospitals with a 5-star rating for cleanliness.
SELECT s.`Facility Name`
FROM hcahps_hospital AS s
WHERE s.`State` = 'MO'
AND s.`HCAHPS Measure ID` = 'H_CLEAN_STAR_RATING'
AND s.`Patient Survey Star Rating` = '5';


-- C2: How many Critical Access Hospitals are in each state? Most first.
SELECT h.`State`, COUNT(*) AS hospitals
FROM hospital_general_information AS h
WHERE h.`Hospital Type` = 'Critical Access Hospitals'
GROUP BY h.`State`
ORDER BY hospitals DESC;


-- C3: For Missouri, show each hospital's name, ownership, and heart failure readmission score.
SELECT h.`Facility Name`, h.`Hospital Ownership`, u.`Score`
FROM hospital_general_information AS h
INNER JOIN unplanned_hospital_visits_hospital AS u
ON h.`Facility ID` = u.`Facility ID`
WHERE h.`State` = 'MO'
AND u.`Measure ID` = 'READM_30_HF';


-- C4: How many children's hospitals nationwide have no data in the unplanned visits table?
SELECT COUNT(*)
FROM hospital_general_information AS h
LEFT JOIN unplanned_hospital_visits_hospital AS u
ON h.`Facility ID` = u.`Facility ID`
WHERE h.`Hospital Type` = 'Childrens'
AND u.`Facility ID` IS NULL;


-- C5: For Missouri, how many hospitals got each summary star rating? Ratings in order.
SELECT s.`Patient Survey Star Rating` AS rating, COUNT(*) AS hospitals
FROM hcahps_hospital AS s
WHERE s.`State` = 'MO'
AND s.`HCAHPS Measure ID` = 'H_STAR_RATING'
GROUP BY rating
ORDER BY rating;


-- Subquery Drills

-- Sub-drill 1:Which Missouri hospitals have a cleanliness linear score above the Missouri average?
SELECT s.`Facility Name`, s.`HCAHPS Linear Mean Value` AS clean_score
FROM hcahps_hospital AS s
WHERE s.`State` = 'MO'
AND `HCAHPS Measure ID` = 'H_CLEAN_LINEAR_SCORE'
AND s.`HCAHPS Linear Mean Value` > (
    SELECT AVG(`HCAHPS Linear Mean Value`) AS avg_clean_score
    FROM hcahps_hospital AS s2
    WHERE s2.`State` = 'MO'
    AND s2.`HCAHPS Measure ID` = 'H_CLEAN_LINEAR_SCORE'
    AND s2.`HCAHPS Linear Mean Value` <> 'Not Available'
)
ORDER BY s.`HCAHPS Linear Mean Value` DESC;


-- Sub-drill 2: Name and Hospital Type of Missouri hospitals with a 5-star summary rating.
SELECT h.`Facility Name`, h.`Hospital Type`
FROM hospital_general_information AS h
WHERE h.`Facility ID` IN (
    SELECT s.`Facility ID`
    FROM hcahps_hospital AS s
    WHERE s.`State` = 'MO'
    AND s.`HCAHPS Measure ID` = 'H_STAR_RATING'
    AND s.`Patient Survey Star Rating` = '5'
);

-- Sub-drill 3:Show the name and Hospital Type of Missouri hospitals that have no data in the patient survey table.
SELECT h.`Facility Name`, h.`Hospital Type`
FROM hospital_general_information AS h
WHERE h.`State` = 'MO'
AND h.`Facility ID` NOT IN (
SELECT s.`Facility ID` 
FROM hcahps_hospital AS s
);






