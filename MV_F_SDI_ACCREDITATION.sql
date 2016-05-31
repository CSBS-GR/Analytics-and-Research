DROP MATERIALIZED view dm_mds.mv_f_sdi_accreditation;

create materialized view 
dm_mds.mv_f_sdi_accreditation as
SELECT
  A.BANK_DEMO_ID
, A.CERT_BUS_ID
, CASE WHEN (A.NOIJ IS NULL) THEN 0 ELSE A.NOIJ END AS NOIJ
, CASE WHEN (A.NUMEMP IS NULL) THEN 0 ELSE A.NUMEMP END AS NUMEMP
, CASE WHEN (A.ASTEMPM IS NULL) THEN 0 ELSE A.ASTEMPM END AS ASTEMPM
, CASE WHEN (A.EQCDIV_INCOMEEXPENSE IS NULL) THEN 0 ELSE A.EQCDIV_INCOMEEXPENSE END AS EQCDIV
, CASE WHEN (A.EQPP IS NULL) THEN 0 ELSE A.EQPP END AS EQPP
, CASE WHEN (A.ERNAST5 IS NULL) THEN 0 ELSE A.ERNAST5 END AS ERNAST5
, CASE WHEN (A.INTAN__SSETSLIABILITIES IS NULL) THEN 0 ELSE A.INTAN__SSETSLIABILITIES END AS INTAN
, CASE WHEN (A.LNATRES_ASSETSLIABILITIES IS NULL) THEN 0 ELSE A.LNATRES_ASSETSLIABILITIES END AS LNATRES
, CASE WHEN (A.LNAUTO IS NULL) THEN 0 ELSE A.LNAUTO END AS LNAUTO
, CASE WHEN (A.LNCONOTH IS NULL) THEN 0 ELSE A.LNCONOTH END AS LNCONOTH
, CASE WHEN (A.LNCONRP IS NULL) THEN 0 ELSE A.LNCONRP END AS LNCONRP
, CASE WHEN (A.LNCRCD IS NULL) THEN 0 ELSE A.LNCRCD END AS LNCRCD
, CASE WHEN (A.LNRELOC IS NULL) THEN 0 ELSE A.LNRELOC END AS LNRELOC
, CASE WHEN (A.NCRERESR IS NULL) THEN 0 ELSE A.NCRERESR END AS NCRERESR
, CASE WHEN (A.NONII IS NULL) THEN 0 ELSE A.NONII END AS NONII
, CASE WHEN (A.NTLNLS_INCOMEEXPENSE IS NULL) THEN 0 ELSE A.NTLNLS_INCOMEEXPENSE END AS NTLNLS
, CASE WHEN (A.NTRTMLGJ IS NULL) THEN 0 ELSE A.NTRTMLGJ END AS NTRTMLGJ
, CASE WHEN (A.RBC1RWAJ IS NULL) THEN 0 ELSE A.RBC1RWAJ END AS RBC1RWAJ
, CASE WHEN (A.RBCT1CER IS NULL) THEN 0 ELSE A.RBCT1CER END AS RBCT1CER
--, CASE WHEN (A.SC IS NULL) THEN 0 ELSE A.SC END AS SC
--, CASE WHEN (A.trade IS NULL) THEN 0 ELSE A.trade END AS trade
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
, A.REPDTE 
--, case when (a.LNLSNTV is null) then 0 else a.LNLSNTV end as LNLSNTV
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
, case when (a.SC_SECURITIES is null) then 0 else a.SC_SECURITIES end as SC
, case when (a.SCPLEDGE is null) then 0 else a.SCPLEDGE end as SCPLEDGE
, case when (a.TRADE_SECURITIES is null) then 0 else a.TRADE_SECURITIES end as TRADE
, case when (a.LIAB is null) then 0 else a.LIAB end as LIAB
, CASE WHEN (A.LNLSDEPR IS NULL) THEN 0 ELSE A.LNLSDEPR END AS LNLSDEPR
, CASE WHEN (A.LNCOMRE IS NULL) THEN 0 ELSE A.LNCOMRE END AS LNCOMRE
, 1 AS BANKCOUNT 
, CASE WHEN ( ADD_MONTHS( A.REPDTE, -36) < C.ESTYMD) THEN 1 ELSE 0 END AS NEW_BANK_IND
, C.CB
, C.SUBCHAPS_IND
, CASE WHEN (D.SDI_BK_CLASS_DESC IN ('SM','NM','SB') OR
             (D.SDI_BK_CLASS_DESC IN ('OI','SA') AND E.SDI_REGAGNT_DESC IN ('FDIC'))) 
             then 1 else 0 end as state_charter_ind
from dm_mds.f_sdi_data a
join DM_MDS.F_SDI_DATA_TOTAL b on 
             (A.BANK_DEMO_ID = B.BANK_DEMO_ID AND B.REPDTE=A.REPDTE)
LEFT JOIN DM_MDS.MV_LK_SDI_BANK_DEMO_CRNT C ON (A.cert_bus_id = C.cert_bus_ID)
LEFT JOIN DM_MDS.LK_SDI_BK_CLASS D ON (C.SDI_BK_CLASS_ID = D.SDI_BK_CLASS_ID)
LEFT JOIN DM_MDS.LK_SDI_REGAGNT E ON (C.SDI_REGAGNT_ID = E.SDI_REGAGNT_ID)

WHERE A.REPDTE >= (SELECT ADD_MONTHS(MAX(REPDTE),-48) FROM DM_MDS.LK_SDI_BANK_DEMO);

