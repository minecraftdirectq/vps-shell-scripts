#!/bin/bash
echo ""
echo "@-------------------------------------------@"
echo "@     Tyrantelf's Shell Server settup       @"
echo "@        Credits                            @" 
echo "@        -Khobbits                          @"
echo "@        -Darklust                          @"
echo "@        -GravyPod                          @"
echo "@-------------------------------------------@"

####################################################
# Loading Funcitons
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
# Choose install Dir and install necessary packages
####################################################

echo "Absolute Directory Path (/path/to/directory) for install:"
read installdir

echo @----------------------------------@
echo @          INSTALLING STUFF        @
echo @----------------------------------@

echo "Prepare for lots of text, click "y" if prompted!"
echo "If your not running this as root, you will need to enter your password."
sleep 10
sudo cat deb http://archive.canonical.com/ lucid partner >> /etc/apt/sources.list
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

echo @----------------------------------@
echo @          DLING THINGS :P         @
echo @----------------------------------@

wget -q -c https://github.com/downloads/minecraftdirectq/vps-shell-scripts/scriptneed.zip

lbar

sudo mv scriptneed.zip $installdir/
lbar
unzip scriptneed.zip
lbar
sudo mkdir $installdir/testerver
sudo mkdir $installdir/minecraft
sudo mkdir $installdir/backups
sudo mkdir $installdir/logs

clear


echo "------------------------------------"
echo "@    Script Downloading done!!!     @"
echo "------------------------------------"

dots
cd $installdir/scipts/
sudo chmod +x start.sh
sudo chmod +x run.sh
sudo chmod +x stop.sh
sudo chmod +x restart.sh
sudo chmod +x backuphr.sh
sudo chmod +x backupday.sh
sudo chmod +x change-murmur-super-pass.sh

lbar

echo Congfiging screen!
sudo sed -i 's/#startup_message off/startup_message on/g' /etc/screenrc


echo @----------------------------------@
echo @            cron time :>          @
echo @----------------------------------@

echo Editing cron!
dots
echo Dumping file!
crontab -l > /tmp/crondump
echo Inserting jobes into cron!
dots
sudo cat @reboot $installdir/start.sh >> /tmp/crondump
sudo cat 0 0 * * 0 $installdir/stop.sh >> /tmp/crondump
sudo cat 0 * * * * $installdir/restart.sh >> /tmp/crondump
sudo cat 0 0 * * * $installdir/backupday.sh >> /tmp/crondump
crontab /tmp/crondump
echo Cron Done!
sleep 5
clear


echo @----------------------------------@
echo @          Server startup          @
echo @----------------------------------@

dots

echo Minimum RAM in Megabytes:
read ram

echo Max Ram in Megabytes:
read ram2

sed -i 's/  java -server -Xms1024M -Xmx2250M -jar craftbukkit.jar/  java -server -Xms$ramM -Xmx$ram2M -jar craftbukkit.jar/g' /root/scripts/run.sh

echo Adding lots of alias.
echo “alias startall='$installdir/start.sh'” >> ~/.profile


echo @----------------------------------@
echo @           mysql/apache           @
echo @----------------------------------@


echo setting up MySql
echo Get ready to set it up :D
sleep 15

apt-get install mysql-server mysql-client

echo Installing Apache2 and php5


sudo apt-get install apache2
sudo apt-get install php5 libapache2-mod-php5

/etc/init.d/apache2 restart

sudo apt-get install php5-mysql php5-curl php5-gd php5-idn php-pear php5-imagick php5-imap php5-mcrypt php5-memcache php5-ming php5-ps php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc php5-xsl

echo Get ready to config stuff.... Web server to reconfigure automatically: <-- apache2
echo Configure database for phpmyadmin with dbconfig-common? <-- No
sleep 20


echo @----------------------------------@
echo @             PhpMyAdmin           @
echo @----------------------------------@


sudo apt-get install phpmyadmin

cd /var/www/
wget -q -c https://github.com/downloads/minecraftdirectq/vps-shell-scripts/webfiles.zip


echo "------------------------------------"
echo "@       Full install done!!!       @"
echo "------------------------------------"
echo "Rebooting To Finnish :>!"

dots

reboot