#!/usr/bin/bash

clear

echo "*******************************************************************************"
echo "* custom-os installer for Liber                                               *"
echo "*                                                                             *"
echo "* original script by Itachi for Windows                                       *"
echo "* rewritten by nonaybay for Linux                                             *"
echo "*******************************************************************************"

sleep 3

function rebooter() {
	adb reboot bootloader
	fastboot reboot bootloader
	fastboot reboot fastboot
}

function installBase() {
	fastboot --set-active=a
	fastboot -w
	fastboot flash boot boot.img
	fastboot flash dtbo dtbo.img
	fastboot flash system system.img
	fastboot flash product product.img
	fastboot flash vendor vendor.img
	fastboot flash vbmeta vbmeta.img
}

function systemError() {
	fastboot delete-logical-partition product_a
	fastboot delete-logical-partition product_b
	fastboot erase system
}

function executeIfError() {
	printf "\nyou got an error when flashing system? (y|n) "
	read answer
	
	if [[ $answer == "y" ]]; then
		systemError
		installBase
	fi
}



# run
rebooter
installBase
executeIfError

fastboot reboot

sleep 1; clear

echo "*******************************************************************************"
echo "* enjoy custom-OS                                                             *"
echo "*******************************************************************************"
