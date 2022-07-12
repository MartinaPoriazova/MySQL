SELECT e.`employee_id`, e.`job_title`, a.`address_id`, a.`address_text`
FROM `employees` AS e JOIN `addresses` as a
ON e.`address_id` = a.`address_id`
ORDER BY `address_id`
LIMIT 5;

SELECT e.`first_name`, e.`last_name`, t.`name` AS `town`, a.`address_text`
FROM `employees` AS e 
JOIN `addresses` as a
ON e.`address_id` = a.`address_id`
JOIN `towns` as t
ON a.`town_id` = t.`town_id`
ORDER BY `first_name`, `last_name`
LIMIT 5;

SELECT e.`employee_id`, e.`first_name`, e.`last_name`, d.`name` AS `department_name`
FROM `employees` AS e
JOIN `departments` AS d
ON e.`department_id` = d.`department_id`
WHERE d.`name` = 'Sales'
ORDER BY e.`employee_id` DESC;

SELECT e.`employee_id`, e.`first_name`, e.`salary`, d.`name` AS `department_name`
FROM `employees` AS e
JOIN `departments` AS d
ON e.`department_id` = d.`department_id`
WHERE e.`salary` > 15000
ORDER BY d.`department_id` DESC
LIMIT 5;



SELECT e.`employee_id`, e.`first_name`
FROM `employees` AS e
LEFT JOIN `employees_projects` AS ep
ON e.`employee_id` = ep.`employee_id`
WHERE ep.`project_id` IS NULL
ORDER BY e.`employee_id` DESC
LIMIT 3;

SELECT e.`employee_id`, e.`first_name`
FROM `employees` AS e
WHERE e.`employee_id` NOT IN (
SELECT `employee_id`
FROM `employees_projects`
)
ORDER BY e.`employee_id` DESC
LIMIT 3;



SELECT e.`first_name`, e.`last_name`, e.`hire_date`, d.`name` AS `dept_name`
FROM `employees` AS e
JOIN `departments` AS d
ON e.`department_id` = d.`department_id`
WHERE e.`hire_date` > '1999-01-01' 
AND d.`name` IN ('Sales', 'Finance')
ORDER BY e.`hire_date`;

SELECT e.`employee_id`, e.`first_name`, p.`name` AS `project_name`
FROM `employees` AS e
JOIN `employees_projects` AS ep
ON e.`employee_id` = ep.`employee_id`
JOIN `projects` AS p
ON ep.`project_id` = p.`project_id`
WHERE DATE(p.`start_date`) >= '2002-08-14' 
AND p.`end_date` IS NULL
ORDER BY e.`first_name`, p.`name`
LIMIT 5;

SELECT e.`employee_id`, e.`first_name`, 
IF(YEAR(p.`start_date`) < 2005, p.`name`, NULL) AS `project_name`
FROM `employees` AS e
JOIN `employees_projects` AS ep
ON e.`employee_id` = ep.`employee_id`
JOIN `projects` AS p
ON ep.`project_id` = p.`project_id`
WHERE e.`employee_id` = 24 
ORDER BY p.`name`;

#8

SELECT `employee_id`, `first_name`, 
(SELECT first_name FROM employees WHERE employee_id = e.manager_id) AS manager_name
FROM `employees` AS e
WHERE `manager_id` IN (3, 7)
ORDER BY `first_name`;

#9

SELECT e.`employee_id`, e.`first_name`, e.`manager_id`, (
			SELECT `first_name` 
			FROM `employees`
			WHERE `employee_id` = e.`manager_id`
) AS `manager_name`
FROM `employees` AS e
WHERE e.`manager_id` IN (3, 7)
ORDER BY e.`first_name`;

#10

SELECT e.`employee_id`, CONCAT(e.`first_name`, ' ', e.`last_name`) AS `employee_name`, (
			SELECT CONCAT(`first_name`, ' ', `last_name`)
			FROM `employees`
			WHERE `employee_id` = e.`manager_id`
) AS `manager_name`, d.`name` AS `department_name`
FROM `employees` AS e
JOIN `departments` AS d
ON e.`department_id` = d.`department_id`
WHERE e.`manager_id` IS NOT NULL
ORDER BY e.`employee_id`
LIMIT 5;

#11

SELECT AVG(`salary`) AS `min_average_salary`
FROM `employees`
GROUP BY `department_id`
ORDER BY `min_average_salary` 
LIMIT 1;

#12

