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