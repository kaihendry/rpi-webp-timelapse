#!/bin/bash
umask 002
tmp=$(mktemp /tmp/XXX.jpg)
webp=$(basename $tmp .jpg).webp
/opt/vc/bin/raspistill -n $@ -o $tmp
dir=/home/hendry/camera/$(date +%Y-%m-%d)/$(cat /proc/sys/kernel/random/boot_id)
mkdir -p $dir 2>/dev/null || true
output=$dir/$(date +%s).webp
cwebp -quiet $tmp -o $output
ln -sf $output /srv/http/index.webp
rm -f $tmp
