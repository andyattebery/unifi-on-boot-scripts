#!/bin/bash

# Set this to your netboot.xyz server IP
NETBOOTXYZ_SERVER_IP="192.168.1.232"

cat << EOF > /run/dnsmasq.conf.d/dhcp.netbootxyz.conf
# Configures netboot.xyz PXE boot

# -U, --dhcp-vendorclass=set:<tag>,[enterprise:<IANA-enterprise number>,]<vendor-class>
# Map from a vendor-class string to a tag. Most DHCP clients provide a "vendor class" which represents, in some sense, the type of host. This option maps vendor classes to tags, so that DHCP options may be selectively delivered to different classes of hosts. For example --dhcp-vendorclass=set:printers,Hewlett-Packard JetDirect will allow options to be set only for HP printers like so: --dhcp-option=tag:printers,3,192.168.4.4 The vendor-class string is substring matched against the vendor-class supplied by the client, to allow fuzzy matching. The set: prefix is optional but allowed for consistency.
# Note that in IPv6 only, vendorclasses are namespaced with an IANA-allocated enterprise number. This is given with enterprise: keyword and specifies that only vendorclasses matching the specified number should be searched.
# Architecture numbers from: https://www.iana.org/assignments/dhcpv6-parameters/dhcpv6-parameters.xhtml#processor-architecture

# x86 BIOS
dhcp-vendorclass=set:bios,PXEClient:Arch:00000
# x86 UEFI
dhcp-vendorclass=set:uefi_x86,PXEClient:Arch:00006
# x64 UEFI
dhcp-vendorclass=set:uefi_x64,PXEClient:Arch:00007
# EBC
dhcp-vendorclass=set:uefi_x64,PXEClient:Arch:00009
# ARM 32-bit UEFI
dhcp-vendorclass=set:uefi_arm32,PXEClient:Arch:00010
# ARM 64-bit UEFI
dhcp-vendorclass=set:uefi_arm64,PXEClient:Arch:00011

# -M, --dhcp-boot=[tag:<tag>,]<filename>,[<servername>[,<server address>|<tftp_servername>]]
# (IPv4 only) Set BOOTP options to be returned by the DHCP server. Server name and address are optional: if not provided, the name is left empty, and the address set to the address of the machine running dnsmasq. If dnsmasq is providing a TFTP service (see --enable-tftp ) then only the filename is required here to enable network booting. If the optional tag(s) are given, they must match for this configuration to be sent. Instead of an IP address, the TFTP server address can be given as a domain name which is looked up in /etc/hosts. This name can be associated in /etc/hosts with multiple IP addresses, which are used round-robin. This facility can be used to load balance the tftp load among a set of servers.
# dhcp-boot=tag:<tag>,<boot_image_file>,<servername>,<tftp_server_ip>
dhcp-boot=tag:bios,netboot.xyz.kpxe,netboot.xyz,$NETBOOTXYZ_SERVER_IP
dhcp-boot=tag:uefi_x86,netboot.xyz.efi,netboot.xyz,$NETBOOTXYZ_SERVER_IP
dhcp-boot=tag:uefi_x64,netboot.xyz.efi,netboot.xyz,$NETBOOTXYZ_SERVER_IP
dhcp-boot=tag:uefi_arm32,netboot.xyz-arm64.efi,netboot.xyz,$NETBOOTXYZ_SERVER_IP
dhcp-boot=tag:uefi_arm64,netboot.xyz-arm64.efi,netboot.xyz,$NETBOOTXYZ_SERVER_IP
EOF

# Restart dnsmasq
kill `cat /run/dnsmasq.pid`
