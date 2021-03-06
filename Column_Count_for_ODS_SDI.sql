SELECT count(*)
FROM USER_TAB_COLUMNS
WHERE TABLE_NAME IN
('ODS_SDI_ADDTLNONINTRSTEXPNS'
, 'ODS_SDI_ADDTLNONINTRSTINCM'
, 'ODS_SDI_AMNTOWNRSHPSLLRINTRST'
, 'ODS_SDI_ASSETSLIABILITIES'
, 'ODS_SDI_BNKASSTSLDSCRTZ'
, 'ODS_SDI_CARRYAMMNTCOVFDIC'
, 'ODS_SDI_CASHBALDUE'
, 'ODS_SDI_CASHDIVIDENDS'
, 'ODS_SDI_CHNGBNKEQTYCPTL'
, 'ODS_SDI_COLLCTVINVSTCMNTRFND'
, 'ODS_SDI_CORPTRSTAGACCNT'
, 'ODS_SDI_DEP100KTHRESH'
, 'ODS_SDI_DEP250KTHRESH'
, 'ODS_SDI_DEPOSITSFOREIGNOFFIC'
, 'ODS_SDI_DERIVATIVES'
, 'ODS_SDI_FAMIRESIDENTNETLOANLS'
, 'ODS_SDI_FIDUCIARYRLTDSRVCS'
, 'ODS_SDI_FIDUCIARYSTLMNTSRCHG'
, 'ODS_SDI_GOODWILLINTNGBL'
, 'ODS_SDI_GROSSFIDUCRLTD'
, 'ODS_SDI_INCOMEEXPENSE'
, 'ODS_SDI_INTERESTINCMEXPNSFRGN'
, 'ODS_SDI_LETTERSCREDIT'
, 'ODS_SDI_LOANCHRGOFFRCVRY'
, 'ODS_SDI_LOANRSTRCTTDR'
, 'ODS_SDI_LOANSDEPOSITORY'
, 'ODS_SDI_MATURITYRPRCNGLNSLSS'
, 'ODS_SDI_MAXAMNTCRDTEXPSRRTND'
, 'ODS_SDI_MEMORANDA'
, 'ODS_SDI_NETCHRGOFF14FMLYRSDNTL'
, 'ODS_SDI_NETCHRGOFFLNS'
, 'ODS_SDI_NETLNSLSS'
, 'ODS_SDI_NONACCRL14FMLYRSDNTL'
, 'ODS_SDI_NONCURRNTLNSTOLNS'
, 'ODS_SDI_NONTRANSACTIONACCNTS'
, 'ODS_SDI_NRFDCRYRLTDASSTACCNT'
, 'ODS_SDI_OTHRREALESTTOWN'
, 'ODS_SDI_PASTD3089DYS14FMLYRSD'
, 'ODS_SDI_PASTD90PLSDYS14FMLYRSD'
, 'ODS_SDI_PASTDNNACCRLASST'
, 'ODS_SDI_PASTDUEUSGVMTGUARANT'
, 'ODS_SDI_PERFORMCNDTNRS'
, 'ODS_SDI_SECURITIES'
, 'ODS_SDI_SMALLBSNSSLNS'
, 'ODS_SDI_TIMEDPSTS100KMR'
, 'ODS_SDI_TIMEDPSTSLSS100K'
, 'ODS_SDI_TRADINGACCNTGNSFS'
, 'ODS_SDI_TRANSACTIONACCOUNTS'
, 'ODS_SDI_UNUSEDCOMMITMENTS'
, 'ODS_SDI_USGOBLIGATIONS'
);