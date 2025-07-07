--2.Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
-- First year where I can find prices for Milk and a bread and also average payroll is 2006 and last date is 2018 therefore these years are used for the analysis.

WITH 
price_milk_2018 AS (
    SELECT AVG(average_price) AS avg_price_2018
    FROM t_matej_kaplan_project_sql_primary_final
    WHERE food_category = 'Mléko polotučné pasterované' AND year = '2018'
),
price_milk_2006 AS (
    SELECT AVG(average_price) AS avg_price_2006
    FROM t_matej_kaplan_project_sql_primary_final
    WHERE food_category = 'Mléko polotučné pasterované' AND year = '2006'
),
price_bread_2006 AS (
    SELECT AVG(average_price) AS avg_price_2006
    FROM t_matej_kaplan_project_sql_primary_final
    WHERE food_category = 'Chléb konzumní kmínový' AND year = '2006'
),
payroll_2006 AS (
    SELECT AVG(average_payroll) AS avg_payroll_2006
    FROM t_matej_kaplan_project_sql_primary_final
    WHERE average_payroll IS NOT NULL AND year = '2006'
),
price_bread_2018 AS (
    SELECT AVG(average_price) AS avg_price_2018
    FROM t_matej_kaplan_project_sql_primary_final
    WHERE food_category = 'Chléb konzumní kmínový' AND year = '2018'
),
payroll_2018 AS (
    SELECT AVG(average_payroll) AS avg_payroll_2018
    FROM t_matej_kaplan_project_sql_primary_final
    WHERE average_payroll IS NOT NULL AND year = '2018'
)
SELECT 
    ROUND((pay2006.avg_payroll_2006 / prc2006.avg_price_2006)::numeric, 0) AS ratio_bread_2006,
    ROUND((pay2018.avg_payroll_2018 / prc2018.avg_price_2018)::numeric, 0) AS ratio_bread_2018,
    ROUND((pay2006.avg_payroll_2006 / prcm2006.avg_price_2006)::numeric, 0) AS ratio_milk_2006,
    ROUND((pay2018.avg_payroll_2018 / prcm2018.avg_price_2018)::numeric, 0) AS ratio_milk_2018
FROM 
    price_milk_2018 prcm2018,
    price_milk_2006 prcm2006,
    price_bread_2006 prc2006,
    payroll_2006 pay2006,
    price_bread_2018 prc2018,
    payroll_2018 pay2018;


