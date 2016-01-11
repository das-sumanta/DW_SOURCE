/* prestage - drop intermediate insert table */ 
DROP TABLE if exists dw_prestage.customers_insert;

/* prestage - create intermediate insert table*/ 
CREATE TABLE dw_prestage.customers_insert 
AS
SELECT *
FROM dw_prestage.customers
WHERE EXISTS (SELECT 1
              FROM (SELECT customer_id
                    FROM (SELECT customer_id
                          FROM dw_prestage.customers
                          MINUS
                          SELECT customer_id
                          FROM dw_stage.customers)) a
              WHERE dw_prestage.customers.customer_id = a.customer_id);

/* prestage - drop intermediate update table*/ 
DROP TABLE if exists dw_prestage.customers_update;

/* prestage - create intermediate update table*/ 
CREATE TABLE dw_prestage.customers_update 
AS
SELECT decode(SUM(ch_type),
             3,2,
             SUM(ch_type)
       )  ch_type,
       customer_id
FROM (SELECT customer_id,
             CH_TYPE
      FROM (SELECT customer_id
                  ,CURRENCY
                  ,CURRENCY_ID
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
                  ,'2' CH_TYPE
            FROM dw_prestage.customers
            MINUS
            SELECT customer_id
                  ,CURRENCY
                  ,CURRENCY_ID
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
                  ,'2' CH_TYPE
            FROM dw_stage.customers)
      UNION ALL
      SELECT customer_id,
             CH_TYPE
      FROM (SELECT customer_id
                   ,CUSTOMER_EXTID
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
                   ,ISINACTIVE
                   ,'1' CH_TYPE
            FROM dw_prestage.customers
            MINUS
            SELECT customer_id
                   ,CUSTOMER_EXTID
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
                   ,ISINACTIVE
                   ,'1' CH_TYPE
            FROM dw_stage.customers)) a
WHERE NOT EXISTS (SELECT 1
                  FROM dw_prestage.customers_insert
                  WHERE dw_prestage.customers_insert.customer_id = a.customer_id)
GROUP BY customer_id;

/* prestage - drop intermediate delete table*/ 
DROP TABLE if exists dw_prestage.customers_delete;

/* prestage - create intermediate delete table*/ 
CREATE TABLE dw_prestage.customers_delete 
AS
SELECT *
FROM dw_stage.customers
WHERE EXISTS (SELECT 1
              FROM (SELECT customer_id
                    FROM (SELECT customer_id
                          FROM dw_stage.customers
                          MINUS
                          SELECT customer_id
                          FROM dw_prestage.customers)) a
              WHERE dw_stage.customers.customer_id = a.customer_id);

/* prestage-> stage*/ 
SELECT 'no of prestage customer records identified to inserted -->' ||count(1)
FROM dw_prestage.customers_insert;

/* prestage-> stage*/ 
SELECT 'no of prestage customer records identified to updated -->' ||count(1)
FROM dw_prestage.customers_update;

/* prestage-> stage*/ 
SELECT 'no of prestage customer records identified to deleted -->' ||count(1)
FROM dw_prestage.customers_delete;

/* stage -> delete from stage records to be updated */ 
DELETE
FROM dw_stage.customers USING dw_prestage.customers_update
WHERE dw_stage.customers.customer_id = dw_prestage.customers_update.customer_id;

/* stage -> delete from stage records which have been deleted */ 
DELETE
FROM dw_stage.customers USING dw_prestage.customers_delete
WHERE dw_stage.customers.customer_id = dw_prestage.customers_delete.customer_id;

/* stage -> insert into stage records which have been created */ 
INSERT INTO dw_stage.customers
(
   CUSTOMER_EXTID            
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
)
SELECT  CUSTOMER_EXTID            
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
FROM dw_prestage.customers_insert;

/* stage -> insert into stage records which have been updated */ 
INSERT INTO dw_stage.customers
(
  CUSTOMER_EXTID            
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
)
SELECT CUSTOMER_EXTID            
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
FROM dw_prestage.customers
WHERE EXISTS (SELECT 1
              FROM dw_prestage.customers_update
              WHERE dw_prestage.customers_update.customer_id = dw_prestage.customers.customer_id);

COMMIT;

/* dimension ->insert new records in dim customers */ 

INSERT INTO dw.customers
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
SELECT customer_ID,
       NVL(customer_EXTID,'NA_GDW') ,
       NVL(LEGACY_CUSTOMER_IDCUSTOM,'NA_GDW') ,
       NVL(NAME,'NA_GDW') ,
       NVL(EMAIL,'NA_GDW'	) ,
       NVL(CREDITLIMIT,-99	) ,
       NVL(ADDRESS_LINE1,'NA_GDW') ,
       NVL(ADDRESS_LINE2,'NA_GDW') ,
       NVL(ADDRESS_LINE3,'NA_GDW') ,
       NVL(ZIPCODE,'NA_GDW') ,
       NVL(CITY,'NA_GDW') ,
       NVL(STATE,'NA_GDW') ,
       NVL(COUNTRY,'NA_GDW') ,
       NVL(COMPANYNAME,'NA_GDW') ,
       NVL(CURRENCY,'NA_GDW') ,
       NVL(CURRENCY_ID,-99),
       NVL(ISINACTIVE,'NA_GDW'),
       NVL(CUSTOMER_TYPE,'NA_GDW'),
       NVL(LINE_OF_BUSINESS,'NA_GDW'),
       NVL(LINE_OF_BUSINESS_ID,-99),
       NVL(SUBSIDIARY,'NA_GDW') ,
       NVL(SUBSIDIARY_ID,-99),
       NVL(CUSTOMER_CATEGORY,'NA_GDW'),
       NVL(PAYMENT_TERMS,'NA_GDW') ,
       NVL(PAYMENT_TERM_ID,-99),
       NVL(PARENT,'NA_GDW') ,
       NVL(PARENT_ID,-99),
       NVL(TERRITORY,'NA_GDW') ,
       sysdate,
       '9999-12-31 23:59:59',
       'A'
