#!/bin/bash
cd /root/minecraft/
screen -S "mc" -p 0 -X stuff "`printf "say Starting daily backup, server will be restarted on backup completion.\r"`"
sleep 1
screen -S "mc" -p 0 -X stuff "`printf "stoplag\r"`"
sleep 1

T="$(date +%s)"
screen -S "mc" -p 0 -X stuff "`printf "save-all\r"`"
sleep 2
screen -S "mc" -p 0 -X stuff "`printf "save-off\r"`"
sleep 1

T="$(($(date +%s)-T))"


mkdir /root/backup/minecraftDayly${T}/
rdiff-backup /root/minecraft/plugins/ /root/backup/plugins
rdiff-backup --force --remove-older-than 7D /root/backup/

T="$(($(date +%s)-T))"
screen -S "mc" -p 0 -X stuff "`printf "save-on\r"`"
sleep 1
screen -S "mc" -p 0 -X stuff "`printf "save-all\r"`"
sleep 2

screen -S "mc" -p 0 -X stuff "`printf "say Daily backup complete.  Completed in ${T}s.\r"`"

/root/scripts/restart.sh

sleep 2

D="$(date +%y-%m-%d)"

mv server.log /root/logs/server.${D}.log
touch server.log

sleep 30
exit $?