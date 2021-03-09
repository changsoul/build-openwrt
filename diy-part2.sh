#!/bin/bash

# Modify default IP
sed -i 's/192.168.1.1/192.168.1.254/g' package/base-files/files/bin/config_generate >/dev/null 2>&1

# Turn off uhttpd redirect_https by default
sed -i 's/redirect_https	1/redirect_https	0/' package/network/services/uhttpd/files/uhttpd.config >/dev/null 2>&1

# Turn on wifi by default
sed -i '/set wireless.radio${devidx}.disabled=1/d' package/kernel/mac80211/files/lib/wifi/mac80211.sh >/dev/null 2>&1
sed -i 's/ssid=OpenWrt/ssid=TestWrt-${devidx}/' package/kernel/mac80211/files/lib/wifi/mac80211.sh >/dev/null 2>&1
sed -i '/config dhcp lan/a\        option force 1/' package/network/services/dnsmasq/files/dhcp.conf >/dev/null 2>&1

# Add other package
git clone https://github.com/openwrt/packages.git -b openwrt-21.02 $GITHUB_WORKSPACE/other_packages
rm -rf feeds/packages/lang/golang/
mv $GITHUB_WORKSPACE/other_packages/lang/golang/ feeds/packages/lang/
mv -f $GITHUB_WORKSPACE/other_packages/net/xray-core/ package/network/
sed -i 's/..\/..\/lang\/golang\/golang-package.mk/..\/..\/..\/feeds\/packages\/lang\/golang\/golang-package.mk/' package/network/xray-core/Makefile
sed -i 's/202102250625/202103080146/' package/network/xray-core/Makefile
sed -i 's/ee41b3c624e27a47b611d7cbee9da605fb9cda7c23bec1326969eb137ca6ebe7/85a3fef921cca17ac7eea4379e643258d8b8ea7dbba52a0b97ac63dc5df995e3/' package/network/xray-core/Makefile
sed -i 's/20210226210728/20210308021214/' package/network/xray-core/Makefile
sed -i 's/ef9c30bacc6989a0b9fae6043dcef1ec15af96c01eddfa1f1d1ad93d14864f81/7a88dafe9ce0299742c2a8e30b42eb0433fc31ceb87ed2fb1356b64ff941e7ba/' package/network/xray-core/Makefile
rm -rf $GITHUB_WORKSPACE/other_packages

# Fix some packages
#find package/*/ feeds/*/ -maxdepth 2 -path "*luci-app-bypass/Makefile" | xargs -i sed -i 's/shadowsocksr-libev-ssr-redir/shadowsocksr-libev-alt/g' {}
#find package/*/ feeds/*/ -maxdepth 2 -path "*luci-app-bypass/Makefile" | xargs -i sed -i 's/shadowsocksr-libev-ssr-server/shadowsocksr-libev-server/g' {}
