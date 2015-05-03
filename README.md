# SSHFS on the Nexus 9

First task is to get ssh working. [Dropbear](https://matt.ucc.asn.au/dropbear/dropbear.html) binaries are included in repo, thanks to tonyb486 at xda.

##Dropbear ssh

* Put dropbear binaries in correct directory

```
root@android:/ # mount -o remount,rw /system
root@android:/ # cp /sdcard/downloads/dropbearmulti /system/bin/
root@android:/ # ln -s dropbearmulti dropbear
root@android:/ # ln -s dropbearmulti dropbearkey
root@android:/ # ln -s dropbearmulti dbclient
root@android:/ # ln -s dropbearmulti scp
```

* Create symlinks to the `dropbearmulti` binary

```
root@android:/ # ln -s dropbearmulti dropbear
root@android:/ # ln -s dropbearmulti dropbearkey
root@android:/ # ln -s dropbearmulti dbclient
root@android:/ # ln -s dropbearmulti scp
```

* Try to ssh from the android terminal. Make sure `/` is writable because this binary creates a `/.ssh` directory to store the known hosts file.

```
root@android:/ # ssh USER@HOST
```

* Once connected, exit back to android local backup the `/.ssh` directory because it gets deleted on boot. We want to save the `known_hosts` file so we don't get an unknown host prompt every reboot.

```
root@android:/ # cp -R /.ssh /sdcard/.ssh
```

---

###Sources
* http://forum.xda-developers.com/nexus-9/development/useful-64-bit-aarch64-binaries-busybox-t2931373

* https://github.com/iMilnb/docs/blob/master/dropbear%2Bsftp-android.md

* https://github.com/l3iggs/android_external_sshfs

* https://github.com/lotan/android_sshfs_bin


