# Projekt SQL – Dostupnost potravin a mzdy v ČR

## 1) Zadání a cíl projektu
Cílem je připravit datové podklady a odpovědět na sadu výzkumných otázek, které zkoumají vztah mezi mzdami, cenami základních potravin a makroekonomickými ukazateli (HDP, GINI, populace).  
Výstupem jsou dvě konsolidované tabulky (primární + sekundární) a sady SQL dotazů k jednotlivým otázkám.

### Datové zdroje
Schéma: `data_academy_content`  
- **czechia_payroll**, **czechia_payroll_value_type**, **czechia_payroll_industry_branch**  
- **czechia_price**, **czechia_price_category**  
- **economies**, **countries**

---

## 2) Jak jsem tvořil tabulky

### 2.1 Primární tabulka (ČR)  
Soubor: `sql/01_create_primary_final.sql`  
Popis:
- Agregace **průměrné ceny** potravin po letech (`price_yearly`).
- Agregace **průměrné mzdy** po letech a odvětvích (`payroll_yearly`), pouze `value_type_code = 5958`.
- Join na číselníky odvětví a kategorií potravin → finální tabulka:
  - `rok`, `odvetvi`, `plat`, `potravina`, `prumerna_cena`.

### 2.2 Sekundární tabulka (Evropa)
Soubor: `sql/02_create_secondary_final.sql`  
Popis:
- Join `economies` × `countries` (pro název a kód země).
- Filtrováno na **kontinent Europe** a **mimo Czech Republic**.
- Sloupce: `rok`, `nazev_zeme`, `kod_zeme`, `populace`, `gdp`, `gini`.

---

## 3) Výzkumné otázky a použitá SQL

> Skripty jsou ve složce `sql/` a spouští se na tabulkách výše.

1. **Kde mzdy meziročně klesaly?**  
   Soubor: `03_wage_drop.sql`  
   - Vypočet průměrné mzdy po odvětví a roce + `LAG` proti předchozímu roku, filtr na pokles.
   - Shrnutí:
Dlouhodobý trend mezd je růstový ve většině odvětví. Meziroční poklesy se ale v několika letech a odvětvích vyskytují – typicky v obdobích ekonomického zpomalení. Poklesy jsou spíše krátkodobé výkyvy, po nichž se odvětví obvykle vrací na růstovou trajektorii.

2. **Kolik litrů mléka / kg chleba za mzdu (první a poslední rok)?**  
   Soubor: `04_milk_and_bread_affordability.sql`  
   - Pro vybrané položky („Mléko polotučné pasterované“, „Chléb konzumní kmínový“), poměr `plat / prumerna_cena` v prvním a posledním dostupném roce (po odvětvích).
   - Shrnutí:
Chléb (kg za průměrnou mzdu)
2006 (první rok): průměr napříč odvětvími ≈ 1 287 kg (medián 1 147 kg; rozpětí 707–2 462 kg)
2018 (poslední rok): průměr ≈ 1 342 kg (medián 1 213 kg; rozpětí 774–2 314 kg)
Změna: +4,3 % (≈ +55 kg)

Mléko (l za průměrnou mzdu)
2006 (první rok): průměr ≈ 1 437 l (medián 1 280 l; rozpětí 789–2 749 l)
2018 (poslední rok): průměr ≈ 1 642 l (medián 1 484 l; rozpětí 947–2 831 l)
Změna: +14,2 % (≈ +204 l)

3. **Nejpomaleji zdražující potravina (kladný meziroční růst nejnižší)?**  
   Soubor: `05_slowest_price_increase.sql`  
   - `LAG(prumerna_cena)` po potravině, výpočet % změny, filtr na růst a `ORDER BY pct_zmena ASC LIMIT 1`.
   - Shrnutí:
Nejpomaleji zdražující položkou je Rostlinný roztíratelný tuk v roce 2009, kde meziroční růst průměrné ceny činil pouze +0,01 % (prakticky stabilní cena oproti roku 2008).

4. **Roky, kdy ceny rostly > 10 % nad mzdy?**  
   Soubor: `06_price_growth_exceeds_wage_growth.sql`  
   - Meziroční % růst **průměrné ceny** a **průměrné mzdy** (agregace za všechny položky), rozdíl (cena − mzda) > 10 p. b.  
   - *Pozn.: V aktuálních datech dotaz vrací prázdnou množinu (nenastal takový rok).*
   - Shrnutí:
V dostupném období jsme nenašli rok, kdy by cenový růst převyšoval růst mezd o více než 10 p. b. Cenový vývoj byl sice v některých letech rychlejší než mzdový, ale rozdíl nedosáhl uvedené hranice.

5. **Vliv HDP na mzdy a ceny (přehled růstů)**  
   Soubor: `07_gdp_influence_on_wages_and_prices.sql`  
   - Meziroční % růst **HDP** (ČR), **mezd** a **cen**; spojení podle roku, seřazení podle růstu HDP.
   - Shrnutí:
Mezi růstem HDP a růstem mezd pozorujeme zřetelný pozitivní vztah: v letech vyššího růstu HDP mzdy typicky rostou rychleji, v letech zpomalení/poklesu HDP růst mezd slábne. Vztah mezi HDP a cenami potravin je volnější – ceny reagují i na další faktory (např. komoditní ceny, kurz, regulace).

---

## 4) Jak spustit
1. Spusť `01_create_primary_final.sql` → vytvoří primární tabulku.  
2. Spusť `02_create_secondary_final.sql` → vytvoří sekundární tabulku.  
3. Spouštěj dotazy `03`–`07` podle otázky; výsledky jsou buď výpisy řádků, nebo (u Q4) prázdný výsledek.

---

## 5) Poznámky k formátu a stylu SQL
- Klíčová slova UPPERCASE (`SELECT`, `FROM`, …), aliasy a názvy sloupců `snake_case`.  
- Odsazení **4 mezery**, každý výraz/součet/CASE na vlastní řádek.  
- `JOIN` a `ON` na samostatných řádcích, složené výrazy s `LAG/ROUND` zarovnány do bloků.  
- Komentáře `--` v češtině popisují účel každého kroku.
