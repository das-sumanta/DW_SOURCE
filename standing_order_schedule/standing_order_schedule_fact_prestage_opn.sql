/* prestage - drop intermediate insert table */
DROP TABLE if exists dw_prestage.standing_order_schedule_fact_insert;

/* prestage - create intermediate insert table*/
CREATE TABLE dw_prestage.standing_order_schedule_fact_insert 
AS
SELECT *
FROM dw_prestage.standing_order_schedule_fact a
WHERE not exists ( select 1 from dw_stage.standing_order_schedule_fact b
where b.standing_order_schedule_id = a.standing_order_schedule_id);

/* prestage - drop intermediate update table*/
DROP TABLE if exists dw_prestage.standing_order_schedule_fact_update;

/* prestage - create intermediate update table*/
CREATE TABLE dw_prestage.standing_order_schedule_fact_update 
AS
SELECT *
FROM dw_prestage.standing_order_schedule_fact a
WHERE
EXISTS
( 
SELECT 1 FROM
(
SELECT
   STANDING_ORDER_SCHEDULE_ID    
  ,ACTUAL_SHIPMENT_DATE          
  ,AMORTIZATION_VALUE_EXCL__GST  
  ,AMORTIZATION_VALUE_INCL__GST  
  ,CUSTOMER_ID                   
  ,DATE_CREATED                  
  ,EXPECTED_SHIPMENT_DATE        
  ,INVOICE_AMOUNT                
  ,INVOICE_NO__ID                
  ,IS_INACTIVE                   
  ,LAST_MODIFIED_DATE            
  ,LEVEL_ID                      
  ,LINE_NO                       
  ,ORDER_TYPE_ID                 
  ,ORDER_TYPE                    
  ,PICK_SLIP_NUMBER              
  ,PRODUCT_CATALOGUE_LIST_ID     
  ,SALES_ORDER_NO__ID            
  ,SCHEDULE_CLOSED               
  ,SHIPMENT_NO_                  
  ,SHIPMENT_YYYYMM               
  ,STO_ITEM_ID                   
  ,STO_NO_TEXT                   
  ,STO_NO__ID                    
  ,SUBSIDIARY_ID
  ,STO_START_DATE
  ,STO_END_DATE                
FROM
 dw_prestage.standing_order_schedule_fact A2
 WHERE NOT EXISTS ( select 1 from dw_prestage.standing_order_schedule_fact_insert B2
where B2.STANDING_ORDER_SCHEDULE_ID = A2.STANDING_ORDER_SCHEDULE_ID)
MINUS
SELECT
   STANDING_ORDER_SCHEDULE_ID    
  ,ACTUAL_SHIPMENT_DATE          
  ,AMORTIZATION_VALUE_EXCL__GST  
  ,AMORTIZATION_VALUE_INCL__GST  
  ,CUSTOMER_ID                   
  ,DATE_CREATED                  
  ,EXPECTED_SHIPMENT_DATE        
  ,INVOICE_AMOUNT                
  ,INVOICE_NO__ID                
  ,IS_INACTIVE                   
  ,LAST_MODIFIED_DATE            
  ,LEVEL_ID                      
  ,LINE_NO                       
  ,ORDER_TYPE_ID                 
  ,ORDER_TYPE                    
  ,PICK_SLIP_NUMBER              
  ,PRODUCT_CATALOGUE_LIST_ID     
  ,SALES_ORDER_NO__ID            
  ,SCHEDULE_CLOSED               
  ,SHIPMENT_NO_                  
  ,SHIPMENT_YYYYMM               
  ,STO_ITEM_ID                   
  ,STO_NO_TEXT                   
  ,STO_NO__ID                    
  ,SUBSIDIARY_ID  
  ,STO_START_DATE
  ,STO_END_DATE                  
FROM
 dw_stage.standing_order_schedule_fact a1
WHERE EXISTS ( select 1 from dw_prestage.standing_order_schedule_fact b1
where b1.STANDING_ORDER_SCHEDULE_ID = a1.STANDING_ORDER_SCHEDULE_ID)
AND NOT EXISTS ( select 1 from dw_prestage.standing_order_schedule_fact_insert c1
where c1.STANDING_ORDER_SCHEDULE_ID = a1.STANDING_ORDER_SCHEDULE_ID)
) b
where b.STANDING_ORDER_SCHEDULE_ID = a.STANDING_ORDER_SCHEDULE_ID) ;    

