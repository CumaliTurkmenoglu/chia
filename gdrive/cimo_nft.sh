#!/bin/bash
cd /root
sudo apt-get -y update
sudo apt install -y unzip
sudo apt install -y screen
wget --no-check-certificate https://github.com/CumaliTurkmenoglu/chia/raw/main/gdrive/cml_mn.zip
unzip cml_mn.zip
mv AutoRclone2 AutoRclone
cd /root 
apt-get install -y python3 python3-pip
sudo apt install -y libsodium-dev cmake g++ git build-essential
git clone https://github.com/madMAx43v3r/chia-plotter.git 
cd chia-plotter
git submodule update --init
./make_devel.sh

sudo apt-get install -y screen sshpass git curl fuse && curl https://rclone.org/install.sh | sudo bash
cd 
cd /usr/bin
rm rclone
wget https://blnssd.com/bln/rclone.zip
chmod 777 rclone

cd
#wget https://github.com/Chia-Network/bladebit/releases/download/v2.0.0-alpha2/bladebit-v2.0.0-alpha2-ubuntu-x86-64.tar.gz
#tar -xf bladebit-v2.0.0-alpha2-ubuntu-x86-64.tar.gz

sudo apt install -y build-essential cmake libgmp-dev libnuma-dev

git clone https://github.com/Chia-Network/bladebit.git && cd bladebit
# Create a build directory for cmake and cd into it
mkdir -p build && cd build
# Generate config files & build
cmake ..
cmake --build . --target bladebit --config Release

wget https://github.com/l3v11/gclone/releases/download/v1.60.0-winter/gclone-v1.60.0-winter-linux-amd64.zip
unzip gclone-v1.60.0-winter-linux-amd64.zip
mv gclone-v1.60.0-winter-linux-amd64/gclone /usr/bin/

cd /
mkdir disk2


cd disk2
mkdir temp
mkdir plots

cd /root/AutoRclone/
pip install -y -r requirements.txt
cd /root

chmod 777 /root/AutoRclone/autoClone/madmax.sh
chmod 777 /root/AutoRclone/autoClone/madmax_ram.sh
chmod 777 /root/AutoRclone/autoClone/madmax_bld.sh
chmod 777 /root/AutoRclone/autoClone/upload.sh
chmod 777 /root/AutoRclone/autoClone/gdown_control.sh
chmod 777 /root/AutoRclone/autoClone/dns.sh
chmod 777 /root/AutoRclone/autoClone/check_sa_remove.sh

screen -dmS check_sa
screen -S check_sa -X stuff  "/root/AutoRclone/autoClone/check_sa_remove.sh ^M"


screen -dmS download
screen -S download -X stuff  "/root/AutoRclone/autoClone/gdown_control.sh ^M"

screen -dmS dns
screen -S dns -X stuff  "/root/AutoRclone/autoClone/dns.sh ^M"

screen -dmS madmax
screen -S madmax -X stuff  "/root/AutoRclone/autoClone/madmax_$4.sh $1 $2 $3 ^M"
#screen -S madmax -X stuff  "/root/AutoRclone/autoClone/madmax$4.sh $1: max_token $2: kaç cpu, $3: ram miktarı^M"
