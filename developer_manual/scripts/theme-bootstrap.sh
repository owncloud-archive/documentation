#!/bin/bash
# theme-bootstrap.sh
# Invoke this script with two arguments, the new theme's name and the path to ownCloud root.
# Written by Dmitry Mayorov <dmitry@owncloud.com>,  Matthew Setter <matthew@matthewsetter.com> & Martin Mattel <github@diemattels.at>
# Copyright (c) ownCloud 2018.
set -e

# Clone a copy of the ownCloud example theme
# It won't override an existing app directory of the same name.
function clone_example_theme
{
  local APP_NAME="$1"
  local INSTALL_BASE_DIR="$2"
  local MAINFILE=master.zip
  local UNZIPDIR=/tmp
  local MASTERNAME=theme-example-master
  local DOWNLOAD_FILE=$UNZIPDIR/$MAINFILE
  local THEME_ARCHIVE_URL=https://github.com/owncloud/theme-example/archive/master.zip

  # check if the app name already exists
  if  [ -d "$INSTALL_BASE_DIR/$APP_NAME" ]
  then
    echo "An app with name ('$INSTALL_BASE_DIR/$APP_NAME') already exists."
    echo "Please remove or rename it before running this script again."
    return 1
  fi;

  # delete an existing downloaded zip file
  if [ -e "$DOWNLOAD_FILE" ]
  then
	rm "$DOWNLOAD_FILE"
  fi

  echo "Downloading ownCloud example theme."

  # getting the exmple theme from git
  if ! wget --output-document="$DOWNLOAD_FILE" --tries=3 --continue \
    --timeout=3 --dns-timeout=3 --connect-timeout=3 --read-timeout=3  \
    "$THEME_ARCHIVE_URL" >/dev/null 2>&1
  then
    echo "Download error, exiting"
    return 1
  fi

  # first test if unzip would error then extract
  if unzip -t "$DOWNLOAD_FILE" >/dev/null 2>&1
  then
	# unzip with overwriting existing files and directories and suppressed output
	echo "Unzipping download"
	unzip -oq "$DOWNLOAD_FILE" -d "$UNZIPDIR"
	echo "Moving to target location"
    mv "$UNZIPDIR/$MASTERNAME" "$INSTALL_BASE_DIR/$APP_NAME" 
	echo "Removing download"
    rm "$DOWNLOAD_FILE" 
  else 
    echo "Cannot complete setup of the ownCloud example theme as it is corrupted."
    return 1
  fi
}
E_BADARGS=85

# Remembers the directory where this script was called from
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# Check if run as sudo (root), needed for sub script calling and changing file permissions
if (( $EUID != 0 )); then
    echo "Please run this script with sudo or as root"
    exit
fi

# Check if enough parameters have been applied
if (( $# != 2 ))
then
  echo "Not enough arguments provided."
  echo "Usage: $( basename "$0" ) [new theme name] [owncloud root directory]"
  exit $E_BADARGS
fi

# Check if read-config.php file exists in the same directory
if [ ! -f $SCRIPT_DIR/read-config.php ]
then
    echo "File read-config.php not found! Must be in the same dir as this script"
    exit
fi

# Check if php file is set to be executable, script will else not work
if [ ! -x $SCRIPT_DIR/read-config.php ]
then
    echo "File read-config.php is not set executable"
    exit
fi

app_name="$1"
owncloud_root="$2"
apps=$(php "$SCRIPT_DIR/read-config.php" "$owncloud_root")

# Check if the php script returned an error message. This is when the string does not start with /
if [[ ! $apps = '/'* ]]
then
	echo $apps
	echo "Script read-config.php returned no usable app path"
	exit
fi

if clone_example_theme "$app_name" "$apps" 
then
  # Remove the default signature, which will cause a code integrity violation
  [ -f "$apps/$app_name/appinfo/signature.json" ] && rm "$apps/$app_name/appinfo/signature.json"

  # Replace the default theme id / theme name
  echo "Updating theme id / theme name"
  sed -i "s#<id>theme-example<#<id>$app_name<#" "$apps/$app_name/appinfo/info.xml"

  # Set the appropriate permissions
  echo "Setting new theme file permissions"
  chown -R www-data:www-data "$apps/$app_name"

  # Enable the new theme app
  if [ -e "$owncloud_root/occ" ]
  then
    echo "Enabling new theme in ownCloud"
    php "$owncloud_root/occ" app:enable "$app_name"
  else
    echo
    echo "occ command not found, please enable the app manually"
  fi

  echo
  echo "Finished bootstrapping the new theme."
fi
