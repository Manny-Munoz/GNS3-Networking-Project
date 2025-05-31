-- Run this script in Mariadb to create a user and a database depending on the CMS you are using.
-- This script is for a CMS and is not specific to any particular CMS.
-- Adjust the database name and user credentials as needed.
-- Example for a CMS (e.g., WordPress, Joomla, etc.) 
-- After modifying the script, run it in the terminal using the following command: 
-- mariadb -u root -p < create_user.sql
-- Replace 'password here' with a strong password of your choice.

CREATE DATABASE IF NOT EXISTS cms_db;
CREATE USER 'cms_user'@'localhost' IDENTIFIED BY 'change_this_password';
GRANT ALL PRIVILEGES ON cms_db.* TO 'cms_user'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;