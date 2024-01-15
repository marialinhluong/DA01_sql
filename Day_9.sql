--ex1
select
sum(case
   when device_type='laptop'then 1
   else 0
end) as laptop_reviews,
sum(case
   when device_type<>'laptop'then 1
   else 0
end) as mobile_views
from viewership
-- ex2
Select x, y,z,
case
  when x+y>z and y+z>x and x+z>y then 'Yes'
  else 'No'
end as triangle
from triangle
-- ex3
SELECT
round(cast(sum(CASE
  when call_category= 'n/a' or call_category= ' ' then 1
  else 0
end) as int)/(cast(count(case_id) as int)*100),1) as call_percentage
from callers
-- ex4:
select name from Customer
where referee_id<>2 or referee_id is null
-- ex5:
SELECT
    survived,
    SUM(CASE WHEN pclass = 1 THEN 1 ELSE 0 END) AS first_class,
    SUM(CASE WHEN pclass = 2 THEN 1 ELSE 0 END) AS second_class,
    SUM(CASE WHEN pclass = 3 THEN 1 ELSE 0 END) AS third_class
FROM
    titanic
GROUP BY
    survived
ORDER BY
    survived;
