--Note that this goes to 201603, need to update otherwise

drop materialized view mv_lk_sdi_failebanks;
CREATE MATERIALIZED VIEW MV_LK_SDI_FAILEBANKS AS 
SELECT 
  E.MONTH_ID AS YEARMONTHCLOSING
  ,d.cert_bus_id
  ,D.REPDTE
  ,D.ASSET
  ,case when D.ASSET_GROUP_NARROW is null then 'Up to $50 Million' else d.asset_Group_narrow end as asset_Group_narrow 
  ,case when D.ASSET_GROUP_BROAD is null then 'Small (<$100M)' else d.ASSET_GROUP_BROAD end as asset_group_broad
  ,D.CLOSING_DATE
  ,D.STATE_DESC
  ,case when d.yearmonthclosing is null then 0 else d.count_variable end as count_variable
FROM LK_MONTH E
left join (
SELECT
    a.CERT_BUS_ID
  , REPDTE
  , ASSET 
  , CASE WHEN ASSET < 50000 THEN 'Up to $50 Million'
         WHEN ASSET>=50000 AND ASSET < 100000 THEN '$50 Million to $100 Million'
         WHEN ASSET>=100000 AND ASSET < 300000 THEN '$100 Million to $300 Million'
         WHEN ASSET>=300000 AND ASSET < 1000000 THEN '$300 Million to $1 Billion'         
         WHEN ASSET>=1000000 AND ASSET < 2000000 THEN '$1 Billion to $2 Billion'         
         WHEN ASSET>=2000000 AND ASSET < 10000000 THEN '$2 Billion to $10 Billion'
         WHEN ASSET>=10000000 AND ASSET < 100000000 THEN '$10 Billion to $100 Billion'
         WHEN ASSET>=100000000 THEN 'Over $100 Billion'
         END AS ASSET_GROUP_NARROW
  , CASE WHEN ASSET <  100000 THEN 'Small (<$100M)'       
         WHEN ASSET >= 100000 AND ASSET < 1000000 THEN 'Medium ($100M-$1B)'
         WHEN ASSET >= 1000000 THEN 'Large (>$1B)'
         end as asset_group_broad
  ,B.CLOSING_DATE
  ,B.YEARMONTHCLOSING
  ,C.STATE_DESC
  , 1 as count_variable
  FROM 
  F_SDI_DATA A
  JOIN LK_SDI_FAILEDBANKS B
   ON A.CERT_BUS_ID = B.CERT_BUS_ID
  join lk_state c on B.STATE_CD=c.state_cd
  WHERE (a.CERT_BUS_ID, REPDTE) IN
(
select
    cert_bus_id
  , max(repdte)
from
  F_SDI_DATA
  WHERE CERT_BUS_ID IN (select cert_bus_id from lk_sdi_failedbanks)
group by
    CERT_BUS_ID
)
ORDER BY REPDTE DESC, ASSET DESC) D ON D.YEARMONTHCLOSING=E.MONTH_ID
where e.month_id between 200201 and 201603
;