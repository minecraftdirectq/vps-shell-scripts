!/bin/bash
clear
echo @-------------------------------------------@
echo @        BUKKIT SERVER SETUP SCRIPT         @
echo @-------------------------------------------@
echo @        Credits                            @
echo @          -Khobbits                        @
echo @          -Darklust                        @
echo @          -GravyPod                        @
echo @          -Tyrantelf                       @
echo @          -NixonInnes                      @
echo @-------------------------------------------@

####################################################
# Default parameters
####################################################
D_INSTALLDIR = /opt/minecraft/


####################################################
# Functions
####################################################
counter=1

# Dots loading 
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

# Loading bar
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

# Pause function
function pause() {
   read -p "$*"
}

####################################################
####################################################

####################################################
# INITIALISATION
####################################################

####################################################
# Check if the script is being run by a root user
####################################################

if [[ $EUID -ne 0 ]]; then
   echo "You should run this script as a root user, or using 'sudo'." 1>&2
   exit 1
fi


####################################################
# CONFIGURATION
####################################################

# Choose install dir and install necessary packages
echo "The install will default to /opt/minecraft, if you wish to"
echo "use a custom directory please enter your ABSOLUTE"
echo "directory path (/path/to/directory) for install:"
echo "(leave blank, and hit return to accept default)"
read INSTALLDIR

# If INSTALLDIR is empty set  to default.
if [ -z "$INSTALLDIR" ]; then
  INSTALLDIR = D_INSTALLDIR
fi

# Check if INSTALLDIR exists, if not then create it
if [ ! -d "$INSTALLDIR" ]; then
  mkdir $INSTALLDIR
fi


echo @----------------------------------@
echo @          INSTALLING STUFF        @
echo @----------------------------------@

echo "Preparing to install packages;"
echo "you may be required to press 'y' if prompted"
pause "Press any key to continue..."
# this next line is ugly, we should just crack in a new repo. A better solution would be to check the OS version and add the appropriate package -nix
sudo cat deb http://archive.canonical.com/ lucid partner >> /etc/apt/sources.list
sudo apt-get update
sudo apt-get install sun-java6-jre sun-java6-plugin
# im not sure if this is needed, it is done by default
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

# potentially include these files with the setup script, rather than downloading them. This way if in the future we can taylor packages accordingly by simply modifying the setup script. -nix
wget -q -c https://github.com/downloads/minecraftdirectq/vps-shell-scripts/scriptneed.zip

lbar

sudo mv scriptneed.zip $installdir/
lbar
unzip scriptneed.zip
lbar

# should be checks before this to make sure they dont already exist
sudo mkdir $installdir/testerver
sudo mkdir $installdir/minecraft
sudo mkdir $installdir/backups
sudo mkdir $installdir/logs

clear


echo @-----------------------------------@
echo @    Script Downloading done!!!     @
echo @-----------------------------------@

dots

# probably better practise to use absolute references, just in case.. -nix
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
echo Inserting jobs into cron!
dots

# I think that the server management should be handled by a single script installed as a service, so it can be managed simply via "service bukkit start/stop/restart/update/backup" this will also make unning on startup cleaner. -nix
sudo cat @reboot $installdir/start.sh >> /tmp/crondump
sudo cat 0 0 * * 0 $installdir/stop.sh >> /tmp/crondump
sudo cat 0 * * * * $installdir/restart.sh >> /tmp/crondump
sudo cat 0 0 * * * $installdir/backupday.sh >> /tmp/crondump
crontab /tmp/crondump
echo Cron Done!
sleep 5
clear


echo @---------------------------------------------@
echo @          Configuring Bukkit Server          @
echo @---------------------------------------------@

dots

# We should add some helpful info for the user in here; see cat /proc/meminfo -nix
echo Minimum RAM in Megabytes to allocate server:
read ram

echo Maximum Ram in Megabytes to allocate server:
read ram2

sed -i 's/  java -server -Xms1024M -Xmx2250M -jar craftbukkit.jar/  java -server -Xms$ramM -Xmx$ram2M -jar craftbukkit.jar/g' /root/scripts/run.sh

echo Adding lots of alias.
echo “alias startall='$installdir/start.sh'” >> ~/.profile

# I think the following mysql / php / httpd/apache should be an optional install -nix
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
# ? shutdown -r now -nix
