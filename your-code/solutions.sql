-- Challenge 1 - Most Profiting Authors

USE publications;

-- STEP 1 & 2
SELECT ta.title_id , ta.au_id , 
	   ROUND(t.advance * ta.royaltyper / 100) AS advance , 
       SUM(t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) AS total_royalty
FROM titleauthor AS ta

INNER JOIN titles AS t
ON ta.title_id = t.title_id

INNER JOIN sales AS s
ON ta.title_id = s.title_id

GROUP BY ta.au_id,ta.title_id
ORDER BY total_royalty DESC;

-- STEP 3

SELECT au_id, SUM(advance+total_royalty) AS profits
FROM (SELECT ta.title_id , ta.au_id , 
	   ROUND(t.advance * ta.royaltyper / 100) AS advance , 
       ROUND(SUM(t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) )AS total_royalty
FROM titleauthor AS ta
INNER JOIN titles AS t
ON ta.title_id = t.title_id
INNER JOIN sales AS s
ON ta.title_id = s.title_id
GROUP BY ta.au_id,ta.title_id
ORDER BY total_royalty DESC) ro_adv
GROUP BY au_id
ORDER BY profits DESC
LIMIT 3;


-- CHALLENGE 2
-- Creating temporary table

DROP TABLE ro_adv;
CREATE TEMPORARY TABLE ro_adv
SELECT ta.title_id , ta.au_id , 
	   ROUND(t.advance * ta.royaltyper / 100) AS advance , 
       ROUND(SUM(t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) )AS total_royalty
FROM titleauthor AS ta

INNER JOIN titles AS t
ON ta.title_id = t.title_id

INNER JOIN sales AS s
ON ta.title_id = s.title_id

GROUP BY ta.au_id,ta.title_id
ORDER BY total_royalty DESC;

-- query with temporary table:

SELECT au_id, SUM(advance+total_royalty) AS profits
FROM ro_adv
GROUP BY au_id
ORDER BY profits DESC
LIMIT 3;

-- CHALLENGE 3 
DROP TABLE IF EXISTS author_profits;
CREATE TABLE author_profits AS
(SELECT au_id, SUM(advance+total_royalty) AS profits
FROM ro_adv
GROUP BY au_id
ORDER BY profits DESC);

