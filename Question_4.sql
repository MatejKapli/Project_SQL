--4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

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
    ((pr1.avg_price - pr2.avg_price) / NULLIF(pr2.avg_price, 0)) * 100 AS price_increase
FROM yearly_payroll p1
JOIN yearly_payroll p2 ON p1.year = p2.year + 1
JOIN yearly_price pr1 ON pr1.year = p1.year
JOIN yearly_price pr2 ON pr2.year = p2.year
ORDER BY p1.year;






























