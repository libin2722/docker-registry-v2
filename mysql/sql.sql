CREATE DATABASE IF NOT EXISTS domeos;
CREATE DATABASE IF NOT EXISTS graph;
CREATE DATABASE IF NOT EXISTS portal;
USE domeos;
CREATE TABLE IF NOT EXISTS `admin_roles` (
  `userId` INT(11) NOT NULL PRIMARY KEY,
  `role` VARCHAR(255) NOT NULL DEFAULT '0'
)ENGINE=INNODB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `build_history` (
  `id` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(255) NOT NULL,
  `description` VARCHAR(1024) NULL DEFAULT NULL,
  `state` VARCHAR(128) NOT NULL,
  `createTime` BIGINT(20) NOT NULL DEFAULT '0',
  `removeTime` BIGINT(20) NULL DEFAULT NULL,
  `removed` TINYINT(4) NOT NULL DEFAULT '0',
  `data` MEDIUMTEXT NULL,
  `projectId` INT(11) NOT NULL,
  `secret` VARCHAR(255) NOT NULL,
  `log` LONGBLOB NULL,
  `taskName` VARCHAR(255) NULL DEFAULT NULL,
  `dockerfileContent` MEDIUMTEXT NULL
)ENGINE=INNODB DEFAULT CHARSET=utf8;
CREATE INDEX `build_history_name` ON build_history(`name`);
CREATE INDEX `build_history_projectId` ON build_history(`projectId`);

CREATE TABLE IF NOT EXISTS `gitlab_user` (
  `id` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `userId` INT(11) NOT NULL DEFAULT '0',
  `name` VARCHAR(255) NOT NULL COMMENT 'username in gitlab',
  `token` VARCHAR(255) NOT NULL,
  `createTime` BIGINT(20) NOT NULL DEFAULT '0'
)ENGINE=INNODB DEFAULT CHARSET=utf8;
CREATE INDEX `gitlab_user_userId` ON gitlab_user(`userId`);

CREATE TABLE IF NOT EXISTS `groups` (
  `id` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(255) NOT NULL COMMENT 'group name',
  `description` VARCHAR(255) NULL DEFAULT NULL,
  `createTime` BIGINT(20) NULL DEFAULT NULL,
  `updateTime` BIGINT(20) NULL DEFAULT NULL,
  `state` INT(11) NULL DEFAULT '1'
)ENGINE=INNODB DEFAULT CHARSET=utf8;
CREATE INDEX `groups_name` ON groups(`name`);

CREATE TABLE IF NOT EXISTS `operation_history` (
  `id` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `resourceId` INT(11) NOT NULL,
  `resourceType` VARCHAR(255) NOT NULL,
  `operation` VARCHAR(255) NOT NULL,
  `userId` INT(11) NOT NULL,
  `userName` VARCHAR(255) NOT NULL,
  `status` VARCHAR(255) NOT NULL,
  `message` MEDIUMTEXT NOT NULL,
  `operateTime` BIGINT(20) NOT NULL
)ENGINE=INNODB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `project` (
  `id` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(255) NOT NULL,
  `description` VARCHAR(1024) NULL DEFAULT NULL,
  `state` VARCHAR(128) NOT NULL,
  `createTime` BIGINT(20) NULL DEFAULT NULL,
  `removeTime` BIGINT(20) NULL DEFAULT NULL,
  `removed` TINYINT(4) NOT NULL DEFAULT '0',
  `data` MEDIUMTEXT NULL,
  `authority` TINYINT(4) NOT NULL DEFAULT '0'
)ENGINE=INNODB DEFAULT CHARSET=utf8;
CREATE INDEX `project_name` ON project(`name`);
CREATE INDEX `project_authority` ON project(`authority`);

