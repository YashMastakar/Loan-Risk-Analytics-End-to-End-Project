create database Loanriskanalysis;
use Loanriskanalysis;
select * from dbo.customers_application;

-- Creating primary and foreign key in all the tables 
-- List of all tables 
select * from dbo.customers_application; --
select * from dbo.previous_application; --
select * from dbo.previous_application_clean; --
select * from dbo.bureau;
select * from dbo.installments;  
select * from dbo.credit_card_balance;

-- Checking primary keys 
SELECT OBJECT_NAME(ic.OBJECT_ID) AS TableName, COL_NAME(ic.OBJECT_ID, ic.column_id) AS ColumnName,
i.name AS ConstraintNameFROM sys.indexes AS i
INNER JOIN sys.index_columns AS ic 
ON i.OBJECT_ID = ic.OBJECT_ID AND i.index_id = ic.index_id
WHERE i.is_primary_key = 1;

-- Making column SK_ID_CURR of table dbo.customers_application into primary key constraint for building database schema

-- Making SK_ID_CURR Column into not Null
ALTER TABLE dbo.customers_application
ALTER COLUMN SK_ID_CURR INT not null;

-- Checking SK_ID_CURR column is customers_application table
SELECT * FROM dbo.customers_application where SK_ID_CURR is null;

-- Checking for Duplicates 
SELECT SK_ID_CURR , COUNT(*) AS CNT_COLUMNS 
FROM dbo.customers_application group by SK_ID_CURR HAVING COUNT(*) > 1;

-- GIVING SK_ID_CURR COLUMN A PRIMARY CONSTRAINT
ALTER TABLE dbo.customers_application ADD CONSTRAINT PK_customer_application PRIMARY KEY (SK_ID_CURR);

-- Checking Orphan Records in all tables to sucessfully add foriegn key constraint - 
select DISTINCT p.SK_ID_CURR from dbo.previous_application p 
left join dbo.customers_application c
on p.SK_ID_CURR = c.SK_ID_CURR
WHERE c.SK_ID_CURR is null;

SELECT DISTINCT b.SK_ID_CURR
FROM dbo.bureau b
LEFT JOIN dbo.customers_application c
ON b.SK_ID_CURR = c.SK_ID_CURR
WHERE c.SK_ID_CURR IS NULL;

SELECT DISTINCT i.SK_ID_CURR
FROM dbo.installments i
LEFT JOIN dbo.customers_application c
ON i.SK_ID_CURR = c.SK_ID_CURR
WHERE c.SK_ID_CURR IS NULL;

SELECT DISTINCT cb.SK_ID_CURR
FROM dbo.credit_card_balance cb
LEFT JOIN dbo.customers_application c
ON cb.SK_ID_CURR = c.SK_ID_CURR
WHERE c.SK_ID_CURR IS NULL;

-- Deleting Orphan rows 
DELETE p from dbo.previous_application p
left join dbo.customers_application c 
on p.SK_ID_CURR = c.SK_ID_CURR 
WHERE c.SK_ID_CURR is null;

DELETE b from dbo.bureau b
left join dbo.customers_application c 
on b.SK_ID_CURR = c.SK_ID_CURR 
WHERE c.SK_ID_CURR is null;

DELETE i from dbo.installments i
left join dbo.customers_application c 
on i.SK_ID_CURR = c.SK_ID_CURR 
WHERE c.SK_ID_CURR is null;

DELETE cb from dbo.credit_card_balance cb
left join dbo.customers_application c 
on cb.SK_ID_CURR = c.SK_ID_CURR 
WHERE c.SK_ID_CURR is null;

-- making forigh key columns as null
ALTER TABLE dbo.previous_application
ALTER COLUMN SK_ID_CURR INT NOT NULL;

ALTER TABLE dbo.bureau
ALTER COLUMN SK_ID_CURR INT NOT NULL;

ALTER TABLE dbo.installments
ALTER COLUMN SK_ID_CURR INT NOT NULL;

