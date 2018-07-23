#!/bin/bash
# theme-bootstrap.sh
# Invoke this script with one argument, the new theme's name.
# Written by Dmitry Mayorov <dmitry@owncloud.com> & Matthew Setter <matthew@matthewsetter.com>
# Copyright (c) ownCloud 2018.

set -e

# Clone a copy of the ownCloud example theme
# It won't override an existing app directory of the same name.
function clone_example_theme
{
  local APP_NAME="$1"
  local INSTALL_BASE_DIR="$2"
  local DOWNLOAD_FILE=/tmp/master.zip
  local THEME_ARCHIVE_URL=https://github.com/owncloud/theme-example/archive/master.zip

  if  [ -d "$INSTALL_BASE_DIR/$APP_NAME" ]
  then
    echo "The example theme ('$INSTALL_BASE_DIR/$APP_NAME') already exists."
    echo "Please remove or rename it before running this script again."
    return 1
  fi;

  echo "Cloning ownCloud example theme."
  echo

  [ -e "$DOWNLOAD_FILE" ] && rm "$DOWNLOAD_FILE"
  wget --output-document=/tmp/master.zip --tries=3 --continue \
    --timeout=3 --dns-timeout=3 --connect-timeout=3 --read-timeout=3  \
    "$THEME_ARCHIVE_URL"

  if unzip -t "$DOWNLOAD_FILE" | grep -q "No errors detected in compressed data"
  then
    cd /tmp > /dev/null || return
    unzip master.zip \
      && mv /tmp/theme-example-master "$INSTALL_BASE_DIR/$APP_NAME" \
      && rm "$DOWNLOAD_FILE"
    cd - > /dev/null || return
  else 
    echo "Cannot complete setup of the ownCloud example theme as it is corrupted."
    return 1
  fi
}

E_BADARGS=85

# Stores the directory where this script was called from
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

if (( $# != 2 ))
then
  echo "Not enough arguments supplied."
  echo "Usage: $( basename "$0" ) [-v] [-h] [theme id] [owncloud directory]"
  exit $E_BADARGS
fi

app_name="$1"
owncloud_directory="$2"
apps=$("$SCRIPT_DIR/read-config.php" "$owncloud_directory")

OLDPWD=${OLDPWD:=$(pwd)}

if clone_example_theme "$app_name" "$apps" 
then
  # Remove the default signature, which will cause a code integrity violation
  [ -f "$apps/$app_name/appinfo/signature.json" ] && rm "$apps/$app_name/appinfo/signature.json"

  # Replace the default id
  echo 
  echo "- Updating theme id"
  sed -i "s#<id>theme-example<#<id>$app_name<#" "$apps/$app_name/appinfo/info.xml"

  # Set the appropriate permissions
  echo "- Setting theme file permissions"
  chown -R www-data:www-data "$apps/$app_name"

  # Enable the theme (app)
  echo "- Enabling theme"
  php "$owncloud_directory/occ" app:enable "$app_name"

  echo
  echo "Finished bootstrapping the new theme."

  cd "$OLDPWD" || return
fi
