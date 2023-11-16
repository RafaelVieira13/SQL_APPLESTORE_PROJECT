-- Combine all the datasets related to description into one single table
CREATE TABLE appleStore_description_combined AS

SELECT * FROM appleStore_description1

UNION ALL 

SELECT * FROM appleStore_description2

UNION ALL 

SELECT * FROM appleStore_description3

UNION ALL 

SELECT * FROM appleStore_description4

**Exploratory Data Analysis**

-- Let's take a look to the first table (ApplAppleStore)
SELECT * FROM AppleStore

--- Let's count the number of unique products in both tables
Select
	COUNT(DISTINCT id) AS count_id_applestore
    From AppleStore
    
SELECT
	COUNT(DISTINCT id) AS count_id_appleStore_combined
	FROM appleStore_description_combined
    
--- Let's see if our data has missing values
SELECT 
	count(*) as Missing_Values_AppleStore 
	FROM AppleStore
    Where track_name is NULL or prime_genre IS NULL

SELECT 
	COUNT(*) AS Missing_Values_Description_Combined
    FROM appleStore_description_combined
    WHERE track_name is NULL or app_desc IS NULL
    
--- Number of APPS per Genre
SELECT prime_genre, COUNT(prime_genre) AS number_apps
    FROM AppleStore
    GROUP BY prime_genre 
    order BY number_apps DESC

--- Overview of the RATINGS (max, average, min)
SELECT 
	MAX(user_rating) AS Mas_Rating,
    AVG(user_rating) AS Avg_Rating,
    MIN(user_rating) AS Min_Rating
	FROM AppleStore
    
--- Number of Free APPS
SELECT price, COUNT(*) AS number_free_apps
	FROM AppleStore
    where price = 0

--- Number of Paid APPS
SELECT price, COUNT(*) AS number_paid_apps
	FROM AppleStore
    WHERE price > 0
    
--- Number of Paid APPS vs Number of Free APPS
SELECT CASE
			WHEN price > 0 THEN 'Paid'
            ELSE 'Free'
        END AS app_type,
        COUnt(price) as number_apps
      FROM AppleStore
      GROUP BY app_type

** DATA ANALYSIS** 

--- APPS Prices By Genre
SELECT prime_genre, AVG(price) AS avg_price 
	FROM AppleStore
    GROUP BY prime_genre
    ORDER BY avg_price DESC
    

--- TOP 5 Genre of APPS With the Highest Rating
SELECT prime_genre, AVG(user_rating) AS avg_ratings
    FROM AppleStore
    GROUP BY prime_genre
    ORDER BY avg_ratings DESC
    LIMIT 5
    
--- TOP 5 Genre of APPS With the Lowest Rating
SELECT prime_genre, AVG(user_rating) AS avg_ratings
	FROM AppleStore
    GROUP BY prime_genre
    ORDER BY avg_ratings ASC
    LIMIT 5
    
--- Determine whether paid apps have higher ratings than paid apps
SELECT CASE
			WHEN price > 0 THEN 'Paid'
            ELSE 'Free'
        END AS app_type,
        AVG(user_rating) AS average_ratings
    FROM AppleStore
    group by app_type
    ORDER BY average_ratings DESC
    
 --- Check if apps with more supported languages have higher ratings
 ----- 1. Let's see the max, the average and the minimum number of languages by app
 SELECT
 	MAX(lang_num) AS max_languages,
 	AVG(lang_num) AS average_laguages,
    MIN(lang_num) AS min_languages
 	FROM AppleStore

----- 2. Let's define a app with less than 10 languages as 'low_lang', 10-30 'int_lang' and more than 10 as 'high_lang'
SELECT CASE
			WHEN lang_num < 10 THEN '<10 languages'
            WHEN lang_num BETWEEN 10 AND 30 THEN '10-30 languages'
            ELSE '>30 languages'
       END As lang_class, 
       		  AVG(user_rating) AS avg_ratings
       FROM AppleStore
       GROUP BY lang_class
       ORDER BY avg_ratings DESC

--- Check if there is a correlation between the lenght of the app description and the user rating
-----1. Let's get the data we need and join the APPAppleStore table with the aappleStore_description_combined table based on the id
SELECT CASE
			WHEN length(b.app_desc) < 500 THEN 'Short'
            WHEN length(b.app_desc) BETWEEN 500 AND 1000 THEN 'Medium'
            ELSE 'Long'
         END AS description_length,
         AVG(a.user_rating) AS avg_rating
         
FROM AppleStore as a
JOIN appleStore_description_combined as b 
ON a.id = b.id
    
GROUP BY description_length
ORDER BY  avg_rating DESC

--- Check the top-rated apps for each genre
SELECT prime_genre, track_name, user_rating
FROM
	(SELECT 
     prime_genre, track_name, user_rating,
     RANK() OVER(PARTITION BY prime_genre
                 order by user_rating desc, rating_count_tot desc) as rank
     FROM
	 AppleStore) AS a
WHERE a.rank = 1

    

   
 

 

