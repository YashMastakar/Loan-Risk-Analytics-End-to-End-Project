-- List of all tables 
select * from dbo.customers_application; --
select * from dbo.previous_application; --
select * from dbo.previous_application_clean; --
select * from dbo.bureau;
select * from dbo.installments;  
select * from dbo.credit_card_balance;

Q1. What is the overall default rate of customers?

select SUM(Default_flag) as Defaults, count(SK_ID_CURR) as total_Cust,SUM(Default_flag)*1.0 /COUNT(SK_ID_CURR) 
AS Default_Rate from customers_application;

Q2. How many total customers are in the portfolio?

select  DISTINCT COUNT(SK_ID_CURR) as total_customers from customers_application;

Q3. What is the average loan amount for defaulters vs non-defaulters?

SELECT  Default_flag,CASE WHEN Default_flag = 1 THEN 'Defalter' ELSE 'Non_Defaulter' end as def_types, AVG(AMT_CREDIT) as Avg_Loan_Amt 
FROM customers_application group by Default_flag;

Q4. Which income group has the highest default rate?

SELECT CASE WHEN AMT_INCOME_TOTAL < 100000 THEN 'Low Income'
WHEN AMT_INCOME_TOTAL BETWEEN 100000 AND 300000 THEN 'Medium Income' WHEN AMT_INCOME_TOTAL BETWEEN 300000 AND 600000 THEN 'High Income' ELSE 'Very High Income'
END AS Income_Bucket, AVG(CAST(Default_flag AS FLOAT)) AS Default_Rate FROM dbo.customers_application
GROUP BY CASE  WHEN AMT_INCOME_TOTAL < 100000 THEN 'Low Income' WHEN AMT_INCOME_TOTAL BETWEEN 100000 AND 300000 THEN 'Medium Income'
WHEN AMT_INCOME_TOTAL BETWEEN 300000 AND 600000 THEN 'High Income' ELSE 'Very High Income' END ORDER BY Default_Rate DESC;

Q5. Does education level impact default probability?

select Coalesce(EDUCATION_TYPE,'Unknown') as EDU_Lev , AVG(CAST(Default_flag AS FLOAT)) as def_rate, COUNT(*) AS Customers
from customers_application group by EDUCATION_TYPE order by  def_rate desc;

Q6. Which age group is riskiest for loan default?

select case when AGE_YEARS < 25 then 'Young' when AGE_YEARS between 25 and 35 then 'Early Career'
 when AGE_YEARS BETWEEN 36 AND 50 then 'Middle Age' ELSE  'Senior' end as Age_Grp
,AVG(CAST(Default_flag AS FLOAT)) as Def_rate from customers_application group by 
case when AGE_YEARS < 25 then 'Young' when AGE_YEARS between 25 and 35 then 'Early Career'
 when AGE_YEARS BETWEEN 36 AND 50 then 'Middle Age' ELSE  'Senior' end
 order by Def_rate desc;

Q7. Are unemployed customers more likely to default?

SELECT CASE WHEN Employment_years = 0 THEN 'UNEMPLOYED' ELSE 'EMPLOYED' end as EMP_TYPE, AVG(CAST(Default_flag AS FLOAT)) as Def_rate  
FROM customers_application group by CASE WHEN Employment_years = 0 THEN 'UNEMPLOYED' ELSE 'EMPLOYED' end  
order by Def_rate desc;

Q8. Do customers with previous loan refusals default more often?

select * from previous_application;
with refusal_summary as (select SK_ID_CURR ,sum(CASE WHEN CONTRACT_STATUS = 'Refused' THEN 1
ELSE 0 end) AS Refusa_cnt from previous_application group by SK_ID_CURR)
SELECT case when r.Refusa_cnt > 0 then 'Has Refusal' else 'No refusal' end as appls_cate ,
AVG(CAST(c.Default_flag AS FLOAT)) as Def_rate,  count(*) as customers
FROM customers_application c  join refusal_summary r on r.SK_ID_CURR = c.SK_ID_CURR 
GROUP BY case when r.Refusa_cnt > 0 then 'Has Refusal' else 'No refusal' end;

Q9. Does higher credit utilization increase default risk?

