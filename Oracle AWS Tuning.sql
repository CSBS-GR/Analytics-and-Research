select tablespace_name, sum(bytes) bytes
FROM DBA_SEGMENTS
group by tablespace_name order by 2;

select tablespace_name, sum(bytes) bytes
FROM DBA_FREE_SPACE
group by tablespace_name order by 2;

ALTER TABLESPACE UNDO_T1 RESIZE 10G;
ALTER TABLESPACE TEMP RESIZE 100g;
ALTER TABLESPACE TEMP autoextend on maxsize unlimited;

SELECT TABLESPACE_NAME, FILE_NAME, BYTES
FROM dba_temp_files;

SELECT * FROM dba_temp_free_space;


SELECT *
FROM database_properties
WHERE PROPERTY_NAME LIKE '%TABLESPACE';

select value from v$parameter where name = 'db_block_size';

SELECT SUM (u.blocks * blk.block_size) / 1024 / 1024 "Mb. in sort segments"
, (hwm.MAX * blk.block_size) / 1024 / 1024 "Mb. High Water Mark"
FROM v$sort_usage u
, (SELECT block_size
FROM DBA_TABLESPACES
WHERE CONTENTS = 'TEMPORARY') blk
, (SELECT segblk# + blocks MAX
FROM v$sort_usage
WHERE segblk# = (SELECT MAX (segblk#)
FROM v$sort_usage)) hwm
GROUP BY HWM.MAX * BLK.BLOCK_SIZE / 1024 / 1024;

purge recyclebin;
