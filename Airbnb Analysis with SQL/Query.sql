USE Airbnb;

SELECT * FROM dbo.calendar;

------------------------ FEATURE ENGINEER-------------------------------

/*ALTER TABLE dbo.calendar 
ADD con_price AS (CASE
        WHEN cal_price IS NULL THEN NULL
        ELSE TRY_CAST(SUBSTRING(cal_price, 2, LEN(cal_price)) AS FLOAT)
    END);
*/

/*SELECT 
    CASE
        WHEN cal_price IS NULL THEN NULL
        ELSE TRY_CAST(SUBSTRING(cal_price, 2, LEN(cal_price)) AS FLOAT)
    END AS converted_price
FROM dbo.calendar;
*/
--------------------------------------------------------------------------

SELECT * FROM dbo.listings;

------------------------ FEATURE ENGINEER-------------------------------

/*ALTER TABLE dbo.listings 
ADD conv_price AS (CASE
        WHEN price IS NULL THEN NULL
        ELSE TRY_CAST(SUBSTRING(price, 2, LEN(price)) AS FLOAT)
    END);

ALTER TABLE dbo.listings 
ADD conv_weekly_price AS (CASE
        WHEN weekly_price IS NULL THEN NULL
        ELSE TRY_CAST(SUBSTRING(weekly_price, 2, LEN(weekly_price)) AS FLOAT)
    END);

ALTER TABLE dbo.listings 
ADD conv_monthly_price AS (CASE
        WHEN monthly_price IS NULL THEN NULL
        ELSE TRY_CAST(SUBSTRING(monthly_price, 2, LEN(monthly_price)) AS FLOAT)
    END);

ALTER TABLE dbo.listings 
ADD conv_sec_dep_price AS (CASE
        WHEN security_deposit IS NULL THEN NULL
        ELSE TRY_CAST(SUBSTRING(security_deposit, 2, LEN(security_deposit)) AS FLOAT)
    END);

ALTER TABLE dbo.listings 
ADD conv_clean_fee_price AS (CASE
        WHEN cleaning_fee IS NULL THEN NULL
        ELSE TRY_CAST(SUBSTRING(cleaning_fee, 2, LEN(cleaning_fee)) AS FLOAT)
    END);

ALTER TABLE dbo.listings 
ADD conv_extra_people_price AS (CASE
        WHEN extra_people IS NULL THEN NULL
        ELSE TRY_CAST(SUBSTRING(extra_people, 2, LEN(extra_people)) AS FLOAT)
    END);

*/

----------------------------------------------------------------------------


SELECT * FROM dbo.reviews;

------------------------ FEATURE ENGINEER-------------------------------

/*SELECT * FROM dbo.listings as tbl1
JOIN dbo.calendar as tbl2 ON tbl1.id = tbl2.cal_listing_id
JOIN dbo.reviews as tbl3 ON tbl1.id = tbl3.rev_listing_id;
*/

-----------------------------------------------------------------------------

------------------------------Missing Values Check---------------------------

SELECT COUNT(*) AS total_rows,
       COUNT(cal_listing_id) AS non_null_count,
       COUNT(*) - COUNT(cal_listing_id) AS missing_count
FROM dbo.calendar;

SELECT COUNT(*) AS total_rows,
       COUNT(id) AS non_null_count,
       COUNT(*) - COUNT(id) AS missing_count
FROM dbo.listings;


SELECT COUNT(*) AS total_rows,
       COUNT(rev_listing_id) AS non_null_count,
       COUNT(*) - COUNT(rev_listing_id) AS missing_count
FROM dbo.reviews;

---------------------------------------------------------------------------

-------------------------------------OUTLIER CHECK--------------------------

SELECT * 
FROM dbo.calendar
WHERE con_price NOT BETWEEN 15 AND 950
ORDER BY con_price;

--beds& bed_type, bathrooms,
SELECT beds, bed_type 
FROM dbo.listings
WHERE beds NOT BETWEEN 1 AND 15
ORDER BY beds;

SELECT bed_type, Min(beds) as "Min number of beds", Max(beds) as "Max number of beds"
FROM dbo.listings
--WHERE beds NOT BETWEEN 1 AND 15
GROUP BY bed_type
ORDER BY MIN(beds);

SELECT bathrooms, bed_type 
FROM dbo.listings
WHERE bathrooms NOT BETWEEN 1 AND 5
ORDER BY bathrooms;
----------------------------------------------------------------------------

---------------------------- QUERY 1------------------------------------

--PRICING & DEMAND ANALYSIS:

--Q1
--Determine the average, minimum, and maximum prices for different types of accommodations.
SELECT 
    room_type, 
	AVG(conv_price) as "Average Price", 
	MIN(conv_price) as "Minimum Price", 
	MAX(conv_price) as "Maximum Price" 