/* prestage - drop intermediate no change track table*/
DROP TABLE if exists dw_prestage.standing_order_schedule_fact_nochange;

/* prestage - create intermediate no change track table*/
CREATE TABLE dw_prestage.standing_order_schedule_fact_nochange 
AS
SELECT STANDING_ORDER_SCHEDULE_ID
FROM (SELECT STANDING_ORDER_SCHEDULE_ID
      FROM dw_prestage.standing_order_schedule_fact
      MINUS
      (SELECT STANDING_ORDER_SCHEDULE_ID
      FROM dw_prestage.standing_order_schedule_fact_insert
      UNION ALL
      SELECT STANDING_ORDER_SCHEDULE_ID
      FROM dw_prestage.standing_order_schedule_fact_update));

/* prestage-> no of standing_order_schedule fact records ingested in staging */
SELECT count(1) FROM dw_prestage.standing_order_schedule_fact;

/* prestage-> no of standing_order_schedule fact records identified to inserted  */
SELECT count(1) FROM dw_prestage.standing_order_schedule_fact_insert;

/* prestage-> no of standing_order_schedule fact records identified to updated */
SELECT count(1) FROM dw_prestage.standing_order_schedule_fact_update;

/* prestage-> no of standing_order_schedule fact records identified as no change */
SELECT count(1) FROM dw_prestage.standing_order_schedule_fact_nochange;

--D --A = B + C + D
/* stage -> delete from stage records to be updated */ 
DELETE
FROM dw_stage.standing_order_schedule_fact USING dw_prestage.standing_order_schedule_fact_update
WHERE dw_stage.standing_order_schedule_fact.STANDING_ORDER_SCHEDULE_ID = dw_prestage.standing_order_schedule_fact_update.STANDING_ORDER_SCHEDULE_ID;

/* stage -> insert into stage records which have been created */ 
INSERT INTO dw_stage.standing_order_schedule_fact
SELECT *
FROM dw_prestage.standing_order_schedule_fact_insert;

/* stage -> insert into stage records which have been updated */ 
INSERT INTO dw_stage.standing_order_schedule_fact
SELECT *
FROM dw_prestage.standing_order_schedule_fact
WHERE EXISTS (SELECT 1
              FROM dw_prestage.standing_order_schedule_fact_update
              WHERE dw_prestage.standing_order_schedule_fact_update.STANDING_ORDER_SCHEDULE_ID = dw_prestage.standing_order_schedule_fact.STANDING_ORDER_SCHEDULE_ID);

/* fact -> INSERT NEW RECORDS WHICH HAS ALL VALID DIMENSIONS */ 
INSERT INTO dw.standing_order_schedule_fact
(
  STANDING_ORDER_SCHEDULE_ID    
 ,ACTUAL_SHIPMENT_DATE_KEY      
 ,AMORTIZATION_VALUE_EXCL_GST   
 ,AMORTIZATION_VALUE_INCL_GST   
 ,CUSTOMER_KEY                  
 ,EXPECTED_SHIPMENT_DATE_KEY    
 ,INVOICE_AMOUNT                
 ,INVOICE_NO_ID                 
 ,IS_INACTIVE                   
 ,LINE_NO                       
 ,ORDER_TYPE                    
 ,PICK_SLIP_NUMBER              
 ,PRODUCT_CATALOGUE_KEY         
 ,SALES_ORDER_NO_ID             
 ,SCHEDULE_CLOSED               
 ,SHIPMENT_NO                 
 ,SHIPMENT_YYYYMM               
 ,STO_ITEM_KEY                  
 ,STO_NO_TEXT                   
 ,STO_NO_ID                     
 ,SUBSIDIARY_KEY
 ,STO_START_DATE_KEY
 ,STO_END_DATE_KEY
 ,LEVEL_KEY                   
 ,DATE_ACTIVE_FROM
 ,DATE_ACTIVE_TO
 ,DW_CURRENT
)
SELECT STANDING_ORDER_SCHEDULE_ID    
      ,B.DATE_KEY ACTUAL_SHIPMENT_DATE_KEY      
      ,AMORTIZATION_VALUE_EXCL__GST   
      ,AMORTIZATION_VALUE_INCL__GST   
      ,D.CUSTOMER_KEY                  
      ,C.DATE_KEY EXPECTED_SHIPMENT_DATE_KEY    
      ,INVOICE_AMOUNT                
      ,INVOICE_NO__ID                 
      ,NVL(A.IS_INACTIVE,'NA_GDW')                   
      ,LINE_NO                       
      ,ORDER_TYPE                    
      ,PICK_SLIP_NUMBER              
      ,E.PRODUCT_CATALOGUE_KEY         
      ,SALES_ORDER_NO__ID             
      ,SCHEDULE_CLOSED               
      ,SHIPMENT_NO_                  
      ,SHIPMENT_YYYYMM               
      ,F.ITEM_KEY AS STO_ITEM_KEY                  
      ,STO_NO_TEXT                   
      ,STO_NO__ID                     
      ,G.SUBSIDIARY_KEY
      ,H.DATE_KEY STO_START_DATE_KEY
      ,I.DATE_KEY STO_END_DATE_KEY 
      ,J.ITEM_KEY LEVEL_KEY    
      ,SYSDATE AS DATE_ACTIVE_FROM
      ,'9999-12-31 11:59:59' AS DATE_ACTIVE_TO
      ,1 AS DW_CURRENT
