/* stage -> truncate stage table */ 
TRUNCATE TABLE dw_stage.ITEM_GROUP;

/* stage -> Insert in stage table */
insert into dw_stage.item_group
(
  ITEM_GROUP_ID     
 ,BOM_QUANTITY      
 ,COMPONENT_YIELD   
 ,EFFECTIVE_DATE    
 ,EFFECTIVE_REVISION
 ,LINE_ID           
 ,MEMBER_ID         
 ,OBSOLETE_DATE     
 ,OBSOLETE_REVISION 
 ,PARENT_ID         
 ,QUANTITY          
 ,RATE_PLAN_ID      
)
select 
  ITEM_GROUP_ID     
 ,BOM_QUANTITY      
 ,COMPONENT_YIELD   
 ,EFFECTIVE_DATE    
 ,EFFECTIVE_REVISION
 ,LINE_ID           
 ,MEMBER_ID         
 ,OBSOLETE_DATE     
 ,OBSOLETE_REVISION 
 ,PARENT_ID         
 ,QUANTITY          
 ,RATE_PLAN_ID 
 from
dw_prestage.item_group; 

/* dimension bridge -> truncate dw bridge table */
TRUNCATE TABLE dw.ITEM_GROUP; 

/* dimension bridge -> Insert in dim bridge table */
insert into dw.item_group
(
  ITEM_GROUP_ID      
  ,BOM_QUANTITY       
  ,COMPONENT_YIELD    
  ,EFFECTIVE_DATE     
  ,EFFECTIVE_REVISION 
  ,LINE_ID            
  ,MEMBER_ID          
  ,MEMBER_KEY         
  ,OBSOLETE_DATE      
  ,OBSOLETE_REVISION  
  ,PARENT_ID          
  ,PARENT_KEY         
  ,QUANTITY           
  ,RATE_PLAN_ID       
  ,DATE_ACTIVE_FROM   
  ,DATE_ACTIVE_TO     
  ,DW_ACTIVE          
)
select 
   a.ITEM_GROUP_ID      
  ,a.BOM_QUANTITY       
  ,a.COMPONENT_YIELD    
  ,a.EFFECTIVE_DATE     
  ,a.EFFECTIVE_REVISION 
  ,a.LINE_ID            
  ,a.MEMBER_ID          
  ,b.ITEM_KEY MEMBER_KEY         
  ,a.OBSOLETE_DATE      
  ,a.OBSOLETE_REVISION  
  ,a.PARENT_ID          
  ,c.item_key PARENT_KEY         
  ,a.QUANTITY           
  ,a.RATE_PLAN_ID
  ,sysdate
  ,'9999-12-31 23:59:59'
  ,'A'     
 from
dw_stage.item_group a
INNER JOIN DW_REPORT.ITEMS b ON (a.member_id = b.item_id )  
INNER JOIN DW_REPORT.ITEMS c ON (a.parent_id = c.item_id )
; 

/* prestage -> no of prestage item group records  */ 
SELECT count(1) FROM dw_prestage.item_group;

/* stage -> no of stage item group records */ 
SELECT count(1) FROM dw_stage.item_group;

/* dimension bridge -> no of dw item group records */ 
SELECT count(1) FROM dw.item_group;
      