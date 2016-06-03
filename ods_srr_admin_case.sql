DROP TABLE DM_ODS.ODS_SRR_ADMIN_CASE;
CREATE TABLE DM_ODS.ODS_SRR_ADMIN_CASE AS 
SELECT
CREATED_DATE
,CREATED_DAY
,CREATED_DAY_WORKDAY
,CLOSED_DATE
,CLOSED_DAY_WORKDAY
, day_dist
, ROUND((CREATED_DAY + 21/24 - CREATED_DATE)*24,2) AS DAY1
, ROUND((CLOSED_DATE - CLOSED_DAY - 9/24)*24,2) DAYN
, 8*WORK_DAYS_BETWEEN AS BTW
,CASE WHEN (DAY_DIST < 1) THEN ROUND((greatest(CLOSED_DATE, closed_day + 9/24) - GREATEST(CREATED_DATE, CREATED_DAY+9/24))*24,2)
      WHEN (DAY_DIST >= 1 AND WORK_DAYS_BETWEEN IS NOT NULL) THEN ROUND((CREATED_DAY +
        21/24 - least(GREATEST(CREATED_DATE, CREATED_DAY+9/24),CREATED_DAY+21/24))*24*created_day_workday +
        8*WORK_DAYS_BETWEEN + (greatest(CLOSED_DATE, closed_day + 9/24) - CLOSED_DAY - 9/24)*24*CLOSED_DAY_WORKDAY,2)
     ELSE NULL END AS TIMETOCLOSE                  
,WORK_DAYS_BETWEEN
,MAJORDIF
,CALLER_NAME
,Contact_Type
,AGENCY_NAME
,CUSTOMER_REP
,owner_name
,ROLE_NAME
,CALLER_BUS_ID
,CONTACT_TYPE_BUS_ID
,AGENCY_BUS_ID
,CUSTOMER_REP_BUS_ID
,OWNWER_NAME_BUS_ID
,role_name_bus_id
,TYPE
,priority
,SUBJECT
,CASENUMBER
,STATUS
,ISCLOSED
,MAIN_CATEGORY
,SUBCATEGORY
,REASON
,DESCRIPTION
,ORIGIN
from (
SELECT
TRUNC(CREATED_DATE,'DDD') AS CREATED_DAY,
TRUNC(CLOSED_DATE, 'ddd') AS CLOSED_DAY,
TRUNC(CLOSED_DATE, 'ddd')- TRUNC(CREATED_DATE,'DDD') as day_dist,
CREATED_DATE,
CLOSED_DATE,
MAJORDIF,
ISCLOSED,
(SELECT IS_WORKING_DAY FROM DM_MDS.LK_DATE WHERE CALDATE = TRUNC(CREATED_DATE,'DDD')) AS CREATED_DAY_WORKDAY,
(select is_working_day from DM_MDS.LK_DATE where caldate = TRUNC(CLOSED_DATE,'DDD')) AS CLOSED_DAY_WORKDAY,
(SELECT 
sum(IS_WORKING_DAY)
FROM DM_MDS.LK_DATE
WHERE CALDATE BETWEEN CREATED_DATE AND CLOSED_DATE)-1 as work_days_between,
CALLER_NAME,
CONTACT_TYPE,
priority, 
AGENCY_NAME,
CUSTOMER_REP,
owner_name,
ROLE_NAME,

CALLER_BUS_ID,
CONTACT_TYPE_BUS_ID,
AGENCY_BUS_ID,
CUSTOMER_REP_BUS_ID,
OWNWER_NAME_BUS_ID,
role_name_bus_id,
type,
SUBJECT,
CASENUMBER,
STATUS,
MAIN_CATEGORY,
SUBCATEGORY,
REASON,
DESCRIPTION,
ORIGIN
FROM 
(
SELECT
ROUND((A.CLOSEDDATE - A.CREATEDDATE)*24,2) AS MAJORDIF,
A.ISCLOSED,
A.CONTACTID as caller_bus_id,
B.FULLNAME AS CALLER_NAME,
b.nmls_individual_id__c, as contact_type_bus_id,
B.NMLS_CONTACT_TYPE__C AS CONTACT_TYPE,
a.accountid as agency_bus_id,
D.FULLNAME AS AGENCY_NAME,
A.CREATEDBYID as customer_rep_bus_id,
C.NAME AS CUSTOMER_REP,
e.USERID as ownwer_name_bus_id,
E.NAME AS OWNER_NAME,
f.id as role_name_bus_id,
f.name as role_name,
D.TYPE,
A.PRIORITY,
A.CREATEDDATE,
A.CLOSEDDATE,
A.SUBJECT,
A.CASENUMBER,
A.STATUS,
A.CATEGORY__C AS main_CATEGORY,
A.SUBCATEGORY__C AS SUBCATEGORY,
A.REASON__C AS REASON,
a.description,
A.ORIGIN,
CAST(FROM_TZ(CAST(a.CREATEDDATE AS TIMESTAMP), 'UTC') 
AT TIME ZONE 'America/New_York' AS DATE) CREATED_DATE,
CAST(FROM_TZ(CAST(a.closeddate AS TIMESTAMP), 'UTC') 
at time zone 'America/New_York' AS Date) AS CLOSED_DATE
FROM DM_ODS.ODS_PROFILE_CASE A
LEFT JOIN DM_ODS.ODS_PROFILE_CONTACT B ON A.CONTACTID = B.CONTACTID
LEFT JOIN DM_ODS.ODS_PROFILE_USER C ON A.CREATEDBYID = C.USERID
LEFT JOIN DM_ODS.ODS_PROFILE_ACCOUNT D ON A.ACCOUNTID = D.ACCOUNTID
LEFT JOIN DM_ODS.ODS_PROFILE_USER E ON A.OWNERID = E.USERID
left JOIN DM_ODS.ODS_PROFILE_USERROLE F ON E.USERROLEID=F.ID
WHERE 
RECORDTYPEID = '012i00000015r9TAAQ'))
order by isclosed desc, timetoclose desc