/* prestage - drop intermediate insert table */ 
DROP TABLE if exists dw_prestage.book_fair_insert;

/* prestage - create intermediate insert table*/ 
CREATE TABLE dw_prestage.book_fair_insert 
AS
SELECT *
FROM dw_prestage.book_fairs
WHERE EXISTS (SELECT 1
              FROM (SELECT fair_status_id,route_id,marker_id,fair_type_id,invoice_option_id
                    FROM (SELECT fair_status_id,route_id,marker_id,fair_type_id,invoice_option_id
                          FROM dw_prestage.book_fairs
                          MINUS
                          SELECT fair_status_id,route_id,marker_id,fair_type_id,invoice_option_id
                          FROM dw_stage.book_fairs)) a
              WHERE dw_prestage.book_fairs.fair_status_id = a.fair_status_id
               AND  dw_prestage.book_fairs.route_id = a.route_id
               AND  dw_prestage.book_fairs.marker_id = a.marker_id
               AND  dw_prestage.book_fairs.fair_type_id = a.fair_type_id
               AND  dw_prestage.book_fairs.invoice_option_id = a.invoice_option_id);

/* prestage - drop intermediate update table*/ 
DROP TABLE if exists dw_prestage.book_fair_update;

/* prestage - create intermediate update table*/ 
CREATE TABLE dw_prestage.book_fair_update 
AS
SELECT decode(SUM(ch_type),
             3,2,
             SUM(ch_type)
       )  ch_type,
       fair_status_id,
       route_id,
       marker_id,
       fair_type_id,
       invoice_option_id
FROM (SELECT fair_status_id,
             route_id,
             marker_id,
             fair_type_id,
             invoice_option_id,
             CH_TYPE
      FROM (SELECT fair_status_id,
                   route_id,
                   marker_id,
                   fair_type_id,
                   invoice_option_id,
                   '2' CH_TYPE
            FROM dw_prestage.book_fairs
            MINUS
            SELECT fair_status_id,
                   route_id,
                   marker_id,
                   fair_type_id,
                   invoice_option_id,
                   '2' CH_TYPE
            FROM dw_stage.book_fairs)) a
WHERE NOT EXISTS (SELECT 1
                  FROM dw_prestage.book_fair_insert
                  WHERE dw_prestage.book_fair_insert.fair_status_id = a.fair_status_id
                  AND dw_prestage.book_fair_insert.route_id = a.route_id
                  AND dw_prestage.book_fair_insert.marker_id = a.marker_id
                  AND dw_prestage.book_fair_insert.fair_type_id = a.fair_type_id
                  AND dw_prestage.book_fair_insert.invoice_option_id = a.invoice_option_id)
GROUP BY fair_status_id,
         route_id,
         marker_id,
         fair_type_id,
         invoice_option_id;

/* prestage - drop intermediate delete table*/ 
DROP TABLE if exists dw_prestage.book_fair_delete;

/* prestage - create intermediate delete table*/ 
CREATE TABLE dw_prestage.book_fair_delete 
AS
SELECT *
FROM dw_stage.book_fairs
WHERE EXISTS (SELECT 1
              FROM (SELECT fair_status_id,
                           route_id,
                           marker_id,
                           fair_type_id,
                           invoice_option_id
                    FROM (SELECT fair_status_id,
                                 route_id,
                                 marker_id,
                                 fair_type_id,
                                 invoice_option_id
                          FROM dw_stage.book_fairs
                          MINUS
                          SELECT fair_status_id,
                                 route_id,
                                 marker_id,
                                 fair_type_id,
                                 invoice_option_id
                          FROM dw_prestage.book_fairs)) a
              WHERE dw_stage.book_fairs.fair_status_id = a.fair_status_id
              AND dw_stage.book_fairs.route_id = a.route_id
              AND dw_stage.book_fairs.marker_id = a.marker_id
              AND dw_stage.book_fairs.fair_type_id = a.fair_type_id
              AND dw_stage.book_fairs.invoice_option_id = a.invoice_option_id);

/* prestage-> no of prestage book fair records identified to inserted*/ 
SELECT count(1) FROM dw_prestage.book_fair_insert;

/* prestage-> no of prestage book fair  records identified to updated*/ 
SELECT count(1) FROM dw_prestage.book_fair_update;

/* prestage-> no of prestage book fair records identified to deleted*/ 
SELECT count(1) FROM dw_prestage.book_fair_delete;

