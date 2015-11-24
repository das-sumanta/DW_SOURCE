/* prestage - drop intermediate insert table */
drop table if exists dw_prestage.custom_form_insert;

/* prestage - create intermediate insert table*/
create table dw_prestage.custom_form_insert
as
select * from dw_prestage.custom_form
where exists ( select 1 from  
(select custom_form_id from 
(select custom_form_id from dw_prestage.custom_form
minus
select custom_form_id from dw_stage.custom_form )) a
where  dw_prestage.custom_form.custom_form_id = a.custom_form_id );

/* prestage - drop intermediate update table*/
drop table if exists dw_prestage.custom_form_update;

/* prestage - create intermediate update table*/
create table dw_prestage.custom_form_update
as
select decode(sum(ch_type),3,2,sum(ch_type)) ch_type ,custom_form_id
from
(
SELECT custom_form_id , CH_TYPE FROM 
(  
select custom_form_id , CUSTOM_FORM_NAME , FORM_TYPE , '2' CH_TYPE from dw_prestage.custom_form
MINUS
select custom_form_id , CUSTOM_FORM_NAME , FORM_TYPE , '2' CH_TYPE from dw_stage.custom_form
)
) a where not exists ( select 1 from dw_prestage.custom_form_insert
where dw_prestage.custom_form_insert.custom_form_id = a.custom_form_id) group by custom_form_id;

/* prestage - drop intermediate delete table*/
drop table if exists dw_prestage.custom_form_delete;

/* prestage - create intermediate delete table*/
create table dw_prestage.custom_form_delete
as
select * from dw_stage.custom_form
where exists ( select 1 from  
(select custom_form_id from 
(select custom_form_id from dw_stage.custom_form
minus
select custom_form_id from dw_prestage.custom_form )) a
where dw_stage.custom_form.custom_form_id = a.custom_form_id );

/* prestage-> stage*/
select 'no of prestage custom form records identified to inserted -->'||count(1) from  dw_prestage.custom_form_insert;

/* prestage-> stage*/
select 'no of prestage custom form records identified to updated -->'||count(1) from  dw_prestage.custom_form_update;

/* prestage-> stage*/
select 'no of prestage custom form records identified to deleted -->'||count(1) from  dw_prestage.custom_form_delete;

/* stage ->delete from stage records to be updated */
delete from dw_stage.custom_form 
using dw_prestage.custom_form_update
where dw_stage.custom_form.custom_form_id = dw_prestage.custom_form_update.custom_form_id;

/* stage ->delete from stage records which have been deleted */
delete from dw_stage.custom_form 
using dw_prestage.custom_form_delete
where dw_stage.custom_form.custom_form_id = dw_prestage.custom_form_delete.custom_form_id;

/* stage ->insert into stage records which have been created */
insert into dw_stage.custom_form (CUSTOM_FORM_ID,CUSTOM_FORM_NAME,FORM_TYPE)
select CUSTOM_FORM_ID,CUSTOM_FORM_NAME,FORM_TYPE from dw_prestage.custom_form_insert;

/* stage ->insert into stage records which have been updated */
insert into dw_stage.custom_form (CUSTOM_FORM_ID,CUSTOM_FORM_NAME,FORM_TYPE)
select CUSTOM_FORM_ID,CUSTOM_FORM_NAME,FORM_TYPE from dw_prestage.custom_form
where exists ( select 1 from 
dw_prestage.custom_form_update
where dw_prestage.custom_form_update.custom_form_id = dw_prestage.custom_form.custom_form_id);

commit;


/* dimension ->insert new records in dim custom_form */

insert into dw.custom_form ( 
 CUSTOM_FORM_ID
,CUSTOM_FORM_NAME
,FORM_TYPE 
,date_active_from       
,DATE_ACTIVE_TO         
,dw_active    )
select 
A.custom_form_id,
DECODE(LENGTH(A.CUSTOM_FORM_NAME),0,'NA_GDW',A.CUSTOM_FORM_NAME),
DECODE(LENGTH(A.FORM_TYPE),0,'NA_GDW',A.FORM_TYPE),
sysdate,
'9999-12-31 23:59:59',
'A'
from 
dw_prestage.custom_form_insert A;

/* dimension ->update old record as part of SCD2 maintenance*/

UPDATE dw.custom_form
   SET dw_active = 'I' ,
	   DATE_ACTIVE_TO = (sysdate -1)
WHERE dw_active = 'A'
      and sysdate >= date_active_from and sysdate < date_active_to
	  and exists ( select 1 from dw_prestage.custom_form_update
	  WHERE dw.custom_form.custom_form_id = dw_prestage.custom_form_update.custom_form_id
	  and dw_prestage.custom_form_update.ch_type = 2);

/* dimension ->insert the new records as part of SCD2 maintenance*/

insert into dw.custom_form ( 
 CUSTOM_FORM_ID
,CUSTOM_FORM_NAME
,FORM_TYPE             
,date_active_from       
,DATE_ACTIVE_TO         
,dw_active    )
select 
A.custom_form_id,
DECODE(LENGTH(A.CUSTOM_FORM_NAME),0,'NA_GDW',A.CUSTOM_FORM_NAME),
DECODE(LENGTH(A.FORM_TYPE),0,'NA_GDW',A.FORM_TYPE),
sysdate,
'9999-12-31 23:59:59',
'A')
from 
dw_prestage.custom_form A
WHERE exists (select 1 from dw_prestage.custom_form_update
	  WHERE a.custom_form_id = dw_prestage.custom_form_update.custom_form_id
	  and dw_prestage.custom_form_update.ch_type = 2) ;
	  
/* dimension -> update records as part of SCD1 maintenance */

/* dimension ->logically delete dw records */
update dw.custom_form
set DATE_ACTIVE_TO = sysdate-1,
dw_active = 'I'
FROM dw_prestage.custom_form_delete
WHERE dw.custom_form.custom_form_id = dw_prestage.custom_form_delete.custom_form_id;

commit;