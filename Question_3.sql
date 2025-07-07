--3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
-- The analysis is carried out from 2006 to 2017 as these are available.

WITH year_diff AS (
    SELECT 
        f1.food_category,
        f1.year AS year_current,
        f2.year AS year_prev,
        f1.average_price AS price_current,
        f2.average_price AS price_prev,
        ((f1.average_price - f2.average_price) / NULLIF(f2.average_price, 0)) * 100 AS pct_increase
    FROM t_matej_kaplan_project_sql_primary_final f1
    JOIN t_matej_kaplan_project_sql_primary_final f2 
      ON f1.food_category = f2.food_category 
     AND f1.year = f2.year + 1
),
avg_pct_increase AS (
    SELECT 
        food_category,
        AVG(pct_increase) AS avg_pct_increase
    FROM year_diff
    GROUP BY food_category
)
select
    food_category,
    avg_pct_increase
FROM avg_pct_increase
ORDER BY avg_pct_increase
limit 1;
		


