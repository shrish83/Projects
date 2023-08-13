USE Airbnb;

SELECT * FROM dbo.calendar;
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

SELECT * FROM dbo.listings;

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

SELECT * FROM dbo.reviews;


/*SELECT * FROM dbo.listings as tbl1
JOIN dbo.calendar as tbl2 ON tbl1.id = tbl2.cal_listing_id
JOIN dbo.reviews as tbl3 ON tbl1.id = tbl3.rev_listing_id;
*/

---------------------------- QUERY 1------------------------------------

--PRICING & DEMAND ANALYSIS:

--Q1
--Determine the average, minimum, and maximum prices for different types of accommodations.
SELECT room_type, AVG(conv_price) as "Average Price", MIN(conv_price) as "Minimum Price", MAX(conv_price) as "Maximum Price" FROM dbo.listings 
/*as tbl1
JOIN dbo.calendar as tbl2 ON tbl1.id = tbl2.cal_listing_id
JOIN dbo.reviews as tbl3 ON tbl1.id = tbl3.rev_listing_id */ GROUP BY room_type;


--Q2
--Identify the most expensive and least expensive neighborhoods for renting.
SELECT TOP 1 host_neighbourhood as "Most Expensive Neighbourhood", neighbourhood_cleansed, MAX(conv_price) as "Max Price" FROM dbo.listings 
/*as tbl1
JOIN dbo.calendar as tbl2 ON tbl1.id = tbl2.cal_listing_id
JOIN dbo.reviews as tbl3 ON tbl1.id = tbl3.rev_listing_id*/ GROUP BY host_neighbourhood,neighbourhood_cleansed Order BY "Max Price" DESC; -- HAVING conv_price = MAX(conv_price);

SELECT TOP 5 host_neighbourhood as "Least Expensive Neighbourhood", neighbourhood_cleansed, MIN(conv_price) as "Min Price" FROM dbo.listings 
/*as tbl1
JOIN dbo.calendar as tbl2 ON tbl1.id = tbl2.cal_listing_id
JOIN dbo.reviews as tbl3 ON tbl1.id = tbl3.rev_listing_id*/ GROUP BY host_neighbourhood,neighbourhood_cleansed Order BY "Min Price" ASC; -- HAVING conv_price = MAX(conv_price);


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
SELECT YEAR(cal_date) AS "Year", MONTH(cal_date) AS "Month", COUNT(CAST(availability_30 AS float)) AS "Average Number of Available Listings in 30 days"
FROM dbo.listings AS tbl1
LEFT JOIN dbo.calendar AS tbl2 ON tbl1.id = tbl2.cal_listing_id
GROUP BY YEAR(cal_date), MONTH(cal_date)
ORDER BY Year, Month;