create table LK_Agency as 
select cb.Account_ID,
b.account,
b.AGENCY_NAME,
b.STATE,
b.STATE_ID,
b.SDI_STATE_ID,
case when cb.Account_ID in (16,17,18,31,32,33,34,43,44,46,53,54,55,66,76)then 1
when cb.Account_ID in (24,25,26,27,29,35,36,38,49,71,77,78)then 2
when cb.Account_ID in (1,2,5,6,19,20,30,37,47,56,57,58,59,60,67,68,70,79,80,81)then 3
when cb.Account_ID in (13,14,15,21,22,23,40,45,48,50,51,61,62,63,72,73,74,75,82,83,84) then 4
when cb.Account_ID in (3,4,7,8,9,10,11,12,28,39,41,42,52,64,65,69) then 5
end as District_ID
FROM LK_PF_VALIDAGENCY b
left join LK_PF_ACCOUNT cb
on upper(b.AGENCY_NAME) = upper(cb.full_name);
