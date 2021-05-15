USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT COUNT(*) FROM director_mapping;
-- The total no. of rows in director_mapping table is 3867.

SELECT COUNT(*) FROM genre;
-- The total no. of rows in genre table is 14662.

SELECT COUNT(*) FROM movie;
-- The total no. of rows in movie table is 7997.

SELECT COUNT(*) FROM names;
-- The total no. of rows in names table is 25735.

SELECT COUNT(*) FROM ratings;
-- The total no. of rows in ratings table is 7997.

SELECT COUNT(*) FROM role_mapping;
-- The total no. of rows in role_mapping table is 15615.

-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT 
SUM(CASE
	WHEN m.id IS NULL THEN 1
	ELSE 0
END) AS id_null,
SUM(CASE
	WHEN m.title IS NULL THEN 1
	ELSE 0
END) AS title_null,
SUM(CASE
	WHEN m.year IS NULL THEN 1
	ELSE 0
END) AS year_null,
SUM(CASE
	WHEN m.date_published IS NULL THEN 1
	ELSE 0
END) AS date_published_null,
SUM(CASE
	WHEN m.duration IS NULL THEN 1
	ELSE 0
END) AS duration_null,
SUM(CASE
	WHEN m.country IS NULL THEN 1
	ELSE 0
END) AS country_null,
SUM(CASE
	WHEN m.worlwide_gross_income IS NULL THEN 1
	ELSE 0
END) AS worlwide_gross_income_null,
SUM(CASE
	WHEN m.languages IS NULL THEN 1
	ELSE 0
END) AS languages_null,
SUM(CASE
	WHEN m.production_company IS NULL THEN 1
	ELSE 0
END) AS production_company_null
FROM
    movie AS m;


-- The columns 'country', 'worldwide_gross_income', 'languages', 'production_company' in the movie table have null values.






-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Year wise analysis
SELECT 
	year AS Year, 
    COUNT(*) AS number_of_movies
FROM movie
GROUP BY year;

-- Total no. of movies released in year 2017 is 3052.
-- Total no. of movies released in year 2018 is 2944.
-- Total no. of movies released in year 2019 is 2001.

-- Month wise analysis
SELECT 
	MONTH(date_published) AS month_num, 
    COUNT(*) AS number_of_movies
FROM movie
GROUP BY MONTH(date_published)
ORDER BY month_num;






/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT COUNT(*) AS number_of_movies
FROM movie
WHERE (country LIKE '%USA%' OR country LIKE '%India%') AND year = '2019';

-- The no. of movies produced by USA or India in the year 2019 was 1059.



/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT DISTINCT genre
FROM  genre;








/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT 
	highestmovies.genre,
	COUNT(highestmovies.movie_id) AS Total
FROM 
	genre highestmovies 
INNER JOIN 
	movie m
ON highestmovies.movie_id = m.id
GROUP BY genre
ORDER BY Total DESC
LIMIT 1;

-- 'Drama' genre had the highest no. of movies.



/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
SELECT 
	genre, 
    COUNT(DISTINCT title) AS number_of_movies
FROM 
	movie m 
INNER JOIN 
	genre g 
ON g.movie_id=m.id
GROUP BY genre
ORDER BY COUNT(DISTINCT title)DESC;




/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT 
	genre , 
    ROUND(AVG(duration)) AS avg_duration
FROM 
	movie AS mov 
INNER JOIN 
    genre AS gen
ON mov.id = gen.movie_id
GROUP BY genre
ORDER BY AVG(duration) DESC;




/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
WITH GENRE_RANK AS 
	(SELECT genre,COUNT(DISTINCT movie_id) AS 'movie_count', RANK() OVER (ORDER BY COUNT(movie_id) DESC) AS 'genre_rank'
FROM genre
GROUP BY genre
ORDER BY COUNT(movie_id) DESC)
SELECT * 
FROM GENRE_RANK
WHERE genre = 'Thriller';

-- The rank of 'Thriller' genre of movies among all the genre is 3 and the no. of movies produced in 'Thriller' genre is 1484.


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
SELECT 
MIN(avg_rating) AS min_avg_rating,
MAX(avg_rating) AS max_avg_rating,
MIN(total_votes) AS min_total_votes,
MAX(total_votes) AS max_total_votes,
MIN(median_rating) AS min_median_rating,
MAX(median_rating) AS max_median_rating
FROM ratings;

-- Minimum average rating is 1.0
-- Maximum average rating is 10.0
-- Minimum total votes is 100
-- Maximum total votes is 725138
-- Minimum median rating is 1
-- Maximum median rating is 10
    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
SELECT m.title,
	r.avg_rating,
	DENSE_RANK () OVER ( ORDER BY avg_rating DESC) AS movie_rank
FROM 
	movie m 
INNER JOIN 
    ratings r
