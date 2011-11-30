#!/bin/bash
clear
echo "@-------------------------------------------@"
echo "@        BUKKIT SERVER SETUP SCRIPT         @"
echo "@-------------------------------------------@"
echo "@        Credits                            @"
echo "@          -Khobbits                        @"
echo "@          -Darklust                        @"
echo "@          -GravyPod                        @"
echo "@          -Tyrantelf                       @"
echo "@          -NixonInnes                      @"
echo "@-------------------------------------------@"

####################################################
# Variables
####################################################
# Defaults
D_INSTALLDIR="/opt/minecraft"
D_MINRAM="512"
D_MAXRAM="2048"
D_USERNAME="mcuser"
D_DAYSOLD="7"

# Other stuff
WP_URL="http://dl.dropbox.com/u/34781951/www.zip"
SCRIPTS_URL="http://dl.dropbox.com/u/34781951/scriptneed.zip"
BUKKIT_URL="http://ci.craftbukkit.org/job/dev-CraftBukkit/promotion/latest/Recommended/artifact/target/craftbukkit-0.0.1-SNAPSHOT.jar"


####################################################
# Functions
####################################################
# Confirmation function (Y/N) (Used to break out of question loops)
function yesnof {
  local yesno=""
  while [[ "$yesno" != [yYnN] ]]; do
    echo "Do you want to set $1 to $2? (y/n)"
    read yesno
  done
  if [[ "$yesno" == [yY] ]]; then
    break
  fi
}

