use SynergyCaseStudy;

select * from dbo.clean_data;


--Trends of Number of Quarterly Contracts Beginning and End Date:
SELECT
    YEAR(Start_Date) AS year,
    DATEPART(QUARTER, Start_Date) AS quarter,
    COUNT(DISTINCT Customer_Number) AS customer_count,
    SUM(Revenue_in_Million) AS generated_revenue
FROM dbo.clean_data
GROUP BY YEAR(Start_Date), DATEPART(QUARTER, Start_Date)
ORDER BY year, quarter;


-- Number of Customers with Revenue Greater Than Average in Their Region:
SELECT
    Region,
    COUNT(DISTINCT Customer_Number) AS customer_count
FROM dbo.clean_data
WHERE Revenue_in_Million > (
    SELECT AVG(Revenue_in_Million)
    FROM dbo.clean_data
)
GROUP BY Region
ORDER BY customer_count DESC;


--Share of Revenue Each Region is Generating:
SELECT
    Region,
    SUM(Revenue_in_Million) / (SELECT SUM(Revenue_in_Million) FROM dbo.clean_data) AS revenue_share
FROM dbo.clean_data
GROUP BY region
ORDER BY revenue_share DESC;