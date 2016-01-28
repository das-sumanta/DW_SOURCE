/* prestage - drop intermediate insert table */
drop table if exists dw_prestage.accounts_insert;

/* prestage - create intermediate insert table*/
create table dw_prestage.accounts_insert
as
select * from dw_prestage.accounts
where exists ( select 1 from  
(select account_id from 
(select account_id from dw_prestage.accounts
minus
select account_id from dw_stage.accounts )) a
where  dw_prestage.accounts.account_id = a.account_id );

/* prestage - drop intermediate update table*/
drop table if exists dw_prestage.accounts_update;

/* prestage - create intermediate update table*/
create table dw_prestage.accounts_update
as
select decode(sum(ch_type),3,2,sum(ch_type)) ch_type ,account_id
from
(
SELECT account_id , CH_TYPE FROM 
(  
select account_id 
,CLASS_ID         
,LINE_OF_BUSINESS 
,CURRENCY_ID      
,CURRENCY_NAME    
,DEPARTMENT_ID       
,COST_CENTER_NAME    
,LOCATION_ID    
,LOCATION_NAME  
,PARENT_ID
,PARENT_ACCOUNT_NAME
,PARENT_ACCOUNT_NUMBER, '2' CH_TYPE from dw_prestage.accounts
MINUS
select account_id 
,CLASS_ID         
,LINE_OF_BUSINESS 
,CURRENCY_ID      
,CURRENCY_NAME    
,DEPARTMENT_ID       
,COST_CENTER_NAME    
,LOCATION_ID    
,LOCATION_NAME  
,PARENT_ID
,PARENT_ACCOUNT_NAME
,PARENT_ACCOUNT_NUMBER, '2' CH_TYPE from dw_stage.accounts
)
union all
SELECT account_id , CH_TYPE FROM 
(  
select account_id
,ACCOUNTNUMBER
,ACCOUNT_EXTID
,ACCPAC_CODES
,BANK_ACCOUNT_NUMBER
,CASHFLOW_RATE_TYPE 
,DEFERRAL_ACCOUNT_ID 
,DESCRIPTION         
,GENERAL_RATE_TYPE 
,HYPERION_CODES    
,ISINACTIVE
, '1' CH_TYPE from dw_prestage.accounts
MINUS
select account_id
,ACCOUNTNUMBER
,ACCOUNT_EXTID
,ACCPAC_CODES
,BANK_ACCOUNT_NUMBER
,CASHFLOW_RATE_TYPE 
,DEFERRAL_ACCOUNT_ID 
,DESCRIPTION         
,GENERAL_RATE_TYPE 
,HYPERION_CODES    
,ISINACTIVE
, '1' CH_TYPE from dw_stage.accounts
)
) a where not exists ( select 1 from dw_prestage.accounts_insert
where dw_prestage.accounts_insert.account_id = a.account_id) group by account_id;

/* prestage - drop intermediate delete table*/
drop table if exists dw_prestage.accounts_delete;

/* prestage - create intermediate delete table*/
create table dw_prestage.accounts_delete
as
select * from dw_stage.accounts
where exists ( select 1 from  
(select account_id from 
(select account_id from dw_stage.accounts
minus
select account_id from dw_prestage.accounts )) a
where dw_stage.accounts.account_id = a.account_id );

/* prestage-> no of prestage account records identified to inserted */
select count(1) from  dw_prestage.accounts_insert;

/* prestage-> no of prestage account records identified to updated */
select count(1) from  dw_prestage.accounts_update;

/* prestage-> no of prestage account records identified to deleted*/
select count(1) from  dw_prestage.accounts_delete;

/* stage ->delete from stage records to be updated */
delete from dw_stage.accounts 
using dw_prestage.accounts_update
where dw_stage.accounts.account_id = dw_prestage.accounts_update.account_id;

/* stage ->delete from stage records which have been deleted */
delete from dw_stage.accounts 
using dw_prestage.accounts_delete
where dw_stage.accounts.account_id = dw_prestage.accounts_delete.account_id;

