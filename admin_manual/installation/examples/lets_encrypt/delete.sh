#!/bin/bash

LE_PATH="/usr/bin"
LE_CB="certbot"

##
## Retrieve and print a list of the installed Let's Encrypt SSL certificates.
##
function get_certificate_names()
{
  "$LE_PATH/$LE_CB" certificates | grep -iE "certificate name" | awk -F: '{gsub(/\s+/, "", $2); printf("- %s\n", $2)}'
}

echo "Available Certificates:"

get_certificate_names
echo

read -p "Which certificate do you want to delete: " -r -e answer
if [ -n "$answer" ]; then
  "$LE_PATH/$LE_CB" delete --cert-name "$answer"
fi

