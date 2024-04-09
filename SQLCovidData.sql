

-- Full Table view of Covid Cases and Death 
Select *
From SQLPOrtfolio..CovidCasesDeath
Where continent is not null 
order by 1,2

-- Full table view of showing vaccination and other 
Select *
From SQLPOrtfolio..CovidVaccinatedMortalityRate
Where continent is not null 
order by 1,2

     
-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

Select Location, date, total_cases,total_deaths, 
CASE 
        WHEN total_cases = 0 THEN NULL
        ELSE (CAST(total_deaths AS float) / total_cases) * 100 
    END AS DeathPercentage
From SQLPOrtfolio..CovidCasesDeath
Where location like '%states%'
and continent is not null 
order by 1,2


-- Total cases on a perticular Year
Select YEAR(date) as YEAR, location, SUM(CAST(new_cases AS bigint)) AS total_new_cases
From SQLPOrtfolio..CovidCasesDeath
Where YEAR(date) = 2024
GROUP BY YEAR(date), location
order by 1,2


-- Compare New Covid cases counts across different years for each location
-- Shows what percentage of population infected with Covid
SELECT 
    location,
	SUM(CASE WHEN YEAR(date) = 2020 THEN CAST(new_cases AS bigint) ELSE 0 END) AS total_new_cases_2020,
    SUM(CASE WHEN YEAR(date) = 2021 THEN CAST(new_cases AS bigint) ELSE 0 END) AS total_new_cases_2021,
    SUM(CASE WHEN YEAR(date) = 2022 THEN CAST(new_cases AS bigint) ELSE 0 END) AS total_new_cases_2022,
    SUM(CASE WHEN YEAR(date) = 2023 THEN CAST(new_cases AS bigint) ELSE 0 END) AS total_new_cases_2023,
    SUM(CASE WHEN YEAR(date) = 2024 THEN CAST(new_cases AS bigint) ELSE 0 END) AS total_new_cases_2024,
	(SUM(CAST(new_cases AS bigint)) / population) * 100 AS PercentPopulationInfected

FROM 
    SQLPOrtfolio..CovidCasesDeath
	Where continent = 'Asia'
GROUP BY 
    location, population
ORDER BY 
    location;

-- Compare total deaths cases counts across different years for each location
-- Shows what percentage of population death after Covid

	SELECT location,
	SUM(CASE WHEN YEAR(date) = 2020 THEN CAST(new_deaths AS bigint) ELSE 0 END) AS total_death_cases_2020,
	SUM(CASE WHEN YEAR(date) = 2021 THEN CAST(new_deaths AS bigint) ELSE 0 END) AS total_death_cases_2021,
	SUM(CASE WHEN YEAR(date) = 2022 THEN CAST(new_deaths AS bigint) ELSE 0 END) AS total_death_cases_2022,
	SUM(CASE WHEN YEAR(date) = 2023 THEN CAST(new_deaths AS bigint) ELSE 0 END) AS total_death_cases_2023,
	SUM(CASE WHEN YEAR(date) = 2024 THEN CAST(new_deaths AS bigint) ELSE 0 END) AS total_death_cases_2024,
CASE 
        WHEN SUM(CAST(new_cases AS bigint)) = 0 THEN 0
        ELSE (SUM(CAST(new_deaths AS bigint)) / SUM(CAST(new_cases AS bigint))) * 100 
    END AS DeathPercentage	FROM 
    SQLPOrtfolio..CovidCasesDeath
	Where continent = 'Asia'
GROUP BY 
    location, population
ORDER BY 
    location;

-- Compare New Covid cases and death counts in a year for a continent location
-- Shows what percentage of population infected with Covid

	SELECT 
    location,
    SUM(CASE WHEN YEAR(date) = 2020 THEN CAST(new_cases AS bigint) ELSE 0 END) AS total_new_cases_2020,
    SUM(CASE WHEN YEAR(date) = 2020 THEN CAST(new_deaths AS bigint) ELSE 0 END) AS total_death_cases_2020,
    (SUM(CASE WHEN YEAR(date) = 2020 THEN CAST(new_cases AS bigint) ELSE 0 END) / population) * 100 AS PercentPopulationInfected_2020,
    CASE 
        WHEN SUM(CASE WHEN YEAR(date) = 2020 THEN CAST(new_cases AS bigint) ELSE 0 END) = 0 THEN NULL
        ELSE ((SUM(CASE WHEN YEAR(date) = 2020 THEN CAST(new_deaths AS bigint) ELSE 0 END) * 100.0) / SUM(CASE WHEN YEAR(date) = 2020 THEN CAST(new_cases AS bigint) ELSE 0 END))
    END AS DeathPercentageofInfectedCount_2020
