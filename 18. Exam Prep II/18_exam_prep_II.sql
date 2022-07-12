CREATE TABLE `users` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `username` VARCHAR(30) NOT NULL UNIQUE,
    `password` VARCHAR(30) NOT NULL,
    `email` VARCHAR(50) NOT NULL,
    `gender` CHAR(1) NOT NULL,
    `age` INT NOT NULL,
    `job_title` VARCHAR(40) NOT NULL,
    `ip` VARCHAR(30) NOT NULL
);

CREATE TABLE `addresses` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `address` VARCHAR(30) NOT NULL,
    `town` VARCHAR(30) NOT NULL,
    `country` VARCHAR(30) NOT NULL,
    `user_id` INT NOT NULL,
	CONSTRAINT fk_addresses_users
    FOREIGN KEY (`user_id`)
    REFERENCES `users` (`id`)
);

CREATE TABLE `photos` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `description` TEXT NOT NULL,
    `date` DATETIME NOT NULL,
    `views` INT NOT NULL DEFAULT 0
);

CREATE TABLE `users_photos` (
	`user_id` INT NOT NULL,
    `photo_id` INT NOT NULL,
	CONSTRAINT fk_users_photos_users
    FOREIGN KEY (`user_id`)
    REFERENCES `users` (`id`),
	CONSTRAINT fk_users_photos_photos
    FOREIGN KEY (`photo_id`)
    REFERENCES `photos` (`id`)
);

CREATE TABLE `likes` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `photo_id` INT,
    `user_id` INT,
    CONSTRAINT fk_likes_photos
    FOREIGN KEY (`photo_id`)
    REFERENCES `photos` (`id`),
	CONSTRAINT fk_likes_users
    FOREIGN KEY (`user_id`)
    REFERENCES `users` (`id`)
);

CREATE TABLE `comments` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`comment` VARCHAR(255) NOT NULL,
    `date` DATETIME NOT NULL,
    `photo_id` INT NOT NULL,
	CONSTRAINT fk_comments_photos
    FOREIGN KEY (`photo_id`)
    REFERENCES `photos` (`id`)
);


# 02

INSERT INTO `addresses`(`address`, `town`, `country`, `user_id`)
SELECT `username`, `password`, `ip`, `age`
FROM `users`
WHERE `gender` = 'M';


# 03

UPDATE `addresses`
SET `country` = 
	(CASE LEFT(`country`, 1)
		WHEN 'B' THEN 'Blocked'
		WHEN 'T' THEN 'Test'
		WHEN 'P' THEN 'In Progress'
	END)
WHERE LEFT(`country`, 1) IN ('B', 'T', 'P'); # може и без where, Но трябва да има else `country` си е тя


# 04
 
DELETE FROM `addresses`
WHERE `id` % 3 = 0;


# 05

SELECT `username`, `gender`, `age`
FROM `users`
ORDER BY `age` DESC, `username`;


# 06

SELECT ph.`id`, ph.`date` AS `date_and_time`, ph.`description`, COUNT(c.`id`) AS `commentsCount`
FROM `photos` AS ph
JOIN `comments` AS c
ON ph.`id` = c.`photo_id`
GROUP BY ph.`id`
ORDER BY `commentsCount` DESC, ph.`id`
LIMIT 5;


# 07

SELECT CONCAT_WS(' ', u.`id`, u.`username`) AS `id_username`, u.`email`
FROM `users` AS u
JOIN `users_photos` AS up
ON u.`id` = up.`user_id`
#JOIN `photos` AS p
#ON up.`photo_id` = p.`id`
WHERE u.`id` = up.`photo_id`
ORDER BY u.`id`;


# 08

SELECT p.`id`, COUNT(DISTINCT l.`id`) AS `likes_count`, COUNT(DISTINCT c.`id`) AS `comments_count`
FROM `photos` AS p
LEFT JOIN `likes` AS l
ON p.`id` = l.`photo_id`
LEFT JOIN `comments` AS c
ON p.`id` = c.`photo_id`
GROUP BY p.`id`
ORDER BY `likes_count` DESC, `comments_count` DESC, p.`id`;


SELECT p.`id`,  
(SELECT COUNT(*) FROM `likes` WHERE photo_id = p.`id`) AS `l_count`,
(SELECT COUNT(*) FROM `comments` WHERE photo_id = p.`id`) AS `c_count`
FROM `photos` AS p
ORDER BY `l_count` DESC, `c_count` DESC, p.`id`;

# 09

SELECT CONCAT(LEFT(p.`description`, 30), '...') AS `summary`, p.`date`
FROM `photos` AS p
WHERE DAY(p.`date`) = 10
ORDER BY p.`date` DESC;


# 10

DELIMITER $$

CREATE FUNCTION udf_users_photos_count(username VARCHAR(30))
RETURNS INT
DETERMINISTIC
BEGIN
	RETURN (SELECT COUNT(up.`photo_id`)
			FROM `users` AS u
			LEFT JOIN `users_photos` AS up
            ON u.`id` = up.`user_id`
            WHERE u.`username` = username
    );
END $$

DELIMITER ;

SELECT udf_users_photos_count('ssantryd') AS photosCount;


# 11


DELIMITER $$

CREATE PROCEDURE udp_modify_user(p_address VARCHAR(30), p_town VARCHAR(30))
BEGIN
	UPDATE `users` AS u
	JOIN `addresses` AS a
    ON u.`id` = a.`user_id`
    SET age = age + 10
	WHERE a.`address` = p_address AND a.`town` = p_town;
END $$

DELIMITER ;

CALL udp_modify_user ('97 Valley Edge Parkway', 'Divinópolis');
SELECT u.username, u.email, u.gender, u.age, u.job_title FROM users AS u
WHERE u.username = 'eblagden21';

