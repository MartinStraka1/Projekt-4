WITH
  -- 1) Roční průměrná cena potravin
  prumer_ceny_rocne AS (
    SELECT
      rok,
      AVG(prumerna_cena) AS prumerna_cena_rok
    FROM data_academy_content.t_martin_straka_project_SQL_primary_final
    GROUP BY rok
  ),

  -- 2) Roční průměrná mzda
  prumer_mzdy_rocne AS (
    SELECT
      rok,
      AVG(plat) AS prumerna_mzda_rok
    FROM data_academy_content.t_martin_straka_project_SQL_primary_final
    GROUP BY rok
  ),

  -- 3) Výpočet meziročního % růstu cen a mezd + jejich rozdíl
  vyvoj_rust AS (
    SELECT
      c.rok,

      -- procentuální meziroční růst cen
      ROUND(
        (
          c.prumerna_cena_rok
          - LAG(c.prumerna_cena_rok) OVER (ORDER BY c.rok)
        )
        / NULLIF(LAG(c.prumerna_cena_rok) OVER (ORDER BY c.rok), 0) * 100
      , 2) AS rust_cen_pct,

      -- procentuální meziroční růst mezd
      ROUND(
        (
          m.prumerna_mzda_rok
          - LAG(m.prumerna_mzda_rok) OVER (ORDER BY m.rok)
        )
        / NULLIF(LAG(m.prumerna_mzda_rok) OVER (ORDER BY m.rok), 0) * 100
      , 2) AS rust_mzd_pct,

      -- rozdíl procentuálních růstů (cena minus mzda)
      ROUND(
        (
          (c.prumerna_cena_rok 
           - LAG(c.prumerna_cena_rok) OVER (ORDER BY c.rok))
          / NULLIF(LAG(c.prumerna_cena_rok) OVER (ORDER BY c.rok), 0) * 100
        )
        -
        (
          (m.prumerna_mzda_rok 
           - LAG(m.prumerna_mzda_rok) OVER (ORDER BY m.rok))
          / NULLIF(LAG(m.prumerna_mzda_rok) OVER (ORDER BY m.rok), 0) * 100
        )
      , 2) AS rozdil_rust_cen_mzd
    FROM prumer_ceny_rocne c
    JOIN prumer_mzdy_rocne m USING(rok)
  )

-- 4) Vybereme ty roky, kde cenový růst převýšil růst mezd o více než 10 %
SELECT
  rok                                    AS rok,
  rust_cen_pct                           AS procent_rust_cen,
  rust_mzd_pct                           AS procent_rust_mzd,
  rozdil_rust_cen_mzd                    AS rozdil_proc_cena_minus_mzda
FROM vyvoj_rust
WHERE rozdil_rust_cen_mzd > 10           -- filtrujeme jen roky s cenami rostoucími >10 % nad mzdy
ORDER BY rok;

-- POZNÁMKA:
-- V aktuálních datech tento dotaz nevrátí žádný řádek,
-- což znamená, že v žádném roce cenový růst
-- nepřevýšil růst mezd o více než 10 %.
