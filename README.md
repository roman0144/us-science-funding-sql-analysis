Исследование различий в финансировании отраслей науки США
Цель: Определить, какие отрасли науки получают наибольшее и наименьшее финансирование, выявить закономерности распределения средств, возможные причины различий и перспективы изменений в будущем.

Данные: Проект основан на открытых базах данных Национального научного фонда США (NSF):
HERD Survey 2023 — таблицы 1, 23, 25, 27, 43
Business Enterprise R&D 2022 — таблица 3

Обработанные таблицы:
- `sector_expenditures_2023` — государственное финансирование по отраслям  
- `life_sciences_funding` — распределение внутри наук о жизни  
- `research_expenditures` — динамика финансирования науки с 1953 по 2023  
- `business_expenditures` — инвестиции частного сектора по отраслям и размерам компаний

Методы анализа:
Сортировка и группировка в SQL
Построение категорий с CASE WHEN
Визуализация и трендовый анализ в Python (Jupyter Notebook)

Инструменты:
SQL (SQLite)
Jupyter Notebook (Python 3.11)
pandas, matplotlib, seaborn
