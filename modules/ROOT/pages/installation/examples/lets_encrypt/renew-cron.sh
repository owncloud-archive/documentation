#!/bin/bash

LE_PATH="/usr/bin"
LE_CB="certbot"

"$LE_PATH/$LE_CB" renew --no-self-upgrade --noninteractive
