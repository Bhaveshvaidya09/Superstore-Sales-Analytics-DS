📊 Superstore Executive Sales & Operations Command Center

Future Interns - Task 1 Submission

Track Code: DS (Data Science & Analytics)

🎯 Project Overview & Problem Statement

Despite generating consistent multi-regional sales, the Superstore retail chain lacked actionable visibility into its primary revenue drivers. Leadership struggled to identify which specific product sub-categories, customer segments, or geographic regions were propelling growth versus underperforming. Furthermore, the supply chain team lacked a standardized method to track delivery SLA (Service Level Agreement) failures.

Without this granular intelligence, the business could not optimize its inventory, tailor localized marketing campaigns, or allocate resources efficiently.

💡 Business Solutions Delivered

This project resolves the blind spots by delivering an end-to-end, automated analytics pipeline. The final Command Center dashboard allows executives to:

Target High-Value Products: Pinpoint "Cash Cow" categories to drive inventory purchasing decisions.

Optimize Logistics: Monitor real-time shipping SLA failure rates across different shipping modes.

Execute Targeted Marketing: Utilize Machine Learning-based RFM (Recency, Frequency, Monetary) Segmentation to identify VIP "Champions" and customers at high risk of churn.

Allocate Regional Ad Spend: Rank top-performing States and Cities to maximize Return on Ad Spend (ROAS).

🛠️ Tech Stack & Implementation Deep-Dive

1. Python (Data Engineering & Advanced Analytics)

Exploratory Data Analysis (EDA) & Cleaning: Handled missing geographic data, standardized date formats, and resolved data type inconsistencies.

Feature Engineering: Calculated Processing_Days by extracting the delta between order and shipping dates.

Statistical Outlier Detection: Implemented the Interquartile Range (IQR) method to detect and flag massive "Whale" orders that could skew baseline analytics.

Machine Learning Prep (RFM Segmentation): Grouped the customer base and calculated percentile scores (1-4) for Recency, Frequency, and Monetary value, automatically classifying buyers into actionable business tiers (e.g., "Champions", "Churn Risk").

2. SQL Server (Relational Modeling & Advanced Querying)

Master View Creation: Built a highly optimized vw_Superstore_Sales_Master view handling all business logic, preventing the BI tool from performing heavy transformations.

Advanced Querying (CTEs & Window Functions):

Used LAG() to calculate Month-over-Month (MoM) revenue growth.

Used RANK() and ROW_NUMBER() with PARTITION BY to identify top regional customers.

Extracted cumulative running totals and dynamic basket-size categorization.

3. Power BI (Visualization & Business Intelligence)

Relational Data Modeling: Established a 1-to-Many (*:1) relationship linking the Master Sales table to the Python-generated Customer RFM Segments table.

Advanced DAX Measures: Engineered dynamic KPIs including Average Order Value (AOV), On-Time Delivery Rate (%), and MoM Growth.

UI/UX Design: Developed a premium dark-themed aesthetic (Dark Navy/Sky Blue) with interactive slicers, cross-filtering, and conditional formatting to immediately highlight SLA breaches.

📈 Key Performance Indicators (KPIs) Engineered

Total Revenue: Establishes the baseline financial trajectory.

Total Orders: Measures actual transaction volume and warehouse throughput demand.

Average Order Value (AOV): Tracks basket size to evaluate upselling effectiveness.

Total Unique Customers: Validates market penetration vs. reliance on repeat buyers.

Delayed Shipments (Count): Quantifies exact backlog volume breaching the 4-day SLA.

On-Time Delivery Rate (%): Standardizes supply chain efficiency against corporate targets.

📂 Repository Structure

Superstore_Data_Science_EDA.ipynb: The Jupyter Notebook containing the Python pipeline (Cleaning, Outliers, RFM).

Superstore_SQL_Queries.sql: The master SQL script containing the View creation and 10 advanced analytical queries.

Superstore_Analytics_Project_Report_v2.docx: The formal, written documentation of the project.

Dashboard.pbix: The interactive Power BI dashboard file. (Note: Requires Power BI Desktop to open).

Developed by Bhavesh Ajay Vaidya for the Future Interns Data Science & Analytics Track.
