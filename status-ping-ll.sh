#!/bin/sh

#CITRC
#01/13/2020
#local logging enabled
#This version of the ping script runs a local down log file stored in /data/log/Pi-ping-log and stores the status there

#log file path
#fp=/data/log/Pi-ping-log
#Config.txt varaible designation
configfile="/data/PI-PingScript/config.txt"
#While loop var for breaking anywhere in the process
c=0
#Continuous run variable
constant=0
#TIME varaible assign
TIME=$(date +'%F')
STIME=$(date +'%F %T')
#Function count_lines
  #This function interates through the config.txt to determine how many lines are in the file by using a while loop
count_lines ()
{
  #While loop to read through config.txt and count the lines in the file
  while read d ; do
    #Everytime the while loop iterates it adds one to i, giving a value for how many lines are in config.txt
    i=$((i+1))
  done < config.txt
}
#Function readconfig_file
  #Utilizes a while loop to cycle through config.txt and read each IP.
  #It then sends the IP address recieved from config.txt to the ping_device function which pings the variable.
readconfig_file ()
{
  #While loop reads the variable line from config.txt
  while read ip ; do
    #ping_device function called
    ping_device
  done < config.txt
}

#Function ping_device
  #Pings the IP recieved from config.txt five times with quiet mode
  #Uses an if statement to determine if the ping was successful
  #Uploads to the status page
ping_device ()
{
  #Everytime this function is called, i2 increments by 1
  i2=$((i2+1))
  #if statement to compare i and i2. i is the number of lines in config.txt, i2 is the number of times an ip has been pinged from config.txt. If i2 and i are equal then the script stops
  if [ $i -eq $i2 ] ; then
    #Adds 1 to constant breaking while loop and stopping script
    c=$((c+1))
  fi
  #pinging the destination
  ping -q -c 3 $ip > /dev/null
  #Sets the return value of the ping equal to a
  a=$?
  #If statement determines if var a is anything but 0 meaning the ping has failed. 0 meaning the ping succeeded
  if [ $a -eq 0 ] ; then
    #Upload to status page
    echo $ip up at $STIME
  elif [ $a -ne 0 ] ; then
    #second knock
    ping -q -c 3 $ip > /dev/null
    b=$?
    #if statement to check second KNOCK
    if [ $b -eq 0 ] ; then
      #Passed, ignore first fail
      echo $ip up, second knock at $STIME
    elif [ $b -ne 0 ] ; then
      lfp=/data/log/Pi-ping-log/$ip-down-$TIME.txt
      echo $ip DOWN as of $STIME >> $lfp
      #Failed second knock
    fi
  fi
  #Unsetting both IP and a var
  unset ip
  unset a
  unset TIME
  unset lfp
}

#While loop so that the script can be stopped anywhere within the script when c is incremented
while [ $c -eq 0 ]
do
  #calling the functiion count_lines to count the number of lines in config.txt
  count_lines
  #Begin of the read and ping
  readconfig_file
done
