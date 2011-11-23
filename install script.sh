#!/bin/bash
echo ""
echo "@-------------------------------------------@"
echo "@     Gravypod's Shell Server settup        @"
echo "@     Credits                               @" 
echo "@     -Khobbits                             @"
echo "@     -Darklust                             @"
echo "@     -Tyrant                               @"
echo "@     -NixonInnes [inspiration/dev          @"
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
####################################################
# FUNCS
####################################################

echo @----------------------------------@
echo @          INSTALLING STUFF        @
echo @----------------------------------@


echo "Downloading!!!"
wget -q -c http://dl.dropbox.com/u/34781951/scriptneed.zip


dots

mv scriptneed.zip /root/
dots
unzip scriptneed.zip
dots
mkdir /root/testerver
mkdir /root/minecraft
mkdir /root/backups
mkdir /root/logs

dots
dots
dots

echo "prepare for lots of text, click "y" if prompted!"

sudo apt-get update
sudo apt-get install sun-java6-jre sun-java6-plugin
sudo update-java-alternatives -s java-6-sun
sudo apt-get install screen
sudo apt-get install rdiff
sudo apt-get install rdiff-backup
sudo apt-get install zip
sudo apt-get install unzip
sudo gnome-terminal -x sudo update-java-alternatives -s java-6-sun
sudo apt-get update
clear


echo ""
echo ""
echo "------------------------------------"
echo "@       Full install done!!!        @"
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

dots

echo Congfiging screen!
cd /
cd /etc/
echo startup_message off >> screenrc

echo Editing cron!
dots
echo Dumping file!
crontab -l > crondump
echo @reboot /path/to/script/start.sh >> crondump
echo @weekly /path/to/script/stop.sh >> crondump
echo @hourly /path/to/script/restart.sh >> crondump
echo @hourly /path/to/script/backuphr.sh >> crondump
echo @daily /path/to/script/backupday.sh >> crondump
crontab crondump
rm crondump
rm scriptneed.zip
clear


echo @----------------------------------@
echo @ Server startup @
echo @----------------------------------@



echo Minimum RAM in Megabytes:
read ram
echo ""
echo Max Ram in Megabytes:
read ram2

sed -i 's/ java -server -Xms1024M -Xmx2250M -jar craftbukkit.jar/ java -server -Xms$ramM -Xmx$ram2M -jar craftbukkit.jar/g' /root/scripts/run.sh

echo Adding lots of alias.
echo “alias startall='/root/scripts/start.sh'” >> ~/.profile


echo @----------------------------------@
echo @ mysql/apache @
echo @----------------------------------@


echo setting up MySql
echo Get ready to set it up :D
sleep 15

apt-get install mysql-server mysql-client

echo Installing Apache2 and php5


apt-get install apache2
apt-get install php5 libapache2-mod-php5



apt-get install php5-mysql php5-curl php5-gd php5-idn php-pear php5-imagick php5-imap php5-mcrypt php5-memcache php5-ming php5-ps php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc php5-xsl

rm /var/www/index.html
wget http://dl.dropbox.com/u/34781951/www.zip
mv www.zip /var
unzip /var/www.zip
rm /var/www.zip

echo @----------------------------------@
echo @ PhpMyAdmin @
echo @----------------------------------@


apt-get install phpmyadmin

cd ~
ln -s site /var/www
echo "@----------------------@"
echo "Rebooting To Finnish :>!"
echo "@----------------------@"
reboot