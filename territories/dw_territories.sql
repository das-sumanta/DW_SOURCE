CREATE SCHEMA if not exists dw;

DROP TABLE if exists dw.territories;

CREATE TABLE dw.territories 
(
  TERRITORY_KEY              BIGINT IDENTITY(0,1), 
  TERRITORY_ID               INTEGER,
  TERRITORY                  VARCHAR(100),
  SUBSIDIARY                 VARCHAR(100),
  SUBSIDIARY_ID              INTEGER,   
  IS_INACTIVE                VARCHAR(10),
  DATE_ACTIVE_FROM           TIMESTAMP,
  DATE_ACTIVE_TO             TIMESTAMP,
  DW_ACTIVE                  VARCHAR(1),
  PRIMARY KEY (TERRITORY_KEY,TERRITORY_ID,TERRITORY)
)
DISTSTYLE ALL INTERLEAVED SORTKEY (TERRITORY_KEY,TERRITORY_ID,TERRITORY,DW_ACTIVE);



insert into dw.territories
(      
   TERRITORY_ID      
  ,TERRITORY 
  ,SUBSIDIARY_ID
  ,SUBSIDIARY
  ,IS_INACTIVE        
  ,DATE_ACTIVE_FROM  
  ,DATE_ACTIVE_TO    
  ,DW_ACTIVE 
 )
 select                                        
  -99 AS TERRITORY_ID                   
  ,'NA_GDW' AS TERRITORY
  ,-99 AS SUBSIDIARY_ID
    ,'NA_GDW' AS SUBSIDIARY 
    ,'NA_GDW' AS IS_INACTIVE      
    ,sysdate   as DATE_ACTIVE_FROM                        
    ,'9999-12-31 23:59:59'   as DATE_ACTIVE_TO            
    ,'A'  as DW_ACTIVE ; 
    
insert into dw.territories
(      
   TERRITORY_ID      
  ,TERRITORY   
  ,SUBSIDIARY_ID
  ,SUBSIDIARY
  ,IS_INACTIVE            
  ,DATE_ACTIVE_FROM  
  ,DATE_ACTIVE_TO    
  ,DW_ACTIVE 
 )
 select                                        
   0 AS TERRITORY_ID                   
  ,'NA_ERR' AS TERRITORY 
   ,0 AS SUBSIDIARY_ID
    ,'NA_ERR' AS SUBSIDIARY 
    ,'NA_ERR' AS IS_INACTIVE             
    ,sysdate   as DATE_ACTIVE_FROM                        
    ,'9999-12-31 23:59:59'   as DATE_ACTIVE_TO            
    ,'A'  as DW_ACTIVE ; 
    
commit; 
