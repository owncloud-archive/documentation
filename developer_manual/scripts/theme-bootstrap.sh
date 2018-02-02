#!/bin/bash
# theme-bootstrap.sh
# Invoke this script with one argument, the new theme's name.
# Written by Dmitry Mayorov <dmitry@owncloud.com> & Matthew Setter <matthew@matthewsetter.com>
# Copyright (c) ownCloud 2018.
set -e

E_BADARGS=85

if (( $# != 2 ))
then
  echo "Not enough arguments supplied."
  echo "Usage: $( basename "$0" ) [-v] [-h] [theme id] [owncloud directory]"
  exit $E_BADARGS
fi

app_name="$1"
owncloud_directory="$2"
apps="$owncloud_directory/apps"

OLDPWD=${OLDPWD:=$(pwd)}

echo "Bootstrapping theme development."

cd "$owncloud_directory"

# Copy the example theme to your theme
echo 
echo "Copying default theme"
cp -r "$apps/theme-example" "$apps/$app_name"

# Remove the default signature, which will cause a code integrity violation
if [ -f "$apps/$app_name/appinfo/signature.json" ]; then
  echo 
  echo "Removing default signature.json file to avoid code integrity violation"
  rm "$apps/$app_name/appinfo/signature.json"
fi

# Replace the default id
echo 
echo "Updating theme id"
sed -i "s#<id>theme-example<#<id>$app_name<#" "$apps/$app_name/appinfo/info.xml"

# Set the appropriate permissions
echo
echo "Setting theme file permissions"
chown -R www-data:www-data "$apps/$app_name"

# Enable the theme (app)
echo 
echo "Enabling theme"
sudo -u www-data php "$owncloud_directory/occ" app:enable "$app_name"

echo
echo "Finished bootstrapping the new theme."

cd "$OLDPWD" 
