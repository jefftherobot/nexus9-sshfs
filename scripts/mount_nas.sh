#!/system/bin/sh 
mount -o remount,rw /
umount /mnt/THX1138
#mount -t cifs -o username=admin,password=jdm$ //192.168.0.160/Media /mnt/nas
sshfs -o allow_other -o ro -o follow_symlinks -o StrictHostKeyChecking=no -o reconnect -o TCPKeepAlive=no -o ssh_command="ssh -i /data/.ssh/id_rsa" neo@192.168.0.120:/mnt/THX1138 /mnt/THX1138
mount -o remount,ro /