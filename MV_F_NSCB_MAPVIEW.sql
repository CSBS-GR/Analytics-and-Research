create materialized view 
dm_mds.mv_f_nscb_mapview as
select
case when count(caseid) is null then 0 else count(caseid) end as bankcount,
b.state_id, b.ST_DESC
from
DM_MDS.F_NSCB_SURVEY a
right OUTER JOIN DM_MDS.LK_NSCB_STATE b on (b.state_id = a.state_id)
where b.state_id <> -1
group by b.state_id, st_desc
order by st_desc;
commit;