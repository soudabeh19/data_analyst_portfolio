-- Select some of the data to use
select Location, date, total_cases, new_cases, total_deaths, population 
from CovidAnalysisProject..CovidDeaths
order by 1,2


--How many cases do they have and how many death cases be reported? what's the percentage of death people compare to the number of Covid cases
select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DailyDeathPctg
from CovidAnalysisProject..CovidDeaths
order by 1,2

--What's the percentage of daily death number over total case number in United States
select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DailyDeathPctg
from CovidAnalysisProject..CovidDeaths
where location like '%states%'
order by 1,2

-- How much worse is it? Total cases vs population!!
-- Percentage of population who have Covid (daily infection rate compared to population)
select Location, date,  population, total_cases, (total_cases/population)*100 as PctgPopulationInfected
from CovidAnalysisProject..CovidDeaths
where location like '%states%'
order by 1,2

-- Country with the highist infection rate compare to its population (order by the highest infected population)
select Location, population, MAX(total_cases) as highestInfectionReported, MAX(total_cases/population)*100 as PctgPopulationInfected
from CovidAnalysisProject..CovidDeaths
group by Location, population
order by PctgPopulationInfected desc

-- Country with the highist death number compare to its population (order by the highest death rate population)
-- Note: 1. total_deaths is a nvarchar type and it needs to convert to int
--		 2. some records have NULL value in their "continent" columns therefore their location represents by their continent name
select Location, MAX(cast(total_deaths as int)) as TotalDeathNum 
from CovidAnalysisProject..CovidDeaths
where continent is not null
group by Location
order by TotalDeathNum desc


-- (Correct One) Continent with the highist death number compare to its population (order by the highest death rate population)
select location, MAX(cast(total_deaths as int)) as TotalDeathNum 
from CovidAnalysisProject..CovidDeaths
where continent is null
group by location
order by TotalDeathNum desc

-- (Just for being the same as ALEX project however the above query is accurate not the bellow one- for the sake of working with Tableau) Continent with the highist death number compare to its population (order by the highest death rate population)
select continent, MAX(cast(total_deaths as int)) as TotalDeathNum 
from CovidAnalysisProject..CovidDeaths
where continent is not null
group by continent
order by TotalDeathNum desc

-- Time: 42:49

