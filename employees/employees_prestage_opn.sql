/* prestage - drop intermediate insert table */
drop table if exists dw_prestage.employees_insert;

/* prestage - create intermediate insert table*/
create table dw_prestage.employees_insert
as
select * from dw_prestage.employees
where exists ( select 1 from  
(select employee_id from 
(select employee_id from dw_prestage.employees
minus
select employee_id from dw_stage.employees )) a
where  dw_prestage.employees.employee_id = a.employee_id );

/* prestage - drop intermediate update table*/
drop table if exists dw_prestage.employees_update;

/* prestage - create intermediate update table*/
create table dw_prestage.employees_update
as
select decode(sum(ch_type),3,2,sum(ch_type)) ch_type ,employee_id
from
(
SELECT employee_id , CH_TYPE FROM 
(  
select employee_id , SUPERVISOR_NAME,SUPERVISOR_ID,APPROVER_ID,APPROVER_NAME, '2' CH_TYPE from dw_prestage.employees
MINUS
select employee_id , SUPERVISOR_NAME,SUPERVISOR_ID,APPROVER_ID,APPROVER_NAME, '2' CH_TYPE from dw_stage.employees
)
union all
SELECT employee_id , CH_TYPE FROM 
(  
select employee_id,JOBTITLE,EMAIL,LINE1,LINE2,LINE3,ZIPCODE,CITY,STATE,COUNTRY,SUBSIDIARY,SUBSIDIARY_ID,LINE_OF_BUSINESS,LINE_OF_BUSINESS_ID,LOCATION,LOCATION_ID,COST_CENTER,DEPARTMENT_ID,HIREDDATE	,RELEASEDATE, '1' CH_TYPE from dw_prestage.employees
MINUS
select employee_id,JOBTITLE,EMAIL,LINE1,LINE2,LINE3,ZIPCODE,CITY,STATE,COUNTRY,SUBSIDIARY,SUBSIDIARY_ID,LINE_OF_BUSINESS,LINE_OF_BUSINESS_ID,LOCATION,LOCATION_ID,COST_CENTER,DEPARTMENT_ID,HIREDDATE	,RELEASEDATE, '1' CH_TYPE from dw_stage.employees
)
) a where not exists ( select 1 from dw_prestage.employees_insert
where dw_prestage.employees_insert.employee_id = a.employee_id) group by employee_id;

/* prestage - drop intermediate delete table*/
drop table if exists dw_prestage.employees_delete;

/* prestage - create intermediate delete table*/
create table dw_prestage.employees_delete
as
select * from dw_stage.employees
where exists ( select 1 from  
(select employee_id from 
(select employee_id from dw_stage.employees
minus
select employee_id from dw_prestage.employees )) a
where dw_stage.employees.employee_id = a.employee_id );

/* prestage-> stage*/
select 'no of prestage vendor records identified to inserted -->'||count(1) from  dw_prestage.employees_insert;

/* prestage-> stage*/
select 'no of prestage vendor records identified to updated -->'||count(1) from  dw_prestage.employees_update;

/* prestage-> stage*/
select 'no of prestage vendor records identified to deleted -->'||count(1) from  dw_prestage.employees_delete;

/* stage -> delete from stage records to be updated */
delete from dw_stage.employees 
using dw_prestage.employees_update
where dw_stage.employees.employee_id = dw_prestage.employees_update.employee_id;

/* stage -> delete from stage records which have been deleted */
delete from dw_stage.employees 
using dw_prestage.employees_delete
where dw_stage.employees.employee_id = dw_prestage.employees_delete.employee_id;

/* stage -> insert into stage records which have been created */
insert into dw_stage.employees 
select * from dw_prestage.employees_insert;

/* stage -> insert into stage records which have been updated */
insert into dw_stage.employees 
select * from dw_prestage.employees
where exists ( select 1 from 
dw_prestage.employees_update
where dw_prestage.employees_update.employee_id = dw_prestage.employees.employee_id);

