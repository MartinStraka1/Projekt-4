WITH
  -- 1) Spočítáme průměrnou mzdu pro každé odvětví a rok
  mzda_rocne AS (
    SELECT
      odvetvi,                    -- kód nebo název odvětví
      rok,                        -- rok
      AVG(plat)   AS prumerna_mzda  -- průměrná mzda napříč všemi potravinami
    FROM data_academy_content.t_martin_straka_project_SQL_primary_final
    GROUP BY
      odvetvi,
      rok
  ),

  -- 2) Přidáme hodnotu mzdy z předchozího roku pro stejné odvětví
  mzda_s_predchozim_rokem AS (
    SELECT
      odvetvi,                                  -- odvětví
      rok,                                      -- aktuální rok
      prumerna_mzda,                            -- průměrná mzda za aktuální rok
      LAG(prumerna_mzda)                       -- funkce LAG bere hodnotu z minulého řádku
        OVER (PARTITION BY odvetvi ORDER BY rok) 
        AS mzda_predchozi_rok                  -- průměrná mzda v předchozím roce
    FROM mzda_rocne
  )

-- 3) Vybereme jen ty řádky, kde mzda klesla (aktuální < předchozí)
SELECT
  odvetvi, 
  rok, 
  mzda_predchozi_rok      AS mzda_v_minulem_roce,  -- průměrná mzda minulý rok
  prumerna_mzda           AS mzda_za_dany_rok,     -- průměrná mzda tento rok
  (prumerna_mzda - mzda_predchozi_rok) 
    AS absolutni_zmena     -- rozdíl mezi letošní a loňskou mzdou
FROM mzda_s_predchozim_rokem
WHERE
  mzda_predchozi_rok IS NOT NULL  -- vynecháme první rok, kde není předchozí hodnota
  AND prumerna_mzda < mzda_predchozi_rok  -- filtr pro meziroční pokles mzdy
ORDER BY
  odvetvi,  -- seřadíme podle odvětví
  rok;      -- a poté podle roku
