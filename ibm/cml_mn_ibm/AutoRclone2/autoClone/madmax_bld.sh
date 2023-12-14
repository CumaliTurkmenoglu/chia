#!/bin/bash
clone=0
remote=$1
transfer=$2
#cpu=$3
#ram=$4
accumulate=$5
while true
do
        MADMAX_PROCESS_ID=$(pgrep bladebit)
        MADMAX_STATUS=$(ps -o s= -p $MADMAX_PROCESS_ID)
        CLONE_PROCESS_ID=$(pgrep uploading_has_started)
        CLONE_STATUS=$(ps -o s= -p $CLONE_PROCESS_ID)
        #S -> running
        #T -> SUSPENDED

       if [ ! -z $MADMAX_PROCESS_ID ]
            then
                PLOT_COUNT=$(ls /disk2/plots | wc -l) #plots klasörü içindeki taşınmaya hazır plot sayısına bak

				if [ $clone == 0 ] && [ $PLOT_COUNT -ge $accumulate ] #clone processi mevcut değil ya da plotlar birikti
				then
						clone=1
						#sudo su
						echo "6 adet plot birikti. Gönderelim"
						chmod 777 /root/AutoRclone/autoClone/autoClone.sh
						screen -dmS  clone
						screen -S clone -X stuff  "/root/AutoRclone/autoClone/autoClone.sh $remote $transfer ^M"
#						screen -S clone -X stuff  "/root/AutoRclone/autoClone/autoClone.sh $remote $transfer ^M"
						sleep 5
						screen -S clone -X stuff  "^C^M"
						screen -S clone -X stuff  "sudo su^M"
						sleep 3
						screen -S clone -X stuff  "/root/AutoRclone/autoClone/autoClone.sh $remote $transfer ^M"
						sleep 2
				fi

                if [ $MADMAX_STATUS == "S" ] && [ $PLOT_COUNT -gt $accumulate ] #madmax processi mevcut ve plot üretimi var ise
                then
                        #7 adet plot var. madmax durdurmamız gerekiyor.
                        kill -STOP $MADMAX_PROCESS_ID
                        echo "7 adet plot. madmax duraklatıldı"
                        sleep 1

                elif [ $MADMAX_STATUS == "T" ] && [ $PLOT_COUNT -lt $accumulate ]
                then
                        #madmax duraklatışmıştı. plot sayısı 4'e düştü. madmax tekrardan çalıştırılıyor
                        kill -CONT $MADMAX_PROCESS_ID
                        echo "4 adet plot. madmax devam"
                        sleep 1
                fi

                if [ $MADMAX_STATUS == "S" ]
                then
                        echo "Tavuklar Otluyor"
                elif [ $MADMAX_STATUS == "T" ]
                then
                        echo "Tavuklar Dinlenmede"
                else
                        echo "Dilemma!"
                        #echo "madmax çalışmıyor. durdu. Temp klasörleri boşaltılıp yeniden başlatılıyor."
                fi
        else
                        echo "FIRST TIME: Tavuklar Otluyor. durdu. Temp klasörleri boşaltılıp yeniden başlatılıyor."
						sudo mkdir /disk2/plots
                        sudo chmod 777 /disk2/plots

                        screen -ls | awk -vFS='\t|[.]' '/tavuk/ {system("screen -S "$2" -X quit")}'
                        screen -dmS tavuk
                        screen -S tavuk -X stuff "cd^M"
                        screen -S tavuk -X stuff "./bladebit_cuda -c xch1wxvh0lupku627a3qnnrggssr9ey4utcfmk87llvg94wgahemc2yq2u37za -f b87d02b56e479832e7414bd7a0d8c3b03f18947eb406d82c9b1de30fcbad012fb84fe7bbd0b335310bcfd344a8bd9e94 cudaplot /disk2/plots/ ^M"
        fi

        sleep 60
done