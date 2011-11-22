#!/bin/bash
cd /root/minecraft/
while true
do
	java -server -Xms1024M -Xmx2250M -jar craftbukkit.jar
	echo "You have stoped the server click CTRL-C to fully stop!"
	sleep 2
	echo "3"
	sleep 1
	echo "2"
	sleep 1
	echo "1"
done

exit $?