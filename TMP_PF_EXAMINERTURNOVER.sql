DROP TABLE DM_MDS.TMP_PF_EXAMINERTURNOVER;
CREATE TABLE DM_MDS.TMP_PF_EXAMINERTURNOVER AS 
WITH A AS (SELECT 
cast(YEAR as integer) Year
,ACCOUNT
,CASE WHEN LOWER(QUESTION_LABEL) LIKE LOWER('%examiner turnover%') THEN 'Examiner Turnover %'
       WHEN QUESTION_LABEL LIKE '%Total Number of Examiners -- Total as of 12/31/201%' OR
          QUESTION_LABEL LIKE '%Total Number of Examiners (as of 2015-12-31)'
           THEN 'Total Number of Examiners' 
        when lower(question_label) like 'other%' then 'Reason: Other'   
 ELSE 'Reason: '||QUESTION_LABEL END AS QUESTION_LABEL
, CASE WHEN ANSWERTYPE = 'Percent' THEN (ANSWER_PERCENT*1.0) ELSE ANSWER_NUMBER END AS RESPONSE
, OLSONID
,TOPIC_TITLE
,'Turnover Information' as accr_categ
, sum(CASE WHEN ANSWERTYPE = 'Percent' THEN ANSWER_PERCENT/100 ELSE ANSWER_NUMBER END) over (partition by account, year) as zerofilter
FROM 
dm_mds.tmp_pf_allyr_sectioni
WHERE 
 (LOWER(QUESTION_LABEL) LIKE LOWER('%examiner turnover%')
 OR QUESTION_LABEL IN ('Retirement'
,'Resignation with no reason given'
,'Resignation to work with Federal Agency'
,'Resignation to work in a financial institution (bank, holding company, trust company, etc.)'
,'Resignation to work in private sector other than a financial institution'
,'Transfer to work with other State Agency'
,'Termination'
,'Death'
,'Promotion to Office'
,'Other (Please explain)','Other' )
OR (LOWER(QUESTION_LABEL) LIKE LOWER('%Total Number of Examiners%')
     AND QUESTION_LABEL NOT LIKE '%Cross-trained%'
     AND QUESTION_LABEL NOT LIKE '%Yrs%')
)
AND TOPIC_TITLE LIKE '%Characteristics of the State Examiner Workforce'
AND YEAR > 2011
and answertype in ('Percent','Number')
 ORDER BY ACCOUNT ASC, YEAR DESC)
SELECT 
ACCOUNT
,YEAR
,QUESTION_LABEL
,RESPONSE
,ROUND(AVG(RESPONSE) OVER (PARTITION BY YEAR, QUESTION_LABEL),2) AS NATIONAL_LEVEL
, accr_categ
,OLSONID
,topic_title
FROM A 
WHERE zerofilter is not null and ZEROFILTER > 0 ;

 
