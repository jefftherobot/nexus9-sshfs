#!/system/bin/sh
kill $(ps | grep 'debuggerd.bin' | awk '{print $2}')