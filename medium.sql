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
