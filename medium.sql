--Assume you're given a table with information on Amazon customers and their spending on products in different categories, 
--write a query to identify the top two highest-grossing products within each category in the year 2022. 
--The output should include the category, product, and total spend.
WITH product_category_spend AS
(SELECT category, product, SUM(spend) AS total_spend
FROM product_spend
WHERE transaction_date >= '2022-01-01' AND transaction_date <= '2022-12-31'
GROUP BY category, product)
,
top_spend AS (
SELECT *, 
RANK() OVER (
PARTITION BY category
ORDER BY total_spend DESC) AS ranking 
FROM product_category_spend)

SELECT category, product, total_spend
FROM top_spend
WHERE ranking <= 2
ORDER BY category, total_spend DESC;


--Assume there are three Spotify tables containing information about the artists, songs, and music charts. 
--Write a query to find the top 5 artists whose songs appear most frequently in the Top 10 of the global_song_rank table.
--Display the top 5 artist names in ascending order, along with their song appearance ranking. 
--Note that if two artists have the same number of song appearances, they should have the same ranking, and the rank numbers should be continuous 
--(i.e. 1, 2, 2, 3, 4, 5).
--For instance, if Ed Sheeran appears in the Top 10 five times and Bad Bunning four times, Ed Sheeran should be ranked 1st, 
--and Bad Bunny should be ranked 2nd.
WITH cte AS (SELECT artist_id, count(*) AS top_ten_charts
FROM songs
JOIN global_song_rank
ON songs.song_id = global_song_rank.song_id
WHERE global_song_rank.rank <=10
GROUP BY artist_id
ORDER BY top_ten_charts DESC),

cte2 AS (SELECT *, DENSE_RANK() 
OVER(ORDER BY top_ten_charts DESC)
AS artist_rank
FROM cte)

SELECT artist_name, artist_rank
FROM cte2
JOIN artists
ON cte2.artist_id = artists.artist_id
WHERE artist_rank <=5
ORDER BY artist_rank, artist_name

