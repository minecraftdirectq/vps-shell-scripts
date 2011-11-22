#!/bin/bash
cd /home/mco/minecraft
screen -p 0 -X stuff "`printf "say Starting hourly backup\r"`"
sleep 1

T="$(date +%s)"
screen -S "mc" -p 0 -X stuff "`printf "save-all\r"`"
sleep 2
screen -S "mc" -p 0 -X stuff "`printf "save-off\r"`"

T="$(($(date +%s)-T))"

rdiff-backup /root/minecraft/ /root/backup/minecraft${T}/

screen -S "mc" -p 0 -X stuff "`printf "save-on\r"`"

T="$(($(date +%s)-T))"
screen -S "mc" -p 0 -X stuff "`printf "say Hourly backup complete.  Completed in ${T}s\r"`"
exit $?