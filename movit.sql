/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table configurations
# ------------------------------------------------------------

DROP TABLE IF EXISTS `configurations`;

CREATE TABLE `configurations` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `position` int(11) NOT NULL DEFAULT '0',
  `participant_id` int(11) unsigned NOT NULL,
  `name` varchar(255) NOT NULL DEFAULT '',
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `practice_configuration` tinyint(1) NOT NULL DEFAULT '0',
  `day_of_week_mon` tinyint(1) NOT NULL DEFAULT '1',
  `day_of_week_tue` tinyint(1) NOT NULL DEFAULT '1',
  `day_of_week_wed` tinyint(1) NOT NULL DEFAULT '1',
  `day_of_week_thu` tinyint(1) NOT NULL DEFAULT '1',
  `day_of_week_fri` tinyint(1) NOT NULL DEFAULT '1',
  `day_of_week_sat` tinyint(1) NOT NULL DEFAULT '1',
  `day_of_week_sun` tinyint(1) NOT NULL DEFAULT '1',
  `imageset_id` int(11) unsigned DEFAULT NULL,
  `loop_animated_images` tinyint(1) NOT NULL DEFAULT '0',
  `animation_frame_rate` int(11) NOT NULL DEFAULT '50',
  `use_staircase_method` tinyint(1) NOT NULL DEFAULT '0',
  `number_of_staircases` int(11) NOT NULL DEFAULT '1',
  `staircase_start_level` varchar(255) NOT NULL DEFAULT '50',
  `number_of_reversals` varchar(255) NOT NULL DEFAULT '6',
  `hits_to_finish` varchar(255) NOT NULL DEFAULT '4',
  `staircase_min_level` varchar(255) NOT NULL DEFAULT '0',
  `staircase_max_level` varchar(255) NOT NULL DEFAULT '100',
  `delta_values` varchar(255) NOT NULL DEFAULT '6,4,2,2,2,2',
  `questions_per_folder` varchar(1000) NOT NULL DEFAULT '',
  `num_wrong_to_get_easier` varchar(255) NOT NULL DEFAULT '1',
  `num_correct_to_get_harder` varchar(255) NOT NULL DEFAULT '2',
  `background_colour` varchar(255) NOT NULL DEFAULT '#000000',
  `show_exit_button` tinyint(1) NOT NULL DEFAULT '1',
  `exit_button_x` int(11) NOT NULL DEFAULT '972',
  `exit_button_y` int(11) NOT NULL DEFAULT '20',
  `exit_button_w` int(11) NOT NULL DEFAULT '32',
  `exit_button_h` int(11) NOT NULL DEFAULT '32',
  `exit_button_fg` varchar(255) NOT NULL DEFAULT '#8A8A8A',
  `exit_button_bg` varchar(255) NOT NULL DEFAULT '#303030',
  `num_buttons` int(11) NOT NULL DEFAULT '2',
  `button1_text` varchar(255) NOT NULL,
  `button2_text` varchar(255) NOT NULL DEFAULT '',
  `button3_text` varchar(255) NOT NULL,
  `button4_text` varchar(255) NOT NULL DEFAULT '',
  `button1_bg` varchar(255) NOT NULL DEFAULT '',
  `button2_bg` varchar(255) NOT NULL DEFAULT '',
  `button3_bg` varchar(255) NOT NULL DEFAULT '',
  `button4_bg` varchar(255) NOT NULL DEFAULT '',
  `button1_fg` varchar(255) NOT NULL DEFAULT '',
  `button2_fg` varchar(255) NOT NULL DEFAULT '',
  `button3_fg` varchar(255) NOT NULL DEFAULT '',
  `button4_fg` varchar(255) NOT NULL DEFAULT '',
  `button1_x` int(11) NOT NULL,
  `button1_y` int(11) NOT NULL,
  `button1_w` int(11) NOT NULL,
  `button1_h` int(11) NOT NULL,
  `button2_x` int(11) NOT NULL,
  `button2_y` int(11) NOT NULL,
  `button2_w` int(11) NOT NULL,
  `button2_h` int(11) NOT NULL,
  `button3_x` int(11) NOT NULL,
  `button3_y` int(11) NOT NULL,
  `button3_w` int(11) NOT NULL,
  `button3_h` int(11) NOT NULL,
  `button4_x` int(11) NOT NULL,
  `button4_y` int(11) NOT NULL,
  `button4_w` int(11) NOT NULL,
  `button4_h` int(11) NOT NULL,
  `require_next` tinyint(1) NOT NULL DEFAULT '0',
  `time_between_each_question_mean` float NOT NULL DEFAULT '0',
  `time_between_each_question_plusminus` float NOT NULL DEFAULT '0',
  `infinite_presentation_time` tinyint(1) NOT NULL DEFAULT '0',
  `presentation_time` float NOT NULL DEFAULT '2',
  `use_specified_seed` tinyint(1) NOT NULL DEFAULT '0',
  `specified_seed` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `participant_id` (`participant_id`),
  KEY `imageset_id` (`imageset_id`),
  CONSTRAINT `configurations_ibfk_1` FOREIGN KEY (`participant_id`) REFERENCES `participants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `configurations_ibfk_2` FOREIGN KEY (`imageset_id`) REFERENCES `imagesets` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

# Dump of table imagesets
# ------------------------------------------------------------

DROP TABLE IF EXISTS `imagesets`;

CREATE TABLE `imagesets` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `path` varchar(1000) NOT NULL DEFAULT '',
  `user_id` int(11) unsigned NOT NULL,
  `name` varchar(255) NOT NULL DEFAULT '',
  `data` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `imagesets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

