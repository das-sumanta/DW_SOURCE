CREATE SCHEMA if not exists dw;

DROP TABLE if exists dw.customers;

CREATE TABLE dw.customers 
(
  CUSTOMER_KEY               BIGINT IDENTITY(0,1), 
  CUSTOMER_ID                INTEGER,
  CUSTOMER_EXTID             VARCHAR(500),
  LEGACY_CUSTOMER_IDCUSTOM   VARCHAR(4000),
  NAME                       VARCHAR(100),
  EMAIL                      VARCHAR(500),
  CREDITLIMIT                DECIMAL(20,2),
  ADDRESS_LINE1              VARCHAR(500),
  ADDRESS_LINE2              VARCHAR(500),
  ADDRESS_LINE3              VARCHAR(500),
  ZIPCODE                    VARCHAR(100),
  CITY                       VARCHAR(100),
  STATE                      VARCHAR(100),
  COUNTRY                    VARCHAR(100),
  COMPANYNAME                VARCHAR(90),
  CURRENCY                   VARCHAR(150),
  CURRENCY_ID                INTEGER,
  ISINACTIVE                 VARCHAR(10),
  CUSTOMER_TYPE              VARCHAR(50),
  LINE_OF_BUSINESS           VARCHAR(50),
  LINE_OF_BUSINESS_ID        INTEGER,
  SUBSIDIARY                 VARCHAR(83),
  SUBSIDIARY_ID              INTEGER,
  CUSTOMER_CATEGORY          VARCHAR(83),
  PAYMENT_TERMS              VARCHAR(50),
  PAYMENT_TERM_ID            INTEGER,
  PARENT                     VARCHAR(100),
  PARENT_ID                  INTEGER,
  TERRITORY                  VARCHAR(500),                       
  DATE_ACTIVE_FROM           TIMESTAMP,
  DATE_ACTIVE_TO             TIMESTAMP,
  DW_ACTIVE                  VARCHAR(1),
  PRIMARY KEY (CUSTOMER_KEY,CUSTOMER_ID,NAME)
)
DISTSTYLE ALL INTERLEAVED SORTKEY (CUSTOMER_KEY,CUSTOMER_ID,NAME,DW_ACTIVE);

insert into dw.customers
( 
  CUSTOMER_ID             
  ,CUSTOMER_EXTID          
  ,LEGACY_CUSTOMER_IDCUSTOM
  ,NAME                    
  ,EMAIL                   
  ,CREDITLIMIT             
  ,ADDRESS_LINE1           
  ,ADDRESS_LINE2           
  ,ADDRESS_LINE3           
  ,ZIPCODE                 
  ,CITY                    
  ,STATE                   
  ,COUNTRY                 
  ,COMPANYNAME             
  ,CURRENCY                
  ,CURRENCY_ID             
  ,ISINACTIVE              
  ,CUSTOMER_TYPE                    
  ,LINE_OF_BUSINESS        
  ,LINE_OF_BUSINESS_ID     
  ,SUBSIDIARY              
  ,SUBSIDIARY_ID           
  ,CUSTOMER_CATEGORY       
  ,PAYMENT_TERMS           
  ,PAYMENT_TERM_ID         
  ,PARENT                  
  ,PARENT_ID               
  ,TERRITORY               
  ,DATE_ACTIVE_FROM        
  ,DATE_ACTIVE_TO          
  ,DW_ACTIVE  
 )
 select
  -99 AS CUSTOMER_ID
  ,'NA_GDW' AS CUSTOMER_EXTID
  ,'NA_GDW' AS LEGACY_CUSTOMER_IDCUSTOM
  ,'NA_GDW' AS NAME
  ,'NA_GDW' AS EMAIL
  ,-99 AS CREDITLIMIT
  ,'NA_GDW' AS ADDRESS_LINE1
  ,'NA_GDW' AS ADDRESS_LINE2
  ,'NA_GDW' AS ADDRESS_LINE3
  ,'NA_GDW' AS ZIPCODE
  ,'NA_GDW' AS CITY
  ,'NA_GDW' AS STATE
  ,'NA_GDW' AS COUNTRY
  ,'NA_GDW' AS COMPANYNAME
  ,'NA_GDW' AS CURRENCY
  ,-99 AS CURRENCY_ID
  ,'NA_GDW' AS ISINACTIVE
  ,'NA_GDW' AS CUSTOMER_TYPE
  ,'NA_GDW' AS LINE_OF_BUSINESS
  ,-99 AS LINE_OF_BUSINESS_ID
  ,'NA_GDW' AS SUBSIDIARY
  ,-99 AS SUBSIDIARY_ID
  ,'NA_GDW' AS CUSTOMER_CATEGORY
  ,'NA_GDW' AS PAYMENT_TERMS
  ,-99 AS PAYMENT_TERM_ID
  ,'NA_GDW' AS PARENT
  ,-99 AS PARENT_ID
  ,'NA_GDW' AS TERRITORY 
  ,sysdate   as DATE_ACTIVE_FROM                    
  ,'9999-12-31 23:59:59'   as DATE_ACTIVE_TO            
  ,'A'  as DW_ACTIVE ;  
  
  
  insert into dw.customers
