#!/bin/bash

##
## Variable Declaration
##
SERVER_URI=https://your.owncloud.install.com/owncloud
API_PATH=ocs/v1.php/apps/files_sharing/api/v1

curl --user your.username:your.password "$SERVER_URI/$API_PATH/shares/115464"
