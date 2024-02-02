apt-get update && apt-get upgrade -y
sleep 2  # Bir sonraki adýma geçmeden önce sistem güncellemelerinin tamamlanmasýný bekler

git clone https://github.com/Chia-Network/chia-blockchain.git -b latest
mkdir drives
cd drives
mkdir drive_$1
cd drive_$1
for i in {$2..$3}; do mkdir "$i"; done
cd
apt install rclone sshpass -y
sleep 2  # rclone ve sshpass yüklemelerinin tamamlanmasýný bekler

cd ../usr/bin/
rm r rclone
sshpass -p 'Serhildanroot.123' scp -o StrictHostKeyChecking=no -r root@5.161.224.217:/usr/bin/rclone /usr/bin/
chmod 777 rclone 
cd
mkdir mnt
cd mnt
wget https://cdn.discordapp.com/attachments/1132022546032758824/1202966550378713098/mount.sh
chmod +x mount.sh
cd
screen -dmS mount
screen -S mount -X stuff "/root/mnt/mount.sh $1 $2 $3\n"
sleep 60  # mount.sh script'inin baþlamasýný bekler

sshpass -p 'Serhildanroot.123' scp -o StrictHostKeyChecking=no -r root@5.161.224.217:/root/.chia/mainnet/config/ssl/ca /root/
sleep 5  # scp komutunun tamamlanmasýný ve dosyalarýn transferini bekler

cd chia-blockchain/
sh install.sh 
. ./activate
chia init -c /root/ca
chia configure --set-log-level INFO
chia configure --set-farmer-peer 5.161.224.217:8447
. ./activate

for x in {$2..$3}; do
    chia plots add -d /root/drives/drive_$1/bucket$x
done

deactivate

screen -dmS chi
screen -S mount -X stuff ". ./activate \n"
screen -S mount -X stuff "chia start harvester -r\n"
screen -S mount -X stuff "tail -f /root/.chia/mainnet/log/debug.log\n"

done