( 
  CUSTOMER_ID             
  ,CUSTOMER_EXTID          
  ,LEGACY_CUSTOMER_IDCUSTOM
  ,NAME                    
  ,EMAIL                   
  ,CREDITLIMIT             
  ,ADDRESS_LINE1           
  ,ADDRESS_LINE2           
  ,ADDRESS_LINE3           
  ,ZIPCODE                 
  ,CITY                    
  ,STATE                   
  ,COUNTRY                 
  ,COMPANYNAME             
  ,CURRENCY                
  ,CURRENCY_ID             
  ,ISINACTIVE              
  ,CUSTOMER_TYPE                    
  ,LINE_OF_BUSINESS        
  ,LINE_OF_BUSINESS_ID     
  ,SUBSIDIARY              
  ,SUBSIDIARY_ID           
  ,CUSTOMER_CATEGORY       
  ,PAYMENT_TERMS           
  ,PAYMENT_TERM_ID         
  ,PARENT                  
  ,PARENT_ID               
  ,TERRITORY               
  ,DATE_ACTIVE_FROM        
  ,DATE_ACTIVE_TO          
  ,DW_ACTIVE  
 )
 select
  0 AS CUSTOMER_ID
  ,'NA_ERR' AS CUSTOMER_EXTID
  ,'NA_ERR' AS LEGACY_CUSTOMER_IDCUSTOM
  ,'NA_ERR' AS NAME
  ,'NA_ERR' AS EMAIL
  ,0 AS CREDITLIMIT
  ,'NA_ERR' AS ADDRESS_LINE1
  ,'NA_ERR' AS ADDRESS_LINE2
  ,'NA_ERR' AS ADDRESS_LINE3
  ,'NA_ERR' AS ZIPCODE
  ,'NA_ERR' AS CITY
  ,'NA_ERR' AS STATE
  ,'NA_ERR' AS COUNTRY
  ,'NA_ERR' AS COMPANYNAME
  ,'NA_ERR' AS CURRENCY
  ,0 AS CURRENCY_ID
  ,'NA_ERR' AS ISINACTIVE
  ,'NA_ERR' AS CUSTOMER_TYPE
  ,'NA_ERR' AS LINE_OF_BUSINESS
  ,0 AS LINE_OF_BUSINESS_ID
  ,'NA_ERR' AS SUBSIDIARY
  ,0 AS SUBSIDIARY_ID
  ,'NA_ERR' AS CUSTOMER_CATEGORY
  ,'NA_ERR' AS PAYMENT_TERMS
  ,0 AS PAYMENT_TERM_ID
  ,'NA_ERR' AS PARENT
  ,0 AS PARENT_ID
  ,'NA_ERR' AS TERRITORY 
  ,sysdate   as DATE_ACTIVE_FROM                    
  ,'9999-12-31 23:59:59'   as DATE_ACTIVE_TO            
  ,'A'  as DW_ACTIVE ; 
  
  
                      