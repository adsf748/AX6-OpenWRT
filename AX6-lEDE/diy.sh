#!/bin/bash
# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}

# Add packages
#添加科学上网源
#git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall-packages package/openwrt-passwall-packages
#git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall package/openwrt-passwall
git clone --depth 1 https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon
git clone --depth 1 https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config
git clone --depth 1 https://github.com/hudra0/qosmate package/qosmate
git clone --depth 1 https://github.com/hudra0/luci-app-qosmate package/luci-app-qosmate
#git clone --depth 1 https://github.com/sirpdboy/luci-app-ddns-go package/ddnsgo
#git clone --depth 1 https://github.com/sbwml/luci-app-alist package/alist
#git clone --depth=1  https://github.com/kenzok8/small-package package/small-package
#git_sparse_clone main https://github.com/kiddin9/kwrt-packages luci-app-zerotier
#git_sparse_clone main https://github.com/kiddin9/kwrt-packages vlmcsd
#git_sparse_clone main https://github.com/kiddin9/kwrt-packages luci-app-vlmcsd
git_sparse_clone main https://github.com/kiddin9/kwrt-packages luci-app-subconverter
git_sparse_clone dev https://github.com/vernesong/OpenClash luci-app-openclash
#拉取TerryLip大佬部分源码，感谢大佬对nss的支持！
#git_sparse_clone qualcommax-6.x-nss-wifi https://github.com/TerryLip/AX6NSS package/new/luci-theme-argon
#git_sparse_clone qualcommax-6.x-nss-wifi https://github.com/TerryLip/AX6NSS package/new/luci-app-argon-config
git_sparse_clone qualcommax-6.x-nss-wifi https://github.com/TerryLip/AX6NSS package/new/luci-app-turboacc
git_sparse_clone qualcommax-6.x-nss-wifi https://github.com/TerryLip/AX6NSS package/new/vlmcsd
git_sparse_clone qualcommax-6.x-nss-wifi https://github.com/TerryLip/AX6NSS package/new/luci-app-vlmcsd

# mosdns
git_sparse_clone v5 https://github.com/sbwml/luci-app-mosdns luci-app-mosdns
git_sparse_clone v5 https://github.com/sbwml/luci-app-mosdns mosdns
git_sparse_clone v5 https://github.com/sbwml/luci-app-mosdns v2dat

# 替换luci-app-openvpn-server imm源的启动不了服务！
#rm -rf feeds/luci/applications/luci-app-openvpn-server
#git_sparse_clone main https://github.com/kiddin9/kwrt-packages luci-app-openvpn-server
# 调整 openvpn-server 到 VPN 菜单
#sed -i 's/services/vpn/g' package/luci-app-openvpn-server/luasrc/controller/*.lua
#sed -i 's/services/vpn/g' package/luci-app-openvpn-server/luasrc/model/cbi/openvpn-server/*.lua
#sed -i 's/services/vpn/g' package/luci-app-openvpn-server/luasrc/view/openvpn/*.htm

#git clone -b js https://github.com/papagaye744/luci-theme-design package/luci-theme-design

#替换luci-app-socat为https://github.com/chenmozhijin/luci-app-socat
#rm -rf feeds/luci/applications/luci-app-socat
#git_sparse_clone main https://github.com/chenmozhijin/luci-app-socat luci-app-socat

#删除库中的插件，使用自定义源中的包。
rm -rf feeds/luci/applications/luci-app-openclash
rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/luci/applications/luci-app-argon-config
rm -rf feeds/packages/net/vlmcsd
rm -rf feeds/luci/applications/luci-app-vlmcsd
#rm -rf feeds/luci/applications/luci-app-ddns-go
#rm -rf feeds/packages/net/ddns-go
#rm -rf feeds/packages/net/alist
#rm -rf feeds/luci/applications/luci-app-alist
#rm -rf feeds/luci/applications/openwrt-passwall
#rm -rf feeds/luci/applications/openwrt-passwall-packages

#添加istore
echo >> feeds.conf.default
echo 'src-git istore https://github.com/linkease/istore;main' >> feeds.conf.default
./scripts/feeds update istore
./scripts/feeds install -d y -p istore luci-app-store

#修改默认IP
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

#修改主机名
#sed -i "s/hostname='ImmortalWrt'/hostname='Redmi-AX6'/g" package/base-files/files/bin/config_generate