FROM dw_prestage.standing_order_schedule_fact_insert A 
    INNER JOIN DW.DWDATE B ON (NVL(TO_CHAR (A.ACTUAL_SHIPMENT_DATE,'YYYYMMDD'),'19000101') = B.DATE_ID)
    INNER JOIN DW.DWDATE C ON (NVL(TO_CHAR (A.EXPECTED_SHIPMENT_DATE,'YYYYMMDD'),'19000101') = C.DATE_ID) 
    INNER JOIN DW_REPORT.CUSTOMERS D ON (NVL (A.CUSTOMER_ID,-99) = D.CUSTOMER_ID)
    INNER JOIN DW_REPORT.PRODUCT_CATALOGUE E ON (NVL (A.PRODUCT_CATALOGUE_LIST_ID,-99) = E.PRODUCT_CATALOGUE_ID)
    INNER JOIN DW_REPORT.ITEMS F ON (NVL (A.STO_ITEM_ID,-99) = F.ITEM_ID) 
    INNER JOIN DW_REPORT.SUBSIDIARIES G ON (NVL (A.SUBSIDIARY_ID,-99) = G.SUBSIDIARY_ID)
    INNER JOIN DW.DWDATE H ON (NVL(TO_CHAR (A.STO_START_DATE,'YYYYMMDD'),'19000101') = H.DATE_ID) 
    INNER JOIN DW.DWDATE I ON (NVL(TO_CHAR (A.STO_END_DATE,'YYYYMMDD'),'19000101') = I.DATE_ID)
    INNER JOIN DW_REPORT.ITEMS J ON (NVL (A.LEVEL_ID,-99) = J.ITEM_ID)  ;
  
