/* error prestage - drop intermediate error prestage table */
DROP TABLE IF EXISTS DW_PRESTAGE.BUDGETFORECAST_FACT_ERROR;

/* prestage - create intermediate insert table*/
CREATE TABLE DW_PRESTAGE.BUDGETFORECAST_FACT_ERROR
AS
SELECT
     A.RUNID,
     A.BUDGETFORECAST_ID,
     A.BUDGETFORECAST_NAME,
     A.FISCAL_MONTH_ID,
     A.FISCAL_WEEK_ID,
     NVL(A.CLASS_KEY,B.CLASS_KEY) AS CLASS_KEY,
     A.CLASS_ID ,
	 NVL(A.TERRITORY_KEY,C.TERRITORY_KEY) AS TERRITORY_KEY,
     A.TERRITORY_ID,
	 NVL(A.SUBSIDIARY_KEY,D.SUBSIDIARY_KEY) AS SUBSIDIARY_KEY,
     A.SUBSIDIARY_ID,
	 A.BUDGETFORECAST_TYPE,
     A.MONTH_END_DATE,
     A.MONTH_START_DATE,
     A.WEEK_START_DATE,
     A.WEEK_END_DATE,
     A.AMOUNT,
     A.IS_INACTIVE,
	 A.CREATION_DATE,
     A.LAST_MODIFIED_DATE,
     'PROCESSED'  RECORD_STATUS,
     SYSDATE  DW_CREATION_DATE
 FROM DW.BUDGETFORECAST_FACT_ERROR A
  LEFT OUTER JOIN DW_REPORT.CLASSES B ON (A.CLASS_ID = B.CLASS_ID)
  LEFT OUTER JOIN DW_REPORT.territories C ON (A.TERRITORY_ID = C.TERRITORY_ID)
  LEFT OUTER JOIN DW_REPORT.SUBSIDIARIES D ON (A.SUBSIDIARY_ID = D.SUBSIDIARY_ID)
WHERE A.RUNID = NVL('%s',A.RUNID)
AND RECORD_STATUS = 'ERROR';

/* prestage-> identify new revenue fact records */
UPDATE DW_PRESTAGE.BUDGETFORECAST_FACT_ERROR A
 SET RECORD_STATUS = 'INSERT'
 WHERE NOT EXISTS
 (SELECT 1 FROM DW_REPORT.BUDGETFORECAST_FACT B
 WHERE A.BUDGETFORECAST_ID = B.BUDGETFORECAST_ID
 AND A.SUBSIDIARY_KEY = B.SUBSIDIARY_KEY );

/* prestage-> no of budget forecast fact records reprocessed in staging*/
SELECT count(1) FROM dw_prestage.BUDGETFORECAST_FACT_ERROR;

/* prestage-> no of budget forecast fact records identified as new*/
SELECT count(1) FROM dw_prestage.BUDGETFORECAST_FACT_ERROR where RECORD_STATUS = 'INSERT';

/* prestage-> no of budget forecast fact records identified to be updated*/
SELECT count(1) FROM dw_prestage.BUDGETFORECAST_FACT_ERROR where RECORD_STATUS = 'PROCESSED';

/* fact -> INSERT REPROCESSED RECORDS WHICH HAS ALL VALID DIMENSIONS */
INSERT INTO dw.budgetforecast_fact
(
  BUDGETFORECAST_ID   
 ,BUDGETFORECAST_NAME   
 ,FISCAL_MONTH_ID       
 ,FISCAL_WEEK_ID        
 ,CLASS_KEY             
 ,TERRITORY_KEY         
 ,SUBSIDIARY_KEY        
 ,BUDGETFORECAST_TYPE   
 ,MONTH_END_DATE        
 ,MONTH_START_DATE      
 ,WEEK_START_DATE       
 ,WEEK_END_DATE         
 ,AMOUNT                
 ,IS_INACTIVE           
 ,CREATION_DATE         
 ,LAST_MODIFIED_DATE    
 ,DATE_ACTIVE_FROM      
 ,DATE_ACTIVE_TO        
 ,DW_CURRENT            
  )  
