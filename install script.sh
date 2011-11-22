#!/bin/bash
echo ""
echo "@-------------------------------------------@"
echo "@     Gravypod's Shell Server settup        @"
echo "@     Credits                               @" 
echo "@     -Khobbits                             @"
echo "@     -Darklust                             @"
echo "@     -Tyrantelf "GitHub Guy"               @"
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

sudo su

echo "prepare for lots of text, click "y" if prompted!"

sudo apt-get install bash

sudo apt-get install sun-java6-jre sun-java6-plugin
apt-get install apache2
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
crontab crondump
clear

<<<<<<< HEAD
=======
echo The ram for -Xms
read ram

echo The ram for -Xmx
read ram2

sed -i 's/  java -server -Xms1024M -Xmx2250M -jar craftbukkit.jar/  java -server -Xms$ramM -Xmx$ram2M -jar craftbukkit.jar/g' /root/scripts/run.sh


echo Adding lots of alias.
echo “alias startall='/root/scripts/start.sh'” >> ~/.profile

echo setting up MySql
echo Get ready to set it up :D
sleep 15

apt-get install mysql-server mysql-client



echo Installing Apache2 and php5
apt-get install apache2
apt-get install php5 libapache2-mod-php5
/etc/init.d/apache2 restart

cd /var/www/
wget -q -c https://github.com/downloads/minecraftdirectq/vps-shell-scripts/webfiles.zip

echo "done"
echo ""
echo "SUCCESS!"
echo "Rebooting!"

lbar

reboot