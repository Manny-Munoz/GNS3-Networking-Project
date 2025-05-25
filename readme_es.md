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
| [vm_config_es.md](vm_config_es.md)                                   | Documentación de las VMs utilizadas (ISOs, versiones, configuración) |

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

## 🖥️ Documentación de Conexiones de Interfaces

Cada router está conectado a su switch local a través de la interfaz `f0/1` y al router central mediante la interfaz `f2/0`. Los enlaces entre regiones utilizan las interfaces `f0/0` o `f1/0` como enlaces punto a punto. Mapeos más detallados se agregarán en `vm_config.md` y en las anotaciones del diagrama.

El README está disponible en:

* Español 🇪🇸 *(Estás aquí)*
* [English 🇺🇸](readme.md)

## ⚖️ Licencia

Este proyecto es para uso educativo y personal. Las imágenes de Cisco IOS y los sistemas operativos utilizados tienen sus propias licencias.

---

> Para más detalles, consulta el archivo `configuracion_routers.txt` y el diagrama visual en la carpeta `diagramas/`.