#1

DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above_35000()
BEGIN
	SELECT `first_name`, `last_name`
	FROM `employees`
	WHERE `salary` > 35000
	ORDER BY `first_name`, `last_name`, `employee_id`;
END $$

DELIMITER ;

CALL usp_get_employees_salary_above_35000(35000);

#2

DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above(min_salary DECIMAL(19, 4))
BEGIN
	SELECT `first_name`, `last_name`
	FROM `employees`
	WHERE `salary` >= min_salary
	ORDER BY `first_name`, `last_name`, `employee_id`;
END $$

DELIMITER ;

CALL usp_get_employees_salary_above(45000);

SELECT `first_name`, `last_name`
FROM `employees`
WHERE `salary` > 45000
ORDER BY `first_name`, `last_name`, `employee_id`;


# 03

DELIMITER $$
CREATE PROCEDURE usp_get_towns_starting_with(town_name VARCHAR(20))
BEGIN
	SELECT `name`
    FROM `towns`
    WHERE `name` LIKE CONCAT(town_name, '%')
    ORDER BY `name`;

END $$

DELIMITER ;

CALL usp_get_towns_starting_with('b');

# 04

DELIMITER $$
CREATE PROCEDURE usp_get_employees_from_town(town_name VARCHAR(20))
BEGIN
	SELECT e.`first_name`, e.`last_name`
    FROM `employees` AS e
    JOIN `addresses` AS a
    ON e.`address_id` = a.`address_id`
    JOIN `towns` AS t
    ON a.`town_id` = t.`town_id`
    WHERE t.`name` = town_name
    ORDER BY e.`first_name`, e.`last_name`, e.`employee_id`;

END $$

DELIMITER ;

CALL usp_get_employees_from_town('Sofia');

# 05

DELIMITER $$

CREATE FUNCTION ufn_get_salary_level(e_salary DECIMAL)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
	RETURN (CASE
				WHEN e_salary < 30000 THEN 'Low'
                WHEN e_salary BETWEEN 30000 AND 50000 THEN 'Average'
                WHEN e_salary > 50000 THEN 'High'
			END
	);
END $$

DELIMITER ;

SELECT ufn_get_salary_level(51000);

# 06

DELIMITER $$
CREATE PROCEDURE usp_get_employees_by_salary_level(s_level VARCHAR(10))
BEGIN
	SELECT e.`first_name`, e.`last_name`
	FROM `employees` AS e
	WHERE ufn_get_salary_level(`salary`) = s_level
	ORDER BY e.`first_name` DESC, e.`last_name` DESC;

END $$

DELIMITER ;

CALL usp_get_employees_by_salary_level('High');

# 07

DELIMITER $$
CREATE FUNCTION ufn_is_word_comprised(set_of_letters VARCHAR(50), word VARCHAR(50))  
RETURNS bit
DETERMINISTIC
BEGIN
	RETURN word REGEXP (concat('^[',set_of_letters,']*$'));
END $$

DELIMITER ;

SELECT ufn_is_word_comprised('asdf', 'safd');
SELECT ufn_is_word_comprised('asdf', 'csafd');

# 08

DELIMITER $$
CREATE PROCEDURE usp_get_holders_full_name()
BEGIN
	SELECT concat_ws(' ', `first_name`, `last_name`) as `full_name`
    FROM `account_holders` 
    ORDER BY `full_name`, `id`;
END $$
DELIMITER ;

CALL usp_get_holders_full_name();

# 09

DELIMITER $$

CREATE PROCEDURE usp_get_holders_with_balance_higher_than(money DECIMAL(19,4))
BEGIN
	SELECT `first_name`, `last_name` 
	FROM `account_holders` as ah
	RIGHT JOIN `accounts` as ac 
    ON ac.`account_holder_id` = ah.`id`
    GROUP BY ah.id
    HAVING sum(`balance`) > money
    ORDER BY ah.`id`;
END $$

DELIMITER ;

CALL usp_get_holders_with_balance_higher_than(7000);


# 10 

DELIMITER $$
CREATE FUNCTION ufn_calculate_future_value(sum DECIMAL(19,4), interest DECIMAL(19,4), num_years INT)
RETURNS DECIMAL(19,4)
DETERMINISTIC
BEGIN
	RETURN sum * (pow((1 + interest), num_years));
END $$
DELIMITER ;

SELECT ufn_calculate_future_value(1000, 0.5, 5);

# 11


DELIMITER $$

CREATE PROCEDURE usp_calculate_future_value_for_account(acc_id INT, interest DECIMAL(19,4))
BEGIN
	SELECT a.`id` AS `account_id`, ah.`first_name`, ah.`last_name`, a.`balance` AS `current_balance`, 
    ufn_calculate_future_value(a.`balance`, interest, 5) AS `balance_in_5_years`
	FROM `accounts` AS a
	JOIN `account_holders` AS ah
    ON a.`account_holder_id` = ah.`id`
    WHERE a.`id` = acc_id;
END $$

DELIMITER ;

CALL usp_calculate_future_value_for_account(1, 0.1);