/* stage ->insert into stage records which have been created */
insert into dw_stage.accounts (ACCOUNTNUMBER                 
                              ,ACCOUNT_EXTID                 
                              ,ACCOUNT_ID                    
                              ,ACCPAC_CODES                  
                              ,BANK_ACCOUNT_NUMBER           
                              ,CASHFLOW_RATE_TYPE            
                              ,CATEGORY_1099_MISC            
                              ,CATEGORY_1099_MISC_MTHRESHOLD 
                              ,CLASS_ID                      
                              ,LINE_OF_BUSINESS              
                              ,CURRENCY_ID                   
                              ,CURRENCY_NAME                 
                              ,DATE_LAST_MODIFIED            
                              ,DEFERRAL_ACCOUNT_ID           
                              ,DEPARTMENT_ID                 
                              ,COST_CENTER_NAME              
                              ,DESCRIPTION                   
                              ,FULL_DESCRIPTION              
                              ,FULL_NAME                     
                              ,GENERAL_RATE_TYPE             
                              ,HYPERION_CODES                
                              ,ISINACTIVE                    
                              ,IS_BALANCESHEET               
                              ,IS_INCLUDED_IN_ELIMINATION    
                              ,IS_INCLUDED_IN_REVAL          
                              ,IS_LEFTSIDE                   
                              ,IS_SUMMARY                    
                              ,LOCATION_ID                   
                              ,LOCATION_NAME                 
                              ,NAME                          
                              ,OPENBALANCE                   
                              ,PARENT_ID                     
                              ,PARENT_ACCOUNT_NAME           
                              ,PARENT_ACCOUNT_NUMBER         
                              ,TYPE_NAME                     
                              ,TYPE_SEQUENCE                 
)
select ACCOUNTNUMBER                 
      ,ACCOUNT_EXTID                 
      ,ACCOUNT_ID                    
      ,ACCPAC_CODES                  
      ,BANK_ACCOUNT_NUMBER           
      ,CASHFLOW_RATE_TYPE            
      ,CATEGORY_1099_MISC            
      ,CATEGORY_1099_MISC_MTHRESHOLD 
      ,CLASS_ID                      
      ,LINE_OF_BUSINESS              
      ,CURRENCY_ID                   
      ,CURRENCY_NAME                 
      ,DATE_LAST_MODIFIED            
      ,DEFERRAL_ACCOUNT_ID           
      ,DEPARTMENT_ID                 
      ,COST_CENTER_NAME              
      ,DESCRIPTION                   
      ,FULL_DESCRIPTION              
      ,FULL_NAME                     
      ,GENERAL_RATE_TYPE             
      ,HYPERION_CODES                
      ,ISINACTIVE                    
      ,IS_BALANCESHEET               
      ,IS_INCLUDED_IN_ELIMINATION    
      ,IS_INCLUDED_IN_REVAL          
      ,IS_LEFTSIDE                   
      ,IS_SUMMARY                    
      ,LOCATION_ID                   
      ,LOCATION_NAME                 
      ,NAME                          
      ,OPENBALANCE                   
      ,PARENT_ID                     
      ,PARENT_ACCOUNT_NAME           
      ,PARENT_ACCOUNT_NUMBER         
      ,TYPE_NAME                     
      ,TYPE_SEQUENCE                 
 from dw_prestage.accounts_insert;

/* stage ->insert into stage records which have been updated */
insert into dw_stage.accounts (ACCOUNTNUMBER                 
                              ,ACCOUNT_EXTID                 
                              ,ACCOUNT_ID                    
                              ,ACCPAC_CODES                  
                              ,BANK_ACCOUNT_NUMBER           
                              ,CASHFLOW_RATE_TYPE            
                              ,CATEGORY_1099_MISC            
                              ,CATEGORY_1099_MISC_MTHRESHOLD 
                              ,CLASS_ID                      
                              ,LINE_OF_BUSINESS              
                              ,CURRENCY_ID                   
                              ,CURRENCY_NAME                 
                              ,DATE_LAST_MODIFIED            
                              ,DEFERRAL_ACCOUNT_ID           
                              ,DEPARTMENT_ID                 
                              ,COST_CENTER_NAME              
                              ,DESCRIPTION                   
                              ,FULL_DESCRIPTION              
                              ,FULL_NAME                     
                              ,GENERAL_RATE_TYPE             
                              ,HYPERION_CODES                
                              ,ISINACTIVE                    
                              ,IS_BALANCESHEET               
                              ,IS_INCLUDED_IN_ELIMINATION    
                              ,IS_INCLUDED_IN_REVAL          
                              ,IS_LEFTSIDE                   
                              ,IS_SUMMARY                    
                              ,LOCATION_ID                   
                              ,LOCATION_NAME                 
                              ,NAME                          
                              ,OPENBALANCE                   
                              ,PARENT_ID                     
                              ,PARENT_ACCOUNT_NAME           
                              ,PARENT_ACCOUNT_NUMBER         
                              ,TYPE_NAME                     
                              ,TYPE_SEQUENCE                 
                               )
