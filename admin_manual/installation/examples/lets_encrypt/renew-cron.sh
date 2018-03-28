#!/bin/bash

LE_PATH="/opt/letsencrypt"
LE_CB="certbot"

"$LE_PATH/$LE_CB" renew --no-self-upgrade --noninteractive
