#!/bin/bash
cd /root/AutoRclone/autoClone
remote=$1
while :
do
    mkdir /disk2/plots2
    echo "$remote -------"
    rclone move /disk2/plots XCOSUP_$remote:  --exclude "/*.temp"  --transfers=$3  --drive-upload-cutoff 1000T --tpslimit 5 --drive-stop-on-upload-limit --drive-chunk-size 4096M --no-traverse --ignore-existing  -P -v
remote=$(($remote + 1))
    if [ $remote -gt $2 ]; then
        remote=$1
    fi
    echo " Remote: $remote ---"
done

#autoClone.sh 1 10 3