# Food and Payroll Analysis – SQL Project

## 🧠 Project Overview

This project analyzes the accessibility of basic food items in the Czech Republic over time using publicly available datasets. The goal is to assess trends in wages and food prices and explore how economic indicators (like GDP and GINI coefficient) relate to these trends. The final results support research presented at a public conference.

## 🔍 Research Questions

1. Do wages grow over the years in all industries, or do some decline?
2. How many liters of milk and kilograms of bread could be bought for the average wage in the first and last available years?
3. Which food category has the slowest price increase (lowest year-on-year percentage growth)?
4. Is there a year when food prices grew more than 10% faster than wages?
5. Does GDP growth influence changes in wages and food prices?

## 🗂️ Datasets Used

### Czech Republic
- `czechia_payroll` – Wage data by industry
- `czechia_price` – Food price data
- `czechia_price_category`, `czechia_payroll_industry_branch`, etc. – Lookup tables
- `czechia_region`, `czechia_district` – Regional references

### Europe (International)
- `countries` – Metadata about countries
- `economies` – GDP, GINI coefficient, tax burden, etc.

## 🏗️ Table: `t_Matej_Kaplan_project_SQL_primary_final`

This table consolidates average food prices, average payrolls, and economic indicators (GDP per capita and GINI index) in the Czech Republic, grouped by year, region, and category/industry.

### ✅ Source Tables Used

- `czechia_price` – Food item prices
- `czechia_price_category` – Food category names
- `czechia_region` – Region names
- `czechia_payroll` – Industry-level payroll data
- `czechia_payroll_industry_branch` – Industry name lookup
- `economies` – GDP, GINI coefficient, and population by country and year

### 🧮 Table Structure

| Column             | Description                                               |
|--------------------|-----------------------------------------------------------|
| `year`             | Year of the data (from food prices or payroll)            |
| `category_code`    | Code of the food price category                           |
| `region_code`      | Region code (NUTS2)                                       |
| `food_category`    | Name of the food item                                     |
| `region`           | Name of the region                                        |
| `industry_branch_code` | Industry code from payroll                             |
| `industry_name`    | Name of the industry                                      |
| `average_price`    | Average food price per category, region, and year         |
| `average_payroll`  | Average payroll per industry and year                     |
| `gini`             | GINI coefficient for Czech Republic in that year          |
| `gdp_per_capita`   | GDP per capita (GDP / population)                         |

### 🔄 Data Processing Logic

1. **Food Prices (`fp`)**:
   - Aggregates average food prices by year, category, and region.
   - Uses `DATE_PART('year', cp.date_from)` to extract the year.
   - Joins category and region names for readability.

2. **Payroll (`pr`)**:
   - Aggregates average payrolls by year and industry.
   - Filters by `value_type_code = '5958'` to ensure consistent payroll metric.
   - Converts `payroll_year` to a date to extract the year.
   - Rounds payroll values to 2 decimal places.

3. **Join Logic**:
   - `FULL OUTER JOIN` merges food prices and payrolls by year and a common code.
   - Uses `COALESCE(fp.year, pr.year)` to handle years that may appear in only one of the sources.
   - Joins `economies` to append GDP and GINI data for Czech Republic by year.

4. **GDP per Capita Calculation**:
   - `gdp / NULLIF(population, 0)` safely computes GDP per capita, avoiding division by zero.

### ⚠️ Notes

- `FULL OUTER JOIN` ensures that data from both sources is included even if a matching entry is missing in one.
- The condition `fp.category_code::text = pr.industry_branch_code` assumes that food categories and industries can be compared by matching codes as strings. This may be adjusted based on actual business logic if necessary.
- The table is ordered chronologically by year.


## 🏗️ Table: `t_Matej_Kaplan_project_SQL_secondary_final`

This table merges economic data with country metadata to provide a comprehensive dataset for cross-country analysis, including key economic indicators and country attributes.

### 🗂️ Source Tables Description

| Table       | Description                                                                 |
|-------------|-----------------------------------------------------------------------------|
| `economies` | Contains economic indicators such as GDP, population, GINI coefficient, and tax data, by country and year. |
| `countries` | Contains country-level metadata including capital city, currency name, and continent. |

### 📋 Selected Columns in Final Table

| Column Name     | Source     | Description                                    |
|-----------------|------------|------------------------------------------------|
| country         | economies  | Country name (join key)                        |
| year            | economies  | Year of the economic data                      |
| gdp             | economies  | Gross Domestic Product                         |
| population      | economies  | Total population                               |
| gini            | economies  | GINI coefficient (income inequality measure) |
| taxes           | economies  | Tax data                                       |
| capital_city    | countries  | Capital city of the country                    |
| currency_name   | countries  | Official currency name                         |
| continent       | countries  | Continent where the country is located        |
| gdp_per_capita  | derived    | GDP divided by population (calculated field)  |

### 🔄 Data Processing Logic
- The table is created by performing a **FULL JOIN** on the `country` column between `economies` and `countries`.
- The column `gdp_per_capita` is calculated as **GDP divided by population**, using a safe division with `NULLIF` to avoid division by zero.
- This table has not been used for answering resarch questions as the data were irelevant.

## 📝 Data Notes

- Some missing values in `czechia_price` for year XXXX were excluded.
- Wages and prices were aligned by filtering for overlapping years only.
- All transformations were applied only in the final result tables; no primary data was altered.

- 
