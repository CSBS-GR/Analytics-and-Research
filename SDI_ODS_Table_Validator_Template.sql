SELECT 
SUM(ideoth) as sum_ideoth,
repdte
FROM DM_ODS.ODS_SDI_ADDTLNONINTRSTEXPNS
group by repdte
order by repdte

