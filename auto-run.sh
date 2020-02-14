#!/bin/sh

#CITRC
#02/10/2020

#This script is runs the status-ping-ll.sh script on a set interval continuously

#log folder path
lfp=/data/log/Pi-ping-log
#log list file
llf=/data/PI-PingScript/loglist.txt
#log file limit
lfl=50
#Function delete_log
  #This function counts through the log list until it reaches the log limit, after the limit has been met it begins deleting off the remaining logs
delete_log ()
{
  while read g ; do
    #Everytime the while loop iterates it adds one to i, giving a value for how many lines are in config.txt
    a=$((a+1))
    if [ $a -gt $lfl ] ; then
      rm /data/log/Pi-ping-log/$g
    fi
  done < loglist.txt
}
#Function count_lines
  #This function interates through the config.txt to determine how many lines are in the file by using a while loop
count_lines ()
{
  #While loop to read through config.txt and count the lines in the file
  while read d ; do
    #Everytime the while loop iterates it adds one to i, giving a value for how many lines are in config.txt
    i=$((i+1))
  done < loglist.txt
}
#Function log_manage
  #This function lists all the logs in /data/log/PI-Ping-log and counts them. Then compares the number of logs to the log limit
log_manage ()
{
  #list files from /data/log/Pi-ping-log into /data/PI-PingScript/loglist.txt
  ls -t $lfp > $llf
  #call the count_lines function to count the number of logs
  count_lines
  if [ $i -ge $lfl ]
  then
    delete_log
  fi
}
#constant for while loop
constant=0
while [ $constant -eq 0 ]
do
  log_manage
  /data/PI-PingScript/status-ping-ll.sh
  sleep 5m
done