ON m.id = r.movie_id
LIMIT 10;





/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
SELECT 
	median_rating, 
    COUNT(*) AS movie_count
FROM ratings
GROUP BY median_rating
ORDER BY median_rating;





/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT 
	production_company,
	COUNT(id) AS movie_count, 
    RANK() OVER(ORDER BY COUNT(id) DESC) AS prod_company_rank
FROM 
	movie AS m 
INNER JOIN 
	ratings AS r
ON m.id = r.movie_id
WHERE (avg_rating > 8) AND (production_company IS NOT NULL)
GROUP BY production_company
ORDER BY COUNT(id) DESC
LIMIT 2;


-- The production houses 'Dream Warrior pictures' and 'National Theatre Live' have produced the most number of hit movies.





-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT 
	genre, 
    COUNT(id) AS movie_count
FROM 
	genre AS g 
INNER JOIN 
	movie AS m
ON g.movie_id = m.id
INNER JOIN 
	ratings AS r
ON m.id = r.movie_id
WHERE (country LIKE '%USA%') AND MONTH(date_published) = 3 AND YEAR(date_published) = 2017 AND total_votes > 1000
GROUP BY genre
ORDER BY COUNT(id) DESC;



-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
SELECT m.title, r.avg_rating, g.genre
FROM
    genre AS g
LEFT JOIN
    movie AS m 
ON g.movie_id = m.id
LEFT JOIN
    ratings AS r 
ON g.movie_id = r.movie_id
WHERE r.avg_rating > 8 AND m.title LIKE 'The%';


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
SELECT COUNT(movie_id) 
FROM 
	ratings AS r 
INNER JOIN 
	movie AS m 
ON r.movie_id = m.id
WHERE((date_published BETWEEN '2018/4/1' and '2019/4/1') AND (median_rating = 8));

-- The movies released between 1 April 2018 and 1 April 2019, 361 movies were given a median rating of 8.

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:


-- CODE FOR GERMAN
SELECT SUM(r.total_votes) AS German_Count
FROM 
	movie AS m
INNER JOIN
    ratings AS r 
ON m.id = r.movie_id
WHERE m.languages LIKE '%German%';

-- The total no. of votes for German movies is 4421525

-- CODE FOR ITALIAN
SELECT SUM(r.total_votes) AS Italian_Count
FROM
    movie AS m
INNER JOIN
    ratings AS r 
ON m.id = r.movie_id
WHERE m.languages LIKE '%Italian%';

-- The total no. of votes for Italian movies is 2559540

-- From the above analysis, we can see that German movies got more votes than Italian movies.

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT 
    SUM(CASE
        WHEN name IS NULL THEN 1
        ELSE 0
    END) AS name_nulls,
    SUM(CASE
        WHEN height IS NULL THEN 1
        ELSE 0
    END) AS height_nulls,
    SUM(CASE
        WHEN date_of_birth IS NULL THEN 1
        ELSE 0
    END) AS date_of_birth_nulls,
    SUM(CASE
        WHEN known_for_movies IS NULL THEN 1
        ELSE 0
    END) AS known_for_movies_nulls
FROM
    names;

-- The columns 'height', 'date_of_birth', 'known_for_movies' in the names table have null values.




/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT 
	genre, 
    COUNT(m.id) 
FROM 
	genre AS g 
INNER JOIN 
	movie AS m
ON g.movie_id = m.id
INNER JOIN 
	ratings AS  r
ON m.id = r.movie_id
WHERE avg_rating > 8
GROUP BY genre
ORDER BY COUNT(m.id) DESC;

-- The top 3 genre which have the most no. of movies with an average rating > 8 are 'Drama', 'Action' and 'Comedy'.

SELECT 
	name, 
    COUNT(m.id) AS movie_count 
FROM 
	names AS n 
INNER JOIN 
	director_mapping AS d
ON n.id = d.name_id
INNER JOIN 
	movie AS m
ON d.movie_id = m.id
INNER JOIN 
	genre AS g
ON m.id = g.movie_id
INNER JOIN 
	ratings r
ON m.id = r.movie_id
WHERE ((genre = 'Drama') OR (genre = 'Action') OR (genre = 'Comedy') AND (avg_rating >8))
GROUP BY name
ORDER BY 
	COUNT(m.id) DESC, 
    name
LIMIT 3;

/* 
The top three directors in the top three genres whose movies have an average rating > 8 are as follows:
1) Jesse V. Johnson
2) Tigmanshu Dhulia
3) James Mangold
*/


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT 
	name AS actor_name, 
	COUNT(m.id) AS movie_count
FROM 
	names AS n 
INNER JOIN 
	role_mapping AS r 
ON n.id = r.name_id
INNER JOIN 
	movie AS m
ON m.id = r.movie_id
INNER JOIN 
	ratings AS rat