FROM dw_prestage.customers_insert A;

/* dimension -> update old record as part of SCD2 maintenance*/ 
UPDATE dw.customers
   SET dw_active = 'I',
       DATE_ACTIVE_TO = (sysdate -1)
WHERE dw_active = 'A'
AND   sysdate>= date_active_from
AND   sysdate< date_active_to
AND   EXISTS (SELECT 1
              FROM dw_prestage.customers_update
              WHERE dw.customers.customer_id = dw_prestage.customers_update.customer_id
              AND   dw_prestage.customers_update.ch_type = 2);

/* dimension -> insert the new records as part of SCD2 maintenance*/ 
INSERT INTO dw.customers
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
SELECT customer_ID,
       NVL(customer_EXTID,'NA_GDW') ,
       NVL(LEGACY_CUSTOMER_IDCUSTOM,'NA_GDW') ,
       NVL(NAME,'NA_GDW') ,
       NVL(EMAIL,'NA_GDW'	) ,
       NVL(CREDITLIMIT,-99	) ,
       NVL(ADDRESS_LINE1,'NA_GDW') ,
       NVL(ADDRESS_LINE2,'NA_GDW') ,
       NVL(ADDRESS_LINE3,'NA_GDW') ,
       NVL(ZIPCODE,'NA_GDW') ,
       NVL(CITY,'NA_GDW') ,
       NVL(STATE,'NA_GDW') ,
       NVL(COUNTRY,'NA_GDW') ,
       NVL(COMPANYNAME,'NA_GDW') ,
       NVL(CURRENCY,'NA_GDW') ,
       NVL(CURRENCY_ID,-99),
       NVL(ISINACTIVE,'NA_GDW'),
       NVL(CUSTOMER_TYPE,'NA_GDW'),
       NVL(LINE_OF_BUSINESS,'NA_GDW'),
       NVL(LINE_OF_BUSINESS_ID,-99),
       NVL(SUBSIDIARY,'NA_GDW') ,
       NVL(SUBSIDIARY_ID,-99),
       NVL(CUSTOMER_CATEGORY,'NA_GDW'),
       NVL(PAYMENT_TERMS,'NA_GDW') ,
       NVL(PAYMENT_TERM_ID,-99),
       NVL(PARENT,'NA_GDW') ,
       NVL(PARENT_ID,-99),
       NVL(TERRITORY,'NA_GDW') ,
       sysdate,
       '9999-12-31 23:59:59',
       'A'
FROM dw_prestage.customers A
WHERE EXISTS (SELECT 1
              FROM dw_prestage.customers_update
              WHERE a.customer_id = dw_prestage.customers_update.customer_id
              AND   dw_prestage.customers_update.ch_type = 2);

/* dimension -> update records as part of SCD1 maintenance */ 
UPDATE dw.customers
   SET customer_EXTID = NVL(dw_prestage.customers.customer_EXTID,'NA_GDW'),
       LEGACY_CUSTOMER_IDCUSTOM = NVL(dw_prestage.customers.LEGACY_CUSTOMER_IDCUSTOM,'NA_GDW'),
       NAME = NVL(dw_prestage.customers.NAME,'NA_GDW'),
       EMAIL = NVL(dw_prestage.customers.EMAIL,'NA_GDW'),
       CREDITLIMIT = NVL(dw_prestage.customers.CREDITLIMIT,-99),
       ADDRESS_LINE1 = NVL(dw_prestage.customers.ADDRESS_LINE1,'NA_GDW'),
       ADDRESS_LINE2 = NVL(dw_prestage.customers.ADDRESS_LINE2,'NA_GDW'),
       ADDRESS_LINE3 = NVL(dw_prestage.customers.ADDRESS_LINE3,'NA_GDW'),
       ZIPCODE = NVL(dw_prestage.customers.ZIPCODE,'NA_GDW'),
       CITY = NVL(dw_prestage.customers.CITY,'NA_GDW'),
       STATE = NVL(dw_prestage.customers.STATE,'NA_GDW'),
       COUNTRY = NVL(dw_prestage.customers.COUNTRY,'NA_GDW'),
       COMPANYNAME = NVL(dw_prestage.customers.COMPANYNAME,'NA_GDW'),
       ISINACTIVE = NVL(dw_prestage.customers.ISINACTIVE,'NA_GDW')
FROM dw_prestage.customers
WHERE dw.customers.customer_id = dw_prestage.customers.customer_id
AND   EXISTS (SELECT 1
              FROM dw_prestage.customers_update
              WHERE dw_prestage.customers.customer_id = dw_prestage.customers_update.customer_id
              AND   dw_prestage.customers_update.ch_type = 1);

/* dimension -> logically delete dw records */ 
UPDATE dw.customers
   SET DATE_ACTIVE_TO = sysdate -1,
       dw_active = 'I'
FROM dw_prestage.customers_delete
WHERE dw.customers.customer_id = dw_prestage.customers_delete.customer_id;

COMMIT;