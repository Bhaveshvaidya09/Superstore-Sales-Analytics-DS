USE SuperstoreAnalytics;
GO

-- ============================================================================
-- SUPERSTORE SALES ANALYTICS - MASTER SQL QUERIES
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. "CASH COW" PRODUCT ANALYSIS (Category & Sub-Category Performance)
-- Business Value: Identifies the highest revenue-driving products and Average Order Value (AOV).
-- ----------------------------------------------------------------------------
SELECT 
    Category,
    Sub_Category,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    SUM(Revenue) AS Total_Revenue,
    ROUND(SUM(Revenue) / COUNT(DISTINCT Order_ID), 2) AS Avg_Order_Value
FROM 
    vw_Superstore_Sales_Master
GROUP BY 
    Category, 
    Sub_Category
ORDER BY 
    Total_Revenue DESC;


-- ----------------------------------------------------------------------------
-- 2. TIME-SERIES: MONTH-OVER-MONTH (MoM) REVENUE GROWTH
-- Business Value: Tracks monthly sales momentum and calculates percentage growth/decline.
-- ----------------------------------------------------------------------------
WITH MonthlySales AS (
    SELECT 
        Order_Year_Month,
        SUM(Revenue) AS Current_Month_Revenue
    FROM 
        vw_Superstore_Sales_Master
    GROUP BY 
        Order_Year_Month
)
SELECT 
    Order_Year_Month,
    Current_Month_Revenue,
    LAG(Current_Month_Revenue, 1) OVER (ORDER BY Order_Year_Month) AS Previous_Month_Revenue,
    ROUND(
        ((Current_Month_Revenue - LAG(Current_Month_Revenue, 1) OVER (ORDER BY Order_Year_Month)) / 
        NULLIF(LAG(Current_Month_Revenue, 1) OVER (ORDER BY Order_Year_Month), 0)) * 100, 2
    ) AS MoM_Growth_Percentage
FROM 
    MonthlySales
ORDER BY 
    Order_Year_Month;


-- ----------------------------------------------------------------------------
-- 3. GEOGRAPHIC TARGETING: TOP REGIONAL MARKETS BY RANK
-- Business Value: Ranks top-performing States and Cities nationally to optimize marketing ad spend.
-- ----------------------------------------------------------------------------
SELECT 
    State,
    City,
    SUM(Revenue) AS Total_Revenue,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    RANK() OVER (ORDER BY SUM(Revenue) DESC) AS National_Rank
FROM 
    vw_Superstore_Sales_Master
GROUP BY 
    State, 
    City
ORDER BY 
    Total_Revenue DESC;


-- ----------------------------------------------------------------------------
-- 4. CUSTOMER SEGMENTATION: VIP LIFETIME VALUE (LTV)
-- Business Value: Identifies the top 10 highest-spending customers for targeted loyalty programs.
-- ----------------------------------------------------------------------------
SELECT TOP 10
    Customer_ID,
    Customer_Name,
    Customer_Segment,
    COUNT(DISTINCT Order_ID) AS Purchase_Frequency,
    SUM(Revenue) AS Total_Lifetime_Value
FROM 
    vw_Superstore_Sales_Master
GROUP BY 
    Customer_ID, 
    Customer_Name, 
    Customer_Segment
ORDER BY 
    Total_Lifetime_Value DESC;


-- ----------------------------------------------------------------------------
-- 5. SUPPLY CHAIN EFFICIENCY: SHIPPING SLA FAILURE RATE
-- Business Value: Evaluates warehouse efficiency and delayed shipment impact.
-- ----------------------------------------------------------------------------
SELECT 
    Ship_Mode,
    Shipping_SLA_Status,
    COUNT(Order_ID) AS Total_Shipments,
    SUM(Revenue) AS Affected_Revenue
FROM 
    vw_Superstore_Sales_Master
GROUP BY 
    Ship_Mode, 
    Shipping_SLA_Status
