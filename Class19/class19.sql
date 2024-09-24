USE sakila;

-- QUERY 1
-- Create a user named analyst_user.

CREATE USER 'analyst_user'@'localhost' IDENTIFIED BY 'securepass';
-- User can access from localhost only
CREATE USER 'analyst_user'@'%' IDENTIFIED BY 'securepass';
-- User can access from any host

-- QUERY 2
-- Grant permissions only for SELECT, UPDATE, and DELETE on all sakila tables.

GRANT SELECT, UPDATE, DELETE ON sakila.* TO 'analyst_user'@'localhost';
SHOW GRANTS FOR 'analyst_user'@'localhost';

-- QUERY 3
-- Login with this user and attempt to create a table. Show the result of the operation.

-- To log in with this user, use the following bash command:
-- mysql -u analyst_user -p
-- Then, attempt to create a table with the following query:
CREATE TABLE region (
  region_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  region_name VARCHAR(50) NOT NULL,
  country_id SMALLINT UNSIGNED NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (region_id),
  KEY idx_fk_country_id (country_id),
  CONSTRAINT `fk_region_country` FOREIGN KEY (country_id) REFERENCES country (country_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- This returns the following error:
-- ERROR 1142 (42000): CREATE command denied to user 'analyst_user'@'localhost' for table 'region'

-- QUERY 4
-- Try to update a film title. Use the following update script.

SELECT title FROM film WHERE film_id = 371;
UPDATE film SET title='Return of the Wind' WHERE film_id = 371;

-- Response:
-- Query OK, 1 row affected (0.04 sec)
-- Rows matched: 1  Changed: 1  Warnings: 0

-- QUERY 5
-- With root or any admin user, revoke the UPDATE permission. Use the following command.

REVOKE UPDATE ON sakila.* FROM 'analyst_user'@'localhost';
FLUSH PRIVILEGES;

-- QUERY 6
-- Login again with analyst_user and try the update from step 4. Show the result.

UPDATE film SET title='Wind and the Tide' WHERE film_id = 371;

-- Response:
-- ERROR 1142 (42000): UPDATE command denied to user 'analyst_user'@'localhost' for table 'film'

