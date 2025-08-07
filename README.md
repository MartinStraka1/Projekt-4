# Projekt SQL – Analýza mzdových a cenových dat

## Popis projektu
Tento repozitář obsahuje SQL skripty k analýze českých dat o mzdách, cenách potravin a makroekonomických ukazatelích (HDP, GINI, populace).  

## Obsah složky `sql/`
| Soubor                                    | Co dělá                                  |
|-------------------------------------------|-------------------------------------------|
| `01_create_primary_final.sql`             | Vytvoří primární tabulku s průměrnými ročními mzdami a cenami potravin. |
| `02_create_secondary_final.sql`           | Vytvoří sekundární tabulku s makrodaty (HDP, GINI, populace) pro evropské státy mimo ČR. |
| `03_wage_decline_by_industry.sql`         | Najde odvětví, kde mzdy meziročně klesaly. |
| `04_milk_and_bread_affordability.sql`     | Vypočte, kolik litrů mléka/kg chleba si koupíte za průměrnou mzdu. |
| `05_slowest_price_increase.sql`           | Určí potravinu s nejpomalejším kladným meziročním růstem ceny. |
| `06_price_growth_exceeds_wage_growth.sql` | Najde roky, kdy cenový růst překonal růst mezd o více než 10 %. |
| `07_gdp_influence_on_wages_and_prices.sql`| Zkoumá korelaci mezi růstem HDP, mezd a cen. |

## Jak spustit
1. Připojte se v DBeaveru (nebo jiném klientu) k databázi `data_academy_content`.  
2. V adresáři `sql/` spusťte skripty postupně (01 → 07).  
3. Každý skript vytvoří nebo aktualizuje příslušnou tabulku nebo zobrazí výsledky dotazu.

## Předpoklady
- PostgreSQL 12+  
- Data jsou naimportovaná v schématu `data_academy_content`.  
- Uživatel má práva `SELECT` a `CREATE TABLE`.

## Kontakt
Martin Straka – [email@example.com](mailto:email@example.com)
