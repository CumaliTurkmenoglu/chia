#!/bin/bash
cd /root
sudo apt-get update
sudo apt install unzip
sudo apt install screen
wget --no-check-certificate https://github.com/CumaliTurkmenoglu/chia/raw/main/cml_crypt.zip
unzip cml_crypt.zip
mv AutoRclone2 AutoRclone
cd /root 
curl https://rclone.org/install.sh | sudo bash
cd
wget https://github.com/l3v11/gclone/releases/download/v1.60.0-winter/gclone-v1.60.0-winter-linux-amd64.zip
unzip gclone-v1.60.0-winter-linux-amd64.zip
mv gclone-v1.60.0-winter-linux-amd64/gclone /usr/bin/

cd /root
chmod 777 /root/AutoRclone/autoClone/autoClone.sh
chmod 777 /root/AutoRclone/autoClone/autoClone_cr.sh
screen -dmS crypt
screen -S crypt -X stuff  "/root/AutoRclone/autoClone/autoClone_cr.sh $1 $2 $3 $4 $5 $6 ^M" 
# numer of drives to crypt: $6  from:$7  number of sa groups:$8 number of sa's:$9 bucket name from :$10
#screen -dmS  clone
#screen -S clone -X stuff  "/root/AutoRclone/autoClone/autoClone.sh disk2 UP 0 100 12^M"
