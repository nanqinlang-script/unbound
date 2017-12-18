#!/bin/bash
Green_font="\033[32m" && Yellow_font="\033[33m" && Red_font="\033[31m" && Font_suffix="\033[0m"
Info="${Green_font}[Info]${Font_suffix}"
Error="${Red_font}[Error]${Font_suffix}"


check_system(){
	[[ ! -z "`cat /etc/issue | grep -iE "debian"`" ]] && release="debian"
	[[ ! -z "`cat /etc/issue | grep -E -i "ubuntu"`" ]] && release="ubuntu"
	[[ "${release}" != "debian" && "${release}" != "ubuntu" ]] && echo -e "${Error} not support!" && exit 1
}

check_root(){
	[[ "`id -u`" != "0" ]] && echo -e "${Error} must be root user !" && exit 1
}

directory(){
	[[ ! -d /home/unbound-compile ]] && mkdir -p /home/unbound-compile
	cd /home/unbound-compile
}

maker(){
	wget https://raw.githubusercontent.com/nanqinlang-script/unbound/master/unbound-1.6.7.tar.gz && tar -zxf unbound-1.6.7.tar.gz
	chmod -R 7777 /home/unbound-compile
	cd unbound-1.6.7
	./configure --prefix=/home/unbound --sysconfdir=/home/unbound/etc --disable-rpath --with-pidfile=/home/unbound/etc/unbound.pid --with-libevent
	make && make install
}

check_install(){
	if [[ $? -ne 0 ]]; then
		 echo -e "${Error} unbound installed failed, please check !"
	else
		 echo -e "${Info} unbound installed successfully !"
	fi
}

check_system
check_root
directory
apt-get update && apt-get install -y build-essential && apt-get build-dep -y unbound
maker
check_install
rm -rf /home/unbound-compile