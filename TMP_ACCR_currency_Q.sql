DROP TABLE DM_MDS.TMP_PF_ACCR_CURRENCY;
CREATE TABLE DM_MDS.TMP_PF_ACCR_CURRENCY AS 
SELECT 
ACCOUNT
,YEAR
,QUESTION_LABEL
,RESPONSE
,round(avg(response) over (partition by year, question_label),0) as NATIONAL_LEVEL
,CASE WHEN OLSONID IN ('QMICDT_5-A','QMICDT_41-A','QMICDT_44-A','QMICDT_973-A')
   then 'Depository Information' else 'Budget Information' end as ACCR_CATEG
,OLSONID
,TOPIC_TITLE
from (
SELECT
ACCOUNT
,CAST(YEAR AS INTEGER) YEAR
,CASE 
    WHEN LOWER(QUESTION_LABEL) LIKE LOWER('%Total Budget Approved (Actual Dollar Amount) -- Current FY%')
     THEN 'Total Budget Approved' 
    WHEN LOWER(QUESTION_LABEL) LIKE LOWER('%actual expenditures%') THEN 'Actual Expenditures' 
    WHEN  LOWER(QUESTION_LABEL) LIKE LOWER('%Amount Allocated to Commercial Bank Supervision%current%')
       THEN 'Amount Allocated to Commercial Bank Supervision'
    WHEN (LOWER(QUESTION_LABEL) LIKE LOWER('%No related label%') AND lower(report_header_text) like LOWER('%department%net contribution%'))
       THEN 'Amount Returned to General Fund'
    WHEN LOWER(QUESTION_LABEL) LIKE LOWER('%Total Actual%Budgeted Training Expense%') THEN 'Budgeted Training Expense'
    WHEN LOWER(QUESTION_LABEL) LIKE LOWER('%Savings Banks/Savings%Loans -- Total Assets%if applicable%') THEN 'Total Assets (if supervised): Savings Banks'
    WHEN OLSONID = 'QMICDT_5-A' THEN 'Commercial Banks: Total Assets'
    WHEN OLSONID = 'QMICDT_41-A' THEN 'Industrial Loan Corporations: Total Assets'
    WHEN OLSONID = 'QMICDT_44-A' THEN 'Non-depository Trust Companies: Total Assets'
    when olsonid = 'QMICDT_973-A' then 'Savings Banks: Total Assets'
    ELSE QUESTION_LABEL
    END
     AS QUESTION_LABEL
,CASE WHEN year<=2013 and olsonid in ('QMICDT_5-A','QMICDT_41-A','QMICDT_44-A','QMICDT_973-A') THEN round(ANSWER_CURRENCY*1000,0)
      else round(ANSWER_CURRENCY,0) end AS RESPONSE
,'Budget Information' AS ACCR_CATEG
, OLSONID
, TOPIC_TITLE
,sum(answer_currency) over (partition by account, year) AS ZEROFILTER
FROM 
DM_MDS.TMP_PF_ALLYR_SECTIONI
WHERE 
     (LOWER(QUESTION_LABEL) LIKE LOWER('%Total Budget Approved (Actual Dollar Amount) -- Current FY%')
      OR 
      LOWER(QUESTION_LABEL) LIKE LOWER('%actual expenditures%')
      OR 
      LOWER(QUESTION_LABEL) LIKE LOWER('%Amount Allocated to Commercial Bank Supervision%current%')
      OR 
      LOWER(QUESTION_LABEL) LIKE LOWER('%What is your department%net contribution to your State%')
      OR LOWER(REPORT_HEADER_TEXT) LIKE LOWER('%department%net contribution%')
      OR LOWER(QUESTION_LABEL) LIKE LOWER('%Hourly Fee')   
      OR LOWER(QUESTION_LABEL) LIKE LOWER('%total actual%Budgeted Training Expense%')
      OR olsonid = 'QMICDT_5-A'
      OR LOWER(QUESTION_LABEL) LIKE LOWER('%Savings Banks/Savings%Loans -- Total Assets%if applicable%')
      OR LOWER(QUESTION_LABEL) LIKE LOWER('%Non-depository Trust Companies%Total Assets%')
      OR LOWER(QUESTION_LABEL) LIKE LOWER('%Industrial Loan Corporations%Total Assets%')
   )
    
      AND YEAR IN (2012,2013,2014,2015)
ORDER BY ACCOUNT, accr_categ, QUESTION_LABEL, YEAR desc ) 
where zerofilter <>0