select case WHEN COALESCE(cc.avg_cc_utilization,0) < 0.3 then 'Low'
when cc.avg_cc_utilization < 0.6 then 'Medium' when cc.avg_cc_utilization < 0.9 then 'High'	else 'Very High' end as Utiliz_Bucket,
AVG(CAST(ca.Default_flag AS FLOAT)) as Default_rate, count(*) as customers
from customers_application ca left join credit_card_agg cc
ON ca.SK_ID_CURR = cc.SK_ID_CURR GROUP BY case  WHEN COALESCE(cc.avg_cc_utilization,0) < 0.3 then 'Low'
when cc.avg_cc_utilization < 0.6 then 'Medium' when cc.avg_cc_utilization < 0.9 then 'High'	else 'Very High' end
order by  Default_rate desc ;

Q10. Are customers with late installment payments riskier?

select Case when ins.LATE_CNT <= 10 then 'LOW' when ins.LATE_CNT <= 30 THEN 'Medium' ELSE  'High' END as LATE_CATE, 
count(*) as total_customers, AVG(CAST(ca.Default_flag AS FLOAT)) as Default_rate
from customers_application ca join installments_agg ins on ca.SK_ID_CURR = ins.SK_ID_CURR
group by Case when ins.LATE_CNT <= 10 then 'LOW' when ins.LATE_CNT <= 30 THEN 'Medium' ELSE  'High' END order by Default_rate desc;

Q11. How does total outstanding debt relate to default?

select  CASE WHEN b.AMT_CREDIT_SUM <= 50000 then 'Low' when b.AMT_CREDIT_SUM <= 150000 then 'Medium'
when b.AMT_CREDIT_SUM <= 300000 then 'High' else 'Very High' END as Outstanding_debt_bucket, AVG(CAST(ca.default_flag as float)) as default_rate, 
COUNT(*) as customers, SUM(CAST(b.AMT_CREDIT_SUM AS BIGINT)) AS total_exposure
from customers_application as ca inner join 
bureau_agg as b on ca.SK_ID_CURR = b.SK_ID_CURR group by CASE WHEN b.AMT_CREDIT_SUM <= 50000 then 'Low' when b.AMT_CREDIT_SUM <= 150000 then 'Medium'
when b.AMT_CREDIT_SUM <= 300000 then 'High' else 'Very High' END 
order by default_rate desc;

Q12. Which customer segment should the bank avoid lending to?

SELECT CASE WHEN AMT_INCOME_TOTAL < 100000 THEN 'Low Income'
WHEN AMT_INCOME_TOTAL BETWEEN 100000 AND 300000 THEN 'Medium Income'
WHEN AMT_INCOME_TOTAL BETWEEN 300000 AND 600000 THEN 'High Income' ELSE 'Very High Income' 
END AS Income_Bucket, AVG(CAST(Default_flag AS FLOAT)) AS Default_Rate, 
COUNT(*) AS total_cust, sum(cast(AMT_CREDIT as float)) AS Exposure, SUM(CAST(AMT_CREDIT AS BIGINT) * Default_flag) AS Expected_loss
from customers_application GROUP BY CASE WHEN AMT_INCOME_TOTAL < 100000 THEN 'Low Income' WHEN AMT_INCOME_TOTAL BETWEEN 100000 AND 300000 THEN 'Medium Income'
WHEN AMT_INCOME_TOTAL BETWEEN 300000 AND 600000 THEN 'High Income' ELSE 'Very High Income' END ORDER BY Default_Rate Desc;

Q13. Which segment has high loan amount but low default risk?

select CASE WHEN AMT_INCOME_TOTAL < 100000 THEN 'Low Income'
WHEN AMT_INCOME_TOTAL BETWEEN 100000 AND 300000 THEN 'Medium Income'
WHEN AMT_INCOME_TOTAL BETWEEN 300000 AND 600000 THEN 'High Income' ELSE 'Very High Income' END AS Income_Bucket, 
AVG(CAST(Default_flag AS FLOAT)) AS Default_Rate, COUNT(*) AS total_cust, sum(cast(AMT_CREDIT as bigint)) AS Exposure
from customers_application
group by CASE WHEN AMT_INCOME_TOTAL < 100000 THEN 'Low Income'
WHEN AMT_INCOME_TOTAL BETWEEN 100000 AND 300000 THEN 'Medium Income'
WHEN AMT_INCOME_TOTAL BETWEEN 300000 AND 600000 THEN 'High Income' ELSE 'Very High Income' END order by Exposure desc, Default_Rate asc;

