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

## 📃 Included Files

| File                          | Description                                                         |
| ----------------------------- | ------------------------------------------------------------------- |
| [configure_static_network.sh](scripts/configure_static_network.sh)   | Complete configurations of the Cisco routers used                   |
| [install_dependencies.sh](scripts/install_dependencies.sh) | Automated script to configure services on Linux servers             |
| [vm_config.md](vm_config.md)                | Documentation of the VMs used (ISOs, versions, configuration)       |

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

For more details, see the comments in the `named.conf.zones` and `db.example.com` files.

### 5. Configure NTP Server and Clients

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
sudo mv server.ntp.conf /etc/ntp.conf
```

- To apply changes, restart the NTP service:
  ```bash
  sudo systemctl restart ntp
  ```
- To check synchronization status:
  ```bash
  sudo ntpq -p
  sudo ntpstat
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
  sudo ntpstat
  ```

---

For more information, see the documentation and examples in the `./config_files/ntp/` directory.

---

## 🖥️ Interface Connections Documentation

Each router is connected to its local switch through interface `f0/1`, and to the Central router through interface `f2/0`. Inter-region links use interfaces `f0/0` or `f1/0` as point-to-point links. More detailed mappings will be added to `vm_config.md` and diagram annotations.

README is available in:

* English 🇺🇸 *(You are here)*
* [Español 🇪🇸](readme_es.md)



## ⚖️ License

This project is for educational and personal use. The Cisco IOS images and the operating systems used have their own licenses.

---

> For more details, see the `configuracion_routers.txt` file and the visual diagram in the `diagramas/` folder.