CREATE TABLE IF NOT EXISTS `project_rsakey_map` (
  `id` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `projectId` INT(11) NOT NULL,
  `rsaKeypairId` INT(11) NOT NULL,
  `keyId` INT(11) NOT NULL,
  `state` VARCHAR(128) NOT NULL,
  `createTime` BIGINT(20) NOT NULL DEFAULT '0'
)ENGINE=INNODB DEFAULT CHARSET=utf8;
CREATE INDEX `project_rsakey_map_projectId` ON project_rsakey_map(`projectId`);
CREATE INDEX `project_rsakey_map_rsaKeypairId` ON project_rsakey_map(`rsaKeypairId`);

CREATE TABLE IF NOT EXISTS `resources` (
  `id` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `resourceId` INT(11) NOT NULL COMMENT 'projectId or deployId',
  `resourceType` VARCHAR(255) NOT NULL COMMENT 'PROJECT or DEPLOY or CLUSTER',
  `ownerId` INT(11) NOT NULL COMMENT 'userId or groupId',
  `ownerType` VARCHAR(255) NOT NULL COMMENT 'USER or GROUP',
  `role` VARCHAR(255) NOT NULL COMMENT 'role name',
  `updateTime` BIGINT(20) NULL DEFAULT NULL
)ENGINE=INNODB DEFAULT CHARSET=utf8;
CREATE INDEX `resources_resourceType` ON resources(`resourceType`);
CREATE INDEX `resources_resourceId` ON resources(`resourceId`);
CREATE INDEX `resources_ownerId` ON resources(`ownerId`);
CREATE INDEX `resources_ownerType` ON resources(`ownerType`);

CREATE TABLE IF NOT EXISTS `rsa_keypair` (
  `id` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(255) NOT NULL,
  `description` VARCHAR(1024) NULL DEFAULT NULL,
  `state` VARCHAR(128) NOT NULL,
  `createTime` BIGINT(20) NOT NULL DEFAULT '0',
  `removeTime` BIGINT(20) NULL DEFAULT NULL,
  `removed` TINYINT(4) NOT NULL DEFAULT '0',
  `data` MEDIUMTEXT NULL,
  `authority` INT(11) NOT NULL DEFAULT '0'
)ENGINE=INNODB DEFAULT CHARSET=utf8;
CREATE INDEX `rsa_keypair_name` ON rsa_keypair(`name`);

CREATE TABLE IF NOT EXISTS `subversion_user` (
  `id` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `userId` INT(11) NOT NULL DEFAULT '0',
  `name` VARCHAR(255) NOT NULL COMMENT 'username in subversion',
  `password` VARCHAR(255) NOT NULL,
  `svnPath` VARCHAR(255) NOT NULL,
  `createTime` BIGINT(20) NOT NULL DEFAULT '0'
)ENGINE=INNODB DEFAULT CHARSET=utf8;
CREATE INDEX `subversion_user_userId` ON subversion_user(`userId`);

CREATE TABLE IF NOT EXISTS `users` (
  `id` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `username` VARCHAR(255) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `salt` VARCHAR(255) NULL DEFAULT NULL,
  `email` VARCHAR(255) NULL DEFAULT NULL,
  `phone` VARCHAR(255) NULL DEFAULT NULL,
  `loginType` VARCHAR(255) NOT NULL,
  `createTime` BIGINT(20) NOT NULL DEFAULT '0',
  `updateTime` BIGINT(20) NOT NULL DEFAULT '0',
  `state` VARCHAR(128) NULL DEFAULT NULL
)ENGINE=INNODB DEFAULT CHARSET=utf8;
CREATE INDEX `users_state` ON users(`state`);
CREATE INDEX `users_username` ON users(`username`);

CREATE TABLE IF NOT EXISTS `user_group_map` (
  `id` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `groupId` INT(11) NOT NULL,
  `userId` INT(11) NOT NULL,
  `role` VARCHAR(255) NOT NULL COMMENT 'role name',
  `updateTime` BIGINT(20) NULL DEFAULT NULL
)ENGINE=INNODB DEFAULT CHARSET=utf8;
CREATE INDEX `user_group_map_userId` ON user_group_map(`userId`);
CREATE INDEX `user_group_map_groupId` ON user_group_map(`groupId`);

