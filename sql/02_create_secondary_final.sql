-- Vytvoříme novou tabulku t_martin_straka_project_SQL_secondary_final
CREATE TABLE data_academy_content.t_martin_straka_project_SQL_secondary_final AS
-- Vybereme makroekonomická data pro evropské státy mimo ČR
SELECT
    e.year AS rok,
    -- rok, pro který jsou data
    e.country AS nazev_zeme,
    -- název země z tabulky economies
    c.abbreviation AS kod_zeme,
    -- ISO kód země ze seznamu countries
    c.population AS populace,
    -- populace ze seznamu countries
    e.gdp AS gdp,
    -- HDP země
    e.gini AS gini
    -- GINI koeficient nerovnosti
FROM
    data_academy_content.economies AS e
    -- spojíme s tabulkou countries podle názvu země
JOIN data_academy_content.countries AS c
    ON
    e.country = c.country
WHERE
    c.continent = 'Europe'
    -- omezíme jen na evropské státy
    AND c.country <> 'Czech Republic'
    -- vyjmeme ČR, ta je v primární tabulce
ORDER BY
    e.year,
    -- seřadíme podle roku
    c.country;
-- a podle názvu země