select ACCOUNTNUMBER                 
      ,ACCOUNT_EXTID                 
      ,ACCOUNT_ID                    
      ,ACCPAC_CODES                  
      ,BANK_ACCOUNT_NUMBER           
      ,CASHFLOW_RATE_TYPE            
      ,CATEGORY_1099_MISC            
      ,CATEGORY_1099_MISC_MTHRESHOLD 
      ,CLASS_ID                      
      ,LINE_OF_BUSINESS              
      ,CURRENCY_ID                   
      ,CURRENCY_NAME                 
      ,DATE_LAST_MODIFIED            
      ,DEFERRAL_ACCOUNT_ID           
      ,DEPARTMENT_ID                 
      ,COST_CENTER_NAME              
      ,DESCRIPTION                   
      ,FULL_DESCRIPTION              
      ,FULL_NAME                     
      ,GENERAL_RATE_TYPE             
      ,HYPERION_CODES                
      ,ISINACTIVE                    
      ,IS_BALANCESHEET               
      ,IS_INCLUDED_IN_ELIMINATION    
      ,IS_INCLUDED_IN_REVAL          
      ,IS_LEFTSIDE                   
      ,IS_SUMMARY                    
      ,LOCATION_ID                   
      ,LOCATION_NAME                 
      ,NAME                          
      ,OPENBALANCE                   
      ,PARENT_ID                     
      ,PARENT_ACCOUNT_NAME           
      ,PARENT_ACCOUNT_NUMBER         
      ,TYPE_NAME                     
      ,TYPE_SEQUENCE   
  from dw_prestage.accounts
where exists ( select 1 from 
dw_prestage.accounts_update
where dw_prestage.accounts_update.account_id = dw_prestage.accounts.account_id);

commit;


/* dimension ->insert new records in dim accounts */

insert into dw.accounts ( 
 ACCOUNT_ID           
,NAME                 
,ACCOUNTNUMBER        
,ACCOUNT_EXTID        
,ACCPAC_CODES         
,BANK_ACCOUNT_NUMBER  
,CASHFLOW_RATE_TYPE   
,CLASS_ID             
,LINE_OF_BUSINESS     
,CURRENCY_ID          
,CURRENCY_NAME        
,DEFERRAL_ACCOUNT_ID  
,DEPARTMENT_ID        
,COST_CENTER_NAME     
,DESCRIPTION          
,GENERAL_RATE_TYPE    
,HYPERION_CODES       
,ISINACTIVE           
,LOCATION_ID          
,LOCATION_NAME        
,PARENT_ID            
,PARENT_ACCOUNT_NAME  
,PARENT_ACCOUNT_NUMBER
,DATE_ACTIVE_FROM     
,DATE_ACTIVE_TO       
,DW_ACTIVE            
     )
select 
  NVL(A.ACCOUNT_ID,-99) AS ACCOUNT_ID
 ,DECODE(LENGTH(A.NAME),0,'NA_GDW',A.NAME) AS NAME
 ,DECODE(LENGTH(A.ACCOUNTNUMBER),0,'NA_GDW',A.ACCOUNTNUMBER) AS ACCOUNTNUMBER
 ,DECODE(LENGTH(A.ACCOUNT_EXTID),0,'NA_GDW',A.ACCOUNT_EXTID) AS ACCOUNT_EXTID
 ,DECODE(LENGTH(A.ACCPAC_CODES),0,'NA_GDW',A.ACCPAC_CODES) AS ACCPAC_CODES
 ,DECODE(LENGTH(A.BANK_ACCOUNT_NUMBER),0,'NA_GDW',A.BANK_ACCOUNT_NUMBER) AS BANK_ACCOUNT_NUMBER
 ,DECODE(LENGTH(A.CASHFLOW_RATE_TYPE ),0,'NA_GDW',A.CASHFLOW_RATE_TYPE ) AS CASHFLOW_RATE_TYPE 
 ,NVL(A.CLASS_ID         ,-99) AS CLASS_ID       
 ,DECODE(LENGTH(A.LINE_OF_BUSINESS ),0,'NA_GDW',A.LINE_OF_BUSINESS ) AS LINE_OF_BUSINESS
 ,NVL(A.CURRENCY_ID      ,-99) AS CURRENCY_ID      
 ,DECODE(LENGTH(A.CURRENCY_NAME    ),0,'NA_GDW',A.CURRENCY_NAME    ) AS CURRENCY_NAME   
 ,NVL(A.DEFERRAL_ACCOUNT_ID ,-99) AS DEFERRAL_ACCOUNT_ID 
 ,NVL(A.DEPARTMENT_ID       ,-99) AS DEPARTMENT_ID       
 ,DECODE(LENGTH(A.COST_CENTER_NAME    ),0,'NA_GDW',A.COST_CENTER_NAME    ) AS COST_CENTER_NAME     
 ,DECODE(LENGTH(A.DESCRIPTION         ),0,'NA_GDW',A.DESCRIPTION         ) AS DESCRIPTION          
 ,DECODE(LENGTH(A.GENERAL_RATE_TYPE ),0,'NA_GDW',A.GENERAL_RATE_TYPE ) AS GENERAL_RATE_TYPE  
 ,DECODE(LENGTH(A.HYPERION_CODES    ),0,'NA_GDW',A.HYPERION_CODES    ) AS HYPERION_CODES     
 ,DECODE(LENGTH(A.ISINACTIVE        ),0,'NA_GDW',A.ISINACTIVE        ) AS ISINACTIVE         
 ,NVL(A.LOCATION_ID    ,-99) AS LOCATION_ID    
 ,DECODE(LENGTH(A.LOCATION_NAME  ),0,'NA_GDW',A.LOCATION_NAME  ) AS LOCATION_NAME   
 ,NVL(A.PARENT_ID,-99) AS PARENT_ID
 ,DECODE(LENGTH(A.PARENT_ACCOUNT_NAME),0,'NA_GDW',A.PARENT_ACCOUNT_NAME) AS PARENT_ACCOUNT_NAME
 ,DECODE(LENGTH(A.PARENT_ACCOUNT_NUMBER),0,'NA_GDW',A.PARENT_ACCOUNT_NUMBER) AS PARENT_ACCOUNT_NUMBER  
 ,sysdate     
 ,'9999-12-31 23:59:59'  
 ,'A'