CREATE TABLE IF NOT EXISTS `deployment` (
  `id` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(255) NOT NULL,
  `description` VARCHAR(1024) NULL DEFAULT NULL,
  `state` VARCHAR(128) NOT NULL,
  `createTime` BIGINT(20) NOT NULL DEFAULT '0',
  `removeTime` BIGINT(20) NULL DEFAULT NULL,
  `removed` TINYINT(4) NOT NULL DEFAULT '0',
  `data` MEDIUMTEXT NULL,
  `clusterId` INT(11) DEFAULT NULL
)ENGINE=INNODB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `version` (
  `id` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(255) NOT NULL,
  `description` VARCHAR(1024) DEFAULT NULL,
  `state` VARCHAR(128) NOT NULL,
  `createTime` BIGINT(20) DEFAULT NULL,
  `removeTime` BIGINT(20) DEFAULT NULL,
  `removed` TINYINT(4) NOT NULL DEFAULT '0',
  `data` MEDIUMTEXT NULL,
  `deployId` INT(11) DEFAULT NULL,
  `version` BIGINT(20) DEFAULT NULL
)ENGINE=INNODB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `cluster` (
  `id` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(255) NOT NULL,
  `description` VARCHAR(1024) DEFAULT NULL,
  `state` VARCHAR(128) NOT NULL,
  `createTime` BIGINT(20) DEFAULT NULL,
  `removeTime` BIGINT(20) DEFAULT NULL,
  `removed` TINYINT(4) NOT NULL DEFAULT '0',
  `data` MEDIUMTEXT NULL
)ENGINE=INNODB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `load_balancer` (
  `id` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(255) NOT NULL,
  `description` VARCHAR(1024) DEFAULT NULL,
  `state` VARCHAR(128) NOT NULL,
  `createTime` BIGINT(20) DEFAULT NULL,
  `removeTime` BIGINT(20) DEFAULT NULL,
  `removed` TINYINT(4) NOT NULL DEFAULT '0',
  `data` MEDIUMTEXT
)ENGINE=INNODB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `load_balancer_deploy_map` (
  `id` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(255) NOT NULL,
  `description` VARCHAR(1024) DEFAULT NULL,
  `state` VARCHAR(128) NOT NULL,
  `createTime` BIGINT(20) DEFAULT NULL,
  `removeTime` BIGINT(20) DEFAULT NULL,
  `removed` TINYINT(4) NOT NULL DEFAULT '0',
  `data` MEDIUMTEXT,
  `deployId` INT(11) DEFAULT NULL,
  `loadBalancerId` INT(11) DEFAULT NULL
)ENGINE=INNODB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `uniq_port_index` (
  `id` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `lbid` INT(11) NOT NULL,
  `port` INT(11) NOT NULL,
  `clusterId` INT(11) NOT NULL
)ENGINE=INNODB DEFAULT CHARSET=utf8;
CREATE UNIQUE INDEX `uniq_port_index_cluster_port` ON uniq_port_index(`port`, `clusterId`);

CREATE TABLE IF NOT EXISTS `file_content` (
  `id` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(255) NOT NULL,
  `description` VARCHAR(1024) NULL DEFAULT NULL,
  `state` VARCHAR(128) NOT NULL,
  `createTime` BIGINT(20) NOT NULL DEFAULT '0',
  `removeTime` BIGINT(20) NULL DEFAULT NULL,
  `removed` TINYINT(4) NOT NULL DEFAULT '0',
  `data` MEDIUMTEXT NULL,
  `md5` VARCHAR(255) NOT NULL DEFAULT '0',
  `content` LONGBLOB NOT NULL
)ENGINE=INNODB DEFAULT CHARSET=utf8;
CREATE INDEX `file_content_name` ON file_content(`name`);
CREATE INDEX `file_content_md5` ON file_content(`md5`);

