# VM Configuration

This document details the configuration and creation of the virtual machines (VMs) used in the GNS3 Networking Practice Project. Each VM section includes the recommended specs and the QEMU commands to create and install the VM.

---

## Index

- [Ubuntu Server](#ubuntu-server)
- [Rocky Linux](#rocky-linux)
- [Debian](#debian)
- [openSUSE](#opensuse)
- [Loc-OS](#loc-os)
- [Router Hardware](#router-hardware)
- [GNS3 Integration Steps](#gns3-integration-steps)
- [Licensing and Disclaimer](#licensing-and-disclaimer)

---

## Ubuntu Server

- **OS:** Ubuntu Server 24.04 LTS
- **RAM:** 800 MB
- **Disk:** 10 GB qcow2
- **ISO Used:** ubuntu-24.04.2-live-server-amd64.iso

**Creation and installation with QEMU:**
```bash
qemu-img create -f qcow2 ubuntu-server.qcow2 10G
qemu-system-x86_64 -enable-kvm -m 1024 -cpu qemu64 -smp 1 \
  -drive file=ubuntu-server.qcow2,if=virtio \
  -cdrom ubuntu-24.04.2-live-server-amd64.iso -boot d \
  -net nic -net user
```

---

## Rocky Linux

- **OS:** Rocky Linux 9
- **RAM:** 800 MB
- **Disk:** 14 GB qcow2
- **ISO Used:** Rocky-9.3-x86_64-minimal.iso

**Creation and installation with QEMU:**
```bash
qemu-img create -f qcow2 rocky-linux.qcow2 14G
qemu-system-x86_64 -enable-kvm -m 1024 -cpu qemu64 -smp 1 \
  -drive file=rocky-linux.qcow2,if=virtio \
  -cdrom Rocky-9.3-x86_64-minimal.iso -boot d \
  -net nic -net user
```

---

## Debian

- **OS:** Debian 12
- **RAM:** 800 MB
- **Disk:** 10 GB qcow2
- **ISO Used:** debian-12.10.0-amd64-netinst.iso

**Creation and installation with QEMU:**
```bash
qemu-img create -f qcow2 debian12.qcow2 10G
qemu-system-x86_64 -enable-kvm -m 1024 -cpu qemu64 -smp 1 \
  -drive file=debian12.qcow2,if=virtio \
  -cdrom debian-12.10.0-amd64-netinst.iso -boot d \
  -net nic -net user
```

---

## openSUSE

- **OS:** openSUSE Leap 15.6
- **RAM:** 800 MB
- **Disk:** 12 GB qcow2
- **ISO Used:** openSUSE-Leap-15.6-DVD-x86_64-Media.iso

**Creation and installation with QEMU:**
```bash
qemu-img create -f qcow2 opensuse-leap.qcow2 12G
qemu-system-x86_64 -enable-kvm -m 1024 -cpu qemu64 -smp 1 \
  -drive file=opensuse-leap.qcow2,if=virtio \
  -cdrom openSUSE-Leap-15.6-DVD-x86_64-Media.iso -boot d \
  -net nic -net user
```

---

## Loc-OS

- **OS:** Loc-OS 24 LXDE
- **RAM:** 1024 MB
- **Disk:** 10 GB qcow2
- **ISO Used:** Loc-OS-24-LXDE-X86_64.iso

**Creation and installation with QEMU:**
```bash
qemu-img create -f qcow2 locos.qcow2 10G
qemu-system-x86_64 -enable-kvm -m 1024 -cpu qemu64 -smp 1 \
  -drive file=locos.qcow2,if=virtio \
  -cdrom Loc-OS-24-LXDE-X86_64.iso -boot d \
  -net nic -net user
```

---

# Router Hardware

**C7200 Router**  
- RAM: 512 MiB  
- NVRAM: 512 KiB  
- Slot 0: C7200-IO-FE  
- Slot 1: PA-FE-TX  
- Slot 2: PA-FE-TX  

**3725 Router**  
- RAM: 128 MiB  
- NVRAM: 256 KiB  
- Slot 0: GT96100-FE  
- Slot 1: NM-1FE-TX  
- Slot 2: NM-1FE-TX  

> **Note:** For the OSs to work in GNS3, the console type should be set to "none". Also, installation should be done without a GUI; if a GUI is installed, more RAM and storage will likely be needed.

---

# GNS3 Integration Steps

## Adding Virtual Machines

After installing all virtual machines, create a new project in GNS3 (e.g., "GNS3 Networking Practice Project").  
To add the VMs:

1. Go to **Edit > Preferences > QEMU VMs > New**.
2. Name each VM and proceed through the wizard.
3. Set the console type to **none**.
4. When prompted for the disk image, select the location of your installed `.qcow2` file.
5. If you created a dedicated directory for your project (recommended), select **No** when asked to copy the image to the default directory.
6. After creating each VM, you can change its symbol in preferences for better visual organization.

## Adding Routers

To add routers:

1. Go to **Edit > Preferences > IOS Routers**.
2. Add your Cisco router images (not included for licensing reasons).
3. Configure slots and RAM as specified above.

# Licensing and Disclaimer

- **No operating system or Cisco IOS images are distributed in this repository.**  
  You must download all ISOs and Cisco images from their official sources and respect their respective licenses.
- This project is for educational and personal use only.

---