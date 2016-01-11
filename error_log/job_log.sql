CREATE TABLE `job_log` 
(
  `job_id`              mediumint(9) NOT NULL AUTO_INCREMENT,
  `runid`               INT(11) DEFAULT NULL,
  `entity`              VARCHAR(500) DEFAULT NULL,
  `run_mode`            VARCHAR(100) DEFAULT NULL,
  `ExtractStart`        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ExtractEnd`          TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00',
  `S3LoadStart`         TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00',
  `S3LoadEnd`           TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00',
  `RedShiftLoadStart`   TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00',
  `RedShiftLoadEnd`     TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00',
  `job_status`          VARCHAR(500) DEFAULT NULL,
  PRIMARY KEY (`job_id`)
);

