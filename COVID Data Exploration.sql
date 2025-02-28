select* 
from protifolio_project..CovidDeaths
where continent is not null
order by 3,4




select location ,date ,total_cases , total_deaths , new_cases,population 
 from protifolio_project..CovidDeaths
 where continent is not null
 order by 1,2 ;



 --__________________________________________________________________________________________________________
 --total Cases VS total Daths
select location , date , total_deaths , total_cases ,(total_deaths/total_cases)*100
as prs_deaths
from CovidDeaths
where location like ('%states%')
order by 1,2;


--___________________________________________________________________________________________________________
--look at total_cases vs population

select location , date , total_cases ,population ,(total_deaths/population)*100
from covidDeaths
where location like ('%egypt%') 
order by 1,2;


--____________________________________________________________________________________________________________
-- countries whith highst infection rate compared

select location ,population ,max(total_cases) as high_infc_cont,max((total_cases/population))*100
as percent_populatio_infected
from covidDeaths 
group by location ,population 
order by percent_populatio_infected desc;


--______________________________________________________________________________________________________________



select location ,max(cast(total_deaths as int))as cont_death
from CovidDeaths
where continent is null
group by location  
order by cont_death desc;


--_____________________________________________________________________________________________
--Breaking things Down By CoNtinent
----showing countries with the highest death count per population
select continent,max(cast(total_deaths as int))as cont_death
from CovidDeaths
where continent is not null
group by continent
order by cont_death desc;

--___________________________________________________________________________________________________
--global number

select  date , sum(total_cases) ,sum(cast (total_deaths as int ))
,sum( cast(total_deaths as int))/sum(total_cases)*100
from protifolio_project..CovidDeaths
where continent is not null
group by date 
order by 1,2;


--__________________________________________________________________________________________________
-- looking at total population vs vaccinations

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


--________________________________________________________________________________________________
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


--_________________________________________________________________________________

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


--_________________________________________________________________________________________________________________
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




