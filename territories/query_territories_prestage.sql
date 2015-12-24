SELECT 
TO_CHAR(a.GROUP_ID) AS TERRITORY_ID,
a.TITLE AS TERRITORY,
'27' as subsidiary_id,
'Scholastic New Zealand Limited' as subsidiary
from
crmgroup a
WHERE a.IS_SALES_GROUP = 'Yes';

