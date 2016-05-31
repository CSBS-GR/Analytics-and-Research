--------------------------------------------------------
--  DDL for Table TMP_SOD_BRANCHMAP
--------------------------------------------------------

drop table dm_mds.tmp_sod_branchmap;

  CREATE TABLE "DM_MDS"."TMP_SOD_BRANCHMAP" 
  AS (
  SELECT	
a.YEAR
,A.CERT
,A.NAMEFULL
,B.CB
,A.BKMO
,A.STALPBR
,A.STNUMBR
,A.STNAMEBR
,A.CNTYNAMB
,A.CNTYNUMB
,A.DEPSUMBR
,A.UNINUMBR
,A.ZIP
,A.ZIPBR
,A.SIMS_LATITUDE
,A.SIMS_LONGITUDE
,1 as branch_counter
FROM DM_ODS.ODS_SOD A
LEFT JOIN DM_MDS.MV_LK_SDI_BANK_DEMO_CRNT B ON (A.CERT=B.CERT_BUS_ID)
where year in (2015,2014)
   ) 
   
--   SELECT  /*csv*/
--   *
--   from "DM_MDS"."TMP_SOD_BRANCHMAP"