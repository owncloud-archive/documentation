#!/bin/bash

##
## Variable Declaration
##
SERVER_URI=https://localhost
API_PATH=/ocs/v1.php/apps/files_sharing/api/v1/sharees?format=json

curl --user admin:admin "$SERVER_URI/$API_PATH&itemType=1&shareType=0&perPage=1" \
  --insecure
