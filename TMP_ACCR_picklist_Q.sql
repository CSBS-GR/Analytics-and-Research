SELECT
ACCOUNT
,CAST(YEAR AS INTEGER) YEAR
--,QUESTION_LABEL AS Q_LAB_OLD
,REPLACE(REPLACE(QUESTION_LABEL, 'toSupervise','to Supervise'), 
  'Has your department entered into a fee sharing agreement with another state?',
  'Does your department currently have a fee sharing agreement with another state?')
 AS Question_label
,ANSWER_PICKLIST as response
,round(1.0*SUM(CASE WHEN 1=1 THEN 1 END) OVER (PARTITION BY YEAR, QUESTION_LABEL,
     ANSWER_PICKLIST)/SUM(CASE WHEN 1=1 THEN 1 END) OVER (PARTITION BY YEAR,
     QUESTION_LABEL),2) AS NATIONAL_LEVEL
, CASE WHEN OLSONID IN ('SFDC-5343-A','QMICDT_1117-A') THEN 'Budget Information'
    WHEN OLSONID IN ('RC_7992-A','RC_5788-A') THEN 'Specialty Exams Information'
    WHEN OLSONID IN ('RC_344-A') then 'Examination Information'
   else 'General Agency Information' end AS ACCR_CATEG
, OLSONID
, topic_title
from
DM_MDS.TMP_PF_ALLYR_SECTIONI a
WHERE 
     (LOWER(QUESTION_LABEL) LIKE LOWER('%Is your department independent, or part of a larger agency?%')
      OR 
      LOWER(QUESTION_LABEL) LIKE LOWER('%Is any part of your examination staff unionized?%')
      OR 
      LOWER(QUESTION_LABEL) LIKE LOWER('%Credit%Unions%--%Authority%Supervise%')
       OR 
      LOWER(QUESTION_LABEL) LIKE LOWER('%Credit%Card%Banks%--%Authority%Supervise%')
       OR 
      LOWER(QUESTION_LABEL) LIKE LOWER('%Does your department currently have a fee%sharing agreement with another state?%')
       OR
      LOWER(QUESTION_LABEL) LIKE LOWER('%Has your department entered into a fee sharing agreement with another state?%') 
       OR 
      LOWER(QUESTION_LABEL) LIKE LOWER('%Holding Companies%--%Authority%Supervise%')
         OR 
      LOWER(QUESTION_LABEL) LIKE LOWER('%Dedicated Fund%')
       OR 
      LOWER(QUESTION_LABEL) LIKE LOWER('%Were examination frequency requirements met?%')
      OR 
      LOWER(QUESTION_LABEL) LIKE LOWER('%Does your department participate in FFIEC examinations of TSPs?%')
      OR 
      LOWER(QUESTION_LABEL) LIKE LOWER('%Does your department charge an hourly bank examination fee?%')
      or olsonid = 'RC_7992-A'
   )
      AND YEAR IN (2012,2013,2014,2015)
ORDER BY ACCOUNT, YEAR, Q_ORDER 