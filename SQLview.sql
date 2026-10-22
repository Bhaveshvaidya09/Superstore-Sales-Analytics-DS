USE SuperstoreAnalytics;
GO

-- Drop view if it already exists
IF OBJECT_ID('vw_Superstore_Sales_Master', 'V') IS NOT NULL
    DROP VIEW vw_Superstore_Sales_Master;
GO

CREATE VIEW vw_Superstore_Sales_Master AS
SELECT 
    -- 1. Order & Shipping Information
    Order_ID,
    CAST(Order_Date AS DATE)             AS Order_Date_Formatted,
    CAST(Ship_Date AS DATE)              AS Ship_Date_Formatted,
    Ship_Mode,
    
    -- 2. Time Intelligence Attributes
    YEAR(Order_Date)                     AS Order_Year_Num,
    MONTH(Order_Date)                    AS Order_Month_Number,
    DATENAME(MONTH, Order_Date)          AS Order_Month_Name,
    DATENAME(WEEKDAY, Order_Date)        AS Order_Day_Of_Week,
    DATEPART(QUARTER, Order_Date)        AS Order_Quarter,
    FORMAT(Order_Date, 'yyyy-MM')        AS Order_Year_Month,
    
    -- 3. Customer Demographics
    Customer_ID,
    Customer_Name,
    Segment                              AS Customer_Segment,
    
    -- 4. Geographic Hierarchy
    Country,
    City,
    State,
    Postal_Code,
    Region,
    
    -- 5. Product Classification
    Product_ID,
    Category,
    Sub_Category,
    Product_Name,
    
    -- 6. Core Financial Metrics
    ROUND(Revenue, 2)                    AS Revenue,
    
    -- 7. Advanced Supply Chain & Operational Indicators
    DATEDIFF(DAY, Order_Date, Ship_Date) AS Operational_Shipping_Days,
    
    -- Shipping SLA Risk Flag
    CASE 
        WHEN DATEDIFF(DAY, Order_Date, Ship_Date) > 4 THEN 'Delayed'
        ELSE 'On-Time'
    END AS Shipping_SLA_Status,

    -- Basket / Order Size Categorization
    CASE 
        WHEN Revenue >= 1000 THEN 'High Value (>$1000)'
        WHEN Revenue >= 300 THEN 'Mid Value ($300-$1000)'
        ELSE 'Low Value (<$300)'
    END AS Revenue_Tier

FROM 
    Cleaned_Superstore_Sales;
GO