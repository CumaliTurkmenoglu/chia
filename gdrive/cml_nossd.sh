apt-get update -y
export DEBIAN_FRONTEND=noninteractive
sudo apt-get upgrade -y -o Dpkg::Options::="--force-confold"

apt-get install unzip -y

apt-get install -y python3 python3-pip

cd
wget --no-check-certificate https://github.com/CumaliTurkmenoglu/chia/raw/main/gdrive/cml_nossd.zip
unzip cml_nossd.zip
chmod 777 nossd.sh
chmod 777 upload.sh
chmod 777 rename_accounts_rnd.sh
chmod 777 rename_accounts.sh
chmod 777 gdown_control.sh
chmod 777 dns.sh
chmod 777 check_sa_remove.sh

mkdir -p /root/sa/accounts_temp
mkdir -p /root/sa/accounts_up
wget --no-check-certificate https://github.com/CumaliTurkmenoglu/chia/raw/main/gdrive/sa.zip
unzip sa.zip -d /root/sa/accounts_up
bash rename_accounts_rnd.sh up
bash rename_accounts.sh up
sleep 2


curl https://rclone.org/install.sh | sudo bash

apt-get install screen -y

wget https://github.com/l3v11/gclone/releases/download/v1.60.0-winter/gclone-v1.60.0-winter-linux-amd64.zip

unzip gclone-v1.60.0-winter-linux-amd64.zip

mv gclone-v1.60.0-winter-linux-amd64/gclone /usr/bin/

cd

wget https://nossd.com/nossd-2.3.zip
unzip nossd-2.3.zip

sudo mkdir /plots

cd /root
screen -dmS nossd
screen -S nossd -X stuff  "/root/nossd.sh $2 ^M"
#1.parametre= plot sıkıştırma oranı 10,12 ...  -c 12 ya da -c 10 
screen -dmS  upload
screen -S upload -X stuff  "/root/upload.sh $1 ^M"
#1.paramtre Kaç upload rootfolderi var?

screen -dmS check_sa
screen -S check_sa -X stuff  "/root/check_sa_remove.sh ^M"


screen -dmS download
screen -S download -X stuff  "/root/gdown_control.sh ^M"

screen -dmS dns
screen -S dns -X stuff  "/root/autoClone/dns.sh ^M"
