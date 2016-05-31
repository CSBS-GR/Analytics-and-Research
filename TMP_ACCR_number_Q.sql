drop TABLE DM_MDS.TMP_PF_ACCR_number;
create table dm_mds.tmp_pf_accr_number as
SELECT 
 ACCOUNT
,YEAR
,QUESTION_LABEL
,RESPONSE
,round(AVG(RESPONSE) OVER (PARTITION BY YEAR, QUESTION_LABEL),2) AS NATIONAL_LEVEL
,ACCR_CATEG
,OLSONID
,TOPIC_TITLE
FROM
(SELECT
ACCOUNT
,CAST(YEAR AS INTEGER) YEAR
,
CASE WHEN OLSONID IN ('QMICDT_972-A')  THEN 'Savings Banks/Savings and Loans: Number Supervised'
     WHEN OLSONID IN ('QMICDT_4-A')  THEN 'Commercial Banks: Number Supervised'
     WHEN OLSONID IN ('QMICDT_43-A')  THEN 'Non-depository Trust Companies: Number Supervised'
     WHEN OLSONID IN ('QMICDT_13-A')  THEN 'Credit Unions: Number Superviseded'
     WHEN OLSONID IN ('QMICDT_31-A')  THEN 'Credit Card Banks: Number Superviseded'
     
     WHEN OLSONID ='QMICDT_7926-A' THEN 'Number of 4 and 5 rated banks (Start of Year)'
     WHEN OLSONID ='QMICDT_7928-A' THEN 'Number of 4 and 5 rated banks (End of Year)'
     WHEN OLSONID ='QMICDT_7930-A' THEN 'Number of failed institutions'
     
     WHEN OLSONID ='QMICDT_7940-A' THEN 'Insured Depositories Enforcement Actions (Start of the Year)'
     WHEN OLSONID ='QMICDT_7931-A' THEN 'Insured Depositories Enforcement Actions Joint with Federal Agency (Start of the Year)'
     WHEN OLSONID ='QMICDT_7949-A' THEN 'Holding Company Enforcement Actions (Start of the Year)'
     WHEN OLSONID ='QMICDT_7950-A' THEN 'Holding Company Enforcement Actions Joint with Federal Agency (Start of the Year)'
     
     WHEN OLSONID ='QMICDT_7943-A' THEN 'Insured Depositories Enforcement Actions (End of the Year)'
     WHEN OLSONID ='QMICDT_7934-A' THEN 'Insured Depositories Enforcement Actions Joint with Federal Agency (End of the Year)'
     WHEN OLSONID ='QMICDT_7955-A' THEN 'Holding Company Enforcement Actions (End of the Year)'
     WHEN OLSONID ='QMICDT_7956-A' THEN 'Holding Company Enforcement Actions Joint with Federal Agency (End of the Year)'
     WHEN OLSONID='QMICDT_7997-A' THEN 'Turnaround time (days): Independent Examinations'
     WHEN OLSONID='QMICDT_7998-A' THEN 'Turnaround time (days): Joint Examinations with FDIC Lead'
     WHEN OLSONID='QMICDT_7999-A' THEN 'Turnaround time (days): Joint Examinations with Federal Reserve Lead'
     WHEN OLSONID='QMICDT_8000-A' THEN 'Turnaround time (days): Joint Examinations with State Lead'
     WHEN OLSONID='QMICDT_350-A' THEN 'Bank Exams: Number of Joint Examinations with State Lead'
     WHEN OLSONID='QMICDT_353-A' THEN 'Bank Exams: Number of Joint Examinations with Federal Lead'
     WHEN OLSONID='QMICDT_356-A' THEN 'Bank Exams: Number of Concurrent Examinations'
     WHEN OLSONID='QMICDT_359-A' THEN 'Bank Exams: Number of State Only Independent Examinations'
     WHEN OLSONID='QMICDT_1155-A'  THEN 'BSA Exams: Number of Independent Examinations'
     WHEN OLSONID='QMICDT_1156-A'  THEN 'BSA Exams: Number of Joint Examinations with the Federal Reserve'
     WHEN OLSONID='QMICDT_1157-A'  THEN 'BSA Exams: Number of Concurrent Examinations with the Federal Reserve'
     WHEN OLSONID='QMICDT_1158-A'  THEN 'BSA Exams: Total Number of Examinations'
     WHEN OLSONID='QMICDT_371-A'  THEN 'Bank Holding Companies: Number of Independent Examinations'
     WHEN OLSONID='QMICDT_369-A'  THEN 'Bank Holding Companies: Number of Joint Examinations with the Federal Reserve'
     WHEN OLSONID='QMICDT_370-A'  THEN 'Bank Holding Companies: Number of Concurrent Examinations with the Federal Reserve'
     WHEN OLSONID='QMICDT_372-A'  THEN 'Bank Holding Companies: Total Number of Examinations'
     WHEN OLSONID='QMICDT_1163-A'  THEN 'Non-depository Trust: Total Number of Examinations'
     WHEN OLSONID='QMICDT_372-A'  THEN 'Non-depository Trust: Report Average Turnaround in days'
     WHEN OLSONID='SFDC-3476-A' THEN 'Compliance Exams: Total Number of Examinations'
     when olsonID='QMICDT_7989-A' then 'Examiner Vacancies' 
    else question_label  
    END
     AS
     QUESTION_LABEL
, ANSWER_NUMBER AS RESPONSE
, CASE WHEN OLSONID IN ('SFDC-82679-A','SFDC-82684-A','SFDC-82689-A',
      'SFDC-82694-A','SFDC-82699-A','SFDC-82704-A','SFDC-82709-A','SFDC-82681-A',
      'SFDC-82686-A','SFDC-82691-A','SFDC-82696-A','SFDC-82701-A','SFDC-82706-A',
      'SFDC-82711-A')    THEN  'Workforce Information' 
      when (olsonid in ('QMICDT_371-A','QMICDT_369-A','QMICDT_370-A','QMICDT_372-A') -- examinations BHC
      OR  OLSONID IN ('QMICDT_1155-A','QMICDT_1156-A','QMICDT_1157-A','QMICDT_1158-A') -- bsa exams
      OR  OLSONID IN ('QMICDT_5768-A','QMICDT_5771-A','QMICDT_5774-A','QMICDT_5780-A')  --IT exams
      OR  OLSONID IN ('QMICDT_1163-A','QMICDT_1164-A')    -- nondepository trust exams    
      OR  OLSONID IN ('SFDC-3476-A')) THEN 'Specialty Exams Information'
      WHEN OLSONID IN ('QMICDT_7997-A','QMICDT_7998-A','QMICDT_7999-A','QMICDT_8000-A')
          THEN 'Report Turnaround Information'
     when (OLSONID IN ('QMICDT_7926-A','QMICDT_7928-A','QMICDT_7930-A')  --4 and 5 camel + nr of banks failures
      OR  OLSONID IN ('QMICDT_7940-A','QMICDT_7931-A', 'QMICDT_7934-A','QMICDT_7943-A')  -- enforcement Bank
      OR  OLSONID IN ('QMICDT_7949-A','QMICDT_7950-A','QMICDT_7955-A','QMICDT_7956-A')  -- enforcement HC
      OR  OLSONID IN ('QMICDT_359-A','QMICDT_362-A','QMICDT_350-A','QMICDT_353-A','QMICDT_356-A'))
            THEN 'Examination Information'
      when olsonId in ('QMICDT_4-A','QMICDT_43-A','QMICDT_972-A') then 'Depository Information'
      when (LOWER(QUESTION_LABEL) LIKE LOWER('%de novo%approved%')
      OR  LOWER(QUESTION_LABEL) LIKE LOWER('%Conversions from National Bank to State Depository Institutions%approved%')
      OR  LOWER(QUESTION_LABEL) LIKE LOWER('Conversions from Federal Thrift to State Depository Institutions%approved%')
      OR  LOWER(QUESTION_LABEL) LIKE LOWER('Conversions from Federal Thrift to State Thrift%approved%')
      OR  LOWER(QUESTION_LABEL) LIKE LOWER('State Depository Institution Conversions to National Bank Charters%approved%')
      OR  LOWER(QUESTION_LABEL) LIKE LOWER('STATE DEPOSITORY INSTITUTION CONVERSIONS TO FEDERAL THRIFT CHARTERS%approved%'))
         THEN 'Application Information'
         else 'General Agency Information'
      end AS ACCR_CATEG
, OLSONID
, TOPIC_TITLE
,sum(answer_number) over (partition by account, year) AS ZEROFILTER
FROM 
DM_MDS.TMP_PF_ALLYR_SECTIONI
WHERE 
   ( LOWER(QUESTION_LABEL) LIKE LOWER('%Commercial Banks -- Number%Supervised%')
      OR LOWER(QUESTION_LABEL) LIKE LOWER('%Savings Banks/Savings%Loans -- Number%Supervised%')
      OR LOWER(QUESTION_LABEL) LIKE LOWER('%Non-depository Trust Companies% -- Number%Supervised%%')
      OR LOWER(QUESTION_LABEL) LIKE LOWER('%Industrial Loan Corporations% -- Number%Supervised%%')
      OR LOWER(QUESTION_LABEL) LIKE LOWER('%credit union%number supervised%')
      OR LOWER(QUESTION_LABEL) LIKE LOWER('%credit card banks%number supervised%')
      OR LOWER(QUESTION_LABEL) LIKE LOWER('%de novo%approved%')
      OR  LOWER(QUESTION_LABEL) LIKE LOWER('%Conversions from National Bank to State Depository Institutions%approved%')
      OR  LOWER(QUESTION_LABEL) LIKE LOWER('Conversions from Federal Thrift to State Depository Institutions%approved%')
      OR  LOWER(QUESTION_LABEL) LIKE LOWER('Conversions from Federal Thrift to State Thrift%approved%')
      OR  LOWER(QUESTION_LABEL) LIKE LOWER('State Depository Institution Conversions to National Bank Charters%approved%')
      OR  LOWER(QUESTION_LABEL) LIKE LOWER('STATE DEPOSITORY INSTITUTION CONVERSIONS TO FEDERAL THRIFT CHARTERS%approved%')
      --examination info
      OR  OLSONID IN ('QMICDT_7926-A','QMICDT_7928-A','QMICDT_7930-A')  --4 and 5 camel + nr of banks failures
      OR  OLSONID IN ('QMICDT_7940-A','QMICDT_7931-A', 'QMICDT_7934-A','QMICDT_7943-A')  -- enforcement Bank
      OR  OLSONID IN ('QMICDT_7949-A','QMICDT_7950-A','QMICDT_7955-A','QMICDT_7956-A')  -- enforcement HC
      OR  OLSONID IN ('QMICDT_359-A','QMICDT_362-A','QMICDT_350-A','QMICDT_353-A','QMICDT_356-A')  --nr exams
      --turnaround time
      OR  OLSONID IN ('QMICDT_7997-A','QMICDT_7998-A','QMICDT_7999-A','QMICDT_8000-A') -- turnaround time
      --Specialty
      OR  OLSONID IN ('QMICDT_371-A','QMICDT_369-A','QMICDT_370-A','QMICDT_372-A') -- examinations BHC
      OR  OLSONID IN ('QMICDT_1155-A','QMICDT_1156-A','QMICDT_1157-A','QMICDT_1158-A') -- bsa exams
      OR  OLSONID IN ('QMICDT_5768-A','QMICDT_5771-A','QMICDT_5774-A','QMICDT_5780-A')  --IT exams
      OR  OLSONID IN ('QMICDT_1163-A','QMICDT_1164-A')    -- nondepository trust exams    
      OR  OLSONID IN ('SFDC-3476-A')  --compliance exams
      --Workforce info
      OR  OLSONID IN ('SFDC-82679-A','SFDC-82684-A','SFDC-82689-A','SFDC-82694-A','SFDC-82699-A','SFDC-82704-A','SFDC-82709-A')  --examiner fte (2015)
      OR  OLSONID IN ('SFDC-82681-A','SFDC-82686-A','SFDC-82691-A','SFDC-82696-A','SFDC-82701-A','SFDC-82706-A','SFDC-82711-A')  --examiner xtrained (2015)

   )  
   AND YEAR IN (2012,2013,2014,2015)
ORDER BY ACCOUNT, YEAR, OLSONID)
WHERE ZEROFILTER <> 0
order by  account, year desc, accr_categ, olsonid