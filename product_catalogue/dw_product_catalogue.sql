CREATE SCHEMA if not exists dw;

DROP TABLE if exists dw.product_catalogue;

CREATE TABLE dw.product_catalogue 
(
  product_catalogue_key            BIGINT IDENTITY(0,1),                             
  product_catalogue_ID             INTEGER,                               
  PRODUCT_CATALOGUE_NAME           VARCHAR(3000),                          
  CLUBLEVELREADING_LEVEL_NAME      VARCHAR(3000),                          
  IN_MARKET_END_DATE               DATE,                                     
  IN_MARKET_START_DATE             DATE,                                     
  ISSUEOFFERMONTH_NAME             VARCHAR(3000),                           
  ISSUEOFFERMONTH_DESC             VARCHAR(4000),                          
  IS_INACTIVE                      VARCHAR(10),                              
  LINE_OF_BUSINESS                 VARCHAR(200),                            
  NO__OF_BOOKS_IN_OFFER_BIH_O_ID   INTEGER,                               
  OFFER_DESCRIPTION                VARCHAR(4000),                           
  SUBSIDIARY                       VARCHAR(400),                            
  YEARMONTH_YYYYMM                 DECIMAL(22,0),                         
  YEARMONTH_YYYYMM__REMOVE         DECIMAL(22,0),                         
  PRODUCT_CATALOGUE_YEAR           VARCHAR(1000),                           
  DATE_ACTIVE_FROM                 TIMESTAMP,                             
  DATE_ACTIVE_TO                   TIMESTAMP,                                           
  DW_ACTIVE                        VARCHAR(1),                            
  PRIMARY KEY (product_catalogue_key)
)
DISTSTYLE ALL INTERLEAVED SORTKEY (product_catalogue_key,product_catalogue_ID,DW_ACTIVE);


INSERT INTO dw.product_catalogue
(
   product_catalogue_ID         
  ,PRODUCT_CATALOGUE_NAME       
  ,CLUBLEVELREADING_LEVEL_NAME  
  ,IN_MARKET_END_DATE      
  ,IN_MARKET_START_DATE    
  ,ISSUEOFFERMONTH_NAME         
  ,ISSUEOFFERMONTH_DESC         
  ,IS_INACTIVE                  
  ,LINE_OF_BUSINESS             
  ,NO__OF_BOOKS_IN_OFFER_BIH_O_ID
  ,OFFER_DESCRIPTION            
  ,SUBSIDIARY                   
  ,YEARMONTH_YYYYMM             
  ,YEARMONTH_YYYYMM__REMOVE     
  ,PRODUCT_CATALOGUE_YEAR       
  ,DATE_ACTIVE_FROM             
  ,DATE_ACTIVE_TO               
  ,DW_ACTIVE                    
)
SELECT 
       -99  AS product_catalogue_ID               
      ,'NA_GDW'  AS PRODUCT_CATALOGUE_NAME        
      ,'NA_GDW'  AS CLUBLEVELREADING_LEVEL_NAME   
      ,'9999-12-31' AS IN_MARKET_END_DATE     
      ,'9999-12-31' AS IN_MARKET_START_DATE    
      ,'NA_GDW'    AS ISSUEOFFERMONTH_NAME         
      ,'NA_GDW'   AS ISSUEOFFERMONTH_DESC          
      ,'NA_GDW'    AS IS_INACTIVE                 
      ,'NA_GDW'   AS LINE_OF_BUSINESS             
      ,-99  AS NO__OF_BOOKS_IN_OFFER_BIH_O_ID     
      ,'NA_GDW'   AS OFFER_DESCRIPTION            
      ,'NA_GDW'   AS SUBSIDIARY                   
      ,0  AS YEARMONTH_YYYYMM                    
      ,0  AS YEARMONTH_YYYYMM__REMOVE            
      ,'NA_GDW'   AS PRODUCT_CATALOGUE_YEAR       
      , SYSDATE AS DATE_ACTIVE_FROM               
      , '9999-12-31 23:59:59' AS DATE_ACTIVE_TO   
      , 'A' AS DW_ACTIVE ;                         

INSERT INTO dw.product_catalogue
(
   product_catalogue_ID         
  ,PRODUCT_CATALOGUE_NAME       
  ,CLUBLEVELREADING_LEVEL_NAME  
  ,IN_MARKET_END_DATE      
  ,IN_MARKET_START_DATE     
  ,ISSUEOFFERMONTH_NAME         
  ,ISSUEOFFERMONTH_DESC         
  ,IS_INACTIVE                  
  ,LINE_OF_BUSINESS             
  ,NO__OF_BOOKS_IN_OFFER_BIH_O_ID
  ,OFFER_DESCRIPTION            
  ,SUBSIDIARY                   
  ,YEARMONTH_YYYYMM             
  ,YEARMONTH_YYYYMM__REMOVE     
  ,PRODUCT_CATALOGUE_YEAR       
  ,DATE_ACTIVE_FROM             
  ,DATE_ACTIVE_TO               
  ,DW_ACTIVE          
)
SELECT  0  AS product_catalogue_ID               
      ,'NA_ERR'  AS PRODUCT_CATALOGUE_NAME        
      ,'NA_ERR'  AS CLUBLEVELREADING_LEVEL_NAME   
      ,'9999-12-31' AS IN_MARKET_END_DATE_KEY      
      ,'9999-12-31' AS IN_MARKET_START_DATE_KEY    
      ,'NA_ERR'    AS ISSUEOFFERMONTH_NAME         
      ,'NA_ERR'   AS ISSUEOFFERMONTH_DESC          
      ,'NA_ERR'    AS IS_INACTIVE                 
      ,'NA_ERR'   AS LINE_OF_BUSINESS             
      ,0  AS NO__OF_BOOKS_IN_OFFER_BIH_O_ID     
      ,'NA_ERR'   AS OFFER_DESCRIPTION            
      ,'NA_ERR'   AS SUBSIDIARY                   
      ,0  AS YEARMONTH_YYYYMM                    
      ,0  AS YEARMONTH_YYYYMM__REMOVE            
      ,'NA_ERR'   AS PRODUCT_CATALOGUE_YEAR       
      , SYSDATE AS DATE_ACTIVE_FROM               
      , '9999-12-31 23:59:59' AS DATE_ACTIVE_TO   
      , 'A' AS DW_ACTIVE ;                         

COMMIT;

