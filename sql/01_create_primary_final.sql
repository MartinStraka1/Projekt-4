-- Vytvoříme novou tabulku s názvem t_martin_straka_project_SQL_primary_final
CREATE TABLE data_academy_content.t_martin_straka_project_SQL_primary_final AS
-- 1) Definice CTE pro roční průměrné ceny potravin
WITH
  price_yearly AS (
SELECT
      category_code,
    -- kód potravinové kategorie
      EXTRACT(YEAR FROM date_from) AS rok,
    -- rok z data (date_from)
    AVG(value) AS prumerna_cena
    -- průměrná cena v daném roce
FROM
    data_academy_content.czechia_price
GROUP BY
      category_code,
      EXTRACT(YEAR FROM date_from)
  ),
-- 2) Definice CTE pro roční průměrné mzdy podle odvětví
payroll_yearly AS (
SELECT
      payroll_year AS rok,
    -- rok výplaty
    industry_branch_code AS industry_code,
    -- kód odvětví
    AVG(value) AS prumerna_mzda
    -- průměrná mzda v daném roce a odvětví
FROM
    data_academy_content.czechia_payroll
WHERE
    value_type_code = 5958
    -- filtrujeme jen platy (kód 5958)
GROUP BY
      payroll_year,
      industry_branch_code
  )
-- 3) Hlavní výběr: spojíme mzdy s cenami a názvy kategorií
SELECT
    pr.rok AS rok,
    -- rok
    ib.name AS odvetvi,
    -- název odvětví
    ROUND(pr.prumerna_mzda::NUMERIC, 2) AS plat,
    -- průměrná mzda zaokrouhlená na 2 deset. místa
    pc.name AS potravina,
    -- název potravinové kategorie
    ROUND(py.prumerna_cena::NUMERIC, 2) AS prumerna_cena
    -- průměrná cena zaokrouhlená na 2 deset. místa
FROM
    payroll_yearly AS pr
    -- připojíme názvy odvětví
JOIN data_academy_content.czechia_payroll_industry_branch AS ib
    ON
    pr.industry_code = ib.code
    -- připojíme roční ceny potravin
JOIN price_yearly AS py
    ON
    py.rok = pr.rok
    -- připojíme názvy potravinových kategorií
JOIN data_academy_content.czechia_price_category AS pc
    ON
    py.category_code = pc.code
    -- 4) Seřadíme výsledky podle roku, odvětví a názvu potraviny
ORDER BY
    py.rok,
    ib.name,
    pc.name;
