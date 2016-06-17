drop table dm_mds.lk_srr_priority;
create table dm_mds.lk_srr_priority as 
SELECT DISTINCT
case when PRIORITY is null then 'N/A' else priority end as priority_Desc ,
CASE WHEN PRIORITY='Critical' THEN 1
     WHEN PRIORITY='High' THEN 2
     WHEN PRIORITY='Medium' THEN 3
     WHEN PRIORITY='Low' THEN 4
     WHEN PRIORITY IS NULL THEN 5 end as priority_id,
sysdate as update_Ts
FROM DM_ODS.ODS_SRR_ADMIN_CASE
ORDER BY PRIORITY_id;

DROP TABLE DM_MDS.IND_SRR_ISCLOSED;
create table dm_mds.ind_srr_isclosed as
SELECT 
distinct
isclosed as ind_closed_id
,case when isclosed=1 then 'Closed'
      ELSE 'Not Closed' END AS IND_CLOSED_DESC
      ,SYSDATE AS UPDATE_TS
from DM_ODS.ODS_SRR_ADMIN_CASE order by isclosed

CREATE SEQUENCE description_seq
  MINVALUE 1
  MAXVALUE 9999999999999
  START WITH 1
  INCREMENT BY 1
  CACHE 20;

DROP TABLE LK_SRR_DESCRIPTION;
create table lk_srr_description
(
  DESCRIPTION_ID          NUMBER DEFAULT DESCRIPTION_SEQ.NEXTVAL
  ,DESCRIPTION_SHORT VARCHAR2(2000 CHAR)
  ,DESCRIPTION_desc CLOB
  ,PRIMARY KEY (DESCRIPTION_ID)
 );



drop table tmp_tmp;
CREATE TABLE TMP_TMP
(
  DECRIPTION CLOB
  ,DESCRIPTION_SHORT VARCHAR2(2000 CHAR)
);
 insert into tmp_tmp
SELECT
description,
DBMS_LOB.SUBSTR(DESCRIPTION, 2000, 1) AS DESCRIPTION_SHORT
FROM DM_ODS.ODS_SRR_ADMIN_CASE;

INSERT INTO LK_SRR_DESCRIPTION (DESCRIPTION_ID, DESCRIPTION_SHORT, DESCRIPTION_DESC)
SELECT
DESCRIPTION_SEQ.NEXTVAL,
DESCRIPTION_SHORT,
DECRIPTION as description
from tmp_tmp
;
drop table tmp_tmp;
