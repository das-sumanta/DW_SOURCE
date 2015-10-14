drop table if exists dw_prestage.freight_estimate_insert;

create table dw_prestage.freight_estimate_insert
as
select * from dw_prestage.freight_estimate
where exists ( select 1 from  
(select LANDED_COST_RULE_MATRIX_NZ_ID from 
(select LANDED_COST_RULE_MATRIX_NZ_ID from dw_prestage.freight_estimate
minus
select LANDED_COST_RULE_MATRIX_NZ_ID from dw_stage.freight_estimate )) a
where  dw_prestage.freight_estimate.LANDED_COST_RULE_MATRIX_NZ_ID = a.LANDED_COST_RULE_MATRIX_NZ_ID );

drop table if exists dw_prestage.freight_estimate_update;

create table dw_prestage.freight_estimate_update
as
select decode(sum(ch_type),3,2,sum(ch_type)) ch_type ,LANDED_COST_RULE_MATRIX_NZ_ID
from
(
SELECT LANDED_COST_RULE_MATRIX_NZ_ID , CH_TYPE FROM 
(  --SCD2 columns
select LANDED_COST_RULE_MATRIX_NZ_ID , SUBSIDIARY, SUBSIDIARY_ID, '2' CH_TYPE from dw_prestage.freight_estimate
MINUS
select LANDED_COST_RULE_MATRIX_NZ_ID , SUBSIDIARY, SUBSIDIARY_ID, '2' CH_TYPE from dw_stage.freight_estimate
)
union all
SELECT LANDED_COST_RULE_MATRIX_NZ_ID , CH_TYPE FROM 
(  --SCD1 columns
select LANDED_COST_RULE_MATRIX_NZ_ID,LANDED_COST_RULE_MATRIX_NZ_NAM,	DESCRIPTION,	IS_INACTIVE,	PERCENT_OF_COST,	PLUS_AMOUNT, '1' CH_TYPE from dw_prestage.freight_estimate
MINUS
select LANDED_COST_RULE_MATRIX_NZ_ID,LANDED_COST_RULE_MATRIX_NZ_NAM,	DESCRIPTION,	IS_INACTIVE,	PERCENT_OF_COST,	PLUS_AMOUNT, '1' CH_TYPE from dw_stage.freight_estimate
)
) a where not exists ( select 1 from dw_prestage.freight_estimate_insert
where dw_prestage.freight_estimate_insert.LANDED_COST_RULE_MATRIX_NZ_ID = a.LANDED_COST_RULE_MATRIX_NZ_ID) group by LANDED_COST_RULE_MATRIX_NZ_ID;

drop table if exists dw_prestage.freight_estimate_delete;

create table dw_prestage.freight_estimate_delete
as
select * from dw_stage.freight_estimate
where exists ( select 1 from  
(select LANDED_COST_RULE_MATRIX_NZ_ID from 
(select LANDED_COST_RULE_MATRIX_NZ_ID from dw_stage.freight_estimate
minus
select LANDED_COST_RULE_MATRIX_NZ_ID from dw_prestage.freight_estimate )) a
where dw_stage.freight_estimate.LANDED_COST_RULE_MATRIX_NZ_ID = a.LANDED_COST_RULE_MATRIX_NZ_ID );

select 'no of prestage freight estimate records identified to inserted -->'||count(1) from  dw_prestage.freight_estimate_insert;

select 'no of prestage freight estimate records identified to updated -->'||count(1) from  dw_prestage.freight_estimate_update;

select 'no of prestage freight estimate records identified to deleted -->'||count(1) from  dw_prestage.freight_estimate_delete;

/* delete from stage records to be updated */
delete from dw_stage.freight_estimate 
using dw_prestage.freight_estimate_update
where dw_stage.freight_estimate.LANDED_COST_RULE_MATRIX_NZ_ID = dw_prestage.freight_estimate_update.LANDED_COST_RULE_MATRIX_NZ_ID;

/* delete from stage records which have been deleted */
delete from dw_stage.freight_estimate 
using dw_prestage.freight_estimate_delete
where dw_stage.freight_estimate.LANDED_COST_RULE_MATRIX_NZ_ID = dw_prestage.freight_estimate_delete.LANDED_COST_RULE_MATRIX_NZ_ID;

