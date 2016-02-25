/* prestage - drop intermediate insert table */
drop table if exists dw_prestage.product_catalogue_insert;

/* prestage - create intermediate insert table*/
create table dw_prestage.product_catalogue_insert
as
select * from dw_prestage.product_catalogue
where exists ( select 1 from  
(select product_catalogue_id from 
(select product_catalogue_id from dw_prestage.product_catalogue
minus
select product_catalogue_id from dw_stage.product_catalogue )) a
where  dw_prestage.product_catalogue.product_catalogue_id = a.product_catalogue_id );

/* prestage - drop intermediate update table*/
drop table if exists dw_prestage.product_catalogue_update;

/* prestage - create intermediate update table*/
create table dw_prestage.product_catalogue_update
as
select decode(sum(ch_type),3,2,sum(ch_type)) ch_type ,product_catalogue_id
from
(
SELECT product_catalogue_id , CH_TYPE FROM 
(  
select product_catalogue_id , CLUBLEVELREADING_LEVEL_ID,ISSUEOFFERMONTH_ID,LINE_OF_BUSINESS_ID,SUBSIDIARY_ID, '2' CH_TYPE from dw_prestage.product_catalogue
MINUS
select product_catalogue_id , CLUBLEVELREADING_LEVEL_ID,ISSUEOFFERMONTH_ID,LINE_OF_BUSINESS_ID,SUBSIDIARY_ID, '2' CH_TYPE from dw_stage.product_catalogue
)
union all
SELECT product_catalogue_id , CH_TYPE FROM 
(  
select product_catalogue_id,PRODUCT_CATALOGUE_NAME,IN_MARKET_END_DATE,IN_MARKET_START_DATE,IS_INACTIVE,NO__OF_BOOKS_IN_OFFER_BIH_O_ID,OFFER_DESCRIPTION,YEARMONTH_YYYYMM,YEARMONTH_YYYYMM__REMOVE,YEAR_ID,PRODUCT_CATALOGUE_YEAR, '1' CH_TYPE from dw_prestage.product_catalogue
MINUS
select product_catalogue_id,PRODUCT_CATALOGUE_NAME,IN_MARKET_END_DATE,IN_MARKET_START_DATE,IS_INACTIVE,NO__OF_BOOKS_IN_OFFER_BIH_O_ID,OFFER_DESCRIPTION,YEARMONTH_YYYYMM,YEARMONTH_YYYYMM__REMOVE,YEAR_ID,PRODUCT_CATALOGUE_YEAR, '1' CH_TYPE from dw_stage.product_catalogue
)
) a where not exists ( select 1 from dw_prestage.product_catalogue_insert
where dw_prestage.product_catalogue_insert.product_catalogue_id = a.product_catalogue_id) group by product_catalogue_id;

/* prestage - drop intermediate delete table*/
drop table if exists dw_prestage.product_catalogue_delete;

/* prestage - create intermediate delete table*/
create table dw_prestage.product_catalogue_delete
as
select * from dw_stage.product_catalogue
where exists ( select 1 from  
(select product_catalogue_id from 
(select product_catalogue_id from dw_stage.product_catalogue
minus
select product_catalogue_id from dw_prestage.product_catalogue )) a
where dw_stage.product_catalogue.product_catalogue_id = a.product_catalogue_id );

/* prestage-> no of prestage product_catalogue records identified to inserted*/
select count(1) from  dw_prestage.product_catalogue_insert;

/* prestage-> no of prestage product_catalogue records identified to updated*/
select count(1) from  dw_prestage.product_catalogue_update;

/* prestage-> no of prestage product_catalogue records identified to deleted*/
select count(1) from  dw_prestage.product_catalogue_delete;

/* stage -> delete from stage records to be updated */
delete from dw_stage.product_catalogue 
using dw_prestage.product_catalogue_update
where dw_stage.product_catalogue.product_catalogue_id = dw_prestage.product_catalogue_update.product_catalogue_id;

/* stage -> delete from stage records which have been deleted */
delete from dw_stage.product_catalogue 
using dw_prestage.product_catalogue_delete
where dw_stage.product_catalogue.product_catalogue_id = dw_prestage.product_catalogue_delete.product_catalogue_id;

