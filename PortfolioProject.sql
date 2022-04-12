select * from PortfolioProject..CovidDeaths$
where continent is not null
order by 3,4

--Data that we are going to use

select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths$
where continent is not null 
order by 1,2

--Total cases vs Total deaths for united states

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathpercentage
from PortfolioProject..CovidDeaths$
where location like '%states%' 
and continent is not null 
order by 1,2

--Total cases vs population

select location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths$
where continent is not null 
order by 1,2


-- Countries with Highest Infection Rate compared to Population

select location, population, MAX(total_cases) as Highestcases, MAX((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths$
group by location, population 
order by PercentPopulationInfected desc

-- Countries with Highest Death Count per Population

select location, population, MAX(cast(total_deaths as int)) as Totaldeathcount, MAX((total_deaths/population))*100 as PercentPopulationdied
from PortfolioProject..CovidDeaths$
group by location, population 
order by PercentPopulationdied desc

--Contintents with the highest death count

select continent, MAX(cast(total_deaths as int)) as Totaldeathcount
from PortfolioProject..CovidDeaths$
where continent is not null
group by continent 
order by Totaldeathcount desc

-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths$
where continent is not null 
order by 1,2

-- Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as PeopleVaccinated
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null  
order by 2,3


Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 