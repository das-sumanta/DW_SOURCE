SELECT TO_CHAR(a.SALES_TERRITORY_CUSTOM_ID) AS TERRITORY_ID,
       a.SALES_TERRITORY_CUSTOM_NAME AS TERRITORY,
       a.subsidiary_id AS subsidiary_id,
       b.name AS subsidiary,
       a.is_inactive
FROM sales_territory_custom a,
     subsidiaries b
WHERE a.subsidiary_id = 27
AND   a.subsidiary_id = b.subsidiary_id;