commit;

/* dimension -> insert new records in dim employees */
insert into dw.employees ( 
  EMPLOYEE_ID
,NAME
,FULL_NAME
,FIRSTNAME
,LASTNAME
,INITIALS
,JOB_TITLE
,EMAIL
,LINE1
,LINE2
,LINE3
,ZIPCODE
,CITY
,STATE
,COUNTRY
,SUPERVISOR_NAME
,SUPERVISOR_ID
,APPROVER_ID
,APPROVER_NAME
,SUBSIDIARY
,SUBSIDIARY_ID
,LINE_OF_BUSINESS
,LINE_OF_BUSINESS_ID
,LOCATION
,LOCATION_ID
,COST_CENTER
,COST_CENTER_ID
,HIRE_DATE
,RELEASE_DATE
,DATE_ACTIVE_FROM
,DATE_ACTIVE_TO
,DW_ACTIVE  )
select 
 employee_id
 ,DECODE(LENGTH(NAME),0,'NA_GDW',NAME)
 ,DECODE(LENGTH(FULL_NAME),0,'NA_GDW',FULL_NAME )         
 ,DECODE(LENGTH(FIRSTNAME),0,'NA_GDW',FIRSTNAME   )      
 ,DECODE(LENGTH(LASTNAME),0,'NA_GDW', LASTNAME   )    
 ,DECODE(LENGTH(INITIALS),0,'NA_GDW', INITIALS )    
 ,DECODE(LENGTH(JOBTITLE),0,'NA_GDW', JOBTITLE )    
 ,DECODE(LENGTH(EMAIL),0,'NA_GDW', EMAIL   )
 ,DECODE(LENGTH(LINE1),0,'NA_GDW', LINE1  )         
 ,DECODE(LENGTH(LINE2),0,'NA_GDW', LINE2  )
 ,DECODE(LENGTH(LINE3),0,'NA_GDW', LINE3  )         
 ,DECODE(LENGTH(ZIPCODE),0,'NA_GDW', ZIPCODE)          
 ,DECODE(LENGTH(CITY),0,'NA_GDW',CITY )             
 ,DECODE(LENGTH(STATE),0,'NA_GDW',STATE )            
 ,DECODE(LENGTH(COUNTRY),0,'NA_GDW', COUNTRY )         
 ,DECODE(LENGTH(SUPERVISOR_NAME),0,'NA_GDW',SUPERVISOR_NAME)       
 ,NVL(SUPERVISOR_ID , -99)  
 ,NVL(APPROVER_ID , -99) 
 ,DECODE(LENGTH(APPROVER_NAME),0,'NA_GDW',APPROVER_NAME)
  ,DECODE(LENGTH(SUBSIDIARY),0,'NA_GDW',SUBSIDIARY)
 ,NVL(SUBSIDIARY_ID ,-99)  
 ,DECODE(LENGTH(LINE_OF_BUSINESS),0,'NA_GDW',LINE_OF_BUSINESS)
 ,NVL(LINE_OF_BUSINESS_ID ,-99)  
 ,DECODE(LENGTH(LOCATION),0,'NA_GDW', LOCATION) 
 ,NVL(LOCATION_ID , -99)
 ,DECODE(LENGTH(COST_CENTER),0,'NA_GDW', COST_CENTER) 
 ,NVL(DEPARTMENT_ID , -99) 
 ,NVL(HIREDDATE,'1900-12-31 00:00:00') 
 ,NVL(RELEASEDATE,'1900-12-31 00:00:00') 
 ,sysdate
 ,'9999-12-31 23:59:59'
 ,'A'
  from 
dw_prestage.employees_insert A;

/* dimension -> update old record as part of SCD2 maintenance*/

UPDATE dw.employees
   SET dw_active = 'I' ,
	   DATE_ACTIVE_TO = (sysdate -1)
