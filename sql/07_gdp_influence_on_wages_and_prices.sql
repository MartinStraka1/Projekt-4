
WITH
  -- 1) Meziroční procentní růst HDP České republiky
  gdp_growth AS (
    SELECT
      year AS rok,                                        -- rok
      ROUND(
        (
          (gdp 
           - LAG(gdp) OVER (ORDER BY year))               -- rozdíl oproti předchozímu roku
          / NULLIF(LAG(gdp) OVER (ORDER BY year), 0)      -- dělení předchozí hodnotou (ochrana proti dělení nulou)
          * 100                                          -- převod na procenta
        )::numeric
      , 2) AS procent_rust_hdp                            -- % růst HDP
    FROM data_academy_content.economies
    WHERE country = 'Czech Republic'                      -- vybereme jen ČR
  ),

  -- 2) Meziroční procentní růst průměrné mzdy napříč všemi odvětvími
  wage_growth AS (
    SELECT
      rok,                                                -- rok
      ROUND(
        (
          (AVG(plat) 
           - LAG(AVG(plat)) OVER (ORDER BY rok))          -- rozdíl průměrné mzdy oproti předchozímu roku
          / NULLIF(LAG(AVG(plat)) OVER (ORDER BY rok), 0)  -- dělení průměrné mzdy z předchozího roku
          * 100
        )::numeric
      , 2) AS procent_rust_mzdy                           -- % růst mzdy
    FROM data_academy_content.t_martin_straka_project_SQL_primary_final
    GROUP BY rok                                          -- agregace na úroveň roku
  ),

  -- 3) Meziroční procentní růst průměrné ceny potravin
  price_growth AS (
    SELECT
      rok,                                                -- rok
      ROUND(
        (
          (AVG(prumerna_cena) 
           - LAG(AVG(prumerna_cena)) OVER (ORDER BY rok)) -- rozdíl průměrné ceny oproti předchozímu roku
          / NULLIF(LAG(AVG(prumerna_cena)) OVER (ORDER BY rok), 0) -- dělení průměrné ceny z předchozího roku
          * 100
        )::numeric
      , 2) AS procent_rust_cen                            -- % růst cen
    FROM data_academy_content.t_martin_straka_project_SQL_primary_final
    GROUP BY rok                                          -- agregace na úroveň roku
  )

-- 4) Spojíme všechny tři časové řady a vybereme jen roky, kde máme úplná data pro mzdy i ceny
SELECT
  g.rok                            AS rok,               -- rok
  g.procent_rust_hdp               AS procent_rust_hdp,   -- % růst HDP
  w.procent_rust_mzdy              AS procent_rust_mzdy,  -- % růst mzdy
  p.procent_rust_cen               AS procent_rust_cen    -- % růst cen
FROM gdp_growth g
LEFT JOIN wage_growth w USING(rok)                      -- přidáme růst mezd
LEFT JOIN price_growth p USING(rok)                     -- přidáme růst cen
WHERE
  w.procent_rust_mzdy IS NOT NULL                       -- jen roky s vypočteným růstem mezd
  AND p.procent_rust_cen IS NOT NULL                    -- jen roky s vypočteným růstem cen
ORDER BY 
  g.procent_rust_hdp DESC;                              -- seřadíme od největšího růstu HDP