/* stage -> delete from stage records to be updated */ 
DELETE
FROM dw_stage.book_fairs USING dw_prestage.book_fair_update
WHERE dw_stage.book_fairs.fair_status_id = dw_prestage.book_fair_update.fair_status_id
AND dw_stage.book_fairs.route_id = dw_prestage.book_fair_update.route_id
AND dw_stage.book_fairs.marker_id = dw_prestage.book_fair_update.marker_id
AND dw_stage.book_fairs.fair_type_id = dw_prestage.book_fair_update.fair_type_id
AND dw_stage.book_fairs.invoice_option_id = dw_prestage.book_fair_update.invoice_option_id;

/* stage -> delete from stage records which have been deleted */ 
DELETE
FROM dw_stage.book_fairs USING dw_prestage.book_fair_delete
WHERE dw_stage.book_fairs.fair_status_id = dw_prestage.book_fair_delete.fair_status_id
AND dw_stage.book_fairs.route_id = dw_prestage.book_fair_delete.route_id
AND dw_stage.book_fairs.marker_id = dw_prestage.book_fair_delete.marker_id
AND dw_stage.book_fairs.fair_type_id = dw_prestage.book_fair_delete.fair_type_id
AND dw_stage.book_fairs.invoice_option_id = dw_prestage.book_fair_delete.invoice_option_id;

/* stage -> insert into stage records which have been created */ 
INSERT INTO dw_stage.book_fairs
(
   FAIR_STATUS_ID    
  ,FAIR_STATUS       
  ,ROUTE_ID          
  ,ROUTE             
  ,MARKER_ID         
  ,MARKER            
  ,FAIR_TYPE_ID      
  ,FAIR_TYPE         
  ,INVOICE_OPTION_ID 
  ,INVOICE_OPTION         
)
SELECT FAIR_STATUS_ID    
      ,FAIR_STATUS       
      ,ROUTE_ID          
      ,ROUTE             
      ,MARKER_ID         
      ,MARKER            
      ,FAIR_TYPE_ID      
      ,FAIR_TYPE         
      ,INVOICE_OPTION_ID 
      ,INVOICE_OPTION       
FROM dw_prestage.book_fair_insert;

/* stage -> insert into stage records which have been updated */ 
INSERT INTO dw_stage.book_fairs
(
   FAIR_STATUS_ID    
  ,FAIR_STATUS       
  ,ROUTE_ID          
  ,ROUTE             
  ,MARKER_ID         
  ,MARKER            
  ,FAIR_TYPE_ID      
  ,FAIR_TYPE         
  ,INVOICE_OPTION_ID 
  ,INVOICE_OPTION      
)
SELECT FAIR_STATUS_ID    
      ,FAIR_STATUS       
      ,ROUTE_ID          
      ,ROUTE             
      ,MARKER_ID         
      ,MARKER            
      ,FAIR_TYPE_ID      
      ,FAIR_TYPE         
      ,INVOICE_OPTION_ID 
      ,INVOICE_OPTION      
FROM dw_prestage.book_fairs
WHERE EXISTS (SELECT 1
              FROM dw_prestage.book_fair_update
              WHERE dw_prestage.book_fair_update.fair_status_id = dw_prestage.book_fairs.fair_status_id
              AND dw_prestage.book_fair_update.route_id = dw_prestage.book_fairs.route_id
              AND dw_prestage.book_fair_update.marker_id = dw_prestage.book_fairs.marker_id
              AND dw_prestage.book_fair_update.fair_type_id = dw_prestage.book_fairs.fair_type_id
              AND dw_prestage.book_fair_update.invoice_option_id = dw_prestage.book_fairs.invoice_option_id);

COMMIT;

/* dimension ->insert new records in dim book_fair */ 
INSERT INTO dw.book_fairs
(
  FAIR_STATUS_ID    
  ,FAIR_STATUS       
  ,ROUTE_ID          
  ,ROUTE             
  ,MARKER_ID         
  ,MARKER            
  ,FAIR_TYPE_ID      
  ,FAIR_TYPE         
  ,INVOICE_OPTION_ID 
  ,INVOICE_OPTION    
  ,DATE_ACTIVE_FROM  
  ,DATE_ACTIVE_TO    
  ,DW_ACTIVE          
  )
