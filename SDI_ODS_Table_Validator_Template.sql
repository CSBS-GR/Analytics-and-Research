SELECT 
SUM(offdom) as offdom,
repdte
FROM DM_ODS.ODS_SDI_BANKDEMOGRAPHICS
group by repdte
order by repdte

