# GNS3 Networking Practice Project

This repository contains a complete practice for designing and configuring a distributed network using GNS3. It includes router configurations, installation scripts for servers, and a visual diagram of the network topology.

## 📚 Index

- [🔧 GNS3 Project Screenshot](#-gns3-project-screenshot)
- [Region Codes](#region-codes)
- [📊 General Description](#-general-description)
- [🔹 Topology](#-topology)
- [🌐 Addressing and NAT (Central Router)](#-addressing-and-nat-central-router)
- [📝 Routes and RIP](#-routes-and-rip)
- [💻 Operating Systems Used on Servers](#-operating-systems-used-on-servers)
- [📃 Included Files](#-included-files)
- [🔗 External Connection](#-external-connection)
- [📚 Requirements](#-requirements)
- [Interface and Connection Documentation](#interface-and-connection-documentation)
- [🚀 Usage](#-usage)
- [🖥️️️️ ️Interface Connections Documentation](#-interface-connections-documentation)
- [⚖️ License](#-license)

---

### 🔧 GNS3 Project Screenshot

Below is the actual view of the topology inside GNS3:

![GNS3 Topology](images/gns3_topology_screenshot.png)

---

## Region Codes

| Code    | Location                |
|---------|-------------------------|
| MIA     | Miami, USA              |
| MEX     | Mexico City             |
| GUA     | Guatemala City          |
| CRC     | San José, Costa Rica    |
| COMMON | Central Backbone Router (Core Network) |

---

## 📊 General Description

The simulated network consists of five interconnected regions:

* Common Network (main interconnection node and Internet gateway)
* Miami Network
* Mexico Network
* Guatemala Network
* Costa Rica Network

Cisco routers and virtual machines with different operating systems were used to simulate servers and workstations.

## 🔹 Topology

* **Main router:** Cisco C7200 (Central Network)
* **Edge routers:** Cisco C3725 for each region (Miami, Mexico, Guatemala, Costa Rica)
* **Protocols:** RIP v2 with static routes for Internet access
* **Internet connection:** `f1/0` interface of the Central Network router, with IP assigned by DHCP and NAT configured

## 🌐 Addressing and NAT (Central Router)

```bash
interface f0/0
 ip address 172.16.100.254 255.255.255.0
 ip nat inside
 no shutdown

interface f1/0
 ip address dhcp
 ip nat outside
 no shutdown

ip nat inside source list 1 interface f1/0 overload

access-list 1 permit 172.16.0.0 0.0.255.255
access-list 1 permit 10.10.16.0 0.0.0.255
access-list 1 permit 192.168.20.0 0.0.0.63
```

## 📝 Routes and RIP

```bash
router rip
 version 2
 network 172.16.0.0
 network 10.10.16.0
 network 192.168.20.0
 no auto-summary
```

Each regional router is connected to the central router through a `f2/0` interface configured in the `172.16.100.0/24` subnet and a point-to-point interface for internal connections.

## 💻 Operating Systems Used on Servers

* Ubuntu Server
* Debian
* openSUSE
* Rocky Linux

These servers were configured using the [installation script](scripts/install_dependencies.sh), which automates the installation of packages and services such as Apache, MariaDB, PHP, DNS, DHCP, among others.

# 📃 Included Files

| File                                              | Description                                                         |
| ------------------------------------------------- | ------------------------------------------------------------------- |
| [configure_static_network.sh](scripts/configure_static_network.sh) | Complete configurations of the Cisco routers used                   |
| [install_dependencies.sh](scripts/install_dependencies.sh)         | Automated script to configure services on Linux servers             |
| [install_cms.sh](scripts/install_cms.sh)                         | Script to automate CMS database/user creation and SQL import        |
| [generate_ssl_certs.sh](scripts/generate_ssl_certs.sh)           | Script to generate SSL certificates and Apache virtual hosts        |
| [setup_file_server.sh](scripts/setup_file_server.sh)             | Script to configure SFTP/NFS file server                            |
| [create_user.sql](config_files/create_user.sql)                  | SQL template for creating CMS database and user                     |
| [named.conf.zones](config_files/named.conf.zones)                | DNS zone configuration file                                         |
| [named.conf.options](config_files/named.conf.options)            | DNS options configuration file                                      |
| [db.example.com](config_files/db.example.com)                    | Example DNS zone file                                               |
| [vm_config.md](vm_config.md)                                     | Documentation of the VMs used (ISOs, versions, configuration)       |

## 🔗 External Connection

The Common Network router can connect to a NAT cloud or directly to a `Cloud` type interface in GNS3, obtaining its IP via DHCP and acting as the Internet gateway for the entire network.

## 📚 Requirements

* GNS3 2.2 or higher
* Cisco IOS images (C7200 and C3725)
* Operating system images in `.qcow2` and `.iso` format
* QEMU and GNS3 VM configuration (recommended)

# Interface and Connection Documentation

Below is a summary of which interface connects each router and switch, to simplify configuration and cabling in GNS3:

| Device         | Interface      | Connected To        |  Description                |
| -------------- | ------------- | -------------------- | -------------------------- |
| R-Common       | f2/0          | Cloud/NAT            | Internet Gateway           |
| R-Common       | f0/0          | SW-Common            | LAN Central                |
| R-MIA          | f0/0          | R-MEX (f0/0)         | Link to Mexico             |
| R-MIA          | f0/1          | SW-MIA               | Miami LAN                  |
| R-MIA          | f2/0          | SW-Common            | Link to Common             |
| R-MEX          | f0/0          | R-MIA (f0/0)         | Link to Miami              |
| R-MEX          | f0/1          | SW-MEX               | Mexico LAN                 |
| R-MEX          | f1/0          | R-GUA (f0/0)         | Link to Guatemala          |
| R-MEX          | f2/0          | SW-Common            | Link to Common             |
| R-GUA          | f0/0          | R-MEX (f1/0)         | Link to Mexico             |
| R-GUA          | f0/1          | SW-GUA               | Guatemala LAN              |
| R-GUA          | f1/0          | R-CRC (f0/0)         | Link to Costa Rica         |
| R-GUA          | f2/0          | SW-Common            | Link to Common             |
| R-CRC          | f0/0          | R-GUA (f1/0)         | Link to Guatemala          |
| R-CRC          | f0/1          | SW-CRC               | Costa Rica LAN             |
| R-CRC          | f2/0          | SW-Common            | Link to Common             |

- **SW-XXX**: Refers to the switch of each region (Central, MIA, MEX, GUA, CRC).
- All servers and workstations connect to their respective regional switch.
- The "Cloud" node in GNS3 represents the Internet connection.

## 🚀 Usage

### ⚠️ Network Troubleshooting for Rocky Linux

If Rocky Linux does not have network connectivity at first boot, you may need to manually bring up the network interface. Run the following commands:

```bash
sudo nmcli device status
sudo nmcli device connect eth0
sudo nmcli connection up eth0
```
*(Replace `eth0` with your actual interface name, such as `ens3` or `enp1s0`.)*

---

### 1. Execute the install_dependencies.sh script

First, give execution permissions and run the script according to your OS.

**For Ubuntu/Rocky/openSUSE:**
```bash
sudo chmod +x ./scripts/install_dependencies.sh
sudo ./scripts/install_dependencies.sh
```

**For Debian:**
```bash
su -
chmod +x ./scripts/install_dependencies.sh
./scripts/install_dependencies.sh
```

---

#### ⚠️ Interactive Prompts During Installation

While running the script, you will need to answer some questions to set up MySQL/MariaDB:

**MySQL Secure Installation (`mysql_secure_installation`):**

- **Enter current password for root (enter for none):**  
  Just press Enter (no password is set by default).
- **Switch to unix_socket authentication?**  
  Answer **no** (using unix_socket can be a security concern later).
- **Change the root password?**  
  Answer **yes** and set a strong root password.
- **Remove anonymous users?**  
  Answer **yes**.
- **Disallow root login remotely?**  
  Answer **yes**.
- **Remove test database and access to it?**  
  Answer **yes**.
- **Reload privilege tables now?**  
  Answer **yes**.

---

### 2. Run configure_static_network.sh

**For Ubuntu/Rocky/openSUSE:**
```bash
sudo chmod +x ./scripts/configure_static_network.sh
sudo ./scripts/configure_static_network.sh
```

**For Debian:**
```bash
su -
chmod +x ./scripts/configure_static_network.sh
./scripts/configure_static_network.sh
```

---

### 3. Create the CMS database and user

Depending on the CMS you are using, you will need to edit certain parameters in the `create_user.sql` script (such as the database name, username, and password).  
After making the necessary changes, you can execute the script with:

```bash
mariadb -u root -p < create_user.sql
```
For more details and examples, refer directly to the `create_user.sql` file, which contains additional useful information and guidance.

---

### 4. Configure DNS zones with named.conf.zones

Use the `named.conf.zones` file to configure your DNS zones.  
This file defines the four DNS zones used in this project: `gt.com`, `cr.com`, `mx.com`, and `us.com`.

**IMPORTANT:**  
If you need to configure one of these zones (for example, `gt.com`) as a master zone on a specific server, you **must delete or comment out the corresponding `gt.com` forward zone** from this file.  
After removing the forward zone for that domain, follow the instructions below to include this file in your server configuration. Once done, continue with the manual in `readme.md` or refer to the `db.example.com` file for further configuration steps.

**How to use this file:**

- **On Debian/Ubuntu:**
    1. Move this file to `/etc/bind/`:
       ```bash
       mv ./named.conf.zones /etc/bind/
       ```
    2. Add the following line to `/etc/bind/named.conf`:
       ```
       include "/etc/bind/named.conf.zones";
       ```

- **On openSUSE or Rocky Linux:**
    1. Move this file to `/etc/named/`:
       ```bash
       mv ./named.conf.zones /etc/named/
       ```
    2. Add the following line to `/etc/named.conf`:
       ```
       include "/etc/named/named.conf.zones";
       ```
---

#### Example: Creating a master zone file

You can use the provided `db.example.com` as a template for your zone files.  
Modify the "gt" part to match your country code (e.g., "cr", "us", "mx") and update the IP addresses as needed.  
After making your changes, rename the file to match the zone (e.g., `db.gt.com`).

- **On Debian/Ubuntu:**
    - Move the file:
      ```bash
      mv ./db.gt.com /etc/bind/
      ```
    - Add the zone to `/etc/bind/named.conf.local`:
      ```
      zone "gt.com" {
        type master;
        file "/etc/bind/db.gt.com";
      };
      ```

- **On Rocky Linux:**
    - Move the file:
      ```bash
      mv ./db.gt.com /var/named/
      ```
    - Add the zone to `/etc/named.conf`:
      ```
      zone "gt.com" {
        type master;
        file "/var/named/db.gt.com";
      };
      ```

- **On openSUSE:**
    - Move the file:
      ```bash
      mv ./db.gt.com /var/lib/named/
      ```
    - Add the zone to `/etc/named.conf`:
      ```
      zone "gt.com" {
        type master;
        file "/var/lib/named/db.gt.com";
      };
      ```

#### 🔁 Adding a Secondary DNS Server to Allow External Resolution

To allow DNS queries to be resolved outside the network (for example, resolving `google.com`), you must add a secondary DNS forwarder (such as Google’s `8.8.8.8`) inside your `options` block. You can use the provided `named.conf.options` as a template for DNS configuration. After editing (or if you wish to use the default), move the file to the correct location:

- **On Debian/Ubuntu:**
    - Uncomment the appropriate directory line in your options file:
        ```conf
        directory "/var/cache/bind";
        ```
    - Move your custom `named.conf.options` to replace the existing one:
        ```bash
        mv ./config_files/named.conf.options /etc/bind/named.conf.options
        ```
    - Restart BIND to apply the changes:
        ```bash
        sudo systemctl restart bind9
        ```

- **On Rocky Linux / CentOS / RHEL:**
    - Open `/etc/named.conf` and remove any existing `options { ... };` block.
    - Move your configuration file:
        ```bash
        mv ./named.conf.options /var/named/named.conf.options
        ```
    - Add the following line to the end of `/etc/named.conf`:
        ```
        include "/var/named/named.conf.options";
        ```
    - Restart the DNS service:
        ```bash
        sudo systemctl restart named
        ```

- **On openSUSE:**
    - Edit `/etc/named.conf` and remove the existing `options { ... };` block.
    - Move your configuration file:
        ```bash
        mv ./named.conf.options /var/lib/named/named.conf.options
        ```
    - Add this line to `/etc/named.conf`:
        ```
        include "/var/lib/named/named.conf.options";
        ```
    - Restart the DNS service:
        ```bash
        sudo systemctl restart named
        ```

---

### 5. Generate SSL Certificates and Apache Virtual Hosts

The script [`generate_ssl_certs.sh`](./scripts/generate_ssl_certs.sh) automates the creation of self-signed SSL certificates and Apache virtual host configurations for your subdomains. It works on Ubuntu, Debian, openSUSE, and Rocky Linux.

#### Usage

**1. Make the script executable and run it as root:**

For Ubuntu/Rocky/openSUSE:
```bash
sudo chmod +x ./scripts/generate_ssl_certs.sh
sudo ./scripts/generate_ssl_certs.sh
```

For Debian:
```bash
su -
chmod +x ./scripts/generate_ssl_certs.sh
./scripts/generate_ssl_certs.sh
```

**2. Follow the interactive prompts:**
- Enter the base domain (e.g., `quetzal`).
- Select your country code (`gt`, `cr`, `us`, `mx`).
- Choose default or custom subdomains.
- Optionally, create an initial HTTP Basic Auth user (for `.htpasswd`).

**3. The script will:**
- Generate a self-signed SSL certificate for your domain.
- Create a virtual host configuration for each subdomain.
- Place the SSL certificates in `/etc/ssl/<your-domain>/`.
- Place the Apache configs in the correct directory for your OS.
- Reload Apache to apply the changes.

**4. Protect subdomains with Basic Auth (optional):**

To enable HTTP Basic Authentication on any subdomain, add the following lines inside the `<Directory>` block of the corresponding virtual host config:

```apache
    AuthType Basic
    AuthName "Restricted Access"
    AuthUserFile /etc/apache2/.htpasswd   # or /etc/httpd/.htpasswd on Rocky
    Require valid-user
```

See the script output for the exact path to your `.htpasswd` file.

For more details, see the comments in the [`generate_ssl_certs.sh`](./scripts/generate_ssl_certs.sh) script.

--- 


### 6. Configure NTP Server and Clients

#### NTP configuration for Ubuntu Server/Debian (using `ntpd`)

Use the `server.ntp.conf` file located at `./config_files/ntp/server.ntp.conf` to configure your NTP server.

This file is designed for Debian/Ubuntu systems and configures the NTP daemon to synchronize time with external servers.  
You can modify the `pool` lines to use your preferred NTP servers if needed.

**Example from `./config_files/ntp/server.ntp.conf`:**
```conf
pool 0.debian.pool.ntp.org iburst
pool 1.debian.pool.ntp.org iburst
pool 2.debian.pool.ntp.org iburst
pool 3.debian.pool.ntp.org iburst
```

After editing (or if you wish to use the default), move the file to the correct location:
```bash
cd ./config_files/ntp
sudo mv server.ntp.conf /etc/ntpsec/ntp.conf
```

- To apply changes, restart the NTP service:
  ```bash
  sudo systemctl restart ntp
  ```
- To check synchronization status:
  ```bash
  sudo ntpq -p
  ```

---

#### NTP configuration for openSUSE/Rocky Linux (using `chrony`)

Use the `server.client.ntp.conf` file at `./config_files/ntp/server.client.ntp.conf` to configure Chrony.

This file is for openSUSE and Rocky Linux systems using Chrony.  
It should reference the IP addresses or hostnames of your Debian/Ubuntu NTP servers.

After editing, move the file to the correct location:
```bash
sudo mv ./config_files/ntp/server.client.ntp.conf /etc/chrony.conf
```

- To apply changes, restart the Chrony service:
  ```bash
  sudo systemctl restart chronyd
  ```
- To check synchronization status:
  ```bash
  chronyc tracking
  chronyc sources -v
  ```

---

#### NTP configuration for LocOS (or any Linux client using `ntpd`)

For LocOS or other Linux clients using `ntpd`, use the `client.ntp.conf` file at `./config_files/ntp/client.ntp.conf`.

Edit the file to use the appropriate NTP server for your region (e.g., `quetzal.ntp.gt.com`, `quetzal.ntp.cr.com`, `quetzal.ntp.mx.com`, etc.).  
After editing, move the file to the correct location:

```bash
cd ./config_files/ntp
sudo mv client.ntp.conf /etc/ntp.conf
```

- Restart the NTP service after changes:
  ```bash
  sudo systemctl restart ntp
  ```
- Check status:
  ```bash
  sudo ntpq -p
  ```

For more information, see the documentation and examples in the `./config_files/ntp/` directory.

---

### 7. Configure and Use the File Server (SFTP/NFS)

The script [`setup_file_server.sh`](./scripts/setup_file_server.sh) allows you to quickly set up a shared file server using SFTP (on Debian/Ubuntu) or NFS (on openSUSE/Rocky Linux).

#### Usage

1. **Make the script executable and run it as root:**
   ```bash
   sudo chmod +x ./scripts/setup_file_server.sh
   sudo ./scripts/setup_file_server.sh
   ```

2. **Follow the interactive prompts:**
   - Choose the mount directory (default is `/srv/fileshare` or specify a custom one).
   - The script will detect your distribution and automatically configure SFTP or NFS as appropriate.

#### Access from Clients

- **On Debian/Ubuntu (SFTP):**
  - User: `quetzalftp`
  - Group: `ftpusers`
  - Upload folder: `upload`
  - Connect from Linux:
    ```bash
    sftp quetzalftp@<server_ip>
    cd upload
    put filename.txt
    ```
  - In FileZilla:
    - Protocol: SFTP
    - Host: `<server_ip>`
    - User: `quetzalftp`

- **On openSUSE/Rocky Linux (NFS):**
  - Mount the shared directory from the client:
    ```bash
    sudo apt install nfs-common    # On Debian/Ubuntu
    sudo mount -t nfs <server_ip>:/srv/fileshare /mnt
    ```
  - To mount automatically at boot, add to `/etc/fstab`:
    ```
    <server_ip>:/srv/fileshare  /mnt  nfs  defaults  0  0
    ```

See the script itself for additional details or customization options.

---

### 8. Setup SSH Server

Secure and reliable SSH access is essential for managing your servers remotely. This section explains how to set up SSH key authentication and use a configuration file for easier connections.

#### 1. Basic SSH Access

To connect to a server for the first time, use:

```bash
ssh <username>@<server_ip_or_domain>
```

- You will be prompted to accept the server's fingerprint—type `yes`.
- Enter your password when prompted.

#### 2. Generate SSH Keys

For passwordless and more secure access, generate an SSH key pair on your client machine:

```bash
ssh-keygen
```

- You can set a passphrase for extra security.
- By default, keys are stored in `~/.ssh/`.

#### 3. Copy Your Public Key to the Server

Add your public key to the server's authorized keys:

```bash
ssh-copy-id -i ~/.ssh/mykey.pub your_user@<server_ip_or_domain>
```

- Enter your password when prompted.
- Now you can log in using your key (and passphrase, if set):

```bash
ssh -i ~/.ssh/mykey your_user@<server_ip_or_domain>
```

#### 4. Use an SSH Config File for Easy Connections

A sample SSH config file (`ssh.config`) is provided in `config_files/`. This allows you to connect using simple host aliases.

Copy it to your SSH directory:

```bash
mv config_files/ssh.config ~/.ssh/config
```

Now you can connect using just the host alias:

```bash
ssh mia-server
```

#### 5. SSH Server Security Recommendations

After setting up users and keys, improve your server's SSH security by editing `/etc/ssh/sshd_config`:

- **Enable public key authentication:**  
  Uncomment or add:  
  ```
  PubkeyAuthentication yes
  ```
- **(Optional) Change the SSH port:**  
  ```
  Port 8022
  ```
  *Note: Changing the port is a minor security measure, but can reduce automated attacks on port 22.*
- **Disable password authentication (key-only login):**  
  ```
  PasswordAuthentication no
  ```
- **Specify the authorized keys file:**  
  ```
  AuthorizedKeysFile .ssh/authorized_keys
  ```
- **Disable root login:**  
  ```
  PermitRootLogin no
  ```

After making changes, restart the SSH service:

```bash
sudo systemctl restart sshd
```

With these steps, you will have secure, convenient SSH access to all your servers.

---


## 🖥️ Interface Connections Documentation

Each router is connected to its local switch through interface `f0/1`, and to the Central router through interface `f2/0`. Inter-region links use interfaces `f0/0` or `f1/0` as point-to-point links. More detailed mappings will be added to `vm_config.md` and diagram annotations.

README is available in:

* English 🇺🇸 *(You are here)*
* [Español 🇪🇸](readme_es.md)

## ⚖️ License

This project is for educational and personal use. The Cisco IOS images and the operating systems used have their own licenses.

---