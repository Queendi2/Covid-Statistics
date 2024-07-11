USE PortfolioProject;

SELECT 
    location, date, total_cases, new_cases, total_deaths
FROM
    portfolioproject.coviddeaths
ORDER BY 1 , 2;


/*Looking at total cases vs total deaths*/
/*shows likelyhood of dying if you contract covid in your country*/

SELECT 
    location,
    date,
    total_cases,
    total_deaths,
    round((total_deaths / total_cases) * 100,2) AS DeathPercentage
FROM
    portfolioproject.coviddeaths
WHERE
    location LIKE '%Lithuania%'
ORDER BY 1 , 2;

/*Looking at total cases vs population
shows what percentage of population got covid*/
SELECT 
    location,
    date,
    population,
    total_cases,
    Round((total_cases / population) * 100,2) AS PercentageOfInfection
FROM
    portfolioproject.coviddeaths
WHERE
    continent IS NOT NULL
ORDER BY 1 , 2;

/* Looking at  countries with highest infection rate*/
SELECT 
    distinct location,
    population,
    MAX(total_cases) AS HighestInfectionCount,
    Round(MAX((total_cases / population)) * 100,2) AS PercentageOfInfection
FROM
    portfolioproject.coviddeaths
WHERE
    continent IS NOT NULL
GROUP BY location , population
ORDER BY PercentageOfInfection DESC;

/*Showing countries with highest death count per population*/
SELECT 
    location,
    max(cast(Total_Deaths as signed int)) as TotalDeaths 
FROM
    portfolioproject.coviddeaths
WHERE
    continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeaths DESC;

/*Showing continents with the highest death count per calculation*/
SELECT 
    continent,
    MAX(CAST(Total_Deaths AS SIGNED INT)) AS TotalDeaths
FROM
    portfolioproject.coviddeaths
WHERE
    continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeaths DESC;

/*Global numbers*/
SELECT 
    date,
    SUM(total_cases) AS total_cases,
    SUM(CAST(total_deaths AS SIGNED INT)) AS total_deaths,
    Round(SUM(CAST(total_deaths AS SIGNED INT)) / SUM(CAST(total_cases AS SIGNED INT)) * 100,2) AS DeathPercentage
FROM
    portfolioproject.coviddeaths
WHERE
    continent IS NOT NULL
GROUP BY date
ORDER BY 1 , 2;

/*number of cases and deaths overall across the world*/
SELECT 
    SUM(total_cases) AS total_cases,
    SUM(CAST(total_deaths AS SIGNED INT)) AS total_deaths,
    Round(SUM(CAST(total_deaths AS SIGNED INT)) / SUM(CAST(total_cases AS SIGNED INT)) * 100,2) AS DeathPercentage
FROM
    portfolioproject.coviddeaths
WHERE
    continent IS NOT NULL
ORDER BY 1 , 2;

/* looking at total population vs vaccinations*/
Select dea.continent,dea.location,dea.population,dea.date,
Cast(vac.new_vaccinations as signed int), sum(vac.new_vaccinations) over(partition by dea.location order by dea.location,dea.date) as RollingPeopleVacc
from portfolioproject.coviddeaths dea
join portfolioproject.covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent IS NOT NULL;

/*USE CTE to find what precent of population was vaccinated at the that moment*/

with PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVacc)
as
(
Select dea.continent,dea.location,dea.date,dea.population,
Cast(vac.new_vaccinations as signed int), sum(vac.new_vaccinations) over(partition by dea.location order by dea.location,dea.date) as RollingPeopleVacc
from portfolioproject.coviddeaths dea
join portfolioproject.covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent IS NOT NULL
)
select *,Round((RollingPeopleVacc/population)*100,2) as RollingPeopleVaccProcent
from PopvsVac;










