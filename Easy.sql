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
