#!/bin/bash

# autoprovision stage 2: this script will be executed upon boot if the extroot was successfully mounted (i.e. rc.local is run from the extroot overlay)

. /etc/auto-provision/autoprovision-functions.sh

# Command to check if a command ran successfully
check_run() {
    if eval "$@"; then
        return 0  # Command ran successfully, return true
    else
        return 1  # Command failed to run, return false
    fi
}

# Log to the system log and echo if needed
log_say()
{
    SCRIPT_NAME=$(basename "$0")
    echo "${SCRIPT_NAME}: ${1}"
    logger "${SCRIPT_NAME}: ${1}"
}

# Command to wait for Internet connection
wait_for_internet() {
    while ! ping -q -c3 1.1.1.1 >/dev/null 2>&1; do
        log_say "Waiting for Internet connection..."
        sleep 1
    done
    log_say "Internet connection established"
}

# Command to wait for opkg to finish
wait_for_opkg() {
  while pgrep -x opkg >/dev/null; do
    log_say "Waiting for opkg to finish..."
    sleep 1
  done
  log_say "opkg is released, our turn!"
}

installPackages()
{
    signalAutoprovisionWaitingForUser

    until (opkg update)
    do
        log_say "opkg update failed. No internet connection? Retrying in 15 seconds..."
        sleep 15
    done

    signalAutoprovisionWorking

    log_say "Autoprovisioning stage2 is about to install packages"

    # CUSTOMIZE
    # install some more packages that don't need any extra steps
    log_say "updating all packages!"

    log_say "                                                                      "
    log_say " ███████████             ███                         █████            "
    log_say "░░███░░░░░███           ░░░                         ░░███             "
    log_say " ░███    ░███ ████████  ████  █████ █████  ██████   ███████    ██████ "
    log_say " ░██████████ ░░███░░███░░███ ░░███ ░░███  ░░░░░███ ░░░███░    ███░░███"
    log_say " ░███░░░░░░   ░███ ░░░  ░███  ░███  ░███   ███████   ░███    ░███████ "
    log_say " ░███         ░███      ░███  ░░███ ███   ███░░███   ░███ ███░███░░░  "
    log_say " █████        █████     █████  ░░█████   ░░████████  ░░█████ ░░██████ "
    log_say "░░░░░        ░░░░░     ░░░░░    ░░░░░     ░░░░░░░░    ░░░░░   ░░░░░░  "
    log_say "                                                                      "
    log_say "                                                                      "
    log_say " ███████████                        █████                             "
    log_say "░░███░░░░░███                      ░░███                              "
    log_say " ░███    ░███   ██████  █████ ████ ███████    ██████  ████████        "
    log_say " ░██████████   ███░░███░░███ ░███ ░░░███░    ███░░███░░███░░███       "
    log_say " ░███░░░░░███ ░███ ░███ ░███ ░███   ░███    ░███████  ░███ ░░░        "
    log_say " ░███    ░███ ░███ ░███ ░███ ░███   ░███ ███░███░░░   ░███            "
    log_say " █████   █████░░██████  ░░████████  ░░█████ ░░██████  █████           "
    log_say "░░░░░   ░░░░░  ░░░░░░    ░░░░░░░░    ░░░░░   ░░░░░░  ░░░░░            "

    # Keep trying to run opkg update until it succeeds
    while ! check_run "opkg update"; do
        log_say "\"opkg update\" failed. Retrying in 15 seconds..."
        sleep 15
    done
    
    # List of our packages to install
    local PACKAGE_LIST="adblock attr avahi-dbus-daemon base-files busybox ca-bundle cgi-io coreutils coreutils-sort dbus dnsmasq dropbear firewall4 fstools fwtool getrandom hostapd-common iw iwinfo jansson4 jshn jsonfilter kernel kmod-cfg80211 kmod-crypto-aead kmod-crypto-ccm kmod-crypto-cmac kmod-crypto-crc32c kmod-crypto-ctr kmod-crypto-gcm kmod-crypto-gf128 kmod-crypto-ghash kmod-crypto-hash kmod-crypto-hmac kmod-crypto-kpp kmod-crypto-lib-chacha20 kmod-crypto-lib-chacha20poly1305 kmod-crypto-lib-curve25519 kmod-crypto-lib-poly1305 kmod-crypto-manager kmod-crypto-null kmod-crypto-rng kmod-crypto-seqiv kmod-crypto-sha256 kmod-gpio-button-hotplug kmod-hwmon-core kmod-leds-gpio kmod-lib-crc-ccitt kmod-lib-crc32c kmod-mac80211 kmod-mt76-connac kmod-mt76-core kmod-mt7615-common kmod-mt7615-firmware kmod-mt7615e kmod-mt7915e kmod-nf-conntrack kmod-nf-conntrack6 kmod-nf-flow kmod-nf-log kmod-nf-log6 kmod-nf-nat kmod-nf-reject kmod-nf-reject6 kmod-nfnetlink kmod-nft-core kmod-nft-fib kmod-nft-nat kmod-nft-offload kmod-nls-base kmod-ppp kmod-pppoe kmod-pppox kmod-slhc kmod-thermal kmod-tun kmod-udptunnel4 kmod-udptunnel6 kmod-usb-core kmod-usb-xhci-hcd kmod-usb3 kmod-wireguard libatomic1 libattr libavahi-client libavahi-dbus-support libblobmsg-json20220515 libbz2-1.0 libc libcap libdaemon libdbus libexif libexpat libffmpeg-mini libflac libgcc1 libgmp10 libgnutls libid3tag libiwinfo-data libiwinfo-lua libiwinfo20210430 libjpeg-turbo libjson-c5 libjson-script20220515 liblua5.1.5 liblucihttp-lua liblucihttp0 liblzo2 libmnl0 libncurses6 libnettle8 libnftnl11 libnl-tiny1 libogg0 libopenssl1.1 libpam libpopt0 libpthread libreadline8 librt libsqlite3-0 libtasn1 libtirpc libubox20220515 libubus-lua libubus20220601 libuci20130104 libuclient20201210 libucode20220812 liburing libustream-wolfssl20201210 libuuid1 libvorbis libwolfssl5.5.4.ee39414e logd lua luci luci-app-adblock luci-app-firewall luci-app-minidlna luci-app-openvpn luci-app-opkg luci-app-samba4 luci-base luci-compat luci-lib-base luci-lib-ip luci-lib-jsonc luci-lib-nixio luci-mod-admin-full luci-mod-network luci-mod-status luci-mod-system luci-proto-ipv6 luci-proto-ppp luci-ssl luci-theme-bootstrap minidlna mtd netifd nftables-json odhcp6c odhcpd-ipv6only openvpn-openssl openwrt-keyring opkg ppp ppp-mod-pppoe procd procd-seccomp procd-ujail px5g-wolfssl rpcd rpcd-mod-file rpcd-mod-iwinfo rpcd-mod-luci rpcd-mod-rrdns samba4-libs samba4-server terminfo ubi-utils uboot-envtools ubox ubus ubusd uci uclient-fetch ucode ucode-mod-fs ucode-mod-ubus ucode-mod-uci uhttpd uhttpd-mod-ubus urandom-seed urngd usign wireguard-tools wireless-regdb wpad-basic-wolfssl zlib firewall ip6tables iptables kmod-ath kmod-ath9k kmod-ath9k-common kmod-ip6tables kmod-ipt-conntrack kmod-ipt-core kmod-ipt-nat kmod-ipt-offload kmod-nf-ipt kmod-nf-ipt6 kmod-usb-ehci libblobmsg-json20210516 libip4tc2 libip6tc2 libjson-script20210516 libubox20210516 libubus20210630 git git-http jq libxtables12 luci-app-statistics luci-mod-dashboard luci-app-vnstat luci-app-wireguard kmod-usb-storage block-mount kmod-fs-ext4 kmod-fs-exfat fdisk luci-lib-ipkg kmod-rt2800-usb rt2800-usb-firmware kmod-lib80211 kmod-rtl8192cu kmod-usb-ohci kmod-usb-uhci e2fsprogs resize2fs htop debootstrap bash wget kmod-usb-net-rndis luci-app-commands kmod-usb-net-cdc-eem kmod-usb-net-cdc-ether kmod-usb-net-cdc-subset kmod-usb-net kmod-usb2 kmod-usb-net-ipheth libimobiledevice luci-app-nlbwmon nano ttyd fail2ban speedtest-netperf vsftpd usbmuxd usbutils"

    count=$(echo "$PACKAGE_LIST" | wc -w)
    log_say "Packages to install: ${count}"

    # Convert the object list to an array
    IFS=' ' read -r -a objects <<< "$PACKAGE_LIST"

    # Loop until the object_list array is empty
    while [[ ${#objects[@]} -gt 0 ]]; do
        # Get a slice of 10 objects or the remaining objects if less than 10
        slice=("${objects[@]:0:10}")

        # Remove the echoed objects from the list
        objects=("${objects[@]:10}")

        # Join the slice into a single line with spaces
        line=$(printf "%s " "${slice[@]}")

        # Remove leading/trailing whitespaces
        line=$(echo "$line" | xargs)

        # opkg install the 10 packages
        eval "opkg install $line"
    done

   ## We have to remove dnsmasq (which is required to be installed on build) and install dnsmasq-full
   opkg remove dnsmasq
   # Get rid of the old dhcp config
   [ -f /etc/config/dhcp ] && rm /etc/config/dhcp
   # Install the dnsmasq-full package since we want that
   opkg install dnsmasq-full
   # Move the default dhcp config to the right place
   [ -f /etc/config/dhcp ] && mv /etc/config/dhcp /etc/config/dhcp.orig
   # Put our pre-configured config in its place
   [[ -f /etc/config/dhcp.pr && ! -f /etc/config/dhcp ]] && cp /etc/config/dhcp.pr /etc/config/dhcp

}

autoprovisionStage2()
{
    log_say "Autoprovisioning stage2 speaking"

    signalAutoprovisionWorking

    # CUSTOMIZE: with an empty argument it will set a random password and only ssh key based login will work.
    # please note that stage2 requires internet connection to install packages and you most probably want to log_say in
    # on the GUI to set up a WAN connection. but on the other hand you don't want to end up using a publically
    # available default password anywhere, therefore the random here...
    setRootPassword "torguard"

    installPackages

    chmod +x ${overlay_root}/etc/rc.local
    cat >${overlay_root}/etc/rc.local <<EOF
chmod a+x /etc/stage3.sh
{ bash /etc/stage3.sh; } && exit 0 || { log "** PRIVATEROUTER ERROR **: stage3.sh failed - rebooting in 30 seconds"; sleep 30; reboot; }
EOF

}

# Fix our DNS and update packages and do not check https certs
fixPackagesDNS()
{
    log_say "Fixing DNS (if needed) and installing required packages for opkg"

    # Domain to check
    domain="privaterouter.com"

    # DNS server to set if domain resolution fails
    dns_server="1.1.1.1"

    # Perform the DNS resolution check
    if ! nslookup "$domain" >/dev/null 2>&1; then
        log_say "Domain resolution failed. Setting DNS server to $dns_server."

        # Update resolv.conf with the new DNS server
        echo "nameserver $dns_server" > /etc/resolv.conf
    else
        log_say "Domain resolution successful."
    fi

    log_say "Installing opkg packages"
    opkg update --no-check-certificate
    opkg install --no-check-certificate wget-ssl unzip ca-bundle ca-certificates git git-http jq curl bash nano ntpdate

    # Set the time to fix ssl cert issues
    ntpdate -q 0.openwrt.pool.ntp.org
}

# Wait for Internet connection
wait_for_internet

# Wait for opkg to finish
wait_for_opkg

# Fix our DNS Server and install some required packages
fixPackagesDNS

autoprovisionStage2

reboot
