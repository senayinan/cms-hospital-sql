# CMS Hospitals SQL Practice

SQL practice using public hospital quality data from the Centers for Medicare & Medicaid Services (CMS), written in MySQL. The queries focus on Missouri hospitals and national comparisons: readmission rates, patient survey results, and hospitals with missing data.

## Data

Source: [CMS Provider Data Catalog – Hospitals](https://data.cms.gov/provider-data/topics/hospitals)

| Table | Contents | Rows |
|---|---|---|
| `hospital_general_information` | One row per hospital: name, location, type, ownership, overall rating | 5,419 |
| `unplanned_hospital_visits_hospital` | 14 measures per hospital: 30-day readmissions, excess days in acute care, outpatient visits | 67,060 |
| `hcahps_hospital` | 68 patient survey items per hospital (HCAHPS): communication, cleanliness, quietness, star ratings | 325,720 |

The tables are linked by `Facility ID`. The CSV files are not included in this repository; they can be downloaded from the link above.

## Files

- **`cms_hospitals_practice.sql`**: main questions (JOINs, aggregation, patient survey data, subqueries)
- **`cms_hospitals_drills.sql`**: shorter practice queries, a checkpoint set, subquery drills, and CTE drills

## SQL covered

- Filtering with `WHERE`, `IN`, `LIKE`, `<>`
- `INNER JOIN` and `LEFT JOIN` (including finding hospitals with no matching data using `IS NULL`)
- Aggregation with `COUNT`, `AVG`, `GROUP BY`, `ORDER BY`
- Subqueries returning a single value and a list (`IN`, `NOT IN`)
- Common Table Expressions (CTEs), including queries with two CTEs

## Data quality notes

Working with the raw CMS files surfaced several issues that affect results:

- **Incomplete imports.** MySQL Workbench's Table Data Import Wizard silently skipped rows. It loaded 2,917 of 5,419 hospitals into the general information table and 49,848 of 325,720 rows into the patient survey table. The cause was numeric column types meeting text values such as `Not Available`. Both tables were reloaded with `LOAD DATA` with every column as `TEXT`, and row counts were checked against the source files.
- **Missing values are text, not NULL.** CMS writes `Not Available` or `Not Applicable` in place of missing numbers. MySQL treats these as 0 in calculations, so they are excluded before any average or comparison.
- **Text comparisons.** Because ratings are stored as text, `>= '4'` also matches `Not Available`. Queries use `IN ('4', '5')` instead.
- **Measures without data.** The hospital-wide readmission measure (`Hybrid_HWR`) is `Not Available` for all 4,790 hospitals in this release, so it is not used.
- **Survey value columns.** Patient survey results are stored in different columns depending on the item: percentages, linear scores, and star ratings each have their own column.

## Example findings

- 629 of the 5,419 hospitals in the general information table have no unplanned visits data.
- The national average 30-day pneumonia readmission rate (`READM_30_PN`) is about 17.3%.
- The Missouri average 30-day heart failure readmission rate (`READM_30_HF`) is about 21.6%.

## Tools

MySQL 8.4, MySQL Workbench

## About

I'm a former pediatric nurse (10 years in endocrinology and gastroenterology, including a supervisory role) with a master's degree in Hospital and Healthcare Facilities Management. I built this project while moving into health data analytics, using the kind of hospital quality data I worked alongside in clinical practice. Next step: building dashboards from this data in Power BI.