# 12 TRANSACTION


DELIMITER $$

CREATE PROCEDURE usp_deposit_money(account_id INT, money_amount DECIMAL(19,4))
BEGIN
	START TRANSACTION;
    IF (SELECT COUNT(*) FROM `accounts` WHERE `id` = account_id) = 0
		OR (money_amount <= 0)
		THEN ROLLBACK;
    ELSE 
		UPDATE `accounts`
        SET `balance` = `balance` + money_amount
        WHERE `id` = account_id;
    END IF;
END $$

DELIMITER ;

CALL usp_deposit_money(1, 10);
SELECT * FROM `accounts`;


# 13 withdraw

DELIMITER $$

CREATE PROCEDURE usp_withdraw_money(account_id INT, money_amount DECIMAL(19,4))
BEGIN
	START TRANSACTION;
    IF (SELECT COUNT(*) FROM `accounts` WHERE `id` = account_id) = 0
		OR (money_amount <= 0)
        OR ((SELECT `balance` FROM `accounts` WHERE `id` = account_id) <  money_amount)
		THEN ROLLBACK;
    ELSE 
		UPDATE `accounts`
        SET `balance` = `balance` - money_amount
        WHERE `id` = account_id;
    END IF;
END $$

DELIMITER ;

CALL usp_withdraw_money(1, 10);
SELECT * FROM `accounts`;

# 14 transfere between accounts

DELIMITER $$

CREATE PROCEDURE usp_transfer_money(from_account_id INT, to_account_id INT, amount DECIMAL(19,4))
BEGIN
	START TRANSACTION;
    IF (SELECT COUNT(*) FROM `accounts` WHERE `id` = from_account_id) = 0
		OR (SELECT COUNT(*) FROM `accounts` WHERE `id` = to_account_id) = 0
		OR from_account_id = to_account_id
		OR (amount <= 0)
        OR ((SELECT `balance` FROM `accounts` WHERE `id` = from_account_id) <  amount)
		THEN ROLLBACK;
    ELSE 
		UPDATE `accounts`
        SET `balance` = `balance` - amount
        WHERE `id` = from_account_id;
        UPDATE `accounts`
        SET `balance` = `balance` + amount
        WHERE `id` = to_account_id;
	COMMIT;
    END IF;
END $$

DELIMITER ;

CALL usp_transfer_money(1, 2, 10);
SELECT * FROM `accounts`;


# 15 Trigger


DELIMITER $$

CREATE TRIGGER tr_update_accounts
AFTER UPDATE
ON `accounts`
FOR EACH ROW
BEGIN
	INSERT INTO `logs`(`account_id`, `old_sum`, `new_sum`)
	VALUES (OLD.`id`, OLD.`balance`, NEW.`balance`);
END $$

DELIMITER ;


# 16

SELECT date_format(current_timestamp(), '%b %e %Y at %l:%i:%s %p');

CREATE TABLE `notification_emails` (
	`id` INT PRIMARY KEY AUTO_INCREMENT, 
    `recipient` INT NOT NULL, 
    `subject` VARCHAR(150), 
    `body` TEXT
);

DELIMITER $$

CREATE TRIGGER tr_create_new_email 
BEFORE INSERT
ON `logs`
FOR EACH ROW
BEGIN
	INSERT INTO `notification_emails`
    SET `recipient` = new.account_id,
		`subject` = concat('Balance change for account: ', new.account_id),
		`body` = concat('On ', date_format(current_timestamp(), '%b %e %Y at %l:%i:%s %p'),
					'AM your balance was changed from ', new.old_sum,
                    ' to ', new.new_sum, '.');
END $$

DELIMITER ;

SELECT * FROM `notification_emails`;


# 16 

CREATE TABLE `logs`(
`log_id` INT PRIMARY KEY AUTO_INCREMENT,
`account_id` INT NOT NULL,
`old_sum` DECIMAL(20, 4),
`new_sum` DECIMAL(20, 4));

DELIMITER $$

CREATE TRIGGER tr_balance_change
AFTER UPDATE
ON `accounts`
FOR EACH ROW
BEGIN
    IF OLD.balance <> NEW.balance THEN
    INSERT INTO `logs` (`account_id`, `old_sum`, `new_sum`)
    VALUES
    (OLD.id, ROUND(OLD.balance, 4), ROUND(NEW.balance, 4));
    END IF;
END $$

CREATE TABLE notification_emails(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`recipient` INT NOT NULL,
`subject` VARCHAR(50) NOT NULL,
`body` TEXT NOT NULL);

DELIMITER $$

CREATE TRIGGER tr_notifications_emails
AFTER INSERT
ON `logs`
FOR EACH ROW
BEGIN
    INSERT INTO notification_emails(`recipient`, `subject`, `body`)
    VALUES
    (NEW.account_id,
    CONCAT('Balance change for account: ', NEW.account_id),
    CONCAT('On ', DATE_FORMAT(NOW(), '%b %d %Y at %r'), 
        ' your balance was changed from ', NEW.old_sum, ' to ', NEW.new_sum, '.'));
END $$
	