create schema if not exists dw_stage ;

drop table if exists dw_stage.transaction_status;

create table dw_stage.transaction_status
( 
 DOCUMENT_TYPE          VARCHAR(500)
,STATUS                 VARCHAR(500)
,PRIMARY KEY (DOCUMENT_TYPE,STATUS)
)
DISTSTYLE ALL INTERLEAVED SORTKEY (DOCUMENT_TYPE,STATUS);