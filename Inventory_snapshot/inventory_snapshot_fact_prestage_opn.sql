/* prestage - drop intermediate insert table */
DROP TABLE if exists dw_prestage.inventory_snapshot_fact_insert;

/* prestage - create intermediate insert table*/
CREATE TABLE dw_prestage.inventory_snapshot_fact_insert 
AS
SELECT *
FROM dw_prestage.inventory_snapshot_fact a
WHERE not exists ( select 1 from dw_stage.inventory_snapshot_fact b
where b.subsidiary_id = a.subsidiary_id
and b.location_id = a.location_id
and b.item_id = a.item_id);

/* prestage - drop intermediate update table*/
DROP TABLE if exists dw_prestage.inventory_snapshot_fact_update;

/* prestage - create intermediate update table*/
CREATE TABLE dw_prestage.inventory_snapshot_fact_update 
AS
SELECT *
FROM dw_prestage.inventory_snapshot_fact a
WHERE
EXISTS
( 
SELECT 1 FROM
(
SELECT
    SUBSIDIARY_ID  
   ,LOCATION_ID    
   ,ITEM_ID        
   ,AVG_COST       
   ,QTY_AVAILABLE  
   ,QTY_ON_HAND    
   ,QTY_ON_ORDER   
   ,QTY_BACKORDERED            
FROM
 dw_prestage.inventory_snapshot_fact A2
 WHERE NOT EXISTS ( select 1 from dw_prestage.inventory_snapshot_fact_insert B2
where B2.subsidiary_ID = A2.subsidiary_ID
and B2.location_ID = A2.location_ID
and B2.item_ID = A2.item_ID)
MINUS
SELECT
    SUBSIDIARY_ID  
   ,LOCATION_ID    
   ,ITEM_ID        
   ,AVG_COST       
   ,QTY_AVAILABLE  
   ,QTY_ON_HAND    
   ,QTY_ON_ORDER   
   ,QTY_BACKORDERED              
FROM
 dw_stage.inventory_snapshot_fact a1
WHERE EXISTS ( select 1 from dw_prestage.inventory_snapshot_fact b1
where b1.subsidiary_ID = a1.subsidiary_ID
and b1.location_ID = a1.location_ID
and b1.item_ID = a1.item_ID)
AND NOT EXISTS ( select 1 from dw_prestage.inventory_snapshot_fact_insert c1
where c1.subsidiary_ID = a1.subsidiary_ID
and c1.location_ID = a1.location_ID
and c1.item_ID = a1.item_ID)
) b
where b.subsidiary_ID = a.subsidiary_ID
and b.location_ID = a.location_ID
and b.item_ID = a.item_ID) ;    

/* prestage - drop intermediate no change track table*/
DROP TABLE if exists dw_prestage.inventory_snapshot_fact_nochange;

/* prestage - create intermediate no change track table*/
CREATE TABLE dw_prestage.inventory_snapshot_fact_nochange 
AS
SELECT SUBSIDIARY_ID  
      ,LOCATION_ID    
      ,ITEM_ID  
FROM (SELECT 
      SUBSIDIARY_ID  
      ,LOCATION_ID    
      ,ITEM_ID
      FROM dw_prestage.inventory_snapshot_fact
      MINUS
      (SELECT 
      SUBSIDIARY_ID  
      ,LOCATION_ID    
      ,ITEM_ID
      FROM dw_prestage.inventory_snapshot_fact_insert
      UNION ALL
      SELECT 
      SUBSIDIARY_ID  
      ,LOCATION_ID    
      ,ITEM_ID
      FROM dw_prestage.inventory_snapshot_fact_update));

/* prestage-> no of inventory_snapshot fact records ingested in staging */
SELECT count(1) FROM dw_prestage.inventory_snapshot_fact;

/* prestage-> no of inventory_snapshot fact records identified to inserted  */
SELECT count(1) FROM dw_prestage.inventory_snapshot_fact_insert;

/* prestage-> no of inventory_snapshot fact records identified to updated */
SELECT count(1) FROM dw_prestage.inventory_snapshot_fact_update;

