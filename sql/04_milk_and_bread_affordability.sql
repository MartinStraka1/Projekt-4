WITH
-- 1) Vybereme pro každé odvětví a rok údaje o mzdě a ceně pro dvě vybrané potraviny
  DATA AS (
SELECT
      odvetvi,
    -- název odvětví
    potravina,
    -- název potraviny (mléko nebo chléb)
    rok,
    -- rok
    plat,
    -- průměrná mzda v daném odvětví a roce
    prumerna_cena
    -- průměrná cena potraviny v daném roce
FROM
    data_academy_content.t_martin_straka_project_SQL_primary_final
WHERE
    potravina IN (
      'Mléko polotučné pasterované',
      'Chléb konzumní kmínový'
    )
  ),
-- 2) Určíme pro každé odvětví+potravina první a poslední dostupný rok
first_last AS (
SELECT
      odvetvi,
      potravina,
      MIN(rok) AS first_year,
    -- nejstarší rok v datech
    MAX(rok) AS last_year
    -- nejnovější rok v datech
FROM
    DATA
GROUP BY
      odvetvi,
      potravina
  )
-- 3) Spojíme to dohromady a spočítáme, kolik litrů/kg potraviny si koupíte
SELECT
    f.odvetvi,
    f.potravina,
    f.first_year AS rok_prvni,
    -- rok první srovnatelné hodnoty
    ROUND(d1.plat / d1.prumerna_cena, 2) AS mnozstvi_prvni,
    -- litr/kg za průměrnou mzdu v prvním roce
    f.last_year AS rok_posledni,
    -- rok poslední srovnatelné hodnoty
    ROUND(d2.plat / d2.prumerna_cena, 2) AS mnozstvi_posledni
    -- litr/kg za průměrnou mzdu v posledním roce
FROM
    first_last AS f
JOIN DATA AS d1
    ON
    d1.odvetvi = f.odvetvi
    AND d1.potravina = f.potravina
    AND d1.rok = f.first_year
JOIN DATA AS d2
    ON
    d2.odvetvi = f.odvetvi
    AND d2.potravina = f.potravina
    AND d2.rok = f.last_year
ORDER BY
    f.odvetvi,
    f.potravina;
-- výsledky setřídíme podle odvětví a názvu potraviny
