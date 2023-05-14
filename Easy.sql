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
