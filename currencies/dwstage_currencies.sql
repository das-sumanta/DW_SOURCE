create schema if not exists dw_stage ;

drop table if exists dw_stage.currencies;

create table dw_stage.currencies
(
 CURRENCY_EXTID	VARCHAR(255)
,CURRENCY_ID	INTEGER
,DATE_LAST_MODIFIED	TIMESTAMP
,IS_INACTIVE	VARCHAR(3)
,NAME	VARCHAR(105)
,PRECISION_0	DECIMAL(1,0)
,SYMBOL	VARCHAR(4),
PRIMARY KEY (CURRENCY_ID,NAME)
)
DISTSTYLE ALL INTERLEAVED SORTKEY (CURRENCY_ID,NAME);







