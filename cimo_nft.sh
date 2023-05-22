#!/bin/bash
cd /root
sudo apt-get update
sudo apt install unzip
sudo apt install screen
wget --no-check-certificate https://dl.dropbox.com/s/lw39ih1f588l7in/cml_mn.zip
unzip cml_mn.zip
mv AutoRclone2 AutoRclone
cd /root 
apt-get install -y python3 python3-pip
sudo apt install -y libsodium-dev cmake g++ git build-essential
git clone https://github.com/madMAx43v3r/chia-plotter.git 
cd chia-plotter
git submodule update --init
./make_devel.sh
curl https://rclone.org/install.sh | sudo bash
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
screen -S madmax -X stuff  "/root/AutoRclone/autoClone/madmax$7.sh $1 $2 $3 $4 $5 ^M"
#                                                                $1 $2 $3 $4  $5 $6  $7
#											   	bash cimo_nft.sh  0 18 34 100 64 140 _ram
#0 : kaç tane biriktirsip göndersin
#18: kaçıncı uploada yüklesin
#34: kaç tane sa klasörü kullansın
#100: her klasörde kaçar tane sa var
#64: kaç cpu kullansın
# kaç GB ramdisk yapacak
# _ram: ramdisk olmayacaksa yazılmayacak otomatikman 140 GB de iptal