CREATE TABLE IF NOT EXISTS `base_image_custom` (
  `id` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(255) NOT NULL,
  `description` VARCHAR(1024) NULL DEFAULT NULL,
  `state` VARCHAR(128) NOT NULL,
  `createTime` BIGINT(20) NOT NULL DEFAULT '0',
  `removeTime` BIGINT(20) NULL DEFAULT NULL,
  `removed` TINYINT(4) NOT NULL DEFAULT '0',
  `data` MEDIUMTEXT NULL,
  `isGC` INT(11) NULL DEFAULT '0',
  `logMD5` VARCHAR(255) NULL DEFAULT NULL
)ENGINE=INNODB DEFAULT CHARSET=utf8;
CREATE INDEX `base_image_custom_name` ON base_image_custom(`name`);

CREATE TABLE IF NOT EXISTS `base_images` (
  `id` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `imageName` VARCHAR(255) NOT NULL DEFAULT '0',
  `imageTag` VARCHAR(255) NULL DEFAULT '0',
  `registry` VARCHAR(255) NULL DEFAULT '0',
  `description` TEXT NULL
)ENGINE=INNODB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `global` (
  `id` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `type` VARCHAR(255) NOT NULL,
  `value` VARCHAR(4096) NOT NULL,
  `createTime` BIGINT(20) NOT NULL DEFAULT '0',
  `lastUpdate` BIGINT(20) NOT NULL DEFAULT '0'
)ENGINE=INNODB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `monitor_targets` (
  `id` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `target` VARCHAR(10240) NULL DEFAULT NULL,
  `create_time` DATETIME NULL DEFAULT NULL
)ENGINE=INNODB DEFAULT CHARSET=utf8;

 CREATE TABLE IF NOT EXISTS `k8s_events` (
   `id` INT(20) NOT NULL AUTO_INCREMENT PRIMARY KEY,
   `version` VARCHAR(255) NOT NULL,
   `clusterId` INT(11) NOT NULL,
   `deployId` INT(11) NOT NULL DEFAULT -1,
   `namespace` VARCHAR(255) NOT NULL,
   `eventKind` VARCHAR(255) NOT NULL,
   `name` VARCHAR(255) NOT NULL,
   `host` VARCHAR(255),
   `content` TEXT
 ) ENGINE=INNODB DEFAULT CHARSET=utf8;
CREATE INDEX `k8s_events_kind_index` ON k8s_events(`clusterId`, `namespace`, `eventKind`);
CREATE INDEX `k8s_events_name_index` ON k8s_events(`clusterId`, `namespace`, `name`);
CREATE INDEX `k8s_events_host_index` ON k8s_events(`host`);
CREATE INDEX `k8s_events_deploy_index` ON k8s_events(`clusterId`, `namespace`, `deployId`);

 CREATE TABLE IF NOT EXISTS `deploy_event` (
  `eid` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `deployId` INT(11) DEFAULT NULL,
  `operation` VARCHAR(255) DEFAULT NULL,
  `eventStatus` VARCHAR(255) DEFAULT NULL,
  `statusExpire` BIGINT(20) DEFAULT NULL,
  `content` MEDIUMTEXT NULL
) ENGINE=INNODB DEFAULT CHARSET=utf8;

-- alarm related tables: 11 in total
-- 2016.04.14

-- alarm event info
CREATE TABLE IF NOT EXISTS `alarm_event_info_draft` (
  `id` VARCHAR(64) NOT NULL PRIMARY KEY,
  `endpoint` VARCHAR(128) NULL DEFAULT NULL,
  `metric` VARCHAR(128) NULL DEFAULT NULL,
  `counter` VARCHAR(128) NULL DEFAULT NULL,
  `func` VARCHAR(128) NULL DEFAULT NULL,
  `left_value` VARCHAR(128) NULL DEFAULT NULL,
  `operator` VARCHAR(128) NULL DEFAULT NULL,
  `right_value` VARCHAR(128) NULL DEFAULT NULL,
  `note` VARCHAR(4096) NULL DEFAULT NULL,
  `max_step` INT(20) NULL DEFAULT NULL,
  `current_step` INT(20) NULL DEFAULT NULL,
  `priority` INT(20) NULL DEFAULT NULL,
  `status` VARCHAR(128) NULL DEFAULT NULL,
  `timestamp` INT(20) NULL DEFAULT NULL,
  `expression_id` INT(20) NULL DEFAULT NULL,
  `strategy_id` INT(20) NULL DEFAULT NULL,
  `template_id` INT(20) NULL DEFAULT NULL
)ENGINE=INNODB DEFAULT CHARSET=utf8;

