--Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, 
--projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

select year, avg(average_price) as avg_price, avg(average_payroll) as avg_payroll, avg(gdp_per_capita) as gdp_per_capita from t_matej_kaplan_project_sql_primary_final tmkpspf
group by year
order by year;

WITH yearly_payroll AS (
    SELECT 
        year,
        AVG(average_payroll) AS avg_payroll
    FROM t_matej_kaplan_project_sql_primary_final
    GROUP BY year
),
yearly_price AS (
    SELECT 
        year,
        AVG(average_price) AS avg_price
    FROM t_matej_kaplan_project_sql_primary_final
    GROUP BY year
),
yearly_gdp AS (
    SELECT 
        year,
        AVG(gdp_per_capita) AS avg_gdp_per_capita
    FROM t_matej_kaplan_project_sql_primary_final
    GROUP BY year
)
SELECT 
    p1.year AS current_year,
    p2.year AS prev_year,
    -- Payroll comparison
    p1.avg_payroll AS payroll_current,
    p2.avg_payroll AS payroll_prev,
    ((p1.avg_payroll - p2.avg_payroll) / NULLIF(p2.avg_payroll, 0)) * 100 AS payroll_increase,
    -- Price comparison
    pr1.avg_price AS price_current,
    pr2.avg_price AS price_prev,
    ((pr1.avg_price - pr2.avg_price) / NULLIF(pr2.avg_price, 0)) * 100 AS price_increase,
    -- GDP per capita comparison
    g1.avg_gdp_per_capita AS gdp_current,
    g2.avg_gdp_per_capita AS gdp_prev,
    ((g1.avg_gdp_per_capita - g2.avg_gdp_per_capita) / NULLIF(g2.avg_gdp_per_capita, 0)) * 100 AS gdp_increase
FROM yearly_payroll p1
JOIN yearly_payroll p2 ON p1.year = p2.year + 1
JOIN yearly_price pr1 ON pr1.year = p1.year
JOIN yearly_price pr2 ON pr2.year = p2.year
JOIN yearly_gdp g1 ON g1.year = p1.year
JOIN yearly_gdp g2 ON g2.year = p2.year
ORDER BY p1.year;


WITH yearly_payroll AS (
    SELECT 
        year,
        AVG(average_payroll) AS avg_payroll
    FROM t_matej_kaplan_project_sql_primary_final
    GROUP BY year
),
yearly_price AS (
    SELECT 
        year,
        AVG(average_price) AS avg_price
    FROM t_matej_kaplan_project_sql_primary_final
    GROUP BY year
),
yearly_gdp AS (
    SELECT 
        year,
        AVG(gdp_per_capita) AS avg_gdp_per_capita
    FROM t_matej_kaplan_project_sql_primary_final
    GROUP BY year
)
SELECT 
    p1.year AS current_year,
    p2.year AS prev_year,
    -- Payroll comparison
    p1.avg_payroll AS payroll_current,
    p2.avg_payroll AS payroll_prev,
    ((p1.avg_payroll - p2.avg_payroll) / NULLIF(p2.avg_payroll, 0)) * 100 AS payroll_increase,
    -- Price comparison
    pr1.avg_price AS price_current,
    pr2.avg_price AS price_prev,
    ((pr1.avg_price - pr2.avg_price) / NULLIF(pr2.avg_price, 0)) * 100 AS price_increase,
    -- GDP per capita comparison
    g1.avg_gdp_per_capita AS gdp_current,
    g2.avg_gdp_per_capita AS gdp_prev,
    ((g1.avg_gdp_per_capita - g2.avg_gdp_per_capita) / NULLIF(g2.avg_gdp_per_capita, 0)) * 100 AS gdp_increase
FROM yearly_payroll p1
JOIN yearly_payroll p2 ON p1.year = p2.year + 1
JOIN yearly_price pr1 ON pr1.year = p1.year
JOIN yearly_price pr2 ON pr2.year = p2.year
JOIN yearly_gdp g1 ON g1.year = p1.year
JOIN yearly_gdp g2 ON g2.year = p2.year
ORDER BY p1.year;