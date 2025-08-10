
-- Data Cleaning & Data Processing -- 

SELECT * FROM adidas;

UPDATE adidas
SET 
`Units Sold` = REPLACE(`Units Sold`,',',''),
`Total Amount` = REPLACE(`Total Amount`,',',''),
`Total Amount` = REPLACE(`Total Amount`,'$',''),
Profit = REPLACE(Profit,',',''),
Profit = REPLACE(Profit,'$',''),
`Profit in Percentage` = REPLACE(`Profit in Percentage`,'%','');

SELECT `Price per Unit`*`Units Sold`, `Total Amount`/10 FROM adidas;

UPDATE adidas
SET `Total Amount` = `Total Amount` / 10,
Profit = Profit / 10;

SELECT STR_TO_DATE(`Date`,'%d-%m-%Y') FROM adidas;

UPDATE adidas
SET `Date` = STR_TO_DATE(`Date`,'%d-%m-%Y');

SELECT YEAR(`Date`),MONTH(`Date`),LEFT(MONTHNAME(`Date`),3),QUARTER(`Date`) FROM adidas;

ALTER TABLE adidas
ADD COLUMN year INT,
ADD COLUMN month VARCHAR(10),
ADD COLUMN month_index INT,
ADD COLUMN Quarter VARCHAR(3);

UPDATE adidas
SET 
year = YEAR(`Date`),
month = MONTHNAME(`Date`),
month_index = MONTH(`Date`),
Quarter = CONCAT('Q',QUARTER(`Date`));

SELECT * FROM adidas;

# 1. Calculate total sales, units sold, and profit for each `Retailer ID` and `Product`.

SELECT `Retailer ID`,ROUND(SUM(`Total Amount`)) AS Total_Sales,SUM(`Units Sold`) AS Units_Sold,ROUND(SUM(Profit)) AS Profit
FROM adidas
GROUP BY 1;

SELECT `Product`,ROUND(SUM(`Total Amount`)) AS Total_Sales,SUM(`Units Sold`) AS Units_Sold,ROUND(SUM(Profit)) AS Profit
FROM adidas
GROUP BY 1;

-- 2. Rank products by `Total Amount` and `Profit` within each `Region`.

SELECT * FROM adidas;

SELECT Region,Product,
		ROUND(SUM(`Total Amount`)) AS Total_Amount,
        ROUND(SUM(Profit)) AS Profit,
ROW_NUMBER() 
	OVER(
		PARTITION BY Region 
        ORDER BY SUM(`Total Amount`) DESC,SUM(Profit) DESC
        ) AS `Rank`
FROM adidas
GROUP BY 1,2;

-- 3. Find total `Total Amount` and `Profit` for each `Region` and `State`, and identify the top 5 cities by `Total Amount` within each state.

SELECT * FROM adidas;
SELECT Region,State,City,
		ROUND(SUM(`Total Amount`)) AS Total_Amount,
        ROUND(SUM(Profit)) AS Profit,
        ROW_NUMBER()
			OVER(PARTITION BY Region,State ORDER BY ROUND(SUM(`Total Amount`)) DESC,ROUND(SUM(Profit)) DESC
            ) AS `Rank`
FROM adidas
GROUP BY 1,2,3;

-- In this dataset every single state has just a single city -- 

-- 4. Calculate total sales for each month and quarter to analyze trends.

SELECT month,ROUND(SUM(`Total Amount`)) AS Total_Amount
FROM adidas
GROUP BY 1
ORDER BY MIN(month_index);


SELECT Quarter,ROUND(SUM(`Total Amount`)) AS Total_Amount
FROM adidas
GROUP BY 1
;

WITH CTE AS
(
SELECT Quarter,month,ROUND(SUM(`Total Amount`)) AS Total_Amount
FROM adidas
GROUP BY 1,2
ORDER BY 1,MIN(month_index)
)
SELECT CONCAT(Quarter,' - ',month) AS Period,Total_Amount
FROM CTE;

-- 5. Compare `Total Amount` and `Profit` for different `Sales Method` values (`In-store`, `Outlet`, `Online`).

SELECT `Sales Method`,ROUND(SUM(`Total Amount`)) AS Total_Amount,ROUND(SUM(Profit)) AS Profit
FROM adidas
GROUP BY 1;


-- 6. Calculate the total Total Amount and Profit for each Retailer ID and categorize them into tiers based on their Profit

WITH CTE AS
(
SELECT `Retailer ID`,
		ROUND(SUM(`Total Amount`)) AS Total_Amount,
        ROUND(SUM(Profit)) AS Profit
FROM adidas
GROUP BY 1
)
SELECT *,
CASE
	WHEN Profit >= (SELECT AVG(Profit) FROM CTE) * 1.33 THEN 'High-Value'
    WHEN Profit <= (SELECT AVG(Profit) FROM CTE) * 0.66 THEN 'Low-Value'
	ELSE 'Medium-Value'
END AS Retail_Segmentation
FROM CTE;

-- 7. Identify sales transactions where `Total Amount` exceeds a specific threshold, e.g., $100,000.

SELECT * FROM adidas
WHERE `Total Amount` > 100000;

-- 8. Calculate the average profit margin (`Profit in Percentage`) for each `Product` and `Region`.

SELECT Product,CONCAT(ROUND(AVG(`Profit in Percentage`),2),'%') AS avg_profit_margin 
FROM adidas
GROUP BY 1;

SELECT Region,CONCAT(ROUND(AVG(`Profit in Percentage`),2),'%') AS avg_profit_margin 
FROM adidas
GROUP BY 1;

SELECT Region,Product,CONCAT(ROUND(AVG(`Profit in Percentage`),2),'%') AS avg_profit_margin 
FROM adidas
GROUP BY 1,2;

-- 9. Calculate the year-over-year percentage change in `Total Amount` and `Profit` for each `Region`.

SELECT Region,year,ROUND(SUM(`Total Amount`)) AS Total_Amount,
CONCAT(ROUND(((ROUND(SUM(`Total Amount`)) - ROUND(LAG(SUM(`Total Amount`)) OVER(PARTITION BY Region ORDER BY year))) /
 ROUND(LAG(SUM(`Total Amount`)) OVER(PARTITION BY Region ORDER BY year))),2),'%') AS Total_Amount_year_over_year,
CONCAT(ROUND(((ROUND(SUM(`Profit`)) - ROUND(LAG(SUM(`Profit`)) OVER(PARTITION BY Region ORDER BY year))) /
 ROUND(LAG(SUM(`Profit`)) OVER(PARTITION BY Region ORDER BY year))),2),'%') AS Profit_year_over_year
FROM adidas
GROUP BY 1,2
ORDER BY 1;

-- We have only two years in this dataset so the previous got null for every single region

-- 10. Prepare a summary table of total sales for each `City`, ordered from highest to lowest. */

WITH CTE AS
(
SELECT City,ROUND(SUM(`Total Amount`)) AS Total_Sales
FROM adidas
GROUP BY 1
)
SELECT *,
SUM(Total_Sales) OVER(ORDER BY SUM(Total_Sales) DESC) AS RN_Total
FROM CTE
GROUP BY 1;