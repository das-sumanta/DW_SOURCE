create schema if not exists dw ;

drop table if exists dw.vendors;

create table dw.vendors
(VENDOR_KEY         Bigint identity(0,1)      
,VENDOR_ID          INTEGER 
,VENDOR_EXTID       VARCHAR(500)
,NAME               VARCHAR(83) 
,EMAIL              VARCHAR(500)
,FULL_NAME          VARCHAR(1800)
,BILLADDRESS        VARCHAR(999) 
,SHIPADDRESS        VARCHAR(999) 
,ACCOUNTNUMBER      VARCHAR(100) 
,LINE1              VARCHAR(200) 
,LINE2              VARCHAR(200) 
,LINE3              VARCHAR(200)
,ZIPCODE            VARCHAR(100) 
,CITY               VARCHAR(50)  
,STATE              VARCHAR(60)  
,COUNTRY            VARCHAR(60)  
,COMPANYNAME        VARCHAR(90)  
,CURRENCY           VARCHAR(110) 
,CURRENCY_ID        INTEGER  
,EFT_BILL_PAYMENT   VARCHAR(6)   
,IS1099ELIGIBLE     VARCHAR(6)   
,ISINACTIVE         VARCHAR(10)  
,TYPE               VARCHAR(10)  
,LINE_OF_BUSINESS   VARCHAR(50)      
,LINE_OF_BUSINESS_ID  INTEGER
,SUBSIDIARY_NAME    VARCHAR(83)
,SUBSIDIARY_ID      INTEGER  
,VENDOR_TYPE        VARCHAR(83)  
,DATE_ACTIVE_FROM   TIMESTAMP    
,DATE_ACTIVE_TO     TIMESTAMP    
,DW_ACTIVE          VARCHAR(1)   
,PRIMARY KEY ( VENDOR_KEY , VENDOR_ID) )
DISTSTYLE ALL
INTERLEAVED SORTKEY (VENDOR_KEY , VENDOR_ID , DW_ACTIVE);


insert into dw.vendors
( 
VENDOR_ID         
,VENDOR_EXTID      
,NAME              
,EMAIL             
,FULL_NAME         
,BILLADDRESS       
,SHIPADDRESS       
,ACCOUNTNUMBER     
,LINE1             
,LINE2             
,LINE3             
,ZIPCODE           
,CITY              
,STATE             
,COUNTRY           
,COMPANYNAME       
,CURRENCY          
,CURRENCY_ID       
,EFT_BILL_PAYMENT  
,IS1099ELIGIBLE    
,ISINACTIVE        
,TYPE              
,LINE_OF_BUSINESS  
,LINE_OF_BUSINESS_ID
,SUBSIDIARY_NAME        
,SUBSIDIARY_ID     
,VENDOR_TYPE       
,DATE_ACTIVE_FROM  
,DATE_ACTIVE_TO    
,DW_ACTIVE         
 )
select -99 as VENDOR_ID
        ,'NA_GDW'   as VENDOR_EXTID
        ,'NA_GDW'   as NAME
        ,'NA_GDW'   as EMAIL
        ,'NA_GDW'   as FULL_NAME
        ,'NA_GDW'   as BILLADDRESS
        ,'NA_GDW'   as SHIPADDRESS
        ,'NA_GDW'   as ACCOUNTNUMBER
        ,'NA_GDW'   as LINE1
        ,'NA_GDW'   as LINE2
        ,'NA_GDW'   as LINE3
        ,'NA_GDW'   as ZIPCODE
        ,'NA_GDW'   as CITY
        ,'NA_GDW'   as STATE
        ,'NA_GDW'   as COUNTRY
        ,'NA_GDW'   as COMPANYNAME
        ,'NA_GDW'   as CURRENCY
        ,-99   as CURRENCY_ID
        ,'NA_GDW'   as EFT_BILL_PAYMENT
        ,'NA_GDW'   as IS1099ELIGIBLE
        ,'No'  as ISINACTIVE
        ,'NA_GDW'   as TYPE
        ,'NA_GDW'   as LINE_OF_BUSINESS
		,-99        as LINE_OF_BUSINESS_ID
        ,'NA_GDW'   as SUBSIDIARY_NAME
        ,-99   as SUBSIDIARY_ID
        ,'NA_GDW'   as VENDOR_TYPE
        ,sysdate   as DATE_ACTIVE_FROM
        ,'9999-12-31 23:59:59'   as DATE_ACTIVE_TO
        ,'A'  as DW_ACTIVE ;

insert into dw.vendors
( 
VENDOR_ID         
,VENDOR_EXTID      
,NAME              
,EMAIL             
,FULL_NAME         
,BILLADDRESS       
,SHIPADDRESS       
,ACCOUNTNUMBER     
,LINE1             
,LINE2             
,LINE3             
,ZIPCODE           
,CITY              
,STATE             
,COUNTRY           
,COMPANYNAME       
,CURRENCY          
,CURRENCY_ID       
,EFT_BILL_PAYMENT  
,IS1099ELIGIBLE    
,ISINACTIVE        
,TYPE              
,LINE_OF_BUSINESS
,LINE_OF_BUSINESS_ID  
,SUBSIDIARY_NAME        
,SUBSIDIARY_ID     
,VENDOR_TYPE       
,DATE_ACTIVE_FROM  
,DATE_ACTIVE_TO    
,DW_ACTIVE         
 )
 select  0 as VENDOR_ID
        ,'NA_ERR'   as VENDOR_EXTID
        ,'NA_ERR'   as NAME
        ,'NA_ERR'   as EMAIL
        ,'NA_ERR'   as FULL_NAME
        ,'NA_ERR'   as BILLADDRESS
        ,'NA_ERR'   as SHIPADDRESS
        ,'NA_ERR'   as ACCOUNTNUMBER
        ,'NA_ERR'   as LINE1
        ,'NA_ERR'   as LINE2
        ,'NA_ERR'   as LINE3
        ,'NA_ERR'   as ZIPCODE
        ,'NA_ERR'   as CITY
        ,'NA_ERR'   as STATE
        ,'NA_ERR'   as COUNTRY
        ,'NA_ERR'   as COMPANYNAME
        ,'NA_ERR'   as CURRENCY
        ,0   as CURRENCY_ID
        ,'NA_ERR'   as EFT_BILL_PAYMENT
        ,'NA_ERR'   as IS1099ELIGIBLE
        ,'No'  as ISINACTIVE
        ,'NA_ERR'   as TYPE
        ,'NA_ERR'   as LINE_OF_BUSINESS
		, 0         as LINE_OF_BUSINESS_ID
        ,'NA_ERR'   as SUBSIDIARY_NAME
        ,0   as SUBSIDIARY_ID
        ,'NA_ERR'   as VENDOR_TYPE
        ,sysdate   as DATE_ACTIVE_FROM
        ,'9999-12-31 23:59:59'   as DATE_ACTIVE_TO
        ,'A'  as DW_ACTIVE ;	   

		commit;
		
		