/* stage -> insert into stage records which have been created */
insert into dw_stage.product_catalogue(PRODUCT_CATALOGUE_ID,PRODUCT_CATALOGUE_NAME,	CLUBLEVELREADING_LEVEL_ID,	CLUBLEVELREADING_LEVEL_NAME,	DATE_CREATED,	IN_MARKET_END_DATE  ,	IN_MARKET_START_DATE,	ISSUEOFFERMONTH_ID  ,	ISSUEOFFERMONTH_NAME,	ISSUEOFFERMONTH_DESC,	IS_INACTIVE         ,	LAST_MODIFIED_DATE  ,	LINE_OF_BUSINESS_ID ,	LINE_OF_BUSINESS    ,	NO__OF_BOOKS_IN_OFFER_BIH_O_ID  ,	OFFER_DESCRIPTION   ,	SUBSIDIARY_ID       ,	SUBSIDIARY          ,	YEARMONTH_YYYYMM    ,	YEARMONTH_YYYYMM__REMOVE        ,	YEAR_ID ,	PRODUCT_CATALOGUE_YEAR ) 
select PRODUCT_CATALOGUE_ID,PRODUCT_CATALOGUE_NAME,	CLUBLEVELREADING_LEVEL_ID,	CLUBLEVELREADING_LEVEL_NAME,	DATE_CREATED,	IN_MARKET_END_DATE  ,	IN_MARKET_START_DATE,	ISSUEOFFERMONTH_ID  ,	ISSUEOFFERMONTH_NAME,	ISSUEOFFERMONTH_DESC,	IS_INACTIVE         ,	LAST_MODIFIED_DATE  ,	LINE_OF_BUSINESS_ID ,	LINE_OF_BUSINESS    ,	NO__OF_BOOKS_IN_OFFER_BIH_O_ID  ,	OFFER_DESCRIPTION   ,	SUBSIDIARY_ID       ,	SUBSIDIARY          ,	YEARMONTH_YYYYMM    ,	YEARMONTH_YYYYMM__REMOVE        ,	YEAR_ID ,	PRODUCT_CATALOGUE_YEAR  from dw_prestage.product_catalogue_insert;

/* stage -> insert into stage records which have been updated */
insert into dw_stage.product_catalogue (PRODUCT_CATALOGUE_ID,PRODUCT_CATALOGUE_NAME,	CLUBLEVELREADING_LEVEL_ID,	CLUBLEVELREADING_LEVEL_NAME,	DATE_CREATED,	IN_MARKET_END_DATE  ,	IN_MARKET_START_DATE,	ISSUEOFFERMONTH_ID  ,	ISSUEOFFERMONTH_NAME,	ISSUEOFFERMONTH_DESC,	IS_INACTIVE         ,	LAST_MODIFIED_DATE  ,	LINE_OF_BUSINESS_ID ,	LINE_OF_BUSINESS    ,	NO__OF_BOOKS_IN_OFFER_BIH_O_ID  ,	OFFER_DESCRIPTION   ,	SUBSIDIARY_ID       ,	SUBSIDIARY          ,	YEARMONTH_YYYYMM    ,	YEARMONTH_YYYYMM__REMOVE        ,	YEAR_ID ,	PRODUCT_CATALOGUE_YEAR )
select PRODUCT_CATALOGUE_ID,PRODUCT_CATALOGUE_NAME,	CLUBLEVELREADING_LEVEL_ID,	CLUBLEVELREADING_LEVEL_NAME,	DATE_CREATED,	IN_MARKET_END_DATE  ,	IN_MARKET_START_DATE,	ISSUEOFFERMONTH_ID  ,	ISSUEOFFERMONTH_NAME,	ISSUEOFFERMONTH_DESC,	IS_INACTIVE         ,	LAST_MODIFIED_DATE  ,	LINE_OF_BUSINESS_ID ,	LINE_OF_BUSINESS    ,	NO__OF_BOOKS_IN_OFFER_BIH_O_ID  ,	OFFER_DESCRIPTION   ,	SUBSIDIARY_ID       ,	SUBSIDIARY          ,	YEARMONTH_YYYYMM    ,	YEARMONTH_YYYYMM__REMOVE        ,	YEAR_ID ,	PRODUCT_CATALOGUE_YEAR  from dw_prestage.product_catalogue
where exists ( select 1 from 
dw_prestage.product_catalogue_update
where dw_prestage.product_catalogue_update.product_catalogue_id = dw_prestage.product_catalogue.product_catalogue_id);

/* dimension ->insert new records in dim product_catalogue */

