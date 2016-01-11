/* prestage - drop intermediate insert table */
drop table if exists dw_prestage.carrier_insert;

/* prestage - create intermediate insert table*/
create table dw_prestage.carrier_insert
as
select * from dw_prestage.carrier
where exists ( select 1 from  
(select carrier_record_id from 
(select carrier_record_id from dw_prestage.carrier
minus
select carrier_record_id from dw_stage.carrier )) a
where  dw_prestage.carrier.carrier_record_id = a.carrier_record_id );

/* prestage - drop intermediate update table*/
drop table if exists dw_prestage.carrier_update;

/* prestage - create intermediate update table*/
create table dw_prestage.carrier_update
as
select decode(sum(ch_type),3,2,sum(ch_type)) ch_type ,carrier_record_id
from
(
SELECT carrier_record_id , CH_TYPE FROM 
(  
select carrier_record_id , CARRIER_RECORD_NAME , CARRIER_ADDRESS, IS_INACTIVE, '1' CH_TYPE from dw_prestage.carrier
MINUS
select carrier_record_id , CARRIER_RECORD_NAME , CARRIER_ADDRESS, IS_INACTIVE,'1' CH_TYPE from dw_stage.carrier
)
) a where not exists ( select 1 from dw_prestage.carrier_insert
where dw_prestage.carrier_insert.carrier_record_id = a.carrier_record_id) group by carrier_record_id;

/* prestage - drop intermediate delete table*/
drop table if exists dw_prestage.carrier_delete;

/* prestage - create intermediate delete table*/
create table dw_prestage.carrier_delete
as
select * from dw_stage.carrier
where exists ( select 1 from  
(select carrier_record_id from 
(select carrier_record_id from dw_stage.carrier
minus
select carrier_record_id from dw_prestage.carrier )) a
where dw_stage.carrier.carrier_record_id = a.carrier_record_id );

/* prestage-> stage*/
select 'no of prestage carrier records identified to inserted -->'||count(1) from  dw_prestage.carrier_insert;

/* prestage-> stage*/
select 'no of prestage carrier records identified to updated -->'||count(1) from  dw_prestage.carrier_update;

/* prestage-> stage*/
select 'no of prestage carrier records identified to deleted -->'||count(1) from  dw_prestage.carrier_delete;

/* stage ->delete from stage records to be updated */
delete from dw_stage.carrier 
using dw_prestage.carrier_update
where dw_stage.carrier.carrier_record_id = dw_prestage.carrier_update.carrier_record_id;

/* stage ->delete from stage records which have been deleted */
delete from dw_stage.carrier 
using dw_prestage.carrier_delete
where dw_stage.carrier.carrier_record_id = dw_prestage.carrier_delete.carrier_record_id;

/* stage ->insert into stage records which have been created */
insert into dw_stage.carrier (CARRIER_ADDRESS    
,CARRIER_RECORD_ID  
,CARRIER_RECORD_NAME
,IS_INACTIVE
,DATE_CREATED              
,DATE_LAST_MODIFIED 
)
select CARRIER_ADDRESS    
,CARRIER_RECORD_ID  
,CARRIER_RECORD_NAME
,IS_INACTIVE
,DATE_CREATED               
,DATE_LAST_MODIFIED 
 from dw_prestage.carrier_insert;

/* stage ->insert into stage records which have been updated */
insert into dw_stage.carrier (CARRIER_ADDRESS    
,CARRIER_RECORD_ID  
,CARRIER_RECORD_NAME
,IS_INACTIVE
,DATE_CREATED               
,DATE_LAST_MODIFIED 
)
select CARRIER_ADDRESS    
,CARRIER_RECORD_ID  
,CARRIER_RECORD_NAME
,IS_INACTIVE
,DATE_CREATED              
,DATE_LAST_MODIFIED 
 from dw_prestage.carrier
where exists ( select 1 from 
dw_prestage.carrier_update
where dw_prestage.carrier_update.carrier_record_id = dw_prestage.carrier.carrier_record_id);

commit;


/* dimension ->insert new records in dim carrier */

insert into dw.carrier ( 
 carrier_id   
,IS_INACTIVE             
,CARRIER_NAME 
,CARRIER_ADDRESS
,date_active_from       
,DATE_ACTIVE_TO         
,dw_active    )
select 
A.carrier_record_id,
NVL(A.IS_INACTIVE,'NA_GDW'),
DECODE(LENGTH(A.CARRIER_RECORD_NAME),0,'NA_GDW',A.CARRIER_RECORD_NAME),
DECODE(LENGTH(A.CARRIER_ADDRESS),0,'NA_GDW',A.CARRIER_ADDRESS),
sysdate,
'9999-12-31 23:59:59',
'A'
from 
dw_prestage.carrier_insert A;

/* dimension ->update old record as part of SCD2 maintenance*/

UPDATE dw.carrier
   SET dw_active = 'I' ,
	   DATE_ACTIVE_TO = (sysdate -1)
WHERE dw_active = 'A'
      and sysdate >= date_active_from and sysdate < date_active_to
	  and exists ( select 1 from dw_prestage.carrier_update
	  WHERE dw.carrier.carrier_id = dw_prestage.carrier_update.carrier_record_id
	  and dw_prestage.carrier_update.ch_type = 2);

/* dimension ->insert the new records as part of SCD2 maintenance*/

insert into dw.carrier ( 
 carrier_id   
,IS_INACTIVE             
,CARRIER_NAME 
,CARRIER_ADDRESS
,date_active_from       
,DATE_ACTIVE_TO         
,dw_active      )
select 
A.carrier_record_id,
NVL(A.IS_INACTIVE,'NA_GDW'),
DECODE(LENGTH(A.CARRIER_RECORD_NAME),0,'NA_GDW',A.CARRIER_RECORD_NAME),
DECODE(LENGTH(A.CARRIER_ADDRESS),0,'NA_GDW',A.CARRIER_ADDRESS),   
sysdate,
'9999-12-31 23:59:59',
'A'
from 
dw_prestage.carrier A
WHERE exists (select 1 from dw_prestage.carrier_update
	  WHERE a.carrier_record_id = dw_prestage.carrier_update.carrier_record_id
	  and dw_prestage.carrier_update.ch_type = 2) ;
	  
/* dimension -> update records as part of SCD1 maintenance */

UPDATE dw.carrier
   SET CARRIER_name = NVL(dw_prestage.carrier.CARRIER_RECORD_name,'NA_GDW'),
       is_inactive = NVL(dw_prestage.carrier.is_inactive,'NA_GDW'),
       CARRIER_ADDRESS = NVL(dw_prestage.carrier.CARRIER_ADDRESS,'NA_GDW')
FROM dw_prestage.carrier
WHERE dw.carrier.carrier_id = dw_prestage.carrier.carrier_record_id
and exists (select 1 from dw_prestage.carrier_update
	  WHERE dw_prestage.carrier.carrier_record_id = dw_prestage.carrier_update.carrier_record_id
	  and dw_prestage.carrier_update.ch_type = 1);

/* dimension ->logically delete dw records */
update dw.carrier
set DATE_ACTIVE_TO = sysdate-1,
dw_active = 'I'
FROM dw_prestage.carrier_delete
WHERE dw.carrier.carrier_id = dw_prestage.carrier_delete.carrier_record_id;

commit;