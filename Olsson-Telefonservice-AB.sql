SET @job_name = 'olsson';
SET @job_Name_Caps = 'Olssons Telefonservice AB';
SET @job_name_offduty = 'olssonoffduty';
SET @job_label_offduty = 'Olssons Telefonservice AB - Ur tjänst';

INSERT INTO `jobs` (name, label, whitelisted) VALUES
  (@job_name, @job_Name_Caps, 1),
  (@job_name_offduty, @job_label_offduty, 1)
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
  (@job_name, 0, 'testemployee', 'Provanställd', 125, '{}', '{}'),
  (@job_name, 1, 'employee', 'Anställd', 175, '{}', '{}'),
  (@job_name, 2, 'technician', 'Tekniker', 250, '{}', '{}'),
  (@job_name, 3, 'boss', 'VD', 300, '{}', '{}'),
  (@job_name_offduty, 0, 'testemployee', 'Provanställd', 50, '{}', '{}'),
  (@job_name_offduty, 1, 'employee', 'Anställd', 75, '{}', '{}'),
  (@job_name_offduty, 2, 'technician', 'Tekniker', 100, '{}', '{}'),
  (@job_name_offduty, 3, 'boss', 'VD', 150, '{}', '{}')
;

CREATE TABLE IF NOT EXISTS `olssonslager` (
  `lager` int(11) DEFAULT b'0',
  PRIMARY KEY (`lager`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `olssonslager` (lager) VALUES
	(0)
;

INSERT INTO `items` (name, label, `limit`) VALUES
	('crackedphone', 'Telefon (sprucken)', 1),
	('virusphone', 'Telefon (virus)', 1)
;
