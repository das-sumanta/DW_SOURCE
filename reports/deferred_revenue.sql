SELECT b.clublevelreading_level_name,
       d.customer_extid,
       d.companyname,
       c.product_catalogue_year,
       c.offer_description,
       TO_CHAR(TO_DATE(c.yearmonth_yyyymm,'yyyymm'),'dd/mm/yyyy') release_date,
       e.calendar_week_number release_week,
       e.fiscal_year,
       e.fiscal_month_number,
       a.amortization_value_excl_gst nett_value
FROM dw.standing_order_schedule_fact A,
     dw.product_catalogue b,
     (SELECT clublevelreading_level_name,
             yearmonth_yyyymm,
             product_catalogue_year,
             offer_description
      FROM dw.product_catalogue
      WHERE line_of_business = 'Standing Orders') c,
     dw_report.customers d,
     dw.dwdate e
WHERE /*a.customer_key = 50964
AND   */a.PRODUCT_CATALOGUE_key = b.PRODUCT_CATALOGUE_key
AND   b.clublevelreading_level_name = c.clublevelreading_level_name
AND   a.customer_key = d.customer_key
AND   c.yearmonth_yyyymm|| '01' = e.date_id
AND   NVL (a.shipment_no,1) = 1
AND   a.order_type = 'SUB';


SELECT b.clublevelreading_level_name,
       d.customer_extid,
       d.companyname,
       c.product_catalogue_year,
       c.offer_description,
       TO_CHAR(TO_DATE(c.yearmonth_yyyymm,'yyyymm'),'dd/mm/yyyy') release_date,
       e.calendar_week_number release_week,
       e.fiscal_year,
       e.fiscal_month_number,
       a.amortization_value_excl_gst nett_value
FROM dw.standing_order_schedule_fact_A A,
     dw.product_catalogue b,
     (SELECT clublevelreading_level_name,
             yearmonth_yyyymm,
             product_catalogue_year,
             offer_description
      FROM dw.product_catalogue
      WHERE line_of_business = 'Standing Orders') c,
     dw_report.customers d,
     dw.dwdate e,
     dw.dwdate f
WHERE /*a.customer_key = 50964
AND   */  a.PRODUCT_CATALOGUE_key = b.PRODUCT_CATALOGUE_key
AND   b.clublevelreading_level_name = c.clublevelreading_level_name
AND   a.customer_key = d.customer_key
AND   c.yearmonth_yyyymm|| '01' = e.date_id
AND   f.date_key = a.sto_start_date_key
AND   c.yearmonth_yyyymm >= CAST(TO_CHAR(TO_DATE(f.date_id,'YYYYMMDD'),'YYYYMM') AS INTEGER)
AND   NVL (a.shipment_no,1) = 1
AND   a.order_type = 'SUB'