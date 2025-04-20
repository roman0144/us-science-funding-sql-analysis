USE research;
-- Сравнение общего финансирования научных отраслей в образовательной сфере
SELECT 
    science_field AS field, 
    higher_education_funding AS funding_amount
FROM sector_expenditures_2023
ORDER BY funding_amount DESC;
SELECT * FROM life_scienses_funding ORDER BY funding_amount DESC;

-- Сопоставление локального и федерального финансирования науки в образовании
SELECT 
    science_field,
    federal_funding_university,
    local_funding_university,
    federal_funding_university / local_funding_university AS federal_to_local_ratio
FROM sector_expenditures_2023
ORDER BY federal_to_local_ratio DESC; -- Пропорция здесь означает "во сколько раз федеральное финансирование больше местного"
SELECT *, -- Смотрим нет ли ошибки в данных или дополнительного финансирования. Не нашли, только на 1.00, вероятно из-за округления
    (federal_funding + university_funding + industry_funding + business_funding + all_other_sources) - total_expenditure AS diff
FROM research_expenditures
WHERE (federal_funding + university_funding + industry_funding + business_funding + all_other_sources) > total_expenditure;

-- Историческая динамика финансирования науки от 1953 до 2023 года
SELECT research_year, 
       total_expenditure, 
       federal_funding, 
       university_funding, 
       industry_funding, 
       business_funding, 
       all_other_sources,
       total_expenditure - LAG(total_expenditure) OVER (ORDER BY research_year) AS expenditure_change
FROM research_expenditures
ORDER BY ABS(expenditure_change) DESC
LIMIT 10; -- Выдаёт только 0-е и 20-е, но эти данные показывают только финансирование в абсолютных числах
SELECT research_year, expenditure_change 
FROM (
    SELECT research_year, 
           total_expenditure - LAG(total_expenditure) OVER (ORDER BY research_year) AS expenditure_change
    FROM research_expenditures
) subquery
ORDER BY expenditure_change ASC
LIMIT 10; -- Возможно, результат такой, из-за низкого старта
-- SELECT * FROM research_expenditures ORDER BY research_year;
SELECT research_year, 
       total_expenditure, 
       total_expenditure - LAG(total_expenditure) OVER (ORDER BY research_year) AS expenditure_change, 
       (total_expenditure - LAG(total_expenditure) OVER (ORDER BY research_year)) / LAG(total_expenditure) OVER (ORDER BY research_year) * 100 AS percentage_change
FROM research_expenditures
ORDER BY percentage_change; -- Для анализа построен график в Python

-- Анализ бизнес-расходов на научные отрасли и технологии
SELECT * FROM business_expenditures ORDER BY All_companies DESC;
SELECT 
  CASE 
    WHEN Industry_and_company_size IN ('Software_publishers', 'Data_processing,_hosting,_and_related_services', 'Telecommunications', 'Computer_systems_design_and_related_services') 
THEN 'IT_Services'
	WHEN Industry_and_company_size IN ('Other_information', 'Newspaper,_periodical,_book,_and_directory_publishers', 'Printing_and_related_support_activities') 
THEN 'Other_Information_Services'
	WHEN Industry_and_company_size IN ('Pharmaceuticals_and_medicines', 'Electromedical,_electrotherapeutic,_and_irradiation_apparatus', 'Medical_equipment_and_supplies', 'Health_care_services') 
THEN 'Medicine'
	WHEN Industry_and_company_size IN ('Communications_equipment', 'Semiconductor_and_other_electronic _omponents', 'Other_computer_and_electronic_products') 
THEN 'Electronics'
	WHEN Industry_and_company_size IN ('Navigational,_measuring,_electromedical,_and_control_instruments', 'Scientific_research_and_development_services') 
THEN 'Investment_in_research'
	WHEN Industry_and_company_size IN ('Search,_detection,_navigation,_guidance,_aeronautical,_and_nautical_system_and_instruments', 'Architectural,_engineering,_and_related_services', 'Transportation_equipment', 'Machinery', 'Wood_products', 'Plastics_and_rubber_products', 'Nonmetallic_mineral_products', 'Primary_metals', 'Fabricated_metal_products') 
THEN 'Construction_and_machinery'
  END AS Grouped_Industry,
  SUM(All_companies) AS Total
FROM business_expenditures
GROUP BY Grouped_Industry
ORDER BY Total DESC;