# Dump of table logs
# ------------------------------------------------------------

DROP TABLE IF EXISTS `logs`;

CREATE TABLE `logs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `participant_id` int(11) unsigned NOT NULL,
  `data` text NOT NULL,
  `log_timestamp` int(11) NOT NULL,
  `upload_timestamp` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `participant_id` (`participant_id`),
  CONSTRAINT `logs_ibfk_1` FOREIGN KEY (`participant_id`) REFERENCES `participants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


# Dump of table participants
# ------------------------------------------------------------

DROP TABLE IF EXISTS `participants`;

CREATE TABLE `participants` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL DEFAULT '',
  `configuration` text NOT NULL,
  `user_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `participants_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

# Dump of table roles
# ------------------------------------------------------------

DROP TABLE IF EXISTS `roles`;

CREATE TABLE `roles` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL,
  `description` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;

INSERT INTO `roles` (`id`, `name`, `description`)
VALUES
	(1,'login','Login privileges, granted after account confirmation'),
	(2,'admin','Administrative user, has access to everything.');

/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table roles_users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `roles_users`;

CREATE TABLE `roles_users` (
  `user_id` int(10) unsigned NOT NULL,
  `role_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `fk_role_id` (`role_id`),
  CONSTRAINT `roles_users_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `roles_users_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


# Dump of table user_tokens
# ------------------------------------------------------------

DROP TABLE IF EXISTS `user_tokens`;

CREATE TABLE `user_tokens` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) unsigned NOT NULL,
  `user_agent` varchar(40) NOT NULL,
  `token` varchar(40) NOT NULL,
  `created` int(10) unsigned NOT NULL,
  `expires` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_token` (`token`),
  KEY `fk_user_id` (`user_id`),
  KEY `expires` (`expires`),
  CONSTRAINT `user_tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(254) NOT NULL,
  `username` varchar(32) NOT NULL DEFAULT '',
  `password` varchar(64) NOT NULL,
  `logins` int(10) unsigned NOT NULL DEFAULT '0',
  `last_login` int(10) unsigned DEFAULT NULL,
  `default_participant_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_username` (`username`),
  UNIQUE KEY `uniq_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;