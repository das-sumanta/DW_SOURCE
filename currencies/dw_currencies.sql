create schema if not exists dw ;

drop table if exists dw.currencies;

create table dw.currencies
(
 CURRENCY_KEY           BIGINT IDENTITY(0,1)
,CURRENCY_ID            INTEGER 
,CURRENCY_EXTID	        VARCHAR(255) 
,ISINACTIVE             VARCHAR(3)
,NAME                   VARCHAR(105)  
,PRECISION              DECIMAL(2,0)
,DATE_ACTIVE_FROM       TIMESTAMP
,DATE_ACTIVE_TO         TIMESTAMP
,DW_ACTIVE              VARCHAR(1)
,SYMBOL                 VARCHAR(6) 
,PRIMARY KEY ( CURRENCY_KEY , CURRENCY_ID) )
DISTSTYLE ALL
COMPOUND SORTKEY (CURRENCY_KEY , CURRENCY_ID , DW_ACTIVE); 

insert into dw.currencies
( CURRENCY_ID       
,CURRENCY_EXTID	   
,ISINACTIVE        
,NAME              
,PRECISION      
,DATE_ACTIVE_FROM  
,DATE_ACTIVE_TO    
,DW_ACTIVE         
,SYMBOL )
select -99 as CURRENCY_ID,
       'NA_GDW' as CURRENCY_EXTID,
 	   'No' as ISINACTIVE,
	   'NA_GDW' as NAME,
     '0' as PRECISION,
       SYSDATE AS DATE_ACTIVE_FROM ,
       '9999-12-31 23:59:59' AS DATE_ACTIVE_TO,
       'A' as dw_active,
       'NA_GDW' as SYMBOL;
	   
insert into dw.currencies
( CURRENCY_ID       
,CURRENCY_EXTID	   
,ISINACTIVE        
,NAME              
,PRECISION      
,DATE_ACTIVE_FROM  
,DATE_ACTIVE_TO    
,DW_ACTIVE         
,SYMBOL )
select 0 as CURRENCY_ID,
       'NA_ERR' as CURRENCY_EXTID,
 	   'No' as ISINACTIVE,
	   'NA_ERR' as NAME,
     '0' as PRECISION,
       SYSDATE AS DATE_ACTIVE_FROM ,
       '9999-12-31 23:59:59' AS DATE_ACTIVE_TO,
       'A' as dw_active,
       'NA_ERR' as SYMBOL;
	   
commit;