ON m.id = rat.movie_id
WHERE median_rating >= 8
GROUP BY name
ORDER BY COUNT(m.id) DESC, name
LIMIT 2;

/*
The top two actors whose movies have a median rating >= 8 are as follows:
1) Mammootty
2) Mohanlal
*/

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT 
	m.production_company,
	SUM(r.total_votes) AS vote_count,
    ROW_NUMBER () OVER (ORDER BY SUM(r.total_votes) DESC) AS prod_comp_rank
FROM 
	movie m 
INNER JOIN 
	ratings r
ON m.id = r.movie_id
GROUP BY production_company
LIMIT 3;

/*
The top three production houses based on the number of votes received by their movies are as follows:
1) Marvel Studios
2) Twentieth Century Fox
3) Warner Bros.
*/



/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT 
	n.name, 
    SUM(total_votes) AS total_votes, 
    COUNT(DISTINCT m.id) AS movie_count, 
    (SUM(total_votes * avg_rating)/SUM(total_votes)) AS actor_avg_rating,
DENSE_RANK() OVER( ORDER BY SUM(total_votes * avg_rating)/SUM(total_votes) DESC, SUM(total_votes) DESC) AS actor_rank	
FROM 
	names AS n 
INNER JOIN 
	role_mapping AS r 
ON n.id = r.name_id
INNER JOIN 
	movie AS m
ON r.movie_id = m.id
INNER JOIN 
	ratings as rtn
ON m.id = rtn.movie_id
WHERE country LIKE  "%India%"
GROUP BY n.name
HAVING COUNT(DISTINCT m.id) >=5;







-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT 
	n.name, 
    SUM(total_votes) AS total_votes, 
    COUNT(DISTINCT m.id) AS movie_count, 
    (Round(SUM(total_votes * avg_rating)/SUM(total_votes),2)) AS actor_avg_rating,
DENSE_RANK() OVER( ORDER BY SUM(total_votes * avg_rating)/SUM(total_votes) DESC, SUM(total_votes) DESC) AS actress_rank	
FROM 
	names AS n 
INNER JOIN 
	role_mapping AS r 
ON n.id = r.name_id
INNER JOIN 
	movie AS m
ON r.movie_id = m.id
INNER JOIN 
	ratings AS rt
ON m.id = rt.movie_id
WHERE country LIKE  "%India%" AND languages LIKE "%Hindi%" AND category = 'actress'
GROUP BY n.name
HAVING COUNT(DISTINCT m.id) >=3
LIMIT 5;

/*
Top five actresses in Hindi movies released in India based on their average ratings are as follows:
1) Taapsee Pannu
2) Kriti Sanon
3) Divya Dutta
4) Shraddha Kapoor
5) Kriti Kharbanda
*/

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
SELECT 
	m.title,
	r.avg_rating,
	CASE
		WHEN avg_rating > 8 THEN 'Superhit'
		WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit'
		WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch'
		ELSE 'Flop movies'
	END AS movie_type
FROM 
	movie m 
INNER JOIN 
	ratings r
ON m.id = r.movie_id 
INNER JOIN 
	genre g
ON m.id = g.movie_id
WHERE genre = 'thriller';









/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
WITH avg_movieduration AS
	(
	SELECT 
		g.genre,
		AVG(m.duration) AS avg_duration
	FROM
		movie AS m
	INNER JOIN
		genre AS g
	ON m.id=g.movie_id
	GROUP BY g.genre
	)
SELECT *,
	SUM(avg_duration) OVER w1 AS running_total_duration,
	AVG(avg_duration) OVER w2 AS moving_avg_duration
FROM 
	avg_movieduration
WINDOW w1 AS (ORDER BY genre ROWS UNBOUNDED PRECEDING),
w2 AS (ORDER BY genre ROWS 6 PRECEDING);









-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies
SELECT 
	genre,
    COUNT(DISTINCT id) AS "no of movies" FROM movie AS m
INNER JOIN 
	genre AS g
ON m.id = g.movie_id
GROUP BY genre
ORDER BY count(DISTINCT id) DESC
LIMIT 3;

-- Top 3 genres based on most number of movies are 'Drama', 'Comedy' and 'Thriller'.

SELECT 
	genre,
    year,
    title AS movie_name, 
    worlwide_gross_income, 
    RANK() OVER(ORDER BY worlwide_gross_income DESC) AS movie_rank
FROM 
	genre AS g 
INNER JOIN 
	movie AS m
ON g.movie_id = m.id
WHERE(genre	LIKE '%Drama%' OR genre LIKE '%Comedy%' OR genre LIKE '%Thriller%') AND Year = 2017
LIMIT 5;

/*
Five highest-grossing movies of the year 2017 that belong to the top three genres are as follows:
1) Shatamanam Bhavati
2) Winner
3) Thank You for Your Service
4) The Healer
5) The Healer
*/

