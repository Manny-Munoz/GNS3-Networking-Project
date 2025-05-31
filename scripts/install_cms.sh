#!/bin/bash

# Detect OS
detect_os() {
  if [ -f /etc/os-release ]; then
    source /etc/os-release
    case "$ID" in
      debian|ubuntu)
        OS_FAMILY="debian"
        APACHE_CONF_DIR="/etc/apache2/sites-available"
        APACHE_WEB_ROOT="/var/www"
        RELOAD_CMD="systemctl reload apache2"
        APACHE_USER="www-data"
        ;;
      opensuse*|suse)
        OS_FAMILY="opensuse"
        APACHE_CONF_DIR="/etc/httpd/conf.d"
        APACHE_WEB_ROOT="/srv/www"
        RELOAD_CMD="systemctl restart apache2"
        APACHE_USER="wwwrun"
        ;;
      centos|rocky|rhel)
        OS_FAMILY="rocky"
        APACHE_CONF_DIR="/etc/httpd/conf.d"
        APACHE_WEB_ROOT="/srv/www"
        RELOAD_CMD="systemctl restart httpd"
        APACHE_USER="apache"
        ;;
      *)
        echo "Unsupported OS."
        exit 1
        ;;
    esac
  else
    echo "Unable to detect OS."
    exit 1
  fi
}

# Prompt for country
echo "Which server are you using? (gt, cr, us, mx)"
read -r server
server=${server,,}  # Convert to lowercase

# Map server to CMS and SQL file
case "$server" in
  gt)
    cms="joomla"
    sql_file="joomla_gt.sql"
    cms_dir="GT"
    domain="www.quetzal.gt.com"
    ;;
  cr)
    cms="drupal"
    sql_file="drupal_gt.sql"
    cms_dir="CRC"
    domain="www.quetzal.cr.com"
    ;;
  mx)
    cms="wordpress"
    sql_file="wordpress_gt.sql"
    cms_dir="MX"
    domain="www.quetzal.mx.com"
    ;;
  us)
    cms="wordpress"
    sql_file="wordpress_sql.sql"
    cms_dir="US"
    domain="www.quetzal.us.com"
    ;;
  *)
    echo "Invalid option."
    exit 1
    ;;
esac

# Prompt for database details
echo "Database user to create:"
read -r db_user

echo "Database name to create:"
read -r db_name

echo "Enter the password for user $db_user:"
read -s db_pass

# Detect OS
detect_os

# Paths
create_user_sql_path="../config_files/create_user.sql"
sql_path="../cms/$cms_dir/$sql_file"
web_dir="$APACHE_WEB_ROOT/$domain"
vhost_file="$APACHE_CONF_DIR/$domain.conf"

# Check if the user wants to modify create_user.sql
if [ -f "$create_user_sql_path" ]; then
  echo "The file $create_user_sql_path contains the following default SQL commands:"
  cat "$create_user_sql_path"
  echo
  echo "It is recommended to change the default password ('change_this_password')."
  read -p "Do you want to modify this file before proceeding? [y/n]: " modify_sql
  if [[ $modify_sql == "y" ]]; then
    nano "$create_user_sql_path"
  fi
else
  echo "User creation SQL file not found: $create_user_sql_path"
  exit 1
fi

# Create user and database
sed -e "s/cms_user/$db_user/g" -e "s/cms_db/$db_name/g" -e "s/change_this_password/$db_pass/g" "$create_user_sql_path" | mariadb -u root -p

# Import CMS SQL file
if [ -f "$sql_path" ]; then
  mariadb -u "$db_user" -p"$db_pass" "$db_name" < "$sql_path"
else
  echo "CMS SQL file not found: $sql_path"
  exit 1
fi

# Set up web directory
mkdir -p "$web_dir"
echo "<html><body><h1>Welcome to $domain</h1></body></html>" > "$web_dir/index.html"
chown -R "$APACHE_USER:$APACHE_USER" "$web_dir"

# Create VirtualHost configuration
cat > "$vhost_file" <<EOF
<VirtualHost *:80>
    ServerName $domain
    DocumentRoot $web_dir

    <Directory "$web_dir">
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
    </Directory>
</VirtualHost>
EOF

# Reload Apache
eval "$RELOAD_CMD"

echo "$cms installation completed on $domain."