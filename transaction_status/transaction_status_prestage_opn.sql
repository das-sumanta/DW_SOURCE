/* prestage - drop intermediate insert table */
DROP TABLE IF EXISTS DW_PRESTAGE.TRANSACTION_STATUS_INSERT;

/* prestage - create intermediate insert table*/
CREATE TABLE DW_PRESTAGE.TRANSACTION_STATUS_INSERT
AS
SELECT * FROM DW_PRESTAGE.TRANSACTION_STATUS
WHERE EXISTS ( SELECT 1 FROM  
(SELECT DOCUMENT_TYPE,STATUS FROM 
(SELECT DOCUMENT_TYPE,STATUS FROM DW_PRESTAGE.TRANSACTION_STATUS
MINUS
SELECT DOCUMENT_TYPE,STATUS FROM DW_STAGE.TRANSACTION_STATUS )) A
WHERE  DW_PRESTAGE.TRANSACTION_STATUS.DOCUMENT_TYPE = A.DOCUMENT_TYPE
     AND DW_PRESTAGE.TRANSACTION_STATUS.STATUS = A.STATUS );

/* prestage - Insert the NA_GDW NA_ERR records for insert table*/	 
INSERT INTO DW_PRESTAGE.TRANSACTION_STATUS_INSERT
(
  runid,
  document_type,
  status
)
SELECT Y.RUNID,
       Y.document_type,
       X.STATUS
FROM (SELECT C.RUNID,
             C.document_type,
             C.STATUS
      FROM (SELECT DISTINCT RUNID,
                   document_type,
                   NULL AS STATUS
            FROM DW_PRESTAGE.TRANSACTION_STATUS_INSERT) C) Y,
     (SELECT B.RUNID,
             B.document_type,
             B.STATUS
      FROM (SELECT NULL AS RUNID,
                   NULL AS document_type,
                   'NA_GDW' AS STATUS UNION ALL SELECT NULL AS RUNID,
                   NULL AS document_type,
                   'NA_ERR' AS STATUS) B) X;

/* prestage - drop intermediate update table*/
DROP TABLE IF EXISTS DW_PRESTAGE.TRANSACTION_STATUS_UPDATE;

/* prestage - create intermediate update table*/
CREATE TABLE DW_PRESTAGE.TRANSACTION_STATUS_UPDATE
AS
SELECT DECODE(SUM(CH_TYPE),3,2,SUM(CH_TYPE)) CH_TYPE ,DOCUMENT_TYPE,STATUS
FROM
(
SELECT DOCUMENT_TYPE,STATUS , CH_TYPE FROM 
(  
SELECT DOCUMENT_TYPE,STATUS, '2' CH_TYPE FROM DW_PRESTAGE.TRANSACTION_STATUS
MINUS
SELECT DOCUMENT_TYPE,STATUS,'2' CH_TYPE FROM DW_STAGE.TRANSACTION_STATUS
)
) A WHERE NOT EXISTS ( SELECT 1 FROM DW_PRESTAGE.TRANSACTION_STATUS_INSERT
WHERE DW_PRESTAGE.TRANSACTION_STATUS_INSERT.DOCUMENT_TYPE = A.DOCUMENT_TYPE
 AND DW_PRESTAGE.TRANSACTION_STATUS_INSERT.STATUS = A.STATUS) GROUP BY DOCUMENT_TYPE,STATUS;

/* prestage - drop intermediate delete table*/
DROP TABLE IF EXISTS DW_PRESTAGE.TRANSACTION_STATUS_DELETE;

/* prestage - create intermediate delete table*/
CREATE TABLE DW_PRESTAGE.TRANSACTION_STATUS_DELETE
AS
SELECT * FROM DW_STAGE.TRANSACTION_STATUS
WHERE EXISTS ( SELECT 1 FROM  
(SELECT DOCUMENT_TYPE,STATUS FROM 
(SELECT DOCUMENT_TYPE,STATUS FROM DW_STAGE.TRANSACTION_STATUS
MINUS
SELECT DOCUMENT_TYPE,STATUS FROM DW_PRESTAGE.TRANSACTION_STATUS )) A
WHERE DW_STAGE.TRANSACTION_STATUS.DOCUMENT_TYPE = A.DOCUMENT_TYPE 
     AND DW_STAGE.TRANSACTION_STATUS.STATUS = A.STATUS);

/* prestage-> no of prestage TRANSACTION_STATUS records identified to inserted */
select count(1) from  dw_prestage.TRANSACTION_STATUS_insert;

/* prestage-> no of prestage TRANSACTION_STATUS records identified to updated */
select count(1) from  dw_prestage.TRANSACTION_STATUS_update;

/* prestage-> no of prestage TRANSACTION_STATUS records identified to deleted */
select count(1) from  dw_prestage.TRANSACTION_STATUS_delete;

/* stage ->delete from stage records to be updated */
DELETE FROM DW_STAGE.TRANSACTION_STATUS 
USING DW_PRESTAGE.TRANSACTION_STATUS_UPDATE
WHERE DW_STAGE.TRANSACTION_STATUS.DOCUMENT_TYPE = DW_PRESTAGE.TRANSACTION_STATUS_UPDATE.DOCUMENT_TYPE
AND DW_STAGE.TRANSACTION_STATUS.STATUS = DW_PRESTAGE.TRANSACTION_STATUS_UPDATE.STATUS;

