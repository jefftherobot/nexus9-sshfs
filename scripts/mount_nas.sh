#!/system/bin/sh
mount -o remount,rw /
umount /mnt/sshfs
sshfs -o allow_other -o ro -o follow_symlinks -o StrictHostKeyChecking=no -o reconnect -o TCPKeepAlive=no -o ssh_command="ssh -i /data/.ssh/id_rsa" USER@HOST:/path/on/server /mnt/sshfs
mount -o remount,ro /