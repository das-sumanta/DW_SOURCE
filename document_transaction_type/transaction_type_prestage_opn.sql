/* prestage - drop intermediate insert table */
drop table if exists dw_prestage.transaction_type_insert;

/* prestage - create intermediate insert table*/
create table dw_prestage.transaction_type_insert
as
select * from dw_prestage.transaction_type
where exists ( select 1 from  
(select transaction_type_record_id from 
(select transaction_type_record_id from dw_prestage.transaction_type
minus
select transaction_type_record_id from dw_stage.transaction_type )) a
where  dw_prestage.transaction_type.transaction_type_record_id = a.transaction_type_record_id );

/* prestage - drop intermediate update table*/
drop table if exists dw_prestage.transaction_type_update;

/* prestage - create intermediate update table*/
create table dw_prestage.transaction_type_update
as
select decode(sum(ch_type),3,2,sum(ch_type)) ch_type ,transaction_type_id
from
(
SELECT transaction_type_id , CH_TYPE FROM 
(  
select transaction_type_id , transaction_type_NAME , document_type, preferred, '1' CH_TYPE from dw_prestage.transaction_type
MINUS
select transaction_type_id , transaction_type_NAME , document_type, preferred,'1' CH_TYPE from dw_stage.transaction_type
)
) a where not exists ( select 1 from dw_prestage.transaction_type_insert
where dw_prestage.transaction_type_insert.transaction_type_id = a.transaction_type_id) group by transaction_type_id;

/* prestage - drop intermediate delete table*/
drop table if exists dw_prestage.transaction_type_delete;

/* prestage - create intermediate delete table*/
create table dw_prestage.transaction_type_delete
as
select * from dw_stage.transaction_type
where exists ( select 1 from  
(select transaction_type_id from 
(select transaction_type_id from dw_stage.transaction_type
minus
select transaction_type_id from dw_prestage.transaction_type )) a
where dw_stage.transaction_type.transaction_type_id = a.transaction_type_id );

/* prestage-> stage*/
select 'no of prestage transaction_type records identified to inserted -->'||count(1) from  dw_prestage.transaction_type_insert;

/* prestage-> stage*/
select 'no of prestage transaction_type records identified to updated -->'||count(1) from  dw_prestage.transaction_type_update;

/* prestage-> stage*/
select 'no of prestage transaction_type records identified to deleted -->'||count(1) from  dw_prestage.transaction_type_delete;

/* stage ->delete from stage records to be updated */
delete from dw_stage.transaction_type 
using dw_prestage.transaction_type_update
where dw_stage.transaction_type.transaction_type_id = dw_prestage.transaction_type_update.transaction_type_id;

/* stage ->delete from stage records which have been deleted */
delete from dw_stage.transaction_type 
using dw_prestage.transaction_type_delete
where dw_stage.transaction_type.transaction_type_id = dw_prestage.transaction_type_delete.transaction_type_id;

/* stage ->insert into stage records which have been created */
insert into dw_stage.transaction_type (
 transaction_type_id    
,transaction_type_name 
,document_type
,preferred
)
select 
 transaction_type_id    
,transaction_type_name 
,document_type
,preferred
 from dw_prestage.transaction_type_insert;

/* stage ->insert into stage records which have been updated */
insert into dw_stage.transaction_type (
 transaction_type_id    
,transaction_type_name 
,document_type
,preferred
)
select 
 transaction_type_id    
,transaction_type_name 
,document_type
,preferred 
 from dw_prestage.transaction_type
where exists ( select 1 from 
dw_prestage.transaction_type_update
where dw_prestage.transaction_type_update.transaction_type_id = dw_prestage.transaction_type.transaction_type_id);

commit;


/* dimension ->insert new records in dim transaction_type */

insert into dw.transaction_type ( 
 transaction_type_id   
,IS_INACTIVE             
,transaction_type_NAME 
,transaction_type_ADDRESS
,date_active_from       
,DATE_ACTIVE_TO         
,dw_active    )
select 
A.transaction_type_record_id,
NVL(A.IS_INACTIVE,'NA_GDW'),
DECODE(LENGTH(A.transaction_type_RECORD_NAME),0,'NA_GDW',A.transaction_type_RECORD_NAME),
DECODE(LENGTH(A.transaction_type_ADDRESS),0,'NA_GDW',A.transaction_type_ADDRESS),
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
	  WHERE dw.transaction_type.transaction_type_id = dw_prestage.transaction_type_update.transaction_type_record_id
	  and dw_prestage.transaction_type_update.ch_type = 2);

/* dimension ->insert the new records as part of SCD2 maintenance*/

insert into dw.transaction_type ( 
 transaction_type_id   
,IS_INACTIVE             
,transaction_type_NAME 
,transaction_type_ADDRESS
,date_active_from       
,DATE_ACTIVE_TO         
,dw_active      )
select 
A.transaction_type_record_id,
NVL(A.IS_INACTIVE,'NA_GDW'),
DECODE(LENGTH(A.transaction_type_RECORD_NAME),0,'NA_GDW',A.transaction_type_RECORD_NAME),
DECODE(LENGTH(A.transaction_type_ADDRESS),0,'NA_GDW',A.transaction_type_ADDRESS),   
sysdate,
'9999-12-31 23:59:59',
'A'
from 
dw_prestage.transaction_type A
WHERE exists (select 1 from dw_prestage.transaction_type_update
	  WHERE a.transaction_type_record_id = dw_prestage.transaction_type_update.transaction_type_record_id
	  and dw_prestage.transaction_type_update.ch_type = 2) ;
	  
/* dimension -> update records as part of SCD1 maintenance */

UPDATE dw.transaction_type
   SET transaction_type_name = NVL(dw_prestage.transaction_type.transaction_type_RECORD_name,'NA_GDW'),
       is_inactive = NVL(dw_prestage.transaction_type.is_inactive,'NA_GDW'),
       transaction_type_ADDRESS = NVL(dw_prestage.transaction_type.transaction_type_ADDRESS,'NA_GDW')
FROM dw_prestage.transaction_type
WHERE dw.transaction_type.transaction_type_id = dw_prestage.transaction_type.transaction_type_record_id
and exists (select 1 from dw_prestage.transaction_type_update
	  WHERE dw_prestage.transaction_type.transaction_type_record_id = dw_prestage.transaction_type_update.transaction_type_record_id
	  and dw_prestage.transaction_type_update.ch_type = 1);

/* dimension ->logically delete dw records */
update dw.transaction_type
set DATE_ACTIVE_TO = sysdate-1,
dw_active = 'I'
FROM dw_prestage.transaction_type_delete
WHERE dw.transaction_type.transaction_type_id = dw_prestage.transaction_type_delete.transaction_type_record_id;

commit;