/* fact -> INSERT NEW RECORDS IN ERROR TABLE WHICH DOES NOT HAVE VALID DIMENSIONS */ 
INSERT INTO dw.standing_order_schedule_fact_error
(
  RUNID                              
 ,STANDING_ORDER_SCHEDULE_ID        
 ,ACTUAL_SHIPMENT_DATE              
 ,ACTUAL_SHIPMENT_DATE_KEY          
 ,ACTUAL_SHIPMENT_DATE_ERROR        
 ,AMORTIZATION_VALUE_EXCL_GST       
 ,AMORTIZATION_VALUE_INCL_GST       
 ,CUSTOMER_ID                       
 ,CUSTOMER_KEY                      
 ,CUSTOMER_ID_ERROR                 
 ,EXPECTED_SHIPMENT_DATE            
 ,EXPECTED_SHIPMENT_DATE_KEY        
 ,EXPECTED_SHIPMENT_DATE_ERROR      
 ,INVOICE_AMOUNT                    
 ,INVOICE_NO_ID                     
 ,IS_INACTIVE                       
 ,LINE_NO                           
 ,ORDER_TYPE                        
 ,PICK_SLIP_NUMBER                  
 ,PRODUCT_CATALOGUE_ID              
 ,PRODUCT_CATALOGUE_KEY             
 ,PRODUCT_CATALOGUE_ID_ERROR        
 ,SALES_ORDER_NO_ID                 
 ,SCHEDULE_CLOSED                   
 ,SHIPMENT_NO                       
 ,SHIPMENT_YYYYMM                   
 ,STO_ITEM_ID                       
 ,STO_ITEM_KEY                      
 ,STO_ITEM_ID_ERROR                 
 ,STO_NO_TEXT                       
 ,STO_NO_ID                         
 ,SUBSIDIARY_ID                     
 ,SUBSIDIARY_KEY                    
 ,SUBSIDIARY_ID_ERROR 
 ,STO_START_DATE       
 ,STO_START_DATE_KEY   
 ,STO_START_DATE_ERROR
 ,STO_END_DATE       
 ,STO_END_DATE_KEY   
 ,STO_END_DATE_ERROR
 ,LEVEL_ID       
 ,LEVEL_KEY      
 ,LEVEL_ID_ERROR                        
 ,RECORD_STATUS        
 ,DW_CREATION_DATE     
)
SELECT A.RUNID
      ,A.STANDING_ORDER_SCHEDULE_ID
      ,A.ACTUAL_SHIPMENT_DATE  
      ,B.DATE_KEY ACTUAL_SHIPMENT_DATE_KEY  
      ,CASE
         WHEN (B.DATE_KEY IS NULL AND A.ACTUAL_SHIPMENT_DATE  IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (B.DATE_KEY IS NULL AND A.ACTUAL_SHIPMENT_DATE IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END ACTUAL_SHIPMENT_DATE_ERROR
      ,A.AMORTIZATION_VALUE_EXCL__GST       
      ,A.AMORTIZATION_VALUE_INCL__GST   
       ,A.CUSTOMER_ID                       
       ,D.CUSTOMER_KEY    
       ,CASE
         WHEN (D.CUSTOMER_KEY  IS NULL AND A.CUSTOMER_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (D.CUSTOMER_KEY  IS NULL AND A.CUSTOMER_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END CUSTOMER_ID_ERROR
      ,A.EXPECTED_SHIPMENT_DATE  
      ,C.DATE_KEY EXPECTED_SHIPMENT_DATE_KEY  
      ,CASE
         WHEN (C.DATE_KEY IS NULL AND A.EXPECTED_SHIPMENT_DATE  IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (C.DATE_KEY IS NULL AND A.EXPECTED_SHIPMENT_DATE IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END EXPECTED_SHIPMENT_DATE_ERROR
       ,A.INVOICE_AMOUNT                    
       ,A.INVOICE_NO__ID                     
       ,A.IS_INACTIVE                       
       ,A.LINE_NO                           
       ,A.ORDER_TYPE                        
       ,A.PICK_SLIP_NUMBER
       ,A.PRODUCT_CATALOGUE_LIST_ID          
       ,E.PRODUCT_CATALOGUE_KEY 
       ,CASE
         WHEN (E.PRODUCT_CATALOGUE_KEY IS NULL AND A.PRODUCT_CATALOGUE_LIST_ID  IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (E.PRODUCT_CATALOGUE_KEY IS NULL AND A.PRODUCT_CATALOGUE_LIST_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END PRODUCT_CATALOGUE_ID_ERROR
      ,A.SALES_ORDER_NO__ID                 
      ,A.SCHEDULE_CLOSED                   
      ,A.SHIPMENT_NO_                       
      ,A.SHIPMENT_YYYYMM
      ,A.STO_ITEM_ID                       
      ,F.ITEM_KEY STO_ITEM_KEY       
      ,CASE
         WHEN (F.ITEM_KEY  IS NULL AND A.STO_ITEM_ID  IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (F.ITEM_KEY  IS NULL AND A.STO_ITEM_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END STO_ITEM_ID_ERROR 
        ,A.STO_NO_TEXT                       
       ,A.STO_NO__ID                         
       ,A.SUBSIDIARY_ID                     
       ,G.SUBSIDIARY_KEY     
       ,CASE
         WHEN (G.SUBSIDIARY_KEY  IS NULL AND A.SUBSIDIARY_ID   IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (G.SUBSIDIARY_KEY  IS NULL AND A.SUBSIDIARY_ID  IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END SUBSIDIARY_ID_ERROR 
      ,STO_START_DATE       
      ,H.DATE_KEY STO_START_DATE_KEY   
      ,CASE
         WHEN (H.DATE_KEY IS NULL AND A.STO_START_DATE  IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (H.DATE_KEY IS NULL AND A.STO_START_DATE IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END STO_START_DATE_ERROR
      ,STO_END_DATE       
      ,I.DATE_KEY STO_END_DATE_KEY   
      ,CASE
         WHEN (I.DATE_KEY IS NULL AND A.STO_END_DATE  IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (I.DATE_KEY IS NULL AND A.STO_END_DATE IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END STO_END_DATE_ERROR
      ,LEVEL_ID
      ,J.ITEM_KEY LEVEL_KEY
      ,CASE
         WHEN (J.ITEM_KEY  IS NULL AND A.LEVEL_ID  IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (J.ITEM_KEY  IS NULL AND A.LEVEL_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END LEVEL_ID_ERROR         
      ,'ERROR' AS RECORD_STATUS
      ,SYSDATE AS DW_CREATION_DATE	   
FROM dw_prestage.standing_order_schedule_fact_insert A
    LEFT OUTER JOIN DW.DWDATE B ON (TO_CHAR (A.ACTUAL_SHIPMENT_DATE,'YYYYMMDD') = B.DATE_ID)
    LEFT OUTER JOIN DW.DWDATE C ON (TO_CHAR (A.EXPECTED_SHIPMENT_DATE,'YYYYMMDD') = C.DATE_ID) 
    LEFT OUTER JOIN DW_REPORT.CUSTOMERS D ON (A.CUSTOMER_ID = D.CUSTOMER_ID)
    LEFT OUTER JOIN DW_REPORT.PRODUCT_CATALOGUE E ON (A.PRODUCT_CATALOGUE_LIST_ID = E.PRODUCT_CATALOGUE_ID)
    LEFT OUTER JOIN DW_REPORT.ITEMS F ON (A.STO_ITEM_ID = F.ITEM_ID) 
    LEFT OUTER JOIN DW_REPORT.SUBSIDIARIES G ON (A.SUBSIDIARY_ID = G.SUBSIDIARY_ID)
    LEFT OUTER JOIN DW.DWDATE H ON (TO_CHAR (A.STO_START_DATE,'YYYYMMDD') = H.DATE_ID) 
    LEFT OUTER JOIN DW.DWDATE I ON (TO_CHAR (A.STO_END_DATE,'YYYYMMDD') = I.DATE_ID) 
    LEFT OUTER JOIN DW_REPORT.ITEMS J ON (A.LEVEL_ID = J.ITEM_ID) 
  WHERE 
  ((B.DATE_KEY IS NULL AND A.ACTUAL_SHIPMENT_DATE IS NOT NULL ) OR
  (D.CUSTOMER_KEY IS NULL AND A.CUSTOMER_ID IS NOT NULL ) OR
  (C.DATE_KEY IS NULL AND A.EXPECTED_SHIPMENT_DATE IS NOT NULL ) OR
  (E.PRODUCT_CATALOGUE_KEY IS NULL AND A.PRODUCT_CATALOGUE_LIST_ID IS NOT NULL ) OR
  (G.SUBSIDIARY_KEY IS NULL AND A.SUBSIDIARY_ID IS NOT NULL ) OR
  (F.ITEM_KEY IS NULL AND A.STO_ITEM_ID IS NOT NULL ) OR
  (H.DATE_KEY IS NULL AND A.STO_START_DATE IS NOT NULL ) OR
  (I.DATE_KEY IS NULL AND A.STO_END_DATE IS NOT NULL ) OR
  (J.ITEM_KEY IS NULL AND A.LEVEL_ID IS NOT NULL ) );

/* fact -> UPDATE THE OLD RECORDS SETTING THE CURRENT FLAG VALUE TO 0 */  
UPDATE dw.standing_order_schedule_fact SET dw_current = 0,DATE_ACTIVE_TO = (sysdate -1) WHERE dw_current = 1
AND   sysdate>= date_active_from
AND   sysdate< date_active_to
AND   EXISTS (SELECT 1 FROM dw_prestage.standing_order_schedule_fact_update 
WHERE dw.standing_order_schedule_fact.STANDING_ORDER_SCHEDULE_ID = dw_prestage.standing_order_schedule_fact_update.STANDING_ORDER_SCHEDULE_ID);

/* fact -> NOW INSERT THE FACT RECORDS WHICH HAVE BEEN UPDATED AT THE SOURCE */ 
INSERT INTO dw.standing_order_schedule_fact
(
  STANDING_ORDER_SCHEDULE_ID    
 ,ACTUAL_SHIPMENT_DATE_KEY      
 ,AMORTIZATION_VALUE_EXCL_GST   
 ,AMORTIZATION_VALUE_INCL_GST   
 ,CUSTOMER_KEY                  
 ,EXPECTED_SHIPMENT_DATE_KEY    
 ,INVOICE_AMOUNT                
 ,INVOICE_NO_ID                 
 ,IS_INACTIVE                   
 ,LINE_NO                       
 ,ORDER_TYPE                    
 ,PICK_SLIP_NUMBER              
 ,PRODUCT_CATALOGUE_KEY         
 ,SALES_ORDER_NO_ID             
 ,SCHEDULE_CLOSED               
 ,SHIPMENT_NO                 
 ,SHIPMENT_YYYYMM               
 ,STO_ITEM_KEY                  
 ,STO_NO_TEXT                   
 ,STO_NO_ID                     
 ,SUBSIDIARY_KEY
 ,STO_START_DATE_KEY
 ,STO_END_DATE_KEY
 ,LEVEL_KEY                   
 ,DATE_ACTIVE_FROM
 ,DATE_ACTIVE_TO
 ,DW_CURRENT
)
SELECT STANDING_ORDER_SCHEDULE_ID    
      ,B.DATE_KEY ACTUAL_SHIPMENT_DATE_KEY      
      ,AMORTIZATION_VALUE_EXCL__GST   
      ,AMORTIZATION_VALUE_INCL__GST   
      ,D.CUSTOMER_KEY                  
      ,C.DATE_KEY EXPECTED_SHIPMENT_DATE_KEY    
      ,INVOICE_AMOUNT                
      ,INVOICE_NO__ID                 
      ,NVL(A.IS_INACTIVE,'NA_GDW')                   
      ,LINE_NO                       
      ,ORDER_TYPE                    
      ,PICK_SLIP_NUMBER              
      ,E.PRODUCT_CATALOGUE_KEY         
      ,SALES_ORDER_NO__ID             
      ,SCHEDULE_CLOSED               
      ,SHIPMENT_NO_                  
      ,SHIPMENT_YYYYMM               
      ,F.ITEM_KEY AS STO_ITEM_KEY                  
      ,STO_NO_TEXT                   
      ,STO_NO__ID                     
      ,G.SUBSIDIARY_KEY
      ,H.DATE_KEY STO_START_DATE_KEY
      ,I.DATE_KEY STO_END_DATE_KEY 
      ,J.ITEM_KEY LEVEL_KEY    
      ,SYSDATE AS DATE_ACTIVE_FROM
      ,'9999-12-31 11:59:59' AS DATE_ACTIVE_TO
      ,1 AS DW_CURRENT
FROM dw_prestage.standing_order_schedule_fact_update A 
    INNER JOIN DW.DWDATE B ON (NVL(TO_CHAR (A.ACTUAL_SHIPMENT_DATE,'YYYYMMDD'),'19000101') = B.DATE_ID)
    INNER JOIN DW.DWDATE C ON (NVL(TO_CHAR (A.EXPECTED_SHIPMENT_DATE,'YYYYMMDD'),'19000101') = C.DATE_ID) 
    INNER JOIN DW_REPORT.CUSTOMERS D ON (NVL (A.CUSTOMER_ID,-99) = D.CUSTOMER_ID)
    INNER JOIN DW_REPORT.PRODUCT_CATALOGUE E ON (NVL (A.PRODUCT_CATALOGUE_LIST_ID,-99) = E.PRODUCT_CATALOGUE_ID)
    INNER JOIN DW_REPORT.ITEMS F ON (NVL (A.STO_ITEM_ID,-99) = F.ITEM_ID) 
    INNER JOIN DW_REPORT.SUBSIDIARIES G ON (NVL (A.SUBSIDIARY_ID,-99) = G.SUBSIDIARY_ID)
    INNER JOIN DW.DWDATE H ON (NVL(TO_CHAR (A.STO_START_DATE,'YYYYMMDD'),'19000101') = H.DATE_ID) 
    INNER JOIN DW.DWDATE I ON (NVL(TO_CHAR (A.STO_END_DATE,'YYYYMMDD'),'19000101') = I.DATE_ID)
    INNER JOIN DW_REPORT.ITEMS J ON (NVL (A.LEVEL_ID,-99) = J.ITEM_ID) ;

/* fact -> INSERT UPDATED RECORDS IN ERROR TABLE WHICH DOES NOT HAVE VALID DIMENSIONS */ 
INSERT INTO dw.standing_order_schedule_fact_error
(
  RUNID                              
 ,STANDING_ORDER_SCHEDULE_ID        
 ,ACTUAL_SHIPMENT_DATE              
 ,ACTUAL_SHIPMENT_DATE_KEY          
 ,ACTUAL_SHIPMENT_DATE_ERROR        
 ,AMORTIZATION_VALUE_EXCL_GST       
 ,AMORTIZATION_VALUE_INCL_GST       
 ,CUSTOMER_ID                       
 ,CUSTOMER_KEY                      
 ,CUSTOMER_ID_ERROR                 
 ,EXPECTED_SHIPMENT_DATE            
 ,EXPECTED_SHIPMENT_DATE_KEY        
 ,EXPECTED_SHIPMENT_DATE_ERROR      
 ,INVOICE_AMOUNT                    
 ,INVOICE_NO_ID                     
 ,IS_INACTIVE                       
 ,LINE_NO                           
 ,ORDER_TYPE                        
 ,PICK_SLIP_NUMBER                  
 ,PRODUCT_CATALOGUE_ID              
 ,PRODUCT_CATALOGUE_KEY             
 ,PRODUCT_CATALOGUE_ID_ERROR        
 ,SALES_ORDER_NO_ID                 
 ,SCHEDULE_CLOSED                   
 ,SHIPMENT_NO                       
 ,SHIPMENT_YYYYMM                   
 ,STO_ITEM_ID                       
 ,STO_ITEM_KEY                      
 ,STO_ITEM_ID_ERROR                 
 ,STO_NO_TEXT                       
 ,STO_NO_ID                         
 ,SUBSIDIARY_ID                     
 ,SUBSIDIARY_KEY                    
 ,SUBSIDIARY_ID_ERROR 
 ,STO_START_DATE       
 ,STO_START_DATE_KEY   
 ,STO_START_DATE_ERROR
 ,STO_END_DATE       
 ,STO_END_DATE_KEY   
 ,STO_END_DATE_ERROR
 ,LEVEL_ID       
 ,LEVEL_KEY      
 ,LEVEL_ID_ERROR                        
 ,RECORD_STATUS        
 ,DW_CREATION_DATE     
)
SELECT A.RUNID
      ,A.STANDING_ORDER_SCHEDULE_ID
      ,A.ACTUAL_SHIPMENT_DATE  
      ,B.DATE_KEY ACTUAL_SHIPMENT_DATE_KEY  
      ,CASE
         WHEN (B.DATE_KEY IS NULL AND A.ACTUAL_SHIPMENT_DATE  IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (B.DATE_KEY IS NULL AND A.ACTUAL_SHIPMENT_DATE IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END ACTUAL_SHIPMENT_DATE_ERROR
      ,A.AMORTIZATION_VALUE_EXCL__GST       
      ,A.AMORTIZATION_VALUE_INCL__GST   
       ,A.CUSTOMER_ID                       
       ,D.CUSTOMER_KEY    
       ,CASE
         WHEN (D.CUSTOMER_KEY  IS NULL AND A.CUSTOMER_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (D.CUSTOMER_KEY  IS NULL AND A.CUSTOMER_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END CUSTOMER_ID_ERROR
      ,A.EXPECTED_SHIPMENT_DATE  
      ,C.DATE_KEY EXPECTED_SHIPMENT_DATE_KEY  
      ,CASE
         WHEN (C.DATE_KEY IS NULL AND A.EXPECTED_SHIPMENT_DATE  IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (C.DATE_KEY IS NULL AND A.EXPECTED_SHIPMENT_DATE IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END EXPECTED_SHIPMENT_DATE_ERROR
       ,A.INVOICE_AMOUNT                    
       ,A.INVOICE_NO__ID                     
       ,A.IS_INACTIVE                       
       ,A.LINE_NO                           
       ,A.ORDER_TYPE                        
       ,A.PICK_SLIP_NUMBER
       ,A.PRODUCT_CATALOGUE_LIST_ID          
       ,E.PRODUCT_CATALOGUE_KEY 
       ,CASE
         WHEN (E.PRODUCT_CATALOGUE_KEY IS NULL AND A.PRODUCT_CATALOGUE_LIST_ID  IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (E.PRODUCT_CATALOGUE_KEY IS NULL AND A.PRODUCT_CATALOGUE_LIST_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END PRODUCT_CATALOGUE_ID_ERROR
      ,A.SALES_ORDER_NO__ID                 
      ,A.SCHEDULE_CLOSED                   
      ,A.SHIPMENT_NO_                       
      ,A.SHIPMENT_YYYYMM
      ,A.STO_ITEM_ID                       
      ,F.ITEM_KEY STO_ITEM_KEY       
      ,CASE
         WHEN (F.ITEM_KEY  IS NULL AND A.STO_ITEM_ID  IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (F.ITEM_KEY  IS NULL AND A.STO_ITEM_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END STO_ITEM_ID_ERROR 
        ,A.STO_NO_TEXT                       
       ,A.STO_NO__ID                         
       ,A.SUBSIDIARY_ID                     
       ,G.SUBSIDIARY_KEY     
       ,CASE
         WHEN (G.SUBSIDIARY_KEY  IS NULL AND A.SUBSIDIARY_ID   IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (G.SUBSIDIARY_KEY  IS NULL AND A.SUBSIDIARY_ID  IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END SUBSIDIARY_ID_ERROR 
      ,STO_START_DATE       
      ,H.DATE_KEY STO_START_DATE_KEY   
      ,CASE
         WHEN (H.DATE_KEY IS NULL AND A.STO_START_DATE  IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (H.DATE_KEY IS NULL AND A.STO_START_DATE IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END STO_START_DATE_ERROR
      ,STO_END_DATE       
      ,I.DATE_KEY STO_END_DATE_KEY   
      ,CASE
         WHEN (I.DATE_KEY IS NULL AND A.STO_END_DATE  IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (I.DATE_KEY IS NULL AND A.STO_END_DATE IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END STO_END_DATE_ERROR
      ,LEVEL_ID
      ,J.ITEM_KEY LEVEL_KEY
      ,CASE
         WHEN (J.ITEM_KEY  IS NULL AND A.LEVEL_ID  IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (J.ITEM_KEY  IS NULL AND A.LEVEL_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END LEVEL_ID_ERROR         
      ,'ERROR' AS RECORD_STATUS
      ,SYSDATE AS DW_CREATION_DATE	   
FROM dw_prestage.standing_order_schedule_fact_update A
    LEFT OUTER JOIN DW.DWDATE B ON (TO_CHAR (A.ACTUAL_SHIPMENT_DATE,'YYYYMMDD') = B.DATE_ID)
    LEFT OUTER JOIN DW.DWDATE C ON (TO_CHAR (A.EXPECTED_SHIPMENT_DATE,'YYYYMMDD') = C.DATE_ID) 
    LEFT OUTER JOIN DW_REPORT.CUSTOMERS D ON (A.CUSTOMER_ID = D.CUSTOMER_ID)
    LEFT OUTER JOIN DW_REPORT.PRODUCT_CATALOGUE E ON (A.PRODUCT_CATALOGUE_LIST_ID = E.PRODUCT_CATALOGUE_ID)
    LEFT OUTER JOIN DW_REPORT.ITEMS F ON (A.STO_ITEM_ID = F.ITEM_ID) 
    LEFT OUTER JOIN DW_REPORT.SUBSIDIARIES G ON (A.SUBSIDIARY_ID = G.SUBSIDIARY_ID)
    LEFT OUTER JOIN DW.DWDATE H ON (TO_CHAR (A.STO_START_DATE,'YYYYMMDD') = H.DATE_ID) 
    LEFT OUTER JOIN DW.DWDATE I ON (TO_CHAR (A.STO_END_DATE,'YYYYMMDD') = I.DATE_ID) 
    LEFT OUTER JOIN DW_REPORT.ITEMS J ON (A.LEVEL_ID = J.ITEM_ID) 
  WHERE 
  ((B.DATE_KEY IS NULL AND A.ACTUAL_SHIPMENT_DATE IS NOT NULL ) OR
  (D.CUSTOMER_KEY IS NULL AND A.CUSTOMER_ID IS NOT NULL ) OR
  (C.DATE_KEY IS NULL AND A.EXPECTED_SHIPMENT_DATE IS NOT NULL ) OR
  (E.PRODUCT_CATALOGUE_KEY IS NULL AND A.PRODUCT_CATALOGUE_LIST_ID IS NOT NULL ) OR
  (G.SUBSIDIARY_KEY IS NULL AND A.SUBSIDIARY_ID IS NOT NULL ) OR
  (F.ITEM_KEY IS NULL AND A.STO_ITEM_ID IS NOT NULL ) OR
  (H.DATE_KEY IS NULL AND A.STO_START_DATE IS NOT NULL ) OR
  (I.DATE_KEY IS NULL AND A.STO_END_DATE IS NOT NULL ) OR
  (J.ITEM_KEY IS NULL AND A.LEVEL_ID IS NOT NULL ) );
