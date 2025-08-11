# Adidas Sales Performance Analysis with SQL

## Project Overview

This project involves a comprehensive analysis of the Adidas sales dataset using MySQL. The primary objective was to perform data cleaning,
conduct exploratory data analysis (EDA), and derive actionable insights into sales performance, profitability, and market trends. By leveraging 
advanced SQL functions, I transformed raw transactional data into a structured format to answer key business questions.

## Key Skills & Tools Used

- Data Cleaning & Transformation: (String manipulation, STR_TO_DATE, Data Type Casting)
 
- Advanced SQL: (Common Table Expressions (CTEs), Window Functions like DENSE_RANK(), ROW_NUMBER() and LAG())
  
- Data Aggregation Functions Like GROUP BY, SUM(), AVG(), MIN(), MAX(), COUNT()
  
- Analytical Techniques: (Time-Series Analysis, Profitability Analysis, Customer Segmentation)

## Analytical Questions & Key Findings

### 1. What are the top-performing products and regions?

```sql
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
```
<img width="701" height="238" alt="Screenshot 2025-08-10 182112" src="https://github.com/user-attachments/assets/b43e5c99-7e9b-4e6f-a3d6-30cb1899e605" />

ㅤ

Used ROW_NUMBER() to rank products and regions by total sales and profit, identifying which product lines 
and geographical areas are the most significant revenue drivers.

------------------------------------------------------------------------------

### 2. Calculate the aggregate Total Amount and Profit for each Retailer ID and categorize them into performance tiers based on their profitability.

```sql
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
```
<img width="628" height="160" alt="Screenshot 2025-08-10 183947" src="https://github.com/user-attachments/assets/6757744f-b2aa-41d6-8f7f-f8e27ebc5247" />

ㅤ

This query successfully segments retailers into performance tiers into High-Value, Medium-Value, and Low-Value based on their average total profit.

------------------------------------------------------------------------------

### 3. Analyze the average profit margin for each product within each geographical region to identify and compare profitability.

```sql
SELECT Region,Product,CONCAT(ROUND(AVG(`Profit in Percentage`),2),'%') AS avg_profit_margin 
FROM adidas
GROUP BY 1,2;
```
<img width="537" height="231" alt="Screenshot 2025-08-10 184645" src="https://github.com/user-attachments/assets/bc5f2326-500f-4e46-87e9-8cb4e91b35b7" />

ㅤ

This query calculates the average profit margin per product and region, which is essential for understanding where the business is most profitable.

------------------------------------------------------------------------------


### 4. What's the year-over-year percentage change in total sales and profit for each region to assess growth and performance trends.

```sql
SELECT Region,
	   year,
       ROUND(SUM(`Total Amount`)) AS Total_Amount,
	   CONCAT(ROUND(((ROUND(SUM(`Total Amount`)) - ROUND(LAG(SUM(`Total Amount`)) OVER(PARTITION BY Region ORDER BY year))) /
       ROUND(LAG(SUM(`Total Amount`)) OVER(PARTITION BY Region ORDER BY year))),2),'%') AS Total_Amount_year_over_year,
       CONCAT(ROUND(((ROUND(SUM(`Profit`)) - ROUND(LAG(SUM(`Profit`)) OVER(PARTITION BY Region ORDER BY year))) /
       ROUND(LAG(SUM(`Profit`)) OVER(PARTITION BY Region ORDER BY year))),2),'%') AS Profit_year_over_year
FROM adidas
GROUP BY 1,2
```
<img width="843" height="186" alt="Screenshot 2025-08-10 185412" src="https://github.com/user-attachments/assets/28d3023c-87ec-4c89-b17e-0726b9ab48f8" />

ㅤ

This query calculates the year-over-year growth rate for both total sales and profit by region. This analysis is crucial for understanding regional performance,
identifying which areas are experiencing significant growth or decline, and guiding strategic planning for future market investments and resource allocation.

