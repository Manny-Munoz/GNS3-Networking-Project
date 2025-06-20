#!/bin/bash

source ./bash_utils.sh
require_root

# Detect OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    cecho "Could not detect operating system." "$RED"
    exit 1
fi

cecho "Detected distro: $DISTRO" "$GREEN"

establish_dhcp() {
cat <<EOF
subnet $SUBNET netmask $NETMASK {
    range $DHCP_START $DHCP_END;
    option routers $GATEWAY;
    option subnet-mask $NETMASK;
    option domain-name-servers $DNS;
    default-lease-time 600;
    max-lease-time 7200;
}
EOF
}

ip2int() {
    local IFS=.
    read -r i1 i2 i3 i4 <<< "$1"
    echo $(( (i1 * 16777216) + (i2 * 65536) + (i3 * 256) + i4 ))
}

int2ip() {
    local ip=$1
    local o1 o2 o3 o4
    o1=$(( (ip >> 24) & 255 ))
    o2=$(( (ip >> 16) & 255 ))
    o3=$(( (ip >> 8) & 255 ))
    o4=$(( ip & 255 ))
    echo "$o1.$o2.$o3.$o4"
}

ip_in_subnet() {
    local ip=$1
    local subnet=$2
    local mask=$3
    local ip_dec subnet_dec mask_dec

    ip_dec=$(ip2int "$ip")
    subnet_dec=$(ip2int "$subnet")
    mask_dec=$(ip2int "$mask")

    [[ $((ip_dec & mask_dec)) -eq $((subnet_dec & mask_dec)) ]]
}

IPprefix_by_netmask () { 
   c=0 x=0$( printf '%o' ${1//./ } )
   while [ $x -gt 0 ]; do
       let c+=$((x%2)) 'x>>=1'
   done
   echo $c ; 
}

# Ask user for required data
read -p "Interface name (e.g. ens3, eth0): " IFACE
read -p "Static IP address (e.g. 172.16.0.10): " ADDRESS
read -p "Netmask (e.g. 255.255.252.0): " NETMASK
read -p "Gateway (e.g. 172.16.0.1): " GATEWAY
read -p "DNS nameserver (e.g. 172.16.0.10): " DNS
read -p "DHCP Range start (e.g. 172.16.0.20): " DHCP_START
read -p "DHCP Range end (e.g. 172.16.0.100): " DHCP_END
read -p "Subnet (e.g. 172.16.0.0): " SUBNET


ADDR_INT=$(ip2int "$ADDRESS")
DHCP_START_INT=$(ip2int "$DHCP_START")
if (( ADDR_INT + 2 > DHCP_START_INT )); then
    cecho "❌ ERROR: The IP address should be at least 2 numbers less than the DHCP_Start." "$RED"
    exit 1
fi

# Create Samba IP address
SAMBA_ADDRESS=$(int2ip $((ADDR_INT + 1)))
cecho "Samba IP address will be: $SAMBA_ADDRESS" "$GREEN"


case "$DISTRO" in
debian | ubuntu)
    # Calculate subnet using ipcalc
    SUBNET=$(ipcalc -n "$ADDRESS" "$NETMASK" | grep Network | awk '{print $2}' | cut -d'/' -f1)
    #Validate DHCP range
    if ! ip_in_subnet "$DHCP_START" "$SUBNET" "$NETMASK" || ! ip_in_subnet "$DHCP_END" "$SUBNET" "$NETMASK"; then
    cecho "❌ ERROR: The DHCP range does not match the subnet $SUBNET/$NETMASK" "$RED"
    exit 1
    fi
    ;;
esac


case "$DISTRO" in

debian | ubuntu)
    cecho "Configuring network for Debian/Ubuntu..." "$GREEN"

    if [ -d /etc/netplan ]; then
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
      addresses: 
        - $ADDRESS/$(IPprefix_by_netmask "$NETMASK")
        - $SAMBA_ADDRESS/$(IPprefix_by_netmask "$NETMASK")
      routes: 
        - to: default
          via: $GATEWAY
      nameservers:
        addresses: 
            - $DNS
EOF

        cecho "Applying Netplan configuration..." "$GREEN"
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
    post-up ip addr add $SAMBA_ADDRESS/$(IPprefix_by_netmask "$NETMASK") dev $IFACE
EOF

        cecho "Restarting networking..." "$GREEN"
        systemctl restart networking
        systemctl status networking
    fi

    cecho "Configuring isc-dhcp-server..." "$GREEN"

    echo "INTERFACESv4=\"$IFACE\"" >/etc/default/isc-dhcp-server

    establish_dhcp > /etc/dhcp/dhcpd.conf

    systemctl restart isc-dhcp-server
    systemctl status isc-dhcp-server
    ;;
opensuse* | suse)
    cecho "Configuring network for openSUSE..." "$GREEN"

CONFIG_FILE="/etc/sysconfig/network/ifcfg-$IFACE"

cat <<EOF >$CONFIG_FILE
BOOTPROTO='static'
STARTMODE='auto'
IPADDR='$ADDRESS'
NETMASK='$NETMASK'
GATEWAY='$GATEWAY'
IPADDR_2='$SAMBA_ADDRESS'
NETMASK_2='$NETMASK'
EOF

    if ! grep -q "$DNS" /etc/resolv.conf; then
    echo "nameserver $DNS" > /etc/resolv.conf
    fi


    establish_dhcp > /etc/dhcpd.conf

    echo "DHCPD_INTERFACE=\"$IFACE\"" >>/etc/sysconfig/dhcpd

    systemctl enable dhcpd
    systemctl restart wicked
    systemctl restart dhcpd
    systemctl status dhcpd
    ;;

rocky | centos | rhel)
    cecho "Configuring network for Rocky Linux/CentOS/RHEL..." "$GREEN"

    CONFIG_FILE="/etc/sysconfig/network-scripts/ifcfg-$IFACE"
    
cat <<EOF >$CONFIG_FILE
DEVICE=$IFACE
BOOTPROTO=static
ONBOOT=yes
IPADDR=$ADDRESS
NETMASK=$NETMASK
GATEWAY=$GATEWAY
DNS1=$DNS
IPADDR2=$SAMBA_ADDRESS
NETMASK2=$NETMASK
EOF

    echo "nameserver $DNS" >/etc/resolv.conf

    establish_dhcp > /etc/dhcp/dhcpd.conf

    systemctl enable dhcpd

    # Delete existing connection 
    nmcli connection delete "$IFACE"

    # Create new connection
    nmcli connection add type ethernet ifname "$IFACE" con-name "$IFACE" ip4 "$ADDRESS/$(IPprefix_by_netmask "$NETMASK")" gw4 "$GATEWAY"
    nmcli connection modify "$IFACE" ipv4.dns "$DNS"
    nmcli connection modify "$IFACE" ipv4.method manual
    nmcli connection up "$IFACE"

    sleep 2
    ip a show "$IFACE"

    systemctl restart dhcpd
    systemctl status dhcpd

*)
    cecho "Distribution not supported yet: $DISTRO" "$RED"
    exit 1
    ;;
esac

cecho "✅ Network and DHCP configuration completed." "$GREEN"