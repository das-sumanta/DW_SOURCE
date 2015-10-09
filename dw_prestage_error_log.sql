DROP TABLE IF EXISTS dw_prestage.error_log CASCADE;

CREATE TABLE dw_prestage.error_log
(
   error_id      bigint           DEFAULT "identity"(144597, 0, '0,1'::text),
   runid         integer,
   error_desc    varchar(4000),
   target_table  varchar(100),
   error_stage   varchar(100),
   error_timestamp timestamp
);

COMMIT;