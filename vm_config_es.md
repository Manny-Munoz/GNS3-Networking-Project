# Configuración de Máquinas Virtuales (VM)

Este documento detalla la configuración y creación de las máquinas virtuales (VMs) utilizadas en el Proyecto de Práctica de Redes con GNS3. Cada sección incluye las especificaciones recomendadas y los comandos QEMU para crear e instalar cada VM.

---

## Índice

- [Ubuntu Server](#ubuntu-server)
- [Rocky Linux](#rocky-linux)
- [Debian](#debian)
- [openSUSE](#opensuse)
- [Loc-OS](#loc-os)
- [Hardware de Routers](#hardware-de-routers)
- [Pasos de Integración en GNS3](#pasos-de-integración-en-gns3)
- [Recomendaciones de Rendimiento](#recomendaciones-de-rendimiento)
- [Referencias y Enlaces Útiles](#referencias-y-enlaces-útiles)
- [Licencias y Descargo de Responsabilidad](#licencias-y-descargo-de-responsabilidad)

---

## Ubuntu Server

- **SO:** Ubuntu Server 24.04 LTS
- **RAM:** 800 MB
- **Disco:** 10 GB qcow2
- **ISO utilizada:** ubuntu-24.04.2-live-server-amd64.iso

**Creación e instalación con QEMU:**
```bash
qemu-img create -f qcow2 ubuntu-server.qcow2 10G
qemu-system-x86_64 -enable-kvm -m 1024 -cpu qemu64 -smp 1 \
  -drive file=ubuntu-server.qcow2,if=virtio \
  -cdrom ubuntu-24.04.2-live-server-amd64.iso -boot d \
  -net nic -net user
```

---

## Rocky Linux

- **SO:** Rocky Linux 9
- **RAM:** 800 MB
- **Disco:** 14 GB qcow2
- **ISO utilizada:** Rocky-9.3-x86_64-minimal.iso

**Creación e instalación con QEMU:**
```bash
qemu-img create -f qcow2 rocky-linux.qcow2 14G
qemu-system-x86_64 -enable-kvm -m 1024 -cpu qemu64 -smp 1 \
  -drive file=rocky-linux.qcow2,if=virtio \
  -cdrom Rocky-9.3-x86_64-minimal.iso -boot d \
  -net nic -net user
```

---

## Debian

- **SO:** Debian 12
- **RAM:** 800 MB
- **Disco:** 10 GB qcow2
- **ISO utilizada:** debian-12.10.0-amd64-netinst.iso

**Creación e instalación con QEMU:**
```bash
qemu-img create -f qcow2 debian12.qcow2 10G
qemu-system-x86_64 -enable-kvm -m 1024 -cpu qemu64 -smp 1 \
  -drive file=debian12.qcow2,if=virtio \
  -cdrom debian-12.10.0-amd64-netinst.iso -boot d \
  -net nic -net user
```

---

## openSUSE

- **SO:** openSUSE Leap 15.6
- **RAM:** 800 MB
- **Disco:** 12 GB qcow2
- **ISO utilizada:** openSUSE-Leap-15.6-DVD-x86_64-Media.iso

**Creación e instalación con QEMU:**
```bash
qemu-img create -f qcow2 opensuse-leap.qcow2 12G
qemu-system-x86_64 -enable-kvm -m 1024 -cpu qemu64 -smp 1 \
  -drive file=opensuse-leap.qcow2,if=virtio \
  -cdrom openSUSE-Leap-15.6-DVD-x86_64-Media.iso -boot d \
  -net nic -net user
```

---

## Loc-OS

- **SO:** Loc-OS 24 LXDE
- **RAM:** 1024 MB
- **Disco:** 10 GB qcow2
- **ISO utilizada:** Loc-OS-24-LXDE-X86_64.iso

**Creación e instalación con QEMU:**
```bash
qemu-img create -f qcow2 locos.qcow2 10G
qemu-system-x86_64 -enable-kvm -m 1024 -cpu qemu64 -smp 1 \
  -drive file=locos.qcow2,if=virtio \
  -cdrom Loc-OS-24-LXDE-X86_64.iso -boot d \
  -net nic -net user
```

---

# Hardware de Routers

**Router C7200**  
- RAM: 512 MiB  
- NVRAM: 512 KiB  
- Slot 0: C7200-IO-FE  
- Slot 1: PA-FE-TX  
- Slot 2: PA-FE-TX  

**Router 3725**  
- RAM: 128 MiB  
- NVRAM: 256 KiB  
- Slot 0: GT96100-FE  
- Slot 1: NM-1FE-TX  
- Slot 2: NM-1FE-TX  

> **Nota:** Para que los sistemas operativos funcionen en GNS3, el tipo de consola debe estar en "none". Además, la instalación debe hacerse sin entorno gráfico (GUI); si se instala una GUI, probablemente se requerirá más RAM y almacenamiento.

---

# Pasos de Integración en GNS3

## Agregar Máquinas Virtuales

Después de instalar todas las máquinas virtuales, crea un nuevo proyecto en GNS3 (por ejemplo, "Proyecto de Práctica de Redes GNS3").  
Para agregar las VMs:

1. Ve a **Editar > Preferencias > QEMU VMs > Nuevo**.
2. Nombra cada VM y sigue el asistente.
3. Selecciona el tipo de consola como **none**.
4. Cuando se te pida la imagen de disco, selecciona la ubicación de tu archivo `.qcow2` instalado.
5. Si creaste un directorio dedicado para tu proyecto (recomendado), selecciona **No** cuando se te pregunte si deseas copiar la imagen al directorio por defecto.
6. Después de crear cada VM, puedes cambiar su símbolo en preferencias para mejor organización visual.

## Agregar Routers

Para agregar routers:

1. Ve a **Editar > Preferencias > IOS Routers**.
2. Agrega tus imágenes de router Cisco (no incluidas por razones de licencia).
3. Configura los slots y la RAM como se especifica arriba.

---

# Recomendaciones de Rendimiento

Para una experiencia fluida, tu PC anfitriona debe cumplir al menos con los siguientes requisitos:

- **Mínimos (para topologías pequeñas, 2-3 VMs/routers):**
  - CPU: 2 núcleos
  - RAM: 8 GB
  - Almacenamiento: 40 GB libres (SSD recomendado)
- **Recomendados (para el proyecto completo, 5+ VMs/routers):**
  - CPU: 4+ núcleos (Intel/AMD modernos)
  - RAM: 16 GB o más
  - Almacenamiento: 80 GB+ libres en SSD
- **Consejos:**
  - Cierra aplicaciones no utilizadas para liberar RAM/CPU.
  - Usa SSD para las imágenes de disco de las VMs para mejor rendimiento.
  - Si usas GNS3 VM, asigna suficientes recursos en tu hipervisor.

---

# Referencias y Enlaces Útiles

- [Documentación de GNS3](https://docs.gns3.com/)
- [Documentación de QEMU](https://wiki.qemu.org/Documentation)
- [Cisco IOS Images (Info)](https://www.cisco.com/c/en/us/support/ios-nx-os-software/ios-software-releases-products/index.html)
- [ISOs de Ubuntu Server](https://ubuntu.com/download/server)
- [ISOs de Debian](https://www.debian.org/distrib/)
- [ISOs de Rocky Linux](https://rockylinux.org/download)
- [ISOs de openSUSE](https://get.opensuse.org/leap/)
- [ISOs de Loc-OS](https://sourceforge.net/projects/loc-os-linux/files/)

---

# Licencias y Descargo de Responsabilidad

- **No se distribuye ningún sistema operativo ni imágenes de Cisco IOS en este repositorio.**  
  Debes descargar todas las ISOs e imágenes de Cisco desde sus fuentes oficiales y respetar sus respectivas licencias.
- Este proyecto es solo para uso educativo y personal.

---

Si tienes preguntas o necesitas más detalles, consulta el README principal o los archivos de configuración de routers.# Configuración de Máquinas Virtuales (VM)

Este documento detalla la configuración y creación de las máquinas virtuales (VMs) utilizadas en el Proyecto de Práctica de Redes con GNS3. Cada sección incluye las especificaciones recomendadas y los comandos QEMU para crear e instalar cada VM.

---

## Ubuntu Server

- **SO:** Ubuntu Server 24.04 LTS
- **RAM:** 800 MB
- **Disco:** 10 GB qcow2
- **ISO utilizada:** ubuntu-24.04.2-live-server-amd64.iso

**Creación e instalación con QEMU:**
```bash
qemu-img create -f qcow2 ubuntu-server.qcow2 10G
qemu-system-x86_64 -enable-kvm -m 1024 -cpu qemu64 -smp 1 \
  -drive file=ubuntu-server.qcow2,if=virtio \
  -cdrom ubuntu-24.04.2-live-server-amd64.iso -boot d \
  -net nic -net user
```

---

## Rocky Linux

- **SO:** Rocky Linux 9
- **RAM:** 800 MB
- **Disco:** 14 GB qcow2
- **ISO utilizada:** Rocky-9.3-x86_64-minimal.iso

**Creación e instalación con QEMU:**
```bash
qemu-img create -f qcow2 rocky-linux.qcow2 14G
qemu-system-x86_64 -enable-kvm -m 1024 -cpu qemu64 -smp 1 \
  -drive file=rocky-linux.qcow2,if=virtio \
  -cdrom Rocky-9.3-x86_64-minimal.iso -boot d \
  -net nic -net user
```

---

## Debian

- **SO:** Debian 12
- **RAM:** 800 MB
- **Disco:** 10 GB qcow2
- **ISO utilizada:** debian-12.10.0-amd64-netinst.iso

**Creación e instalación con QEMU:**
```bash
qemu-img create -f qcow2 debian12.qcow2 10G
qemu-system-x86_64 -enable-kvm -m 1024 -cpu qemu64 -smp 1 \
  -drive file=debian12.qcow2,if=virtio \
  -cdrom debian-12.10.0-amd64-netinst.iso -boot d \
  -net nic -net user
```

---

## openSUSE

- **SO:** openSUSE Leap 15.6
- **RAM:** 800 MB
- **Disco:** 12 GB qcow2
- **ISO utilizada:** openSUSE-Leap-15.6-DVD-x86_64-Media.iso

**Creación e instalación con QEMU:**
```bash
qemu-img create -f qcow2 opensuse-leap.qcow2 12G
qemu-system-x86_64 -enable-kvm -m 1024 -cpu qemu64 -smp 1 \
  -drive file=opensuse-leap.qcow2,if=virtio \
  -cdrom openSUSE-Leap-15.6-DVD-x86_64-Media.iso -boot d \
  -net nic -net user
```

---

## Loc-OS

- **SO:** Loc-OS 24 LXDE
- **RAM:** 1024 MB
- **Disco:** 10 GB qcow2
- **ISO utilizada:** Loc-OS-24-LXDE-X86_64.iso

**Creación e instalación con QEMU:**
```bash
qemu-img create -f qcow2 locos.qcow2 10G
qemu-system-x86_64 -enable-kvm -m 1024 -cpu qemu64 -smp 1 \
  -drive file=locos.qcow2,if=virtio \
  -cdrom Loc-OS-24-LXDE-X86_64.iso -boot d \
  -net nic -net user
```

---

# Hardware de Routers

**Router C7200**  
- RAM: 512 MiB  
- NVRAM: 512 KiB  
- Slot 0: C7200-IO-FE  
- Slot 1: PA-FE-TX  
- Slot 2: PA-FE-TX  

**Router 3725**  
- RAM: 128 MiB  
- NVRAM: 256 KiB  
- Slot 0: GT96100-FE  
- Slot 1: NM-1FE-TX  
- Slot 2: NM-1FE-TX  

> **Nota:** Para que los sistemas operativos funcionen en GNS3, el tipo de consola debe estar en "none". Además, la instalación debe hacerse sin entorno gráfico (GUI); si se instala una GUI, probablemente se requerirá más RAM y almacenamiento.

---

# Pasos de Integración en GNS3

## Agregar Máquinas Virtuales

Después de instalar todas las máquinas virtuales, crea un nuevo proyecto en GNS3 (por ejemplo, "Proyecto de Práctica de Redes GNS3").  
Para agregar las VMs:

1. Ve a **Editar > Preferencias > QEMU VMs > Nuevo**.
2. Nombra cada VM y sigue el asistente.
3. Selecciona el tipo de consola como **none**.
4. Cuando se te pida la imagen de disco, selecciona la ubicación de tu archivo `.qcow2` instalado.
5. Si creaste un directorio dedicado para tu proyecto (recomendado), selecciona **No** cuando se te pregunte si deseas copiar la imagen al directorio por defecto.
6. Después de crear cada VM, puedes cambiar su símbolo en preferencias para mejor organización visual.

## Agregar Routers

Para agregar routers:

1. Ve a **Editar > Preferencias > IOS Routers**.
2. Agrega tus imágenes de router Cisco (no incluidas por razones de licencia).
3. Configura los slots y la RAM como se especifica arriba.

---

# Licencias y Descargo de Responsabilidad

- **No se distribuye ningún sistema operativo ni imágenes de Cisco IOS en este repositorio.**  
  Debes descargar todas las ISOs e imágenes de Cisco desde sus fuentes oficiales y respetar sus respectivas licencias.
- Este proyecto es solo para uso educativo y personal.

---

Si tienes preguntas o necesitas más detalles, consulta el README principal o los archivos de configuración de routers.