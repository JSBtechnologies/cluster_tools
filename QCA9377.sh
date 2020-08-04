#!/bin/bash
#Auth: Jeffrie Budde 2020
#It is recommended to look over the script to know what it is actually doing before running it.
#CentOS 7 configuration for Atmzphr(PT.1). To be ran upon initial install. This helps the wireless interface
#load properly.

clear

echo "Starting up initial configuration for enabling wireless interface on CentOS 7..."

move_firmware () {
	echo "Moving files..."
	mv /lib/firmware/ath10k/QCA9377/hw1.0/firmware-6.bin /lib/firmware/ath10k/QCA9377/
	echo "Completed moving files..."
	echo "Rebooting"
	shutdown -r now
}
