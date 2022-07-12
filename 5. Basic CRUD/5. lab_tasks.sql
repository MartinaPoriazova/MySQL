SELECT `id`, `first_name`, `last_name`, `job_title` FROM `employees`
ORDER BY `id`;

SELECT concat(`first_name`,' ',`last_name`) AS 'full_name' FROM `employees`;

SELECT `id`, concat(`first_name`,' ',`last_name`) AS 'full_name', `job_title`, `salary` 
FROM `employees` 
WHERE `salary` > 1000.00
ORDER BY `id`;

SELECT * FROM employees AS e
WHERE e.department_id = 4 AND e.salary >= 1000;

UPDATE `employees`
SET `salary` = `salary` + 100 WHERE `job_title` = 'Manager';
SELECT `salary` FROM `employees`;

SELECT DISTINCT `last_name`, `department_id` FROM `employees`
WHERE `salary` <= 1500;

SELECT * FROM `employees`
WHERE `department_id` = 4;

SELECT * FROM `employees`
WHERE `department_id` IN (1, 4) and `salary` >= 1500;

SELECT * FROM `employees`
WHERE `department_id` = 4 and `salary` >= 1000;

CREATE VIEW `employees_name_salary` AS
SELECT `id`, concat(`first_name`,' ',`last_name`) AS 'full_name',
`salary` FROM `employees`;
SELECT * FROM `employees_name_salary`;

SELECT * FROM `employees` 
LIMIT 0,5;

SELECT `id`, `first_name`, `last_name`, `job_title`, `department_id`, `salary` FROM `employees`
ORDER BY `salary` DESC 
LIMIT 1;

CREATE VIEW `top_paid_employee` AS
SELECT * FROM `employees`
ORDER BY `salary` DESC 
LIMIT 1;
SELECT * FROM `top_paid_employee`;

SELECT `id`, `first_name`, `last_name`, `job_title`, `department_id`, `salary` FROM `employees`
WHERE `department_id` is not null
ORDER BY `salary` ASC;

DELETE `id`, `first_name`, `last_name`, `job_title`, `department_id`, `salary` FROM `employees`
WHERE `department_id` IN (1, 2);

DELETE FROM `employees` WHERE employees.department_id IN (2, 1);
SELECT * FROM `employees`
ORDER BY `id`;

CREATE TABLE `customer_contacts`
AS SELECT `id`, `first_name`, `last_name`
FROM `clients`;

SHOW CREATE TABLE `customer_contacts`;

