create schema if not exists dw_prestage ;

drop table if exists dw_prestage.custom_form;

create table dw_prestage.custom_form
( 
 RUNID                  INTEGER
,CUSTOM_FORM_ID         INTEGER
,CUSTOM_FORM_NAME       VARCHAR(1000)
,FORM_TYPE              VARCHAR(100)
); 