-- alarm callback
CREATE TABLE IF NOT EXISTS `alarm_callback_info` (
  `id` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `url` VARCHAR(256) NULL DEFAULT NULL,
  `beforeCallbackSms` TINYINT(1) NULL DEFAULT NULL,
  `beforeCallbackMail` TINYINT(1) NULL DEFAULT NULL,
  `afterCallbackSms` TINYINT(1) NULL DEFAULT NULL,
  `afterCallbackMail` TINYINT(1) NULL DEFAULT NULL
)ENGINE=INNODB DEFAULT CHARSET=utf8;

-- alarm host info
CREATE TABLE IF NOT EXISTS `alarm_host_info` (
  `id` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `hostname` VARCHAR(128) NULL DEFAULT NULL,
  `ip` VARCHAR(128) NULL DEFAULT NULL,
  `cluster` VARCHAR(128) NULL DEFAULT NULL,
  `createTime` BIGINT(20) NULL DEFAULT NULL
)ENGINE=INNODB DEFAULT CHARSET=utf8;

-- alarm host group info
CREATE TABLE IF NOT EXISTS `alarm_host_group_info` (
  `id` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `hostGroupName` VARCHAR(128) NULL DEFAULT NULL,
  `creatorId` INT(11) NULL DEFAULT NULL,
  `creatorName` VARCHAR(128) NULL DEFAULT NULL,
  `createTime` BIGINT(20) NULL DEFAULT NULL,
  `updateTime` BIGINT(20) NULL DEFAULT NULL
)ENGINE=INNODB DEFAULT CHARSET=utf8;

-- alarm strategy info
CREATE TABLE IF NOT EXISTS `alarm_strategy_info` (
  `id` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `metric` VARCHAR(64) NULL DEFAULT NULL,
  `tag` VARCHAR(128) NULL DEFAULT NULL,
  `pointNum` INT(11) NULL DEFAULT NULL,
  `aggregateType` VARCHAR(64) NULL DEFAULT NULL,
  `operator` VARCHAR(64) NULL DEFAULT NULL,
  `rightValue` DOUBLE NULL DEFAULT NULL,
  `note` VARCHAR(1024) NULL DEFAULT NULL,
  `maxStep` INT(11) NULL DEFAULT NULL
)ENGINE=INNODB DEFAULT CHARSET=utf8;

-- alarm template info
CREATE TABLE IF NOT EXISTS `alarm_template_info` (
  `id` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `templateName` VARCHAR(64) NULL DEFAULT NULL,
  `templateType` VARCHAR(64) NULL DEFAULT NULL,
  `creatorId` INT(11) NULL DEFAULT NULL,
  `creatorName` VARCHAR(128) NULL DEFAULT NULL,
  `createTime` BIGINT(20) NULL DEFAULT NULL,
  `updateTime` BIGINT(20) NULL DEFAULT NULL,
  `callbackId` INT(11) NULL DEFAULT NULL,
  `deployId` INT(11) NULL DEFAULT NULL,
  `isRemoved` TINYINT(4) NOT NULL DEFAULT '0'
)ENGINE=INNODB DEFAULT CHARSET=utf8;

-- alarm host group & host bind
CREATE TABLE IF NOT EXISTS `alarm_host_group_host_bind` (
  `hostGroupId` INT(11) NOT NULL,
  `hostId` INT(11) NOT NULL,
  `bindTime` BIGINT(20) NOT NULL
)ENGINE=INNODB DEFAULT CHARSET=utf8;

-- alarm template & host group bind
CREATE TABLE IF NOT EXISTS `alarm_template_host_group_bind` (
  `templateId` INT(11) NOT NULL,
  `hostGroupId` INT(11) NOT NULL,
  `bindTime` BIGINT(20) NOT NULL
)ENGINE=INNODB DEFAULT CHARSET=utf8;

