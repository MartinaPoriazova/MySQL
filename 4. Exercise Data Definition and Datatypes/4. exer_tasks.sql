CREATE DATABASE `minions`;
USE `minions`;
CREATE TABLE `minions`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(30),
`age` INT
);
CREATE TABLE `towns`(
`town_id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(30)
);

ALTER TABLE `towns`
CHANGE COLUMN `town_id` `id` INT AUTO_INCREMENT;

ALTER TABLE `minions`
ADD COLUMN `town_id` INT,
ADD CONSTRAINT fk_minions_towns 
FOREIGN KEY `minions` (`town_id`) 
REFERENCES `towns` (`id`);

INSERT INTO `towns` (`id`, `name`)
VALUES (1, "Sofia"), 
(2, "Plovdiv"), 
(3, "Varna");

INSERT INTO `minions` (`id`, `name`, `age`, `town_id`) 
VALUES (1, "Kevin", 22, 1), 
(2, "Bob", 15, 3), 
(3, "Steward", NUll, 2);

TRUNCATE TABLE `minions`;

DROP TABLE `minions`;
DROP TABLE `towns`;

CREATE TABLE `people`(
`id` INT PRIMARY KEY AUTO_INCREMENT UNIQUE,
`name` VARCHAR(200) NOT NULL,
`picture` BLOB,
`height` DOUBLE(3,2),
`weight` DOUBLE(5,2),
`gender` CHAR(1) NOT NULL,
`birthdate` DATE NOT NULL,
`biography` TEXT 
);

INSERT INTO `people` (`id`, `name`, `picture`, `height`, `weight`, `gender`, `birthdate`, `biography`)
VALUES
(1, "Ivan", NULL, 1.90, 98.54, "m", '1984-10-01', "Ivan is a volleyball team captain"),
(2, "Maya", NULL, 1.58, 58.54, "f", '1986-12-31', "Maya is a singer in a girl band"),
(3, "George", NULL, 1.80, 102.5, "m", '1987-07-19', "George is from Svoge and has a big house with two dogs."),
(4, "Iva", NULL, 1.71, 52.25, "f", '1994-03-28', "Iva is travelling all around the world, because she is a pilot."),
(5, "Peter", NULL, 1.84, 75.45, "m", '1974-05-09', "Peter is a teacher in a big highscholl in Plovdiv.");

CREATE TABLE `users`(
`id` INT PRIMARY KEY AUTO_INCREMENT UNIQUE,
`username` VARCHAR(30) NOT NULL UNIQUE,
`password` VARCHAR(26) NOT NULL,
`profile_picture` BLOB,
`last_login_time` TIMESTAMP NOT NULL,
`is_deleted` BOOLEAN NOT NULL  
);

INSERT INTO `users` (`id`, `username`, `password`, `profile_picture`, `last_login_time`, `is_deleted`)
VALUES
(1, 'maria_2001', 'Test123!', NULL, '2022-01-02 12:53:41', false),
(2, 'good_girl_1998', 'love!me01', NULL, '2022-01-03 00:21:01', false),
(3, 'hellBoy', 'halloWorld', NULL, '2021-07-29 13:00:11', true),
(4, 'SUNFLOWER!!!', 'fOrEvEr1234&', NULL, '2018-11-30 01:05:00', true),
(5, 'BATMAN86', 'Test123', NULL, '1998-07-31 00:53:41', false);

ALTER TABLE `users`
DROP PRIMARY KEY,
ADD CONSTRAINT pk_users
PRIMARY KEY `users` (`id`, `username`);

ALTER TABLE `users`
CHANGE COLUMN `last_login_time` `last_login_time`
TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- ALTER TABLE `users`
-- ALTER COLUMN `last_login_time` 
-- SET DEFAULT NOW();

ALTER TABLE `users`
DROP PRIMARY KEY,
ADD CONSTRAINT pk_id
PRIMARY KEY(id),
ADD CONSTRAINT uq_username
UNIQUE(username);

CREATE DATABASE `Movies`;
USE `Movies`;

CREATE TABLE `directors`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`director_name` VARCHAR(100) NOT NULL,
`notes` TEXT
);

INSERT INTO `directors` (`director_name`, `notes`)
VALUES
('Ivan Ivanov', 'Test1'),
('Milen Ivanov', 'Test2'),
('Peter Petrov', 'Test3'),
('Delyan Ivanov', 'Test4'),
('Mihail Stoyanov', 'Test5');

CREATE TABLE `genres`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`genre_name` VARCHAR(100) NOT NULL,
`notes` TEXT
);

INSERT INTO `genres` (`genre_name`, `notes`)
VALUES
('triller', 'Test1'),
('comedy', 'Test2'),
('drama', 'Test3'),
('sci-fi', 'Test4'),
('family', 'Test5');

CREATE TABLE `categories`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`category_name` VARCHAR(100) NOT NULL,
`notes` TEXT
);

INSERT INTO `categories` (`category_name`, `notes`)
VALUES
('best_movie', 'Test1'),
('best_actor', 'Test2'),
('best_actress', 'Test3'),
('best_director', 'Test4'),
('best_script', 'Test5');

CREATE TABLE `movies`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`title` VARCHAR(200) NOT NULL,
`director_id` INT,
`copyright_year` YEAR,
`length` TIME, 
`genre_id` INT,
`category_id` INT,
`rating` DOUBLE(1,1),
`notes` TEXT
);

INSERT INTO `movies` (`title`)
VALUES 
('Test Movie1'),
('Test Movie2'),
('Test Movie3'),
('Test Movie4'),
('Test Movie5');

-- ALTER TABLE `movies`
-- ADD COLUMN `director_id` INT,
-- ADD CONSTRAINT fk_director_id
-- FOREIGN KEY `movies` (`director_id`) 
-- REFERENCES `directors` (`id`);

-- ALTER TABLE `minions`
-- ADD COLUMN `town_id` INT,
-- ADD CONSTRAINT fk_minions_towns 
-- FOREIGN KEY `minions` (`town_id`) 
-- REFERENCES `towns` (`id`);

CREATE DATABASE `car_rental`;
USE `car_rental`;

CREATE TABLE `categories`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`category` VARCHAR(50) NOT NULL,
`daily_rate` DOUBLE,
`weekly_rate` DOUBLE,
`monthly_rate` DOUBLE, 
`weekend_rate` DOUBLE
);

INSERT INTO `categories` (`category`)
VALUES 
('Test CAR1'),
('Test CAR2'),
('Test CAR3');

CREATE TABLE `cars`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`plate_number` VARCHAR(10) NOT NULL UNIQUE,
`make` VARCHAR(50) NOT NULL,
`model` VARCHAR(50) NOT NULL,
`car_year` YEAR,
`category_id` INT, 
`doors` INT,
`picture` BLOB,
`car_condition` VARCHAR(100),
`available` BOOLEAN
);

INSERT INTO `cars` (`plate_number`, `make`, `model`)
VALUES 
('123ASbe', 'Test CAR1', 'Test CAR1'),
('de2131Q', 'Test CAR2', 'Test CAR2'),
('242fgR', 'Test CAR3', 'Test CAR3');

CREATE TABLE `employees`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`first_name` VARCHAR(20) NOT NULL,
`last_name` VARCHAR(20) NOT NULL,
`title` VARCHAR(20) NOT NULL,
`notes` TEXT
);

INSERT INTO `employees` (`first_name`, `last_name`, `title`)
VALUES 
('Peter', 'Test1', 'Test1'),
('Ivan', 'Test2', 'Test2'),
('Stoyan', 'Test3', 'Test3');

CREATE TABLE `customers`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`driver_licence_number` INT NOT NULL UNIQUE,
`full_name` VARCHAR(40) NOT NULL,
`address` VARCHAR(100) NOT NULL,
`city` VARCHAR(20) NOT NULL,
`zip_code` INT NOT NULL, 
`notes` TEXT
);

INSERT INTO `customers` (`driver_licence_number`, `full_name`, `address`, `city`, `zip_code`)
VALUES 
(12354231, 'Ivan Ivanov', 'Dondukov str. 55', 'Sofia', 1000),
(34323432, 'Peter Ivanov', 'Dondukov str. 59', 'Sofia', 1000),
(65456344, 'Iva Popova', 'Dondukov str. 56', 'Sofia', 1000);

CREATE TABLE `rental_orders`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`employee_id` INT NOT NULL,
`customer_id` INT NOT NULL,
`car_id` INT NOT NULL,
`car_condition` VARCHAR(100),
`tank_level` VARCHAR(20),
`kilometrage_start` INT,
`kilometrage_end` INT,
`total_kilometrage` INT,
`start_date` DATE,
`end_date` DATE,
`total_days` INT,
`rate_applied` DOUBLE,
`tax_rate` DOUBLE,
`order_status` BOOLEAN,
`notes` TEXT
);

INSERT INTO `rental_orders` (`employee_id`, `customer_id`, `car_id`)
VALUES 
(12354231, 2, 213),
(34323432, 5, 432),
(65456344, 77, 542);

CREATE DATABASE `soft_uni`;
USE `soft_uni`;

CREATE TABLE `towns`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(45)
);

CREATE TABLE `addresses`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`address_text` VARCHAR(45),
`town_id` INT,
CONSTRAINT fk_addresses_towns
FOREIGN KEY `addresses`(`town_id`)
REFERENCES `towns`(`id`)
);

CREATE TABLE `departments`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(45)
);

CREATE TABLE `employees`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`first_name` VARCHAR(30) NOT NULL,
`middle_name` VARCHAR(30) NOT NULL,
`last_name` VARCHAR(30) NOT NULL,
`job_title` VARCHAR(20) NOT NULL,
`department_id` INT NOT NULL,
`hire_date` DATE,
`salary` DECIMAL(15,2), 
`address_id` INT,
CONSTRAINT fk_employees_departments
FOREIGN KEY `employees`(`department_id`)
REFERENCES `departments`(`id`),
CONSTRAINT fk_employees_addresses
FOREIGN KEY `employees`(`address_id`)
REFERENCES `addresses`(`id`)
);

INSERT INTO `towns` (`name`)
VALUES 
('Sofia'),
('Plovdiv'),
('Varna'),
('Burgas');

INSERT INTO `departments` (`name`)
VALUES 
('Engineering'),
('Sales'),
('Marketing'),
('Software Development'),
('Quality Assurance');
 
INSERT INTO `employees` (`first_name`, `middle_name`, `last_name`, `job_title`,  `department_id`, `hire_date`, `salary`)
VALUES 
('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '2013-02-01', 3500.00),
('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '2004-03-02', 4000.00),
('Maria', 'Petrova', 'Ivanova', 'Intern', 5, '2016-08-28', 525.25),
('Georgi', 'Terziev', 'Ivanov', 'CEO', 2, '2007-12-09', 3000.00),
('Peter', 'Pan', 'Pan', 'Intern', 3, '2016-08-28', 599.88);

-- SELECT * FROM `towns`
SELECT `name` FROM `towns`
ORDER BY `name`;

SELECT `name` FROM `departments`
ORDER BY `name`;

SELECT `first_name`, `last_name`, `job_title`, `salary` FROM `employees`
ORDER BY `salary` DESC;

-- DELETE FROM `soft_uni`.`departments`
-- WHERE <(where_expression)>;

UPDATE `employees`
SET `salary` = `salary` * 1.1;
SELECT `salary` FROM `employees`;

DELETE FROM occupancies;

SHOW CREATE TABLE `employees`;
SHOW ENGINES;
SHOW TABLE STATUS LIKE `employees`;
