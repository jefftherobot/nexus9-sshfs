#!/system/bin/sh

mount -o remount,rw /
mkdir /mnt/sshfs
chmod 777 /mnt/sshfs
cp -R /sdcard/.ssh /.ssh
mount -o remount,ro /