ORDER BY 
    Ship_Mode, 
    Shipping_SLA_Status DESC;


-- ----------------------------------------------------------------------------
-- 6. ORDER BASKET SIZE DISTRIBUTION
-- Business Value: Analyzes how much revenue comes from high, mid, or low-value individual orders.
-- ----------------------------------------------------------------------------
SELECT 
    Revenue_Tier,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    SUM(Revenue) AS Total_Revenue,
    ROUND((COUNT(DISTINCT Order_ID) * 100.0) / (SELECT COUNT(DISTINCT Order_ID) FROM vw_Superstore_Sales_Master), 2) AS Percentage_Of_All_Orders
FROM 
    vw_Superstore_Sales_Master
GROUP BY 
    Revenue_Tier
ORDER BY 
    Total_Revenue DESC;


-- ----------------------------------------------------------------------------
-- 7. SEASONALITY & SHOPPING BEHAVIOR (DAY OF WEEK ANALYSIS)
-- Business Value: Discovers which day of the week generates the most sales to optimize flash sales.
-- ----------------------------------------------------------------------------
SELECT 
    Order_Day_Of_Week,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    SUM(Revenue) AS Total_Revenue
FROM 
    vw_Superstore_Sales_Master
GROUP BY 
    Order_Day_Of_Week
ORDER BY 
    Total_Revenue DESC;


-- ----------------------------------------------------------------------------
-- 8. RECENCY ANALYSIS (CHURN RISK)
-- Business Value: Identifies the last time a customer made a purchase to flag inactive accounts.
-- ----------------------------------------------------------------------------
SELECT 
    Customer_ID,
    Customer_Name,
    MAX(Order_Date_Formatted) AS Last_Purchase_Date,
    DATEDIFF(DAY, MAX(Order_Date_Formatted), (SELECT MAX(Order_Date_Formatted) FROM vw_Superstore_Sales_Master)) AS Days_Since_Last_Purchase,
    SUM(Revenue) AS Total_Spend
FROM 
    vw_Superstore_Sales_Master
GROUP BY 
    Customer_ID, 
    Customer_Name
ORDER BY 
    Days_Since_Last_Purchase DESC;


-- ----------------------------------------------------------------------------
-- 9. TOP CUSTOMER PER REGION (WINDOW PARTITIONING)
-- Business Value: Finds the single best customer in every region using ROW_NUMBER().
-- ----------------------------------------------------------------------------
WITH RankedCustomers AS (
    SELECT 
        Region,
        Customer_Name,
        SUM(Revenue) AS Total_Revenue,
        ROW_NUMBER() OVER(PARTITION BY Region ORDER BY SUM(Revenue) DESC) AS Regional_Rank
    FROM 
        vw_Superstore_Sales_Master
    GROUP BY 
        Region, 
        Customer_Name
)
SELECT 
    Region,
    Customer_Name AS Top_Regional_Customer,
    Total_Revenue
FROM 
    RankedCustomers
WHERE 
    Regional_Rank = 1
ORDER BY 
    Total_Revenue DESC;


-- ----------------------------------------------------------------------------
-- 10. CUMULATIVE (RUNNING) TOTAL REVENUE
-- Business Value: Shows the running total of revenue over time to visualize trajectory.
-- ----------------------------------------------------------------------------
WITH MonthlyTotals AS (
    SELECT 
        Order_Year_Month,
        SUM(Revenue) AS Monthly_Revenue
    FROM 
        vw_Superstore_Sales_Master
    GROUP BY 
        Order_Year_Month
)
SELECT 
    Order_Year_Month,
    Monthly_Revenue,
    SUM(Monthly_Revenue) OVER (ORDER BY Order_Year_Month ROWS UNBOUNDED PRECEDING) AS Cumulative_Revenue
FROM 
    MonthlyTotals
ORDER BY 
    Order_Year_Month;