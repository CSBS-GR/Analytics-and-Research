--- For Querying Question and determine OLSONID ----
SELECT
YEAR
, ACCOUNT
, OLSONID
, QUESTION_LABEL
, ANSWER_CURRENCY
FROM TMP_PF_ALLYR_SECTIONI
WHERE
QUESTION_LABEL LIKE '%Credit%' AND
QUESTION_LABEL LIKE '%--%' AND
ANSWER_CURRENCY IS NOT NULL AND
CERTIFIED = '1';
--- Some questions have multiple OLSONID -----------
SELECT DISTINCT OLSONID FROM TMP_PF_ALLYR_SECTIONI
WHERE
QUESTION_LABEL LIKE '%Total Number of Examiner%' AND
QUESTION_LABEL LIKE '%as of%' AND
ANSWER_NUMBER IS NOT NULL AND
CERTIFIED = '1';
---- Press F5 and Get the CSV  ---------------------
SELECT /*csv*/
YEAR
, STATE
, (N_EXAMINER1 || N_EXAMINER2) AS N_PF_EXAMINER
, (N_COMMERCIAL+N_SAVINGS+N_BANKER+N_INDUSTRIAL+N_CREDIT) AS N_PF_BANK
, (AS_COMMERCIAL+AS_SAVINGS+AS_BANKER+AS_INDUSTRIAL+AS_CREDIT) AS PF_TOTAL_ASSET
FROM (
SELECT
A.YEAR
, B.STATE
, A.ACCOUNT
, A.OLSONID
, (A.ANSWER_NUMBER || A.ANSWER_CURRENCY) as ANSWER
FROM
TMP_PF_ALLYR_SECTIONI A JOIN
lk_pf_validagency B on A.ACCOUNT = B.ACCOUNT
WHERE
(A.ANSWER_NUMBER || A.ANSWER_CURRENCY) IS NOT NULL AND
CERTIFIED = '1'
)
PIVOT
(
   MAX(ANSWER)
   FOR OLSONID IN (
     'QMICDT_239-A' N_EXAMINER1
   , 'SFDC-82660-A' N_EXAMINER2
   , 'QMICDT_4-A' N_COMMERCIAL
   , 'QMICDT_972-A' N_SAVINGS
   , 'QMICDT_28-A' N_BANKER
   , 'QMICDT_40-A' N_INDUSTRIAL
   , 'QMICDT_31-A' N_CREDIT
   , 'QMICDT_5-A' AS_COMMERCIAL
   , 'QMICDT_973-A' AS_SAVINGS
   , 'QMICDT_29-A' AS_BANKER
   , 'QMICDT_41-A' AS_INDUSTRIAL
   , 'QMICDT_32-A' AS_CREDIT
   )
)
ORDER BY ACCOUNT, YEAR desc;