/* prestage-> no of inventory_snapshot fact records identified as no change */
SELECT count(1) FROM dw_prestage.inventory_snapshot_fact_nochange;

--D --A = B + C + D
/* stage -> delete from stage records to be updated */ 
DELETE
FROM dw_stage.inventory_snapshot_fact USING dw_prestage.inventory_snapshot_fact_update
WHERE dw_stage.inventory_snapshot_fact.subsidiary_ID = dw_prestage.inventory_snapshot_fact_update.subsidiary_ID
and dw_stage.inventory_snapshot_fact.location_ID = dw_prestage.inventory_snapshot_fact_update.location_ID
and dw_stage.inventory_snapshot_fact.item_ID = dw_prestage.inventory_snapshot_fact_update.item_ID;

/* stage -> insert into stage records which have been created */ 
INSERT INTO dw_stage.inventory_snapshot_fact
SELECT *
FROM dw_prestage.inventory_snapshot_fact_insert;

/* stage -> insert into stage records which have been updated */ 
INSERT INTO dw_stage.inventory_snapshot_fact
SELECT *
FROM dw_prestage.inventory_snapshot_fact
WHERE EXISTS (SELECT 1
              FROM dw_prestage.inventory_snapshot_fact_update
              WHERE dw_prestage.inventory_snapshot_fact_update.subsidiary_ID = dw_prestage.inventory_snapshot_fact.subsidiary_ID
              and dw_prestage.inventory_snapshot_fact_update.location_ID = dw_prestage.inventory_snapshot_fact.location_ID
              and dw_prestage.inventory_snapshot_fact_update.item_ID = dw_prestage.inventory_snapshot_fact.item_ID);

/* fact -> INSERT NEW RECORDS WHICH HAS ALL VALID DIMENSIONS */ 
INSERT INTO dw.inventory_snapshot_fact
(
   SUBSIDIARY_KEY       
  ,LOCATION_KEY         
  ,ITEM_KEY             
  ,AVG_COST             
  ,QTY_AVAILABLE        
  ,QTY_ON_HAND          
  ,QTY_ON_ORDER         
  ,QTY_BACKORDERED      
  ,DATE_ACTIVE_FROM     
  ,DATE_ACTIVE_TO       
  ,DW_CURRENT           
)
SELECT 
       B.SUBSIDIARY_KEY       
      ,C.LOCATION_KEY         
      ,D.ITEM_KEY             
      ,AVG_COST             
      ,QTY_AVAILABLE        
      ,QTY_ON_HAND          
      ,QTY_ON_ORDER         
      ,QTY_BACKORDERED      
      ,SYSDATE AS DATE_ACTIVE_FROM
      ,'9999-12-31 11:59:59' AS DATE_ACTIVE_TO
      ,1 AS DW_CURRENT
FROM dw_prestage.inventory_snapshot_fact_insert A
    INNER JOIN DW_REPORT.SUBSIDIARIES B ON (NVL (A.SUBSIDIARY_ID,-99) = B.SUBSIDIARY_ID) 
    INNER JOIN DW_REPORT.LOCATIONS C ON (NVL (A.LOCATION_ID,-99) = C.LOCATION_ID) 
    INNER JOIN DW_REPORT.ITEMS D ON (NVL (A.ITEM_ID,-99) = D.ITEM_ID);
  
