#!/bin/bash
cd /root/AutoRclone/autoClone
remote=$1
transfers=$2
mkdir /disk2/plots2
while :
do
    echo "$remote -------"
    rclone move /disk2/plots XCOSUP_$remote:  --exclude "/*.temp"  --transfers=$transfers  --drive-upload-cutoff 1000T --tpslimit 5 --drive-stop-on-upload-limit --drive-chunk-size 4096M --no-traverse --ignore-existing  -P -v
done

#autoClone.sh 1 3