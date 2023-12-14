#!/bin/bash
cd /root
sudo apt-get update
sudo apt install unzip
sudo apt install screen
wget --no-check-certificate  https://github.com/CumaliTurkmenoglu/chia/raw/main/ibm/cml_mn_ibm/cml_mn_ibm.zip
unzip cml_mn_ibm.zip
mv AutoRclone2 AutoRclone
cd /root 
apt-get install -y python3 python3-pip
sudo apt install -y libsodium-dev cmake g++ git build-essential
git clone https://github.com/madMAx43v3r/chia-plotter.git 
cd chia-plotter
git submodule update --init
./make_devel.sh

sudo apt-get install screen sshpass git curl fuse && curl https://rclone.org/install.sh | sudo bash
cd 
cd /usr/bin
rm rclone
wget https://prol1337.de/rclone16/rclone
chmod 777 rclone

cd
wget https://github.com/Chia-Network/bladebit/releases/download/v2.0.0-alpha2/bladebit-v2.0.0-alpha2-ubuntu-x86-64.tar.gz
tar -xf bladebit-v2.0.0-alpha2-ubuntu-x86-64.tar.gz

wget https://github.com/l3v11/gclone/releases/download/v1.60.0-winter/gclone-v1.60.0-winter-linux-amd64.zip
unzip gclone-v1.60.0-winter-linux-amd64.zip
mv gclone-v1.60.0-winter-linux-amd64/gclone /usr/bin/

cd /
mkdir disk2

cd disk2
mkdir temp
mkdir plots
cd /root
chmod 777 /root/AutoRclone/autoClone/madmax.sh
chmod 777 /root/AutoRclone/autoClone/madmax_ram.sh
chmod 777 /root/AutoRclone/autoClone/madmax_bld.sh
chmod 777 /root/AutoRclone/autoClone/autoClone.sh
screen -dmS madmax
screen -S madmax -X stuff  "/root/AutoRclone/autoClone/madmax$6.sh $1 $2 $3 $4 $5 ^M"
#remote=$1
#transfer=$2
#cpu=$3                                                           
#ram=$4
#accumulate=$5
#ram_mi_degilmi $6

#cimo_nft.sh 1 3 62 123 1 _bld