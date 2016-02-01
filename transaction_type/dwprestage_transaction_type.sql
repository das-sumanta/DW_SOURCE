create schema if not exists dw_prestage ;

drop table if exists dw_prestage.transaction_type;

create table dw_prestage.transaction_type
( 
 RUNID                  INTEGER
,TRANSACTION_TYPE_ID    INTEGER
,TRANSACTION_TYPE       VARCHAR(500)
,DOCUMENT_TYPE          VARCHAR(500)
,PREFERRED              VARCHAR(10)
); 