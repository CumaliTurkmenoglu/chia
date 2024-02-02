apt-get update && apt-get upgrade -y
sleep 2  # Bir sonraki ad?ma ge?meden ?nce sistem g?ncellemelerinin tamamlanmas?n? bekler

cd
git clone https://github.com/Chia-Network/chia-blockchain.git -b latest
mkdir drives
cd drives
mkdir drive_$1
cd drive_$1

start_value=$2
end_value=$3
# Perform the for loop
for ((i=start_value; i<=end_value; i++)); do
    mkdir "bucket$i"
done

cd

apt install rclone sshpass -y
sleep 2

cd ../usr/bin/
rm r rclone
sshpass -p 'Serhildanroot.123' scp -o StrictHostKeyChecking=no -r root@5.161.224.217:/usr/bin/rclone /usr/bin/
chmod 777 rclone

sshpass -p 'Serhildanroot.123' scp -o StrictHostKeyChecking=no -r root@5.161.224.217:/root/.config/rclone/rclone.conf /root/.config/rclone/

cd
chmod +x cml_hrv/mount.sh
cd

screen -dmS mount
screen -S mount -X stuff "/root/cml_hrv/mount.sh $1 $2 $3\n"
sleep 60

sshpass -p 'Serhildanroot.123' scp -o StrictHostKeyChecking=no -r root@5.161.224.217:/root/.chia/mainnet/config/ssl/ca /root/
sleep 5  # scp komutunun tamamlanmas?n? ve dosyalar?n transferini bekler


