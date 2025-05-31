#!/bin/bash

source ./bash_utils.sh
require_root

# Country codes map
declare -A COUNTRY_CODES=( [gt]=GT [cr]=CR [mx]=MX [us]=US )

# Detect OS
detect_os() {
  if [ -f /etc/os-release ]; then
    source /etc/os-release
    case "$ID" in
      debian|ubuntu) OS_FAMILY="debian" ;;
      opensuse*|suse) OS_FAMILY="opensuse" ;;
      centos|rocky|rhel) OS_FAMILY="rocky" ;;
      *) cecho "Unsupported OS." "$RED"; exit 1 ;;
    esac
  fi
}

# Get Apache dirs and commands based on OS
set_paths_and_cmds() {
  case "$OS_FAMILY" in
    debian)
      APACHE_CONF_DIR="/etc/apache2/sites-available"
      APACHE_WEB_ROOT="/var/www"
      ENABLE_CMD="/usr/sbin/a2ensite"
      RELOAD_CMD="systemctl reload apache2"
      APACHE_USER="www-data"
      ;;
    opensuse)
      APACHE_CONF_DIR="/etc/ssl/$SITE_NAME"
      APACHE_WEB_ROOT="/srv/www"
      ENABLE_CMD="true"  # auto enabled
      RELOAD_CMD="systemctl restart httpd"
      APACHE_USER="wwwrun"
      ;;
    rocky)
      APACHE_CONF_DIR="/etc/httpd/conf.d"
      APACHE_WEB_ROOT="/srv/www"
      ENABLE_CMD="true"  # auto enabled
      RELOAD_CMD="systemctl restart apache2"
      APACHE_USER="apache"
      ;;
  esac
}

set_htpasswd_file() {
    case "$OS_FAMILY" in
        debian|opensuse)
            HTPASSWD_FILE="/etc/apache2/.htpasswd"
            ;;
        rocky)
            HTPASSWD_FILE="/etc/httpd/.htpasswd"
            ;;
    esac    

}

# Prompt for domain and config
read -p "What is the base domain (e.g. quetzal): " SITE_NAME
SITE_NAME=${SITE_NAME:-quetzal}
read -p "Supported countries are: gt, cr, us, mx. Enter one: " COUNTRY_CODE
COUNTRY_CODE=${COUNTRY_CODE,,}  # to lowercase

DOMAIN="$SITE_NAME.$COUNTRY_CODE.com"
CN="$DOMAIN"
COUNTRY="${COUNTRY_CODES[$COUNTRY_CODE]}"

BASE_SSL_DIR="/etc/ssl/$SITE_NAME"
mkdir -p "$BASE_SSL_DIR"

# Detect OS
detect_os
set_paths_and_cmds
set_htpasswd_file

# Prompt for subdomains
declare -a SUBDOMAINS
read -p "Use default subdomains (www, admin, notes, root domain)? [y/n]: " USE_DEFAULT
if [[ $USE_DEFAULT == "y" ]]; then
  SUBDOMAINS=("www" "admin" "notes" "")
  read -p "Do you want to add additional subdomains? [y/n]: " ADD_EXTRA
  if [[ $ADD_EXTRA == "y" ]]; then
    read -p "Enter extra subdomains separated by spaces: " -a EXTRA_SUBDOMAINS
    SUBDOMAINS+=("${EXTRA_SUBDOMAINS[@]}")
  fi
else
  read -p "Enter all desired subdomains (e.g. www admin) or leave empty for root only: " -a SUBDOMAINS
  SUBDOMAINS+=("")
fi

# Ask if htpasswd user already created
read -p "Do you want to create the htpasswd now? [y/n]: " CREATE_AUTH
if [[ $CREATE_AUTH == "y" ]]; then 
read -p "Enter username: " HTTPAUTH_USER 
read -s -p "Enter password: " HTTPAUTH_PASS 
htpasswd -bc "$HTPASSWD_FILE" "$HTTPAUTH_USER" "$HTTPAUTH_PASS"
fi

# SSL
KEY_PATH="$BASE_SSL_DIR/$DOMAIN.key"
CRT_PATH="$BASE_SSL_DIR/$DOMAIN.crt"

cecho "Generating SSL certificate for $DOMAIN..." "$GREEN"
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout "$KEY_PATH" -out "$CRT_PATH" \
  -subj "/C=$COUNTRY/ST=State/L=City/O=Quetzal/OU=IT/CN=$DOMAIN"

# Create virtual host configs
for SUB in "${SUBDOMAINS[@]}"; do
  FQDN="${SUB:+$SUB.}$DOMAIN"
  WEB_DIR="$APACHE_WEB_ROOT/$FQDN"
  mkdir -p "$WEB_DIR"
  echo "<html><body><h1>Welcome to $FQDN</h1></body></html>" > "$WEB_DIR/index.html"
  chown -R $APACHE_USER:$APACHE_USER "$WEB_DIR"

  VHOST_FILE="$APACHE_CONF_DIR/$FQDN.conf"
  cecho "Creating VirtualHost for $FQDN..." "$GREEN"

cat > "$VHOST_FILE" <<EOF
<VirtualHost *:443>
    ServerName $FQDN
    DocumentRoot $WEB_DIR

    SSLEngine on
    SSLCertificateFile $CRT_PATH
    SSLCertificateKeyFile $KEY_PATH

    <Directory "$WEB_DIR">
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
    </Directory>
</VirtualHost>
EOF

done

# Enable and restart Apache
if [[ $OS_FAMILY == "debian" ]]; then
  for SUB in "${SUBDOMAINS[@]}"; do
    FQDN="${SUB:+$SUB.}$DOMAIN"
    $ENABLE_CMD "$FQDN.conf"
  done
fi

cecho "Reloading Apache..." "$GREEN"
eval "$RELOAD_CMD"

cecho 
cecho "==============================================" "$YELLOW"
cecho "To protect a subdomain with Basic Auth, add the following lines" "$YELLOW"
cecho "inside the <Directory> block of the desired VirtualHost config:" "$YELLOW"
cecho
cecho "    AuthType Basic" "$YELLOW"
cecho "    AuthName \"Restricted Access\"" "$YELLOW"
cecho "    AuthUserFile $HTPASSWD_FILE" "$YELLOW"
cecho "    Require valid-user" "$YELLOW"
cecho
cecho "Example:" "$YELLOW"
cecho "    <Directory \"/path/to/your/webroot\">" "$YELLOW"
cecho "        Options Indexes FollowSymLinks" "$YELLOW"
cecho "        AllowOverride None" "$YELLOW"
cecho "        Require all granted" "$YELLOW"
cecho "        AuthType Basic" "$YELLOW"
cecho "        AuthName \"Restricted Access\"" "$YELLOW"
cecho "        AuthUserFile $HTPASSWD_FILE" "$YELLOW"
cecho "        Require valid-user" "$YELLOW"
cecho "    </Directory>" "$YELLOW"
cecho
cecho "==============================================" "$YELLOW"
cecho
cecho "All sites configured successfully!" "$GREEN"