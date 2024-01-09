-- ex1
select distinct CITY from STATION
where ID%2=0
group by city
-- ex2
select (count(ID)-count(distinct CITY)) from STATION
-- ex4
SELECT 
round(cast(sum(item_count*order_occurrences)/sum(order_occurrences) as decimal),1)
FROM items_per_order
-- ex5
SELECT candidate_id FROM candidates
where skill in('Python','Tableau','PostgreSQL')
GROUP BY candidate_id
having count(skill)=3
-- ex6
select user_id,
date(max(post_date))-date(min(post_date)) as days_between
from posts
where post_date>='2021-01-01' and post_date<'2022-01-01'
group by user_id
having count(post_id)>=2
-- ex7
SELECT card_name,
max(issued_amount)-min(issued_amount) as difference
FROM monthly_cards_issued
GROUP BY card_name
order by difference desc
-- ex8
SELECT manufacturer,
count(drug) as drug_count,
abs(sum(cogs-total_sales)) as total_loss
FROM pharmacy_sales
where total_sales<cogs
GROUP BY manufacturer
order by total_loss desc
-- ex9
select movie from Cinema
where id%2=1 and description not like 'boring'
-- ex10
select movie from Cinema
where id%2=1 and description not like 'boring'
-- ex11
select user_id,
count(follower_id) as followers_count
from Followers
group by user_id
order by user_id
-- ex12
select class from Courses
group by class
having count(student)>=5

