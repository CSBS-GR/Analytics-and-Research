drop table dm_ods.ods_lk_city;

create table DM_ODS.ODS_LK_CITY as 
SELECT
 state_id *100000 + dense_rank() over (partition by state_id order by city_desc) as city_id
,city_desc
,state_id
from
(
select 
 a.city_desc
,b.stnumbr as state_id
from
(
SELECT DISTINCT
initcap(city_desc) as city_desc
,state_Cd
from (

select 
ODS_SOD.CITY2BR as CITY_DESC
,ODS_SOD.StalpBR as State_cd
from DM_ODS.ODS_SOD 

union all

select 
ODS_SOD.CITYHCR as CITY_DESC
,ODS_SOD.stalphcr as State_cd 
from DM_ODS.ODS_SOD

union all
select 
ODS_SOD.CITY as CITY_DESC
,ODS_SOD.stalp as State_cd 
from DM_ODS.ODS_SOD
)
) a
join 
(select distinct
stnumbr
,stalpbr
from  dm_ods.ods_sod) b
on (b.stalpbr = a.state_cd) )
order by state_id, city_desc    