FROM 
    SQLPOrtfolio..CovidCasesDeath
WHERE 
    continent = 'Asia'
GROUP BY 
    location, population
ORDER BY 
    location;

-- Countries with Highest Infection Rate compared to Population

Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From SQLPOrtfolio..CovidCasesDeath
--Where location like '%states%'
order by PercentPopulationInfected desc
Select Location, Population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
From SQLPOrtfolio..CovidCasesDeath
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

-- Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From SQLPOrtfolio..CovidCasesDeath
--Where location like '%states%'
Where continent is not null 
Group by Location
order by TotalDeathCount desc

--Find the location with the highest number of new cases in a single day.
Select TOP 1 location, date, max(new_cases) as highest_number_of_new_cases_a_single_day
From SQLPOrtfolio..CovidCasesDeath
Where continent is not null 
Group by location,date
order by highest_number_of_new_cases_a_single_day desc 

--Calculate the average number of new deaths per day across all locations.
Select location, AVG(new_deaths) as Avg_Death_count
From SQLPOrtfolio..CovidCasesDeath
Where continent is not null 
Group by location
order by Avg_Death_count desc 

--To calculate the average number of new deaths per day across all locations on a yearly basis
SELECT 
    YEAR(date) AS year,
    AVG(cast(new_deaths as int)) AS avg_new_deaths_per_day
FROM 
    SQLPOrtfolio..CovidCasesDeath
GROUP BY 
    YEAR(date)
order by year;

--Identify the location with the highest total deaths per million people.

select location, MAX(total_deaths_per_million) as TotalDeathsPerMillion
FROM 
    SQLPOrtfolio..CovidCasesDeath
GROUP BY 
    location
order by TotalDeathsPerMillion desc;

--Determine the continent with the highest total cases.
select continent, MAX(total_cases) as max_cases
FROM 
    SQLPOrtfolio..CovidCasesDeath
	GROUP BY 
    continent
order by max_cases desc;

--Find the location with the highest reproduction rate.

select location, MAX(reproduction_rate) as reproduction_rate
FROM 
    SQLPOrtfolio..CovidCasesDeath
	GROUP BY 
    location
order by reproduction_rate desc;

--Calculate the total number of ICU patients across all locations.
select SUM(cast(icu_patients as int)) as total_ICU_Patients
FROM 
    SQLPOrtfolio..CovidCasesDeath

--Find the location with the highest mortality rate:
select location,sum(cast (total_deaths as bigint)) as total_deaths,SUM(cast( total_cases as bigint)) as total_cases, SUM(cast(total_deaths as bigint))*100.0/NULLIF (SUM(cast(total_cases as bigint)),0) as mortality_rate
FROM 
    SQLPOrtfolio..CovidCasesDeath
GROUP BY 
    location
order by mortality_rate desc;



--Identify the location with the highest percentage change in cases: 
WITH CasesChange AS (
    SELECT 
        location,
        date,
        
        CAST(total_cases AS float) AS total_cases,
        LAG(CAST(total_cases AS float)) OVER (PARTITION BY location ORDER BY date) AS previous_total_cases,
        (CAST(total_cases AS float) - LAG(CAST(total_cases AS float)) OVER (PARTITION BY location ORDER BY date)) * 100.0 / NULLIF(LAG(CAST(total_cases AS float)) OVER (PARTITION BY location ORDER BY date), 0) AS percentage_change
    FROM 
        SQLPOrtfolio..CovidCasesDeath
)
SELECT 
    location,
    MAX(percentage_change) AS highest_percentage_change
FROM 
    CasesChange
GROUP BY 
    location
ORDER BY 
    highest_percentage_change DESC;

-- Find the location with the highest hospital beds per thousand people
select location, SUM(cast(hosp_patients as bigint)) AS total_hosp_patients,
    population, sum(cast(hosp_patients as bigint))*1000/NULLIF(population, 0)  as hosp_patients_per_thousand
FROM 
    SQLPOrtfolio..CovidCasesDeath
	GROUP BY 
    location, population
ORDER BY 
    hosp_patients_per_thousand DESC;

--Calculate the percentage of ICU patients per hospital:

Select location,sum(cast(icu_patients as bigint)) as icu_patients, sum(cast(hosp_patients as bigint)) as hosp_patients,
sum(cast(icu_patients as bigint)) *100 /NULLIF(sum(cast(hosp_patients as bigint)),0) as ICU_PER_HOSP
FROM 
    SQLPOrtfolio..CovidCasesDeath
	GROUP BY 
    location
ORDER BY 
    ICU_PER_HOSP DESC;


--Identify the location with the highest weekly hospital admissions per capita: 

