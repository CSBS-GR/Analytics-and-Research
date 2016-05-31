DROP TABLE DM_MDS.TMP_PF_EXAMINERNR;
CREATE TABLE DM_MDS.TMP_PF_EXAMINERNR AS
SELECT 
CASE WHEN QUESTION_LABEL = 'Number of Examiners: Experience <2 Yrs' THEN 1
     WHEN QUESTION_LABEL = 'Number of Examiners: Experience 2 to 5 Yrs' THEN 2
     WHEN QUESTION_LABEL = 'Number of Examiners: Experience >5 to 15 Yrs' THEN 3
     WHEN QUESTION_LABEL = 'Number of Examiners: Experience >15 to 25 Yrs' THEN 4
     WHEN QUESTION_LABEL = 'Number of Examiners: Experience > 25 Yrs' THEN 5
     WHEN QUESTION_LABEL = 'Total Number of Examiners' THEN 6 end AS Q_ORDER,
ACCOUNT,
YEAR,
QUESTION_LABEL,
TOTALNR AS RESPONSE
,round(avg(totalnr) OVER (PARTITION BY YEAR, QUESTION_LABEL),2) AS NATIONAL_LEVEL
,ACCR_CATEG
,OLSONID
,topic_title
FROM (
SELECT
ACCOUNT,
YEAR,
QUESTION_LABEL,
Q_ORDER,
TOTALNR,
TOPIC_TITLE,
olsonid,
accr_categ,
sum(Totalnr) over (partition by account, year) AS ZEROFILTER
from (
SELECT
ACCOUNT,
YEAR,
QUESTION_LABEL,
MAX(Q_ORDER) AS Q_ORDER,
SUM(ANSWER_NUMBER) AS TOTALNR,
ACCR_CATEG,
max(olsonid) as olsonid,
topic_title
from (
SELECT
Q_ORDER,
ACCOUNT,
cast(YEAR as integer) year,
CASE WHEN (QUESTION_LABEL like '%Total Number of Examiners -- < 2 Yrs') THEN 'Number of Examiners: Experience <2 Yrs'
     WHEN (QUESTION_LABEL LIKE '%Total Number of Examiners -- 2 to 5 Yrs') THEN 'Number of Examiners: Experience 2 to 5 Yrs'
     WHEN ((QUESTION_LABEL LIKE '%Total Number of Examiners -- 5 to 10 Yrs') OR 
                    (QUESTION_LABEL LIKE '%Total Number of Examiners -- 10 to 15 Yrs')) 
                  THEN 'Number of Examiners: Experience >5 to 15 Yrs'
     WHEN ((QUESTION_LABEL LIKE '%Total Number of Examiners -- 15 to 20 Yrs') OR 
                    (QUESTION_LABEL LIKE '%Total Number of Examiners -- 20 to 25 Yrs'))
     THEN 'Number of Examiners: Experience >15 to 25 Yrs'
     WHEN QUESTION_LABEL LIKE '%Total Number of Examiners -- > 25 Yrs' THEN 'Number of Examiners: Experience > 25 Yrs'
     WHEN QUESTION_LABEL LIKE '%Total Number of Examiners -- Total as of 12/31/201%' OR
          QUESTION_LABEL LIKE '%Total Number of Examiners (as of 2015-12-31)' 
          THEN 'Total Number of Examiners'
     ELSE QUESTION_LABEL   END AS QUESTION_LABEL,
ANSWER_NUMBER
,OLSONID
, 'Years of Service' AS ACCR_CATEG
, topic_title
FROM 
DM_MDS.TMP_PF_ALLYR_SECTIONI
WHERE 
     (LOWER(QUESTION_LABEL) LIKE LOWER('%Number of Examiners%'))
     AND ANSWER_NUMBER IS NOT NULL
     AND QUESTION_LABEL NOT LIKE '%Cross-trained%'
     AND YEAR in (2012,2013,2014,2015)
ORDER BY ACCOUNT, YEAR, Q_ORDER 
)
GROUP BY ACCOUNT,YEAR,QUESTION_LABEL, ACCR_CATEG, TOPIC_TITLE
ORDER BY  ACCOUNT, YEAR, Q_ORDER asc ))
WHERE ZEROFILTER IS NOT NULL AND ZEROFILTER <>0
order by account, year desc, q_order


