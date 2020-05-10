#!/bin/bash

export IMAGE=2020-02-13-raspbian-buster-lite.img
export DEV=sdc
export SKIP_FLASH=false

#if [ -z $EUID ] || [ $EUID -ne 0 ]; then
  echo "This script must be run as root"
#  exit 1
#fi

if [ -z $1 ]; then
  echo "Usage: bash $0 hostname [ip-suffix]"
  echo "       bash $0 rpi1 101"
  echo "       bash $0 rpi2 102"
  exit 1
fi

if [ -z $SKIP_FLASH ] || [ $SKIP_FLASH = false ];
then
  echo "Writing Raspbian Lite image(${IMAGE}) to SD card"
  dd if=$IMAGE of=/dev/$DEV bs=10M
fi

sync

BOOT_PATH="boot"
ROOT_PATH="root"

echo "Creating Directory $BOOT_PATH"
if [ -d $BOOT_PATH ]; then
  rm -rf $BOOT_PATH
fi
mkdir $BOOT_PATH

echo "Creating Directory $ROOT_PATH"
if [ -d $ROOT_PATH ]; then
  rm -rf $ROOT_PATH
fi
mkdir $ROOT_PATH

echo "Mounting SD card from /dev/$DEV"
mount /dev/${DEV}1 $BOOT_PATH
mount /dev/${DEV}2 $ROOT_PATH

YOUR_PUBLIC_KEY="/home/wjunjian/.ssh/id_rsa.pub"
RPI_ROOT_AUTHORIZED_KEYS="${ROOT_PATH}/home/pi/.ssh/authorized_keys"
echo "Setting ssh login without password. Copy your public key(${YOUR_PUBLIC_KEY}) to ${RPI_ROOT_AUTHORIZED_KEYS}"
mkdir -p ${ROOT_PATH}/home/pi/.ssh/
cp ${YOUR_PUBLIC_KEY} ${RPI_ROOT_AUTHORIZED_KEYS}

echo "Disable password login"
sed -ie s/#PasswordAuthentication\ yes/PasswordAuthentication\ no/g ${ROOT_PATH}/etc/ssh/sshd_config

echo "Setting hostname: $1"
sed -ie s/raspberrypi/$1/g ${ROOT_PATH}/etc/hostname
sed -ie s/raspberrypi/$1/g ${ROOT_PATH}/etc/hosts

echo "Enable ssh"
touch ${BOOT_PATH}/ssh

echo "Setting Wi-Fi User or Password(wpa_supplicant.conf)"
cat wpa_supplicant.conf > ${BOOT_PATH}/wpa_supplicant.conf

echo "Setting Zone China Shanghai"
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

if ! [ -z $2 ]; then
  echo "Setting static IP(dhcpcd.conf)"
  sed s/255/$2/g dhcpcd.conf > ${ROOT_PATH}/etc/dhcpcd.conf
fi

echo "Unmounting SD Card"
umount $BOOT_PATH
umount $ROOT_PATH

sync

