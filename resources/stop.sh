screen -S "mc" -p 0 -X stuff "`printf "Full server restart! Server will restart in 10 secconds!\r"`"
sleep 10
screen -S "mc" -p 0 -X stuff "`printf "Full stop!!!\r"`"
sleep 1
screen -S "mc" -p 0 -X stuff "`kickall Server restart, some back in 5-10 minutes\r"`"
sleep 1
screen -S "mc" -p 0 -X stuff "`printf "stop\r"`"
sleep 2
screen -p 0 -X kill
sleep 2
killall screen
sleep 2
killall java
sleep 4
killall -9 java
killall -9 screen 
sleep 5
reboot