drop table dm_mds.tmp_pf_accr_percent;
create table dm_mds.tmp_pf_accr_percent as
select account, year, question_label, answer_percent as response, pct_avg as national_level, accr_categ, olsonid, topic_title from (
SELECT
olsonid
,ACCOUNT
,topic_title
,CAST(YEAR AS INTEGER) YEAR
,REGEXP_REPLACE(replace(QUESTION_LABEL, ' -- % of Total',''), '^Insured Depositories$','Insured Depositories Over $10 Billion') as question_label
,ANSWER_PERCENT
, SUM(ANSWER_PERCENT) OVER (PARTITION BY ACCOUNT) NOTZERO
, ROUND(AVG(ANSWER_PERCENT) OVER (PARTITION BY YEAR, OLSONID),2) AS PCT_AVG
, 'Sources of Funding' as Accr_categ
FROM 
DM_MDS.TMP_PF_ALLYR_SECTIONI
WHERE 
   (
     olsonid in  ('QMICDT_1106-A','SFDC-5371-A','QMICDT_1107-A','QMICDT_1108-A','QMICDT_1109-A')
   )
    
      AND YEAR IN (2012,2013,2014,2015)
ORDER BY ACCOUNT, YEAR, QUESTION_LABEL ) where notzero <> 0