ALTER TABLE dbo.credit_card_balance
ALTER COLUMN SK_ID_CURR INT NOT NULL;

-- giving foriegn keys to all tables
ALTER TABLE dbo.previous_application
ADD CONSTRAINT FK_prevapp_customer
FOREIGN KEY (SK_ID_CURR)
REFERENCES dbo.customers_application (SK_ID_CURR);

ALTER TABLE dbo.bureau
ADD CONSTRAINT FK_bureau_customer
FOREIGN KEY (SK_ID_CURR)
REFERENCES dbo.customers_application (SK_ID_CURR);

ALTER TABLE dbo.installments
ADD CONSTRAINT FK_installments_informa
FOREIGN KEY (SK_ID_CURR)
REFERENCES dbo.customers_application (SK_ID_CURR);

ALTER TABLE dbo.credit_card_balance
ADD CONSTRAINT FK_credit_balance
FOREIGN KEY (SK_ID_CURR)
REFERENCES dbo.customers_application (SK_ID_CURR);

-- Creating indexes for faster joins 
create index idx_customerapp_skid
on dbo.customers_application (SK_ID_CURR);

CREATE INDEX idx_prevapp_skid
ON dbo.previous_application (SK_ID_CURR);

CREATE INDEX idx_burea_skid
ON dbo.bureau (SK_ID_CURR);

CREATE INDEX idx_installmen_skid
ON dbo.installments (SK_ID_CURR);

CREATE INDEX idx_credbalanc_skid
ON dbo.credit_card_balance (SK_ID_CURR);

CREATE INDEX idx_cc_curr
ON credit_card_agg(SK_ID_CURR);


-- Data Cleaning
-- cleaning customers_application table
-- 1) Removing percentage to successfuly convert datatype from nvarchar to decimal
update customers_application 
set REGION_POPULATION_RELATIVE = REPLACE(REPLACE(REGION_POPULATION_RELATIVE, '%',''),',','')
WHERE REGION_POPULATION_RELATIVE IS NOT NULL;

-- 2) Converting datatype from nvarchar to decimal
ALTER TABLE dbo.customers_application
ALTER COLUMN  REGION_POPULATION_RELATIVE decimal(10,6);
select * from dbo.customers_application;

-- 3) Converting Others from occupation_type column to  Unknown
update dbo.customers_application
set OCCUPATION_TYPE = 'Unknown'
where OCCUPATION_TYPE like 'Others%'
or OCCUPATION_TYPE is null;

-- 4) Converting XNA to others in Organization_type
update dbo.customers_application set ORGANIZATION_TYPE = 'Others' 
where ORGANIZATION_TYPE LIKE 'XNA%' ;

-- Cleaning typing errors in numeric columns

-- 5) Remove - sign from DAYS_BIRTH
update dbo.customers_application 
set DAYS_BIRTH = ABS(DAYS_BIRTH);

-- 5) Remove - sign from DAYS_EMPLOYED
update dbo.customers_application 
set DAYS_EMPLOYED = ABS(DAYS_EMPLOYED);

-- 6) Remove - sign from DAYS_REGISTRATION
update dbo.customers_application 
set DAYS_REGISTRATION = ABS(DAYS_REGISTRATION);

-- 7) Remove - sign from Days_id_publish
update dbo.customers_application
set DAYS_ID_PUBLISH = ABS(DAYS_ID_PUBLISH);

-- 8) Removing - sign from OWN_CAR_AGE
update dbo.customers_application
set OWN_CAR_AGE = ABS(OWN_CAR_AGE);

ALTER TABLE dbo.customers_application DROP COLUMN DAYS_EMPLOYED;
-- As there is Already column EMPLOYMENT_YEARS there is no need to days column 

SELECT * FROM dbo.customers_application;

