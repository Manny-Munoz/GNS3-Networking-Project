#!/bin/bash

source ./bash_utils.sh
require_root


# === Detect OS ===
if [ -f /etc/os-release ]; then
  . /etc/os-release
  DISTRO=$ID
else
  echo "Could not detect operating system."
  exit 1
fi

# === Ask for mount directory ===
default_dir="/srv/fileshare"
echo "Default mount directory: $default_dir"
read -p "Do you want to use a custom directory? (y/n): " custom_choice
if [[ "$custom_choice" == "y" ]]; then
  read -p "Enter your custom mount directory: " MOUNT_DIR
else
  MOUNT_DIR="$default_dir"
fi

mkdir -p "$MOUNT_DIR"
echo "Using mount directory: $MOUNT_DIR"

# === Main logic per distribution ===
case "$DISTRO" in
  ubuntu|debian)
    echo "Setting up vsftpd (SFTP via OpenSSH) on Debian/Ubuntu..."

    if ! command -v sftp &> /dev/null; then
      echo "SFTP is not available. Please ensure openssh-server is installed."
      exit 1
    fi

    groupadd ftpusers 2>/dev/null
    useradd -d "$MOUNT_DIR" -s /sbin/nologin -G ftpusers quetzalftp
    chown root:root "$MOUNT_DIR"
    mkdir -p "$MOUNT_DIR/upload"
    chown quetzalftp:ftpusers "$MOUNT_DIR/upload"

    echo "SFTP server ready."
    cat <<EOF

  Client usage (Linux):
  sftp quetzalftp@<server_ip>
  cd upload
  put filename

  If using FileZilla:
    - Protocol: SFTP
    - Host: <server_ip>
    - User: quetzalftp
EOF
    ;;
  rocky|centos|rhel|almalinux|fedora)

    echo "Setting up NFS server on $DISTRO..."

    if ! command -v exportfs &> /dev/null; then
      echo "NFS utils not found. Please install nfs-utils."
      exit 1
    fi

    mkdir -p "$MOUNT_DIR"
    chown nobody:nobody"$MOUNT_DIR"

    echo "$MOUNT_DIR *(rw,sync,no_subtree_check,no_root_squash)" >> /etc/exports
    exportfs -ra
    systemctl enable nfs-server
    systemctl restart nfs-server

    echo "NFS server configured."
    cat <<EOF

  Client usage (Linux):
  sudo apt install nfs-common    # On Debian/Ubuntu
  sudo mount -t nfs <server_ip>:${MOUNT_DIR} /mnt

  To make it persistent:
    Add this line to /etc/fstab:
    <server_ip>:${MOUNT_DIR} /mnt nfs defaults 0 0
EOF
    ;;

  opensuse*|suse)
    echo "Setting up NFS server on $DISTRO..."

    if ! command -v exportfs &> /dev/null; then
      echo "NFS utils not found. Please install nfs-utils."
      exit 1
    fi

    mkdir -p "$MOUNT_DIR"
    chown nobody:nogroup "$MOUNT_DIR"

    echo "$MOUNT_DIR *(rw,sync,no_subtree_check,no_root_squash)" >> /etc/exports
    exportfs -ra
    systemctl enable nfs-server
    systemctl restart nfs-server

    echo "NFS server configured."
    cat <<EOF

  Client usage (Linux):
  sudo apt install nfs-common    # On Debian/Ubuntu
  sudo mount -t nfs <server_ip>:${MOUNT_DIR} /mnt

  To make it persistent:
    Add this line to /etc/fstab:
    <server_ip>:${MOUNT_DIR} /mnt nfs defaults 0 0
EOF
    ;;

  *)
    echo "Unsupported distribution: $DISTRO"
    exit 1
    ;;
esac