-- alarm template & user group bind
CREATE TABLE IF NOT EXISTS `alarm_template_user_group_bind` (
  `templateId` INT(11) NOT NULL,
  `userGroupId` INT(11) NOT NULL,
  `bindTime` BIGINT(20) NOT NULL
)ENGINE=INNODB DEFAULT CHARSET=utf8;

-- alarm template & strategy bind
CREATE TABLE IF NOT EXISTS `alarm_template_strategy_bind` (
  `templateId` INT(11) NOT NULL,
  `strategyId` INT(11) NOT NULL,
  `bindTime` BIGINT(20) NOT NULL
)ENGINE=INNODB DEFAULT CHARSET=utf8;

-- alarm link info
CREATE TABLE IF NOT EXISTS `alarm_link_info` (
  `id` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `content` MEDIUMTEXT NULL DEFAULT NULL
)ENGINE=INNODB DEFAULT CHARSET=utf8;

-- add admin
-- use domeos;
INSERT INTO users(username, PASSWORD, salt, loginType, createTime, state) VALUES ('admin','5fdf2372d4f23bdecfd2b8e8d7aacce1','0ea3abcf42700bb1bbcca6c27c92a821','USER','1460017181','NORMAL');
INSERT INTO admin_roles(userId, role) VALUES ('1', 'admin');
INSERT INTO GLOBAL(TYPE, VALUE) VALUES ('BUILD_IMAGE', 'pub.domeos.org/domeos/build:0.3');
INSERT INTO GLOBAL(TYPE, VALUE) VALUES ('PUBLIC_REGISTRY_URL', 'http://pub.domeos.org');
-- CREATE DATABASE IF NOT EXISTS `graph`;
-- USE GRAPH;
-- set names utf8;
-- grant all privileges on graph.* to 'domeos'@'%' with grant option;
USE graph;

