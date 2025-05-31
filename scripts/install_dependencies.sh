#!/bin/bash

source ./bash_utils.sh
require_root

# Generic function to install CMS
install_cms() {
    local name=$1
    local url=$2

    local CURRENT_DIR=$(pwd)

    local SITE_DIR="$WEBROOT/$name"
    cecho "Installing $name in $SITE_DIR ..." "$BLUE"

    mkdir -p "$SITE_DIR"
    cd "$SITE_DIR"


    if [ "$1" = "drupal" ]; then
        composer create-project drupal/recommended-project drupal
        cd -
    else
        wget -q "$url" -O "$name.tar.gz"
        tar -xzf "$name.tar.gz" --strip-components=1
        rm "$name.tar.gz"
    fi

    chown -R "$USERWEB:$USERWEB" "$SITE_DIR"
    chmod -R 755 "$SITE_DIR"

    cecho "$name installed in $SITE_DIR" "$BLUE"

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
cecho "Detecting operating system..." "$BLUE"

case "$ID" in
    ubuntu|debian)
        WEBROOT="/var/www/html"
        USERWEB="www-data"

        cecho "Debian-based system detected: $PRETTY_NAME" "$GREEN"
        cecho "==> Running common commands for Debian/Ubuntu" "$BLUE"

        # upgrade repositories
        apt update && apt upgrade -y
        # DHCP + DNS 
        apt install -y isc-dhcp-server bind9 bind9-utils
        # Web + DB + PHP
        apt install -y apache2 mariadb-server mariadb-client
        apt install -y php libapache2-mod-php php-mysql php-cli php-curl php-xml php-mbstring php-imap php-apcu php-intl php-gd
        apt install -y phpmyadmin
        apt install -y php-sqlite3

        /usr/bin/mysql_secure_installation

        # Vim 
        apt install -y vim
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

        /usr/sbin/a2enmod ssl
        /usr/sbin/a2enmod authnz_external
        # Security tools
        apt install -y iptables fail2ban logrotate chkrootkit postfix
        # Monitoring and administration tools
        apt install -y htop vnstat iproute2 cron mailutils tmux
        mv ../config_files/.tmux.conf ~/.tmux.conf
        # Network tools
        apt install ipcalc
        # file management
        apt install -y tar gzip zip p7zip-full
        # Network service utilities
        apt install -y squid docker.io
        # Development tools
        apt install -y git nodejs npm python3 python3-pip
        apt install -y nfs-kernel-server 
        systemctl enable --now nfs-server
        if [ "$ID" = "ubuntu" ]; then
            cecho "==> Running Ubuntu-specific commands" "$GREEN"
            # Control apparmor
            apt install -y apparmor-utils apparmor-profiles

            # Composer 
            apt install composer
            composer --version

            # Drupal
            install_cms "drupal" ""

            # Bookstack
            cd $WEBROOT
            git clone https://github.com/BookStackApp/BookStack.git --branch release --single-branch bookstack
            cd -
            cd $WEBROOT/bookstack
            composer install --no-dev
            cd - 

            # osTicket
            cd $WEBROOT
            curl -s https://api.github.com/repos/osTicket/osTicket/releases/latest|grep browser_download_url| cut -d '"' -f 4 | wget -i -
            unzip osTicket*.zip -d /var/www/html/osticket
            rm osTicket*.zip
            chown -R www-data:www-data /var/www/html/osticket
            cd - 

            # Dokuwiki 
            install_cms "dokuwiki" "$URL_DOKUWIKI"

        elif [ "$ID" = "debian" ]; then
            cecho "==> Running Debian-specific commands" "$GREEN"

            install_cms "wordpress" "$URL_WORDPRESS"
        fi
        ;;

    rocky|centos)
        echo "RHEL-based system detected: $PRETTY_NAME"
        WEBROOT="/var/www/html"
        USERWEB="apache"

        cecho "==> Running common commands for Rocky/CentOS" "$BLUE"

        cecho "Updating the system..." "$BLUE"
        dnf update -y && dnf upgrade -y

        # VIM 
        cecho "Installing Vim..." "$BLUE"
        dnf install -y vim

        # DHCP + DNS
        cecho "Installing DHCP server + bind..." "$BLUE"
        dnf install -y dhcp-server bind bind-utils

        cecho "Installing Apache, MariaDB and PHP..." "$BLUE"
        dnf install -y httpd mariadb-server mariadb
        dnf install -y mod_ssl 
        dnf install -y php php-mysqlnd php-gd php-xml php-mbstring
        systemctl restart httpd   # Rocky/CentOS/RHEL

        /usr/bin/mysql_secure_installation

        cecho "Installing OpenSSL and root certificates..." "$BLUE"
        dnf install -y openssl ca-certificates

        cecho "Installing FTP server (vsftpd)..." "$BLUE"
        dnf install -y vsftpd

        cecho "Installing NTP..." "$BLUE"
        dnf install -y chrony
        systemctl enable chronyd --now

        # SSH
        cecho "Installing SSH server..." "$BLUE"
        dnf install -y openssh-server
        systemctl enable sshd --now

        # Install NFS server 
        cecho "Installing NFS server..." "$BLUE"
        dnf install -y nfs-utils 
        systemctl enable --now nfs-server

        # Samba
        cecho "Installing Samba..." "$BLUE"
        dnf install -y samba

        # Basic authentication (htpasswd)
        cecho "Installing apache-utils..." "$BLUE"
        dnf install -y httpd-tools

        cecho "Installing monitoring and security tools..." "$BLUE"

        # Protection against brute force on services (like SSH)
        dnf install -y fail2ban

        # System activity report by mail
        dnf install -y logwatch


        # Rootkit scanners (malware detection)
        dnf install -y rkhunter 

        cecho "Installing system utilities..." "$BLUE"

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

        mv ../config_files/.tmux.conf ~/.tmux.conf

        # Fast file searcher with database
        dnf install -y mlocate
        updatedb

        cecho "Installing development tools..." "$BLUE"

        # Git, Node.js, npm, Python and pip
        dnf install -y git nodejs npm python3 python3-pip

        # Compression and archiving tools
        dnf install -y zip unzip tar

        # Console mail client (mailx)
        dnf install -y mailx

        # Podman: Docker-compatible OCI alternative
        dnf install -y podman

        dnf install -y ipcalc

        cecho "All tools have been installed." "$GREEN"

        # Enable services
        cecho "Enabling services..." "$BLUE"
        systemctl enable httpd --now
        systemctl restart httpd
        systemctl enable mariadb --now
        systemctl enable smb --now
        systemctl enable vsftpd --now


        if [ "$ID" = "rocky" ]; then
            cecho "==> Running Rocky Linux-specific commands" "$GREEN"
            install_cms "wordpress" "$URL_WORDPRESS"
        elif [ "$ID" = "centos" ]; then
            cecho "==> Running CentOS-specific commands" "$GREEN"
        fi
        ;;

    opensuse*|sles)
        cecho "openSUSE system detected: $PRETTY_NAME" "$GREEN"
        WEBROOT="/srv/www/htdocs"
        USERWEB="wwwrun"

        zypper refresh
        zypper update -y

        # VIM 
        cecho "Installing Vim..." "$BLUE"
        zypper install -y vim

        # DHCP
        cecho "Installing DHCP server..." "$BLUE"
        zypper install -y dhcp-server

        # DNS
        cecho "Installing BIND (DNS server)..." "$BLUE"
        zypper install -y bind bind-utils

        # Web + PHP + Database
        cecho "Installing Apache, MariaDB and PHP..." "$BLUE"
        zypper install -y apache2 mariadb mariadb-client
        /usr/sbin/a2enmod ssl
        systemctl restart apache2
        zypper install -y apache2 php php-mysql php-gd php-xml php-mbstring php-zlib 
        systemctl enable apache2 --now
        systemctl enable mariadb --now
        systemctl start mariadb

        zypper install -y nfs-kernel-server 
        systemctl enable --now nfs-server


        /usr/bin/mysql_secure_installation

        # SSL
        cecho "Installing OpenSSL and certificates..." "$BLUE"
        zypper install -y openssl ca-certificates

        # FTP
        cecho "Installing FTP server (vsftpd)..." "$BLUE"
        zypper install -y vsftpd

        # NTP
        cecho "Installing NTP..." "$BLUE"
        zypper install -y chrony
        systemctl enable chronyd --now

        # SSH
        cecho "Installing SSH server..." "$BLUE"
        zypper install -y openssh
        systemctl enable sshd --now

        # Samba
        cecho "Installing Samba..." "$BLUE"
        zypper install -y samba

        # Basic authentication (htpasswd)
        cecho "Installing apache-utils..." "$BLUE"
        zypper install -y apache2-utils

        # Enable services
        cecho "Enabling services..." "$GREEN"
        systemctl enable smb --now
        systemctl enable vsftpd --now

        # Firewall (optional, if firewalld is used)
        cecho "Checking firewalld..." "$BLUE"
        if systemctl is-active --quiet firewalld; then
          echo "Enabling ports in firewalld..."
          firewall-cmd --permanent --add-service=http
          firewall-cmd --permanent --add-service=https
          firewall-cmd --permanent --add-service=ftp
          firewall-cmd --permanent --add-service=samba
          firewall-cmd --reload
        fi

        zypper install -y fail2ban         # Protection against brute force attacks
        zypper install -y logwatch         # System activity reports
        zypper install -y rkhunter         # Rootkit scanners
        zypper install -y htop             # Interactive process monitor
        zypper install -y iftop            # Bandwidth monitor
        zypper install -y net-tools        # Classic network tools
        zypper install -y mc               # Midnight Commander file manager
        zypper install -y tmux             # Terminal multiplexer
        mv ../config_files/.tmux.conf ~/.tmux.conf
        zypper install -y mlocate          # Fast file searcher
        updatedb                        # Update file search database
        zypper install -y git nodejs npm python3 python3-pip   # Development tools
        zypper install -y zip unzip tar    # Compression and archiving tools
        zypper install -y mailx            # Console mail client
        zypper install -y podman

        # Network service utilities
        zypper addrepo https://download.opensuse.org/repositories/network:utilities/15.6/network:utilities.repo
        zypper refresh
        zypper install -y ipcalc

        install_cms "joomla" "$URL_JOOMLA"

        cecho "Configuration and installation complete for openSUSE." "$GREEN"
        ;;
    *)
        cecho "Unsupported or unknown distribution: $PRETTY_NAME" "$RED"
        ;;
esac


