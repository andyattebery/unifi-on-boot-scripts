# Unifi On Boot Scripts

## Unifi On Boot Script

This enables persistent scripts on Unifi gateways that run on boot.

It will run executable (`chmod +x`) scripts that end in `.sh` which are in `/data/on_boot.d`.

### Installation

1. [Enable ssh for UnifiOS](https://help.ui.com/hc/en-us/articles/204909374-UniFi-Connect-with-SSH-Advanced-)
    - For the UDMP, the username is `root`
2. [Install the Unifi On Boot Script](https://github.com/unifi-utilities/unifios-utilities/blob/main/on-boot-script/README.md)
    - The "magic" install script has different installation methods for different Unifi devices.
    - For the UDMP, it installs a systemd service (which is a different method than the _Manual Install Steps_ in the README).

## dnsmasq netboot.xyz Script

This configures the Unifi DHCP server for PXE booting from a local [netboot.xyz](netboot.xyz) installation.

The built-in Unifi DCHP server is dnsmasq and is configured to read configuration files from `/run/dnsmasq.conf.d/`. However, this is mounted on tmpfs and is therefore wiped on reboot. So the `10-dnsmasq-netbootxyz.sh` script creates a configuration file — `dhcp.netbootxyz.conf` — on boot.

 The `dhcp.netbootxyz.conf` configuration uses the `dhcp-boot` parameter to configure [DHCP option 66 (TFPT server) and DHCP option 67 (boot file)](https://www.rfc-editor.org/rfc/rfc2132.html). It also handles different architectures (i.e. BIOS, UEFI x64, UEFI arm64, etc) which need specific boot files using the `dhcp-vendorclass` parameter to set different tags to be matched by specific `dhcp-boot` parameters.

### Installation

1. Set the `NETBOOTXYZ_SERVER_IP` variable at the top of the `10-dnsmasq-netbootxyz.sh` file to your netboot.xyz server IP.
2. Copy the `10-dnsmasq-netbootxyz.sh` file to your Unifi gateway's Unifi On Boot directory (`/data/on_boot.d`).
    - `scp 10-dnsmasq-netbootxyz.sh root@<unifi-ip>:/data/on_boot.d`
3. Restart the udm-boot.service to run the script.
    - `systemctl restart udm-boot.service`

## References
- https://technotim.live/posts/netbootxyz-tutorial/#dhcp-configuration
- https://docs.linuxserver.io/images/docker-netbootxyz/?h=netboo#router-setup-examples
- https://community.ui.com/questions/PXE-Network-boot-UDM-SE-Serving-files-conditionally-based-on-architecture/1843fcf6-87d5-4305-bc1d-4e55619ebb10