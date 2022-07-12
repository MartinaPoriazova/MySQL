DROP FUNCTION IF EXISTS ufn_count_employees_by_town;
DELIMITER //
CREATE FUNCTION ufn_count_employees_by_town(town_name VARCHAR(50)) 
RETURNS INT DETERMINISTIC
BEGIN
	DECLARE emp_count INT;
    SET emp_count := (SELECT COUNT(*) FROM `employees`
    JOIN `addresses` USING(address_id)
    JOIN `towns` AS t USING(town_id)
    WHERE t.`name` = town_name);
	RETURN emp_count;
END//

DELIMITER ;

SELECT ufn_count_employees_by_town('Sofia');
SELECT employee_id, first_name, last_name, t.`name` FROM `employees`
    JOIN `addresses` USING(address_id)
    JOIN `towns` AS t USING(town_id)
    WHERE t.`name` = 'Sofia';
    
    -- Procedures --
    
DROP PROCEDURE IF EXISTS usp_select_employees_by_seniority;
DELIMITER $$
CREATE PROCEDURE usp_select_employees_by_seniority() 
BEGIN
  SELECT * 
  FROM employees
  WHERE ROUND((DATEDIFF(NOW(), hire_date) / 365.25)) < 15;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS usp_select_employees_by_seniority;
DELIMITER //
CREATE PROCEDURE usp_select_employees_by_seniority(IN years_employed INT) 
BEGIN
  SELECT e.employee_id, e.first_name, e.last_name, e.hire_date, ROUND(DATEDIFF(NOW(), hire_date) / 365.25)
  FROM employees AS e
  WHERE ROUND(DATEDIFF(NOW(), hire_date) / 365.25) < years_employed;
END//
DELIMITER ;

CALL usp_select_employees_by_seniority(15);


-- IN OUT Params

DROP PROCEDURE IF EXISTS `usp_add_numbers`;

DELIMITER $$
USE `soft_uni`$$
CREATE PROCEDURE `usp_add_numbers` (
	IN a INT,
    IN b INT, 
    out result INT)
BEGIN
	SET result = a + b;
END$$

DELIMITER ;

SET @result = 0;
CALL usp_add_numbers(37, 5, @result);
SELECT @result;

# 02

DROP PROCEDURE IF EXISTS `usp_raise_salaries`;
DELIMITER $$
CREATE PROCEDURE `usp_raise_salaries` (IN department_name VARCHAR(50))
BEGIN
	UPDATE employees JOIN departments d USING(department_id)
    SET salary = salary * 1.05
    WHERE d.`name` = department_name;
END$$
DELIMITER ;
CALL `usp_raise_salaries`('Sales');

SELECT employee_id, first_name, last_name, salary
FROM employees JOIN departments AS d USING(department_id)
WHERE d.`name` = 'Sales';

CALL `usp_raise_salaries`('Sales');



DROP PROCEDURE IF EXISTS `usp_raise_salaries`;
DELIMITER $$
CREATE PROCEDURE `usp_raise_salaries` (
	IN department_name VARCHAR(50),
    IN percentage DOUBLE)
BEGIN
	UPDATE employees JOIN departments d USING(department_id)
    SET salary = salary * (1 + percentage/100)
    WHERE d.`name` = department_name;
END$$
DELIMITER ;
CALL `usp_raise_salaries`('Sales', 10);



# 03

DROP PROCEDURE IF EXISTS `usp_raise_salaries`;
DELIMITER $$
CREATE PROCEDURE usp_raise_salary_by_id(id INT)
BEGIN
	UPDATE employees
	SET salary = salary * 1.05
    WHERE employee_id = id;
END$$
DELIMITER ;


# 04 Trigger

CREATE TABLE `deleted_employees` (
    `employee_id` INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `first_name` VARCHAR(50) NOT NULL,
    `last_name` VARCHAR(50) NOT NULL,
    `middle_name` VARCHAR(50) DEFAULT NULL,
    `job_title` VARCHAR(50) NOT NULL,
    `department_id` INT(10) NOT NULL,
    `salary` DECIMAL(19 , 4 ) NOT NULL
);

CREATE 
    TRIGGER `trigger_employee`
 BEFORE DELETE ON `employees` FOR EACH ROW 
    INSERT INTO `deleted_employees`(
    `first_name`, 
    `last_name`, 
    `middle_name`, 
    `job_title`, 
    `department_id`, 
    `salary`) 
    VALUES (
    OLD.`first_name`, 
    OLD.`last_name`, 
    OLD.`middle_name`, 
    OLD.`job_title`, 
    OLD.`department_id`, 
    OLD.`salary`);