SELECT mc.`country_code`, m.`mountain_range`, p.`peak_name`, p.`elevation`
FROM `mountains_countries` AS mc
JOIN `mountains` AS m
ON mc.`mountain_id` = m.`id`
JOIN `peaks` AS p
ON p.`mountain_id` = m.`id`
WHERE mc.`country_code` = 'BG' AND p.`elevation` > 2835
ORDER BY p.`elevation` DESC;

SELECT mc.country_code, m.mountain_range, p.peak_name, p.elevation
	FROM peaks AS p
    JOIN mountains AS m 
    ON  m.id = p.mountain_id
    JOIN mountains_countries AS mc 
    ON mc.mountain_id = m.id
    WHERE p.elevation > 2835 AND mc.country_code = 'BG'
    ORDER BY  p.elevation DESC;

#13

SELECT c.`country_code`, COUNT(m.`mountain_range`) AS `mountain_range`
FROM `countries` AS c
JOIN `mountains_countries` AS mc
ON c.`country_code` = mc.`country_code`
JOIN `mountains` AS m
ON mc.`mountain_id` = m.`id`
WHERE c.`country_code` IN ('BG', 'RU', 'US')
GROUP BY c.`country_code`
ORDER BY `mountain_range` DESC;

SELECT mc.country_code, COUNT(mc.mountain_id) AS 'mountain_range'
	FROM mountains_countries AS mc
	JOIN countries AS c USING(country_code)
	WHERE c.country_name IN ('United States', 'Russia', 'Bulgaria')
	GROUP BY country_code
	ORDER BY `mountain_range` DESC;
    
#14

SELECT c.`country_name`, r.`river_name`
FROM `continents` AS con
JOIN `countries` AS c
ON c.`continent_code` = con.`continent_code`
LEFT JOIN `countries_rivers` AS cr
ON c.`country_code` = cr.`country_code`
LEFT JOIN `rivers` AS r
ON cr.`river_id` = r.`id`
WHERE con.`continent_code` = 'AF'
ORDER BY c.`country_name`
LIMIT 5;

SELECT c.country_name, r.river_name
	FROM continents AS cn
	JOIN countries AS c USING(continent_code)
    LEFT JOIN countries_rivers AS cr USING(country_code)
    LEFT JOIN rivers AS r ON r.id = cr.river_id
    WHERE cn.continent_name = 'Africa'
    ORDER BY c.country_name
    LIMIT 5;

#15

SELECT c.`continent_code`, c.`currency_code`, COUNT(*) AS `currency_usage`
FROM `countries` AS c
GROUP BY c.`continent_code` , c.`currency_code`
HAVING `currency_usage` > 1 AND `currency_usage` = (
		SELECT COUNT(*) AS cn
    FROM `countries` AS c2
    WHERE c2.`continent_code` = c.`continent_code`
    GROUP BY c2.`currency_code`
    ORDER BY cn DESC
    LIMIT 1)
ORDER BY c.`continent_code`, c.`continent_code`;


SELECT
    c.continent_code,
    c.currency_code,
    COUNT(*) AS 'currency_usage'
FROM
    `countries` AS c
GROUP BY c.continent_code , c.currency_code
HAVING `currency_usage` > 1
    AND `currency_usage` = (SELECT
        COUNT(*) AS cn
    FROM
        `countries` AS c2
    WHERE
        c2.continent_code = c.continent_code
    GROUP BY c2.currency_code
    ORDER BY cn DESC
    LIMIT 1)
ORDER BY c.continent_code , c.continent_code;

#16

SELECT COUNT(*) AS `country_count`
FROM `countries` AS c
LEFT JOIN `mountains_countries` AS mc
ON c.`country_code` = mc.`country_code`
WHERE mc.`mountain_id` IS NUll;


#17

SELECT 
    c.`country_name`,
    MAX(p.elevation) AS `highest_peak_elevation`,
    MAX(r.length) AS `longest_river_length`
FROM
    `countries` AS c
        JOIN
    `countries_rivers` AS cr ON c.`country_code` = cr.`country_code`
        JOIN
    `rivers` AS r ON cr.`river_id` = r.`id`
        JOIN
    `mountains_countries` AS mc ON c.`country_code` = mc.`country_code`
        JOIN
    `mountains` AS m ON mc.`mountain_id` = m.`id`
        JOIN
    `peaks` AS p ON m.`id` = p.`mountain_id`
GROUP BY c.`country_name`
ORDER BY `highest_peak_elevation` DESC , `longest_river_length` DESC , c.`country_name`
LIMIT 5;

