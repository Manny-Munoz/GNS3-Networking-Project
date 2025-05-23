#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Run this script as root"
    exit 1
fi

# Generic function to install CMS
install_cms() {
    local name=$1
    local url=$2

    local CURRENT_DIR=$(pwd)

    local SITE_DIR="$WEBROOT/$name"
    echo "Installing $name in $SITE_DIR ..."

    mkdir -p "$SITE_DIR"
    cd "$SITE_DIR"


    if [ "$1" = "drupal" ]; then
        composer create-project drupal/recommended-project drupal
        cd drupal && php -d memory_limit=256M web/core/scripts/drupal quick-start demo_umami
        cd -
    else
        wget -q "$url" -O "$name.tar.gz"
        tar -xzf "$name.tar.gz" --strip-components=1
        rm "$name.tar.gz"

    chown -R "$USERWEB:$USERWEB" "$SITE_DIR"
    chmod -R 755 "$SITE_DIR"

    echo "$name installed in $SITE_DIR"

    cd "$CURRENT_DIR"

}

# CMS download URLs
URL_WORDPRESS="https://wordpress.org/latest.tar.gz"
URL_JOOMLA="https://downloads.joomla.org/cms/joomla5/latest/Joomla_5-Stable-Full_Package.tar.gz?format=gz"
URL_DOKUWIKI="https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz"

# Load OS information
if [ -f /etc/os-release ]; then
    . /etc/os-release
else
    echo "Could not find /etc/os-release"
    exit 1
fi

# Detect OS family and distribution name
echo "Detecting operating system..."

