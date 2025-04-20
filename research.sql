CREATE DATABASE research;
USE research;
-- Загружаются только те поля, которые были использованы в аналитике.

-- Загрузка данных о расходах на научные исследования с 1953 по 2023 г.
/*
Файл был скачан с сайта NSF в формате Excel, затем подготовлен к загрузке:
- удалены пробелы в значениях и названиях столбцов (через автозамену в блокноте);
- вырезаны комментарии, лишние строки и столбцы;
- изменены названия столбцов для соответствия структуре таблицы и читабельности без пробелов;
- сохранён в формате CSV (UTF-8, разделитель — запятая). Но блокнот показывал, что сохранилась с разделителем точка с запятой.
*/
CREATE TABLE research_expenditures (
    id INT AUTO_INCREMENT PRIMARY KEY,
    research_year INT,
    total_expenditure DECIMAL(15,2),
    federal_funding DECIMAL(15,2),
    university_funding DECIMAL(15,2),
    industry_funding DECIMAL(15,2),
    business_funding DECIMAL(15,2),
    all_other_sources DECIMAL(15,2)
);
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/nsf25314-tab001.csv'
INTO TABLE research_expenditures
FIELDS TERMINATED BY ';' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@research_year, @total_expenditure, @federal_funding, @industry_funding, @university_funding, @business_funding, @all_other_sources)
SET 
    research_year = NULLIF(@research_year, ''),
    total_expenditure = NULLIF(@total_expenditure, ''),
    federal_funding = NULLIF(@federal_funding, ''),
    university_funding = NULLIF(@university_funding, ''),
    industry_funding = NULLIF(@industry_funding, ''),
	business_funding = NULLIF(@business_funding, ''),
	all_other_sources = NULLIF(@all_other_sources, '');
SELECT * FROM research_expenditures LIMIT 10;

-- Загрузка данных о расходах образовательных учереждений на научные исследования по научным отраслям
CREATE TABLE sector_expenditures (
	science_field TEXT,
    higher_education_funding DECIMAL(15,2),
    federal_funding_university DECIMAL(15,2),
    local_funding_university DECIMAL(15,2)
);
INSERT INTO sector_expenditures_2023 -- Данные "All institutions" из файлов "nsf25314-tab023" 25 и 27
(science_field, higher_education_funding, federal_funding_university, local_funding_university)
VALUES
('All_RnD_expenditures', 108681008, 59603993, 5437566),
('Computer_and_information_sciences', 3617348, 2417938, 92811),
('Geosciences_atmospheric_sciences_ocean_sciences', 4032534, 2693891, 256518),
('Life_sciences', 62204360, 33896235, 3161287),
('Mathematics_and_statistics', 1060700, 661446, 30663),
('Physical_sciences', 6944769, 4621763, 129636),
('Psychology', 1637829, 978784, 59755),
('Social_sciences', 3615227, 1202546, 208838),
('Sciences_nec', 1194804, 475264, 59917),
('Engineering', 17468446, 10931327, 961129),
('All_non_SnE_fields', 6904991, 1724799,	477012);
SELECT * FROM sector_expenditures_2023;

-- Загрузка данных о расходах образовательных учереждений на научные исследования среди "наук о жизни"
-- Строчка Life_sciences показалась подозрительной, и я решил скачать более подробную таблицу по этой графе
CREATE TABLE life_scienses_funding (
    science_field TEXT,
    funding_amount DECIMAL(15,2)
);
INSERT INTO life_scienses_funding -- Данные "All institutions" из файлf "nsf25314-tab043"
(science_field, funding_amount)
VALUES
('All_life_sciences', 33896235),
('Agricultural_sciences', 1458868),
('Biological_and_biomedical_sciences', 11753581),
('Health_sciences', 19390822),
('Natural_resources_and_conservation', 512675),
('Life_sciences_nec', 780289);
SELECT * FROM ife_scienses_funding;

-- Загрузка данных о расходах бизнеса на научные исследования по научным отраслям
-- Данные о размерах компаний не были проанализированы, но учитывались при рассмотрение неподробных категорий вроде "другое"
/*
Файл был скачан с сайта NSF в формате Excel, затем подготовлен к загрузке:
- удалены пробелы в значениях, названиях столбцов (через автозамену в блокноте);
- очищенны ячейки с значением 'D'(сомнительные или засекреченные данные из-за коммерческой тайны)(через автозамену в блокноте);
- вырезаны комментарии, лишние строки и столбцы;
- изменены названия столбцов для соответствия структуре таблицы и читабельности без пробелов;
- сохранён в формате CSV (UTF-8, разделитель — запятая). Но блокнот показывал, что сохранилась с точкой с запятой;
*/
CREATE TABLE business_expenditures (
    Industry_and_company_size TEXT,
    All_companies DECIMAL(15,2),
    Less_than_1ml DECIMAL(15,2),
    ml_1_9_999 DECIMAL(15,2),
    ml_10_49_999 DECIMAL(15,2),
    ml_50_99_999 DECIMAL(15,2),
    ml_100_or_more DECIMAL(15,2)
);
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/nsf24335-tab003.csv'
INTO TABLE business_expenditures
FIELDS TERMINATED BY ';' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@Industry_and_company_size, @All_companies, @Less_than_1ml, @ml_1_9_999, @ml_10_49_999, @ml_50_99_999, @ml_100_or_more)
SET 
    Industry_and_company_size = NULLIF(@Industry_and_company_size, ''),
    All_companies = NULLIF(@All_companies, ''),
    Less_than_1ml = NULLIF(@Less_than_1ml, ''),
    ml_1_9_999 = NULLIF(@ml_1_9_999, ''),
    ml_10_49_999 = NULLIF(@ml_10_49_999, ''),
	ml_50_99_999 = NULLIF(@ml_50_99_999, ''),
	ml_100_or_more = NULLIF(@ml_100_or_more, '');
SELECT * FROM business_expenditures LIMIT 10;