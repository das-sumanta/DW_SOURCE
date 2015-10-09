DROP TABLE IF EXISTS dw_prestage.error_log CASCADE;

CREATE TABLE dw_prestage.message_log
(
   message_id      bigint           DEFAULT identity(0,1),
   runid         integer,
   message_desc    varchar(4000),
   target_table  varchar(100),
   message_stage   varchar(100),  
   message_type  varchar(50)     /* can be information , warning , error */
   message_timestamp timestamp
);

COMMIT;