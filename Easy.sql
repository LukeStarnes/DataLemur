--Given a table of candidates and their skills, you're tasked with finding the candidates best suited for an open Data Science job. 
--You want to find candidates who are proficient in Python, Tableau, and PostgreSQL.
--Write a query to list the candidates who possess all of the required skills for the job. Sort the output by candidate ID in ascending order.
SELECT candidate_id
FROM candidates
WHERE skill IN ('Python', 'Tableau', 'PostgreSQL')
GROUP BY candidate_id
HAVING count(*) = 3
ORDER BY candidate_id

--Assume you're given the tables below about Facebook Page and Page likes (as in "Like a Facebook Page").
--Write a query to return the IDs of the Facebook pages which do not possess any likes. The output should be sorted in ascending order.
SELECT pages.page_id
FROM pages
LEFT JOIN page_likes
ON pages.page_id = page_likes.page_id
WHERE page_likes.liked_date IS NULL
ORDER BY page_id

--Tesla is investigating production bottlenecks and they need your help to extract the relevant data. 
--Write a query that determines which parts with the assembly steps have initiated the assembly process but remain unfinished.
--Assumptions:
----parts_assembly table contains all parts currently in production, each at varying stages of the assembly process.
----An unfinished part is one that lacks a finish_date.
SELECT part, assembly_step
FROM parts_assembly
WHERE finish_date IS NULL

--Assume you're given a table Twitter tweet data, write a query to obtain a histogram of tweets posted per user in 2022. 
--Output the tweet count per user as the bucket and the number of Twitter users who fall into that bucket.
--In other words, group the users by the number of tweets they posted in 2022 and count the number of users in each group.
SELECT NumberOfTweetsPerUser AS tweet_bucket, Count(*) AS users_num
FROM
  (SELECT user_id, COUNT(tweet_id) AS NumberOfTweetsPerUser
  FROM tweets
  WHERE tweet_date BETWEEN '2022-01-01' AND '2022-12-31'
  GROUP BY user_id) AS total_tweets
GROUP BY NumberOfTweetsPerUser

--Assume you're given the table on user viewership categorised by device type where the three types are laptop, tablet, and phone.
--Write a query that calculates the total viewership for laptops and mobile devices where mobile is defined as the sum of tablet and phone viewership. 
--Output the total viewership for laptops as laptop_reviews and the total viewership for mobile devices as mobile_views.
SELECT 
COUNT(*) FILTER (WHERE device_type = 'laptop') AS laptop_views,
COUNT(*) FILTER (WHERE device_type IN ('tablet','phone')) AS mobile_views
FROM viewership 

--Assume you are given the table below that shows job postings for all companies on the LinkedIn platform. 
--Write a query to get the number of companies that have posted duplicate job listings.
----Clarification:
----Duplicate job listings refer to two jobs at the same company with the same title and description.
WITH t1 AS
(SELECT company_id, title, description, count(*) AS job_count 
FROM job_listings
GROUP BY company_id, title, description)
SELECT count(*) AS co_w_duplicate_jobs 
FROM t1 
WHERE job_count > 1

--Given a table of Facebook posts, for each user who posted at least twice in 2021, write a query to find the number of days between each user’s first post of the year and last post of the year in the year 2021. 
--Output the user and number of the days between each user's first and last post.
SELECT user_id, max(post_date)::date - min(post_date)::date AS days_between
FROM posts
WHERE DATE_PART('year', post_date::DATE) = 2021 
GROUP BY user_id
HAVING Count(*) > 1

--Write a query to identify the top 2 Power Users who sent the highest number of messages on Microsoft Teams in August 2022. 
--Display the IDs of these 2 users along with the total number of messages they sent. Output the results in descending order based on the count of the messages.
----Assumption:
----No two users have sent the same number of messages in August 2022.
SELECT sender_id, count(*) AS message_count 
FROM messages
WHERE EXTRACT(MONTH FROM sent_date) = '8' AND EXTRACT(YEAR FROM sent_date) = '2022'
GROUP BY sender_id
ORDER BY message_count DESC
LIMIT 2

--Assume you're given the tables containing completed trade orders and user details in a Robinhood trading system.
--Write a query to retrieve the top three cities that have the highest number of completed trade orders listed in descending order. 
--Output the city name and the corresponding number of completed trade orders.
SELECT users.city, count(*) AS total_orders
FROM trades
JOIN users
ON trades.user_id = users.user_id
WHERE trades.status = 'Completed'
GROUP BY users.city
ORDER BY total_orders DESC
LIMIT 3

--Given the reviews table, write a query to retrieve the average star rating for each product, grouped by month. 
--The output should display the month as a numerical value, product ID, and average star rating rounded to two decimal places. 
--Sort the output first by month and then by product ID.
SELECT 
  EXTRACT(MONTH FROM submit_date) AS mth,
  product_id,
  ROUND(AVG(stars), 2) AS avg_stars
FROM reviews
GROUP BY 
  EXTRACT(MONTH FROM submit_date), 
  product_id
ORDER BY mth, product_id;

--Assume you have an events table on Facebook app analytics. 
--Write a query to calculate the click-through rate (CTR) for the app in 2022 and round the results to 2 decimal places.
----Definition and note:
----Percentage of click-through rate (CTR) = 100.0 * Number of clicks / Number of impressions
----To avoid integer division, multiply the CTR by 100.0, not 100.
SELECT app_id, 
ROUND(100.0 
* SUM(CASE WHEN event_type = 'click' THEN 1 ELSE 0 END)
/ SUM(CASE WHEN event_type = 'impression' THEN 1 ELSE 0 END)
,2) AS ctr_rate
FROM events
WHERE timestamp >= '2022-01-01' AND timestamp < '2023-01-01'
GROUP BY app_id

--Assume you're given tables with information about TikTok user sign-ups and confirmations through email and text. 
--New users on TikTok sign up using their email addresses, and upon sign-up, 
--each user receives a text message confirmation to activate their account.
--Write a query to display the user IDs of those who did not confirm their sign-up on the first day, but confirmed on the second day.
----Definition:
----action_date refers to the date when users activated their accounts and confirmed their sign-up through text messages.
SELECT user_id
FROM emails
JOIN texts
ON emails.email_id = texts.email_id
WHERE signup_action = 'Confirmed'
AND texts.action_date = emails.signup_date + INTERVAL '1 day'

-- Your team at JPMorgan Chase is soon launching a new credit card, and to gain some context, you are analyzing how many credit cards were issued each month.
--Write a query that outputs the name of each credit card and the difference in issued amount between the month with the most cards issued, 
--and the least cards issued. Order the results according to the biggest difference.
SELECT card_name, MAX(issued_amount) - MIN(issued_amount) AS difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY difference DESC

--You're trying to find the mean number of items per order on Alibaba, rounded to 1 decimal place using tables which includes information on the count of items in each order (item_count table) 
--and the corresponding number of orders for each item count (order_occurrences table).
SELECT ROUND(SUM(order_occurrences*1.0 * item_count)/sum(order_occurrences),1)
FROM items_per_order;
