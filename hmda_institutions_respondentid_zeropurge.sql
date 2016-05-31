update mstrredshift.public.hmdainstitution
set updated_respondent_id =ltrim(updated_respondent_id, '0')
where updated_respondent_id like '0%'


select *  from mstrredshift.public.hmdainstitution
where respondent_id like '0%-%'
 limit 1000