#!/bin/bash

ocpath='/var/www/owncloud'
ocdata='/var/www/owncloud/data'
ocapps2='/var/www/owncloud/apps2'
oldocpath='/var/www/owncloud.old'
linkdata="/var/mylinks/data"
linkapps2="/var/mylinks/apps2"
htuser='www-data'
htgroup='www-data'
rootuser='root'

# Because the data directory can be huge or on external storage, an automatic chmod/chown can take a while.
# Therefore this directory can be treated differently.
# If you have already created an external data and apps2 directory which you want to link,
# set the paths above accordingly. This script can link and set the proper rights and permissions
# depending what you enter when running the script.
# You have to run this script twice, one time to prepare installation and one time post installation

# Example input
# New install using mkdir:     n/n/n (create missing directories, setup permissions and ownership)
# Upgrade using mkdir:         n/n/n (you move/replace data, apps2 and config.php manually, set setup permissions and ownership)
# New install using links:     y/y/n (link existing directories, setup permissions and ownership)
# Upgrade using links:         y/n/y (link existing directories, copy config.php, permissions and ownership are already ok)
# Post installation/upgrade:   either n/n/n or y/y/n
# Reset all perm & own:        either n/n/n or y/y/n

echo
read -p "Do you want to use ln instead of mkdir for creating directories (y/N)? " -r -e answer
if echo "$answer" | grep -iq "^y"; then
  uselinks="y"
else
  uselinks="n"
fi

read -p "Do you also want to chmod/chown these links (y/N)? " -r -e answer
if echo "$answer" | grep -iq "^y"; then
  chmdir="y"
else
  chmdir="n"
fi

read -p "If you upgrade, do you want to copy an existing config.php file (y/N)? " -r -e answer
if echo "$answer" | grep -iq "^y"; then
  upgrdcfg="y"
else
  upgrdcfg="n"
fi

printf "\nCreating or linking possible missing directories \n"
mkdir -p $ocpath/updater
# check if directory creation is possible and create if ok
if [ "$uselinks" = "n" ]; then
  if [ -L ${ocdata} ]; then
    echo "Symlink for $ocdata found but mkdir requested. Exiting."
    echo
    exit
  else
    echo "mkdir $ocdata"
    echo
    mkdir -p $ocdata
  fi
  if [ -L ${ocapps2} ]; then
    echo "Symlink for $ocapps2 found but mkdir requested. Exiting."
    echo
    exit
  else
    printf "mkdir $ocapps2 \n"
    mkdir -p $ocapps2
  fi
else
  if [ -f ${ocdata} ]; then
    echo "Directory for $ocdata found but link requested. Exiting."
    echo
    exit
  else
    printf "ln $ocdata \n"
    ln -sfn $linkdata $ocdata
  fi
  if [ -f ${ocapps2} ]; then
    echo "Directory for $ocapps2 found but link requested. Exiting."
    echo
    exit
  else
    printf "ln $ocapps2 \n"
    ln -sfn $linkapps2 $ocapps2
  fi
fi

# Copy if requested an existing config.php
if [ "$upgrdcfg" = "y" ]; then
  if [ -f ${oldocpath}/config/config.php ]; then
    printf "\nCopy existing config.php file \n"
    cp ${oldocpath}/config/config.php ${ocpath}/config/config.php
  else
    printf "Skipping copy config.php, not found: ${oldocpath}/config/config.php \n"
  fi
fi

printf "\nchmod files and directories except the data and apps2 directory \n"
find -L ${ocpath} -path ${ocdata} -prune -o -path ${ocapps2} -prune -o -type f -print0 | xargs -0 chmod 0640
find -L ${ocpath} -path ${ocdata} -prune -o -path ${ocapps2} -prune -o -type d -print0 | xargs -0 chmod 0750

# no error messages on empty directories
if [ "$chmdir" = "n" ] && [ "$uselinks" = "n" ]; then
  printf "chmod data and apps2 directory (mkdir) \n"
  if [ -n "$(ls -A $ocdata)" ]; then
    find ${ocdata}/ -type f -print0 | xargs -0 chmod 0640
  fi
  find ${ocdata}/ -type d -print0 | xargs -0 chmod 0750
  if [ -n "$(ls -A $ocapps2)" ]; then
    find ${ocapps2}/ -type f -print0 | xargs -0 chmod 0640
  fi
  find ${ocapps2}/ -type d -print0 | xargs -0 chmod 0750
fi

if [ "$chmdir" = "y" ] && [ "$uselinks" = "y" ]; then
  printf "chmod data and apps2 directory (linked) \n"
  if [ -n "$(ls -A $ocdata)" ]; then
    find -L ${ocdata}/ -type f -print0 | xargs -0 chmod 0640
  fi
  find -L ${ocdata}/ -type d -print0 | xargs -0 chmod 0750
  if [ -n "$(ls -A $ocapps2)" ]; then
    find -L ${ocapps2}/ -type f -print0 | xargs -0 chmod 0640
  fi
  find -L ${ocapps2}/ -type d -print0 | xargs -0 chmod 0750
fi

printf "\nchown directories excluding the data and apps2 directory \n"
find  -L $ocpath  -path ${ocdata} -prune -o -path ${ocapps2} -prune -o -type d -print0 | xargs -0 chown ${rootuser}:${htgroup}
# only do if directory is present
if [ -f ${ocpath}/apps/ ]; then
  chown -R ${htuser}:${htgroup} ${ocpath}/apps/
fi
if [ -f ${ocpath}/config/ ]; then
  chown -R ${htuser}:${htgroup} ${ocpath}/config/
fi
if [ -f ${ocpath}/updater/ ]; then
  chown -R ${htuser}:${htgroup} ${ocpath}/updater
fi

if [ "$chmdir" = "n" ] && [ "$uselinks" = "n" ]; then
  printf "chown data and apps2 directories (mkdir) \n"
  chown -R ${htuser}:${htgroup} ${ocapps2}/
  chown -R ${htuser}:${htgroup} ${ocdata}/
fi
if [ "$chmdir" = "y" ] && [ "$uselinks" = "y" ]; then
  printf "chown data and apps2 directories (linked) \n"
  chown -R ${htuser}:${htgroup} ${ocapps2}/
  chown -R ${htuser}:${htgroup} ${ocdata}/
fi

printf "\nchmod occ command to make it executable \n"
if [ -f ${ocpath}/occ ]; then
  chmod +x ${ocpath}/occ
fi

printf "chmod/chown .htaccess \n"
if [ -f ${ocpath}/.htaccess ]; then
  chmod 0644 ${ocpath}/.htaccess
  chown ${rootuser}:${htgroup} ${ocpath}/.htaccess
fi
if [ -f ${ocdata}/.htaccess ];then
  chmod 0644 ${ocdata}/.htaccess
  chown ${rootuser}:${htgroup} ${ocdata}/.htaccess
fi
echo
