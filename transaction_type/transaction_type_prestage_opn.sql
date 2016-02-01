/* prestage - drop intermediate insert table */
DROP TABLE IF EXISTS DW_PRESTAGE.TRANSACTION_TYPE_INSERT;

/* prestage - create intermediate insert table*/
CREATE TABLE DW_PRESTAGE.TRANSACTION_TYPE_INSERT
AS
SELECT * FROM DW_PRESTAGE.TRANSACTION_TYPE
WHERE EXISTS ( SELECT 1 FROM  
(SELECT TRANSACTION_TYPE_RECORD_ID FROM 
(SELECT TRANSACTION_TYPE_RECORD_ID FROM DW_PRESTAGE.TRANSACTION_TYPE
MINUS
SELECT TRANSACTION_TYPE_RECORD_ID FROM DW_STAGE.TRANSACTION_TYPE )) A
WHERE  DW_PRESTAGE.TRANSACTION_TYPE.TRANSACTION_TYPE_RECORD_ID = A.TRANSACTION_TYPE_RECORD_ID );

/* prestage - drop intermediate update table*/
DROP TABLE IF EXISTS DW_PRESTAGE.TRANSACTION_TYPE_UPDATE;

/* prestage - create intermediate update table*/
CREATE TABLE DW_PRESTAGE.TRANSACTION_TYPE_UPDATE
AS
SELECT DECODE(SUM(CH_TYPE),3,2,SUM(CH_TYPE)) CH_TYPE ,TRANSACTION_TYPE_ID
FROM
(
SELECT TRANSACTION_TYPE_ID , CH_TYPE FROM 
(  
SELECT TRANSACTION_TYPE_ID , TRANSACTION_TYPE , DOCUMENT_TYPE, PREFERRED, '2' CH_TYPE FROM DW_PRESTAGE.TRANSACTION_TYPE
MINUS
SELECT TRANSACTION_TYPE_ID , TRANSACTION_TYPE , DOCUMENT_TYPE, PREFERRED,'2' CH_TYPE FROM DW_STAGE.TRANSACTION_TYPE
)
) A WHERE NOT EXISTS ( SELECT 1 FROM DW_PRESTAGE.TRANSACTION_TYPE_INSERT
WHERE DW_PRESTAGE.TRANSACTION_TYPE_INSERT.TRANSACTION_TYPE_ID = A.TRANSACTION_TYPE_ID) GROUP BY TRANSACTION_TYPE_ID;

/* prestage - drop intermediate delete table*/
DROP TABLE IF EXISTS DW_PRESTAGE.TRANSACTION_TYPE_DELETE;

/* prestage - create intermediate delete table*/
CREATE TABLE DW_PRESTAGE.TRANSACTION_TYPE_DELETE
AS
SELECT * FROM DW_STAGE.TRANSACTION_TYPE
WHERE EXISTS ( SELECT 1 FROM  
(SELECT TRANSACTION_TYPE_ID FROM 
(SELECT TRANSACTION_TYPE_ID FROM DW_STAGE.TRANSACTION_TYPE
MINUS
SELECT TRANSACTION_TYPE_ID FROM DW_PRESTAGE.TRANSACTION_TYPE )) A
WHERE DW_STAGE.TRANSACTION_TYPE.TRANSACTION_TYPE_ID = A.TRANSACTION_TYPE_ID );

/* prestage-> no of prestage transaction_type records identified to inserted */
select count(1) from  dw_prestage.transaction_type_insert;

/* prestage-> no of prestage transaction_type records identified to updated */
select count(1) from  dw_prestage.transaction_type_update;

/* prestage-> no of prestage transaction_type records identified to deleted */
select count(1) from  dw_prestage.transaction_type_delete;

/* stage ->delete from stage records to be updated */
DELETE FROM DW_STAGE.TRANSACTION_TYPE 
USING DW_PRESTAGE.TRANSACTION_TYPE_UPDATE
WHERE DW_STAGE.TRANSACTION_TYPE.TRANSACTION_TYPE_ID = DW_PRESTAGE.TRANSACTION_TYPE_UPDATE.TRANSACTION_TYPE_ID;

/* stage ->delete from stage records which have been deleted */
DELETE FROM DW_STAGE.TRANSACTION_TYPE 
USING DW_PRESTAGE.TRANSACTION_TYPE_DELETE
WHERE DW_STAGE.TRANSACTION_TYPE.TRANSACTION_TYPE_ID = DW_PRESTAGE.TRANSACTION_TYPE_DELETE.TRANSACTION_TYPE_ID;

