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

-- Numbers in global scale 
select date, sum(new_cases) as global_total_cases, sum(cast(new_deaths as int)) as global_total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
From CovidAnalysisProject..CovidDeaths
where continent is not null
Group by date
order by 1,2

-- Total Number of the cases in global scale 
select sum(new_cases) as global_total_cases, sum(cast(new_deaths as int)) as global_total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
From CovidAnalysisProject..CovidDeaths
where continent is not null
--Group by date
order by 1,2

-- Join CovidDeaths and CovidVaccinate tables
select * 
from CovidAnalysisProject..CovidVaccinations vac
join CovidAnalysisProject..CovidDeaths death
	on death.location = vac.location
	and death.date = vac.date

-- Population vs Vaccination 
select death.continent, death.location, death.date, death.population ,vac.new_vaccinations 
from CovidAnalysisProject..CovidVaccinations vac
join CovidAnalysisProject..CovidDeaths death
	on death.location = vac.location
	and death.date = vac.date
where death.continent is not null
order by 2,3

-- Population vs Vaccination for each contury per day
select death.continent, death.location, death.date, death.population , vac.new_vaccinations
from CovidAnalysisProject..CovidDeaths death
join CovidAnalysisProject..CovidVaccinations vac
	on death.location = vac.location
	and death.date = vac.date
where death.continent is not null
order by 2,3

-- Population vs Vaccination for each contury per day with partitioning 
select death.continent, death.location, death.date, death.population , vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by death.location Order by death.location, death.Date)
from CovidAnalysisProject..CovidDeaths death
join CovidAnalysisProject..CovidVaccinations vac
	on death.location = vac.location
	and death.date = vac.date
where death.continent is not null
order by 2,3


 -- Using CTE to roll vaccinated people over population per country
 
with PopVsVac (continent, location, Date, Population, New_Vaccinations, RollingPeopleVaccinated) 
as
(
select death.continent, death.location, death.date, death.population , vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by death.location Order by death.location, death.Date) as RollingPeopleVaccinated
from CovidAnalysisProject..CovidDeaths death
join CovidAnalysisProject..CovidVaccinations vac
	on death.location = vac.location
	and death.date = vac.date
where death.continent is not null
)
select * , (RollingPeopleVaccinated/Population)*100
From PopVsVac