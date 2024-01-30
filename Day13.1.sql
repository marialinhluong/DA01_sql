-- ex.1-Duplicate Job Listings [Linkedin SQL Interview Question]
 -- C1. Join
 SELECT COUNT(DISTINCT a.company_id) as duplicate_companies
FROM job_listings a
JOIN job_listings b ON a.company_id = b.company_id
                   AND a.title = b.title
                   AND a.description = b.description
WHERE a.job_id < b.job_id;  
-- C2. CTEs
WITH DuplicateJobListings AS (
    SELECT 
        a.company_id,
        a.title,
        a.description,
        COUNT(*) AS duplicate_count
    FROM 
        job_listings a
    JOIN 
        job_listings b ON a.company_id = b.company_id
                       AND a.title = b.title
                       AND a.description = b.description
    WHERE 
        a.job_id < b.job_id
    GROUP BY 
        a.company_id, a.title, a.description
    HAVING 
        COUNT(*) >= 1
)
SELECT 
    COUNT(DISTINCT company_id) AS duplicate_companies
FROM 
    DuplicateJobListings;

--- ex.2 - Highest-Grossing Items [Amazon SQL Interview Question]
WITH CategoryProductSpend AS (
    SELECT
        category,
        product,
        SUM(spend) AS total_spend
    FROM
        product_spend
    WHERE
        EXTRACT(year FROM transaction_date) = 2022
    GROUP BY
        category, product
),
RankedProducts AS (
    SELECT
        category,
        product,
        total_spend,
        RANK() OVER (PARTITION BY category ORDER BY total_spend DESC) AS product_rank
    FROM
        CategoryProductSpend
)
SELECT
    category,
    product,
    total_spend
FROM
    RankedProducts
WHERE
    product_rank <= 2;

-- ex.3 - Patient Support Analysis (Part 1) [UnitedHealth SQL Interview Question]
WITH CallerCounts AS (
    SELECT
        policy_holder_id,
        COUNT(DISTINCT case_id) AS call_count
    FROM
        callers
    GROUP BY
        policy_holder_id
    HAVING
        COUNT(DISTINCT case_id) >= 3
)
SELECT
    COUNT(*) AS member_count
FROM
    CallerCounts;
-- ex.4 - Page With No Likes [Facebook SQL Interview Question]
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

-- ex.5 - Active User Retention [Facebook SQL Interview Question]
WITH ActiveUsers AS (
    SELECT
        user_id,
        EXTRACT(month FROM event_date) AS month
    FROM
        user_actions
    WHERE
        EXTRACT(YEAR FROM event_date) = 2022
    GROUP BY
        user_id, EXTRACT(month FROM event_date)
    HAVING
        COUNT(DISTINCT event_date) >= 2
)
SELECT
    7 AS month,
    COUNT(DISTINCT user_id) AS monthly_active_users
FROM
    ActiveUsers
WHERE
    user_id IN(
	SELECT DISTINCT user_id FROM user_actions
	WHERE EXTRACT(YEAR FROM event_date)=2022 AND
		  EXTRACT(MONTH FROM event_date)=6)
-- ex.6 - Monthly Transaction
SELECT 
    TO_CHAR(trans_date,'yyyy-mm') as month,
    country,
    COUNT(*) AS trans_count,
    SUM(CASE WHEN state = 'approved' THEN 1 ELSE 0 END) AS approved_count,
    SUM(amount) AS trans_total_amount,
    SUM(CASE WHEN state = 'approved' THEN amount ELSE 0 END) AS approved_total_amount
FROM 
    Transactions
GROUP BY 
    month, country;
-- Ex.7 1070. Product Sales Analysis III
WITH FirstYearSales AS (
    SELECT
        a.product_id,
        MIN(a.year) AS first_year
    FROM
        Sales a
    GROUP BY
        a.product_id
)
SELECT
    a.product_id,
    b.first_year,
    a.quantity,
    a.price
FROM
    FirstYearSales b
JOIN
    Sales a ON b.product_id = a.product_id AND b.first_year = a.year;
-- ex8. 1045. Customers Who Bought All Products
WITH AllProducts AS (
    SELECT DISTINCT product_key
    FROM Product
),
CustomerProductCounts AS (
    SELECT
        customer_id,
        COUNT(DISTINCT product_key) AS purchased_product_count
    FROM
        Customer
    WHERE
        product_key IN (SELECT product_key FROM AllProducts)
    GROUP BY
        customer_id
)
SELECT
    customer_id
FROM
    CustomerProductCounts
WHERE
    purchased_product_count = (SELECT COUNT(DISTINCT product_key) FROM AllProducts);
-- ex.9 - 1978. Employees Whose Manager Left the Company
WITH LowSalaryEmployees AS (
    SELECT employee_id
    FROM Employees
    WHERE salary < 30000
),
ManagersLeft AS (
    SELECT a.employee_id
    FROM LowSalaryEmployees a
    LEFT JOIN Employees b ON a.employee_id = b.manager_id
    WHERE b.employee_id IS NULL
)
SELECT employee_id
FROM ManagersLeft
ORDER BY employee_id;
-- ex.11 - Movie Rating
WITH UserMovieCounts AS (
    SELECT
        a.user_id,
        a.name,
        COUNT(b.movie_id) AS movie_count
    FROM
        Users a
    LEFT JOIN
        MovieRating b ON a.user_id = b.user_id
    GROUP BY
        a.user_id, a.name
),
MovieAvgRatings AS (
    SELECT
        b.title,
        AVG(mr.rating) AS avg_rating
    FROM
        Movies b
    LEFT JOIN
        MovieRating mr ON b.movie_id = mr.movie_id
    WHERE
        EXTRACT(year FROM mr.created_at) = 2020
        AND EXTRACT(month FROM mr.created_at) = 2
    GROUP BY
        b.title
)
SELECT
    results
FROM (
    SELECT
        umc.name AS results,
        ROW_NUMBER() OVER (ORDER BY umc.movie_count DESC, umc.name) AS rn
    FROM
        UserMovieCounts umc

    UNION ALL

    SELECT
        mar.title AS results,
        ROW_NUMBER() OVER (ORDER BY mar.avg_rating DESC, mar.title) AS rn
    FROM
        MovieAvgRatings mar
) AS combined
ORDER BY
    rn
LIMIT 1;
-- ex.12 - 602. Friend Requests II: Who Has the Most Friends
WITH FriendsCount AS (
    SELECT
        user_id,
        COUNT(DISTINCT friend_id) AS num_friends
    FROM (
        SELECT
            requester_id AS user_id,
            accepter_id AS friend_id
        FROM RequestAccepted

        UNION ALL

        SELECT
            accepter_id AS user_id,
            requester_id AS friend_id
        FROM RequestAccepted
    ) AS friendships
    GROUP BY user_id
)
SELECT
    user_id AS id,
    num_friends AS num
FROM FriendsCount
ORDER BY num_friends DESC, user_id
LIMIT 1;
	
