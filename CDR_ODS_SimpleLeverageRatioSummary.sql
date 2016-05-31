SELECT /*csv*/
A.STATE_DESC
,A.CHARTER_TYPE     
,A.NR_BANKS
,B.BANKS_SLR_OVER10PCT
,C.BANKS_SLR_UNDER10PCT
,D.BANKS_OVER10B_ASSETS
,E.BANKS_CB
,F.BANKS_NOT_CB
from
(SELECT
STATE_DESC
,CHARTER_TYPE     
,COUNT(*) AS NR_BANKS
FROM TMP_F_CDR_SIMPLELEVRATIO
GROUP BY STATE_DESC,CHARTER_TYPE  
ORDER BY STATE_DESC,CHARTER_TYPE ) A


left JOIN
(SELECT
STATE_DESC
,CHARTER_TYPE     
,COUNT(*) AS BANKS_SLR_Over10pct
FROM TMP_F_CDR_SIMPLELEVRATIO
where simple_leverage_ratio >= 0.1
GROUP BY STATE_DESC,CHARTER_TYPE  
ORDER BY STATE_DESC,CHARTER_TYPE ) B ON 
 (B.STATE_DESC = A.STATE_DESC AND A.CHARTER_TYPE = B.CHARTER_TYPE)
left join 
(SELECT
STATE_DESC
,CHARTER_TYPE     
,COUNT(*) AS BANKS_SLR_Under10pct
FROM TMP_F_CDR_SIMPLELEVRATIO
where simple_leverage_ratio < 0.1
GROUP BY STATE_DESC,CHARTER_TYPE  
ORDER BY STATE_DESC,CHARTER_TYPE ) c ON 
 (c.STATE_DESC = A.STATE_DESC AND A.CHARTER_TYPE = c.CHARTER_TYPE)
 
 left join 
(SELECT
STATE_DESC
,CHARTER_TYPE     
,COUNT(*) AS BANKS_Over10b_assets
FROM TMP_F_CDR_SIMPLELEVRATIO
where TMP_F_CDR_SIMPLELEVRATIO.TOTAL_ASSETS_RCON2170 > 10000000
GROUP BY STATE_DESC,CHARTER_TYPE  
ORDER BY STATE_DESC,CHARTER_TYPE ) d ON 
 (D.STATE_DESC = A.STATE_DESC AND A.CHARTER_TYPE = D.CHARTER_TYPE)

 left join 
(SELECT
STATE_DESC
,CHARTER_TYPE     
,COUNT(*) AS BANKS_cb
FROM TMP_F_CDR_SIMPLELEVRATIO
where cb=1
GROUP BY STATE_DESC,CHARTER_TYPE  
ORDER BY STATE_DESC,CHARTER_TYPE ) e ON 
 (e.STATE_DESC = A.STATE_DESC AND A.CHARTER_TYPE = e.CHARTER_TYPE)
 
  left join 
(SELECT
STATE_DESC
,CHARTER_TYPE     
,COUNT(*) AS banks_Not_cb
FROM TMP_F_CDR_SIMPLELEVRATIO
where cb=0
GROUP BY STATE_DESC,CHARTER_TYPE  
ORDER BY STATE_DESC,CHARTER_TYPE ) f ON 
 (F.STATE_DESC = A.STATE_DESC AND A.CHARTER_TYPE = F.CHARTER_TYPE)
order by state_DEsc, charter_type

