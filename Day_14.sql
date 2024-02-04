--ex1
WITH YearlySpend AS (
  SELECT
    EXTRACT(YEAR FROM transaction_date) AS yr,
    product_id,
    SUM(spend) AS curr_year_spend
  FROM
    user_transactions
  GROUP BY
    yr, product_id)
SELECT
  curr.yr,
  curr.product_id,
  curr.curr_year_spend,
  LAG(curr.curr_year_spend) OVER (PARTITION BY curr.product_id ORDER BY curr.yr) AS prev_year_spend,
  ROUND((curr.curr_year_spend - LAG(curr.curr_year_spend) OVER (PARTITION BY curr.product_id ORDER BY curr.yr)) / LAG(curr.curr_year_spend) OVER (PARTITION BY curr.product_id ORDER BY curr.yr) * 100, 2) AS yoy_rate
FROM
  YearlySpend curr
ORDER BY
  curr.product_id,
  curr.yr;

--ex2
WITH RankedIssued AS (
  SELECT
    card_name,
    issued_amount,
    ROW_NUMBER() OVER (PARTITION BY card_name ORDER BY issue_year, issue_month) AS rnk
  FROM
    monthly_cards_issued)
SELECT
  card_name,
  issued_amount
FROM
  RankedIssued
WHERE
  rnk = 1
ORDER BY
  issued_amount DESC;

--ex3
WITH RankedTransactions AS (
  SELECT
    user_id,
    spend,
    transaction_date,
    ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY transaction_date) AS transaction_rank
  FROM
    transactions)
SELECT
  user_id,
  spend,
  transaction_date
FROM
  RankedTransactions
WHERE
  transaction_rank = 3;

--ex4
WITH latest_transactions AS (
  SELECT
    user_id,
    transaction_date,
    product_id,
    RANK() OVER (PARTITION BY user_id 
      ORDER BY transaction_date DESC) AS transaction_rank 
  FROM user_transactions) 
SELECT
  transaction_date,
  user_id,
  COUNT(product_id) AS purchase_count
FROM
  latest_transactions
WHERE
  transaction_rank = 1
GROUP BY transaction_date, user_id
ORDER BY
  transaction_date;

--ex5
WITH RollingAvg AS (
  SELECT
    user_id,
    tweet_date,
    tweet_count,
    AVG(tweet_count) OVER (PARTITION BY user_id ORDER BY tweet_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
    AS rolling_avg_3d
  FROM tweets)
SELECT
  user_id,
  tweet_date,
  ROUND(rolling_avg_3d, 2) AS rolling_avg_3d
FROM
  RollingAvg
ORDER BY
  user_id, tweet_date;

--ex6
WITH RepeatedPayments AS
  (SELECT
    transaction_id,
    merchant_id,
    credit_card_id,
    amount,
    transaction_timestamp,
    LAG(transaction_timestamp) OVER (PARTITION BY merchant_id, credit_card_id, amount ORDER BY transaction_timestamp) AS prev_transaction_timestamp
  FROM
    transactions)
SELECT
  COUNT(DISTINCT transaction_id) AS payment_count
FROM
  RepeatedPayments
WHERE
  EXTRACT(EPOCH FROM (transaction_timestamp - prev_transaction_timestamp)) / 60 <= 10
  AND prev_transaction_timestamp IS NOT NULL;

--ex7
WITH CategoryProductSpend AS
  (SELECT
        category,
        product,
        SUM(spend) AS total_spend
    FROM
        product_spend
    WHERE
        EXTRACT(year FROM transaction_date) = 2022
    GROUP BY
        category, product),
RankedProducts AS
  (SELECT
        category,
        product,
        total_spend,
        RANK() OVER (PARTITION BY category ORDER BY total_spend DESC) AS product_rank
    FROM
        CategoryProductSpend)
SELECT
    category,
    product,
    total_spend
FROM
    RankedProducts
WHERE
    product_rank <= 2;

--ex8
WITH RankedArtists
  AS(SELECT
    a.artist_id,
    a.artist_name,
    DENSE_RANK() OVER (ORDER BY COUNT(gsr.song_id) DESC) AS artist_rank
  FROM
    artists a
    JOIN songs s ON a.artist_id = s.artist_id
    JOIN global_song_rank gsr ON s.song_id = gsr.song_id
  WHERE
    gsr.rank <= 10
  GROUP BY
    a.artist_id, a.artist_name)
SELECT
  artist_name,
  artist_rank
FROM
  RankedArtists
WHERE
  artist_rank <= 5
ORDER BY
  artist_rank;
