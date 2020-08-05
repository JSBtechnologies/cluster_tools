#!/bin/bash
#Auth: Jeffrie Budde 2020
#It is recommended to look over the script to know what it is actually doing before running it.
#CentOS 7 configuration for Atmzphr

clear

echo "Starting up configuration script for Atmzphr..."

main () {
	kill_uneeded_processes
	remove_dns
	update_yum
	add_modules
	add_groups
	selinux_permissions
	docker_setup
	install_docker_pchk
	reboot_sys
}

kill_uneeded_processes () {
	echo "Disabling firewalld..."
	systemctl stop firewalld
	systemctl disable firewalld
	echo "Done."

	echo "Disabling dnsmasq..."
	systemctl stop dnsmasq
	systemctl disable dnsmasq
	echo "Done."
}

remove_dns () {
	echo "Removing and killing all dnsmasq processes(clears up port 53)..."
	yum remove dnsmasq
	killall dnsmasq
	echo "dnsmasq removed"
}

update_yum () {
	echo "Updating yun repo..."
	yum -y upgrade --assumeyes --tolerant 
  yum -y update --assumeyes 
  echo "Done."
  echo "Adding Docker repo..."
  yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo 
  if [ $? -eq 0 ]; then
	    echo "Yum update Success."
	else
	    echo "Yum update failed."
	fi
}

add_modules () {
	echo "Loading in needed modules..."
	tee /etc/modules-load.d/mod_load.conf <<-'EOF'
        dm_raid
        raid1
        br_netfilter
        overlay
EOF
  if [ $? -eq 0 ]; then
	    echo "Loading in Modules Success."
	else
	    echo "Loading in Modules failed."
	fi

  #temp loading modules via mod probe for initial install
  echo "Temp load in modules for installation purposes."
  modprobe br_netfilter
  modprobe dm_raid
  modprobe overlay
  modprobe raid1
  if [ $? -eq 0 ]; then
	    echo "Temp Modules loaded."
	else
	    echo "Temp Modules load failed."
	fi
}

setup_ntp () {
	sudo tee /etc/ntp.conf <<- EOF
	server 0.pool.ntp.org iburst
	server 1.pool.ntp.org iburst
	server 2.pool.ntp.org iburst
	server 3.pool.ntp.org iburst
EOF
}

docker_setup () {
	echo "Docker repo setup..."
	sudo mkdir -p /etc/systemd/system/docker.service.d && sudo tee /etc/systemd/system/docker.service.d/override.conf <<- EOF
  [Service]
  ExecStart=
  ExecStart=/usr/bin/dockerd --storage-driver=overlay
EOF
  if [ $? -eq 0 ]; then
	    echo "Docker repo setup."
	else
	    echo "Docker repo setup failed."
	fi
}

add_groups () {
	echo "Adding needed groups..."
	groupadd nogroup &&
	groupadd docker && 
	echo "Done."
}

selinux_permissions () {
	echo "Editing selinux permissions..."
	sed -i s/SELINUX=enforcing/SELINUX=permissive/g /etc/selinux/config
  	echo "Done."
}

install_docker_pchk () {
	echo "Installing Docker..."
	yum -y install docker-ce docker-ce-cli containerd.io 
	systemctl start docker 
	systemctl enable docker
  echo "Done."
}

reboot_sys () {
	echo "Configuration complete. Rebooting now..."
	shutdown -r now
}

main