WHERE dw_active = 'A'
      and sysdate >= date_active_from and sysdate < date_active_to
	  and exists ( select 1 from dw_prestage.employees_update
	  WHERE dw.employees.employee_id = dw_prestage.employees_update.employee_id
	  and dw_prestage.employees_update.ch_type = 2);

/* dimension -> insert the new records as part of SCD2 maintenance*/

insert into dw.employees ( 
   EMPLOYEE_ID
,NAME
,FULL_NAME
,FIRSTNAME
,LASTNAME
,INITIALS
,JOB_TITLE
,EMAIL
,LINE1
,LINE2
,LINE3
,ZIPCODE
,CITY
,STATE
,COUNTRY
,SUPERVISOR_NAME
,SUPERVISOR_ID
,APPROVER_ID
,APPROVER_NAME
,SUBSIDIARY
,SUBSIDIARY_ID
,LINE_OF_BUSINESS
,LINE_OF_BUSINESS_ID
,LOCATION
,LOCATION_ID
,COST_CENTER
,COST_CENTER_ID
,HIRE_DATE
,RELEASE_DATE
,DATE_ACTIVE_FROM
,DATE_ACTIVE_TO
,DW_ACTIVE  )
select 
 employee_id
 ,DECODE(LENGTH(NAME),0,'NA_GDW',NAME)
 ,DECODE(LENGTH(FULL_NAME),0,'NA_GDW',FULL_NAME )         
 ,DECODE(LENGTH(FIRSTNAME),0,'NA_GDW',FIRSTNAME   )      
 ,DECODE(LENGTH(LASTNAME),0,'NA_GDW', LASTNAME   )    
 ,DECODE(LENGTH(INITIALS),0,'NA_GDW', INITIALS )    
 ,DECODE(LENGTH(JOBTITLE),0,'NA_GDW', JOBTITLE )    
 ,DECODE(LENGTH(EMAIL),0,'NA_GDW', EMAIL   )
 ,DECODE(LENGTH(LINE1),0,'NA_GDW', LINE1  )         
 ,DECODE(LENGTH(LINE2),0,'NA_GDW', LINE2  )
 ,DECODE(LENGTH(LINE3),0,'NA_GDW', LINE3  )         
 ,DECODE(LENGTH(ZIPCODE),0,'NA_GDW', ZIPCODE)          
 ,DECODE(LENGTH(CITY),0,'NA_GDW',CITY )             
 ,DECODE(LENGTH(STATE),0,'NA_GDW',STATE )            
 ,DECODE(LENGTH(COUNTRY),0,'NA_GDW', COUNTRY )         
 ,DECODE(LENGTH(SUPERVISOR_NAME),0,'NA_GDW',SUPERVISOR_NAME)       
 ,NVL(SUPERVISOR_ID , -99)  
 ,NVL(APPROVER_ID , -99) 
 ,DECODE(LENGTH(APPROVER_NAME),0,'NA_GDW',APPROVER_NAME)
  ,DECODE(LENGTH(SUBSIDIARY),0,'NA_GDW',SUBSIDIARY)
 ,NVL(SUBSIDIARY_ID ,-99)  
 ,DECODE(LENGTH(LINE_OF_BUSINESS),0,'NA_GDW',LINE_OF_BUSINESS)
 ,NVL(LINE_OF_BUSINESS_ID ,-99)  
 ,DECODE(LENGTH(LOCATION),0,'NA_GDW', LOCATION) 
 ,NVL(LOCATION_ID , -99)
 ,DECODE(LENGTH(COST_CENTER),0,'NA_GDW', COST_CENTER) 
 ,NVL(DEPARTMENT_ID , -99) 
 ,NVL(HIREDDATE,'1900-12-31 00:00:00') 
 ,NVL(RELEASEDATE,'1900-12-31 00:00:00') 
 ,sysdate
 ,'9999-12-31 23:59:59'
 ,'A'
