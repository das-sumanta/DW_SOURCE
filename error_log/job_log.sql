CREATE TABLE `job_log` 
(
  `job_id`              mediumint(9) NOT NULL AUTO_INCREMENT,
  `runid`               INT(11) DEFAULT NULL,
  `entity`              VARCHAR(500) DEFAULT NULL,
  `run_mode`            VARCHAR(100) DEFAULT NULL,
  `ExtractStart`        TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ExtractEnd`          TIMESTAMP NULL,
  `S3LoadStart`         TIMESTAMP NULL,
  `S3LoadEnd`           TIMESTAMP NULL,
  `RedShiftLoadStart`   TIMESTAMP NULL,
  `RedShiftLoadEnd`     TIMESTAMP NULL,
  `job_status`          VARCHAR(500) DEFAULT NULL,
  PRIMARY KEY (`job_id`)
);

