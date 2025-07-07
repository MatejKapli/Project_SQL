
CREATE TABLE t_Matej_Kaplan_project_SQL_primary_final AS
SELECT
    COALESCE(fp.year, pr.year) AS year,
    fp.category_code,
    fp.region_code,
    fp.food AS food_category,
    fp.region,
    pr.industry_branch_code,
    pr.industry_name,
    fp.average_price,
    pr.average_payroll,
    e.gini,
    e.gdp / NULLIF(e.population, 0) AS gdp_per_capita
FROM (
    -- Food Prices
    SELECT
        DATE_PART('year', cp.date_from) AS year,
        cp.category_code,
        cp.region_code,
        cpc.name AS food,
        cr.name AS region,
        AVG(cp.value) AS average_price
    FROM czechia_price cp
    LEFT JOIN czechia_price_category cpc ON cpc.code = cp.category_code
    LEFT JOIN czechia_region cr ON cr.code = cp.region_code
    WHERE cp.region_code IS NOT NULL 
      AND cp.category_code IS NOT NULL
    GROUP BY 
        DATE_PART('year', cp.date_from), 
        cp.category_code, 
        cp.region_code,
        cpc.name,
        cr.name
) fp
FULL OUTER JOIN (
    -- Payroll
    SELECT
        DATE_PART('year', TO_DATE(payroll_year::text, 'YYYY')) AS year,
        industry_branch_code,
        ROUND(AVG(value), 2) AS average_payroll,
        cpib.name AS industry_name
    FROM czechia_payroll c
    LEFT JOIN czechia_payroll_industry_branch cpib 
        ON cpib.code = c.industry_branch_code
    WHERE value_type_code = '5958' 
      AND industry_branch_code IS NOT NULL
    GROUP BY 
        DATE_PART('year', TO_DATE(payroll_year::text, 'YYYY')), 
        industry_branch_code,
        cpib.name
) pr
ON fp.year = pr.year
   AND fp.category_code::text = pr.industry_branch_code  -- match codes as text
LEFT JOIN economies e
   ON e.year = COALESCE(fp.year, pr.year)
  AND e.country = 'Czech Republic'
ORDER BY year;

