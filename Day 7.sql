-- ex1
select name
from STUDENTS
where marks>75
order by right(name,3),ID
-- ex2
select user_id,
upper(left(name,1))||lower(right(name,length(name)-1)) as name
from Users
-- ex3
SELECT manufacturer,
'$'||ceiling(sum(total_sales)/1000000)||' million' as sale
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY floor(sum(total_sales)) DESC, manufacturer ASC
-- ex4
SELECT EXTRACT(month from submit_date),
product_id as product,
ROUND(AVG(stars),2) as avg_stars
from reviews
GROUP BY EXTRACT(month from submit_date),product_id
ORDER BY EXTRACT(month from submit_date),product_id
-- ex5
select sender_id,
count(message_id) as count_message
from messages
WHERE EXTRACT(month from sent_date)=8 and extract(year from sent_date)=2022
GROUP BY sender_id
HAVING count(message_id)>1
ORDER BY count_message DESC
-- ex6
select tweet_id from Tweets
where length(content)>15
-- ex7
select 
to_char(activity_date,'yyyy-mm-dd') as day,
count(distinct user_id) as active_users from Activity
where session_id>=1 and (activity_date between '2019-06-28' AND '2019-07-27')
group by to_char(activity_date,'yyyy-mm-dd')
-- ex8
select count(distinct id) from employees
where extract(month from joining_date) between 01 and 07 and 
extract(year from joining_date)=2022
-- ex9
select 
position('a'in first_name) as position
from worker
where first_name='Amitah'
-- ex10
select substring(title from length(variety)+2 for 4) from winemag_p2
where country='Macedonia'