/* insert into stage records which have been created */
insert into dw_stage.freight_estimate (LANDED_COST_RULE_MATRIX_NZ_ID,LANDED_COST_RULE_MATRIX_NZ_NAM,DESCRIPTION,IS_INACTIVE,PERCENT_OF_COST,PLUS_AMOUNT,SUBSIDIARY_ID,SUBSIDIARY,DATE_CREATED,LAST_MODIFIED_DATE
) 
select LANDED_COST_RULE_MATRIX_NZ_ID,LANDED_COST_RULE_MATRIX_NZ_NAM,DESCRIPTION,IS_INACTIVE,PERCENT_OF_COST,PLUS_AMOUNT,SUBSIDIARY_ID,SUBSIDIARY,DATE_CREATED,LAST_MODIFIED_DATE
 from dw_prestage.freight_estimate_insert;

/* insert into stage records which have been updated */
insert into dw_stage.freight_estimate (LANDED_COST_RULE_MATRIX_NZ_ID,LANDED_COST_RULE_MATRIX_NZ_NAM,DESCRIPTION,IS_INACTIVE,PERCENT_OF_COST,PLUS_AMOUNT,SUBSIDIARY_ID,SUBSIDIARY,DATE_CREATED,LAST_MODIFIED_DATE
)
select LANDED_COST_RULE_MATRIX_NZ_ID,LANDED_COST_RULE_MATRIX_NZ_NAM,DESCRIPTION,IS_INACTIVE,PERCENT_OF_COST,PLUS_AMOUNT,SUBSIDIARY_ID,SUBSIDIARY,DATE_CREATED,LAST_MODIFIED_DATE
 from dw_prestage.freight_estimate
where exists ( select 1 from 
dw_prestage.freight_estimate_update
where dw_prestage.freight_estimate_update.LANDED_COST_RULE_MATRIX_NZ_ID = dw_prestage.freight_estimate.LANDED_COST_RULE_MATRIX_NZ_ID);

commit;

/* insert new records in dim freight_estimate */
/*==========================assumed that dimensions will be full extraction and hence dw_prestage.freight_estimate will have all the records  =====*/
/*==========================for the first run. =====================================================================================================================================*/
insert into dw.freight_estimate ( 
  LANDED_COST_RULE_MATRIX_NZ_ID,
  SHIP_METHOD_NAME,
  SHIP_METHOD_DESCRIPTION,
  IS_INACTIVE,
  PERCENT_OF_COST,
  ADDITIONAL_AMOUNT,
  SUBSIDIARY,
  SUBSIDIARY_ID,
  DATE_ACTIVE_FROM,
  DATE_ACTIVE_TO,
  DW_ACTIVE )
select 
 LANDED_COST_RULE_MATRIX_NZ_ID
 ,DECODE(LENGTH(LANDED_COST_RULE_MATRIX_NZ_NAM),0,'NA_GDW',LANDED_COST_RULE_MATRIX_NZ_NAM)
 ,DECODE(LENGTH(DESCRIPTION),0,'NA_GDW',DESCRIPTION )         
 ,DECODE(LENGTH(IS_INACTIVE),0,'NA_GDW',IS_INACTIVE   )      
 ,PERCENT_OF_COST
 ,PLUS_AMOUNT 
 ,DECODE(LENGTH(SUBSIDIARY),0,'NA_GDW', SUBSIDIARY )    
 ,NVL(SUBSIDIARY_ID ,-99)  
 ,sysdate
 ,'9999-12-31 23:59:59'
 ,'A'
  from 
dw_prestage.freight_estimate_insert A;

/*==============================================assumed since this is an update the record/s already exists in dim table===========================================================*/
/*===============================================only one record will be there with dw_active column as 'A'========================================================================*/
/* update old record as part of SCD2 maintenance*/

UPDATE dw.freight_estimate
   SET dw_active = 'I' ,
	   DATE_ACTIVE_TO = (sysdate -1)