-- removing nulls from decimans columns 
UPDATE dbo.customers_application SET 
    APARTMENTS_AVG   = COALESCE(APARTMENTS_AVG, 0),
    BASEMENTAREA_AVG = COALESCE(BASEMENTAREA_AVG, 0),
	YEARS_BEGINEXPLUATATION_AVG = COALESCE(YEARS_BEGINEXPLUATATION_AVG, 0),
    YEARS_BUILD_AVG   = COALESCE(YEARS_BUILD_AVG, 0),
    COMMONAREA_AVG   = COALESCE(COMMONAREA_AVG, 0),
    ELEVATORS_AVG    = COALESCE(ELEVATORS_AVG, 0);


-- cleaning PREVIOUS_APPLICATION table
UPDATE dbo.previous_application
SET DAYS_FIRST_DRAWING = ABS(DAYS_FIRST_DRAWING)
WHERE DAYS_FIRST_DRAWING < 0;

UPDATE dbo.previous_application
SET DAYS_FIRST_DUE2 = ABS(DAYS_FIRST_DUE2)
WHERE DAYS_FIRST_DUE2 < 0;

UPDATE dbo.previous_application
SET DAYS_LAST_DUE_1ST_VERSION = ABS(DAYS_LAST_DUE_1ST_VERSION)
WHERE DAYS_LAST_DUE_1ST_VERSION < 0;

UPDATE dbo.previous_application
SET DAYS_LAST_DUE = ABS(DAYS_LAST_DUE)
WHERE DAYS_LAST_DUE < 0;

UPDATE dbo.previous_application
SET DAYS_TERMINATION = ABS(DAYS_TERMINATION)
WHERE DAYS_TERMINATION < 0;

-- 6) Create new column building quality score 
update dbo.customers_application set 
COMMONAREA_AVG = COALESCE(COMMONAREA_AVG,0),APARTMENTS_AVG   = COALESCE(APARTMENTS_AVG, 0),
BASEMENTAREA_AVG = COALESCE(BASEMENTAREA_AVG, 0), ENTRANCES_AVG    = COALESCE(ENTRANCES_AVG, 0),
FLOORSMAX_AVG    = COALESCE(FLOORSMAX_AVG, 0),ELEVATORS_AVG    = COALESCE(ELEVATORS_AVG, 0);

ALTER TABLE dbo.customers_application add building_qual_score FLOAT;

UPDATE DBO.customers_application SET building_qual_score = (COMMONAREA_AVG + APARTMENTS_AVG + BASEMENTAREA_AVG +ENTRANCES_AVG +
FLOORSMAX_AVG +ELEVATORS_AVG) / 6.0;

-- Cleaning previous_application table
-- keeping only relevant records
select CONTRACT_STATUS from dbo.previous_application;

-- Keep only Approved and Refused loans
DELETE FROM dbo.previous_application
WHERE CONTRACT_STATUS NOT IN ('Approved', 'Refused');

-- Creating column credit gap
ALTER TABLE dbo.previous_application 
add credit_gap float;

update dbo.previous_application 
set credit_gap = AMT_CREDIT - AMT_APPLICATION

-- making new column approv_flag
 ALTER TABLE  dbo.previous_application
 add approved_flag int;
 update dbo.previous_application set
 approved_flag = case when CONTRACT_STATUS = 'approved' then 1 else 0 end;

 -- Removing duplicates from previous_application
 
 SELECT *, ROW_NUMBER() OVER (PARTITION BY SK_ID_CURR, DAYS_DECISION, AMT_APPLICATION ORDER BY SK_ID_PREV) AS rn
FROM dbo.previous_application;

 WITH cte AS (SELECT *, ROW_NUMBER() OVER (PARTITION BY SK_ID_CURR, DAYS_DECISION, AMT_APPLICATION ORDER BY SK_ID_PREV) AS rn
FROM dbo.previous_application) DELETE FROM cte WHERE rn > 1;

-- Aggregating to customer level 

select SK_ID_CURR, COUNT(*) AS total_prev_applications,
sum(approved_flag) as approved_apps, count(*)-sum(approved_flag) as refused_apps,
avg(AMT_CREDIT) as AVG_CREDIT, MAX(AMT_CREDIT) AS MAX_CREDIT,
AVG(credit_gap) AS AVG_CREDIT_GAP  INTO dbo.previous_application_clean 
FROM dbo.previous_application group by SK_ID_CURR;

