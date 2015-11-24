create schema if not exists dw_stage ;

drop table if exists dw_stage.custom_form;

create table dw_stage.custom_form
( 
 RUNID                  INTEGER
,CUSTOM_FORM_ID         INTEGER
,CUSTOM_FORM_NAME       VARCHAR(1000)
,FORM_TYPE              VARCHAR(100)
);