from 
dw_prestage.employees A
WHERE exists (select 1 from dw_prestage.employees_update
	  WHERE a.employee_id = dw_prestage.employees_update.employee_id
	  and dw_prestage.employees_update.ch_type = 2) ;
	  
/* dimension -> update records as part of SCD1 maintenance */

UPDATE dw.employees 
   SET  
       JOB_TITLE            =   DECODE(LENGTH(dw_prestage.employees.JOBTITLE),0,'NA_GDW', dw_prestage.employees.JOBTITLE )    
      ,EMAIL                =   DECODE(LENGTH(dw_prestage.employees.EMAIL),0,'NA_GDW', dw_prestage.employees.EMAIL   )
      ,LINE1                =   DECODE(LENGTH(dw_prestage.employees.LINE1),0,'NA_GDW', dw_prestage.employees.LINE1  )         
      ,LINE2                =   DECODE(LENGTH(dw_prestage.employees.LINE2),0,'NA_GDW', dw_prestage.employees.LINE2  )
      ,LINE3                =   DECODE(LENGTH(dw_prestage.employees.LINE3),0,'NA_GDW', dw_prestage.employees.LINE3  )       
      ,ZIPCODE              =   DECODE(LENGTH(dw_prestage.employees.ZIPCODE),0,'NA_GDW', dw_prestage.employees.ZIPCODE)       
      ,CITY                 =   DECODE(LENGTH(dw_prestage.employees.CITY),0,'NA_GDW',dw_prestage.employees.CITY )        
      ,STATE                =   DECODE(LENGTH(dw_prestage.employees.STATE),0,'NA_GDW',dw_prestage.employees.STATE )         
      ,COUNTRY              =   DECODE(LENGTH(dw_prestage.employees.COUNTRY),0,'NA_GDW', dw_prestage.employees.COUNTRY )     
      ,SUBSIDIARY           =   DECODE(LENGTH(dw_prestage.employees.SUBSIDIARY),0,'NA_GDW',dw_prestage.employees.SUBSIDIARY)
      ,SUBSIDIARY_ID        =   NVL(dw_prestage.employees.SUBSIDIARY_ID ,-99)  
      ,LINE_OF_BUSINESS     =   DECODE(LENGTH(dw_prestage.employees.LINE_OF_BUSINESS),0,'NA_GDW',dw_prestage.employees.LINE_OF_BUSINESS)
      ,LINE_OF_BUSINESS_ID  =   NVL(dw_prestage.employees.LINE_OF_BUSINESS_ID ,-99)  
      ,LOCATION             =   DECODE(LENGTH(dw_prestage.employees.LOCATION),0,'NA_GDW', dw_prestage.employees.LOCATION) 
      ,LOCATION_ID          =   NVL(dw_prestage.employees.LOCATION_ID , -99)
      ,COST_CENTER          =   DECODE(LENGTH(dw_prestage.employees.COST_CENTER),0,'NA_GDW', dw_prestage.employees.COST_CENTER) 
      ,COST_CENTER_ID       =   NVL(DEPARTMENT_ID , -99) 
      ,HIRE_DATE            =   NVL(HIREDDATE,'1900-12-31 00:00:00') 
      ,RELEASE_DATE         =   NVL(RELEASEDATE,'1900-12-31 00:00:00')   
   FROM dw_prestage.employees
WHERE dw.employees.employee_id = dw_prestage.employees.employee_id
and exists (select 1 from dw_prestage.employees_update
	  WHERE dw_prestage.employees.employee_id = dw_prestage.employees_update.employee_id
	  and dw_prestage.employees_update.ch_type = 1);

/* dimension -> logically delete dw records */
update dw.employees
set DATE_ACTIVE_TO = sysdate-1,
dw_active = 'I'
FROM dw_prestage.employees_delete
WHERE dw.employees.employee_id = dw_prestage.employees_delete.employee_id;

commit;