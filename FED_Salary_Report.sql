SELECT YEAR /*csv*/
--, CASE A.AGENCY
--    WHEN 'Federal Deposit Insurance Corporation' THEN 'FDIC'
--    WHEN 'Department Of Treasury' THEN 'OCC'
--    WHEN 'National Credit Union Administration' THEN 'NCUA'
--  END AGENCY
, B.DISTRICT_ID
, B.STATE
, C.TITLE STATE_ROLE
, COUNT(A.NAME) N_FED
, ROUND(MIN(A.SALARY),0) MIN_BASE_FED
, ROUND(MAX(A.SALARY),0) MAX_BASE_FED
, ROUND(MIN(A.SALARY + NVL(A.AWARD,0)),0) MIN_ACTUAL_FED
, ROUND(MAX(A.SALARY + NVL(A.AWARD,0)),0) MAX_ACTUAL_FED
, ROUND(AVG(A.SALARY + NVL(A.AWARD,0)),0) AVG_ACTUAL_FED
, ROUND(AVG(A.AWARD),0) AVG_AWARD_FED
FROM (
SELECT YEAR ,
NAME 
, STATE
, JOB
, PLAN_GRADE
, SALARY/1000 SALARY
, AWARD/1000 AWARD
FROM ODS_SAL_REPORT) A
JOIN DM_MDS.LK_AGENCY B ON UPPER(B.STATE) = UPPER(A.STATE)
JOIN DM_MDS.LK_SALARY_TITLE C ON C.PLAN_GRADE = A.PLAN_GRADE
WHERE A.JOB IN ('Financial Institution Examining'
  , 'Legal Instruments Examining'
  , 'Administrative Officer'
  , 'Financial Analysis'
  , 'Financial Analysis'
  , 'Credit Union Examining'
  , 'Management and Program Analysis'
  , 'Financial Analysis'
  , 'Financial Institution Examining'
  , 'Management and Program Analysis')
GROUP BY A.YEAR, C.TITLE, B.STATE, B.DISTRICT_ID
ORDER BY A.YEAR, B.STATE;
