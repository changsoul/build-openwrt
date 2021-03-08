#!/bin/bash

# Modify default IP
sed -i 's/192.168.1.1/192.168.1.254/g' package/base-files/files/bin/config_generate >/dev/null 2>&1

# Turn off uhttpd redirect_https by default
sed -i 's/redirect_https	1/redirect_https	0/' package/network/services/uhttpd/files/uhttpd.config >/dev/null 2>&1

# Turn on wifi by default
sed -i '/set wireless.radio${devidx}.disabled=1/d' package/kernel/mac80211/files/lib/wifi/mac80211.sh >/dev/null 2>&1
sed -i 's/ssid=OpenWrt/ssid=TestWrt-${devidx}/' package/kernel/mac80211/files/lib/wifi/mac80211.sh >/dev/null 2>&1

# Add other package
git clone https://github.com/openwrt/packages.git -b openwrt-21.02 $GITHUB_WORKSPACE/other_packages
rm -rf feeds/packages/lang/golang/
mv $GITHUB_WORKSPACE/other_packages/lang/golang/ feeds/packages/lang/
mv -f $GITHUB_WORKSPACE/other_packages/net/xray-core/ package/network/
sed -i 's/..\/..\/lang\/golang\/golang-package.mk/..\/..\/..\/feeds\/packages\/lang\/golang\/golang-package.mk/' package/network/xray-core/Makefile
rm -rf $GITHUB_WORKSPACE/other_packages

# Fix some packages
#find package/*/ feeds/*/ -maxdepth 2 -path "*luci-app-bypass/Makefile" | xargs -i sed -i 's/shadowsocksr-libev-ssr-redir/shadowsocksr-libev-alt/g' {}
#find package/*/ feeds/*/ -maxdepth 2 -path "*luci-app-bypass/Makefile" | xargs -i sed -i 's/shadowsocksr-libev-ssr-server/shadowsocksr-libev-server/g' {}
