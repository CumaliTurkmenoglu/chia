#!/bin/bash

start_value=$2
end_value=$3

for ((i=start_value; i<=end_value; i++)); do
   echo "Mounting  XGDriveMN__2/$i..."
   rclone mount XGDriveMN_$1:cml_$i /root/drives/drive_$1/bucket$i --allow-non-empty --daemon --multi-thread-streams=16 --multi-thread-cutoff=0 --vfs-cache-mode=off --vfs-read-chunk-size=128K --max-read-ahead=0 --use-mmap --local-no-check-updated --buffer-size=off --no-checksum --no-modtime --checkers=0 --use-cookies --read-only &
   sleep 1
done
