--- SQL code (shouldn’t need this)

SELECT /*csv*/
C.*,
SUM(BANKCOUNT) OVER (PARTITION BY STATE_CD) AS STATE_bankCOUNT,
SUM(asset) OVER (PARTITION BY STATE_cd) AS STATE_Asset_sum
from (
SELECT 
CNTYNAMB,
state_cd,
'us-'||lower(state_cd)||'-'||LPAD(CNTYNUMB,3,'0') as code,
COUNT(*) AS BANKCOUNT,
SUM(ASSET) AS ASSET
FROM DM_ODS.ODS_SOD A
join DM_MDS.LK_STATE b on a.stnumbr = B.STATE_ID
where bkclass in ('SM','NM')
AND BKMO = 1
AND YEAR = 2015
GROUP BY CNTYNAMB, STATE_CD, 'us-'||LOWER(STATE_CD)||'-'||LPAD(CNTYNUMB,3,'0')
ORDER BY State_cd, CNTYNAMB
) c


