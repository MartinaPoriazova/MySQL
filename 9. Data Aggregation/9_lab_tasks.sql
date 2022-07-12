USE `soft_uni`;
SELECT `department_id`, ROUND(SUM(`salary`), 2)
AS `Salary Sum` FROM `employees`
GROUP BY `department_id`
ORDER BY `department_id`;

SELECT `id`, `first_name`, `last_name`, `salary`
FROM `employees` 
where `department_id` = 16;

USE `restaurant`;

SELECT `department_id`, COUNT(`id`) AS `Number of employees`
FROM `employees`
GROUP BY `department_id`
ORDER BY `department_id`;

-- the same:
SELECT `department_id`, COUNT(`id`) AS `Number of employees`
FROM `employees`
GROUP BY `department_id`
ORDER BY COUNT(`id`);

SELECT `department_id`, COUNT(`id`) AS `Number of employees`
FROM `employees`
GROUP BY `department_id`
ORDER BY `Number of employees`;

SELECT `department_id`, ROUND(AVG(`salary`), 2) AS `Average Salary`
FROM `employees`
GROUP BY `department_id`
ORDER BY `department_id`;

SELECT `department_id`, ROUND(MIN(`salary`), 2) AS `Min Salary`
FROM `employees`
GROUP BY `department_id`
HAVING `Min Salary` > 800;

SELECT COUNT(*) AS `Count` 
FROM `products`
WHERE category_id = 2 AND price > 8;

# Add Examples

SELECT `category_id`, 
		ROUND(AVG(`price`), 2) AS `Average Price`,
        ROUND(MIN(`price`), 2) AS `Cheapest Product`,
        ROUND(MAX(`price`), 2) AS `Most Expensive Product`
FROM `products`
GROUP BY `category_id`;

SELECT `category_id`, `country`,
		COUNT(`price`) AS `Number of products`,
        ROUND(AVG(`price`), 2) AS `Average Price`
FROM `products`
GROUP BY `category_id`, `country`
HAVING `Number of products` >= 2;

SELECT `category_id`, `country`,
		COUNT(`price`) AS `Number of products`,
        ROUND(SUM(`price`), 2) AS `Total Price`
FROM `products`
GROUP BY `category_id`, `country` WITH ROLLUP;

SELECT `department_id`, 
ROUND(`salary`, 2) AS `Number of Salaries`,
COUNT(*) AS `Count`
FROM `employees`
GROUP BY `department_id`, ROUND(`salary`, 2)
ORDER BY `department_id`;

SELECT `department_id`, 
CEILING(`salary` / 1000) * 1000 AS `Number of Salaries`,
COUNT(*) AS `Count`
FROM `employees`
GROUP BY `department_id`, `Number of Salaries`
ORDER BY `department_id`;

SET SESSION sql_mode = sys.list_add(@@session.sql_mode, 'ÓNLY_FULL'),
SELECT `department_id`, ANY_VALUE(`job`), COUNT(`id`) AS `Number of Salaries`
FROM `employees`
GROUP BY `department_id`
ORDER BY `department_id`;