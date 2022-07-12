# 01

CREATE TABLE `countries` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(45) NOT NULL
);

CREATE TABLE `towns` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(45) NOT NULL,
    `country_id` INT NOT NULL,
    CONSTRAINT fk_towns_countries
    FOREIGN KEY (`country_id`)
    REFERENCES `countries` (`id`)
);

CREATE TABLE `stadiums` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(45) NOT NULL,
	`capacity` INT NOT NULL,
    `town_id` INT NOT NULL,
    CONSTRAINT fk_stadiums_towns
    FOREIGN KEY (`town_id`)
    REFERENCES `towns` (`id`)
);

CREATE TABLE `teams` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(45) NOT NULL,
	`established` DATE NOT NULL,
    `fan_base` BIGINT NOT NULL DEFAULT 0,
    `stadium_id` INT NOT NULL,
    CONSTRAINT fk_teams_stadiums
    FOREIGN KEY `teams` (`stadium_id`)
    REFERENCES `stadiums` (`id`)
);

CREATE TABLE `skills_data` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `dribbling` INT DEFAULT 0,
    `pace` INT DEFAULT 0,
	`passing` INT DEFAULT 0,
    `shooting` INT DEFAULT 0,
    `speed` INT DEFAULT 0,
    `strength` INT DEFAULT 0
);

CREATE TABLE `players` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(10) NOT NULL,
    `last_name` VARCHAR(20) NOT NULL,
    `age` INT NOT NULL DEFAULT 0,
    `position` CHAR(1) NOT NULL,
    `salary` DECIMAL(10, 2) NOT NULL DEFAULT 0,
    `hire_date` DATETIME,
    `skills_data_id` INT NOT NULL,
    `team_id` INT,
	CONSTRAINT fk_players_skills_data
    FOREIGN KEY (`skills_data_id`)
    REFERENCES `skills_data` (`id`),
	CONSTRAINT fk_players_teams
    FOREIGN KEY (`team_id`)
    REFERENCES `teams` (`id`)
);

CREATE TABLE `coaches` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(10) NOT NULL,
    `last_name` VARCHAR(20) NOT NULL,
	`salary` DECIMAL(10, 2) NOT NULL DEFAULT 0,
    `coach_level` INT NOT NULL DEFAULT 0
);

CREATE TABLE `players_coaches` (
	`player_id` INT,
	`coach_id` INT,
    CONSTRAINT pk_players_coaches
    PRIMARY KEY (`player_id`, `coach_id`),
    CONSTRAINT fk_players_coaches_players
    FOREIGN KEY (`player_id`)
    REFERENCES `players` (`id`),
	CONSTRAINT fk_players_coaches_coaches
    FOREIGN KEY (`coach_id`)
    REFERENCES `coaches` (`id`)
);


# 02

INSERT INTO `coaches`(`first_name`, `last_name`, `salary`, `coach_level`)
SELECT `first_name`, `last_name`, `salary` * 2, 
CHAR_LENGTH(`first_name`) 
FROM `players`
WHERE `age` >= 45;

SELECT * FROM `coaches`;

#3

UPDATE `coaches`
SET `coach_level` = `coach_level` + 1
WHERE LEFT(`first_name`, 1) = 'A'
AND `id` IN (SELECT `coach_id` FROM `players_coaches`);

# 04

DELETE FROM `players`
WHERE `age` >= 45;

# 05

SELECT `first_name`, `age`, `salary`
FROM `players`
ORDER BY `salary` DESC;

# 06

SELECT p.`id`, CONCAT(`first_name`, ' ', `last_name`) AS `full_name`, `age`, `position`, `hire_date`
FROM `players` AS p
JOIN `skills_data` AS sd
ON p.`skills_data_id` = sd.`id`
WHERE `age` < 23 AND `position` = 'A' AND `hire_date` IS NULL AND sd.`strength` > 50
ORDER BY `salary`, `age`;


# 07

SELECT t.`name` AS `team_name`, t.`established`, t.`fan_base`, COUNT(p.`id`) AS `players_count`
FROM `teams` AS t
LEFT JOIN `players` AS p
ON t.`id` = p.`team_id`
GROUP BY t.id
ORDER BY `players_count` DESC, `fan_base` DESC;


# 08

SELECT MAX(sd.`speed`) AS `max_speed`, t.`name` AS `town_name`
FROM `towns` AS t
LEFT JOIN `stadiums` AS s
ON t.`id` = s.`town_id`
LEFT JOIN `teams` AS te
ON s.`id` = te.`stadium_id`
LEFT JOIN `players` AS p
ON te.`id` = p.`team_id`
LEFT JOIN `skills_data` AS sd
ON p.`skills_data_id` = sd.`id`
WHERE te.`name` != 'Devify'
GROUP BY t.`id`
ORDER BY `max_speed` DESC, `town_name`;

# 09

SELECT c.`name`, COUNT(p.`id`) AS `total_count_of_players`, SUM(p.`salary`) AS `total_sum_of_salaries`
FROM `countries` AS c
LEFT JOIN `towns` AS t
ON c.`id` = t.`country_id`
LEFT JOIN `stadiums` AS s
ON t.`id` = s.`town_id`
LEFT JOIN `teams` AS te
ON s.`id` = te.`stadium_id`
LEFT JOIN `players` AS p
ON te.`id` = p.`team_id`
GROUP BY c.`id`
ORDER BY `total_count_of_players` DESC, c.`name`;

# 10

DELIMITER $$

CREATE FUNCTION udf_stadium_players_count(stadium_name VARCHAR(30))
RETURNS INT
DETERMINISTIC
BEGIN
	RETURN (SELECT COUNT(p.`id`)
			FROM `stadiums` AS s
			LEFT JOIN `teams` AS te
            ON s.`id` = te.`stadium_id`
            LEFT JOIN `players` AS p
            ON te.`id` = p.`team_id`
            WHERE s.`name` = stadium_name
    );
END $$

DELIMITER ;

SELECT udf_stadium_players_count ('Jaxworks') as `count`; 


# 11

DELIMITER $$

CREATE PROCEDURE udp_find_playmaker(min_dribble_points INT, team_name VARCHAR(45))
BEGIN
		SELECT CONCAT(p.`first_name`, ' ', p.`last_name`) AS `full_name`, p.`age`, p.`salary`, 
    sd.`dribbling`, sd.`speed`, te.`name` AS `team_name`
	FROM`teams` AS te 
	JOIN `players` AS p
    ON p.`team_id` = te.`id`
    JOIN `skills_data` AS sd
    ON p.`skills_data_id` = sd.`id`
	WHERE sd.`dribbling` > min_dribble_points AND te.`name` = team_name
    ORDER BY sd.`speed` DESC
    LIMIT 1;
END $$

DELIMITER ;

CALL udp_find_playmaker(20, 'Skyble');