/* stage ->insert into stage records which have been created */
INSERT INTO DW_STAGE.TRANSACTION_TYPE (
 TRANSACTION_TYPE_ID    
,TRANSACTION_TYPE 
,DOCUMENT_TYPE
,PREFERRED
)
SELECT 
 TRANSACTION_TYPE_ID    
,TRANSACTION_TYPE 
,DOCUMENT_TYPE
,PREFERRED
 FROM DW_PRESTAGE.TRANSACTION_TYPE_INSERT;

/* stage ->insert into stage records which have been updated */
INSERT INTO DW_STAGE.TRANSACTION_TYPE (
 TRANSACTION_TYPE_ID    
,TRANSACTION_TYPE 
,DOCUMENT_TYPE
,PREFERRED
)
SELECT 
 TRANSACTION_TYPE_ID    
,TRANSACTION_TYPE 
,DOCUMENT_TYPE
,PREFERRED 
 FROM DW_PRESTAGE.TRANSACTION_TYPE
WHERE EXISTS ( SELECT 1 FROM 
DW_PRESTAGE.TRANSACTION_TYPE_UPDATE
WHERE DW_PRESTAGE.TRANSACTION_TYPE_UPDATE.TRANSACTION_TYPE_ID = DW_PRESTAGE.TRANSACTION_TYPE.TRANSACTION_TYPE_ID);


/* dimension ->insert new records in dim transaction_type */

insert into dw.transaction_type ( 
 transaction_type_id               
,transaction_type 
,document_type
,preferred
,date_active_from       
,DATE_ACTIVE_TO         
,dw_active    )
select 
A.TRANSACTION_TYPE_ID,
A.TRANSACTION_TYPE,
A.DOCUMENT_TYPE,
A.PREFERRED,
sysdate,
'9999-12-31 23:59:59',
'A'
from 
dw_prestage.transaction_type_insert A;

/* dimension ->update old record as part of SCD2 maintenance*/

UPDATE dw.transaction_type
   SET dw_active = 'I' ,
	   DATE_ACTIVE_TO = (sysdate -1)
WHERE dw_active = 'A'
      and sysdate >= date_active_from and sysdate < date_active_to
	  and exists ( select 1 from dw_prestage.transaction_type_update
	  WHERE dw.transaction_type.transaction_type_id = dw_prestage.transaction_type_update.transaction_type_id
	  and dw_prestage.transaction_type_update.ch_type = 2);

/* dimension ->insert the new records as part of SCD2 maintenance*/

insert into dw.transaction_type ( 
  transaction_type_id               
,transaction_type 
,document_type
,preferred
,date_active_from       
,DATE_ACTIVE_TO         
,dw_active      )
select 
A.TRANSACTION_TYPE_ID,
A.TRANSACTION_TYPE,
A.DOCUMENT_TYPE,
A.PREFERRED,
sysdate,
'9999-12-31 23:59:59',
'A'
from 
dw_prestage.transaction_type A
WHERE exists (select 1 from dw_prestage.transaction_type_update
	  WHERE a.transaction_type_id = dw_prestage.transaction_type_update.transaction_type_id
	  and dw_prestage.transaction_type_update.ch_type = 2) ;
	  
/* dimension -> update records as part of SCD1 maintenance */

UPDATE dw.transaction_type
   SET transaction_type = NVL(dw_prestage.transaction_type.transaction_type,'NA_GDW'),
       document_type = NVL(dw_prestage.transaction_type.document_type,'NA_GDW')
FROM dw_prestage.transaction_type
WHERE dw.transaction_type.transaction_type_id = dw_prestage.transaction_type.transaction_type_id
and exists (select 1 from dw_prestage.transaction_type_update
	  WHERE dw_prestage.transaction_type.transaction_type_id = dw_prestage.transaction_type_update.transaction_type_id
	  and dw_prestage.transaction_type_update.ch_type = 1);

/* dimension ->logically delete dw records */
update dw.transaction_type
set DATE_ACTIVE_TO = sysdate-1,
dw_active = 'I'
FROM dw_prestage.transaction_type_delete
WHERE dw.transaction_type.transaction_type_id = dw_prestage.transaction_type_delete.transaction_type_id;