FROM dbo.listings 
/*as tbl1
JOIN dbo.calendar as tbl2 ON tbl1.id = tbl2.cal_listing_id
JOIN dbo.reviews as tbl3 ON tbl1.id = tbl3.rev_listing_id */ GROUP BY room_type;


--Q2
--Identify the most expensive and least expensive neighborhoods for renting.
SELECT TOP 1 host_neighbourhood as "Most Expensive Neighbourhood", neighbourhood_cleansed, MAX(conv_price) as "Max Price" 
FROM dbo.listings as tbl1
JOIN dbo.calendar as tbl2 ON tbl1.id = tbl2.cal_listing_id
JOIN dbo.reviews as tbl3 ON tbl1.id = tbl3.rev_listing_id
GROUP BY host_neighbourhood,neighbourhood_cleansed Order BY "Max Price" DESC; -- HAVING conv_price = MAX(conv_price);

SELECT TOP 5 host_neighbourhood as "Least Expensive Neighbourhood", neighbourhood_cleansed, MIN(conv_price) as "Min Price" 
FROM dbo.listings as tbl1
JOIN dbo.calendar as tbl2 ON tbl1.id = tbl2.cal_listing_id
JOIN dbo.reviews as tbl3 ON tbl1.id = tbl3.rev_listing_id
GROUP BY host_neighbourhood,neighbourhood_cleansed Order BY "Min Price" ASC; -- HAVING conv_price = MAX(conv_price);


--Q3
--Analyze pricing trends based on seasons, holidays, or special events.
SELECT DISTINCT YEAR(cal_date) as "Year", MONTH(cal_date) as "Month", AVG(CAST(con_price as FLOAT)) as "Average Price" FROM --dbo.listings as tbl1
--JOIN 
dbo.calendar --as tbl2 ON tbl1.id = tbl2.cal_listing_id
/*JOIN dbo.reviews as tbl3 ON tbl1.id = tbl3.rev_listing_id*/
GROUP BY YEAR(cal_date),MONTH(cal_date)
ORDER BY "Year", "Month";


/*ALTER TABLE dbo.calendar
ADD season VARCHAR(20);

UPDATE dbo.calendar
SET season = CASE
    WHEN MONTH(cal_date) IN (12, 1, 2) THEN 'Winter'
    WHEN MONTH(cal_date) IN (3, 4, 5) THEN 'Spring'
    WHEN MONTH(cal_date) IN (6, 7, 8) THEN 'Summer'
    WHEN MONTH(cal_date) IN (9, 10, 11) THEN 'Fall'
    ELSE 'Unknown'
END;
*/

SELECT DISTINCT YEAR(cal_date) as Year, season as Season, AVG(CAST(con_price as FLOAT)) as "Average Price" FROM --dbo.listings as tbl1
--JOIN 
dbo.calendar --as tbl2 ON tbl1.id = tbl2.cal_listing_id
/*JOIN dbo.reviews as tbl3 ON tbl1.id = tbl3.rev_listing_id*/
GROUP BY YEAR(cal_date), season
ORDER BY Year, season;

-----------------------------------------------------------------------------------------------


---------------------------- QUERY 2------------------------------------

--Occupancy and Availability:

--Q1
--Calculate the occupancy rate for different neighborhoods or property types.
SELECT DISTINCT neighbourhood_cleansed AS "Neighbourhood",AVG(conv_weekly_price) AS "Weekly Rate" 
FROM dbo.listings 
GROUP BY neighbourhood_cleansed 
ORDER BY "Weekly Rate";

SELECT DISTINCT property_type AS "Property",AVG(conv_weekly_price) AS "Weekly Rate" 
FROM dbo.listings 
GROUP BY property_type
ORDER BY "Weekly Rate";

SELECT DISTINCT neighbourhood_cleansed AS "Neighbourhood", property_type AS "Property",AVG(conv_weekly_price) AS "Weekly Rate" 
FROM dbo.listings 
GROUP BY neighbourhood_cleansed, property_type
ORDER BY "Neighbourhood", "Property","Weekly Rate";

--Q2
--Identify properties with the highest and lowest occupancy rates.
SELECT TOP 2 property_type AS "Property",AVG(conv_weekly_price) AS "Weekly Rate" 
FROM dbo.listings
GROUP BY property_type
ORDER BY "Weekly Rate" DESC;

SELECT TOP 7 property_type AS "Property",AVG(conv_weekly_price) AS "Weekly Rate" 
FROM dbo.listings
GROUP BY property_type
ORDER BY "Weekly Rate" ASC;


--Q3
--Determine the average number of available listings per month.
SELECT YEAR(cal_date) AS "Year", MONTH(cal_date) AS "Month", COUNT(CAST(availability_30 AS float)) AS "Number of Available Listings in 30 days"
FROM dbo.listings AS tbl1
LEFT JOIN dbo.calendar AS tbl2 ON tbl1.id = tbl2.cal_listing_id
GROUP BY YEAR(cal_date), MONTH(cal_date)
ORDER BY Year, Month;

