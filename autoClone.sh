
#!/bin/bash
cd /root/AutoRclone/autoClone
while :
do
	n=$(( ( RANDOM % $5 )  + 1 ))
	sa=$(( ( RANDOM % $4 )  + 1 ))
	mkdir /disk2/plots2
	echo hellooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo > "/disk2/plots2/bulk.txt"
	echo    "SA: $sa  dir: $n  $1/plots -> GDrive$2_1:bucket1"
	if timeout 8s rclone move /$1/plots2 GDrive$2_1:bulk --exclude "/*.temp" --drive-upload-cutoff 1000T --tpslimit 5 --drive-stop-on-upload-limit --drive-chunk-size 1024M --no-traverse --ignore-existing -P --drive-service-account-file /root/AutoRclone/accounts/accounts_y/$n/$sa.json | grep -q 'Error 403: User rate limit exceeded\|Error 404: File not found'; then
	  continue
	fi
	echo    "SA: $sa  dir: $n  $1/plots -> GDrive$2_1:bucket1"
	rclone move /$1/plots XGDrive$2_1: --exclude "/*.temp" --drive-upload-cutoff 1000T --tpslimit 5 --drive-stop-on-upload-limit --drive-chunk-size 1024M --no-traverse --ignore-existing -P --drive-service-account-file /root/AutoRclone/accounts/accounts_y/$n/$sa.json 
	 sleep  10
done




#!/bin/bash

# while :
# do
	# echo "uploading_has_started"
 # n=$(( ( RANDOM % 12 )  + 1 ))
 # gclone move /$1/plots XGDrive$2_$n: --drive-upload-cutoff 1000T --tpslimit 5 --drive-stop-on-upload-limit --drive-chunk-size 4096M --no-traverse --ignore-existing -P
       # echo    "$1/plots -> GDrive$2_$n:bucket$n"
		
# done





# while :
# do
	# PLOT_COUNT=$(ls /$1/plots | wc -l) #plots klasörü içindeki taşınmaya hazır plot sayısına bak

	# if [ $PLOT_COUNT -gt $3 ]
	# then
	#		7 adet plot var. Gondermeye basla
			# echo "$3 plots accumulated. Let's move them!"
			# break
	# else		
			# echo "waiting for $3 plots to be cumulated. Tehere are $PLOT_COUNT plots in the directory now."
			# sleep 5m
	# fi
# done


