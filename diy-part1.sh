#!/bin/bash

sed -i '$a src-git xucx https://github.com/kenzok8/small.git' feeds.conf.default
sed -i '$a src-git fxxk https://github.com/kenzok8/openwrt-packages.git' feeds.conf.default
