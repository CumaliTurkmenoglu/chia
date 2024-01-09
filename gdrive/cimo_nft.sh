#!/bin/bash
cd /root
sudo apt-get update
sudo apt install unzip
sudo apt install screen
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

sudo apt-get install screen sshpass git curl fuse && curl https://rclone.org/install.sh | sudo bash
cd 
cd /usr/bin
rm rclone
wget https://prol1337.de/rclone16/rclone
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
pip install -r requirements.txt
cd /root
chmod 777 /root/AutoRclone/autoClone/madmax.sh
chmod 777 /root/AutoRclone/autoClone/madmax_ram.sh
chmod 777 /root/AutoRclone/autoClone/madmax_bld.sh
chmod 777 /root/AutoRclone/autoClone/autoClone.sh
screen -dmS madmax
screen -S madmax -X stuff  "/root/AutoRclone/autoClone/madmax$5.sh $1 $2 $3 $4 ^M"
#screen -S madmax -X stuff  "/root/AutoRclone/autoClone/madmax$5.sh $1: drive(token) $2: transfers $3: kaç cpu, $4: ram miktarı^M"
