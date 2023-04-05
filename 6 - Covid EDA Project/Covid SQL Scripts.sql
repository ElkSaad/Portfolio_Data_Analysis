Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject_Covid19..[covid-deaths]
where continent is not null
order by 3,4

-- Total cases vs Total deaths
-- Shows likelihood of dying if you contract covid in your country

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathsPercentage
From PortfolioProject_Covid19..[covid-deaths]
order by 5 desc

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathsPercentage
From PortfolioProject_Covid19..[covid-deaths]
Where location = 'Italy'
order by 1,2

-- Total cases vs Population
-- Shows what percentage of population infected with Covid

Select Location, date, population, total_cases, (total_cases/population)*100 as Population_Infected_Percentage
From PortfolioProject_Covid19..[covid-deaths]
Where location = 'Italy'
order by 2

-- Highest Infection Rate countries

Select Location, Population, MAX(total_cases) as Highest_Infection_Count, MAX((total_cases/population))*100 as Population_Infected_Percentage
From PortfolioProject_Covid19..[covid-deaths]
group by Location, Population
order by Population_Infected_Percentage desc

-- Highest Deaths Countries per population

Select Location, MAX(cast(Total_deaths as int)) as Total_Deaths_Count
From PortfolioProject_Covid19..[covid-deaths]
where continent is not null
group by Location, Population
order by Total_Deaths_Count desc

-- By continent

Select location, MAX(cast(Total_deaths as int)) as Total_Deaths_Count
From PortfolioProject_Covid19..[covid-deaths]
where continent is null
group by location
order by Total_Deaths_Count desc

Select continent, MAX(cast(Total_deaths as int)) as Total_Deaths_Count
From PortfolioProject_Covid19..[covid-deaths]
where continent is not null
group by continent
order by Total_Deaths_Count desc

-- Global numbers

-- Daily new cases and deaths in the world

Select date, SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathsPercentage
From PortfolioProject_Covid19..[covid-deaths]
where continent is not null
group by date
order by 1,2

Select SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathsPercentage
From PortfolioProject_Covid19..[covid-deaths]
where continent is not null
order by 1,2

-- Total population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER (Partition by dea.location 
order by dea.location, dea.date) as Rolling_People_Vaccinated
, 
From PortfolioProject_Covid19..[covid-deaths] dea
join PortfolioProject_Covid19..[covid-vax] vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- CTE

With PopvsVax (Continent, Location, Date, Population, new_vaccinations, Rolling_People_Vaccinated)
as  
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER (Partition by dea.location 
order by dea.location, dea.date) as Rolling_People_Vaccinated
From PortfolioProject_Covid19..[covid-deaths] dea
join PortfolioProject_Covid19..[covid-vax] vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (Rolling_People_Vaccinated/Population)*100
From PopvsVax

-- TEMP TABLE

Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
Rolling_People_Vaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER (Partition by dea.location 
order by dea.location, dea.date) as Rolling_People_Vaccinated
From PortfolioProject_Covid19..[covid-deaths] dea
join PortfolioProject_Covid19..[covid-vax] vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

Select *, (Rolling_People_Vaccinated/Population)*100
From #PercentPopulationVaccinated

-- Creating view to store data for data viz

Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER (Partition by dea.location 
order by dea.location, dea.date) as Rolling_People_Vaccinated
From PortfolioProject_Covid19..[covid-deaths] dea
join PortfolioProject_Covid19..[covid-vax] vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

Select *
From PercentPopulationVaccinated
