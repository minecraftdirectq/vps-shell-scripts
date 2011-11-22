#!/bin/bash
echo ""
echo "@-------------------------------------------@"
echo "@     Gravypod's Shell Server settup        @"
echo "@     Credits                               @" 
echo "@     -Khobbits                             @"
echo "@     -Darklust                             @"
echo "@     -Tyrant                               @"
echo "@-------------------------------------------@"

####################################################
# FUNCS
####################################################
counter=1
function dots {
while [ $counter -le 3 ]
do
echo -ne "."
sleep .1
((counter++))
done
let counter=1
echo
}

#[LOADING BAR]#
function lbar {
while [ $counter -le 3 ]
do
echo -ne "="
sleep .1
((counter+++++++++++))
done
let counter=1
echo
}

####################################################
# FUNCS
####################################################

echo @----------------------------------@
echo @          INSTALLING STUFF        @
echo @----------------------------------@


echo "prepare for lots of text, click "y" if prompted!"

sudo apt-get install sun-java6-jre sun-java6-plugin
sudo update-java-alternatives -s java-6-sun
sudo apt-get install screen
sudo apt-get install rdiff
sudo apt-get install rdiff-backup
sudo apt-get install zip
sudo apt-get install unzip
sudo gnome-terminal -x sudo update-java-alternatives -s java-6-sun
sudo apt-get update

echo @----------------------------------@
echo @          DLING THINGS :P         @
echo @----------------------------------@

wget -q -c https://github.com/downloads/minecraftdirectq/vps-shell-scripts/scriptneed.zip

lbar

mv scriptneed.zip /root/
lbar
unzip scriptneed.zip
lbar
mkdir /root/testerver
mkdir /root/minecraft
mkdir /root/backups
mkdir /root/logs


clear


echo ""
echo ""
echo "------------------------------------"
echo "@       Full install done!!!       @"
echo "------------------------------------"
echo ""
echo "------------------------------------"
echo "@       CONFIG TIME[woot?]!!!      @"
echo "------------------------------------"

dots
cd /root/scipts/
sudo chmod +x start.sh
sudo chmod +x run.sh
sudo chmod +x stop.sh
sudo chmod +x restart.sh
sudo chmod +x backuphr.sh
sudo chmod +x backupday.sh
sudo chmod +x change-murmur-super-pass.sh

echo ""

lbar

echo Congfiging screen!
sed -i 's/#startup_message off/startup_message on/g' /etc/screenrc

echo Editing cron!
dots
echo Dumping file!
crontab -l > crondump
cat @reboot /path/to/script/start.sh >> crondump
cat 0 0 * * 0 /path/to/script/stop.sh >> crondump
cat 0 * * * * /path/to/script/restart.sh >> crondump
cat 0 * * * * /path/to/script/backuphr.sh >> crondump
cat 0 0 * * * /path/to/script/backupday.sh >> crondump
crontab -l < crondump
clear



echo "done"
echo ""
echo "SUCCESS!"
echo "Rebooting!"

lbar

reboot