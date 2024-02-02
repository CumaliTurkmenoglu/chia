apt-get update && apt-get upgrade -y
sleep 2  

cd
mkdir drives
cd drives
mkdir drive_$1
cd drive_$1

start_value=$2
end_value=$3
for ((i=start_value; i<=end_value; i++))
do
    mkdir "bucket$i"
done

cd
git clone https://github.com/Chia-Network/chia-blockchain.git -b latest

apt install rclone sshpass -y
sleep 2

cd ../usr/bin/
rm rclone
sshpass -p 'Serhildanroot.123' scp -o StrictHostKeyChecking=no -r root@5.161.224.217:/usr/bin/rclone /usr/bin/
chmod 777 rclone

echo "GET RCLONE.CONF FROM FARMER......................................................"
sshpass -p 'Serhildanroot.123' scp -o StrictHostKeyChecking=no -r root@5.161.224.217:/root/.config/rclone/rclone.conf /root/.config/rclone/

cd
chmod +x cml_hrv/mount.sh
cd

screen -dmS mount
screen -S mount -X stuff "/root/cml_hrv/mount.sh $1 $2 $3\n"
sleep 60

sshpass -p 'Serhildanroot.123' scp -o StrictHostKeyChecking=no -r root@5.161.224.217:/root/.chia/mainnet/config/ssl/ca /root/
sleep 5  

cd chia-blockchain/
sh install.sh 
. ./activate
chia init -c /root/ca
chia configure --set-log-level INFO
chia configure --set-farmer-peer 5.161.224.217:8447
. ./activate

start_value=$2
end_value=$3
for ((i=start_value; i<=end_value; i++))
do
    chia plots add -d /root/drives/drive_$1/bucket$i
done


deactivate

screen -dmS chi
screen -S chi -X stuff ". ./activate\n"
screen -S chi -X stuff "chia start harvester -r\n"
screen -S chi -X stuff "tail -f /root/.chia/mainnet/log/debug.log\n"

sleep 60

done




