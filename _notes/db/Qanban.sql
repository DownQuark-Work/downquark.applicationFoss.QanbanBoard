CREATE SCHEMA `Qanban`;

CREATE TABLE `Qanban`.`Project` (
  `id` uuid PRIMARY KEY COMMENT 'each top-level active repository is assigned a uuid',
  `name` varchar(75) NOT NULL,
  `path` varchar(200) COMMENT 'path to repository directory on user OS',
  `determined` boolean DEFAULT false COMMENT 'a maximum of only one project is allowed to be determined at a time',
  `created` timestamp DEFAULT (now()),
  `edited` timestamp DEFAULT (now())
);

CREATE TABLE `Qanban`.`Progress` (
  `id` uuid PRIMARY KEY,
  `project_id` uuid,
  `release_version` varchar(12) DEFAULT "0" COMMENT 'this will help when creating release changelogs',
  `progress_type` integer,
  `progress_content_id` integer,
  `progress_completion_type` integer COMMENT 'defaults to 0 or 1 dependent on `progress_type`'
);

CREATE TABLE `Qanban`.`Progress_Develop` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `creation_type` integer,
  `task_status_type` integer DEFAULT 0,
  `commit_id` integer DEFAULT "null" COMMENT 'if null then task was created manually by the user',
  `name` varchar(20) COMMENT 'task/ticket name',
  `description` varchar(255) COMMENT 'task/ticket issue description',
  `level_of_effort` integer DEFAULT 3,
  `priority` integer DEFAULT 0,
  `created` timestamp DEFAULT (now()),
  `edited` timestamp DEFAULT (now())
);

CREATE TABLE `Qanban`.`Progress_Develop_Commit` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `commit_type` integer,
  `commit_init` varchar(64) UNIQUE NOT NULL,
  `commit_active` varchar(64) UNIQUE DEFAULT "null" COMMENT 'This commit is only meant to help ensure consistency.
It is the most recent commit created while the issues is still in development.
It will be set to null when `commit_complete` is populated',
  `commit_complete` varchar(64) UNIQUE DEFAULT "null",
  `message` varchar(255) DEFAULT "null" COMMENT 'the accompanying message with the most recent commit'
);

CREATE TABLE `Qanban`.`Progress_Discover` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `discover_type` integer,
  `name` varchar(20) NOT NULL,
  `content` varchar(255) NOT NULL,
  `created` timestamp DEFAULT (now()),
  `edited` timestamp DEFAULT (now())
);

CREATE TABLE `Qanban`.`Types_Develop` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `name` ENUM ('OPEN', 'IN_PROGRESS', 'BLOCKED', 'COMPLETE')
);

CREATE TABLE `Qanban`.`Types_Develop_Creation` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `name` ENUM ('GIT_FLOW', 'MANUAL_QANBAN')
);

CREATE TABLE `Qanban`.`Types_Discover` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `name` ENUM ('BUG', 'EXT', 'REF', 'TODO')
);

CREATE TABLE `Qanban`.`Types_Progress` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `name` ENUM ('DEVELOP', 'DISCOVER')
);

CREATE TABLE `Qanban`.`Types_Progress_Completion` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `name` ENUM ('NOT_APPLICABLE', 'NOT_COMPLETE', 'GIT_FLOW', 'MANUAL_QANBAN')
);

CREATE TABLE `Qanban`.`Types_Task_Commit` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `name` ENUM ('BUGFIX', 'FEATURE', 'HOTFIX', 'RELEASE', 'SUPPORT')
);

CREATE TABLE `Qanban`.`Quantifier` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `name` ENUM ('LOW', 'MEDIUM', 'HIGH', 'SMALL', 'LARGE')
);

ALTER TABLE `Qanban`.`Project` COMMENT = 'Initial table to populate';

ALTER TABLE `Qanban`.`Progress` COMMENT = '`created` & `edited` values can be found in their respective `Qanban.Progress_(Develop|Discover)` tables';

ALTER TABLE `Qanban`.`Progress_Discover` COMMENT = 'if `discover_type` is BUG or TODO
  then _name_ and _content_ values will be applied to the
  applicable `Progress_Develop` fields as well
else the fields have no real restictions
  and could be a link, message, snippet, etc';

ALTER TABLE `Qanban`.`Progress` ADD FOREIGN KEY (`project_id`) REFERENCES `Qanban`.`Project` (`id`);

ALTER TABLE `Qanban`.`Progress` ADD FOREIGN KEY (`progress_type`) REFERENCES `Qanban`.`Types_Progress` (`id`);

ALTER TABLE `Qanban`.`Progress` ADD FOREIGN KEY (`progress_content_id`) REFERENCES `Qanban`.`Progress_Develop` (`id`);

ALTER TABLE `Qanban`.`Progress` ADD FOREIGN KEY (`progress_content_id`) REFERENCES `Qanban`.`Progress_Discover` (`id`);

ALTER TABLE `Qanban`.`Progress` ADD FOREIGN KEY (`progress_completion_type`) REFERENCES `Qanban`.`Types_Progress_Completion` (`id`);

ALTER TABLE `Qanban`.`Progress_Develop` ADD FOREIGN KEY (`creation_type`) REFERENCES `Qanban`.`Types_Develop_Creation` (`id`);

ALTER TABLE `Qanban`.`Progress_Develop` ADD FOREIGN KEY (`task_status_type`) REFERENCES `Qanban`.`Types_Develop` (`id`);

ALTER TABLE `Qanban`.`Progress_Develop` ADD FOREIGN KEY (`commit_id`) REFERENCES `Qanban`.`Progress_Develop_Commit` (`id`);

ALTER TABLE `Qanban`.`Progress_Develop` ADD FOREIGN KEY (`level_of_effort`) REFERENCES `Qanban`.`Quantifier` (`id`);

ALTER TABLE `Qanban`.`Progress_Develop` ADD FOREIGN KEY (`priority`) REFERENCES `Qanban`.`Quantifier` (`id`);

ALTER TABLE `Qanban`.`Progress_Develop_Commit` ADD FOREIGN KEY (`commit_type`) REFERENCES `Qanban`.`Types_Task_Commit` (`id`);

ALTER TABLE `Qanban`.`Progress_Discover` ADD FOREIGN KEY (`discover_type`) REFERENCES `Qanban`.`Types_Discover` (`id`);
