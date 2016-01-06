CREATE SCHEMA if not exists dw_stage;

DROP TABLE if exists dw_stage.territories;

CREATE TABLE dw_stage.territories 
(
  TERRITORY_ID               INTEGER,      
  TERRITORY                  VARCHAR(100), 
  SUBSIDIARY                 VARCHAR(100), 
  SUBSIDIARY_ID              INTEGER,      
  IS_INACTIVE                 VARCHAR(10)  
);


