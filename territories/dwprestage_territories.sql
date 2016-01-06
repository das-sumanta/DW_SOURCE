CREATE SCHEMA if not exists dw_prestage;

DROP TABLE if exists dw_prestage.territories;

CREATE TABLE dw_prestage.territories 
(
  RUNID                      INTEGER,
  TERRITORY_ID               INTEGER,
  TERRITORY                  VARCHAR(100),
  SUBSIDIARY                 VARCHAR(100),
  SUBSIDIARY_ID              INTEGER,
  IS_INACTIVE                 VARCHAR(10)
  );


