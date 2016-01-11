CREATE TABLE `message_log` 
(
  `message_id`          mediumint(9) NOT NULL AUTO_INCREMENT,
  `runid`               INT(11) DEFAULT NULL,
  `message_desc`        VARCHAR(4000) DEFAULT NULL,
  `target_table`        VARCHAR(100) DEFAULT NULL,
  `message_stage`       VARCHAR(100) DEFAULT NULL,
  `message_type`        VARCHAR(50) DEFAULT NULL,
  `message_timestamp`   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`message_id`)
);


