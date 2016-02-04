create schema if not exists dw_prestage ;

drop table if exists dw_prestage.transaction_status;

create table dw_prestage.transaction_status
( 
 RUNID                  INTEGER
,DOCUMENT_TYPE          VARCHAR(500)
,STATUS              VARCHAR(500)
); 