-- Cleaning BUREAU table 
select * from bureau;
update dbo.bureau SET DAYS_CREDIT_ENDDATE = COALESCE(DAYS_CREDIT_ENDDATE,0),
DAYS_ENDDATE_FACT = COALESCE(DAYS_ENDDATE_FACT,0),
AMT_CREDIT_SUM_DEBT = COALESCE(AMT_CREDIT_SUM_DEBT,0),
AMT_CREDIT_SUM_LIMIT = COALESCE(AMT_CREDIT_SUM_LIMIT,0);
update dbo.bureau SET AMT_CREDIT_MAX_OVERDUE = COALESCE(AMT_CREDIT_MAX_OVERDUE,0);
update dbo.bureau SET AMT_CREDIT_SUM_OVERDUE = COALESCE(AMT_CREDIT_SUM_OVERDUE,0);

UPDATE dbo.bureau SET CREDIT_CURRENCY = CASE  WHEN CREDIT_CURRENCY = 'currency 1' THEN 'US Dollar'
    WHEN CREDIT_CURRENCY = 'currency 2' THEN 'Euro'
    WHEN CREDIT_CURRENCY = 'currency 3' THEN 'Indian Rupee'
    WHEN CREDIT_CURRENCY = 'currency 4' THEN 'British pound'
    ELSE CREDIT_CURRENCY END;

SELECT * FROM bureau;
-- cleaning installments table 
select * from dbo.installments;  
update dbo.installments set 
DAYS_INSTALMENT = ABS(DAYS_INSTALMENT),
DAYS_ENTRY_PAYMENT = ABS(DAYS_ENTRY_PAYMENT);

-- creating an aggregated installments table
select SK_ID_CURR, COUNT(*) as total_installments, sum(case when AMT_PAYMENT < AMT_INSTALMENT THEN 1 ELSE 0 END ) AS LATE_CNT, 
AVG(DAYS_ENTRY_PAYMENT - DAYS_INSTALMENT) AS AVG_DELAY_DAYS, SUM(AMT_PAYMENT) AS total_paid, SUM(AMT_INSTALMENT) as total_due, 
SUM(case when AMT_PAYMENT < AMT_INSTALMENT then AMT_INSTALMENT - AMT_PAYMENT ELSE 0 END) AS Total_underpayment INTO installments_agg
from  installments group by SK_ID_CURR;


-- UPDATE credit_card_balance table
select * from dbo.credit_card_balance;
update credit_card_balance set 
MONTHS_BALANCE = ABS(MONTHS_BALANCE), 
AMT_DRAWINGS_ATM_CURRENT = coalesce(AMT_DRAWINGS_ATM_CURRENT,0),
AMT_DRAWINGS_OTHER_CURRENT = COALESCE(AMT_DRAWINGS_OTHER_CURRENT,0),
AMT_DRAWINGS_POS_CURRENT = COALESCE(AMT_DRAWINGS_POS_CURRENT,0),
AMT_PAYMENT_CURRENT = COALESCE(AMT_PAYMENT_CURRENT,0);

-- Create aggregated credit card behavior table
SELECT SK_ID_CURR, avg(case when AMT_CREDIT_LIMIT_ACTUAL  = 0 THEN 0
ELSE AMT_BALANCE * 1.0 / AMT_CREDIT_LIMIT_ACTUAL END) AS avg_cc_utilization,
MAX(AMT_BALANCE) as maxx_cc_balance, AVG(AMT_PAYMENT_TOTAL_CURRENT) as avg_cc_payment,
SUM(CASE WHEN AMT_BALANCE > AMT_CREDIT_LIMIT_ACTUAL THEN 1 ELSE 0 END) as overlimit_months,
 count(*) as total_months INTO credit_card_agg  
 from credit_card_balance group by SK_ID_CURR;