from 
dw_prestage.accounts_insert A;

/* dimension ->update old record as part of SCD2 maintenance*/

UPDATE dw.accounts
   SET dw_active = 'I' ,
	   DATE_ACTIVE_TO = (sysdate -1)
WHERE dw_active = 'A'
      and sysdate >= date_active_from and sysdate < date_active_to
	  and exists ( select 1 from dw_prestage.accounts_update
	  WHERE dw.accounts.account_id = dw_prestage.accounts_update.account_id
	  and dw_prestage.accounts_update.ch_type = 2);

/* dimension ->insert the new records as part of SCD2 maintenance*/

insert into dw.accounts ( 
 ACCOUNT_ID           
,NAME                 
,ACCOUNTNUMBER        
,ACCOUNT_EXTID        
,ACCPAC_CODES         
,BANK_ACCOUNT_NUMBER  
,CASHFLOW_RATE_TYPE   
,CLASS_ID             
,LINE_OF_BUSINESS     
,CURRENCY_ID          
,CURRENCY_NAME        
,DEFERRAL_ACCOUNT_ID  
,DEPARTMENT_ID        
,COST_CENTER_NAME     
,DESCRIPTION          
,GENERAL_RATE_TYPE    
,HYPERION_CODES       
,ISINACTIVE           
,LOCATION_ID          
,LOCATION_NAME        
,PARENT_ID            
,PARENT_ACCOUNT_NAME  
,PARENT_ACCOUNT_NUMBER
,DATE_ACTIVE_FROM     
,DATE_ACTIVE_TO       
,DW_ACTIVE          )
select 
NVL(A.ACCOUNT_ID,-99) AS ACCOUNT_ID
 ,DECODE(LENGTH(A.NAME),0,'NA_GDW',A.NAME) AS NAME
 ,DECODE(LENGTH(A.ACCOUNTNUMBER),0,'NA_GDW',A.ACCOUNTNUMBER) AS ACCOUNTNUMBER
 ,DECODE(LENGTH(A.ACCOUNT_EXTID),0,'NA_GDW',A.ACCOUNT_EXTID) AS ACCOUNT_EXTID
 ,DECODE(LENGTH(A.ACCPAC_CODES),0,'NA_GDW',A.ACCPAC_CODES) AS ACCPAC_CODES
 ,DECODE(LENGTH(A.BANK_ACCOUNT_NUMBER),0,'NA_GDW',A.BANK_ACCOUNT_NUMBER) AS BANK_ACCOUNT_NUMBER
 ,DECODE(LENGTH(A.CASHFLOW_RATE_TYPE ),0,'NA_GDW',A.CASHFLOW_RATE_TYPE ) AS CASHFLOW_RATE_TYPE 
 ,NVL(A.CLASS_ID         ,-99) AS CLASS_ID       
 ,DECODE(LENGTH(A.LINE_OF_BUSINESS ),0,'NA_GDW',A.LINE_OF_BUSINESS ) AS LINE_OF_BUSINESS
 ,NVL(A.CURRENCY_ID      ,-99) AS CURRENCY_ID      
 ,DECODE(LENGTH(A.CURRENCY_NAME    ),0,'NA_GDW',A.CURRENCY_NAME    ) AS CURRENCY_NAME   
 ,NVL(A.DEFERRAL_ACCOUNT_ID ,-99) AS DEFERRAL_ACCOUNT_ID 
 ,NVL(A.DEPARTMENT_ID       ,-99) AS DEPARTMENT_ID       
 ,DECODE(LENGTH(A.COST_CENTER_NAME    ),0,'NA_GDW',A.COST_CENTER_NAME    ) AS COST_CENTER_NAME     
 ,DECODE(LENGTH(A.DESCRIPTION         ),0,'NA_GDW',A.DESCRIPTION         ) AS DESCRIPTION          
 ,DECODE(LENGTH(A.GENERAL_RATE_TYPE ),0,'NA_GDW',A.GENERAL_RATE_TYPE ) AS GENERAL_RATE_TYPE  
 ,DECODE(LENGTH(A.HYPERION_CODES    ),0,'NA_GDW',A.HYPERION_CODES    ) AS HYPERION_CODES     
 ,DECODE(LENGTH(A.ISINACTIVE        ),0,'NA_GDW',A.ISINACTIVE        ) AS ISINACTIVE         
 ,NVL(A.LOCATION_ID    ,-99) AS LOCATION_ID    
 ,DECODE(LENGTH(A.LOCATION_NAME  ),0,'NA_GDW',A.LOCATION_NAME  ) AS LOCATION_NAME   
 ,NVL(A.PARENT_ID,-99) AS PARENT_ID
 ,DECODE(LENGTH(A.PARENT_ACCOUNT_NAME),0,'NA_GDW',A.PARENT_ACCOUNT_NAME) AS PARENT_ACCOUNT_NAME
 ,DECODE(LENGTH(A.PARENT_ACCOUNT_NUMBER),0,'NA_GDW',A.PARENT_ACCOUNT_NUMBER) AS PARENT_ACCOUNT_NUMBER 
 ,sysdate
 ,'9999-12-31 23:59:59'
 ,'A'
