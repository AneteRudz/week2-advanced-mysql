## Challenge 1 - Most Profiting Authors

'''
L.S. Good!
'''

### Step 1: Calculate the royalties of each sales for each author
CREATE TEMPORARY TABLE temp_sales_royalty
SELECT titleauthor.title_id, titleauthor.au_id, (titles.price * sales.qty * (titles.royalty/100)*(titleauthor.royaltyper/100)) AS sales_royalty
FROM titleauthor
INNER JOIN titles ON titleauthor.title_id = titles.title_id
INNER JOIN sales ON titles.title_id = sales.title_id
GROUP BY titleauthor.title_id, titleauthor.au_id
ORDER BY sales_royalty DESC;


### Step 2: Aggregate the total royalties for each title for each author
CREATE TEMPORARY TABLE temp_sum_royalties
SELECT titleauthor.title_id, titleauthor.au_id, sum(temp_sales_royalty.sales_royalty) AS sum_royalties
FROM titleauthor
INNER JOIN temp_sales_royalty ON titleauthor.title_id = temp_sales_royalty.title_id
GROUP BY titleauthor.title_id, titleauthor.au_id;


### Step 3: Calculate the total profits of each author
SELECT titleauthor.au_id, sum(titles.advance + temp_sum_royalties.sum_royalties) AS profit
FROM titleauthor
INNER JOIN titles ON titleauthor.title_id = titles.title_id
INNER JOIN temp_sum_royalties ON titles.title_id = temp_sum_royalties.title_id
GROUP BY titleauthor.au_id
ORDER BY profit DESC
LIMIT 3;


'''
L.S. Well done!
'''
## Challenge 2 - Alternative Solution

SELECT titleauthor.au_id, sum(titles.advance + sub_2.sum_royalties) AS profit
FROM (
	SELECT titleauthor.title_id, titleauthor.au_id, sum(sub_1.sales_royalty) AS sum_royalties
	FROM (
		SELECT titleauthor.title_id, titleauthor.au_id, (titles.price * sales.qty * (titles.royalty/100)*(titleauthor.royaltyper/100)) AS sales_royalty
		FROM titleauthor
		INNER JOIN titles ON titleauthor.title_id = titles.title_id
		INNER JOIN sales ON titles.title_id = sales.title_id
		GROUP BY titleauthor.title_id, titleauthor.au_id
		ORDER BY sales_royalty DESC
		) sub_1
	INNER JOIN titleauthor ON sub_1.title_id = titleauthor.title_id
	GROUP BY titleauthor.title_id, titleauthor.au_id
	ORDER BY sum_royalties DESC
	) sub_2
INNER JOIN titleauthor ON sub_2.title_id = titleauthor.title_id
INNER JOIN titles ON titleauthor.title_id = titles.title_id
GROUP BY titleauthor.au_id
ORDER BY profit DESC
LIMIT 3;

'''
L.S. Correct use of the join! Very good! 
'''

## Challenge 3 - create a permanent table

CREATE TABLE most_profiting_authors
SELECT titleauthor.au_id, sum(titles.advance + temp_sum_royalties.sum_royalties) AS profit
FROM titleauthor
INNER JOIN titles ON titleauthor.title_id = titles.title_id
INNER JOIN temp_sum_royalties ON titles.title_id = temp_sum_royalties.title_id
GROUP BY titleauthor.au_id
ORDER BY profit DESC;
