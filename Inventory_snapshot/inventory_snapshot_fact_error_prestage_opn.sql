/* error prestage - drop intermediate error prestage table */
DROP TABLE IF EXISTS DW_PRESTAGE.INVENTORY_SNAPSHOT_FACT_ERROR;

/* prestage - create intermediate insert table*/
CREATE TABLE DW_PRESTAGE.INVENTORY_SNAPSHOT_FACT_ERROR
AS
SELECT
  A.RUNID
 ,NVL(A.SUBSIDIARY_KEY,B.SUBSIDIARY_KEY)       
 ,NVL(A.LOCATION_KEY, C.LOCATION_KEY)        
 ,NVL(A.ITEM_KEY,D.ITEM_KEY)
 ,A.SUBSIDIARY_ID 
 ,A.LOCATION_ID
 ,A.ITEM_ID
 ,A.AVG_COST             
 ,A.QTY_AVAILABLE        
 ,A.QTY_ON_HAND          
 ,A.QTY_ON_ORDER         
 ,A.QTY_BACKORDERED     
 ,'PROCESSED'  RECORD_STATUS
 ,SYSDATE  DW_CREATION_DATE
 FROM DW.INVENTORY_SNAPSHOT_FACT_ERROR A
    INNER JOIN DW_REPORT.SUBSIDIARIES B ON (NVL (A.SUBSIDIARY_ID,-99) = B.SUBSIDIARY_ID) 
    INNER JOIN DW_REPORT.LOCATIONS C ON (NVL (A.LOCATION_ID,-99) = C.LOCATION_ID) 
    INNER JOIN DW_REPORT.ITEMS D ON (NVL (A.ITEM_ID,-99) = D.ITEM_ID)
WHERE A.RUNID = NVL(RUNID_ERR,A.RUNID);

/* prestage-> identify new revenue fact records */
UPDATE DW_PRESTAGE.INVENTORY_SNAPSHOT_FACT_ERROR
 SET RECORD_STATUS = 'INSERT'
 WHERE NOT EXISTS
 (SELECT 1 FROM DW_REPORT.INVENTORY_SNAPSHOT_FACT B
 WHERE DW_PRESTAGE.INVENTORY_SNAPSHOT_FACT_ERROR.ITEM_KEY = B.ITEM_KEY
 AND DW_PRESTAGE.INVENTORY_SNAPSHOT_FACT_ERROR.LOCATION_KEY = B.LOCATION_KEY
 AND DW_PRESTAGE.INVENTORY_SNAPSHOT_FACT_ERROR.SUBSIDIARY_KEY = B.SUBSIDIARY_KEY );

/* prestage-> no of inventory snapshot fact records reprocessed in staging*/
SELECT count(1) FROM dw_prestage.INVENTORY_SNAPSHOT_FACT_ERROR;

/* prestage-> no of inventory snapshot fact records identified as new*/
SELECT count(1) FROM dw_prestage.INVENTORY_SNAPSHOT_FACT_ERROR where RECORD_STATUS = 'INSERT';

/* prestage-> no of inventory snapshot fact records identified to be updated*/
SELECT count(1) FROM dw_prestage.INVENTORY_SNAPSHOT_FACT_ERROR where RECORD_STATUS = 'PROCESSED';

/* fact -> INSERT REPROCESSED RECORDS WHICH HAS ALL VALID DIMENSIONS */
INSERT INTO dw.INVENTORY_SNAPSHOT_FACT
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
   A.SUBSIDIARY_KEY       
  ,A.LOCATION_KEY         
  ,A.ITEM_KEY             
  ,A.AVG_COST             
  ,A.QTY_AVAILABLE        
  ,A.QTY_ON_HAND          
  ,A.QTY_ON_ORDER         
  ,A.QTY_BACKORDERED      
  ,SYSDATE AS DATE_ACTIVE_FROM
  ,'9999-12-31 11:59:59' AS DATE_ACTIVE_TO
  ,1 AS DW_CURRENT
 FROM
 DW_PRESTAGE.INVENTORY_SNAPSHOT_FACT_ERROR A
 WHERE 
 RECORD_STATUS = 'INSERT';
 
 /* fact -> UPDATE THE OLD RECORDS SETTING THE CURRENT FLAG VALUE TO 0 */
UPDATE dw.INVENTORY_SNAPSHOT_FACT SET dw_current = 0,DATE_ACTIVE_TO = (sysdate -1) WHERE dw_current = 1
AND   sysdate>= date_active_from
AND   sysdate< date_active_to
AND   EXISTS (SELECT 1 FROM dw_prestage.INVENTORY_SNAPSHOT_FACT_error
  WHERE dw.INVENTORY_SNAPSHOT_FACT.ITEM_KEY = dw_prestage.INVENTORY_SNAPSHOT_FACT_error.ITEM_KEY
  AND   dw.INVENTORY_SNAPSHOT_FACT.LOCATION_KEY = dw_prestage.INVENTORY_SNAPSHOT_FACT_error.LOCATION_KEY
  AND dw.INVENTORY_SNAPSHOT_FACT.subsidiary_KEY = dw_prestage.INVENTORY_SNAPSHOT_FACT_error.subsidiary_key
  AND dw_prestage.INVENTORY_SNAPSHOT_FACT_error.RECORD_STATUS = 'PROCESSED');
  
/* fact -> INSERT UPDATED REPROCESSED RECORDS WHICH HAVE ALL VALID DIMENSIONS*/
INSERT INTO dw.INVENTORY_SNAPSHOT_FACT
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
   A.SUBSIDIARY_KEY       
  ,A.LOCATION_KEY         
  ,A.ITEM_KEY             
  ,A.AVG_COST             
  ,A.QTY_AVAILABLE        
  ,A.QTY_ON_HAND          
  ,A.QTY_ON_ORDER         
  ,A.QTY_BACKORDERED      
  ,SYSDATE AS DATE_ACTIVE_FROM
  ,'9999-12-31 11:59:59' AS DATE_ACTIVE_TO
  ,1 AS DW_CURRENT
 FROM
 DW_PRESTAGE.INVENTORY_SNAPSHOT_FACT_ERROR A
 WHERE 
 RECORD_STATUS = 'PROCESSED';
 
/* fact -> UPDATE THE ERROR TABLE TO SET THE SATUS AS PROCESSED */
UPDATE dw.INVENTORY_SNAPSHOT_FACT_ERROR SET RECORD_STATUS = 'PROCESSED'
where exists ( select 1 from dw_prestage.INVENTORY_SNAPSHOT_FACT_ERROR b
  WHERE dw.INVENTORY_SNAPSHOT_FACT_ERROR.RUNID = b.RUNID
  AND dw.INVENTORY_SNAPSHOT_FACT_ERROR.SUBSIDIARY_ID = b.SUBSIDIARY_ID
  AND dw.INVENTORY_SNAPSHOT_FACT_ERROR.LOCATION_ID = b.LOCATION_ID
  and dw.INVENTORY_SNAPSHOT_FACT_ERROR.ITEM_ID = b.ITEM_ID);
