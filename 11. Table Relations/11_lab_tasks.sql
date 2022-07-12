CREATE TABLE `mountains` (
`id` INT AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR(45) 
);

CREATE TABLE `peaks` (
`id` INT AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR(45),
`mountain_id` INT,
CONSTRAINT `fk_mountain_id` 
FOREIGN KEY (`mountain_id`)
REFERENCES `mountains` (`id`)
);

ALTER TABLE `peaks`
ADD CONSTRAINT
FOREIGN KEY (`m_id`)
REFERENCES `mountains` (`id`)
ON DELETE CASCADE ON UPDATE CASCADE;

SELECT `driver_id`, `vehicle_type`,
CONCAT(`first_name`, ' ', `last_name`) AS `driver_name`
FROM `vehicles` AS v
JOIN `campers` AS c 
ON v.`driver_id` = c.`id`;

SELECT v.`driver_id`, v.`vehicle_type`,
CONCAT(`first_name`, ' ', `last_name`) AS `driver_name`
FROM `campers` AS c
JOIN `vehicles` AS v
ON v.`driver_id` = c.`id`;

CREATE TABLE `mountains` (
`id` INT AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR(45) 
);
CREATE TABLE `peaks` (
`id` INT AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR(45),
`mountain_id` INT,
CONSTRAINT `fk_mountain_id` 
FOREIGN KEY (`mountain_id`)
REFERENCES `mountains` (`id`)
ON DELETE CASCADE
);

SELECT r.`starting_point`, r.`end_point`, r.`leader_id`, 
CONCAT(c.`first_name`, ' ', `last_name`) AS `leader_name`
FROM `routes` AS r
JOIN `campers` AS c
ON r.`leader_id` = c.`id`;

CREATE SCHEMA `five`;

CREATE TABLE `clients` (
`id` INT AUTO_INCREMENT PRIMARY KEY,
`clients_name` VARCHAR(100) 
);

CREATE TABLE `projects` (
`id` INT AUTO_INCREMENT PRIMARY KEY,
`client_id` INT,
`project_lead_id` INT,
CONSTRAINT `fk_clients`
FOREIGN KEY (`client_id`)
REFERENCES `clients` (`id`)
);

CREATE TABLE `employees` (
`id` INT AUTO_INCREMENT PRIMARY KEY,
`first_name` VARCHAR(30),
`last_name` VARCHAR(30),
`project_id` INT,
CONSTRAINT `fk_projects` 
FOREIGN KEY (`project_id`)
REFERENCES `projects` (`id`)
);

ALTER TABLE `projects`
ADD CONSTRAINT `fk_projects1` 
FOREIGN KEY (`project_lead_id`)
REFERENCES `employees` (`id`);