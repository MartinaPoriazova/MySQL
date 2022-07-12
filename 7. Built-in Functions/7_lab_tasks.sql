SELECT `title` FROM `books`
WHERE substring(`title`, 1, 3) = 'The'
ORDER BY `id`;

SELECT REPLACE(`title`, 'The', '***') 
AS 'Title' FROM `books`
WHERE substring(`title`, 1, 3) = 'The';

SELECT INSERT(`title`, LOCATE('The', `title`), 3, '***') 
AS 'Title' FROM `books`
WHERE substring(`title`, 1, 3) = 'The';

SELECT `title`, LOCATE('The', `title`, 1) 
AS 'Index of The' FROM `books`;

SELECT round(SUM(`cost`), 2) AS `total_cost` FROM `books`;

SELECT concat_ws(' ', `first_name`, `last_name`) AS `full_name`, 
timestampdiff(DAY, `born`, `died`) AS `days_lived` FROM `authors`;

SELECT concat_ws(' ', `first_name`, `last_name`) AS `full_name`, 
timestampdiff(YEAR, `born`, `died`) AS `days_lived` FROM `authors`;

SELECT concat_ws(' ', `first_name`, `last_name`) AS `full_name`, 
timestampdiff(YEAR, `born`, IFNULL(`died`, NOW())) AS `days_lived` FROM `authors`;

SELECT concat(`first_name`, ' ', `last_name`) AS `full_name`,
DATE_FORMAT(`born`, '%b %D, %Y') AS `Born`,
DATE_FORMAT(`died`, '%b %D, %Y') AS `Died`,
timestampdiff(YEAR, `born`, IFNULL(`died`, NOW())) AS `days_lived` 
FROM `authors`;

SELECT `title` FROM `books`
WHERE `title` LIKE '%Harry Potter%';


