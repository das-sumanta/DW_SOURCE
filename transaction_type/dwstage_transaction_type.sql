create schema if not exists dw_stage ;

drop table if exists dw_stage.transaction_type;

create table dw_stage.transaction_type
( 
 TRANSACTION_TYPE_ID    INTEGER
,TRANSACTION_TYPE       VARCHAR(500)
,DOCUMENT_TYPE          VARCHAR(500)
,PREFERRED              VARCHAR(10)
,PRIMARY KEY TRANSACTION_TYPE_ID)
)
DISTSTYLE ALL INTERLEAVED SORTKEY TRANSACTION_TYPE_ID,TRANSACTION_TYPE,DOCUMENT_TYPE);