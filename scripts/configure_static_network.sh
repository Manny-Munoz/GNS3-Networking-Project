#!/bin/bash

set -e

# Detect OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    echo "Could not detect operating system."
    exit 1
fi

echo "Detected distro: $DISTRO"

ip_in_subnet() {
    local ip=$1
    local subnet=$2
    local mask=$3
    local ip2int subnet2int mask2int
    ip2int=$(printf "%u\n" $(ipcalc -n "$ip" | grep Address | awk '{print $2}' | tr . ' '))
    subnet2int=$(printf "%u\n" $(ipcalc -n "$subnet" | grep Address | awk '{print $2}' | tr . ' '))
    mask2int=$(printf "%u\n" $(ipcalc -n "$mask" | grep Netmask | awk '{print $2}' | tr . ' '))
    [[ $((ip2int & mask2int)) -eq $((subnet2int & mask2int)) ]]
}


# Ask user for required data
read -p "Interface name (e.g. ens3, eth0): " IFACE
read -p "Static IP address (e.g. 172.16.0.10): " ADDRESS
read -p "Netmask (e.g. 255.255.252.0): " NETMASK
read -p "Gateway (e.g. 172.16.0.1): " GATEWAY
read -p "DNS nameserver (e.g. 172.16.0.1): " DNS
read -p "DHCP Range start (e.g. 172.16.0.20): " DHCP_START
read -p "DHCP Range end (e.g. 172.16.0.100): " DHCP_END


# Calculate subnet using ipcalc
SUBNET=$(ipcalc -n "$ADDRESS" "$NETMASK" | grep Network | awk '{print $2}' | cut -d'/' -f1)

# Validate DHCP range
if ! ip_in_subnet "$DHCP_START" "$SUBNET" "$NETMASK" || ! ip_in_subnet "$DHCP_END" "$SUBNET" "$NETMASK"; then
    echo "❌ ERROR: The DHCP range does not match the subnet $SUBNET/$NETMASK"
    exit 1
fi


case "$DISTRO" in

debian | ubuntu)
    echo "Configuring network for Debian/Ubuntu..."

    if grep -qi ubuntu /etc/os-release && [ -d /etc/netplan ]; then
        NETPLAN_FILE="/etc/netplan/50-cloud-init.yaml"
        if [ ! -f "$NETPLAN_FILE" ]; then
            NETPLAN_FILE="/etc/netplan/01-netcfg.yaml"
        fi

        cat <<EOF > "$NETPLAN_FILE"
network:
  version: 2
  renderer: networkd
  ethernets:
    $IFACE:
      dhcp4: no
      addresses: [$ADDRESS/$(
        ipcalc -p "$ADDRESS" "$NETMASK" | awk -F= '/PREFIX/ {print $2}'
      )]
      gateway4: $GATEWAY
      nameservers:
        addresses: [$DNS]
EOF

        echo "Applying Netplan configuration..."
        netplan apply
    else
        # Fallback for Debian or legacy Ubuntu
        sed -i "/iface $IFACE inet dhcp/d" /etc/network/interfaces

        cat <<EOF >>/etc/network/interfaces

auto $IFACE
iface $IFACE inet static
    address $ADDRESS
    netmask $NETMASK
    gateway $GATEWAY
    dns-nameservers $DNS
EOF

        echo "Restarting networking..."
        systemctl restart networking
        systemctl status networking
    fi

    echo "Configuring isc-dhcp-server..."

    echo "INTERFACESv4=\"$IFACE\"" >/etc/default/isc-dhcp-server

    cat <<EOF >/etc/dhcp/dhcpd.conf
subnet $SUBNET netmask $NETMASK {
    range $DHCP_START $DHCP_END;
    option routers $GATEWAY;
    option subnet-mask $NETMASK;
    option domain-name-servers $DNS;
    default-lease-time 600;
    max-lease-time 7200;
}
EOF

    systemctl restart isc-dhcp-server
    systemctl status isc-dhcp-server
    ;;
opensuse* | suse)
    echo "Configuring network for openSUSE..."


    CONFIG_FILE="/etc/sysconfig/network/ifcfg-$IFACE"

    cat <<EOF >$CONFIG_FILE
BOOTPROTO='static'
STARTMODE='auto'
IPADDR='$ADDRESS'
NETMASK='$NETMASK'
GATEWAY='$GATEWAY'
EOF

    echo "nameserver $DNS" >/etc/resolv.conf

    # Configure DHCP server
    cat <<EOF >/etc/dhcpd.conf
subnet $SUBNET netmask $NETMASK {
    range $DHCP_START $DHCP_END;
    option routers $GATEWAY;
    option subnet-mask $NETMASK;
    option domain-name-servers $DNS;
    default-lease-time 600;
    max-lease-time 7200;
}
EOF

    systemctl enable dhcpd
    systemctl restart wicked
    systemctl restart dhcpd
    systemctl status dhcpd
    ;;

rocky | centos | rhel)
    echo "Configuring network for Rocky Linux/CentOS/RHEL..."

    CONFIG_FILE="/etc/sysconfig/network-scripts/ifcfg-$IFACE"

    cat <<EOF >$CONFIG_FILE
DEVICE=$IFACE
BOOTPROTO=static
ONBOOT=yes
IPADDR=$ADDRESS
NETMASK=$NETMASK
GATEWAY=$GATEWAY
DNS1=$DNS
EOF

    echo "nameserver $DNS" >/etc/resolv.conf

    # Configure DHCP server
    cat <<EOF >/etc/dhcp/dhcpd.conf
subnet $SUBNET netmask $NETMASK {
    range $DHCP_START $DHCP_END;
    option routers $GATEWAY;
    option subnet-mask $NETMASK;
    option domain-name-servers $DNS;
    default-lease-time 600;
    max-lease-time 7200;
}
EOF

    systemctl enable dhcpd
    echo "Restarting network..."
    nmcli connection reload
    nmcli connection up "$IFACE"
    systemctl restart dhcpd
    systemctl status dhcpd
    ;;

*)
    echo "Distribution not supported yet: $DISTRO"
    exit 1
    ;;
esac

echo "✅ Network and DHCP configuration completed."
