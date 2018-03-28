#!/bin/bash

LE_PATH="/opt/letsencrypt"
LE_CB="certbot"

read -p "Which certificate do you want to delete: " -r -e answer
if [ -n "$answer" ]; then
  "$LE_PATH/$LE_CB" delete --cert-name "$answer"
fi

