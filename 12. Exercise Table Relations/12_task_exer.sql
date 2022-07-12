CREATE TABLE `passports`(
`passport_id` INT AUTO_INCREMENT PRIMARY KEY,
`passport_number` VARCHAR(10) NOT NULL UNIQUE
);

CREATE TABLE `people`(
`person_id` INT AUTO_INCREMENT PRIMARY KEY,
`first_name` VARCHAR(45) NOT NULL,
`salary` DECIMAL(10, 2),
`passport_id` INT UNIQUE NOT NULL,
CONSTRAINT `fk_passport_id` 
FOREIGN KEY (`passport_id`)
REFERENCES `passports` (`passport_id`)
);

INSERT INTO `passports`(`passport_id`, `passport_number`)
VALUES
(101, 'N34FG21B'),
(102, 'K65LO4R7'),
(103, 'ZE657QP2');

INSERT INTO `people` (`first_name`, `salary`, `passport_id`)
VALUES
('Roberto', 43300.00, 102),
('Tom', 56100.00, 103),
('Yana', 60200.00, 101);

CREATE TABLE `manufacturers`(
`manufacturer_id` INT AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR(10) NOT NULL,
`established_on` DATE NOT NULL
);

CREATE TABLE `models`(
`model_id` INT AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR(45) NOT NULL,
`manufacturer_id` INT NOT NULL,
CONSTRAINT `fk_manufacturer_id` 
FOREIGN KEY (`manufacturer_id`)
REFERENCES `manufacturers` (`manufacturer_id`)
);

INSERT INTO `manufacturers` (`name`, `established_on`)
VALUES
('BMW', '1916-03-01'),
('Tesla', '2003-01-01'),
('Lada', '1966-05-01');

INSERT INTO `models` (`model_id`, `name`, `manufacturer_id`)
VALUES
(101, 'X1', 1),
(102, 'i6', 1),
(103, 'Model S', 2),
(104, 'Model X', 2),
(105, 'Model 3', 2),
(106, 'Nova', 3);

SELECT mo.name, m.name FROM `models` AS mo
JOIN `manufacturers` AS m
ON mo.manufacturer_id = m.manufacturer_id;

SELECT * FROM `models` AS mo
JOIN `manufacturers` AS m
ON mo.manufacturer_id = m.manufacturer_id;

CREATE TABLE `students` (
`student_id` INT AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR(45) NOT NULL
);

INSERT INTO `students` (`name`)
VALUES
('Mila'),
('Toni'),
('Ron');

CREATE TABLE `exams` (
`exam_id` INT AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR(45) NOT NULL
);

INSERT INTO `exams` (`exam_id`, `name`)
VALUES
(101, 'Spring MVC'),
(102, 'Neo4j'),
(103, 'Oracle 11g');

CREATE TABLE `students_exams` (
`student_id` INT,
`exam_id` INT,
CONSTRAINT `fk_student_id` 
FOREIGN KEY (`student_id`)
REFERENCES `students` (`student_id`),
CONSTRAINT `fk_exam_id` 
FOREIGN KEY (`exam_id`)
REFERENCES `exams` (`exam_id`)
);

INSERT INTO `students_exams` (`student_id`, `exam_id`)
VALUES
(1, 101),
(1, 102),
(2, 101),
(3, 103),
(2, 102),
(2, 103);

CREATE TABLE `teachers`(
`teacher_id` INT AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR(45) NOT NULL,
`manager_id` INT
);

INSERT INTO `teachers` (`teacher_id`, `name`, `manager_id`)
VALUES
(101, 'John', NULL),
(102, 'Maya', 106),
(103, 'Silvia', 106),
(104, 'Ted', 105),
(105, 'Mark', 101),
(106, 'Greta', 101);

ALTER TABLE `teachers`
ADD CONSTRAINT `fk_manager_id`
FOREIGN KEY (`manager_id`)
REFERENCES `teachers`(`teacher_id`);


CREATE TABLE `cities`(
`city_id` INT AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR(50)
);

CREATE TABLE `customers`(
`customer_id` INT AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR(50),
`birthday` DATE,
`city_id` INT,
CONSTRAINT `fk_city_id` 
FOREIGN KEY (`city_id`)
REFERENCES `cities` (`city_id`)
);

CREATE TABLE `orders`(
`order_id` INT AUTO_INCREMENT PRIMARY KEY,
`customer_id` INT,
CONSTRAINT `fk_customer_id` 
FOREIGN KEY (`customer_id`)
REFERENCES `customers` (`customer_id`)
);

CREATE TABLE `item_types`(
`item_type_id` INT AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR(50)
);

CREATE TABLE `items`(
`item_id` INT AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR(50),
`item_type_id` INT,
CONSTRAINT `fk_item_type_id` 
FOREIGN KEY (`item_type_id`)
REFERENCES `item_types` (`item_type_id`)
);

CREATE TABLE `order_items`(
`order_id` INT,
`item_id` INT,
CONSTRAINT `pk_oreder_items`
PRIMARY KEY (`order_id`, `item_id`),
CONSTRAINT `fk_order_id` 
FOREIGN KEY (`order_id`)
REFERENCES `orders` (`order_id`), 
CONSTRAINT `fk_item_id` 
FOREIGN KEY (`item_id`)
REFERENCES `items` (`item_id`)
);



CREATE TABLE `majors`(
`major_id` INT AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR(50)
);

CREATE TABLE `students`(
`student_id` INT AUTO_INCREMENT PRIMARY KEY,
`student_number` VARCHAR(12),
`student_name` VARCHAR(50),
`major_id` INT,
CONSTRAINT `fk_students_majors` 
FOREIGN KEY (`major_id`)
REFERENCES `majors` (`major_id`)
);

CREATE TABLE `subjects`(
`subject_id` INT AUTO_INCREMENT PRIMARY KEY,
`subject_name` VARCHAR(50)
);

CREATE TABLE `agenda`(
`student_id` INT,
`subject_id` INT,
CONSTRAINT `pk_agenda`
PRIMARY KEY (`student_id`, `subject_id`),
CONSTRAINT `fk_agenda_students` 
FOREIGN KEY (`student_id`)
REFERENCES `students` (`student_id`), 
CONSTRAINT `fk_agenda_subjects` 
FOREIGN KEY (`subject_id`)
REFERENCES `subjects` (`subject_id`)
);

CREATE TABLE `payments`(
`payment_id` INT AUTO_INCREMENT PRIMARY KEY,
`payment_date` DATE,
`payment_amount` DECIMAL (8, 2),
`student_id` INT,
CONSTRAINT `fk_payments_students` 
FOREIGN KEY (`student_id`)
REFERENCES `students` (`student_id`)
);


SELECT mo.mountain_range, p.peak_name, p.elevation FROM `mountains` AS mo
JOIN `peaks` AS p
ON mo.id = p.mountain_id
WHERE `mountain_range` = 'Rila'
ORDER BY `elevation` DESC;
