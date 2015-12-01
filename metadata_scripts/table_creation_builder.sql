select ','||COLUMN_NAME||' ',case when type_name = 'VARCHAR2' AND oa_length > 4000 THEN 'VARCHAR'||'('||cast(oa_length AS VARCHAR)||')'  
                                  when type_name = 'VARCHAR2' AND oa_length <= 4000 THEN 'VARCHAR'||'('||cast(oa_length AS VARCHAR)||')'  
								  WHEN COLUMN_NAME LIKE '%_ID' AND type_name = 'NUMBER' AND OA_SCALE = 0  THEN 'INTEGER'
								  WHEN COLUMN_NAME NOT LIKE '%_ID' AND type_name = 'NUMBER' THEN 'DECIMAL('||CAST(OA_PRECISION AS VARCHAR)||','||CAST(OA_SCALE AS VARCHAR)||')'
                                  ELSE type_name END
from oa_columns
where table_name in ('VENDORS');