# Dots loading 
function dots {
  local counter=1
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
  local counter=1
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

# Check if the script is being run by a root user

if [[ $EUID -ne 0 ]]; then
   echo "You should run this script as a root user, or using 'sudo'." 1>&2
   exit 1
fi


####################################################
# CONFIGURATION
####################################################

echo "You will now be prompted for values for a series of inputs to configure"
echo "the Bukkit server, prior to it being installed."
echo "During the installation simply hit return to accept default settings"
pause "Press any key to continue..."

# Choose install dir and install necessary packages
while true; do
  echo "Where would you like to install the Bukkit server?"
  echo "Default: $D_INSTALLDIR"
  read INSTALLDIR
  if [ -z "$INSTALLDIR" ]; then
    INSTALLDIR=$D_INSTALLDIR
  fi
  yesnof "Install Directory" $INSTALLDIR
done

# Check if INSTALLDIR exists, if not then create it
if [ ! -d "$INSTALLDIR" ]; then
  mkdir $INSTALLDIR
fi

# Create directories
mkdir $INSTALLDIR/temp $INSTALLDIR/backups
TEMPDIR="$INSTALLDIR/temp"

# Download bukkit
echo Downloading bukkit
wget -O $TEMPDIR/bukkit.jar $BUKKIT_URL
cp $TEMPDIR/bukkit.jar $INSTALLDIR

# Copy a working copy of the init script into the temp dir, ready for the setup script to write appropriate values to the variables -nix
cp minecraft_script $TEMPDIR/minecraft

# Request the minimum RAM to allocate the server
while true; do
  echo "Minimum RAM in Megabytes to allocate server (512 - 4096):"
  echo "Default: $D_MINRAM"
  read MINRAM
  while true; do
     if [ -z "$MINRAM" ]; then
       MINRAM=$D_MINRAM
       break
     fi
     if [[ "$MINRAM" =~ ^[0-9]+$ ]]; then
       if (( "$MINRAM" < 512 || "$MINRAM" > 4096 )); then
         echo "Out of range."
       else
         break
       fi
     else
       echo "Please only enter the NUMBER of Megabytes."
     fi
     echo "Minimum RAM in Megabytes to allocate server (512 - 4096):"
     read MINRAM
  done
  yesnof "Min RAM" ${$MINRAM}M
done

# Request the maximum RAM to allocate the server
while true; do
  echo "Maximum RAM in Megabytes to allocate server ($MINRAM - 8192):"
  echo "Default: $D_MAXRAM"
  read MAXRAM
  while true; do
     if [ -z "$MAXRAM" ]; then
       MAXRAM=$D_MAXRAM
       break
     fi
     if [[ "$MAXRAM" =~ ^[0-9]+$ ]]; then
       if (( "$MAXRAM" < $MINRAM || "$MAXRAM" > 8192 )); then
         echo "Out of range."
       else
         break
       fi
     else
       echo "Please only enter the NUMBER of Megabytes."
     fi
     echo "Maximum RAM in Megabytes to allocate server ($MINRAM - 8192):"
     read MINRAM
  done
  yesnof "Max RAM" ${$MAXRAM}M
done

# Append 'M' on to the end of the RAM variables
MINRAM="${MINRAM}M"
MAXRAM="${MAXRAM}M"

# Request user who will own and run Bukkit server
while true; do
  echo "Enter name of new user to run bukkit server:"
  echo "Default: $D_USERNAME"
  read USERNAME
  if [ -z "$USERNAME" ]; then
    USERNAME=$D_USERNAME
  fi
  while id $USERNAME > /dev/null 2>&1; do
    echo "That user already exists."
    read -p "Use existing user, $USERNAME ? (y/n)"
    if [ $REPLY = "y" ]; then
	   break
    fi
    echo "Name of new user to run bukkit server:"
    read USERNAME
  done
  yesnof "bukkit username" $USERNAME
done
echo "Adding user $USERNAME as a system user to run bukkit..."
useradd $USERNAME

# Request the number of days old backup files will be deleted
while true; do
  echo "How many days should backups be stored (i.e. backups will be deleted after X days):"
  echo "Default: $D_DAYSOLD"
  read DAYSOLD
    if [ -z "$DAYSOLD" ]; then
    DAYSOLD=$D_DAYSOLD
  fi
  if [[ "$DAYSOLD" =~ ^[0-9]+$ ]]; then
  else
    echo "Please only enter the NUMBER of days."
  fi
  yesnof "days untill backups are deleted" $DAYSOLD
done

# Write all the set variables to the init file
sed 's/installdir_here/'$INSTALLDIR'/' $TEMPDIR/minecraft
sed 's/minram_here/'$MINRAM'/' $TEMPDIR/minecraft
sed 's/maxram_here/'$MAXRAM'/' $TEMPDIR/minecraft
sed 's/user_here/'$USERNAME'/' $TEMPDIR/minecraft
sed 's/olddays_here/'$DAYSOLD'/' $TEMPDIR/minecraft

# Move the minecraft_script into the init.d and install it as a service -nix
cp $TEMPDIR/minecraft /etc/init.d/minecraft
chmod a+x /etc/init.d/minecraft
update-rc.d minecraft defaults

# Setting permissions
chown -R $USER $INSTALLDIR

echo "@----------------------------------@"
echo "@          INSTALLING STUFF        @"
echo "@----------------------------------@"

echo "Preparing to install packages;"
echo "you may be required to press 'y' if prompted"
pause "Press any key to continue..."
# TODO: this next line is ugly, we shouldnt just crack in a new repo. A better solution would be to check the OS version and add the appropriate package -nix
# It's actually not a bad idea to put in a new repo, and this way java will update with apt-get upgrade later on. -ty
cat deb http://archive.canonical.com/ lucid partner >> /etc/apt/sources.list
apt-get update
apt-get install sun-java6-jre sun-java6-plugin
# im not sure if this is needed, it is done by default
# It's not needed, I just haven't removed it yet, doing it now -Ty
# update-java-alternatives -s java-6-sun

# I compressed all these into one command to make it faster, so it doesn't have to do five dependacy checks, etc. -ty
apt-get install screen rdiff rdiff-backup zip unzip 

# This isn't needed either -ty
# gnome-terminal -x update-java-alternatives -s java-6-sun
apt-get update


echo "@----------------------------------@"
echo "@          DLING THINGS :P         @"
echo "@----------------------------------@"

# potentially include these files with the setup script, rather than downloading them. This way if in the future we can taylor packages accordingly by simply modifying the setup script. -nix
wget -O $TEMPDIR/scriptsneed.zip $SCRIPTS_URL 

lbar
unzip -d $INSTALLDIR/ scriptneed.zip
lbar

clear


echo "@-----------------------------------@"
echo "@    Script Downloading done!!!     @"
echo "@-----------------------------------@"

dots

# probably better practise to use absolute references, just in case.. -nix
# These are redundant with the init script -nix
#cd $INSTALLDIR/scipts/
#chmod +x start.sh
#chmod +x run.sh
#chmod +x stop.sh
#chmod +x restart.sh
#chmod +x backuphr.sh
#chmod +x backupday.sh
#chmod +x change-murmur-super-pass.sh

lbar

#This is redundant, the screen is created with the init script -nix
#echo "Congfiging screen!"
#sed -i 's/#startup_message off/startup_message on/g' /etc/screenrc


#echo "@----------------------------------@"
#echo "@            cron time :>          @"
#echo "@----------------------------------@"

#echo "Editing cron!"
#dots
#echo "Dumping file!"
#crontab -l > /tmp/crondump
#echo "Inserting jobs into cron!"
#dots

# I think that the server management should be handled by a single script installed as a service, so it can be managed simply via "service bukkit start/stop/restart/update/backup" this will also make unning on startup cleaner. -nix
#cat @reboot $INSTALLDIR/start.sh >> /tmp/crondump
#cat 0 0 * * 0 $INSTALLDIR/stop.sh >> /tmp/crondump
#cat 0 * * * * $INSTALLDIR/restart.sh >> /tmp/crondump
#cat 0 0 * * * $INSTALLDIR/backupday.sh >> /tmp/crondump
#crontab /tmp/crondump
#echo "Cron Done!"
#sleep 5
#clear


echo "@---------------------------------------------@"
echo "@          Configuring Bukkit Server          @"
echo "@---------------------------------------------@"



# I think the following mysql / php / httpd/apache should be an optional install -nix
echo "@----------------------------------@"
echo "@           mysql/apache           @"
echo "@----------------------------------@"


echo "setting up MySql"
echo "Get ready to set it up :D"
pause "Press any key to continue..."

apt-get install mysql-server mysql-client

echo "Installing Apache2 and php5"


apt-get install apache2
apt-get install php5 libapache2-mod-php5

/etc/init.d/apache2 restart

apt-get install php5-mysql php5-curl php5-gd php5-idn php-pear php5-imagick php5-imap php5-mcrypt php5-memcache php5-ming php5-ps php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc php5-xsl

echo "Get ready to config stuff.... Web server to reconfigure automatically: <-- apache2"
echo "Configure database for phpmyadmin with dbconfig-common? <-- No"
sleep 20


echo @----------------------------------@
echo @             PhpMyAdmin           @
echo @----------------------------------@


apt-get install phpmyadmin

wget -q -c -O $TEMPDIR/WP.zip $WP_URL
unzip -d /var/www/ $TEMPDIR/WP.zip 


echo "------------------------------------"
echo "@       Full install done!!!       @"
echo "------------------------------------"
echo "Rebooting To Finnish :>!"

dots

shutdown -r now
# ? shutdown -r now -nix
# Actually a much better command nix.. good thinking! -ty