WITH WeeklyAdmissionsPerCapita AS (
Select location, max(weekly_hosp_admissions) as weekly_hosp_admissions,
population,
        (SUM(cast(weekly_hosp_admissions as bigint)) * 1000.0) / NULLIF(population, 0) AS weekly_hosp_admissions_per_capita
    FROM 
    SQLPOrtfolio..CovidCasesDeath
	GROUP BY 
    location, population
	)
SELECT 
    location,
    weekly_hosp_admissions_per_capita
FROM 
    WeeklyAdmissionsPerCapita
ORDER BY 
    weekly_hosp_admissions_per_capita DESC

	
--To determine the correlation between population density and mortality rate, you can calculate the correlation coefficient between these two variables using statistical functions. Here's how you can do it:

SELECT 
    cv.location, AVG(cv.population_density) AS avg_population_density,
    AVG(cd.mortality_rate) AS avg_mortality_rate
FROM 
    (
        SELECT 
            location,date,
            population_density
        FROM 
            SQLPOrtfolio..CovidVaccinatedMortalityRate
    ) AS cv
JOIN 
    (
        SELECT 
            location,date,
            AVG(CAST(total_deaths AS FLOAT) / total_cases) AS mortality_rate
        FROM 
            SQLPOrtfolio..CovidCasesDeath
        GROUP BY 
            location, date
    ) AS cd 
	ON cv.location = cd.location AND cv.date = cd.date
GROUP BY 
    cv.location



	-- Vacination Table
	Select *
From SQLPOrtfolio..CovidVaccinatedMortalityRate
Where continent is not null 
order by 1,2

--Determine the correlation between vaccination rate and mortality rate: 
SELECT
    v.location,
    SUM((v.people_fully_vaccinated / v.population) * (c.total_deaths / c.population)) / COUNT(*) - 
    POWER(SUM(v.people_fully_vaccinated / v.population), 2) * POWER(SUM(c.total_deaths / c.population), 2) / POWER(COUNT(*), 2) AS correlation
FROM
    SQLPOrtfolio..CovidVaccinatedMortalityRate v
INNER JOIN
    SQLPOrtfolio..CovidCasesDeath c ON v.location = c.location AND v.date = c.date
GROUP BY
    v.location
	order by correlation desc;
	--(The correlation quantifies the strength and direction of the linear relationship between the vaccination rate and mortality rate. It ranges from -1 to 1, where:

--A positive correlation (close to 1) indicates that higher vaccination rates tend to be associated with higher mortality rates.
--A negative correlation (close to -1) indicates that higher vaccination rates tend to be associated with lower mortality rates.
--A correlation close to 0 indicates little to no linear relationship between the variables.)


--Identify the location with the highest percentage of people fully vaccinated

SELECT 
    location,
    MAX(people_fully_vaccinated_per_hundred) AS highest_percentage_fully_vaccinated
FROM
    SQLPOrtfolio..CovidVaccinatedMortalityRate
	
GROUP BY
    location
ORDER BY
    highest_percentage_fully_vaccinated DESC;


--Find the location with the lowest median age: Identify the location with the lowest median age.

--Calculate the average positivity rate of tests per continent: Calculate the average positivity rate of tests for each continent.
SELECT 
    top 1 location,
    MIN(median_age) AS lowest_median_age
FROM
    SQLPOrtfolio..CovidVaccinatedMortalityRate
	WHERE
    median_age IS NOT NULL
GROUP BY
    location
ORDER BY
    lowest_median_age;


--To calculate the average positivity rate of tests per continent
	SELECT
    continent,
    AVG(cast(positive_rate as float)) AS average_positivity_rate
FROM

    SQLPOrtfolio..CovidVaccinatedMortalityRate
	WHERE
    continent IS NOT NULL
GROUP BY
    continent;

--Calculate the average number of new boosters administered per day
	SELECT
    AVG(cast(new_boosters as float)) AS average_new_boosters_per_day
FROM
    (
        SELECT
            date,
            LAG(total_boosters, 1, 0) OVER (ORDER BY date) AS prev_total_boosters,
            total_boosters AS new_boosters
        FROM
            SQLPOrtfolio..CovidVaccinatedMortalityRate
    ) AS boosters
WHERE
    date > '2020-01-01'; -- Specify the start date according to your data


-- Identify the location with the highest percentage change in vaccinations
	WITH VaccinationChanges AS (
    SELECT
        location,
        date,
        CAST(new_vaccinations AS DECIMAL) AS new_vaccinations,
        LAG(CAST(new_vaccinations AS DECIMAL)) OVER (PARTITION BY location ORDER BY date) AS prev_new_vaccinations
    FROM
        SQLPOrtfolio..CovidVaccinatedMortalityRate
)
SELECT
    location,
    MAX( CASE 
            WHEN prev_new_vaccinations = 0 THEN NULL
            ELSE (new_vaccinations - prev_new_vaccinations) / prev_new_vaccinations * 100
        END) 
		AS max_percentage_change