insert into dw.product_catalogue ( 
      product_catalogue_ID           
     ,PRODUCT_CATALOGUE_NAME         
     ,CLUBLEVELREADING_LEVEL_NAME    
     ,IN_MARKET_END_DATE             
     ,IN_MARKET_START_DATE           
     ,ISSUEOFFERMONTH_NAME           
     ,ISSUEOFFERMONTH_DESC           
     ,IS_INACTIVE                    
     ,LINE_OF_BUSINESS               
     ,NO__OF_BOOKS_IN_OFFER_BIH_O_ID 
     ,OFFER_DESCRIPTION              
     ,SUBSIDIARY                     
     ,YEARMONTH_YYYYMM               
     ,YEARMONTH_YYYYMM__REMOVE       
     ,PRODUCT_CATALOGUE_YEAR         
     ,DATE_ACTIVE_FROM               
     ,DATE_ACTIVE_TO                 
     ,DW_ACTIVE                      )
select 
 product_catalogue_id
 ,DECODE(LENGTH(PRODUCT_CATALOGUE_NAME),0,'NA_GDW',PRODUCT_CATALOGUE_NAME)
 ,DECODE(LENGTH(CLUBLEVELREADING_LEVEL_NAME),0,'NA_GDW',CLUBLEVELREADING_LEVEL_NAME )         
 ,NVL(IN_MARKET_END_DATE,'1900-12-31 00:00:00')       
 ,NVL(IN_MARKET_START_DATE,'1900-12-31 00:00:00') 
 ,DECODE(LENGTH(ISSUEOFFERMONTH_NAME),0,'NA_GDW',ISSUEOFFERMONTH_NAME )         
 ,DECODE(LENGTH(ISSUEOFFERMONTH_DESC),0,'NA_GDW',ISSUEOFFERMONTH_DESC )         
 ,DECODE(LENGTH(IS_INACTIVE),0,'NA_GDW',IS_INACTIVE )         
 ,DECODE(LENGTH(LINE_OF_BUSINESS),0,'NA_GDW',LINE_OF_BUSINESS )         
 ,NVL(NO__OF_BOOKS_IN_OFFER_BIH_O_ID , -99)  
 ,DECODE(LENGTH(OFFER_DESCRIPTION),0,'NA_GDW', OFFER_DESCRIPTION  )         
 ,DECODE(LENGTH(SUBSIDIARY),0,'NA_GDW', SUBSIDIARY)          
 ,NVL(YEARMONTH_YYYYMM , -99) 
 ,NVL(YEARMONTH_YYYYMM__REMOVE , -99)
 ,DECODE(LENGTH(PRODUCT_CATALOGUE_YEAR),0,'NA_GDW',PRODUCT_CATALOGUE_YEAR )            
 ,sysdate
 ,'9999-12-31 23:59:59'
 ,'A'
  from 
dw_prestage.product_catalogue_insert A;

/* dimension -> update old record as part of SCD2 maintenance*/

UPDATE dw.product_catalogue
   SET dw_active = 'I' ,
	   DATE_ACTIVE_TO = (sysdate -1)
WHERE dw_active = 'A'
      and sysdate >= date_active_from and sysdate < date_active_to
	  and exists ( select 1 from dw_prestage.product_catalogue_update
	  WHERE dw.product_catalogue.product_catalogue_id = dw_prestage.product_catalogue_update.product_catalogue_id
	  and dw_prestage.product_catalogue_update.ch_type = 2);

/* dimension -> insert the new records as part of SCD2 maintenance*/

insert into dw.product_catalogue ( 
         product_catalogue_ID           
     ,PRODUCT_CATALOGUE_NAME         
     ,CLUBLEVELREADING_LEVEL_NAME    
     ,IN_MARKET_END_DATE             
     ,IN_MARKET_START_DATE           
     ,ISSUEOFFERMONTH_NAME           
     ,ISSUEOFFERMONTH_DESC           
     ,IS_INACTIVE                    
     ,LINE_OF_BUSINESS               
     ,NO__OF_BOOKS_IN_OFFER_BIH_O_ID 
     ,OFFER_DESCRIPTION              
     ,SUBSIDIARY                     
     ,YEARMONTH_YYYYMM               
     ,YEARMONTH_YYYYMM__REMOVE       
     ,PRODUCT_CATALOGUE_YEAR         
     ,DATE_ACTIVE_FROM               
     ,DATE_ACTIVE_TO                 
     ,DW_ACTIVE     )
