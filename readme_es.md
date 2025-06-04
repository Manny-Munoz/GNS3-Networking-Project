# Proyecto de Práctica de Redes en GNS3

Este repositorio contiene una práctica completa para el diseño y configuración de una red distribuida utilizando GNS3. Incluye configuraciones de routers, scripts de instalación para servidores y un diagrama visual de la topología de red.

## 📚 Índice

- [🔧 Captura de pantalla del proyecto en GNS3](#-captura-de-pantalla-del-proyecto-en-gns3)
- [Códigos de Región](#códigos-de-región)
- [📊 Descripción General](#-descripción-general)
- [🔹 Topología](#-topología)
- [🌐 Direccionamiento y NAT (Router Central)](#-direccionamiento-y-nat-router-central)
- [📝 Rutas y RIP](#-rutas-y-rip)
- [💻 Sistemas Operativos Usados en los Servidores](#-sistemas-operativos-usados-en-los-servidores)
- [📃 Archivos Incluidos](#-archivos-incluidos)
- [🔗 Conexión con el exterior](#-conexión-con-el-exterior)
- [📚 Requisitos](#-requisitos)
- [Documentación de Interfaces y Conexiones](#documentación-de-interfaces-y-conexiones)
- [🚀 Uso](#-uso)
- [🖥️ Documentación de Conexiones de Interfaces](#-documentación-de-conexiones-de-interfaces)
- [⚖️ Licencia](#-licencia)

---

### 🔧 Captura de pantalla del proyecto en GNS3

A continuación se muestra la vista real de la topología dentro de GNS3:

![Topología GNS3](images/captura_topologia_gns3.png)

---

## Códigos de Región

| Código  | Ubicación                  |
|---------|----------------------------|
| MIA     | Miami, EE.UU.              |
| MEX     | Ciudad de México           |
| GUA     | Ciudad de Guatemala        |
| CRC     | San José, Costa Rica       |
| COMMON  | Router Backbone Central (Red principal) |

---

## 📊 Descripción General

La red simulada consiste en cinco regiones interconectadas:

* Red Común (nodo principal de interconexión y salida a Internet)
* Red Miami
* Red México
* Red Guatemala
* Red Costa Rica

Se utilizaron routers Cisco y máquinas virtuales con distintos sistemas operativos para simular servidores y estaciones de trabajo.

## 🔹 Topología

* **Router principal:** Cisco C7200 (Red Central)
* **Routers de borde:** Cisco C3725 para cada región (Miami, México, Guatemala, Costa Rica)
* **Protocolos:** RIP v2 con rutas estáticas para salida a Internet
* **Conexión a Internet:** Interfaz `f1/0` del router central, con IP asignada por DHCP y NAT configurado

## 🌐 Direccionamiento y NAT (Router Central)

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

## 📝 Rutas y RIP

```bash
router rip
 version 2
 network 172.16.0.0
 network 10.10.16.0
 network 192.168.20.0
 no auto-summary
```

Cada router regional está conectado al router central a través de la interfaz `f2/0` configurada en la subred `172.16.100.0/24` y una interfaz punto a punto para conexiones internas.

## 💻 Sistemas Operativos Usados en los Servidores

* Ubuntu Server
* Debian
* openSUSE
* Rocky Linux

Estos servidores fueron configurados usando el [script de instalación](scripts/install_dependencies.sh), que automatiza la instalación de paquetes y servicios como Apache, MariaDB, PHP, DNS, DHCP, entre otros.

## 📃 Archivos Incluidos

| Archivo                                         | Descripción                                                      |
|-------------------------------------------------|------------------------------------------------------------------|
| [configure_static_network.sh](scripts/configure_static_network.sh) | Configuraciones completas de los routers Cisco utilizados        |
| [install_dependencies.sh](scripts/install_dependencies.sh)         | Script automatizado para configurar servicios en servidores Linux |
| [install_cms.sh](scripts/install_cms.sh)                         | Script para automatizar la creación de bases de datos y usuarios para CMS |
| [generate_ssl_certs.sh](scripts/generate_ssl_certs.sh)           | Script para generar certificados SSL y virtual hosts de Apache   |
| [setup_file_server.sh](scripts/setup_file_server.sh)             | Script para configurar un servidor de archivos SFTP/NFS          |
| [create_user.sql](config_files/create_user.sql)                  | Plantilla SQL para crear bases de datos y usuarios para CMS       |
| [named.conf.zones](config_files/named.conf.zones)                | Archivo de configuración de zonas DNS                            |
| [named.conf.options](config_files/named.conf.options)            | Archivo de configuración de opciones DNS                         |
| [db.example.com](config_files/db.example.com)                    | Archivo de zona DNS de ejemplo                                   |
| [vm_config_es.md](vm_config_es.md)                                     | Documentación de las máquinas virtuales utilizadas               |

## 🔗 Conexión con el exterior

El router de la Red Común puede conectarse a una nube NAT o directamente a una interfaz tipo `Cloud` en GNS3, obteniendo su IP por DHCP y actuando como puerta de enlace a Internet para toda la red.

## 📚 Requisitos

* GNS3 2.2 o superior
* Imágenes IOS de Cisco (C7200 y C3725)
* Imágenes de sistemas operativos en formato `.qcow2` y `.iso`
* QEMU y configuración de GNS3 VM (recomendado)

# Documentación de Interfaces y Conexiones

A continuación se muestra un resumen de qué interfaz conecta cada router y switch, para simplificar la configuración y el cableado en GNS3:

| Dispositivo    | Interfaz   | Conectado a         | Descripción                |
| -------------- | ---------- | ------------------- | -------------------------- |
| R-Common       | f2/0       | Cloud/NAT           | Puerta de enlace a Internet|
| R-Common       | f0/0       | SW-Common           | LAN Central                |
| R-MIA          | f0/0       | R-MEX (f0/0)        | Enlace a México            |
| R-MIA          | f0/1       | SW-MIA              | LAN Miami                  |
| R-MIA          | f2/0       | SW-Common           | Enlace a Común             |
| R-MEX          | f0/0       | R-MIA (f0/0)        | Enlace a Miami             |
| R-MEX          | f0/1       | SW-MEX              | LAN México                 |
| R-MEX          | f1/0       | R-GUA (f0/0)        | Enlace a Guatemala         |
| R-MEX          | f2/0       | SW-Common           | Enlace a Común             |
| R-GUA          | f0/0       | R-MEX (f1/0)        | Enlace a México            |
| R-GUA          | f0/1       | SW-GUA              | LAN Guatemala              |
| R-GUA          | f1/0       | R-CRC (f0/0)        | Enlace a Costa Rica        |
| R-GUA          | f2/0       | SW-Common           | Enlace a Común             |
| R-CRC          | f0/0       | R-GUA (f1/0)        | Enlace a Guatemala         |
| R-CRC          | f0/1       | SW-CRC              | LAN Costa Rica             |
| R-CRC          | f2/0       | SW-Common           | Enlace a Común             |

- **SW-XXX**: Se refiere al switch de cada región (Central, MIA, MEX, GUA, CRC).
- Todos los servidores y estaciones de trabajo se conectan a su switch regional correspondiente.
- El nodo "Cloud" en GNS3 representa la conexión a Internet.

## 🚀 Uso

### ⚠️ Solución de Problemas de Red en Rocky Linux

Si Rocky Linux no tiene conectividad de red al iniciar por primera vez, es posible que debas activar manualmente la interfaz de red. Ejecuta los siguientes comandos:

```bash
sudo nmcli device status
sudo nmcli device connect eth0
sudo nmcli connection up eth0
```
*(Reemplaza `eth0` con el nombre real de tu interfaz, como `ens3` o `enp1s0`.)*

---

### 1. Ejecutar el script install_dependencies.sh

Primero, da permisos de ejecución y ejecuta el script según tu sistema operativo.

**Para Ubuntu/Rocky/openSUSE:**
```bash
sudo chmod +x ./scripts/install_dependencies.sh
sudo ./scripts/install_dependencies.sh
```

**Para Debian:**
```bash
su -
chmod +x ./scripts/install_dependencies.sh
./scripts/install_dependencies.sh
```

---

#### ⚠️ Prompts Interactivos Durante la Instalación

Mientras ejecutas el script, deberás responder algunas preguntas para configurar MySQL/MariaDB:

**Instalación Segura de MySQL (`mysql_secure_installation`):**

- **Enter current password for root (enter for none):**  
  Solo presiona Enter (no hay contraseña configurada por defecto).
- **Switch to unix_socket authentication?**  
  Responde **no** (usar unix_socket puede ser un problema de seguridad más adelante).
- **Change the root password?**  
  Responde **sí** y establece una contraseña segura para root.
- **Remove anonymous users?**  
  Responde **sí**.
- **Disallow root login remotely?**  
  Responde **sí**.
- **Remove test database and access to it?**  
  Responde **sí**.
- **Reload privilege tables now?**  
  Responde **sí**.

---

### 2. Ejecutar configure_static_network.sh

**Para Ubuntu/Rocky/openSUSE:**
```bash
sudo chmod +x ./scripts/configure_static_network.sh
sudo ./scripts/configure_static_network.sh
```

**Para Debian:**
```bash
su -
chmod +x ./scripts/configure_static_network.sh
./scripts/configure_static_network.sh
```

---

### 3. Crear la base de datos y usuario para el CMS

Dependiendo del CMS que utilices, deberás editar ciertos parámetros en el script `create_user.sql` (como el nombre de la base de datos, usuario y contraseña).  
Después de realizar los cambios necesarios, puedes ejecutar el script con:

```bash
mariadb -u root -p < create_user.sql
```
Para más detalles y ejemplos, consulta directamente el archivo `create_user.sql`, que contiene información y guía adicional.

---

### 4. Configurar zonas DNS con named.conf.zones

Utiliza el archivo `named.conf.zones` para configurar tus zonas DNS.  
Este archivo define las cuatro zonas DNS usadas en este proyecto: `gt.com`, `cr.com`, `mx.com` y `us.com`.

**IMPORTANTE:**  
Si necesitas configurar una de estas zonas (por ejemplo, `gt.com`) como zona maestra en un servidor específico, **debes eliminar o comentar la zona forward correspondiente de `gt.com`** en este archivo.  
Después de eliminar la zona forward para ese dominio, sigue las instrucciones a continuación para incluir este archivo en la configuración de tu servidor. Una vez hecho esto, continúa con el manual en `readme.md` o consulta el archivo `db.example.com` para más pasos de configuración.

**Cómo usar este archivo:**

- **En Debian/Ubuntu:**
    1. Mueve este archivo a `/etc/bind/`:
       ```bash
       mv ./named.conf.zones /etc/bind/
       ```
    2. Agrega la siguiente línea a `/etc/bind/named.conf`:
       ```
       include "/etc/bind/named.conf.zones";
       ```

- **En openSUSE o Rocky Linux:**
    1. Mueve este archivo a `/etc/named/`:
       ```bash
       mv ./named.conf.zones /etc/named/
       ```
    2. Agrega la siguiente línea a `/etc/named.conf`:
       ```
       include "/etc/named/named.conf.zones";
       ```
---

#### Ejemplo: Creando un archivo de zona maestra

Puedes usar el archivo `db.example.com` como plantilla para tus archivos de zona.  
Modifica la parte "gt" para que coincida con el código de país (por ejemplo, "cr", "us", "mx") y actualiza las direcciones IP según sea necesario.  
Después de hacer los cambios, renombra el archivo para que coincida con la zona (por ejemplo, `db.gt.com`).

- **En Debian/Ubuntu:**
    - Mueve el archivo:
      ```bash
      mv ./db.gt.com /etc/bind/
      ```
    - Agrega la zona a `/etc/bind/named.conf.local`:
      ```
      zone "gt.com" {
        type master;
        file "/etc/bind/db.gt.com";
      };
      ```

- **En Rocky Linux:**
    - Mueve el archivo:
      ```bash
      mv ./db.gt.com /var/named/
      ```
    - Agrega la zona a `/etc/named.conf`:
      ```
      zone "gt.com" {
        type master;
        file "/var/named/db.gt.com";
      };
      ```

- **En openSUSE:**
    - Mueve el archivo:
      ```bash
      mv ./db.gt.com /var/lib/named/
      ```
    - Agrega la zona a `/etc/named.conf`:
      ```
      zone "gt.com" {
        type master;
        file "/var/lib/named/db.gt.com";
      };
      ```

#### 🔁 Agregar un Servidor DNS Secundario para Permitir Resolución Externa

Para permitir que las consultas DNS se resuelvan fuera de la red (por ejemplo, resolviendo `google.com`), debes agregar un reenviador DNS secundario (como el `8.8.8.8` de Google) dentro del bloque `options`. Puedes usar el archivo proporcionado `named.conf.options` como plantilla para la configuración DNS. Después de editarlo (o si deseas usar la configuración predeterminada), mueve el archivo a la ubicación correcta:

- **En Debian/Ubuntu:**
    - Descomenta la línea de directorio apropiada en tu archivo de opciones:
        ```conf
        directory "/var/cache/bind";
        ```
    - Mueve tu archivo personalizado `named.conf.options` para reemplazar el existente:
        ```bash
        mv ./config_files/named.conf.options /bind/named.conf.options
        ```
    - Reinicia BIND para aplicar los cambios:
        ```bash
        sudo systemctl restart bind9
        ```

- **En Rocky Linux ntOS EL:**
    - Abre `/etc/named.conf` y elimina cualquier bloque existente de `options { ... };`.
    - Mueve tu archivo de configuración:
        ```bash
        mv ./named.conf.options /named/named.conf.options
        ```
    - Agrega la siguiente línea al final de `/etc/named.conf`:
        ```
        include "/var/named/named.conf.options";
        ```
    - Reinicia el servicio DNS:
        ```bash
        sudo systemctl restart named
        ```

- **En openSUSE:**
    - Edita `/etc/named.conf` y elimina el bloque existente de `options { ... };`.
    - Mueve tu archivo de configuración:
        ```bash
        mv ./named.conf.options /lib/named/named.conf.options
        ```
    - Agrega esta línea a `/etc/named.conf`:
        ```
        include "/var/lib/named/named.conf.options";
        ```
    - Reinicia el servicio DNS:
        ```bash
        sudo systemctl restart named
        ```

---

### 5. Generar certificados SSL y Virtual Hosts de Apache

El script [`generate_ssl_certs.sh`](./scripts/generate_ssl_certs.sh) automatiza la creación de certificados SSL autofirmados y la configuración de virtual hosts de Apache para tus subdominios. Funciona en Ubuntu, Debian, openSUSE y Rocky Linux.

#### Uso

**1. Haz el script ejecutable y ejecútalo como root:**

Para Ubuntu/Rocky/openSUSE:
```bash
sudo chmod +x ./scripts/generate_ssl_certs.sh
sudo ./scripts/generate_ssl_certs.sh
```

Para Debian:
```bash
su -
chmod +x ./scripts/generate_ssl_certs.sh
./scripts/generate_ssl_certs.sh
```

**2. Sigue los prompts interactivos:**
- Ingresa el dominio base (por ejemplo, `quetzal`).
- Selecciona el código de país (`gt`, `cr`, `us`, `mx`).
- Elige subdominios por defecto o personalizados.
- Opcionalmente, crea un usuario inicial para autenticación HTTP Basic (para `.htpasswd`).

**3. El script hará lo siguiente:**
- Generar un certificado SSL autofirmado para tu dominio.
- Crear una configuración de virtual host para cada subdominio.
- Guardar los certificados SSL en `/etc/ssl/<tu-dominio>/`.
- Guardar las configuraciones de Apache en el directorio correcto según tu sistema operativo.
- Recargar Apache para aplicar los cambios.

**4. Proteger subdominios con autenticación básica (opcional):**

Para habilitar autenticación HTTP Basic en cualquier subdominio, agrega las siguientes líneas dentro del bloque `<Directory>` de la configuración del virtual host correspondiente:

```apache
    AuthType Basic
    AuthName "Restricted Access"
    AuthUserFile /etc/apache2/.htpasswd   # o /etc/httpd/.htpasswd en Rocky
    Require valid-user
```

Consulta la salida del script para ver la ruta exacta de tu archivo `.htpasswd`.

Para más detalles, revisa los comentarios dentro del script [`generate_ssl_certs.sh`](./scripts/generate_ssl_certs.sh).

---

### 6. Configurar el servidor NTP y los clientes

#### Configuración NTP para Ubuntu Server/Debian (usando `ntpd`)

Utiliza el archivo `server.ntp.conf` ubicado en `./config_files/ntp/server.ntp.conf` para configurar tu servidor NTP.

Este archivo está diseñado para sistemas Debian/Ubuntu y configura el demonio NTP para sincronizar la hora con servidores externos.  
Puedes modificar las líneas `pool` para usar tus propios servidores NTP si lo deseas.

**Ejemplo de `./config_files/ntp/server.ntp.conf`:**
```conf
pool 0.debian.pool.ntp.org iburst
pool 1.debian.pool.ntp.org iburst
pool 2.debian.pool.ntp.org iburst
pool 3.debian.pool.ntp.org iburst
```

Después de editar (o si deseas usar la configuración por defecto), mueve el archivo a la ubicación correcta:
```bash
cd ./config_files/ntp
sudo mv server.ntp.conf /etc/ntp.conf
```

- Para aplicar los cambios, reinicia el servicio NTP:
  ```bash
  sudo systemctl restart ntp
  ```
- Para verificar el estado de sincronización:
  ```bash
  sudo ntpq -p
  sudo ntpstat
  ```

---

#### Configuración NTP para openSUSE/Rocky Linux (usando `chrony`)

Utiliza el archivo `server.client.ntp.conf` en `./config_files/ntp/server.client.ntp.conf` para configurar Chrony.

Este archivo es para sistemas openSUSE y Rocky Linux usando Chrony.  
Debe referenciar las direcciones IP o nombres de host de tus servidores NTP Debian/Ubuntu.

Después de editar, mueve el archivo a la ubicación correcta:
```bash
sudo mv server.client.ntp.conf /etc/chrony.conf
```

- Para aplicar los cambios, reinicia el servicio Chrony:
  ```bash
  sudo systemctl restart chronyd
  ```
- Para verificar el estado de sincronización:
  ```bash
  chronyc tracking
  chronyc sources -v
  ```

---

#### Configuración NTP para LocOS (o cualquier cliente Linux usando `ntpd`)

Para LocOS u otros clientes Linux usando `ntpd`, utiliza el archivo `client.ntp.conf` en `./config_files/ntp/client.ntp.conf`.

Edita el archivo para usar el servidor NTP apropiado para tu región (por ejemplo, `quetzal.ntp.gt.com`, `quetzal.ntp.cr.com`, `quetzal.ntp.mx.com`, etc.).  
Después de editar, mueve el archivo a la ubicación correcta:

```bash
cd ./config_files/ntp
sudo mv client.ntp.conf /etc/ntp.conf
```

- Reinicia el servicio NTP después de los cambios:
  ```bash
  sudo systemctl restart ntp
  ```
- Verifica el estado:
  ```bash
  sudo ntpq -p
  ```

Para más información, consulta la documentación y ejemplos en el directorio `./config_files/ntp/`.

---

### 7. Configurar y Usar el Servidor de Archivos (SFTP/NFS)

El script [`setup_file_server.sh`](./scripts/setup_file_server.sh) te permite configurar rápidamente un servidor de archivos compartidos utilizando SFTP (en Debian/Ubuntu) o NFS (en openSUSE/Rocky Linux).

#### Uso

1. **Haz el script ejecutable y ejecútalo como root:**
   ```bash
   sudo chmod +x ./scripts/setup_file_server.sh
   sudo ./scripts/setup_file_server.sh
   ```

2. **Sigue los prompts interactivos:**
   - Elige el directorio de montaje (por defecto es `/srv/fileshare` o especifica uno personalizado).
   - El script detectará tu distribución y configurará automáticamente SFTP o NFS según corresponda.

#### Acceso desde Clientes

- **En Debian/Ubuntu (SFTP):**
  - Usuario: `quetzalftp`
  - Grupo: `ftpusers`
  - Carpeta de subida: `upload`
  - Conéctate desde Linux:
    ```bash
    sftp quetzalftp@<server_ip>
    cd upload
    put filename.txt
    ```
  - En FileZilla:
    - Protocolo: SFTP
    - Host: `<server_ip>`
    - Usuario: `quetzalftp`

- **En openSUSE/Rocky Linux (NFS):**
  - Monta el directorio compartido desde el cliente:
    ```bash
    sudo apt install nfs-common    # En Debian/Ubuntu
    sudo mount -t nfs <server_ip>:/srv/fileshare 
    ```
  - Para montar automáticamente al inicio, agrega lo siguiente a `/etc/fstab`:
    ```
    <server_ip>:/srv/fileshare    nfs  defaults  0  0
    ```

Consulta el script para obtener más detalles o opciones de personalización.

---

### 8. Configurar el Servidor SSH

El acceso SSH seguro y confiable es esencial para administrar tus servidores de forma remota. Esta sección explica cómo configurar la autenticación con claves SSH y usar un archivo de configuración para conexiones más fáciles.

#### 1. Acceso SSH Básico

Para conectarte a un servidor por primera vez, utiliza:

```bash
ssh <usuario>@<ip_del_servidor_o_dominio>
```

- Se te pedirá que aceptes la huella digital del servidor; escribe `yes`.
- Ingresa tu contraseña cuando se te solicite.

#### 2. Generar Claves SSH

Para un acceso más seguro y sin contraseña, genera un par de claves SSH en tu máquina cliente:

```bash
ssh-keygen
```

- Puedes establecer una frase de contraseña para mayor seguridad.
- Por defecto, las claves se almacenan en `~/.ssh/`.

#### 3. Copiar tu Clave Pública al Servidor

Agrega tu clave pública al archivo de claves autorizadas del servidor:

```bash
ssh-copy-id -i ~/.ssh/mi_clave.pub tu_usuario@<ip_del_servidor_o_dominio>
```

- Ingresa tu contraseña cuando se te solicite.
- Ahora puedes iniciar sesión utilizando tu clave (y frase de contraseña, si la configuraste):

```bash
ssh -i ~/.ssh/mi_clave tu_usuario@<ip_del_servidor_o_dominio>
```

#### 4. Usar un Archivo de Configuración SSH para Conexiones Fáciles

Se proporciona un archivo de configuración SSH de ejemplo (`ssh.config`) en `config_files/`. Esto te permite conectarte utilizando alias simples para los hosts.

Copia el archivo a tu directorio SSH:

```bash
mv config_files/ssh.config ~/.ssh/config
```

Ahora puedes conectarte utilizando solo el alias del host:

```bash
ssh mia-servidor
```

#### 5. Recomendaciones de Seguridad para el Servidor SSH

Después de configurar usuarios y claves, mejora la seguridad de tu servidor SSH editando `/etc/ssh/sshd_config`:

- **Habilitar la autenticación con clave pública:**  
  Descomenta o agrega:  
  ```
  PubkeyAuthentication yes
  ```
- **(Opcional) Cambiar el puerto SSH:**  
  ```
  Port 8022
  ```
  *Nota: Cambiar el puerto es una medida de seguridad menor, pero puede reducir ataques automatizados en el puerto 22.*
- **Deshabilitar la autenticación por contraseña (solo inicio con clave):**  
  ```
  PasswordAuthentication no
  ```
- **Especificar el archivo de claves autorizadas:**  
  ```
  AuthorizedKeysFile .ssh/authorized_keys
  ```
- **Deshabilitar el inicio de sesión como root:**  
  ```
  PermitRootLogin no
  ```

Después de realizar los cambios, reinicia el servicio SSH:

```bash
sudo systemctl restart sshd
```

Con estos pasos, tendrás acceso SSH seguro y conveniente a todos tus servidores.

---


## 🖥️ Documentación de Conexiones de Interfaces

Cada router está conectado a su switch local a través de la interfaz `f0/1` y al router central mediante la interfaz `f2/0`. Los enlaces entre regiones utilizan las interfaces `f0/0` o `f1/0` como enlaces punto a punto. Mapeos más detallados se agregarán en `vm_config.md` y en las anotaciones del diagrama.

El README está disponible en:

* Español 🇪🇸 *(Estás aquí)*
* [English 🇺🇸](readme.md)

## ⚖️ Licencia

Este proyecto está licenciado bajo los siguientes términos:

- **Scripts y código**: Licenciado bajo la Licencia Pública General de GNU v3.0 (GPL-3.0). Consulta el archivo `LICENSE` para más detalles.
- **Documentación**: Licenciada bajo la Licencia Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0). Consulta el archivo `LICENSE` para más detalles.

Nota: Los sistemas operativos y las imágenes de Cisco IOS referenciados en este proyecto no están incluidos y están sujetos a sus propios términos de licencia.