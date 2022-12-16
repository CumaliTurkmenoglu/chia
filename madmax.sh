#!/bin/bash
clone=0
while true
do
        MADMAX_PROCESS_ID=$(pgrep chia_plot)
        MADMAX_STATUS=$(ps -o s= -p $MADMAX_PROCESS_ID)
        CLONE_PROCESS_ID=$(pgrep uploading_has_started)
        CLONE_STATUS=$(ps -o s= -p $CLONE_PROCESS_ID)
        #S -> running
        #T -> SUSPENDED

        if [ ! -z $MADMAX_PROCESS_ID ]
            then
                PLOT_COUNT=$(ls /disk2/plots | wc -l) #plots klasörü içindeki taşınmaya hazır plot sayısına bak

				if [ $clone == 0 ] && [ $PLOT_COUNT -ge $2 ] #clone processi mevcut değil ya da plotlar birikti
				then
						clone=1
						#sudo su
						echo "$2 adet plot birikti. Gönderelim"
						chmod 777 /root/AutoRclone/autoClone/autoClone.sh
						screen -dmS  clone
						screen -S clone -X stuff  "/root/AutoRclone/autoClone/autoClone.sh disk2 $1 $2 $3 $4 ^M"
						sleep 5
						screen -S clone -X stuff  "^C^M"
						screen -S clone -X stuff  "sudo su^M"
						sleep 3
						screen -S clone -X stuff  "/root/AutoRclone/autoClone/autoClone.sh disk2 $1 $2 $3 $4 ^M"
						sleep 2
				fi

                if [ $MADMAX_STATUS == "S" ] && [ $PLOT_COUNT -gt "6" ] #madmax processi mevcut ve plot üretimi var ise
                then
                        #7 adet plot var. madmax durdurmamız gerekiyor.
                        kill -STOP $MADMAX_PROCESS_ID
                        echo "7 adet plot. madmax duraklatıldı"
                        sleep 1

                elif [ $MADMAX_STATUS == "T" ] && [ $PLOT_COUNT -lt "5" ]
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
                        rm -r /disk2/temp/*
                        screen -ls | awk -vFS='\t|[.]' '/tavuk/ {system("screen -S "$2" -X quit")}'
                        screen -dmS tavuk
                        screen -S tavuk -X stuff "cd /root/chia-plotter^M" 
                        screen -S tavuk -X stuff "./build/chia_plot -n -1 -r $5  -t /disk2/temp/ -d /disk2/plots/ -c xch1njk580cxj7e4lma50hzrh73u432mjh8jp6wfy0yrxcssyl3a4caqfc93k3 -f b3690b1c96e1ebc90cdc86d45e41d8d3f5060f4a758f9bc693bbccf0db40c2f25d40b89a64030ff5df82d15fd4c78c77 ^M"
        fi

        sleep 60
done