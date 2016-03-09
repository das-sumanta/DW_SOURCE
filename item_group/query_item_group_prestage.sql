SELECT 
 BOM_QUANTITY 
,COMPONENT_YIELD 
,EFFECTIVE_DATE 
,EFFECTIVE_REVISION 
,TO_CHAR(ITEM_GROUP_ID)  ITEM_GROUP_ID
,TO_CHAR(LINE_ID) LINE_ID 
,TO_CHAR(MEMBER_ID) MEMBER_ID
,OBSOLETE_DATE 
,OBSOLETE_REVISION 
,TO_CHAR(PARENT_ID) PARENT_ID
,QUANTITY 
,TO_CHAR(RATE_PLAN_ID) RATE_PLAN_ID
FROM
ITEM_GROUP
ORDER BY PARENT_ID,MEMBER_ID;