from 
dw_prestage.accounts A
WHERE exists (select 1 from dw_prestage.accounts_update
	  WHERE a.account_id = dw_prestage.accounts_update.account_id
	  and dw_prestage.accounts_update.ch_type = 2) ;
	  
/* dimension -> update records as part of SCD1 maintenance */

UPDATE dw.accounts
   SET  NAME = NVL(dw_prestage.accounts.NAME,'NA_GDW'),
        ACCOUNTNUMBER = NVL(dw_prestage.accounts.ACCOUNTNUMBER,'NA_GDW'),
        ACCOUNT_EXTID = NVL(dw_prestage.accounts.ACCOUNT_EXTID,'NA_GDW'),
        ACCPAC_CODES = NVL(dw_prestage.accounts.ACCPAC_CODES,'NA_GDW'),
        BANK_ACCOUNT_NUMBER = NVL(dw_prestage.accounts.BANK_ACCOUNT_NUMBER,'NA_GDW'),
        CASHFLOW_RATE_TYPE  = NVL(dw_prestage.accounts.CASHFLOW_RATE_TYPE ,'NA_GDW'),
        DEFERRAL_ACCOUNT_ID  = NVL(dw_prestage.accounts.DEFERRAL_ACCOUNT_ID ,-99),
        DESCRIPTION          = NVL(dw_prestage.accounts.DESCRIPTION         ,'NA_GDW'),
        GENERAL_RATE_TYPE  = NVL(dw_prestage.accounts.GENERAL_RATE_TYPE ,'NA_GDW'),
        HYPERION_CODES     = NVL(dw_prestage.accounts.HYPERION_CODES    ,'NA_GDW'),
        ISINACTIVE         = NVL(dw_prestage.accounts.ISINACTIVE        ,'NA_GDW')
FROM dw_prestage.accounts
WHERE dw.accounts.account_id = dw_prestage.accounts.account_id
and exists (select 1 from dw_prestage.accounts_update
	  WHERE dw_prestage.accounts.account_id = dw_prestage.accounts_update.account_id
	  and dw_prestage.accounts_update.ch_type = 1);

/* dimension ->logically delete dw records */
update dw.accounts
set DATE_ACTIVE_TO = sysdate-1,
dw_active = 'I'
FROM dw_prestage.accounts_delete
WHERE dw.accounts.account_id = dw_prestage.accounts_delete.account_id;
