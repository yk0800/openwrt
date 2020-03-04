#!/bin/sh

log_max_size="100" #使用KB计算
log_file="/tmp/unblockmusic.log"

while true
do
	sleep 10s
	icount=`busybox ps -w | grep UnblockNeteaseMusic/app.js |grep -v grep| wc -l`
	if [ $icount -ne 1 ] ;then 
		/etc/init.d/unblockmusic restart 
	fi
	(( log_size = "$(ls -l "${log_file}" | awk -F ' ' '{print $5}')" / "1024" ))
	(( "${log_size}" >= "${log_max_size}" )) && echo "" > /tmp/unblockmusic.log
	sleep 10m
	icount=`busybox ps -w | grep UnblockNeteaseMusic |grep -v grep`
	[ -z "$icount" ] && /etc/init.d/unblockmusic restart 
	log_size=$(expr $(ls -l $log_file | awk '{print $5}') / 1024)
	[ $log_size -ge $log_max_size ] && echo "$(date -R) # Start UnblockNeteaseMusic" >/tmp/unblockmusic.log
done
