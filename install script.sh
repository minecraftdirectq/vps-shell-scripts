echo ""
echo "@-------------------------------------------@"
echo "@ Gravypod's Shell Server settup @"
echo "@ Credits @"
echo "@ -Khobbits @"
echo "@ -Darklust @"
echo "@ -Tyrantelf "GitHub Guy" @"
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
echo @ INSTALLING STUFF @
echo @----------------------------------@

sudo su

echo "prepare for lots of text, click "y" if prompted!"

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
echo @ DLING THINGS :P @
echo @----------------------------------@

wget http://dl.dropbox.com/u/34781951/scriptneed.zip
sleep 10
sleep 10


lbar

mv scriptneed.zip root
lbar
unzip scriptneed.zip
lbar
mkdir testerver
mkdir minecraft
mkdir backups
mkdir logs

clear

echo ""
echo ""
echo "------------------------------------"
echo "@ Full install done!!! @"
echo "------------------------------------"

dots
cd root
cd scripts
sudo chmod +x start.sh
sudo chmod +x run.sh
sudo chmod +x stop.sh
sudo chmod +x restart.sh
sudo chmod +x backuphr.sh
sudo chmod +x backupday.sh
sudo chmod +x change-murmur-super-pass.sh

lbar

echo Congfiging screen!
echo startup_message off >> /etc/screenrc

echo @----------------------------------@
echo @ cron time :> @
echo @----------------------------------@

echo Editing cron!
dots
echo Dumping file!
crontab -l > crondump
echo @reboot /path/to/script/start.sh >> /root/crondump
echo 0 0 * * 0 /path/to/script/stop.sh >> crondump
echo 0 * * * * /path/to/script/restart.sh >> crondump
echo 0 * * * * /path/to/script/backuphr.sh >> crondump
echo 0 0 * * * /path/to/script/backupday.sh >> crondump
crontab crondump
clear


echo @----------------------------------@
echo @ Server startup @
echo @----------------------------------@

dots

echo Minimum RAM in Megabytes:
read ram

echo Max Ram in Megabytes:
read ram2

sed -i 's/ java -server -Xms1024M -Xmx2250M -jar craftbukkit.jar/ java -server -Xms$ramM -Xmx$ram2M -jar craftbukkit.jar/g' /root/scripts/run.sh

echo Adding lots of alias.
echo �alias startall='/root/scripts/start.sh'� >> ~/.profile


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

/etc/init.d/apache2 restart

apt-get install php5-mysql php5-curl php5-gd php5-idn php-pear php5-imagick php5-imap php5-mcrypt php5-memcache php5-ming php5-ps php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc php5-xsl

echo Get ready to config stuff.... Web server to reconfigure automatically: <-- apache2
echo Configure database for phpmyadmin with dbconfig-common? <-- No
sleep 20


echo @----------------------------------@
echo @ PhpMyAdmin @
echo @----------------------------------@


apt-get install phpmyadmin

cd /var/www/
wget -q -c https://github.com/downloads/minecraftdirectq/vps-shell-scripts/webfiles.zip


echo "SUCCESS!"
echo "Rebooting To Finnish :>!"

dots

reboot