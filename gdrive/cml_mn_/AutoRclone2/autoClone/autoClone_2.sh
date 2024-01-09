#!/bin/bash
MAX=$1
tpslimit= $2
while :
do
    # Random bir sayı üret (1 ile MAX arasında)
    num=$(( RANDOM % MAX + 1 ))

    # Token'i oluştur
    random_token="XCOSUP_$num"

    echo -e "\e[92mplotlar buraya gonderiliyor = $random_token\e[0m"
    rclone move /disk2/plots $random_token: --progress --drive-upload-cutoff 1000T --tpslimit $tpslimit --exclude "/*.temp" --drive-stop-on-upload-limit --drive-chunk-size 1024M --no-traverse --ignore-existing --log-level INFO -P

    sleep 2
done

#autoClone_2.sh 200 3