WHERE dw_active = 'A'
      and sysdate >= date_active_from and sysdate < date_active_to
	  and exists ( select 1 from dw_prestage.freight_estimate_update
	  WHERE dw.freight_estimate.LANDED_COST_RULE_MATRIX_NZ_ID = dw_prestage.freight_estimate_update.LANDED_COST_RULE_MATRIX_NZ_ID
	  and dw_prestage.freight_estimate_update.ch_type = 2);

/* insert the new records as part of SCD2 maintenance*/

insert into dw.freight_estimate ( 
  LANDED_COST_RULE_MATRIX_NZ_ID,
  SHIP_METHOD_NAME,
  SHIP_METHOD_DESCRIPTION,
  IS_INACTIVE,
  PERCENT_OF_COST,
  ADDITIONAL_AMOUNT,
  SUBSIDIARY,
  SUBSIDIARY_ID,
  DATE_ACTIVE_FROM,
  DATE_ACTIVE_TO,
  DW_ACTIVE )
select 
 A.LANDED_COST_RULE_MATRIX_NZ_ID
 ,DECODE(LENGTH(A.LANDED_COST_RULE_MATRIX_NZ_NAM),0,'NA_GDW',A.LANDED_COST_RULE_MATRIX_NZ_NAM)
 ,DECODE(LENGTH(A.DESCRIPTION),0,'NA_GDW',A.DESCRIPTION )         
 ,DECODE(LENGTH(A.IS_INACTIVE),0,'NA_GDW',A.IS_INACTIVE   )      
 ,A.PERCENT_OF_COST
 ,A.PLUS_AMOUNT 
 ,DECODE(LENGTH(A.SUBSIDIARY),0,'NA_GDW', A.SUBSIDIARY )    
 ,NVL(A.SUBSIDIARY_ID ,-99)  
 ,sysdate
 ,'9999-12-31 23:59:59'
 ,'A'
from 
dw_prestage.freight_estimate A
WHERE exists (select 1 from dw_prestage.freight_estimate_update
	  WHERE a.LANDED_COST_RULE_MATRIX_NZ_ID = dw_prestage.freight_estimate_update.LANDED_COST_RULE_MATRIX_NZ_ID
	  and dw_prestage.freight_estimate_update.ch_type = 2) ;
	  
/* update SCD1 */

UPDATE dw.freight_estimate 
   SET  
       SHIP_METHOD_NAME            =   dw_prestage.freight_estimate.LANDED_COST_RULE_MATRIX_NZ_NAM 
      ,SHIP_METHOD_DESCRIPTION    =    dw_prestage.freight_estimate.DESCRIPTION
      ,IS_INACTIVE                =   DECODE(LENGTH(dw_prestage.freight_estimate.IS_INACTIVE),0,'NA_GDW', dw_prestage.freight_estimate.IS_INACTIVE  )         
      ,PERCENT_OF_COST                =   dw_prestage.freight_estimate.PERCENT_OF_COST
      ,ADDITIONAL_AMOUNT                =   dw_prestage.freight_estimate.PLUS_AMOUNT       
      ,SUBSIDIARY              =   DECODE(LENGTH(dw_prestage.freight_estimate.SUBSIDIARY),0,'NA_GDW', dw_prestage.freight_estimate.SUBSIDIARY)       
      ,SUBSIDIARY_ID        =   NVL(dw_prestage.freight_estimate.SUBSIDIARY_ID ,-99)  
   FROM dw_prestage.freight_estimate
WHERE dw.freight_estimate.LANDED_COST_RULE_MATRIX_NZ_ID = dw_prestage.freight_estimate.LANDED_COST_RULE_MATRIX_NZ_ID
and exists (select 1 from dw_prestage.freight_estimate_update
	  WHERE dw_prestage.freight_estimate.LANDED_COST_RULE_MATRIX_NZ_ID = dw_prestage.freight_estimate_update.LANDED_COST_RULE_MATRIX_NZ_ID
	  and dw_prestage.freight_estimate_update.ch_type = 1);

/* logically delete dw records */
update dw.freight_estimate
set DATE_ACTIVE_TO = sysdate-1,
dw_active = 'I'
FROM dw_prestage.freight_estimate_delete
WHERE dw.freight_estimate.LANDED_COST_RULE_MATRIX_NZ_ID = dw_prestage.freight_estimate_delete.LANDED_COST_RULE_MATRIX_NZ_ID;

commit;
