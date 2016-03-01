

create materialized view dm_mds.mv_nscb_linesofbusiness as select
answered
,in_business
,percent_business_line
,business_line_name
from 
(select 
sum(answered) as answered
,sum(in_business) as in_business
,1.0* sum(in_business)/sum(answered) as percent_business_line
, 'business_line01' as business_line_name
from (
select 
  business_line01
  , case when business_line01 in (1,0) then 1 else 0 end as answered
  , case when business_line01 in (1) then 1 else 0 end as in_business
from dm_mds.f_nscb_survey) a

union
select 
sum(answered) as answered
,sum(in_business) as in_business
,1.0* sum(in_business)/sum(answered) as percent_business_line
, 'business_line02' as business_line_name
from (
select 
  business_line02
  , case when business_line02 in (1,0) then 1 else 0 end as answered
  , case when business_line02 in (1) then 1 else 0 end as in_business
from dm_mds.f_nscb_survey) a

union
select 
sum(answered) as answered
,sum(in_business) as in_business
,1.0* sum(in_business)/sum(answered) as percent_business_line
, 'business_line03' as business_line_name
from (
select 
  business_line03
  , case when business_line03 in (1,0) then 1 else 0 end as answered
  , case when business_line03 in (1) then 1 else 0 end as in_business
from dm_mds.f_nscb_survey) a
union
select 
sum(answered) as answered
,sum(in_business) as in_business
,1.0* sum(in_business)/sum(answered) as percent_business_line
, 'business_line04' as business_line_name
from (
select 
  business_line04
  , case when business_line04 in (1,0) then 1 else 0 end as answered
  , case when business_line04 in (1) then 1 else 0 end as in_business
from dm_mds.f_nscb_survey) a

union
select 
sum(answered) as answered
,sum(in_business) as in_business
,1.0* sum(in_business)/sum(answered) as percent_business_line
, 'business_line05' as business_line_name
from (
select 
  business_line05
  , case when business_line05 in (1,0) then 1 else 0 end as answered
  , case when business_line05 in (1) then 1 else 0 end as in_business
from dm_mds.f_nscb_survey) a

union
select 
sum(answered) as answered
,sum(in_business) as in_business
,1.0* sum(in_business)/sum(answered) as percent_business_line
, 'business_line06' as business_line_name
from (
select 
  business_line06
  , case when business_line06 in (1,0) then 1 else 0 end as answered
  , case when business_line06 in (1) then 1 else 0 end as in_business
from dm_mds.f_nscb_survey) a

union
select 
sum(answered) as answered
,sum(in_business) as in_business
,1.0* sum(in_business)/sum(answered) as percent_business_line
, 'business_line07' as business_line_name
from (
select 
  business_line07
  , case when business_line07 in (1,0) then 1 else 0 end as answered
  , case when business_line07 in (1) then 1 else 0 end as in_business
from dm_mds.f_nscb_survey) a

union
select 
sum(answered) as answered
,sum(in_business) as in_business
,1.0* sum(in_business)/sum(answered) as percent_business_line
, 'business_line08' as business_line_name
from (
select 
  business_line08
  , case when business_line08 in (1,0) then 1 else 0 end as answered
  , case when business_line08 in (1) then 1 else 0 end as in_business
from dm_mds.f_nscb_survey) a

union
select 
sum(answered) as answered
,sum(in_business) as in_business
,1.0* sum(in_business)/sum(answered) as percent_business_line
, 'business_line09' as business_line_name
from (
select 
  business_line09
  , case when business_line09 in (1,0) then 1 else 0 end as answered
  , case when business_line09 in (1) then 1 else 0 end as in_business
from dm_mds.f_nscb_survey) a

union
select 
sum(answered) as answered
,sum(in_business) as in_business
,1.0* sum(in_business)/sum(answered) as percent_business_line
, 'business_line10' as business_line_name
from (
select 
  business_line10
  , case when business_line10 in (1,0) then 1 else 0 end as answered
  , case when business_line10 in (1) then 1 else 0 end as in_business
from dm_mds.f_nscb_survey) a

union
select 
sum(answered) as answered
,sum(in_business) as in_business
,1.0* sum(in_business)/sum(answered) as percent_business_line
, 'business_line11' as business_line_name
from (
select 
  business_line11
  , case when business_line11 in (1,0) then 1 else 0 end as answered
  , case when business_line11 in (1) then 1 else 0 end as in_business
from dm_mds.f_nscb_survey) a

union
select 
sum(answered) as answered
,sum(in_business) as in_business
,1.0* sum(in_business)/sum(answered) as percent_business_line
, 'business_line12' as business_line_name
from (
select 
  business_line12
  , case when business_line12 in (1,0) then 1 else 0 end as answered
  , case when business_line12 in (1) then 1 else 0 end as in_business
from dm_mds.f_nscb_survey) a

union
select 
sum(answered) as answered
,sum(in_business) as in_business
,1.0* sum(in_business)/sum(answered) as percent_business_line
, 'business_line13' as business_line_name
from (
select 
  business_line13
  , case when business_line13 in (1,0) then 1 else 0 end as answered
  , case when business_line13 in (1) then 1 else 0 end as in_business
from dm_mds.f_nscb_survey) a

union
select 
sum(answered) as answered
,sum(in_business) as in_business
,1.0* sum(in_business)/sum(answered) as percent_business_line
, 'business_line14' as business_line_name
from (
select 
  business_line14
  , case when business_line14 in (1,0) then 1 else 0 end as answered
  , case when business_line14 in (1) then 1 else 0 end as in_business
from dm_mds.f_nscb_survey) a

union
select 
sum(answered) as answered
,sum(in_business) as in_business
,1.0* sum(in_business)/sum(answered) as percent_business_line
, 'business_line15' as business_line_name
from (
select 
  business_line15
  , case when business_line15 in (1,0) then 1 else 0 end as answered
  , case when business_line15 in (1) then 1 else 0 end as in_business
from dm_mds.f_nscb_survey) a
order by percent_business_line desc)