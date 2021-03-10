#!/bin/bash

# Modify default IP and remove the 2nd port from lan brige
sed -i 's/192.168.1.1/192.168.1.254/g' package/base-files/files/bin/config_generate >/dev/null 2>&1
sed -i '/for key in $keys; do generate_switch $key; done/a\\n        uci set network.@switch_vlan[0].ports="3 6t"' package/base-files/files/bin/config_generate >/dev/null 2>&1

# Turn off uhttpd redirect_https by default
sed -i 's/redirect_https	1/redirect_https	0/' package/network/services/uhttpd/files/uhttpd.config >/dev/null 2>&1

# Turn on wifi by default and use the name "TestWrt/TestWrt-5G" for ssid
sed -i '/set wireless.radio${devidx}.disabled=1/d' package/kernel/mac80211/files/lib/wifi/mac80211.sh >/dev/null 2>&1
sed -i '/uci -q batch <<-EOF/i\                ssid_name="TestWrt"\n                [ $mode_band = "a" ] && ssid_name="TestWrt-5G"' package/kernel/mac80211/files/lib/wifi/mac80211.sh >/dev/null 2>&1
sed -i 's/ssid=OpenWrt/ssid=${ssid_name}/' package/kernel/mac80211/files/lib/wifi/mac80211.sh >/dev/null 2>&1
#sed -i '/config dhcp lan/a\        option force 1' package/network/services/dnsmasq/files/dhcp.conf >/dev/null 2>&1

# Add other package
git clone https://github.com/openwrt/packages.git -b openwrt-21.02 $GITHUB_WORKSPACE/other_packages
rm -rf feeds/packages/lang/golang/
mv $GITHUB_WORKSPACE/other_packages/lang/golang/ feeds/packages/lang/
mv -f $GITHUB_WORKSPACE/other_packages/net/xray-core/ package/network/
sed -i 's/..\/..\/lang\/golang\/golang-package.mk/..\/..\/..\/feeds\/packages\/lang\/golang\/golang-package.mk/' package/network/xray-core/Makefile
#sed -i '/CATEGORY:=Network/a\  USERID:=xray=6666:xray=6666' package/network/xray-core/Makefile
sed -i '/DEPENDS:=$(GO_ARCH_DEPENDS) +ca-bundle/a\        +@KERNEL_NAMESPACES +procd-ujail' package/network/xray-core/Makefile
sed -i 's/DEPENDS:=$(GO_ARCH_DEPENDS) +ca-bundle/DEPENDS:=$(GO_ARCH_DEPENDS) +ca-bundle \\/' package/network/xray-core/Makefile
sed -i 's/202102250625/202103080146/' package/network/xray-core/Makefile
sed -i 's/ee41b3c624e27a47b611d7cbee9da605fb9cda7c23bec1326969eb137ca6ebe7/85a3fef921cca17ac7eea4379e643258d8b8ea7dbba52a0b97ac63dc5df995e3/' package/network/xray-core/Makefile
sed -i 's/20210226210728/20210308021214/' package/network/xray-core/Makefile
sed -i 's/ef9c30bacc6989a0b9fae6043dcef1ec15af96c01eddfa1f1d1ad93d14864f81/7a88dafe9ce0299742c2a8e30b42eb0433fc31ceb87ed2fb1356b64ff941e7ba/' package/network/xray-core/Makefile
sed -i 's/procd_set_param user nobody/procd_set_param user xray/' package/network/xray-core/files/xray.init
echo "xray:*:6666:6666:xray:/var/run/xray:/bin/false" >> package/base-files/files/etc/passwd
echo "xray:x:6666:xray" >> package/base-files/files/etc/group
echo "xray:*:0:0:99999:7:::" >> package/base-files/files/etc/shadow
rm -rf $GITHUB_WORKSPACE/other_packages

# Fix some packages
#find package/*/ feeds/*/ -maxdepth 2 -path "*luci-app-bypass/Makefile" | xargs -i sed -i 's/shadowsocksr-libev-ssr-redir/shadowsocksr-libev-alt/g' {}
#find package/*/ feeds/*/ -maxdepth 2 -path "*luci-app-bypass/Makefile" | xargs -i sed -i 's/shadowsocksr-libev-ssr-server/shadowsocksr-libev-server/g' {}