Q14. Which  customers should be prioritized for monitoring or early warning?

WITH Risk_base as (select c.SK_ID_CURR as cust, c.AMT_CREDIT AS Loan_Amt,  ccag.avg_cc_utilization as avg_utilizat, ag.AVG_DELAY_DAYS as avg_delaydays,
(c.AMT_CREDIT/100000 + ccag.avg_cc_utilization * 10 + avg_delay_days * 1.5) as RISK_SCORE , c.Default_flag as default_flags
from customers_application as c LEFT join installments_agg as ag on c.SK_ID_CURR = AG.SK_ID_CURR
LEFT join credit_card_agg as ccag on c.SK_ID_CURR = ccag.SK_ID_CURR) select * from
(select *, RANK() over (order by RISK_SCORE DESC) AS risk_ranks from Risk_base) t where risk_ranks <= 50;

Q15. Which top 5 risk factors are most associated with default?

 WITH RISK_FACTORS AS ( 
 SELECT 'Income' as Factor_type, CASE WHEN AMT_INCOME_TOTAL < 100000 THEN 'Low Income' 
 WHEN AMT_INCOME_TOTAL BETWEEN 100000 AND 300000 THEN 'Medium Income' WHEN AMT_INCOME_TOTAL BETWEEN 300000 AND 600000 THEN 
 'High Income' ELSE 'Very High Income' END AS Bucket, AVG(CAST(default_flag as float)) as default_rate, count(*) AS customers
 from customers_application group by CASE WHEN AMT_INCOME_TOTAL < 100000 THEN 'Low Income' 
 WHEN AMT_INCOME_TOTAL BETWEEN 100000 AND 300000 THEN 'Medium Income' WHEN AMT_INCOME_TOTAL BETWEEN 300000 AND 600000 THEN 
 'High Income' ELSE 'Very High Income' END UNION ALL 

SELECT 'Utilization' as Factor_type , case WHEN COALESCE(ccag.avg_cc_utilization,0) < 0.3 then 'Low' when ccag.avg_cc_utilization < 0.6 
then 'Medium' when ccag.avg_cc_utilization < 0.9 then 'High'	else 'Very High' end, AVG(CAST(c.default_flag as float)), count(*)
from customers_application c join credit_card_agg ccag on ccag.SK_ID_CURR = c.SK_ID_CURR GROUP BY case WHEN COALESCE(ccag.avg_cc_utilization,0) < 0.3 then 'Low' when ccag.avg_cc_utilization < 0.6 
then 'Medium' when ccag.avg_cc_utilization < 0.9 then 'High'	else 'Very High' end UNION ALL 

SELECT 'Loan Size' as Factor_type,  CASE WHEN AMT_CREDIT <= 100000 then 'Small' when AMT_CREDIT <= 300000  then 'Medium' when AMT_CREDIT <= 600000 then 'Large' 
else 'Very Large' END, AVG(CAST(default_flag as float)), count(*)
from customers_application group by CASE WHEN AMT_CREDIT <= 100000 then 'Small' when AMT_CREDIT <= 300000  then 'Medium' when AMT_CREDIT <= 600000 then 'Large' 
else 'Very Large' END union all 

SELECT 'Debt' as Factor_type, case when b.AMT_CREDIT_SUM <= 50000 THEN 'Low Debt' when b.AMT_CREDIT_SUM <= 150000 THEN 'Medium Debt' when b.AMT_CREDIT_SUM <= 300000 
then 'High Debt' else 'Very High Debt' end, AVG(CAST(c.default_flag as float)), count(*)
from customers_application c join bureau b on c.SK_ID_CURR = b.SK_ID_CURR group by case when b.AMT_CREDIT_SUM <= 50000 THEN 'Low Debt'
when b.AMT_CREDIT_SUM <= 150000 THEN 'Medium Debt' when b.AMT_CREDIT_SUM <= 300000 then 'High Debt' else 'Very High Debt' end ) 
select * from (select *, RANK() OVER (ORDER BY default_rate desc) as risk_rank from RISK_FACTORS) t where risk_rank <= 5;



























