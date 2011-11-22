screen -S "mc" -p 0 -X stuff "`printf "say Restarting in 15s!\r"`"
sleep 10
screen -S "mc" -p 0 -X stuff "`printf "say Restarting in 5s!\r"`"
sleep 5
screen -S "mc" -p 0 -X stuff "`printf "kickall Server Restart\r"`"
sleep 1
screen -S "mc" -p 0 -X stuff "`printf "stop\r"`"