SELECT NVL(A.FAIR_STATUS_ID,-99)   
      ,NVL(A.FAIR_STATUS,'NA_GDW')       
      ,NVL(A.ROUTE_ID,-99)           
      ,NVL(A.ROUTE,'NA_GDW')               
      ,NVL(A.MARKER_ID,-99)          
      ,NVL(A.MARKER,'NA_GDW')              
      ,NVL(A.FAIR_TYPE_ID,-99)       
      ,NVL(A.FAIR_TYPE,'NA_GDW')           
      ,NVL(A.INVOICE_OPTION_ID,-99) 
      ,NVL(A.INVOICE_OPTION,'NA_GDW')   
      ,sysdate
      ,'9999-12-31 23:59:59'
      ,'A'
FROM dw_prestage.book_fair_insert A;

/* dimension -> update old record as part of SCD2 maintenance*/ 
UPDATE dw.book_fairs
   SET dw_active = 'I',
       DATE_ACTIVE_TO = (sysdate -1)
WHERE dw_active = 'A'
AND   sysdate>= date_active_from
AND   sysdate< date_active_to
AND   EXISTS (SELECT 1
              FROM dw_prestage.book_fair_update
              WHERE dw.book_fairs.fair_status_id = dw_prestage.book_fair_update.fair_status_id
              AND dw.book_fairs.route_id = dw_prestage.book_fair_update.route_id
              AND dw.book_fairs.marker_id = dw_prestage.book_fair_update.marker_id
              AND dw.book_fairs.fair_type_id = dw_prestage.book_fair_update.fair_type_id
              AND dw.book_fairs.invoice_option_id = dw_prestage.book_fair_update.invoice_option_id
              AND   dw_prestage.book_fair_update.ch_type = 2);

/* dimension -> insert the new records as part of SCD2 maintenance*/ 
INSERT INTO dw.book_fairs
(
  FAIR_STATUS_ID    
  ,FAIR_STATUS       
  ,ROUTE_ID          
  ,ROUTE             
  ,MARKER_ID         
  ,MARKER            
  ,FAIR_TYPE_ID      
  ,FAIR_TYPE         
  ,INVOICE_OPTION_ID 
  ,INVOICE_OPTION    
  ,DATE_ACTIVE_FROM  
  ,DATE_ACTIVE_TO    
  ,DW_ACTIVE     
)
SELECT NVL(A.FAIR_STATUS_ID,-99)   
      ,NVL(A.FAIR_STATUS,'NA_GDW')       
      ,NVL(A.ROUTE_ID,-99)           
      ,NVL(A.ROUTE,'NA_GDW')               
      ,NVL(A.MARKER_ID,-99)          
      ,NVL(A.MARKER,'NA_GDW')              
      ,NVL(A.FAIR_TYPE_ID,-99)       
      ,NVL(A.FAIR_TYPE,'NA_GDW')           
      ,NVL(A.INVOICE_OPTION_ID,-99) 
      ,NVL(A.INVOICE_OPTION,'NA_GDW')   
      ,sysdate
      ,'9999-12-31 23:59:59'
      ,'A'
FROM dw_prestage.book_fairs A
WHERE EXISTS (SELECT 1
              FROM dw_prestage.book_fair_update
              WHERE a.fair_status_id = dw_prestage.book_fair_update.fair_status_id
              AND a.route_id = dw_prestage.book_fair_update.route_id
              AND a.marker_id = dw_prestage.book_fair_update.marker_id
              AND a.fair_type_id = dw_prestage.book_fair_update.fair_type_id
              AND a.invoice_option_id = dw_prestage.book_fair_update.invoice_option_id
              AND   dw_prestage.book_fair_update.ch_type = 2);

/* dimension -> logically delete dw records */ 
UPDATE dw.book_fairs
   SET DATE_ACTIVE_TO = sysdate -1,
       dw_active = 'I'
FROM dw_prestage.book_fair_delete
WHERE dw.book_fairs.fair_status_id = dw_prestage.book_fair_delete.fair_status_id
  AND dw.book_fairs.route_id = dw_prestage.book_fair_delete.route_id
  AND dw.book_fairs.marker_id = dw_prestage.book_fair_delete.marker_id
  AND dw.book_fairs.fair_type_id = dw_prestage.book_fair_delete.fair_type_id
  AND dw.book_fairs.invoice_option_id = dw_prestage.book_fair_delete.invoice_option_id;

COMMIT;

