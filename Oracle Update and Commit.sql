MERGE INTO DM_MDS.F_SDI_DATA a
USING 
(
  SELECT cert,
         repdte,
         lncomre
  FROM dm_ods.ods_sdi_netlnslss
) ta ON (ta.cert = a.cert_bus_id and ta.repdte=a.repdte)
WHEN MATCHED THEN UPDATE 
    SET a.lncomre = ta.lncomre;
    commit work;