FROM
    VaccinationChanges
GROUP BY
    location
	order by max_percentage_change desc;

	--Join table queries 

--Geographic disparities in vaccination coverage:

	SELECT DISTINCT
    v.location,v.date,
     CAST(v.total_vaccinations AS DECIMAL) AS total_vaccinations_numeric,
    CAST(c.total_deaths AS DECIMAL) AS total_deaths_numeric,
    CAST(v.population AS DECIMAL) AS population_numeric,
    (CAST(v.total_vaccinations AS DECIMAL) * 100.0 / CAST(v.population AS DECIMAL)) AS vaccination_percentage,
    (CAST(c.total_deaths AS DECIMAL) * 100.0 / CAST(v.population AS DECIMAL)) AS mortality_percentage
FROM
    SQLPOrtfolio..CovidVaccinatedMortalityRate v
JOIN
    SQLPOrtfolio..CovidCasesDeath c ON v.location = c.location
WHERE
    v.total_vaccinations < (SELECT AVG(cast(total_vaccinations as float)) FROM SQLPOrtfolio..CovidVaccinatedMortalityRate)
    AND c.total_deaths > (SELECT AVG(cast(total_deaths as float)) FROM SQLPOrtfolio..CovidCasesDeath)
ORDER BY
    vaccination_percentage ASC, mortality_percentage DESC;

--4.	5.	Demographic factors affecting vaccination rates: Explore how demographic factors such as median age, poverty rates, and population density influence vaccination rates and COVID-19 outcomes.
-- 
SELECT
    v.location,
    v.total_vaccinations,
    v.people_fully_vaccinated,
    c.total_deaths,
    c.total_cases,
    c.population,
    v.median_age,
    v.diabetes_prevalence,
    v.extreme_poverty,
    v.population_density
FROM
    SQLPOrtfolio..CovidVaccinatedMortalityRate v
JOIN
    SQLPOrtfolio..CovidCasesDeath c ON v.location = c.location



--8.	Identification of high-risk populations: Use demographic data to identify high-risk populations for severe COVID-19 outcomes and target vaccination efforts accordingly.

	SELECT
    v.location,
    v.date,
    v.new_vaccinations,
    v.people_fully_vaccinated,
    c.new_cases,
    c.new_deaths
FROM
    SQLPOrtfolio..CovidVaccinatedMortalityRate v
JOIN
    SQLPOrtfolio..CovidCasesDeath c ON v.location = c.location AND v.date = c.date
WHERE
    NOT (
        (v.new_vaccinations IS NULL OR v.new_vaccinations = '') AND
        (v.people_fully_vaccinated IS NULL OR v.people_fully_vaccinated = '') AND
        (c.new_cases IS NULL OR c.new_cases = '') AND
        (c.new_deaths IS NULL OR c.new_deaths = '')
    )
ORDER BY
    v.location, v.date;


	-- Create a temporary table to store the rolling percentage of population vaccinated
-- Create a temporary table to store the rolling percentage of population vaccinated
-- Create a temporary table to store the rolling percentage of population vaccinated
-- Create a temporary table to store the rolling percentage of population vaccinated


-- Insert data into the temporary table
-- Create a temporary table to store the rolling percentage of population vaccinated
CREATE TABLE #RollingPercentPopulationVaccinated (
    continent NVARCHAR(255),
    location NVARCHAR(255),
    date DATE,
    population BIGINT,
    new_vaccinations INT,
    rolling_people_vaccinated BIGINT,
    rolling_percent_vaccinated FLOAT
);

-- Insert data into the temporary table
INSERT INTO #RollingPercentPopulationVaccinated
SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.date) AS rolling_people_vaccinated,
    (SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.date) * 100.0 / dea.population) AS rolling_percent_vaccinated
FROM
    SQLPOrtfolio..CovidCasesDeath dea
JOIN
    SQLPOrtfolio..CovidVaccinatedMortalityRate vac ON dea.location = vac.location AND dea.date = vac.date;

-- Select data from the temporary table
SELECT * FROM #RollingPercentPopulationVaccinated;

-- Drop the temporary table
DROP TABLE #RollingPercentPopulationVaccinated;


-- Creating View to store data for later visualizations

	CREATE VIEW RollingPercentPopulationVaccinated AS
SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.date) AS rolling_people_vaccinated,
    (SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.date) * 100.0 / dea.population) AS rolling_percent_vaccinated
FROM
    SQLPOrtfolio..CovidCasesDeath dea
JOIN
    SQLPOrtfolio..CovidVaccinatedMortalityRate vac ON dea.location = vac.location AND dea.date = vac.date;
