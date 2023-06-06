#!/bin/sh

# autoprovision stage 2: this script will be executed upon boot if the extroot was successfully mounted (i.e. rc.local is run from the extroot overlay)

. /etc/auto-provision/autoprovision-functions.sh

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

   opkg update
   
   #Go Go Packages
   opkg install adblock attr avahi-dbus-daemon base-files busybox ca-bundle cgi-io coreutils coreutils-sort dbus dnsmasq dropbear firewall4 fstools fwtool getrandom hostapd-common iw iwinfo jansson4
   opkg install jshn jsonfilter kernel kmod-cfg80211 kmod-crypto-aead kmod-crypto-ccm kmod-crypto-cmac kmod-crypto-crc32c kmod-crypto-ctr kmod-crypto-gcm kmod-crypto-gf128 kmod-crypto-ghash kmod-crypto-hash
  opkg install kmod-crypto-hmac kmod-crypto-kpp kmod-crypto-lib-chacha20 kmod-crypto-lib-chacha20poly1305 kmod-crypto-lib-curve25519 kmod-crypto-lib-poly1305 kmod-crypto-manager kmod-crypto-null kmod-crypto-rng
  opkg install kmod-crypto-seqiv kmod-crypto-sha256 kmod-gpio-button-hotplug kmod-hwmon-core kmod-leds-gpio kmod-lib-crc-ccitt kmod-lib-crc32c kmod-mac80211 kmod-mt76-connac kmod-mt76-core kmod-mt7615-common
  opkg install kmod-mt7615-firmware kmod-mt7615e kmod-mt7915e kmod-nf-conntrack kmod-nf-conntrack6 kmod-nf-flow kmod-nf-log kmod-nf-log6 kmod-nf-nat kmod-nf-reject kmod-nf-reject6 kmod-nfnetlink kmod-nft-core
  opkg install kmod-nft-fib kmod-nft-nat kmod-nft-offload kmod-nls-base kmod-ppp kmod-pppoe kmod-pppox kmod-slhc kmod-thermal kmod-tun kmod-udptunnel4 kmod-udptunnel6 kmod-usb-core kmod-usb-xhci-hcd kmod-usb3
  opkg install kmod-wireguard libatomic1 libattr libavahi-client libavahi-dbus-support libblobmsg-json20220515 libbz2-1.0 libc libcap libdaemon libdbus libexif libexpat libffmpeg-mini libflac libgcc1 libgmp10
  opkg install libgnutls libid3tag libiwinfo-data libiwinfo-lua libiwinfo20210430 libjpeg-turbo libjson-c5 libjson-script20220515 liblua5.1.5 liblucihttp-lua liblucihttp0 liblzo2 libmnl0 libncurses6 libnettle8
  opkg install libnftnl11 libnl-tiny1 libogg0 libopenssl1.1 libpam libpopt0 libpthread libreadline8 librt libsqlite3-0 libtasn1 libtirpc libubox20220515 libubus-lua libubus20220601 libuci20130104 libuclient20201210
  opkg install libucode20220812 liburing libustream-wolfssl20201210 libuuid1 libvorbis libwolfssl5.5.4.ee39414e logd lua luci luci-app-adblock luci-app-firewall luci-app-minidlna luci-app-openvpn luci-app-opkg
  opkg install luci-app-samba4 luci-base luci-compat luci-lib-base luci-lib-ip luci-lib-jsonc luci-lib-nixio luci-mod-admin-full luci-mod-network luci-mod-status luci-mod-system luci-proto-ipv6 luci-proto-ppp
  opkg install luci-ssl luci-theme-bootstrap minidlna mtd netifd nftables-json odhcp6c odhcpd-ipv6only openvpn-openssl openwrt-keyring opkg ppp ppp-mod-pppoe procd procd-seccomp procd-ujail px5g-wolfssl rpcd
  opkg install rpcd-mod-file rpcd-mod-iwinfo rpcd-mod-luci rpcd-mod-rrdns samba4-libs samba4-server terminfo ubi-utils uboot-envtools ubox ubus ubusd uci uclient-fetch ucode ucode-mod-fs ucode-mod-ubus ucode-mod-uci
  opkg install uhttpd uhttpd-mod-ubus urandom-seed urngd usign wireguard-tools wireless-regdb wpad-basic-wolfssl zlib
  opkg install base-files busybox ca-bundle cgi-io dnsmasq dropbear firewall fstools fwtool getrandom hostapd-common ip6tables iptables iw iwinfo jshn jsonfilter kernel samba4-server luci-app-samba4 minidlna luci-app-minidlna
  opkg install kmod-ath kmod-ath9k kmod-ath9k-common kmod-cfg80211 kmod-gpio-button-hotplug kmod-ip6tables kmod-ipt-conntrack kmod-ipt-core kmod-ipt-nat kmod-ipt-offload
  opkg install kmod-lib-crc-ccitt kmod-mac80211 kmod-nf-conntrack kmod-nf-conntrack6 kmod-nf-flow kmod-nf-ipt kmod-nf-ipt6 kmod-nf-nat kmod-nf-reject kmod-nf-reject6 kmod-nls-base
  opkg install kmod-ppp kmod-pppoe kmod-pppox kmod-slhc kmod-usb-core kmod-usb-ehci libblobmsg-json20210516 libc libgcc1 libip4tc2 libip6tc2 libiwinfo-data libiwinfo-lua libiwinfo20210430
  opkg install libjson-c5 libjson-script20210516 liblua5.1.5 liblucihttp-lua liblucihttp0 libnl-tiny1 libpthread libubox20210516 libubus-lua libubus20210630 libuci20130104  git git-http jq
  opkg install libuclient20201210 libustream-wolfssl20201210 libxtables12 logd lua luci luci-app-firewall luci-app-opkg luci-base luci-lib-base luci-lib-ip luci-lib-jsonc luci-lib-nixio
  opkg install luci-mod-admin-full luci-mod-network luci-mod-status luci-mod-system
  opkg install luci-proto-ipv6 luci-proto-ppp luci-ssl luci-theme-bootstrap luci-app-statistics luci-mod-dashboard luci-app-vnstat
  opkg install luci-app-openvpn wireguard-tools luci-app-wireguard minidlna openvpn-openssl mtd netifd odhcp6c odhcpd-ipv6only openwrt-keyring opkg ppp ppp-mod-pppoe procd px5g-wolfssl
  opkg install openwrt-keyring ppp ppp-mod-pppoe procd px5g-wolfssl kmod-usb-storage block-mount luci-app-minidlna kmod-fs-ext4 kmod-fs-exfat fdisk luci-compat luci-lib-ipkg
   opkg install base-files busybox cgi-io dropbear firewall fstools fwtool getrandom hostapd-common ip6tables iptables iw iwinfo jshn jsonfilter kernel
   opkg install kmod-ath kmod-ath9k kmod-ath9k-common kmod-cfg80211 kmod-gpio-button-hotplug kmod-ip6tables kmod-ipt-conntrack kmod-ipt-core kmod-ipt-nat kmod-ipt-offload
   opkg install kmod-lib-crc-ccitt kmod-mac80211 kmod-nf-conntrack kmod-nf-conntrack6 kmod-nf-flow kmod-nf-ipt kmod-nf-ipt6 kmod-nf-nat kmod-nf-reject kmod-nf-reject6 kmod-nls-base
   opkg install kmod-ppp kmod-pppoe kmod-pppox kmod-slhc kmod-usb-core kmod-usb-ehci libblobmsg-json20210516 libc libgcc1 libip4tc2 libip6tc2 libiwinfo-data libiwinfo-lua libiwinfo20210430
   opkg install libjson-c5 libjson-script20210516 liblua5.1.5 liblucihttp-lua liblucihttp0 libnl-tiny1 libpthread libubox20210516 libubus-lua libubus20210630 libuci20130104
   opkg install libuclient20201210 libustream-wolfssl20201210 libxtables12 logd lua luci luci-app-firewall luci-app-opkg luci-base luci-lib-base luci-lib-ip luci-lib-jsonc luci-lib-nixio
   opkg install luci-mod-admin-full luci-mod-network luci-mod-status luci-mod-system
   opkg install luci-proto-ipv6 luci-proto-ppp luci-ssl luci-theme-bootstrap luci-app-statistics luci-mod-dashboard luci-app-vnstat
   opkg install luci-app-openvpn wireguard-tools luci-app-wireguard openvpn-openssl mtd netifd odhcp6c odhcpd-ipv6only openwrt-keyring opkg ppp ppp-mod-pppoe procd px5g-wolfssl
   opkg install openwrt-keyring ppp ppp-mod-pppoe procd px5g-wolfssl kmod-usb-storage block-mount kmod-fs-ext4 kmod-fs-exfat luci-compat luci-lib-ipkg
   opkg install kmod-rt2800-usb rt2800-usb-firmware kmod-cfg80211 kmod-lib80211 kmod-mac80211 kmod-rtl8192cu luci-base luci-ssl 
   opkg install luci-theme-bootstrap kmod-usb-storage kmod-usb-ohci kmod-usb-uhci e2fsprogs fdisk resize2fs htop debootstrap luci-compat luci-lib-ipkg
   opkg install bash wget kmod-usb-net-rndis luci-app-commands rpcd-mod-luci kmod-usb-net-cdc-eem
   opkg install kmod-usb-net-cdc-ether kmod-usb-net-cdc-subset kmod-nls-base kmod-usb-core kmod-usb-net kmod-usb-net-cdc-ether kmod-usb2 kmod-usb-net-ipheth libimobiledevice luci-app-nlbwmon luci-app-adblock
   opkg install nano ttyd fail2ban speedtest-netperf 
   opkg install vsftpd samba4-server luci-app-samba4
   opkg install usbmuxd usbutils 

   ## Remove DNSMasq
   opkg remove dnsmasq
   rm /etc/config/dhcp
   opkg install dnsmasq-full

   log_say "PrivateRouter update complete!"
}

autoprovisionStage2()
{
    log "Autoprovisioning stage2 speaking"

    signalAutoprovisionWorking

    # CUSTOMIZE: with an empty argument it will set a random password and only ssh key based login will work.
    # please note that stage2 requires internet connection to install packages and you most probably want to log in
    # on the GUI to set up a WAN connection. but on the other hand you don't want to end up using a publically
    # available default password anywhere, therefore the random here...
    #setRootPassword ""

    installPackages

    chmod +x ${overlay_root}/etc/rc.local
    cat >${overlay_root}/etc/rc.local <<EOF
    chmod a+x /etc/stage3.sh
    bash /etc/stage3.sh || exit 1
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

    log_say "Updating system time using ntp; otherwise the openwrt.org certificates are rejected as not yet valid."
    ntpd -d -q -n -p 0.openwrt.pool.ntp.org

    log_say "Installing opkg packages"
    opkg update
    opkg install wget-ssl unzip ca-bundle ca-certificates
    opkg install git git-http jq curl bash nano
}

# Wait for Internet connection
wait_for_internet

# Wait for opkg to finish
wait_for_opkg

# Fix our DNS Server and install some required packages
fixPackagesDNS

autoprovisionStage2

reboot
