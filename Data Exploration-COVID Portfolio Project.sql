/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

SELECT *
FROM portfolio-project-388211.COVID.Portfolio
WHERE continent is not null 
ORDER BY 3,4;

-- Select Data that we are going to be starting with

SELECT location,date,total_cases, new_cases, total_deaths, population
FROM portfolio-project-388211.COVID.Portfolio
ORDER BY 1,2;

-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

SELECT location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as PercentPopulationInfected
FROM portfolio-project-388211.COVID.Portfolio
--WHERE location LIKE '%Nigeria%'
ORDER BY 1,2;

-- Countries with Highest Infection Rate compared to Population

SELECT Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
FROM portfolio-project-388211.COVID.Portfolio
--WHERE location like '%Nigeria%'
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC;

-- Countries with Highest Death Count per Population

SELECT Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM portfolio-project-388211.COVID.Portfolio
--WHERE location LIKE '%Nigeria%'
WHERE continent is not null 
GROUP BY Location
ORDER BY TotalDeathCount desc;

-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

SELECT continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM portfolio-project-388211.COVID.Portfolio
--WHERE location LIKE '%Nigeria%'
WHERE continent is not null 
GROUP BY continent
ORDER BY TotalDeathCount desc;

-- GLOBAL NUMBERS

SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
FROM portfolio-project-388211.COVID.Portfolio
--WHERE location LIKE '%Nigeria%'
WHERE continent is not null 
--GROUP BY  date
ORDER BY 1,2;

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine


SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS int)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM portfolio-project-388211.COVID.Portfolio dea
JOIN portfolio-project-388211.COVID.CovidVaccination vac 
    ON dea.location = vac.location
	  AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3;

-- Using CTE to perform Calculation on Partition By in previous query

WITH PopvsVac AS
(
    SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
        SUM(CAST(vac.new_vaccinations AS int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
    FROM `portfolio-project-388211.COVID.Portfolio` dea
    JOIN `portfolio-project-388211.COVID.CovidVaccination` vac 
        ON dea.location = vac.location AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL
    ORDER BY 2,3
)
SELECT *, (RollingPeopleVaccinated/Population)*100
FROM PopvsVac;

-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists portfolio-project-388211.COVID.PercentPopulationVaccinated;
CREATE TABLE portfolio-project-388211.COVID.PercentPopulationVaccinated
(
    continent STRING,
    location STRING,
    date DATE,
    population NUMERIC,
    new_vaccinations NUMERIC,
    RollingPeopleVaccinated NUMERIC
);

INSERT INTO portfolio-project-388211.COVID.PercentPopulationVaccinated
 SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
        SUM(CAST(vac.new_vaccinations AS int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
    FROM `portfolio-project-388211.COVID.Portfolio` dea
    JOIN `portfolio-project-388211.COVID.CovidVaccination` vac 
        ON dea.location = vac.location AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL
    ORDER BY 2,3;

SELECT *, (RollingPeopleVaccinated/Population)*100
FROM portfolio-project-388211.COVID.PercentPopulationVaccinated;

-- Creating View to store data for later visualizations
-- Showing contintents with the highest death count per population

CREATE VIEW portfolio-project-388211.COVID.PortfolioView AS
SELECT continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM portfolio-project-388211.COVID.Portfolio
--WHERE location LIKE '%Nigeria%'
WHERE continent is not null 
GROUP BY continent
ORDER BY TotalDeathCount desc;