SELECT
  A.BUDGETFORECAST_ID,
  A.BUDGETFORECAST_NAME,
  A.FISCAL_MONTH_ID,
  A.FISCAL_WEEK_ID,
  A.CLASS_KEY,
  A.TERRITORY_KEY,
  A.SUBSIDIARY_KEY,
  A.BUDGETFORECAST_TYPE,
  A.MONTH_END_DATE,
  A.MONTH_START_DATE,
  A.WEEK_START_DATE,
  A.WEEK_END_DATE,
  A.AMOUNT,
  A.IS_INACTIVE,
  A.CREATION_DATE,
  A.LAST_MODIFIED_DATE, 
  SYSDATE AS DATE_ACTIVE_FROM,
  '9999-12-31 11:59:59' AS DATE_ACTIVE_TO,
  1 AS DW_CURRENT
 FROM
  DW_PRESTAGE.BUDGETFORECAST_FACT_ERROR A
 WHERE 
 RECORD_STATUS = 'INSERT';
 
 /* fact -> UPDATE THE OLD RECORDS SETTING THE CURRENT FLAG VALUE TO 0 */
UPDATE dw.BUDGETFORECAST_fact SET dw_current = 0,DATE_ACTIVE_TO = (sysdate -1) WHERE dw_current = 1
AND   sysdate>= date_active_from
AND   sysdate< date_active_to
AND   EXISTS (SELECT 1 FROM dw_prestage.BUDGETFORECAST_FACT_ERROR
  WHERE dw.BUDGETFORECAST_fact.BUDGETFORECAST_ID = dw_prestage.BUDGETFORECAST_FACT_ERROR.BUDGETFORECAST_ID
  AND dw.BUDGETFORECAST_fact.subsidiary_id = dw_prestage.BUDGETFORECAST_FACT_ERROR.subsidiary_id
  AND dw_prestage.BUDGETFORECAST_FACT_ERROR.RECORD_STATUS = 'PROCESSED');
  
/* fact -> INSERT UPDATED REPROCESSED RECORDS WHICH HAVE ALL VALID DIMENSIONS*/
INSERT INTO dw.revenue_fact
(
 BUDGETFORECAST_ID   
 ,BUDGETFORECAST_NAME   
 ,FISCAL_MONTH_ID       
 ,FISCAL_WEEK_ID        
 ,CLASS_KEY             
 ,TERRITORY_KEY         
 ,SUBSIDIARY_KEY        
 ,BUDGETFORECAST_TYPE   
 ,MONTH_END_DATE        
 ,MONTH_START_DATE      
 ,WEEK_START_DATE       
 ,WEEK_END_DATE         
 ,AMOUNT                
 ,IS_INACTIVE           
 ,CREATION_DATE         
 ,LAST_MODIFIED_DATE    
 ,DATE_ACTIVE_FROM      
 ,DATE_ACTIVE_TO        
 ,DW_CURRENT           
)
SELECT
  A.BUDGETFORECAST_ID,
  A.BUDGETFORECAST_NAME,
  A.FISCAL_MONTH_ID,
  A.FISCAL_WEEK_ID,
  A.CLASS_KEY,
  A.TERRITORY_KEY,
  A.SUBSIDIARY_KEY,
  A.BUDGETFORECAST_TYPE,
  A.MONTH_END_DATE,
  A.MONTH_START_DATE,
  A.WEEK_START_DATE,
  A.WEEK_END_DATE,
  A.AMOUNT,
  A.IS_INACTIVE,
  A.CREATION_DATE,
  A.LAST_MODIFIED_DATE, 
  SYSDATE AS DATE_ACTIVE_FROM,
  '9999-12-31 11:59:59' AS DATE_ACTIVE_TO,
  1 AS DW_CURRENT
 FROM
 DW_PRESTAGE.BUDGETFORECAST_FACT_ERROR A
 WHERE 
 RECORD_STATUS = 'PROCESSED';
 
  /* fact -> UPDATE THE ERROR TABLE TO SET THE SATUS AS PROCESSED */
UPDATE dw.budgetforecast_fact_error SET RECORD_STATUS = 'PROCESSED'
where exists ( select 1 from dw_prestage.budgetforecast_fact_error b
  WHERE dw.budgetforecast_fact_error.RUNID = b.RUNID
  AND dw.budgetforecast_fact_error.budgetforecast_id = b.transaction_id);