SELECT 
	genre,
    year,
    title AS movie_name, 
    worlwide_gross_income, 
    RANK() OVER(ORDER BY worlwide_gross_income DESC) AS movie_rank
FROM 
	genre AS g 
INNER JOIN 
	movie AS m
ON g.movie_id = m.id
WHERE(genre	LIKE '%Drama%' OR genre LIKE '%Comedy%' OR genre LIKE '%Thriller%') AND Year = 2018
LIMIT 5;

/*
Five highest-grossing movies of the year 2018 that belong to the top three genres are as follows:
1) The Villain
2) Antony & Cleopatra
3) La fuitina sbagliata
4) Zaba
5) Gung-hab
*/


SELECT 
	genre,
    year,
    title AS movie_name, 
    worlwide_gross_income, 
    RANK() OVER(ORDER BY worlwide_gross_income DESC) AS movie_rank
FROM 
	genre AS g 
INNER JOIN 
	movie AS m
ON g.movie_id = m.id
WHERE(genre	LIKE '%Drama%' OR genre LIKE '%Comedy%' OR genre LIKE '%Thriller%') AND Year = 2019
LIMIT 5;

/*
Five highest-grossing movies of the year 2019 that belong to the top three genres are as follows:
1) Prescience
2) Joker
3) Joker
4) Eaten by Lions
5) Friend Zone
*/



-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
WITH top2prodrank AS (
SELECT m.production_company, Count(*) AS movie_count,
	   Rank() OVER (ORDER BY Count(*) DESC ) AS prod_comp_rank
FROM 
	movie AS m
INNER JOIN 
	ratings AS r
ON m.id = r.movie_id
WHERE m.languages LIKE '%,%' AND r.median_rating >= 8 AND m.production_company IS NOT NULL
GROUP BY m.production_company
)
SELECT * 
FROM 
	top2prodrank 
WHERE prod_comp_rank<=2;

/*
The top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies are as follows:
1) Star Cinema
2) Twentieth Century Fox
*/


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT 
	name,
	SUM(total_votes) AS total_votes,
	COUNT(DISTINCT m.id) AS movie_count, 
	Round(AVG(avg_rating),2) AS actress_avg_rating,
DENSE_RANK() OVER(ORDER BY COUNT(DISTINCT m.id) DESC, 
AVG(avg_rating) DESC) AS actress_rank
FROM 
	names AS n 
INNER JOIN 
	role_mapping AS r
ON n.id = r.name_id
INNER JOIN 
	movie AS m
ON r.movie_id = m.id
INNER JOIN 
	ratings AS rt
ON m.id = rt.movie_id
INNER JOIN 
	genre AS g 
ON g.movie_id = m.id
WHERE genre = 'Drama' AND avg_rating>8 AND category = 'actress'
GROUP BY name
LIMIT 3;

/*
The top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre are as follows:
1) Amanda Lawrence
2) Denise Gough
3) Susan Brown
*/


/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
WITH MM AS
(
SELECT 
	n.name, 
    m.title,
    m.date_published,
    LEAD(m.date_published,1) OVER (PARTITION BY n.name ORDER BY m.date_published) AS next_release_date
FROM 
	movie AS m
INNER JOIN 
	director_mapping AS dm
ON m.id = dm.movie_id
INNER JOIN names AS n
ON dm.name_id = n.id
ORDER BY n.name
),
diff AS
(
SELECT *,
DATEDIFF(next_release_date,date_published) AS days_diff
FROM MM
),
avginterd AS 
(
SELECT 
	AVG(days_diff) AS avginter, 
    name
FROM diff
GROUP BY name
),
director AS 
(
SELECT
	dm.name_id AS director_id,
    n.name AS director_name,
    COUNT(*) AS number_of_movies,
    row_number() OVER (ORDER BY COUNT(*) DESC) AS director_rank,
    AVG(r.avg_rating) AS avg_rating,
    SUM(r.total_votes) AS total_votes,
    MIN(r.avg_rating) AS min_rating,
    MAX(r.avg_rating) AS max_rating,
    SUM(m.duration) AS total_duration
FROM
	movie AS m 
INNER JOIN 
	ratings r 
ON m.id = r.movie_id
INNER JOIN 
	director_mapping AS dm 
ON m.id = dm.movie_id
INNER JOIN 
	names AS n 
ON dm.name_id = n.id
GROUP BY dm.name_id
)
SELECT 
	t.director_id,
    t.director_name,
    t.number_of_movies,
    a.avginter AS avg_inter_movie_days,
    t.avg_rating,
    t.total_votes,
    t.min_rating,
    t.max_rating,
    t.total_duration 
FROM 
	director AS t
INNER JOIN 
	avginterd AS a 
ON t.director_name = a.name
WHERE Director_rank <= 9;