select 
 product_catalogue_id
 ,DECODE(LENGTH(PRODUCT_CATALOGUE_NAME),0,'NA_GDW',PRODUCT_CATALOGUE_NAME)
 ,DECODE(LENGTH(CLUBLEVELREADING_LEVEL_NAME),0,'NA_GDW',CLUBLEVELREADING_LEVEL_NAME )         
 ,NVL(IN_MARKET_END_DATE,'1900-12-31 00:00:00')       
 ,NVL(IN_MARKET_START_DATE,'1900-12-31 00:00:00') 
 ,DECODE(LENGTH(ISSUEOFFERMONTH_NAME),0,'NA_GDW',ISSUEOFFERMONTH_NAME )         
 ,DECODE(LENGTH(ISSUEOFFERMONTH_DESC),0,'NA_GDW',ISSUEOFFERMONTH_DESC )         
 ,DECODE(LENGTH(IS_INACTIVE),0,'NA_GDW',IS_INACTIVE )         
 ,DECODE(LENGTH(LINE_OF_BUSINESS),0,'NA_GDW',LINE_OF_BUSINESS )         
 ,NVL(NO__OF_BOOKS_IN_OFFER_BIH_O_ID , -99)  
 ,DECODE(LENGTH(OFFER_DESCRIPTION),0,'NA_GDW', OFFER_DESCRIPTION  )         
 ,DECODE(LENGTH(SUBSIDIARY),0,'NA_GDW', SUBSIDIARY)          
 ,NVL(YEARMONTH_YYYYMM , -99) 
 ,NVL(YEARMONTH_YYYYMM__REMOVE , -99)
 ,DECODE(LENGTH(PRODUCT_CATALOGUE_YEAR),0,'NA_GDW',PRODUCT_CATALOGUE_YEAR )            
 ,sysdate
 ,'9999-12-31 23:59:59'
 ,'A'
from 
dw_prestage.product_catalogue A
WHERE exists (select 1 from dw_prestage.product_catalogue_update
	  WHERE a.product_catalogue_id = dw_prestage.product_catalogue_update.product_catalogue_id
	  and dw_prestage.product_catalogue_update.ch_type = 2) ;
	  
/* dimension -> update records as part of SCD1 maintenance */

UPDATE dw.product_catalogue 
   SET  
       PRODUCT_CATALOGUE_NAME          =   DECODE(LENGTH(dw_prestage.product_catalogue.PRODUCT_CATALOGUE_NAME),0,'NA_GDW', dw_prestage.product_catalogue.PRODUCT_CATALOGUE_NAME )    
      ,IN_MARKET_END_DATE              =   NVL(dw_prestage.product_catalogue.IN_MARKET_END_DATE,'1900-12-31 00:00:00')   
      ,IN_MARKET_START_DATE            =   NVL(dw_prestage.product_catalogue.IN_MARKET_START_DATE,'1900-12-31 00:00:00')   
      ,IS_INACTIVE                     =   DECODE(LENGTH(dw_prestage.product_catalogue.IS_INACTIVE),0,'NA_GDW', dw_prestage.product_catalogue.IS_INACTIVE  )
      ,NO__OF_BOOKS_IN_OFFER_BIH_O_ID  =   NVL(dw_prestage.product_catalogue.NO__OF_BOOKS_IN_OFFER_BIH_O_ID ,-99)  
      ,OFFER_DESCRIPTION               =   DECODE(LENGTH(dw_prestage.product_catalogue.OFFER_DESCRIPTION),0,'NA_GDW', dw_prestage.product_catalogue.OFFER_DESCRIPTION)       
      ,YEARMONTH_YYYYMM                =   NVL(dw_prestage.product_catalogue.YEARMONTH_YYYYMM ,-99)  
      ,YEARMONTH_YYYYMM__REMOVE        =   NVL(dw_prestage.product_catalogue.YEARMONTH_YYYYMM__REMOVE ,-99)  
      ,PRODUCT_CATALOGUE_YEAR          =   DECODE(LENGTH(dw_prestage.product_catalogue.PRODUCT_CATALOGUE_YEAR),0,'NA_GDW',dw_prestage.product_catalogue.PRODUCT_CATALOGUE_YEAR)
   FROM dw_prestage.product_catalogue
WHERE dw.product_catalogue.product_catalogue_id = dw_prestage.product_catalogue.product_catalogue_id
and exists (select 1 from dw_prestage.product_catalogue_update
	  WHERE dw_prestage.product_catalogue.product_catalogue_id = dw_prestage.product_catalogue_update.product_catalogue_id
	  and dw_prestage.product_catalogue_update.ch_type = 1);

/* dimension -> logically delete dw records */
update dw.product_catalogue
set DATE_ACTIVE_TO = sysdate-1,
dw_active = 'I'
FROM dw_prestage.product_catalogue_delete
WHERE dw.product_catalogue.product_catalogue_id = dw_prestage.product_catalogue_delete.product_catalogue_id;
