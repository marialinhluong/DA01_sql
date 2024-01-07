-- ex1
Select NAME from CITY
Where POPULATION >=120000 and COUNTRYCODE like 'USA';
-- ex2
Select * from CITY
Where COUNTRYCODE like 'JPN'
-- ex3
Select CITY, STATE from STATION;
-- ex4
Select distinct CITY from STATION
Where CITY like 'a%'
or CITY like 'e%'
or CITY like 'i%'
or CITY like 'o%'
or CITY like 'u%';
-- ex5
Select distinct CITY from STATION
Where CITY like '%a'
or CITY like '%e'
or CITY like '%i'
or CITY like '%o'
or CITY like '%u';
-- ex6
Select distinct CITY from STATION
Where CITY not like 'a%'
and CITY not like 'e%'
and CITY not like 'i%'
and CITY not like 'o%'
and CITY not like 'u%';
-- ex7
select name from Employee
Order by name;
-- ex8
Select name from Employee
Where salary >=2000 and months <10
Order by employee_id;
-- ex9
select product_id from Products
where low_fats like 'Y' and recyclable like 'Y';
-- ex10
Select name from Customer
Where referee_id is null or referee_id <>2; 
-- ex11
select name,population,area from World
Where area >=3000000 or population >=25000000;
-- ex12
select distinct author_id as id from Views
where author_id =viewer_id
order by id asc;
-- ex13
SELECT part,assembly_step FROM parts_assembly
where finish_date is null;
-- ex14
select * from lyft_drivers
where yearly_salary <=30 or yearly_salary >=70;
-- ex15
select advertising_channel from uber_advertising
where year =2019 and money_spent >100;
