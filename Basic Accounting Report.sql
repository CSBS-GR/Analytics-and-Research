with a as (SELECT 
b.AGENCY_NAME
,A.YEAR
,A.QUESTION_LABEL as question_label_old
,A.OLSONID
,CASE WHEN OLSONID ='QMICDT_7973-A' THEN 'Department actual expenditures for the previous Fiscal Year budget?'
      WHEN OLSONID ='QMICDT_7972-A' THEN 'Department actual income for the previous Fiscal Year budget?'
      WHEN OLSONID ='QMICDT_7974-A' THEN 'Amount Allocated to Commercial Bank Supervision'
      WHEN OLSONID ='QMICDT_7971-A' THEN 'Total Budget Approved'
      WHEN OLSONID ='QMICDT_7976-A' THEN 'Department/Division Total Non-depository Budget'
      else question_label
      END AS QUESTION_LABEL
, TO_CHAR(A.ANSWER_CURRENCY, '$999,999,999,999,990.99') AS AMOUNT
,A.REPORT_HEADER_TEXT
FROM TMP_PF_ALLYR_SECTIONI A
JOIN LK_PF_VALIDAGENCY B ON A.ACCOUNT=B.ACCOUNT
WHERE (TOPIC_TITLE LIKE '3.%' OR (TOPIC_TITLE LIKE 'State Banking Department Budgets' AND YEAR=2014))
AND CERTIFIED = 1
AND OLSONID IN ('QMICDT_7973-A', 'QMICDT_7972-A','QMICDT_7974-A','QMICDT_7971-A','QMICDT_7976-A')
ORDER BY  A.ACCOUNT, OLSONID, YEAR)

SELECT /*csv*/
d.AGENCY_NAME
,d.QUESTION_LABEL
,d.AMOUNT_2015
,c.amount_2014
from (
SELECT 
 AGENCY_NAME
 ,QUESTION_LABEL
 ,AMOUNT AS AMOUNT_2015
 FROM A WHERE YEAR=2015) d
JOIN  
(
SELECT 
 AGENCY_NAME 
 ,QUESTION_LABEL
 ,AMOUNT AS AMOUNT_2014
 FROM A WHERE YEAR=2014) C
on d.agency_name=c.agency_name and d.question_label=c.question_label ;

