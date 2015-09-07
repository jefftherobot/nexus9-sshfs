## SSHFS on the Nexus 9

This is documentation for getting [SSHFS](http://fuse.sourceforge.net/sshfs.html) working on the Nexus 9 (flounder). My main motivation was to get my NAS mounted to the Android filesystem, so I didn't have to rely on cloud services, so there's a bit of workaround to achieve this. Google is trying really hard to force cloud services. I'm using [Dirty Unicorns](http://forum.xda-developers.com/nexus-9/orig-development/rom-dirty-unicorns-5-0-2-flounder-1-22-t3009783) 5.1.1 and [FIRE-ICE](http://forum.xda-developers.com/nexus-9/orig-development/kernel-fire-ice-t2930451) [K9] Kernel, so this is only tested with that, but should work with other roms and kernels, so long as you are rooted.

First task is to get SSH working. [Dropbear](https://matt.ucc.asn.au/dropbear/dropbear.html) binaries are included in repo, thanks to tonyb486 at xda. All commands should be run as root with `/` writable.

### Dropbear

* Put dropbear binaries in correct directory

```bash
mount -o remount,rw /system
cp /sdcard/downloads/dropbearmulti /system/bin/
```

* Create symlinks to the `dropbearmulti` binary

```bash
ln -s dropbearmulti dropbear
ln -s dropbearmulti dropbearkey
ln -s dropbearmulti dbclient
ln -s dropbearmulti scp
```

* Try to ssh from the android terminal. Make sure `/` is writable because this binary creates a `/.ssh` directory to store the known hosts file

```bash
ssh USER@HOST
```

* Once connected, exit back to android local and backup the `/.ssh` directory because it gets deleted on boot. We want to save the `known_hosts` file so we don't get an unknown host prompt every reboot *TODO: Find out why this happens*

```bash
cp -R /.ssh /sdcard/.ssh
```

* Generate public/private keys so we can login in without a password, this is almost a necessity for auto mounting. We can do this with dropbear

```bash
dropbearkey -t rsa -f /data/.ssh/id_rsa
```

* You can save the public key to a file

```bash
dropbearkey -y -f /data/.ssh/id_rsa | grep ssh-rsa > /tmp/pubkey

```

* Add the key to your `authorized_keys` file on your server

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
cp /sdcard/downloads/sshfs /system/bin/
```

* Test connection, these are the options that worked best for me. You can find more from the orginal source: https://github.com/l3iggs/android_external_sshfs

```bash
mkdir /mnt/sshfs
chmod 777 /mnt/sshfs
sshfs -o allow_other -o ro -o follow_symlinks -o StrictHostKeyChecking=no -o reconnect -o TCPKeepAlive=no -o ssh_command="ssh -i /data/.ssh/id_rsa" USER@HOST:/path/on/server /mnt/sshfs
```

You should have working SSHFS right now! But you may have noticed that the contents of the mounted directory is only visible to the terminal app. This a problem with the Android system, and some workarounds have been found here: http://forum.xda-developers.com/showthread.php?t=2106480 Most kernels don't have this fix baked in, so we can use a method called the `debuggerd` method. This service has higher privileges and will allow mounts to be seen everywhere, by "piggy backing" on to it.

## Automounting

* Everything will be lost on reboot, so I've created a startup script that's included in the repo. Contents of `startup_script.sh` will create your mount directory and copy the previously backed up `known_hosts` ssh file that dropbear needs.

---

### Important links

* http://forum.xda-developers.com/nexus-9/development/useful-64-bit-aarch64-binaries-busybox-t2931373

* https://github.com/iMilnb/docs/blob/master/dropbear%2Bsftp-android.md

* https://github.com/l3iggs/android_external_sshfs

* https://github.com/lotan/android_sshfs_bin

* https://yorkspace.wordpress.com/2009/04/08/using-public-keys-with-dropbear-ssh-client/

* http://forum.xda-developers.com/showthread.php?t=2106480

* https://play.google.com/store/apps/details?id=os.tools.scriptmanager&hl=en



