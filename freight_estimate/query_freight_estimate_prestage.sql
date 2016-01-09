SELECT 
       TO_CHAR(LANDED_COST_RULE_MATRIX_NZ.LANDED_COST_RULE_MATRIX_NZ_ID) AS LANDED_COST_RULE_MATRIX_NZ_ID,
       REPLACE(REPLACE(LANDED_COST_RULE_MATRIX_NZ.LANDED_COST_RULE_MATRIX_NZ_NAM,CHR (10),' '),CHR (13),' ') AS LANDED_COST_RULE_MATRIX_NZ_NAM,
       REPLACE(REPLACE(LANDED_COST_RULE_MATRIX_NZ.DESCRIPTION,CHR (10),' '),CHR (13),' ') AS DESCRIPTION,
       IS_INACTIVE,
       PERCENT_OF_COST,
       PLUS_AMOUNT,
       TO_CHAR(LANDED_COST_RULE_MATRIX_NZ.SUBSIDIARY_ID) AS SUBSIDIARY_ID,
       SUBSIDIARIES.NAME AS SUBSIDIARY,
       TO_CHAR(LANDED_COST_RULE_MATRIX_NZ.DATE_CREATED,'YYYY-MM-DD HH24:MI:SS') AS DATE_CREATED,
       TO_CHAR(LANDED_COST_RULE_MATRIX_NZ.LAST_MODIFIED_DATE,'YYYY-MM-DD HH24:MI:SS') AS LAST_MODIFIED_DATE
FROM LANDED_COST_RULE_MATRIX_NZ,
     SUBSIDIARIES
WHERE LANDED_COST_RULE_MATRIX_NZ.SUBSIDIARY_ID = SUBSIDIARIES.SUBSIDIARY_ID (+);
