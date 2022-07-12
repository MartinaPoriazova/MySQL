SELECT `employee_id`, CONCAT(`first_name`, ' ', `last_name`) AS `full_name`, 
d.`department_id`, `name` AS `department_name`
FROM `departments` AS d
JOIN `employees` AS e ON d.`manager_id` = e.`employee_id`
ORDER BY `employee_id`
LIMIT 5;

SELECT COUNT(`employee_id`)
FROM `employees`
WHERE `salary` > (
SELECT AVG(`salary`)
FROM `employees`
);

SELECT `employee_id`, CONCAT(`first_name`, ' ', `last_name`) AS `full_name`, `salary`
FROM `employees`
WHERE `salary` > (
SELECT AVG(`salary`)
FROM `employees`
);

SELECT a.`town_id`, `name` AS `town_name`, `address_text`
FROM `addresses` AS a, `towns` AS t
WHERE a.`town_id` = t.`town_id` AND `name` IN('San Francisco', 'Sofia','Carnation')
ORDER BY t.`town_id`;

SELECT a.`town_id`, `name` AS `town_name`, `address_text`
FROM `addresses` AS a JOIN `towns` AS t
ON a.`town_id` = t.`town_id` AND `name` IN('San Francisco', 'Sofia','Carnation')
ORDER BY t.`town_id`;

SELECT `employee_id`, `first_name`, `last_name`, d.`department_id`, `salary`
FROM `employees` AS e JOIN `departments` AS d
ON e.`department_id` = d.`department_id`
WHERE e.`manager_id` IS NULL;

SELECT e.`employee_id` id, e.first_name, e.last_name, d.`name` department, 
a.address_text AS `address`, t.`name` town
FROM `departments` AS d 
JOIN `employees` AS e 
ON d.department_id = e.department_id
JOIN `addresses` AS a 
ON e.address_id = a.address_id
JOIN `towns` t 
ON a.town_id = t.town_id
ORDER BY e.employee_id;

