select * from protifolio_project..CovidVaccinations
  order by 3,4 ;

  select * from protifolio_project..CovidDeaths 
  order by 3,4;


  select * from protifolio_project..CovidDeaths 
  where continent is Not null
  order by 3,4;


 select location ,date ,total_cases , total_deaths , new_cases,population 
 from protifolio_project..CovidDeaths
 order by 1,2 ;

 --looking at total new_cases

 select location , date , new_cases
 from protifolio_project..CovidDeaths 
 order by 1,2;


 
 select max(new_cases)
 from CovidDeaths
 
 select sum (new_cases)
 from CovidDeaths;

 SELECT 
    MONTH(date) AS Month, 
    YEAR(date) AS Year, 
    MAX(new_cases) AS MaxCases
FROM CovidDeaths
GROUP BY YEAR(date), MONTH(date)
ORDER BY Year, Month;

 -- looking at total cases 
 select total_cases from CovidDeaths;
select sum(total_cases)from CovidDeaths;
select max(total_cases)from CovidDeaths;

select date , total_cases from CovidDeaths;

 -- looking total death vs total case
select location ,date , total_deaths , total_cases ,(total_deaths/total_cases)*100
as prsnt_deaths
from CovidDeaths 
order by 1,2;

select location , date , total_deaths , total_cases ,(total_deaths/total_cases)*100
as prs_deaths
from CovidDeaths
where location like ('%states%')
order by 1,2;



--look at total_cases vs population
select location , date , total_deaths ,population ,(total_deaths/population)*100
from covidDeaths
where location like ('%egypt%')
order by 1,2;

--look at countries whith highst infection rate compared
select location ,population ,max(total_cases) as high_infc_cont,max((total_cases/population))*100
as percent_populatio_infected
from covidDeaths 
group by location ,population 
order by percent_populatio_infected;

--showing countries with highest death count per population
select location ,population,max(total_deaths)as cont_death
from CovidDeaths
group by location , population 
order by cont_death desc;


select location ,population,max(cast(total_deaths as int))as cont_death
from CovidDeaths
group by location , population 
order by cont_death desc;

select location ,population,max(cast(total_deaths as int))as cont_death
from CovidDeaths
where continent is not null
group by location , population 
order by cont_death desc;

select location ,sum(cast(new_deaths as int))as Total_death_Count
from protifolio_project..CovidDeaths
where continent is  null
and location not in('World','European Union','International')
group by location  
order by Total_death_Count desc;

-- عشان متعرض القارات خلينا ال continent is not null

--global number
select  date , sum(total_cases) ,sum(cast (total_deaths as int ))
,sum( cast(total_deaths as int))/sum(total_cases)*100
from protifolio_project..CovidDeaths
where continent is not null
group by date 
order by 1,2;

select  /*date**/  sum(total_cases) ,sum(cast (total_deaths as int ))
,sum( cast(total_deaths as int))/sum(total_cases)*100
from protifolio_project..CovidDeaths
where continent is not null
--group by date 
order by 1,2;

select  /*date**/  sum(new_cases)as total_cases ,sum(cast (new_deaths as int ))as Total_Deathes
,sum( cast(total_deaths as int))/sum(total_cases)*100 as Death_percentage
from protifolio_project..CovidDeaths
where continent is not null
--group by date 
order by 1,2;



select * 
from protifolio_project..CovidDeaths D join protifolio_project..CovidVaccinations V  
on D.location = V.location 
and D.date =V.date


-- looking at total population vs vaccinations
select D.continent ,D.location ,D.date , D.population ,V.new_vaccinations
from protifolio_project..CovidDeaths D 
join protifolio_project..CovidVaccinations V
on D.location = V.location 
and D.date =V.date

select D.continent ,D.location ,D.date , D.population ,V.new_vaccinations
,sum(convert(int,V.new_vaccinations  )) over (partition by D.location)
from protifolio_project..CovidDeaths D 
join protifolio_project..CovidVaccinations V
on D.location = V.location 
and D.date =V.date
where D.continent is not null
order by 2,3;

select D.continent ,D.location ,D.date , D.population ,V.new_vaccinations
,sum(convert(int,V.new_vaccinations  )) over (partition by D.location order by D.location,D.date)
as Rolling_people_Vaccinated
--,(Rolling_people_Vaccinated/population)*100
from protifolio_project..CovidDeaths D 
join protifolio_project..CovidVaccinations V
on D.location = V.location 
and D.date =V.date
where D.continent is not null
order by 2,3;

--USE CTE
with Poe_vs_Vac(continent,location ,date, population ,new_Vaccinations,Rolling_people_Vaccinated)
as(
select D.continent ,D.location ,D.date , D.population ,V.new_vaccinations
,sum(convert(int,V.new_vaccinations  )) over (partition by D.location order by D.location,D.date)
as Rolling_people_Vaccinated
--,(Rolling_people_Vaccinated/population)*100
from protifolio_project..CovidDeaths D 
join protifolio_project..CovidVaccinations V
on D.location = V.location 
and D.date =V.date
where D.continent is not null
--order by 2,3;
)
select *,(Rolling_people_Vaccinated/Population)*100
from Poe_vs_Vac


--temp table
drop table if exists #Percent_Population_Vaccinated
create table #Percent_Population_Vaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime ,
Population numeric,
new_vaccination numeric,
Rolling_people_Vaccinated numeric
)
insert into #Percent_Population_Vaccinated
select D.continent ,D.location ,D.date , D.population ,V.new_vaccinations
,sum(convert(int,V.new_vaccinations  )) over (partition by D.location order by D.location,D.date)
as Rolling_people_Vaccinated
--,(Rolling_people_Vaccinated/population)*100
from protifolio_project..CovidDeaths D 
join protifolio_project..CovidVaccinations V
on D.location = V.location 
and D.date =V.date
--where D.continent is not null
--order by 2,3;
select *,(Rolling_people_Vaccinated/Population)*100
from #Percent_Population_Vaccinated;

--create view to stor data for later vizualization

create view Percent_Population_Vaccinated as
select D.continent ,D.location ,D.date , D.population ,V.new_vaccinations
,sum(convert(int,V.new_vaccinations  )) over (partition by D.location order by D.location,D.date)
as Rolling_people_Vaccinated
--,(Rolling_people_Vaccinated/population)*100
from protifolio_project..CovidDeaths D 
join protifolio_project..CovidVaccinations V
on D.location = V.location 
and D.date =V.date
where D.continent is not null
--order by 2,3;

DROP VIEW Percent_Population_Vaccinated;

select *
from  Percent_Population_Vaccinated;


select  Location, Population, max(total_cases)as highest_Infection_Count ,max((total_cases /population ))*100 as Percent_Population_Infected 
from protifolio_project..CovidDeaths
group by Location , Population  
order by Percent_Population_Infected desc;

select  Location, Population ,date, max(total_cases)as highest_Infection_Count ,max((total_cases /population ))*100 as Percent_Population_Infected 
from protifolio_project..CovidDeaths
group by Location , Population ,date
order by Percent_Population_Infected desc;