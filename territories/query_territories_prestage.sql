SELECT TO_CHAR(a.SALES_TERRITORY_CUSTOM_ID) AS TERRITORY_ID,
       a.SALES_TERRITORY_CUSTOM_NAME AS TERRITORY,
       b.name AS subsidiary,
       to_char(a.subsidiary_id) AS subsidiary_id,
       a.is_inactive
     FROM sales_territory_custom a,
     subsidiaries b
WHERE a.subsidiary_id = b.subsidiary_id
AND IS_INACTIVE = 'F'
ORDER BY a.SALES_TERRITORY_CUSTOM_ID,a.SALES_TERRITORY_CUSTOM_NAME;

