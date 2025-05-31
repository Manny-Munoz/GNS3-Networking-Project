#!/bin/bash

echo "Which server are you using? (gt, cr, us, mx)"
read -r server

case "$server" in
  gt|GT)
    cms="joomla"
    sql_file="joomla_gt.sql"
    cms_dir="GT"
    ;;
  us|US)
    cms="wordpress"
    sql_file="wordpress_us.sql"
    cms_dir="US"
    ;;
  cr|CR)
    cms="joomla"
    sql_file="joomla_cr.sql"
    cms_dir="CR"
    ;;
  mx|MX)
    cms="wordpress"
    sql_file="wordpress_mx.sql"
    cms_dir="MX"
    ;;
  *)
    echo "Invalid option."
    exit 1
    ;;
esac

echo "Database user to create:"
read -r db_user

echo "Database name to create:"
read -r db_name

echo "Enter the password for user $db_user:"
read -s db_pass

# Correct path to create_user.sql
create_user_sql_path="../config_files/create_user.sql"

# Create user and database
sed -e "s/cms_user/$db_user/g" -e "s/cms_db/$db_name/g" -e "s/password here/$db_pass/g" "$create_user_sql_path" | mariadb -u root -p

# Correct path to CMS SQL script
sql_path="../cms/$cms_dir/$sql_file"
if [ -f "$sql_path" ]; then
  mariadb -u "$db_user" -p"$db_pass" "$db_name" < "$sql_path"
  echo "$cms installation completed on $db_name."
else
  echo "SQL file not found: $sql_path"
  exit 1
fi