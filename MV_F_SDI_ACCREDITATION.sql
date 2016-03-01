--create materialized view 
--dm_mds.mv_f_sdi_accreditation as
select
  case when (a.numemp is null) then 0 else a.numemp end as numemp
, case when (a.NETINC_INCOMEEXPENSE is null) then 0 else a.NETINC_INCOMEEXPENSE end as NETINC
, case when (a.asset is null) then 0 else a.asset end as asset
, case when (a.ernast is null) then 0 else a.ernast end as ernast
, case when (a.lnlsgr is null) then 0 else a.lnlsgr end as lnlsgr
, case when (a.ORE_ASSETSLIABILITIES is null) then 0 else a.ORE_ASSETSLIABILITIES end as ORE
, case when (a.dep is null) then 0 else a.dep end as dep
, case when (a.eqtot is null) then 0 else a.eqtot end as eqtot
, case when (a.intanmsr is null) then 0 else a.intanmsr end as intanmsr
, case when (a.iserchg is null) then 0 else a.iserchg end as iserchg
, case when (a.intincy is null) then 0 else a.intincy end as intincy
, case when (a.nimy is null) then 0 else a.nimy end as nimy
, case when (a.ASSET5_ASSETSLIABILITIES is null) then 0 else a.ASSET5_ASSETSLIABILITIES end as ASSET5
, case when (a.intinc is null) then 0 else a.intinc end as intinc
, case when (a.noniiay is null) then 0 else a.noniiay end as noniiay
, case when (a.EINTEXP is null) then 0 else a.EINTEXP end as EINTEXP
, case when (a.nonixay is null) then 0 else a.nonixay end as nonixay
, case when (a.NTRTMLG_DEP100KTHRESH is null) then 0 else a.NTRTMLG_DEP100KTHRESH end as NTRTMLG
, case when (a.IDOBRMTG is null) then 0 else a.IDOBRMTG end as IDOBRMTG
, case when (a.DEPFOR is null) then 0 else a.DEPFOR end as DEPFOR 
, case when (a.FREPP is null) then 0 else a.FREPP end as FREPP
, case when (b.BRO is null) then 0 else b.BRO end as BRO
, case when (a.CHBALI is null) then 0 else a.CHBALI end as CHBALI
, case when (a.FREPO is null) then 0 else a.FREPO end as FREPO
, case when (b.SC1LES is null) then 0 else b.SC1LES end as SC1LES
, case when (a.LNLSNET_ASSETSLIABILITIES is null) then 0 else a.LNLSNET_ASSETSLIABILITIES end as lnlsnet
, case when (a.SCHA is null) then 0 else a.SCHA end as SCHA
, case when (a.SCAF is null) then 0 else a.SCAF end as SCAF
, case when (a.NTLNLSR_NETCHRGOFFLNS is null) then 0 else a.NTLNLSR_NETCHRGOFFLNS end as NTLNLSR
, case when (a.LNATRESR is null) then 0 else a.LNATRESR end as LNATRESR
, case when (a.IDDIVNIR is null) then 0 else a.IDDIVNIR end as IDDIVNIR
, case when (a.ROA is null) then 0 else a.ROA end as ROA
, case when (a.ROE is null) then 0 else a.ROE end as ROE
, case when (a.EEFFR is null) then 0 else a.EEFFR end as EEFFR
, case when (a.IDNTILR is null) then 0 else a.IDNTILR end as IDNTILR
, case when (a.IDNTIGR is null) then 0 else a.IDNTIGR end as IDNTIGR
, case when (a.NOIJY is null) then 0 else a.NOIJY end as NOIJY
, a.repdte 
, case when (a.LNLSNTV is null) then 0 else a.LNLSNTV end as LNLSNTV
, case when (a.P3ASSET is null) then 0 else a.P3ASSET end as P3ASSET
, case when (a.P9ASSET is null) then 0 else a.P9ASSET end as P9ASSET
, case when (a.LNRENROT is null) then 0 else a.LNRENROT end as LNRENROT
, case when (a.LNRECONS is null) then 0 else a.LNRECONS end as LNRECONS
, case when (a.LNREMULT is null) then 0 else a.LNREMULT end as LNREMULT
, case when (a.RBCT1J is null) then 0 else a.RBCT1J end as RBCT1J
, case when (a.RBCT2 is null) then 0 else a.RBCT2 end as RBCT2
, case when (a.LNCI is null) then 0 else a.LNCI end as LNCI
, case when (a.LNAG is null) then 0 else a.LNAG end as LNAG
, case when (a.LNREAG is null) then 0 else a.LNREAG end as LNREAG
, case when (a.NAASSET is null) then 0 else a.NAASSET end as NAASSET
, case when (a.EQ_ASSETSLIABILITIES is null) then 0 else a.EQ_ASSETSLIABILITIES end as eq
, case when (a.RBC1AAJ is null) then 0 else a.RBC1AAJ end as RBC1AAJ
, case when (a.RBCRWAJ is null) then 0 else a.RBCRWAJ end as RBCRWAJ
, case when (a.CHBAL_CASHBALDUE is null) then 0 else a.CHBAL_CASHBALDUE end as chbal
, case when (a.SC_SECURITIES is null) then 0 else a.SC_SECURITIES end as SC_SECURITIES
, case when (a.SCPLEDGE is null) then 0 else a.SCPLEDGE end as SCPLEDGE
, case when (a.TRADE_SECURITIES is null) then 0 else a.TRADE_SECURITIES end as TRADE_SECURITIES
, case when (a.LIAB is null) then 0 else a.LIAB end as LIAB
, case when (a.LNLSDEPR is null) then 0 else a.LNLSDEPR end as LNLSDEPR
--, case when (a.lncomre is null then 0 else a.lcomre end) as lncomre
from dm_mds.f_sdi_data a
join DM_MDS.F_SDI_DATA_TOTAL b on 
             (a.bank_demo_id = b.bank_demo_id and b.repdte=a.repdte)
WHERE ROWNUM <= 100 -- and a.repdte >= (select add_months(max(repdte),-48) from DM_MDS.LK_SDI_BANK_DEMO);
