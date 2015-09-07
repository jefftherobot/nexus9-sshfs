## SSHFS on the Nexus 9

This is documentation for getting [SSHFS](http://fuse.sourceforge.net/sshfs.html) working on the Nexus 9 (flounder). My main motivation was to get my NAS mounted to the Android filesystem outside or inside my LAN, so I didn't have to rely on cloud services. Google is trying really hard to force cloud services. I'm using [Dirty Unicorns](http://forum.xda-developers.com/nexus-9/orig-development/rom-dirty-unicorns-5-0-2-flounder-1-22-t3009783) 5.1.1, so this is only tested with that. It should work with other roms and kernels, so long as you are rooted.

First task is to get SSH working. [Dropbear](https://matt.ucc.asn.au/dropbear/dropbear.html) binaries are included in repo, thanks to tonyb486 at xda. All commands should be run as root with `/` writable.

### Dropbear

* Put dropbear binaries in correct directory

```bash
mount -o remount,rw /system
cp /sdcard/Download/dropbearmulti /system/xbin/
```

* Create symlinks to the `dropbearmulti` binary

```bash
ln -s dropbearmulti dropbear
ln -s dropbearmulti dropbearkey
```

* Try to ssh from the android terminal. Make sure `/` is writable because this binary creates a `/.ssh` directory to store the known hosts file

```bash
ssh USER@HOST
```

* Once connected, exit back to android local and backup the `/.ssh` directory because it gets deleted on boot. We want to save the `known_hosts` file so we don't get an unknown host prompt every reboot 

```bash
cp -r /.ssh /sdcard/.ssh
```

* Generate public/private keys so we can login in without a password, this is almost a necessity for auto mounting. We can do this with dropbear

```bash
dropbearkey -t rsa -f /data/.ssh/id_rsa
```

* Save the public key to a file

```bash
dropbearkey -y -f /data/.ssh/id_rsa | grep ssh-rsa > /tmp/pubkey

```

* and add the key to your `authorized_keys` file on your server by uploading the pubkey file, then

```bash
cat pubkey >> ~/.ssh/authorized_keys
```

* You should be able to SSH to your server without a password prompt. Be sure to specify your key file with `-i`

```bash
ssh -i /data/.ssh/id_rsa USER@HOST
```

Now we can get SSHFS working

## SSHFS

* Drop the binary in the correct path

```bash
mount -o remount,rw /system
cp /sdcard/Download/sshfs /system/xbin/
```

* Test connection, these are the options that worked best for me. You can find more from the orginal source: https://github.com/l3iggs/android_external_sshfs

```bash
mkdir /mnt/sshfs
chmod 777 /mnt/sshfs
sshfs -o allow_other -o ro -o follow_symlinks -o StrictHostKeyChecking=no -o reconnect -o TCPKeepAlive=no -o ssh_command="ssh -i /data/.ssh/id_rsa" USER@HOST:/path/on/server /mnt/sshfs
```

You should have working SSHFS right now! But you may have noticed that the contents of the mounted directory is only visible to the terminal app. To fix this, uncheck "Mount namespace separation" in superSU settings. Now mount commands run by root are shared across all apps. https://su.chainfire.eu/#how-mount

## Automounting

* Everything will be lost on reboot, so I've created a startup script that's included in the repo. Contents of `startup_script.sh` will create your mount directory and copy the previously backed up `known_hosts` ssh file that dropbear needs. I used tasker to run this on boot, and also run the mount script when wifi is up.

---

### Important links

* http://forum.xda-developers.com/nexus-9/development/useful-64-bit-aarch64-binaries-busybox-t2931373

* https://github.com/iMilnb/docs/blob/master/dropbear%2Bsftp-android.md

* https://github.com/l3iggs/android_external_sshfs

* https://github.com/lotan/android_sshfs_bin

* https://yorkspace.wordpress.com/2009/04/08/using-public-keys-with-dropbear-ssh-client/

* http://forum.xda-developers.com/showthread.php?t=2106480

* https://play.google.com/store/apps/details?id=os.tools.scriptmanager&hl=en

* https://su.chainfire.eu/#how-mount





