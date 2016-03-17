SELECT 
TO_CHAR(a.CUSTOMER_ID) AS CUSTOMER_ID,
a.CUSTOMER_EXTID,
a.LEGACY_CUSTOMER_IDCUSTOM ,
a.NAME,
a.EMAIL,
to_char(a.CREDITLIMIT) as CREDITLIMIT,
REPLACE(REPLACE(a.LINE1,CHR (10),' '),CHR (13),' ') AS ADDRESS_LINE1,
REPLACE(REPLACE(a.LINE2,CHR (10),' '),CHR (13),' ') AS ADDRESS_LINE2,
REPLACE(REPLACE(a.LINE3,CHR (10),' '),CHR (13),' ') AS ADDRESS_LINE3,
REPLACE(REPLACE(a.ZIPCODE,CHR (10),' '),CHR (13),' ') AS ZIPCODE,
REPLACE(REPLACE(a.CITY,CHR (10),' '),CHR (13),' ') AS CITY,
REPLACE(REPLACE(a.STATE,CHR (10),' '),CHR (13),' ') AS STATE,
b.name as COUNTRY,
a.companyname ,
c.name as CURRENCY,
to_char(c.currency_id) as currency_id,
a.ISINACTIVE ,
DECODE(a.IS_PERSON,'No','Company','Individual') AS CUSTOMER_TYPE,
d.name as LINE_OF_BUSINESS,
to_char(d.class_id) as class_id, 
e.name as SUBSIDIARY,
to_char(e.subsidiary_id) as SUBSIDIARY_ID,
f.name as CUSTOMER_CATEGORY,
g.name as PAYMENT_TERMS,
to_char(g.payment_terms_id) as payment_terms_id,
j.name as PARENT,
to_char(j.customer_id) as parent_id,
h.title as TERRITORY,
to_char(k.list_id) ABCDO_MARKER_ID,
k.list_item_name ABCDO_MARKER,
to_char(l.decile_id) decile_id,
l.decile_name decile,
to_char(a.roll_size) roll_size
FROM 
CUSTOMERS	a
LEFT OUTER JOIN countries b ON (CUSTOMERS.country = countries.short_name)
LEFT OUTER JOIN currencies c ON (CUSTOMERS.currency_id = currencies.currency_id)
LEFT OUTER JOIN classes d ON (CUSTOMERS.line_of_business_id = classes.class_id)
LEFT OUTER JOIN subsidiaries e ON (CUSTOMERS.subsidiary_id = subsidiaries.subsidiary_id)
LEFT OUTER JOIN customer_types f ON (CUSTOMERS.customer_type_id = customer_types.customer_type_id)
LEFT OUTER JOIN payment_terms g ON (CUSTOMERS.payment_terms_id = payment_terms.payment_terms_id)
LEFT OUTER JOIN crmgroup h ON (CUSTOMERS.sales_rep_id = crmgroup.group_id)
LEFT OUTER JOIN customers j ON (CUSTOMERS.parent_id = j.customer_id)
LEFT OUTER JOIN BOOK_FAIR_ABCDO_MARKER_LIST k ON (CUSTOMERS.abcdo_marker_id = k.list_id)
LEFT OUTER JOIN DECILE l ON (CUSTOMERS.decile_id = l.decile_id)
WHERE a.CATEGORY_0 = 'CUSTOMER' 
ORDER BY a.CUSTOMER_ID , a.NAME;
