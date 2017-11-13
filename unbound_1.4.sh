#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
Green_font="\033[32m" && Yellow_font="\033[33m" && Red_font="\033[31m" && Font_suffix="\033[0m"
Info="${Green_font}[Info]${Font_suffix}"
Error="${Red_font}[Error]${Font_suffix}"
echo -e "${Green_font}
#======================================
# Project: unbound
# Version: 1.4
# Author: nanqinlang
# Blog:   https://www.nanqinlang.com
# Github: https://github.com/nanqinlang
#======================================${Font_suffix}"

check_system(){
	cat /etc/issue | grep -q -E -i "debian" && release="debian" 
	cat /etc/issue | grep -q -E -i "ubuntu" && release="ubuntu"
	[[ "${release}" != "debian" || "${release}" != "ubuntu" ]] && echo -e "${Error} not support!" && exit 1
}

check_root(){
	if [[ "`id -u`" = "0" ]]; then
	echo -e "${Info} user is root"
	else echo -e "${Error} must be root user" && exit 1
	fi
}

directory(){
	[[ ! -d /home/unbound-compile ]] && mkdir -p /home/unbound-compile
	cd /home/unbound-compile
}




check_system
check_root
directory
apt-get update && apt-get install -y build-essential && apt-get build-dep -y unbound
wget https://raw.githubusercontent.com/nanqinlang-script/unbound/master/unbound-1.6.7.tar.gz && tar -zxf unbound-1.6.7.tar.gz
chmod -R 7777 /home/unbound-compile
cd unbound-1.6.7
./configure --prefix=/home/unbound --sysconfdir=/home/unbound/etc --disable-rpath --with-pidfile=/home/unbound/etc/unbound.pid --with-libevent
make && make install
if [[ $? -ne 0 ]]; then
	echo -e "${Error} unbound installed failed, please check " && exit 1
	else echo -e "${Info} unbound is installed" && rm -rf /home/unbound-compile
fi
