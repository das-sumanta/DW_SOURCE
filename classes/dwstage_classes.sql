create schema if not exists dw_stage ;

drop table if exists dw_stage.classes;

create table dw_stage.classes
(

 ACCPAC_LOB_CODES       VARCHAR(4000)
,CLASS_EXTID            VARCHAR(255)
,CLASS_ID               INTEGER   
,DATE_LAST_MODIFIED     TIMESTAMP
,FULL_NAME              VARCHAR(1791)
,HYPERION_LOB_CODES     VARCHAR(4000)
,ISINACTIVE             VARCHAR(3)
,LINE_OF_BUSINESS_CODE  VARCHAR(4000)
,NAME                   VARCHAR(31)  
,PARENT_ID              INTEGER,
  PRIMARY KEY (CLASS_ID,LINE_OF_BUSINESS_CODE,NAME)
)
DISTSTYLE ALL INTERLEAVED SORTKEY (CLASS_ID,LINE_OF_BUSINESS_CODE,NAME);