-----------------------------------------------------------------------------------------------------

------------------------------------QUERY 3----------------------------------

--Neighborhood Insights:

--Q1
--Group listings by neighborhoods and analyze the distribution of property types.
SELECT  DISTINCT neighbourhood_cleansed AS "Neighbourhood", property_type as "Property", COUNT(CAST(availability_30 AS float)) AS "Number of Available Listings in 30 days"
FROM dbo.listings AS tbl1
LEFT JOIN dbo.calendar AS tbl2 ON tbl1.id = tbl2.cal_listing_id
GROUP BY neighbourhood_cleansed, property_type
ORDER BY "Neighbourhood","Property";


--Q2
--Compare the popularity of different neighborhoods based on booking frequency.
SELECT
    l.neighbourhood_cleansed,
    COUNT(c.cal_listing_id) AS booking_frequency,
    RANK() OVER (ORDER BY COUNT(c.cal_listing_id) DESC) AS popularity_rank
FROM
    dbo.calendar as c
JOIN
    dbo.listings l ON c.cal_listing_id = l.id
WHERE
    c.available = 'f' -- Assuming 'f' indicates a booked date
GROUP BY
    l.neighbourhood_cleansed
ORDER BY
    popularity_rank;


--Q3
--Identify areas with the most reviews and highest review scores.
SELECT
    l.neighbourhood_cleansed,
    l.city,
    COUNT(r.rev_id) AS review_count,
    AVG(l.review_scores_value) AS avg_review_score,
    RANK() OVER (ORDER BY COUNT(r.rev_id) DESC) AS review_count_rank,
    RANK() OVER (ORDER BY AVG(l.review_scores_value) DESC) AS review_score_rank
FROM
    dbo.listings l
JOIN
    dbo.reviews r ON l.id = r.rev_listing_id
GROUP BY
    l.neighbourhood_cleansed, l.city
ORDER BY
    review_count_rank, review_score_rank;



--------------------------------------------------------------------------------------------------------


--------------------------------------------QUERY 4------------------------------------------

-- Sentiment and Satisfaction Analysis

--Analyze the Distribution of Review Scores and Identify Factors Correlated with Higher Scores:
SELECT
    city, neighbourhood_cleansed, property_type, room_type,amenities, AVG(accommodates) as "avg_accomodates",AVG(bathrooms) as "avg_bathrooms",
	AVG(bedrooms) as "avg_bedrooms", AVG(beds) as "avg_beds", AVG(review_scores_rating) as "avg_ratings"
FROM
    dbo.listings
WHERE
    review_scores_rating IS NOT NULL
GROUP BY
    city, neighbourhood_cleansed, property_type, room_type,amenities
ORDER BY
    "avg_ratings" DESC;

--Determine if There is a Relationship Between Review Scores and Property Prices:
SELECT
    property_type,
    AVG(review_scores_rating) AS avg_review_score,
    AVG(conv_price) AS avg_property_price
FROM
    dbo.listings
WHERE
    review_scores_rating IS NOT NULL
GROUP BY
    property_type
ORDER BY
    avg_review_score ASC;


--Identify Common Keywords in Positive and Negative Reviews
SELECT
    l.property_type,
	CASE WHEN l.review_scores_value >= 7 THEN 'Positive' ELSE 'Negative' END AS sentiment,
    LOWER(REPLACE(r.comments, '.', '')) AS cleaned_review_text,
    COUNT(*) AS keyword_count
FROM
    dbo.listings as l
JOIN
    dbo.reviews as r
ON
    l.id = r.rev_listing_id
GROUP BY
    l.property_type, LOWER(REPLACE(r.comments, '.', '')),review_scores_value
HAVING
    COUNT(*) > 5  ----results with only keyword_count more than 5
ORDER BY
    --sentiment, 
	keyword_count DESC;

-------------------------------------------QUERY 5 ----------------------------------------------
-- Forecasting Trends
SELECT
    cal_date,
    AVG(con_price) OVER (ORDER BY cal_date ROWS BETWEEN 30 PRECEDING AND CURRENT ROW) AS moving_avg_30_days
FROM dbo.calendar;


SELECT
    c.cal_date,
    AVG(availability_30) OVER (ORDER BY cal_date ROWS BETWEEN 30 PRECEDING AND CURRENT ROW) AS moving_avg_30_days
FROM dbo.listings as l 
JOIN dbo.calendar as c
ON l.id = c.cal_listing_id;


SELECT
    c.cal_date,
    AVG(conv_clean_fee_price) OVER (ORDER BY cal_date ROWS BETWEEN 30 PRECEDING AND CURRENT ROW) AS moving_avg_30_days
FROM dbo.listings as l 
JOIN dbo.calendar as c
ON l.id = c.cal_listing_id;

----------------------------------------------------------------------------------------------------------


----------------------------------------------THANK YOU----------------------------------------------------