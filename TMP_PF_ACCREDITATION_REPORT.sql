DROP TABLE TMP_PF_ACCREDITATION_REPORT;
CREATE TABLE TMP_PF_ACCREDITATION_REPORT AS
SELECT
B.YEAR
,B.ACCOUNT
,A.ACCR_CATEG
,A.QUESTION_LABEL
,CASE WHEN C.RESPONSE IS NULL THEN '0' ELSE C.RESPONSE END AS RESPONSE
,case when C.NATIONAL_AVG is null then 0 else C.NATIONAL_AVG end as NATIONAL_AVG


FROM (
 SELECT 
      QUESTION_LABEL
      ,ACCR_CATEG
      ,CASE WHEN ACCR_CATEG = 'Application Information' THEN 5
            WHEN ACCR_CATEG = 'Budget Information' THEN 2
            WHEN ACCR_CATEG ='Depository Information' THEN 4
            WHEN ACCR_CATEG ='Examination Information' THEN 6
            WHEN ACCR_CATEG ='General Agency Information' THEN 1
            WHEN ACCR_CATEG ='Report Turnaround Information' THEN 7
            WHEN ACCR_CATEG ='Sources of Funding' THEN 3
            WHEN ACCR_CATEG ='Specialty Exams Information' THEN 8
            WHEN ACCR_CATEG ='Turnover Information' THEN 10
            WHEN ACCR_CATEG ='Workforce Information' THEN 9
            WHEN ACCR_CATEG = 'Years of Service' THEN 11
            ELSE 12 END AS ORDER_CATEG
     FROM (
     SELECT DISTINCT  QUESTION_LABEL, ACCR_CATEG FROM 
           (SELECT 
           ACCOUNT
           ,YEAR
           ,QUESTION_LABEL
           ,to_char(response) AS RESPONSE
           ,NATIONAL_LEVEL
           ,ACCR_CATEG
           from tmp_pf_accr_number

        UNION ALL
        SELECT 
        ACCOUNT
        ,YEAR
        ,QUESTION_LABEL
        ,to_char(response) AS RESPONSE
        ,NATIONAL_LEVEL
        ,ACCR_CATEG
        FROM TMP_PF_ACCR_PERCENT
        
        UNION ALL
        SELECT 
        ACCOUNT
        ,YEAR
        ,QUESTION_LABEL
        ,to_char(response) AS RESPONSE
        ,NATIONAL_LEVEL
        ,ACCR_CATEG
        from tmp_pf_accr_currency
        
        UNION ALL
        SELECT 
        ACCOUNT
        ,YEAR
        ,QUESTION_LABEL
        ,to_char(response) AS RESPONSE
        ,NATIONAL_LEVEL
        ,ACCR_CATEG
        from tmp_pf_accr_picklist
        
        UNION ALL
        SELECT 
        ACCOUNT
        ,YEAR
        ,QUESTION_LABEL
        ,to_char(response) AS RESPONSE
        ,NATIONAL_LEVEL
        ,ACCR_CATEG
        FROM TMP_PF_EXAMINERNR
        
        UNION ALL
        SELECT 
        ACCOUNT
        ,YEAR
        ,QUESTION_LABEL
        ,to_char(response) AS RESPONSE
        ,NATIONAL_LEVEL
        ,ACCR_CATEG
        FROM TMP_PF_EXAMINERTURNOVER)
        )) a


cross join (
select distinct  account, year from 
(
SELECT 
ACCOUNT
,YEAR
,QUESTION_LABEL
,to_char(response) AS RESPONSE
,NATIONAL_LEVEL
,ACCR_CATEG
from tmp_pf_accr_number

UNION ALL
SELECT 
ACCOUNT
,YEAR
,QUESTION_LABEL
,to_char(response) AS RESPONSE
,NATIONAL_LEVEL
,ACCR_CATEG
FROM TMP_PF_ACCR_PERCENT

UNION ALL
SELECT 
ACCOUNT
,YEAR
,QUESTION_LABEL
,to_char(response) AS RESPONSE
,NATIONAL_LEVEL
,ACCR_CATEG
from tmp_pf_accr_currency

UNION ALL
SELECT 
ACCOUNT
,YEAR
,QUESTION_LABEL
,to_char(response) AS RESPONSE
,NATIONAL_LEVEL
,ACCR_CATEG
from tmp_pf_accr_picklist

UNION ALL
SELECT 
ACCOUNT
,YEAR
,QUESTION_LABEL
,to_char(response) AS RESPONSE
,NATIONAL_LEVEL
,ACCR_CATEG
FROM TMP_PF_EXAMINERNR

UNION ALL
SELECT 
ACCOUNT
,YEAR
,QUESTION_LABEL
,to_char(response) AS RESPONSE
,NATIONAL_LEVEL
,ACCR_CATEG
FROM TMP_PF_EXAMINERTURNOVER)
ORDER BY ACCOUNT, YEAR) B

-------------------
left join
---------------------
(SELECT 
YEAR
,ACCOUNT
,ACCR_CATEG
,QUESTION_LABEL
,RESPONSE
,NATIONAL_LEVEL AS NATIONAL_AVG
from 
(SELECT 
ACCOUNT
,YEAR
,QUESTION_LABEL
,to_char(response) AS RESPONSE
,NATIONAL_LEVEL
,ACCR_CATEG
from tmp_pf_accr_number

UNION ALL
SELECT 
ACCOUNT
,YEAR
,QUESTION_LABEL
,to_char(response) AS RESPONSE
,NATIONAL_LEVEL
,ACCR_CATEG
FROM TMP_PF_ACCR_PERCENT

UNION ALL
SELECT 
ACCOUNT
,YEAR
,QUESTION_LABEL
,to_char(response) AS RESPONSE
,NATIONAL_LEVEL
,ACCR_CATEG
from tmp_pf_accr_currency

UNION ALL
SELECT 
ACCOUNT
,YEAR
,QUESTION_LABEL
,to_char(response) AS RESPONSE
,NATIONAL_LEVEL
,ACCR_CATEG
from tmp_pf_accr_picklist

UNION ALL
SELECT 
ACCOUNT
,YEAR
,QUESTION_LABEL
,to_char(response) AS RESPONSE
,NATIONAL_LEVEL
,ACCR_CATEG
FROM TMP_PF_EXAMINERNR

UNION ALL
SELECT 
ACCOUNT
,YEAR
,QUESTION_LABEL
,TO_CHAR(ROUND(RESPONSE,1)) AS RESPONSE
,NATIONAL_LEVEL
,ACCR_CATEG
FROM TMP_PF_EXAMINERTURNOVER)) C
 ON (B.YEAR=C.YEAR AND B.ACCOUNT=C.ACCOUNT AND A.ACCR_CATEG=C.ACCR_CATEG
 AND A.QUESTION_LABEL=C.QUESTION_LABEL)
order by b.account, b.year, a.order_categ, a.question_label