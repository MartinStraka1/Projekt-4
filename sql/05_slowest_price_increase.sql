WITH cenovy_vyvoj AS (
  -- 1) Vypočítáme pro každou kategorii potravin a rok
  --    průměrnou cenu a cenu z předchozího roku
  SELECT DISTINCT
    potravina,                                           -- název potraviny
    rok,                                                 -- rok
    prumerna_cena,                                       -- průměrná cena v daném roce
    LAG(prumerna_cena) OVER (PARTITION BY potravina
                              ORDER BY rok)            -- cena minulý rok
      AS cena_minuly_rok
  FROM data_academy_content.t_martin_straka_project_SQL_primary_final
)

-- 2) Vybereme jen kategorie, kde cena **rostla** a spočítáme % změnu
SELECT
  potravina,                                            -- název potraviny
  rok,                                                  -- rok, kdy došlo k růstu
  ROUND(
    (prumerna_cena - cena_minuly_rok)                   -- absolutní rozdíl
    / NULLIF(cena_minuly_rok, 0) * 100                   -- přepočet na procenta
  , 2) AS pct_zmena                                      -- meziroční % změna
FROM cenovy_vyvoj
WHERE
  cena_minuly_rok IS NOT NULL                           -- vynecháme první rok
  AND prumerna_cena > cena_minuly_rok                    -- pouze kategorie se zdražením
ORDER BY
  pct_zmena ASC                                          -- od nejpomalejšího růstu
LIMIT 1;                                                 -- jen ta jedna nejpomalejší
