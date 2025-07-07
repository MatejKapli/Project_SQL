CREATE TABLE t_Matej_Kaplan_project_SQL_secondary_final AS
SELECT 
    e.country,
    e.year,
    e.gdp,
    e.population,
    e.gini,
    e.taxes,
    c.capital_city,
    c.currency_name,
    c.continent,
    -- Add other columns from countries as needed
     e.gdp / NULLIF(e.population, 0) AS gdp_per_capita
FROM economies e
FULL JOIN countries c
  ON e.country = c.country;