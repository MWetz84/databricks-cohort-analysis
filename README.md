# 📊 Databricks Cohort Analysis

**Uncovering Customer Behavior Trends with SQL & Databricks**

[![Databricks](https://img.shields.io/badge/Databricks-FF3621?style=for-the-badge&logo=databricks&logoColor=white)](https://www.databricks.com/)
[![SQL](https://img.shields.io/badge/SQL-4479A1?style=for-the-badge&logo=postgresql&logoColor=white)](https://en.wikipedia.org/wiki/SQL)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## 📋 Project Overview

This project demonstrates end-to-end data transformation and visualization capabilities within the Databricks environment. It focuses on analyzing customer purchasing behavior from raw e-commerce order data to derive actionable insights through cohort analysis.

### 🎯 Business Challenge

The primary objective was to understand customer retention and repeat purchase patterns. By transforming raw order data, the project aims to:
- Identify key customer lifecycle events (first and second purchases).
- Quantify the time between initial purchases.
- Visualize customer cohorts to reveal trends in retention, repeat purchases, and cohort growth over time.

## 🏗️ Methodology & Data Transformation

The analysis was performed using **Databricks SQL Endpoints** and involved several key data transformation steps:

1.  **First Purchase Date Calculation:** Determined the earliest order date for each customer.
2.  **Second Purchase Date Identification:** Identified the earliest order date following the first purchase for each customer.
3.  **Days Between Purchases:** Calculated the time difference (in days) between the first and second purchases.
4.  **Cohort Table Creation:** The transformed data was saved as a new table (`cohort_analysis`) to serve as the foundation for subsequent visualizations.

*(Refer to `sql/DA114.5-Project_Cohort_analysis-unified_query.sql` for the unified query.)*

## 📊 Visualizations & Key Insights

Insights derived from the `cohort_analysis` table were visualized using **Databricks Dashboards**. These visualizations provide a clear understanding of customer behavior across different cohorts.

*(Screenshots of the dashboards will be placed here.)*

### 📈 Retention Rate by Cohort
*(Screenshot: `visualizations/Retention Rate by Cohort.png`)*
This visualization shows the percentage of customers who placed a second order within specific timeframes (e.g., 1, 2, and 3 months) after their first purchase.

### 📈 Repeat Purchase Rate by Cohort
*(Screenshot: `visualizations/Repeat Purchase Rates.png`)*
This visualization illustrates the percentage of customers who placed a 2nd, 3rd, and 4th order, providing insights into customer loyalty and purchasing depth.

### 📈 Cohort Size by Month
*(Screenshot: `visualizations/Cohort Size by Month.png`)*
This visualization tracks the number of new customers acquired each month, allowing for an understanding of cohort growth and acquisition trends.

## 🔧 Technical Stack

-   **Platform**: Databricks
-   **Language**: SQL
-   **Data Storage**: Delta Lake (within Databricks)
-   **Visualization**: Databricks Dashboards

## 🚀 Getting Started

To run this project in your Databricks environment:

1.  **Set up Databricks:** Ensure you have access to a Databricks workspace (e.g., a Free Trial account).
2.  **Upload Source Data:**
    *   The raw `ecom_orders.csv` dataset is included in the `data/` directory of this repository.
    *   Upload this `ecom_orders.csv` file to your Databricks workspace (e.g., to DBFS or a Unity Catalog volume).
    *   Create a table named `ecom_orders` in your desired database/schema (e.g., `workspace.bigquery_db_cohortdb.ecom_orders` as referenced in the SQL queries) that points to this uploaded CSV data.
3.  **Run SQL Transformations:**
    *   Open a new SQL notebook or query editor in Databricks.
    *   Copy and paste the content of `sql/DA114.5-Project_Cohort_Analysis-unified_query.sql` into a SQL cell or query editor.
    *   Execute the query to create the `cohort_analysis` table.
4.  **Create Visualizations:**
    *   Use the `cohort_analysis` table to recreate the visualizations as described in the "Visualizations & Key Insights" section, using Databricks Dashboards.

## 🏆 Key Achievements & Skills Demonstrated

✅ **Cohort Analysis Implementation**: Successfully transformed raw order data to enable detailed customer cohort analysis.  
✅ **Advanced SQL**: Utilized complex SQL queries (CTEs, window functions, date functions) for data transformation and aggregation.  
✅ **Databricks Proficiency**: Demonstrated hands-on experience with Databricks SQL Endpoints and Dashboards.  
✅ **Data Visualization**: Created insightful and clear visualizations to communicate complex customer behavior patterns.  
✅ **Problem-Solving**: Identified and addressed data nuances (e.g., multiple orders on same day) to ensure accurate analysis.  
✅ **Data Storytelling**: Presented analytical findings in a clear, actionable format.  

## 📞 Contact & Collaboration

**Looking for opportunities in data analytics and data engineering!**

-   📧 Email: m.wetzel-auma@t-online.de
-   💼 LinkedIn: https://www.linkedin.com/in/wetzelmich/
-   🐱 GitHub: https://github.com/MWetz84

---

*This project showcases practical skills in customer analytics, data transformation, and effective use of the Databricks platform to drive business insights.*