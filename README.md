# SSHFS on the Nexus 9

First task is to get ssh working. [Dropbear](https://matt.ucc.asn.au/dropbear/dropbear.html) binaries are included in repo, thanks to tonyb486 at xda.

##Dropbear ssh

* Put dropbear binaries in correct directory

```
# su
# mount -o remount,rw /system
# cp /sdcard/downloads/dropbearmulti /system/bin/
# ln -s dropbearmulti dropbear
# ln -s dropbearmulti dropbearkey
# ln -s dropbearmulti dbclient
# ln -s dropbearmulti scp
```

---

###Sources
* http://forum.xda-developers.com/nexus-9/development/useful-64-bit-aarch64-binaries-busybox-t2931373

* https://github.com/iMilnb/docs/blob/master/dropbear%2Bsftp-android.md

* https://github.com/l3iggs/android_external_sshfs

* https://github.com/lotan/android_sshfs_bin