/* fact -> INSERT NEW RECORDS IN ERROR TABLE WHICH DOES NOT HAVE VALID DIMENSIONS */ 
INSERT INTO dw.inventory_snapshot_fact_error
(
  RUNID                              
 ,SUBSIDIARY_ID       
 ,SUBSIDIARY_KEY      
 ,SUBSIDIARY_ID_ERROR 
 ,LOCATION_ID         
 ,LOCATION_KEY        
 ,LOCATION_ID_ERROR   
 ,ITEM_ID             
 ,ITEM_KEY            
 ,ITEM_ID_ERROR       
 ,AVG_COST            
 ,QTY_AVAILABLE       
 ,QTY_ON_HAND         
 ,QTY_ON_ORDER        
 ,QTY_BACKORDERED                 
 ,RECORD_STATUS        
 ,DW_CREATION_DATE     
)
SELECT  A.RUNID
       ,A.SUBSIDIARY_ID       
       ,B.SUBSIDIARY_KEY      
       ,CASE
         WHEN (B.SUBSIDIARY_KEY IS NULL AND A.SUBSIDIARY_ID  IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (B.SUBSIDIARY_KEY IS NULL AND A.SUBSIDIARY_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END SUBSIDIARY_ID_ERROR 
       ,A.LOCATION_ID         
       ,C.LOCATION_KEY        
       ,CASE
         WHEN (C.LOCATION_KEY IS NULL AND A.LOCATION_ID  IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (C.LOCATION_KEY IS NULL AND A.LOCATION_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END LOCATION_ID_ERROR   
       ,A.ITEM_ID             
       ,D.ITEM_KEY            
       ,CASE
         WHEN (D.ITEM_KEY IS NULL AND A.ITEM_ID  IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (D.ITEM_KEY IS NULL AND A.ITEM_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END ITEM_ID_ERROR       
       ,AVG_COST            
       ,QTY_AVAILABLE       
       ,QTY_ON_HAND         
       ,QTY_ON_ORDER        
       ,QTY_BACKORDERED     
      ,'ERROR' AS RECORD_STATUS
      ,SYSDATE AS DW_CREATION_DATE	   
FROM dw_prestage.inventory_snapshot_fact_insert A
    LEFT OUTER JOIN DW_REPORT.SUBSIDIARIES B ON (A.SUBSIDIARY_ID = B.SUBSIDIARY_ID) 
    LEFT OUTER JOIN DW_REPORT.LOCATIONS C ON (A.LOCATION_ID = C.LOCATION_ID) 
    LEFT OUTER JOIN DW_REPORT.ITEMS D ON (A.ITEM_ID = D.ITEM_ID) 
  WHERE 
  ((B.SUBSIDIARY_KEY IS NULL AND A.SUBSIDIARY_ID IS NOT NULL ) OR
  (D.ITEM_KEY IS NULL AND A.ITEM_ID IS NOT NULL ) OR
  (C.LOCATION_KEY IS NULL AND A.LOCATION_ID IS NOT NULL ));

/* fact -> UPDATE THE OLD RECORDS SETTING THE CURRENT FLAG VALUE TO 0 */  
UPDATE dw.inventory_snapshot_fact SET dw_current = 0,DATE_ACTIVE_TO = (sysdate -1) WHERE dw_current = 1
AND   sysdate>= date_active_from
AND   sysdate< date_active_to
AND   EXISTS (SELECT 1 FROM dw_prestage.inventory_snapshot_fact_update
                            INNER JOIN DW_REPORT.SUBSIDIARIES B ON (dw_prestage.inventory_snapshot_fact_update.SUBSIDIARY_ID = B.SUBSIDIARY_ID) 
                            INNER JOIN DW_REPORT.LOCATIONS C ON (dw_prestage.inventory_snapshot_fact_update.LOCATION_ID = C.LOCATION_ID) 
                            INNER JOIN DW_REPORT.ITEMS D ON (dw_prestage.inventory_snapshot_fact_update.ITEM_ID = D.ITEM_ID)  
WHERE dw.inventory_snapshot_fact.SUBSIDIARY_KEY = B.SUBSIDIARY_KEY
and dw.inventory_snapshot_fact.LOCATION_KEY = C.LOCATION_KEY
and dw.inventory_snapshot_fact.ITEM_KEY = D.ITEM_KEY);

/* fact -> NOW INSERT THE FACT RECORDS WHICH HAVE BEEN UPDATED AT THE SOURCE */ 
INSERT INTO dw.inventory_snapshot_fact
(
   SUBSIDIARY_KEY       
  ,LOCATION_KEY         
  ,ITEM_KEY             
  ,AVG_COST             
  ,QTY_AVAILABLE        
  ,QTY_ON_HAND          
  ,QTY_ON_ORDER         
  ,QTY_BACKORDERED      
  ,DATE_ACTIVE_FROM     
  ,DATE_ACTIVE_TO       
  ,DW_CURRENT           
)
SELECT 
       B.SUBSIDIARY_KEY       
      ,C.LOCATION_KEY         
      ,D.ITEM_KEY             
      ,AVG_COST             
      ,QTY_AVAILABLE        
      ,QTY_ON_HAND          
      ,QTY_ON_ORDER         
      ,QTY_BACKORDERED      
      ,SYSDATE AS DATE_ACTIVE_FROM
      ,'9999-12-31 11:59:59' AS DATE_ACTIVE_TO
      ,1 AS DW_CURRENT
FROM dw_prestage.inventory_snapshot_fact_update A
    INNER JOIN DW_REPORT.SUBSIDIARIES B ON (NVL (A.SUBSIDIARY_ID,-99) = B.SUBSIDIARY_ID) 
    INNER JOIN DW_REPORT.LOCATIONS C ON (NVL (A.LOCATION_ID,-99) = C.LOCATION_ID) 
    INNER JOIN DW_REPORT.ITEMS D ON (NVL (A.ITEM_ID,-99) = D.ITEM_ID);

/* fact -> INSERT UPDATED RECORDS IN ERROR TABLE WHICH DOES NOT HAVE VALID DIMENSIONS */ 
INSERT INTO dw.inventory_snapshot_fact_error
(
  RUNID                              
 ,SUBSIDIARY_ID       
 ,SUBSIDIARY_KEY      
 ,SUBSIDIARY_ID_ERROR 
 ,LOCATION_ID         
 ,LOCATION_KEY        
 ,LOCATION_ID_ERROR   
 ,ITEM_ID             
 ,ITEM_KEY            
 ,ITEM_ID_ERROR       
 ,AVG_COST            
 ,QTY_AVAILABLE       
 ,QTY_ON_HAND         
 ,QTY_ON_ORDER        
 ,QTY_BACKORDERED                 
 ,RECORD_STATUS        
 ,DW_CREATION_DATE     
)
SELECT  A.RUNID
       ,A.SUBSIDIARY_ID       
       ,B.SUBSIDIARY_KEY      
       ,CASE
         WHEN (B.SUBSIDIARY_KEY IS NULL AND A.SUBSIDIARY_ID  IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (B.SUBSIDIARY_KEY IS NULL AND A.SUBSIDIARY_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END SUBSIDIARY_ID_ERROR 
       ,A.LOCATION_ID         
       ,C.LOCATION_KEY        
       ,CASE
         WHEN (C.LOCATION_KEY IS NULL AND A.LOCATION_ID  IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (C.LOCATION_KEY IS NULL AND A.LOCATION_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END LOCATION_ID_ERROR   
       ,A.ITEM_ID             
       ,D.ITEM_KEY            
       ,CASE
         WHEN (D.ITEM_KEY IS NULL AND A.ITEM_ID  IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (D.ITEM_KEY IS NULL AND A.ITEM_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END ITEM_ID_ERROR       
       ,AVG_COST            
       ,QTY_AVAILABLE       
       ,QTY_ON_HAND         
       ,QTY_ON_ORDER        
       ,QTY_BACKORDERED     
      ,'ERROR' AS RECORD_STATUS
      ,SYSDATE AS DW_CREATION_DATE	   
FROM dw_prestage.inventory_snapshot_fact_update A
    LEFT OUTER JOIN DW_REPORT.SUBSIDIARIES B ON (A.SUBSIDIARY_ID = B.SUBSIDIARY_ID) 
    LEFT OUTER JOIN DW_REPORT.LOCATIONS C ON (A.LOCATION_ID = C.LOCATION_ID) 
    LEFT OUTER JOIN DW_REPORT.ITEMS D ON (A.ITEM_ID = D.ITEM_ID) 
  WHERE 
  ((B.SUBSIDIARY_KEY IS NULL AND A.SUBSIDIARY_ID IS NOT NULL ) OR
  (D.ITEM_KEY IS NULL AND A.ITEM_ID IS NOT NULL ) OR
  (C.LOCATION_KEY IS NULL AND A.LOCATION_ID IS NOT NULL ));