/* stage ->delete from stage records which have been deleted */
DELETE FROM DW_STAGE.TRANSACTION_STATUS 
USING DW_PRESTAGE.TRANSACTION_STATUS_DELETE
WHERE DW_STAGE.TRANSACTION_STATUS.DOCUMENT_TYPE = DW_PRESTAGE.TRANSACTION_STATUS_DELETE.DOCUMENT_TYPE
AND DW_STAGE.TRANSACTION_STATUS.STATUS = DW_PRESTAGE.TRANSACTION_STATUS_DELETE.STATUS;

/* stage ->insert into stage records which have been created */
INSERT INTO DW_STAGE.TRANSACTION_STATUS (
 DOCUMENT_TYPE
,STATUS
)
SELECT 
 DOCUMENT_TYPE
,STATUS
 FROM DW_PRESTAGE.TRANSACTION_STATUS_INSERT;

/* stage ->insert into stage records which have been updated */
INSERT INTO DW_STAGE.TRANSACTION_STATUS (
 DOCUMENT_TYPE
,STATUS
)
SELECT 
 DOCUMENT_TYPE
,STATUS
 FROM DW_PRESTAGE.TRANSACTION_STATUS
WHERE EXISTS ( SELECT 1 FROM 
DW_PRESTAGE.TRANSACTION_STATUS_UPDATE
WHERE DW_PRESTAGE.TRANSACTION_STATUS_UPDATE.DOCUMENT_TYPE = DW_PRESTAGE.TRANSACTION_STATUS.DOCUMENT_TYPE
AND DW_PRESTAGE.TRANSACTION_STATUS_UPDATE.STATUS = DW_PRESTAGE.TRANSACTION_STATUS.STATUS);


/* dimension ->insert new records in dim TRANSACTION_STATUS */

insert into dw.TRANSACTION_STATUS ( 
 document_type
,STATUS
,date_active_from       
,DATE_ACTIVE_TO         
,dw_active    )
select 
A.document_type,
A.STATUS,
sysdate,
'9999-12-31 23:59:59',
'A'
from 
dw_prestage.TRANSACTION_STATUS_insert A;

/* dimension ->update old record as part of SCD2 maintenance*/

UPDATE dw.TRANSACTION_STATUS
   SET dw_active = 'I' ,
	   DATE_ACTIVE_TO = (sysdate -1)
WHERE dw_active = 'A'
      and sysdate >= date_active_from and sysdate < date_active_to
	  and exists ( select 1 from dw_prestage.TRANSACTION_STATUS_update
	  WHERE dw.TRANSACTION_STATUS.document_type = dw_prestage.TRANSACTION_STATUS_update.document_type
	  AND dw.TRANSACTION_STATUS.STATUS = dw_prestage.TRANSACTION_STATUS_update.STATUS
	  and dw_prestage.TRANSACTION_STATUS_update.ch_type = 2);

/* dimension ->insert the new records as part of SCD2 maintenance*/

insert into dw.TRANSACTION_STATUS ( 
document_type
,STATUS
,date_active_from            
,DATE_ACTIVE_TO         
,dw_active      )
select 
A.document_type,
A.STATUS,
sysdate,
'9999-12-31 23:59:59',
'A'
from 
dw_prestage.TRANSACTION_STATUS A
WHERE exists (select 1 from dw_prestage.TRANSACTION_STATUS_update
	  WHERE a.document_type = dw_prestage.TRANSACTION_STATUS_update.document_type
	  AND a.STATUS = dw_prestage.TRANSACTION_STATUS_update.STATUS
	  and dw_prestage.TRANSACTION_STATUS_update.ch_type = 2) ;
	  
/* dimension -> update records as part of SCD1 maintenance */

UPDATE dw.TRANSACTION_STATUS
   SET document_type = NVL(dw_prestage.TRANSACTION_STATUS.document_type,'NA_GDW'),
       STATUS = NVL(dw_prestage.TRANSACTION_STATUS.STATUS,'NA_GDW')
FROM dw_prestage.TRANSACTION_STATUS
WHERE dw.TRANSACTION_STATUS.document_type = dw_prestage.TRANSACTION_STATUS.document_type
AND dw.TRANSACTION_STATUS.STATUS = dw_prestage.TRANSACTION_STATUS.STATUS
and exists (select 1 from dw_prestage.TRANSACTION_STATUS_update
	  WHERE dw_prestage.TRANSACTION_STATUS.document_type = dw_prestage.TRANSACTION_STATUS_update.document_type
	  and dw_prestage.TRANSACTION_STATUS.STATUS = dw_prestage.TRANSACTION_STATUS_update.STATUS
	  and dw_prestage.TRANSACTION_STATUS_update.ch_type = 1);

/* dimension ->logically delete dw records */
update dw.TRANSACTION_STATUS
set DATE_ACTIVE_TO = sysdate-1,
dw_active = 'I'
FROM dw_prestage.TRANSACTION_STATUS_delete
WHERE dw.TRANSACTION_STATUS.document_type = dw_prestage.TRANSACTION_STATUS_delete.document_type
AND dw.TRANSACTION_STATUS.STATUS = dw_prestage.TRANSACTION_STATUS_delete.STATUS;
