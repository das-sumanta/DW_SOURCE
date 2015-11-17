SELECT b.account_id,
       b.amount,
       b.amount_foreign,
       b.company_id,
       b.item_count,
       b.item_unit_price,
       b.landed_cost_source_line_id,
       b.memo,
       b.net_amount,
       b.net_amount_foreign,
       b.quantity_received_in_shipment,
       b.track_landed_cost,
       b.is_landed_cost,
       b.transaction_id,
       b.transaction_line_id,
       b.item_id,
       b.subsidiary_id,
       land_cost.freight_cost,
       land_cost.pre_pub_cost,
       land_cost.reproduction_cost,
       land_cost.shipment_cost,
       land_cost.tax,
       /*decode(b.account_id, 115 , 'IR-HDR',decode(NVL(B.item_count,-1),-1,'FRT-ITM','IR-LINE')) LINE_TYPE*/  CASE
         WHEN transaction_line_id = 0 AND b.item_id IS NULL THEN 'IR-HDR'
         WHEN b.item_count IS NOT NULL AND b.item_unit_price IS NOT NULL AND b.quantity_received_in_shipment IS NOT NULL AND b.item_count >= 0 THEN 'IR-LINE'
         WHEN b.is_landed_cost = 'Yes' THEN 'FRT-ITM'
       END
FROM transaction_lines b 
     INNER JOIN transactions a ON ( a.transaction_id = b.transaction_id )
     LEFT OUTER JOIN (SELECT SUM(frt_cost) AS freight_cost,
       SUM(pub_cost) AS pre_pub_cost,
       SUM(rep_cost) AS reproduction_cost,
       SUM(shp_cost) AS shipment_cost,
       SUM(tax) AS tax,
       transaction_id,
       landed_cost_source_line_id
FROM (SELECT b.transaction_id,
             b.landed_cost_source_line_id,
             CASE
               WHEN b.memo LIKE '%Freight Cost%' THEN b.amount
               ELSE 0
             END AS frt_cost,
             CASE
               WHEN b.memo LIKE '%Pre-Pub%' THEN b.amount
               ELSE 0
             END AS pub_cost,
             CASE
               WHEN b.memo LIKE '%Reproduction Cost%' THEN b.amount
               ELSE 0
             END AS rep_cost,
             CASE
               WHEN b.memo LIKE '%Shipping Charge%' THEN b.amount
               ELSE 0
             END AS shp_cost,
             CASE
               WHEN b.memo LIKE '%Tax%' THEN b.amount
               ELSE 0
             END AS tax
      FROM transactions a,
           transaction_lines b
      WHERE a.transaction_type = 'Item Receipt'
      AND   a.date_last_modified >= '2015-06-01 00:00:00'
      AND   a.transaction_id = b.transaction_id
      AND   a.created_from_id = 378175
      AND   (transaction_line_id <> 0 AND b.item_id IS NOT NULL)
      AND   (b.item_count IS NULL AND b.item_unit_price IS NULL AND b.quantity_received_in_shipment IS NULL AND b.item_count IS NULL)
      AND   (b.is_landed_cost = 'Yes' AND b.amount >= 0))
GROUP BY transaction_id,
         landed_cost_source_line_id
/*ORDER BY transaction_id,
         landed_cost_source_line_id */ ) land_cost ON ( b.transaction_id = land_cost.transaction_id AND b.transaction_line_id = land_cost.landed_cost_source_line_id )
WHERE a.transaction_type = 'Item Receipt'
AND   a.date_last_modified >= '2015-06-01 00:00:00' 
and a.created_from_id = 378175
AND   EXISTS (SELECT 1
              FROM transactions c
              WHERE c.transaction_id = a.created_from_id
              AND   c.transaction_type = 'Purchase Order')
ORDER BY a.transaction_id,
         b.transaction_line_id