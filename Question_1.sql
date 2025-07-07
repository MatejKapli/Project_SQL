--1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

select industry_name, year, avg(average_payroll) as average_salary from t_matej_kaplan_project_sql_primary_final


WITH wage_diff AS (
    SELECT 
        f1.Industry_name,
        f1.year AS current_year,
        f2.year AS prev_year,
        f1.average_payroll AS current_payroll,
        f2.average_payroll AS prev_payroll,
        f1.average_payroll - f2.average_payroll AS payroll_change
    FROM t_matej_kaplan_project_sql_primary_final f1
    JOIN t_matej_kaplan_project_sql_primary_final f2
      ON f1.Industry_name = f2.Industry_name
     AND f1.year = f2.year + 1
),
trend_summary AS (
    SELECT 
        Industry_name,
        COUNT(*) FILTER (WHERE payroll_change > 0) AS increases,
        COUNT(*) FILTER (WHERE payroll_change < 0) AS decreases
    FROM wage_diff
    GROUP BY Industry_name
)
SELECT 
    Industry_name,
    increases,
    decreases,
    CASE 
        WHEN decreases = 0 THEN 'Rising'
        WHEN increases = 0 THEN 'Falling'
        ELSE 'Mixed'
    END AS trend
FROM trend_summary
ORDER BY Industry_name;