DROP TABLE IF EXISTS `graph`.`endpoint`;
CREATE TABLE `graph`.`endpoint` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `endpoint` VARCHAR(255) NOT NULL DEFAULT '',
  `ts` INT(11) DEFAULT NULL,
  `t_create` DATETIME NOT NULL COMMENT 'create time',
  `t_modify` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'last modify time',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_endpoint` (`endpoint`)
) ENGINE=INNODB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `graph`.`endpoint_counter`;
CREATE TABLE `graph`.`endpoint_counter` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `endpoint_id` INT(10) UNSIGNED NOT NULL,
  `counter` VARCHAR(255) NOT NULL DEFAULT '',
  `step` INT(11) NOT NULL DEFAULT 60 COMMENT 'in second',
  `type` VARCHAR(16) NOT NULL COMMENT 'GAUGE|COUNTER|DERIVE',
  `ts` INT(11) DEFAULT NULL,
  `t_create` DATETIME NOT NULL COMMENT 'create time',
  `t_modify` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'last modify time',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_endpoint_id_counter` (`endpoint_id`, `counter`)
) ENGINE=INNODB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `graph`.`tag_endpoint`;
CREATE TABLE `graph`.`tag_endpoint` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `tag` VARCHAR(255) NOT NULL DEFAULT '' COMMENT 'srv=tv',
  `endpoint_id` INT(10) UNSIGNED NOT NULL,
  `ts` INT(11) DEFAULT NULL,
  `t_create` DATETIME NOT NULL COMMENT 'create time',
  `t_modify` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'last modify time',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_tag_endpoint_id` (`tag`, `endpoint_id`)
) ENGINE=INNODB DEFAULT CHARSET=latin1;


-- CREATE DATABASE IF NOT EXISTS portal;
-- USE portal;
-- SET NAMES 'utf8';
-- grant all privileges on portal.* to 'domeos'@'%' with grant option;

USE portal;

DROP TABLE IF EXISTS `portal`.`action`;
CREATE TABLE `portal`.`action` (
  `id`                   INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `uic`                  VARCHAR(255)     NOT NULL DEFAULT '',
  `url`                  VARCHAR(255)     NOT NULL DEFAULT '',
  `callback`             TINYINT(4)       NOT NULL DEFAULT '0',
  `before_callback_sms`  TINYINT(4)       NOT NULL DEFAULT '0',
  `before_callback_mail` TINYINT(4)       NOT NULL DEFAULT '0',
  `after_callback_sms`   TINYINT(4)       NOT NULL DEFAULT '0',
  `after_callback_mail`  TINYINT(4)       NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
)
  ENGINE =INNODB
  DEFAULT CHARSET =utf8
  COLLATE =utf8_unicode_ci;

DROP TABLE IF EXISTS `portal`.`expression`;
CREATE TABLE `portal`.`expression` (
  `id`          INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `expression`  VARCHAR(1024)    NOT NULL,
  `func`        VARCHAR(16)      NOT NULL DEFAULT 'all(#1)',
  `op`          VARCHAR(8)       NOT NULL DEFAULT '',
  `right_value` VARCHAR(16)      NOT NULL DEFAULT '',
  `max_step`    INT(11)          NOT NULL DEFAULT '1',
  `priority`    TINYINT(4)       NOT NULL DEFAULT '0',
  `note`        VARCHAR(1024)    NOT NULL DEFAULT '',
  `action_id`   INT(10) UNSIGNED NOT NULL DEFAULT '0',
  `create_user` VARCHAR(64)      NOT NULL DEFAULT '',
  `pause`       TINYINT(1)       NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
)
  ENGINE =INNODB
  DEFAULT CHARSET =utf8
  COLLATE =utf8_unicode_ci;

DROP TABLE IF EXISTS `portal`.`grp`;
CREATE TABLE `portal`.`grp` (
  id          INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  grp_name    VARCHAR(255)     NOT NULL DEFAULT '',
  create_user VARCHAR(64)      NOT NULL DEFAULT '',
  create_at   TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  come_from   TINYINT(4)       NOT NULL DEFAULT '0',
  PRIMARY KEY (id),
  UNIQUE KEY idx_host_grp_grp_name (grp_name)
)
  ENGINE =INNODB
  DEFAULT CHARSET =utf8
  COLLATE =utf8_unicode_ci
  AUTO_INCREMENT=1000;

DROP TABLE IF EXISTS `portal`.`grp_host`;
CREATE TABLE `portal`.`grp_host` (
  grp_id  INT UNSIGNED NOT NULL,
  host_id INT UNSIGNED NOT NULL,
  KEY idx_grp_host_grp_id (grp_id),
  KEY idx_grp_host_host_id (host_id)
)
  ENGINE =INNODB
  DEFAULT CHARSET =utf8
  COLLATE =utf8_unicode_ci;

DROP TABLE IF EXISTS `portal`.`grp_tpl`;
CREATE TABLE `portal`.`grp_tpl` (
  `grp_id`    INT(10) UNSIGNED NOT NULL,
  `tpl_id`    INT(10) UNSIGNED NOT NULL,
  `bind_user` VARCHAR(64)      NOT NULL DEFAULT '',
  KEY `idx_grp_tpl_grp_id` (`grp_id`),
  KEY `idx_grp_tpl_tpl_id` (`tpl_id`)
)
  ENGINE =INNODB
  DEFAULT CHARSET =utf8
  COLLATE =utf8_unicode_ci;

DROP TABLE IF EXISTS `portal`.`host`;
CREATE TABLE `portal`.`host` (
  id             INT UNSIGNED NOT NULL AUTO_INCREMENT,
  hostname       VARCHAR(255) NOT NULL DEFAULT '',
  ip             VARCHAR(16)  NOT NULL DEFAULT '',
  agent_version  VARCHAR(16)  NOT NULL DEFAULT '',
  plugin_version VARCHAR(128) NOT NULL DEFAULT '',
  maintain_begin INT UNSIGNED NOT NULL DEFAULT 0,
  maintain_end   INT UNSIGNED NOT NULL DEFAULT 0,
  update_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY idx_host_hostname (hostname)
)
  ENGINE =INNODB
  DEFAULT CHARSET =utf8
  COLLATE =utf8_unicode_ci;

DROP TABLE IF EXISTS `portal`.`mockcfg`;
CREATE TABLE `portal`.`mockcfg` (
  `id`       BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name`     VARCHAR(255)        NOT NULL DEFAULT ''
  COMMENT 'name of mockcfg, used for uuid',
  `obj`      VARCHAR(10240)      NOT NULL DEFAULT ''
  COMMENT 'desc of object',
  `obj_type` VARCHAR(255)        NOT NULL DEFAULT ''
  COMMENT 'type of object, host or group or other',
  `metric`   VARCHAR(128)        NOT NULL DEFAULT '',
  `tags`     VARCHAR(1024)       NOT NULL DEFAULT '',
  `dstype`   VARCHAR(32)         NOT NULL DEFAULT 'GAUGE',
  `step`     INT(11) UNSIGNED    NOT NULL DEFAULT 60,
  `mock`     DOUBLE              NOT NULL DEFAULT 0
  COMMENT 'mocked value when nodata occurs',
  `creator`  VARCHAR(64)         NOT NULL DEFAULT '',
  `t_create` DATETIME            NOT NULL
  COMMENT 'create time',
  `t_modify` TIMESTAMP           NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'last modify time',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_name` (`name`)
)
  ENGINE =INNODB
  DEFAULT CHARSET =utf8
  COLLATE =utf8_unicode_ci;

DROP TABLE IF EXISTS `portal`.`plugin_dir`;
CREATE TABLE `portal`.`plugin_dir` (
  `id`          INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `grp_id`      INT(10) UNSIGNED NOT NULL,
  `dir`         VARCHAR(255)     NOT NULL,
  `create_user` VARCHAR(64)      NOT NULL DEFAULT '',
  `create_at`   TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_plugin_dir_grp_id` (`grp_id`)
)
  ENGINE =INNODB
  DEFAULT CHARSET =utf8
  COLLATE =utf8_unicode_ci;

