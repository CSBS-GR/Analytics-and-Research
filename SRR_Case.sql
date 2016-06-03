SELECT
createddate
,CLOSEDDATE
,CLOSEDDATE - CREATEDDATE - 2 * (TO_CHAR(CLOSEDDATE, 'WW') - TO_CHAR(CREATEDDATE, 'WW'))
,
((CLOSEDDATE - CREATEDDATE) + ((((TO_CHAR(CREATEDDATE,'IW') - ((TO_CHAR(CLOSEDDATE,'YY') - TO_CHAR(CREATEDDATE,'YY'))* 52)) 
- TO_CHAR(TO_CHAR(CLOSEDDATE,'IW')))) * 2)) AS DURATION_IN_WEEKDAYS
FROM DM_ODS.ODS_PROFILE_CASE
WHERE CREATEDDATE > TO_DATE('2015-12-30', 'YYYY-MM-DD')
and createddate < TO_DATE('2016-1-1', 'YYYY-MM-DD')
;


SELECT 
CALDATE
,IS_WORKING_DAY
FROM DM_MDS.LK_DATE
WHERE CALDATE BETWEEN TO_DATE('31-DEC-15 18:23:05','DD-MON-RR HH24:MI:SS') AND TO_DATE('05-JAN-16 18:29:40','DD-MON-RR HH24:MI:SS')


SELECT
CREATEDDATE,
closeddate,
(SELECT 
sum(IS_WORKING_DAY)
FROM DM_MDS.LK_DATE
WHERE CALDATE BETWEEN CREATEDDATE AND CLOSEDDATE) as days_between
from DM_ODS.ODS_PROFILE_CASE


SELECT
EXTRACT(TIMEZONE_REGION FROM CREATEDDATE)
FROM  DM_ODS.ODS_PROFILE_CASE
where rownum < 10



SELECT
CREATED_DATE,
CLOSED_DATE,
MAJORDIF,
isclosed,
(SELECT 
sum(IS_WORKING_DAY)
FROM DM_MDS.LK_DATE
WHERE CALDATE BETWEEN CREATED_DATE AND CLOSED_DATE) as work_days_between,
caller_name,
AGENCY_NAME,
customer_rep,
type,
SUBJECT,
ORIGIN
FROM 
(
SELECT
ROUND((A.CLOSEDDATE - A.CREATEDDATE)*60*24,2) AS MAJORDIF,
a.isclosed,
B.FULLNAME as caller_name,
D.FULLNAME AS AGENCY_NAME,
C.NAME as customer_rep,
d.type,
A.CREATEDDATE,
A.CLOSEDDATE,
A.SUBJECT,
A.ORIGIN,
CAST(FROM_TZ(CAST(a.CREATEDDATE AS TIMESTAMP), 'UTC') 
AT TIME ZONE 'America/New_York' AS DATE) CREATED_DATE,
CAST(FROM_TZ(CAST(a.closeddate AS TIMESTAMP), 'UTC') 
at time zone 'America/New_York' AS Date) AS CLOSED_DATE
FROM DM_ODS.ODS_PROFILE_CASE A
JOIN DM_ODS.ODS_PROFILE_CONTACT B ON A.CONTACTID = B.CONTACTID
JOIN DM_ODS.ODS_PROFILE_USer C ON A.CREATEDBYID = c.userid
JOIN DM_ODS.ODS_PROFILE_ACCOUNT D ON A.ACCOUNTID = D.ACCOUNTID
where a.createddate > TO_DATE('31-DEC-15 23:59:59','DD-MON-RR HH24:MI:SS')
order by majordif desc)



select 
MMYYYY,
SUM(CASE WHEN MAJORDIF > 60*24 THEN 1 ELSE 0 end) AS MURK,
count(*)
FROM (
SELECT 
to_char(a.createddate,'yyyy-mm') as mmyyyy,
ROUND((A.CLOSEDDATE - A.CREATEDDATE)*60*24,2) AS MAJORDIF
FROM DM_ODS.ODS_PROFILE_CASE A
WHERE A.CREATEDDATE > TO_DATE('31-DEC-15 23:59:59','DD-MON-RR HH24:MI:SS')
) GROUP BY MMYYYY
order by mmyyyy

select to_number(to_char(createddate,'FF3')) from DM_ODS.ODS_PROFILE_CASE;

SELECT TO_CHAR(TO_DATE('22/05/2016','DD/MM/YYYY'),'WW') FROM DUAL;

