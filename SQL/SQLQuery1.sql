Select *
From Portfolio_Project..CovidDeaths
Where continent is not null
-- when continent is null it means location is an entire continent
Order by 3,4


--Select *
--From Portfolio_Project..CovidVaccinations
--order by 3,4

--Select Data that we are going to be using

Select location, date, total_cases, new_cases, total_deaths, population
From Portfolio_Project..CovidDeaths
Where continent is not null
Order by 1,2


--Looking at total cases vs total deaths
--Shows likelihood of dying if you contrac covid in your country
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From Portfolio_Project..CovidDeaths
Where location like '%states%'
Order by 1,2


--Looking at total cases vs population
--Shows what percentage of population got covid

Select location, date, population, total_cases, (total_cases/population)*100 as percent_population_infected
From Portfolio_Project..CovidDeaths
--Where location like '%states%'
Order by 1,2


--Looking at Countries with highest infection rate compared to population

Select location, population, max(total_cases) as highest_infection_count, max((total_cases/population))*100 as percent_population_infected
From Portfolio_Project..CovidDeaths
--Where location like '%states%'
Group by location, population
Order by percent_population_infected desc


--Showing countries with the highest death count per population


Select location, max(cast(total_deaths as int)) as total_death_count
From Portfolio_Project..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by location
Order by total_death_count desc


--LET'S BREAK TINGS DOWN BY CONTINENT

--Showing continents with the highest death count per population

Select continent, max(cast(total_deaths as int)) as total_death_count
From Portfolio_Project..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by continent
order by total_death_count desc


--GLOBAL NUMBERS 

Select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as death_percentage
From Portfolio_Project..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by date
Order by 1,2

--GLOBAL NUMBERS - TOTAL OF ENTIRE WORLD

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/sum(new_cases)*100 as death_percentage
From Portfolio_Project..CovidDeaths
--Where location like '%states%'
WHERE continent is not null
--GROUP BY date
ORDER BY 1,2


--Looking at total population vs vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date) as rolling_people_vaccinated
--, (rolling_people_vaccinated/population)*100
From Portfolio_Project..CovidDeaths dea
Join Portfolio_Project..CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
Order by 2,3


--USE CTE

With PopvsVac (continent, location, date, population, new_vaccinations, rolling_people_vaccinated)
As
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location ORDER by dea.location, dea.date) as rolling_people_vaccinated
--, (rolling_people_vaccinated/population)*100
FROM Portfolio_Project..CovidDeaths dea
Join Portfolio_Project..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order by 2,3
)
Select *, (rolling_people_vaccinated/population)*100
From PopvsVac


--TEMP TABLE

Drop table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
Date datetime,
population numeric,
new_vaccinations numeric,
rolling_people_vaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location ORDER by dea.location, dea.date) as rolling_people_vaccinated
--, (rolling_people_vaccinated/population)*100
From Portfolio_Project..CovidDeaths dea
Join Portfolio_Project..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--ORDER BY 2,3

Select *, (rolling_people_vaccinated/population)*100
From #PercentPopulationVaccinated


--Creating view to store data for later visualizations

Create view PercentPopulationVaccinated as 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date) as rolling_people_vaccinated
--, (rolling_people_vaccinated/population)*100
From Portfolio_Project..CovidDeaths dea
Join Portfolio_Project..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order by 2,3

Select *
From PercentPopulationVaccinated