DROP TABLE IF EXISTS `portal`.`strategy`;
CREATE TABLE `portal`.`strategy` (
  `id`          INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `metric`      VARCHAR(128)     NOT NULL DEFAULT '',
  `tags`        VARCHAR(256)     NOT NULL DEFAULT '',
  `max_step`    INT(11)          NOT NULL DEFAULT '1',
  `priority`    TINYINT(4)       NOT NULL DEFAULT '0',
  `func`        VARCHAR(16)      NOT NULL DEFAULT 'all(#1)',
  `op`          VARCHAR(8)       NOT NULL DEFAULT '',
  `right_value` VARCHAR(64)      NOT NULL,
  `note`        VARCHAR(128)     NOT NULL DEFAULT '',
  `run_begin`   VARCHAR(16)      NOT NULL DEFAULT '',
  `run_end`     VARCHAR(16)      NOT NULL DEFAULT '',
  `tpl_id`      INT(10) UNSIGNED NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_strategy_tpl_id` (`tpl_id`)
)
  ENGINE =INNODB
  DEFAULT CHARSET =utf8
  COLLATE =utf8_unicode_ci;

DROP TABLE IF EXISTS `portal`.`tpl`;
CREATE TABLE `portal`.`tpl` (
  id          INT UNSIGNED NOT NULL AUTO_INCREMENT,
  tpl_name    VARCHAR(255) NOT NULL DEFAULT '',
  parent_id   INT UNSIGNED NOT NULL DEFAULT 0,
  action_id   INT UNSIGNED NOT NULL DEFAULT 0,
  create_user VARCHAR(64)  NOT NULL DEFAULT '',
  create_at   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY idx_tpl_name (tpl_name),
  KEY idx_tpl_create_user (create_user)
)
  ENGINE =INNODB
  DEFAULT CHARSET =utf8
  COLLATE =utf8_unicode_ci;
