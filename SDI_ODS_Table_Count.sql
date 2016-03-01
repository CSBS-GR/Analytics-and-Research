SELECT table_name, num_rows from all_tables
where table_name like 'ODS_SDI_%'
order by num_rows, table_name