# 📊 Credit Risk Analytics – End-to-End Loan Risk Analysis

![Power BI](https://img.shields.io/badge/PowerBI-Dashboard-yellow?logo=powerbi)
![SQL Server](https://img.shields.io/badge/SQL-Server-blue?logo=microsoftsqlserver)
![Excel](https://img.shields.io/badge/Excel-Analysis-green?logo=microsoftexcel)
![DAX](https://img.shields.io/badge/DAX-Measures-orange)
![Status](https://img.shields.io/badge/Project-Completed-success)
![Domain](https://img.shields.io/badge/Domain-Finance%20%7C%20Risk%20Analytics-blueviolet)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

## Project Overview
This project is an end-to-end **Credit Risk Analytics solution** built using SQL, Power BI, and Excel to analyze customer loan behavior, identify risky borrowers, and support smarter lending decisions.

It converts raw financial data into **actionable dashboards, customer segmentation, and risk scoring models** used by operations and risk teams.

---

## Business Problem
Banks and NBFCs face:
- High loan default rates  
- Manual reporting delays  
- No clear visibility of risky customers  
- Difficulty prioritizing collections  

Without analytics, operations teams cannot quickly detect **who will default, where exposure is high, and which segments to avoid**.

---

## Objectives
- Identify high-risk customers early  
- Segment customers by income, utilization, and debt  
- Track default probability & expected loss  
- Monitor portfolio exposure  
- Build interactive dashboards for decision-makers  
- Enable drill-through customer-level risk analysis  

---

## Dataset Information

### Tables Used
- customers_application  
- previous_application  
- bureau  
- installments  
- credit_card_balance  

### Data Scale
- 300K+ customers  
- Multiple historical loan tables  
- Millions of transaction-level records  

### Key Features
- Income, loan amount, debt exposure  
- Payment delays  
- Installment history  
- Credit utilization  
- Default flag (target variable)  

---

## Tools & Technologies Used
- SQL Server – Data cleaning & aggregations  
- Power BI – Dashboarding  
- DAX – Risk metrics & KPIs  
- Excel – Initial exploration  
- Star Schema Data Modeling  
- Bookmarks & Drill-through navigation  

---

## Project Workflow
1. Raw data cleaning using SQL  
2. Handling nulls and outliers  
3. Aggregation to customer level  
4. Creation of risk features (delay %, utilization %, debt buckets)  
5. Star schema modeling  
6. DAX KPI creation  
7. Interactive Power BI dashboard development  
8. Business insights & recommendations  

---

## Key KPIs Tracked
- Total Customers  
- Total Loan Amount  
- Default Rate %  
- Expected Loss  
- Risky Customers Count  
- Avg Utilization %  
- Avg Delay Days  
- Late Payment Customers  
- Segment Exposure  

---

## Walkthrough of Key Visuals of Power BI

### 🟦 Overview Page
- Portfolio summary KPIs  
- Default rate by Age Group  
- Default rate by Loan Purpose  
- Risk Category distribution  

### 🟨 Risk Drivers Page
- Credit Card Utilization vs Default  
- Installment Delay vs Default  
- Income vs Loan Exposure scatter plot  
- Risk Heatmap matrix  
- Explains **WHY customers default**

### 🟩 Customer Segmentation Page
- Segment Risk vs Exposure matrix  
- Risk Origin Analysis (Decomposition tree)  
- Customer Risk Funnel  
- Segment performance summary  
- Shows **WHICH segments are risky**

### 🟥 Customer Detail Page (Drill-through)
- Individual customer profile  
- Risk score breakdown  
- Education distribution  
- Full customer table  
- Shows **WHO exactly is risky**

---

## Filters Panel
Interactive slicers available across pages:
- Age Bucket  
- Income Bucket  
- Risk Category  

Used for dynamic portfolio filtering.

---

## Key Insights
- High utilization customers show the highest default rates  
- Longer payment delays strongly correlate with default  
- Low income + high loan exposure increases risk  
- Small % of customers contribute the majority of portfolio risk  

---

## Business Recommendations
- Avoid lending to high utilization + high debt customers  
- Use risk score during approvals  
- Monitor delayed payers proactively  
- Prioritize collections for high-risk segments  
- Automate portfolio dashboards for operations

---

## Screenshots
- Overview Dashboard 
- Risk Drivers Dashboard  
- Customer Segmentation  
- Customer Drill-through

The following snapshots illustrate the dashboard's design and analytical layout:

| Page Name | Screenshot |
| :--- | :--- |
| Overview  | ![Overv](https://github.com/YashMastakar/Loan-Risk-Analytics-End-to-End-Project/blob/main/Loan_risk_analysis_1stPage_Overview.png) |
| Risk Drivers | ![Risk DriveSnapshot](https://github.com/YashMastakar/Loan-Risk-Analytics-End-to-End-Project/blob/main/Loan_risk_analysis_2ndPage_Risk_Drivers.png) |
| Customer Segmentation | ![Cust Snapshot](https://github.com/YashMastakar/Loan-Risk-Analytics-End-to-End-Project/blob/main/Loan_risk_analysis_3rdPage_Risk_Cust_Segmentation.png) |
| Customer Drill-through | ![Customer Drill- through-Snapshot](https://github.com/YashMastakar/Loan-Risk-Analytics-End-to-End-Project/blob/main/Loan_risk_analysis_4thPage_Drill_through_page.png) |

---

## Author
**Yash Mastakar**  
Data Analytics | SQL | Power BI | Risk Analytics  
Aspiring Business Analyst