------------------------------------------------------------------------------

### 5. Generate a summary table of total sales for each city, ordered by highest sales, and include a running total to track cumulative performance.

```sql
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
```
<img width="375" height="230" alt="Screenshot 2025-08-10 185705" src="https://github.com/user-attachments/assets/c91c8810-6d98-4878-82b4-cdfa5fd83d18" />
ㅤ
ㅤ

This query effectively ranks cities by total sales, with a running total that highlights the cumulative revenue contribution of top-performing markets.
This is a valuable tool for strategic planning and resource allocation.

------------------------------------------------------------------------------

### 6. What is the month-over-month sales performance, and how do we track the cumulative revenue throughout the year?

```sql
WITH CTE AS
(
SELECT SUBSTRING(`Date`,1,7) AS Period,CONCAT(MONTHNAME(`Date`),' - ',YEAR(`Date`)) AS 'Month-Year'
,SUM(Total_Amount) AS Amount
FROM adidas
GROUP BY 1,2
ORDER BY 1
)
SELECT `Month-Year`,Amount,
SUM(Amount) OVER(ORDER BY Period) AS Running_Total
FROM CTE;
```
<img width="433" height="235" alt="Screenshot 2025-08-10 191549" src="https://github.com/user-attachments/assets/fa27eeb7-2f5f-49b0-89b7-35cb97c1aa83" />


ㅤ

This query effectively tracks monthly sales and provides a running total, which is excellent for monitoring cumulative revenue
and identifying performance trends throughout the year. It gives a clear, progressive view of how sales accumulate over time.

------------------------------------------------------------------------------

### 7. What are the total sales, profit, units sold, and average profit percentage for each product type in every state

```sql
SELECT State,Product_Type,SUM(Total_Amount) AS Total_Amount,
SUM(Profit) AS Total_Profit,
SUM(Units_Sold) AS Total_Units_Sold,
CONCAT(ROUND(AVG(Profit_in_Percentage),1),'%') AS Avg_Percentage
FROM adidas
GROUP BY 1,2
ORDER BY 1;
```

<img width="938" height="242" alt="Screenshot 2025-08-10 191253" src="https://github.com/user-attachments/assets/1fe5c994-7c6d-4306-8e47-06d0a81d1e21" />

ㅤ

This query provides a detailed performance breakdown by state and product type. It's a valuable tool for identifying which products are most profitable
in specific regions. This information can guide inventory, marketing, and sales strategies.

------------------------------------------------------------------------------

### 8. Compare performance betwenn the top three cities in each region on a monthly basis, considering total sales, profit, units sold, and average profit percentage?

```sql
WITH CTE AS 
(
SELECT SUBSTRING(`Date`,1,7) AS Period,
CONCAT(MONTHNAME(`Date`),' - ',YEAR(`Date`)) AS `Month-Year`,
Region,City,
SUM(Total_Amount) AS Total_Amount,
SUM(Profit) AS Total_Profit,
SUM(Units_Sold) AS Total_Units_Sold,
CONCAT(ROUND(AVG(Profit_in_Percentage),1),'%') AS Avg_Percentage,
ROW_NUMBER() 
	OVER(
    PARTITION BY SUBSTRING(`Date`,1,7),Region
    ORDER BY 
		SUM(Total_Amount) DESC,
        SUM(Profit) DESC,
        SUM(Units_Sold) DESC,
		CONCAT(ROUND(AVG(Profit_in_Percentage),1),'%') DESC
		) AS RN
FROM adidas
GROUP BY 1,2,3,4
ORDER BY 1,3,4
),
CTEE AS
(
SELECT `Month-Year`, Region,City, Total_Amount, Total_Profit, Total_Units_Sold, Avg_Percentage
FROM CTE
WHERE RN <= 3
ORDER BY Period,3,4 DESC,5 DESC,6 DESC,7 DESC
)
SELECT * FROM CTEE;
```
<img width="984" height="241" alt="Screenshot 2025-08-10 191838" src="https://github.com/user-attachments/assets/48dc136e-673d-40c8-8e59-b0d293cc1a40" />