case "$ID" in
    ubuntu|debian)
        WEBROOT="/var/www/html"
        USERWEB="www-data"

        echo "Debian-based system detected: $PRETTY_NAME"
        echo "==> Running common commands for Debian/Ubuntu"

        # upgrade repositories
        apt update && apt upgrade -y
        # DHCP + DNS 
        apt install -y isc-dhcp-server bind9 bind9-utils
        # Web + DB + PHP
        apt install -y apache2 mariadb-server mariadb-client
        apt install -y php libapache2-mod-php php-mysql php-cli php-curl php-xml php-mbstring php-imap php-apcu php-intl php-gd
        apt install -y phpmyadmin
        # SSL 
        apt install openssl ca-certificates
        # FTP
        apt install vsftpd
        # NTP
        apt install ntp ntpdate
        # SSH 
        apt install openssh-server
        # Samba 
        apt install samba
        # basic auth with .htpasswd
        apt install libapache2-mod-authnz-external pwauth
        a2enmod authnz_external
        # Security tools
        apt install -y iptables fail2ban logrotate chkrootkit postfix
        # Monitoring and administration tools
        apt install -y htop vnstat iproute2 cron mailutils tmux
        # Network tools
        sudo apt install ipcalc
        # file management
        apt install -y tar gzip zip p7zip-full
        # Network service utilities
        apt install -y squid docker.io
        # Development tools
        apt install -y git nodejs npm python3 python3-pip
        if [ "$ID" = "ubuntu" ]; then
            echo "==> Running Ubuntu-specific commands"

            # Control apparmor
            apt install -y apparmor-utils apparmor-profiles

            # Composer 
            apt install composer
            composer --version

            # Drupal
            install_cms "drupal" ""

            # Bookstack
            git clone https://github.com/BookStackApp/BookStack.git --branch release --single-branch bookstack
            cd bookstack
            composer install --no-dev
            cd - 

            # osTicket
            cd $WEBROOT
            curl -s https://api.github.com/repos/osTicket/osTicket/releases/latest|grep browser_download_url| cut -d '"' -f 4 | wget -i -
            unzip osTicket-v1.18.1.zip -d /var/www/html/osticket
            chown -R www-data:www-data /var/www/html/osticket
            cd - 

            # Dokuwiki 
            install_cms "dokuwiki" "$URL_DOKUWIKI"

        elif [ "$ID" = "debian" ]; then
            echo "==> Running Debian-specific commands"

            install_cms "wordpress" "$URL_WORDPRESS"
        fi
        ;;

    rocky|centos)
        echo "RHEL-based system detected: $PRETTY_NAME"
        WEBROOT="/var/www/html"
        USERWEB="apache"

        echo "==> Running common commands for Rocky/CentOS"

        echo "Updating the system..."
        dnf update -y && dnf upgrade -y

        echo "==> Running common commands for Rocky/CentOS"

        echo "Updating the system..."
        dnf update -y && dnf upgrade -y

        echo "Installing DHCP server + bind..."
        dnf install -y dhcp-server bind bind-utils

        echo "Installing Apache, MariaDB and PHP..."
        dnf install -y httpd mariadb-server mariadb
        dnf install -y php php-mysqlnd php-cli php-curl php-xml php-mbstring php-gd php-intl php-imap php-json php-common php-opcache

        echo "Installing OpenSSL and root certificates..."
        dnf install -y openssl ca-certificates

        echo "Installing FTP server (vsftpd)..."
        dnf install -y vsftpd

        echo "Installing NTP..."
        dnf install -y chrony
        systemctl enable chronyd --now

        # SSH
        echo "Installing SSH server..."
        dnf install -y openssh-server
        systemctl enable sshd --now

        # Samba
        echo "Installing Samba..."
        dnf install -y samba

        # Basic authentication (htpasswd)
        echo "Installing apache-utils..."
        dnf install -y httpd-tools

        # Prompt for username and password for HTTP basic auth
        read -p "Enter username for HTTP basic authentication: " HTTPAUTH_USER
        read -s -p "Enter password for $HTTPAUTH_USER: " HTTPAUTH_PASS
        echo
        htpasswd -bc /etc/httpd/.htpasswd "$HTTPAUTH_USER" "$HTTPAUTH_PASS"

        echo "Installing monitoring and security tools..."

        # Protection against brute force on services (like SSH)
        dnf install -y fail2ban

        # System activity report by mail
        dnf install -y logwatch


        # Rootkit scanners (malware detection)
        dnf install -y rkhunter chkrootkit

        echo "Installing system utilities..."

        # Interactive process monitor
        dnf install -y htop

        # Bandwidth monitor per network interface
        dnf install -y iftop

        # Classic network tools (ifconfig, netstat, etc.)
        dnf install -y net-tools

        # Midnight Commander: terminal file manager
        dnf install -y mc

        # Terminal multiplexer (allows splitting sessions, very useful via SSH)
        dnf install -y tmux

        # Fast file searcher with database
        dnf install -y mlocate
        updatedb

        echo "Installing development tools..."

        # Git, Node.js, npm, Python and pip
        dnf install -y git nodejs npm python3 python3-pip

        # Compression and archiving tools
        dnf install -y zip unzip tar

        # Console mail client (mailx)
        dnf install -y mailx

        # Podman: Docker-compatible OCI alternative
        dnf install -y podman

        dnf install ipcalc

        echo "All tools have been installed."

        # Enable services
        echo "Enabling services..."
        systemctl enable httpd --now
        systemctl enable mariadb --now
        systemctl enable smb --now
        systemctl enable vsftpd --now


        if [ "$ID" = "rocky" ]; then
            echo "==> Running Rocky Linux-specific commands"
            install_cms "wordpress" "$URL_WORDPRESS"
        elif [ "$ID" = "centos" ]; then
            echo "==> Running CentOS-specific commands" 
        fi
        ;;

    opensuse*|sles)
        echo "openSUSE system detected: $PRETTY_NAME"
        WEBROOT="/srv/www/htdocs"
        USERWEB="wwwrun"

        zypper refresh
        zypper update -y

        # DHCP
        echo "Installing DHCP server..."
        zypper install -y dhcp-server

        # DNS
        echo "Installing BIND (DNS server)..."
        zypper install -y bind bind-utils

        # Web + PHP + Database
        echo "Installing Apache, MariaDB and PHP..."
        zypper install -y apache2 mariadb
        zypper install -y php7 php7-mysql php7-cli php7-curl php7-xml php7-mbstring php7-gd php7-intl

        # Composer
        if ! command -v composer >/dev/null; then
            echo "Composer is not installed."
            exit 1
        fi

        # Drupal 
        echo "Installing drupal with Composer..."
        composer create-project drupal/mi-drupal

        # SSL
        echo "Installing OpenSSL and certificates..."
        zypper install -y openssl ca-certificates

        # FTP
        echo "Installing FTP server (vsftpd)..."
        zypper install -y vsftpd

        # NTP
        echo "Installing NTP..."
        zypper install -y chrony
        systemctl enable chronyd --now

        # SSH
        echo "Installing SSH server..."
        zypper install -y openssh
        systemctl enable sshd --now

        # Samba
        echo "Installing Samba..."
        zypper install -y samba

        # Basic authentication (htpasswd)
        echo "Installing apache-utils..."
        zypper install -y apache2-utils
        # Prompt for username and password for HTTP basic auth
        read -p "Enter username for HTTP basic authentication: " HTTPAUTH_USER
        read -s -p "Enter password for $HTTPAUTH_USER: " HTTPAUTH_PASS
        echo
        htpasswd -bc /etc/apache2/.htpasswd "$HTTPAUTH_USER" "$HTTPAUTH_PASS"

        # Enable services
        echo "Enabling services..."
        systemctl enable apache2 --now
        systemctl enable mariadb --now
        systemctl enable smb --now
        systemctl enable vsftpd --now

        # Firewall (optional, if firewalld is used)
        echo "Checking firewalld..."
        if systemctl is-active --quiet firewalld; then
          echo "Enabling ports in firewalld..."
          firewall-cmd --permanent --add-service=http
          firewall-cmd --permanent --add-service=https
          firewall-cmd --permanent --add-service=ftp
          firewall-cmd --permanent --add-service=samba
          firewall-cmd --reload
        fi

        zypper install fail2ban         # Protection against brute force attacks
        zypper install logwatch         # System activity reports
        zypper install rkhunter chkrootkit   # Rootkit scanners
        zypper install htop             # Interactive process monitor
        zypper install iftop            # Bandwidth monitor
        zypper install net-tools        # Classic network tools
        zypper install mc               # Midnight Commander file manager
        zypper install tmux             # Terminal multiplexer
        zypper install mlocate          # Fast file searcher
        updatedb                        # Update file search database
        zypper install git nodejs npm python3 python3-pip   # Development tools
        zypper install zip unzip tar    # Compression and archiving tools
        zypper install mailx            # Console mail client
        zypper install podman

        # Network service utilities
        zypper addrepo https://download.opensuse.org/repositories/network:utilities/15.6/network:utilities.repo
        zypper refresh
        zypper install ipcalc

        echo "Installing Composer..."
        zypper install -y curl unzip php7-cli
        zypper install php-composer

        install_cms "joomla" "$URL_JOOMLA"

        echo "Configuration and installation complete for openSUSE."
        ;;
    *)
        echo "Unsupported or unknown distribution: $PRETTY_NAME"
        ;;
esac


