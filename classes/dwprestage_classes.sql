create schema if not exists dw_prestage ;

drop table if exists dw_prestage.classes;

create table dw_prestage.classes
( 
 RUNID                  INTEGER
,ACCPAC_LOB_CODES        VARCHAR(4000)
,CLASS_EXTID            VARCHAR(255)
,CLASS_ID               INTEGER   
,DATE_LAST_MODIFIED     TIMESTAMP
,FULL_NAME              VARCHAR(1791)
,HYPERION_LOB_CODES     VARCHAR(4000)
,ISINACTIVE             VARCHAR(3)
,LINE_OF_BUSINESS_CODE  VARCHAR(4000)
,NAME                   VARCHAR(31)  
,PARENT_ID              INTEGER 
); 