ㅤ

This query effectively ranks cities within each region on a monthly basis, highlighting the top three performers across key metrics.

------------------------------------------------------------------------------

### 9. Which three products are the top performers in each state, based on a ranking of total sales and profit?

```sql
WITH CTE AS
(
SELECT State,Product,
SUM(Total_Amount) AS Sales,
SUM(Profit) AS Profit,
DENSE_RANK()
	OVER(
		PARTITION BY State
        ORDER BY SUM(Total_Amount) DESC,SUM(Profit) DESC
        ) AS RN
FROM ad
GROUP BY 1,2
)
SELECT State, Product, Sales, Profit FROM CTE
WHERE RN <= 3;
```
<img width="589" height="235" alt="Screenshot 2025-08-10 192531" src="https://github.com/user-attachments/assets/cdea9b5a-9a35-417e-b4d0-af0e52ff3409" />

ㅤ

This query effectively ranks the top three products in each state based on sales and profit. This analysis is valuable for understanding regional
preferences and informing strategic decisions on inventory, marketing, and product placement.

------------------------------------------------------------------------------

### 10. On a monthly basis, which sales method is the top performer when ranked by total sales, units sold, and profit?

```sql
WITH CTE AS
(
SELECT SUBSTRING(`Date`,1,7) AS Period,
CONCAT(MONTHNAME(`Date`),' - ',YEAR(`Date`)) AS 'Month-Year',
Sales_Method,SUM(Total_Amount) AS Total_Amount,
SUM(Units_Sold) AS Units_Sold,SUM(Profit) AS Profit,
CONCAT(ROUND(AVG(Profit_in_Percentage),1),'%') AS Profit_in_Percentage,
ROW_NUMBER() 
	OVER(
		PARTITION BY SUBSTRING(`Date`,1,7),
        CONCAT(MONTHNAME(`Date`),' - ',YEAR(`Date`))
		ORDER BY SUM(Total_Amount) DESC,SUM(Units_Sold) DESC,
        SUM(Profit) DESC,CONCAT(ROUND(AVG(Profit_in_Percentage),1),'%') DESC
		) AS RN	
FROM ad
GROUP BY 1,2,3
ORDER BY 1
)
SELECT `Month-Year`, Sales_Method, Total_Amount, Units_Sold, Profit, Profit_in_Percentage FROM CTE
WHERE RN = 1;
```
<img width="957" height="243" alt="Screenshot 2025-08-10 192920" src="https://github.com/user-attachments/assets/f2799cbf-9ba3-4e10-9b52-62a40e8c6a1f" />

ㅤ

This query identifies the top-performing sales method for each month by ranking channels on multiple metrics. This provides a clear, data-driven insight
for optimizing sales strategy and allocating resources effectively.

------------------------------------------------------------------------------

## Key Findings & Insights
### Retailer & Product Performance: 
- Identified the top-performing retailers and products based on their total sales and profit.

- Sales Trends: Analyzed monthly and quarterly sales trends to reveal seasonal patterns in performance.

- Channel Effectiveness: Compared the effectiveness of different sales methods (In-store, Online, Outlet) using various metrics.

- Market Segmentation: Segmented retailers into High, Medium and Low-Value tiers to identify and prioritize key partners.

- Regional Performance: Ranked top cities and products within each state and region to understand market preferences.

- Profitability Analysis: Calculated the average profit margin per product and region to find where the business is most profitable.

## Contact Info

- Mobile : +91 6303337487

- Email : [kambamsanthosh@gmail.com](kambamsanthosh@gmail.com)

- LinkedIn : [https://www.linkedin.com/in/santhosh-kambam/](https://www.linkedin.com/in/santhosh-kambam/)
