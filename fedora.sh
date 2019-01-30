#!/bin/bash

#Vultr Fedora Startup Script - Aaron Ament
#Quick and dirty script to get it ready for config management and other small tweaks

# -[PYTHON SETUP] - #
#Fedora doesn't ship with a python binary without a number suffix, this breaks ansible.
#I could install py2 to fix this, but I pefer to have py3 by default.
echo "Setting Python Symlink..."
ln -sv /usr/bin/python3 /usr/bin/python
echo



# -[REMOVE COCKPIT]- #
# Pruning the packages
declare -a COCKPIT_PACKAGES=("cockpit-networkmanager"
							 "cockpit-packagekit"
							 "cockpit-storaged"
							 "cockpit-system"
							 "cockpit-bridge"
							 "cockpit-ws"
							 "cockpit"
							)

echo "Removing Cockpit Packages..."
for pkg in "${COCKPIT_PACKAGES[@]}"
	do
		echo "Removing $pkg"
		rpm -ve --nodeps $pkg
	done

#Removing its firewall rules
echo "Disabling cockpit service from firewalld"
firewall-cmd --remove-service=cockpit --permanent
echo "Reloading Firewall"
firewall-cmd --reload


# -[DISABLING SELINUX] - #
echo "Disabling selinux"
sed -i.orig "s/^SELINUX=\S*/SELINUX=disabled/g" /etc/selinux/config

