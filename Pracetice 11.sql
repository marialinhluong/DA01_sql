--- PRACTICE DAY11
--ex1. 
SELECT COUNTRY.Continent,
FLOOR(AVG(CITY.Population)) AS average_city_populations FROM CITY
INNER JOIN COUNTRY ON CITY.CountryCode = COUNTRY.Code
GROUP BY COUNTRY.Continent;
--ex2
SELECT ROUND(CAST(COUNT(texts.email_id) AS decimal)/COUNT(DISTINCT emails.email_id),2)
AS confirm_rate FROM emails
LEFT JOIN texts ON emails.email_id=texts.email_id
AND texts.signup_action = 'Confirmed';
--ex3
SELECT
    age_breakdown.age_bucket AS age_bucket,
    ROUND(CAST(SUM(CASE WHEN activities.activity_type = 'send' THEN activities.time_spent ELSE 0 END) /
                SUM(CASE WHEN activities.activity_type IN ('send', 'open')
					THEN activities.time_spent ELSE 0 END) * 100.0 AS DECIMAL), 2)
					AS send_perc,
    ROUND(CAST(SUM(CASE WHEN activities.activity_type = 'open' THEN activities.time_spent ELSE 0 END) /
                SUM(CASE WHEN activities.activity_type IN ('send', 'open')
					THEN activities.time_spent ELSE 0 END) * 100.0 AS DECIMAL), 2)
					AS open_perc
FROM
    activities
FULL JOIN
    age_breakdown ON age_breakdown.user_id = activities.user_id
WHERE
    (activities.activity_type = 'send' OR activities.activity_type = 'open') AND
    age_breakdown.age_bucket IS NOT NULL
GROUP BY
    age_breakdown.age_bucket;
--ex4
SELECT
    a.customer_id
FROM
    customer_contracts a
JOIN
    products b ON a.product_id = b.product_id
GROUP BY
    a.customer_id
HAVING
    COUNT(DISTINCT b.product_category) = (SELECT COUNT(DISTINCT product_category) FROM products);
--ex5
SELECT
    a.employee_id,
    a.name,
    COUNT(b.employee_id) AS reports_count,
    ROUND(AVG(b.age), 0) AS average_age
FROM
    Employees a
JOIN
    Employees b ON a.employee_id = b.reports_to
WHERE
    a.reports_to IS NULL
GROUP BY
    a.employee_id, a.name
ORDER BY
    a.employee_id;
--ex6
SELECT
    products.product_name,
    SUM(orders.unit) AS unit
FROM
    orders
JOIN
    products ON products.product_id = orders.product_id
WHERE
    EXTRACT(MONTH FROM orders.order_date) = 2
    AND EXTRACT(YEAR FROM orders.order_date) = 2020
GROUP BY
    products.product_name
HAVING
    SUM(orders.unit) >= 100;
--ex7
SELECT
    pages.page_id
FROM
    pages
LEFT JOIN
    page_likes ON pages.page_id = page_likes.page_id
WHERE
    page_likes.page_id IS NULL
ORDER BY
    pages.page_id;
	
--- MID-TEST

-- Question 1-Distinct
select distinct(replacement_cost) from film
order by replacement_cost

-- Question 2-Case-Group by
SELECT film_id,
  CASE
    WHEN replacement_cost >= 9.99 AND replacement_cost <= 19.99 THEN 'low'
    WHEN replacement_cost >= 20.00 AND replacement_cost <= 24.99 THEN 'medium'
    WHEN replacement_cost >= 25.00 AND replacement_cost <= 29.99 THEN 'high'
    ELSE '0'
  END AS overall,
FROM film
GROUP BY film_id

SELECT 
  COUNT(DISTINCT CASE
        WHEN replacement_cost >= 9.99 AND replacement_cost <= 19.99 THEN film_id
        ELSE NULL
      END)
FROM FILM;

-- Question 3-JOIN
SELECT 
    film.title,
    film.length,
    category.name
FROM 
    category
JOIN 
    film_category ON category.category_id = film_category.category_id
JOIN 
    film ON film_category.film_id = film.film_id
WHERE 
    category.name IN ('Drama','Sports')
GROUP BY 
    film.film_id, category.name
ORDER BY 
    film.length DESC;

-- Question 4 - JOIN & GROUP BY
SELECT 
    category.name,
    COUNT(film.film_id) AS film_count
FROM 
    category
JOIN 
    film_category ON category.category_id = film_category.category_id
JOIN 
    film ON film_category.film_id = film.film_id
GROUP BY 
    category.name
ORDER BY 
    film_count DESC;

-- Question 5
SELECT actor.first_name, actor.last_name,
COUNT(film_actor.film_id) AS film_count FROM film_actor
JOIN 
    actor ON actor.actor_id = film_actor.actor_id
GROUP BY actor.first_name, actor.last_name
ORDER BY 
    film_count DESC;
	
-- Question 6 - LEFT JOIN & FILTERING
select * from  customer address
SELECT customer.customer_id,address.address from address
left join customer on customer.address_id=address.address_id
where customer.customer_id is null
group by customer.customer_id,address.address

-- Question 7 - JOIN & GROUP BY
select * from city cicty.city city_id
select * from country
select * from address city_id address_id
select * from customer cusstomer_id address_id
select * from payment amount customer_id
SELECT city.city, sum(payment.amount) as total_amount from payment
JOIN customer ON customer.customer_id=payment.customer_id
JOIN address ON address.address_id=customer.address_id
JOIN city ON city.city_id=address.city_id
GROUP BY city.city
ORDER BY total_amount DESC;

-- Question 8 - JOIN & GROUP BY
SELECT (city.city || ', ' || country.country) as city_country,
       SUM(payment.amount) as total_amount from payment
JOIN customer ON customer.customer_id=payment.customer_id
JOIN address ON address.address_id=customer.address_id
JOIN city ON city.city_id=address.city_id
JOIN country on country.country_id=city.country_id
GROUP BY country.country, city.city
ORDER BY total_amount DESC;
