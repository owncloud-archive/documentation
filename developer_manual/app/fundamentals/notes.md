owncloud_1  | {"reqId":"QveYQCJXFHyu5nmspxBE","level":3,"time":"2017-07-20T09:28:33+00:00","remoteAddr":"172.19.0.1","user":"admin","app":"index","method":"GET","url":"\/index.php","message":"Exception: {\"Exception\":\"Error\",\"Message\":\"Class 'OCA\\\\FailedLogins\\\\AppInfo\\\\Application' not found\",\"Code\":0,\"Trace\":\"#0 \\\/var\\\/www\\\/owncloud\\\/lib\\\/private\\\/Route\\\/Router.php(353): include_once()\\n#1 \\\/var\\\/www\\\/owncloud\\\/lib\\\/private\\\/Route\\\/Router.php(151): OC\\\\Route\\\\Router->requireRouteFile('\\\/var\\\/www\\\/ownclo...', 'testapp')\\n#2 \\\/var\\\/www\\\/owncloud\\\/lib\\\/private\\\/Route\\\/Router.php(270): OC\\\\Route\\\\Router->loadRoutes()\\n#3 \\\/var\\\/www\\\/owncloud\\\/lib\\\/base.php(918): OC\\\\Route\\\\Router->match('')\\n#4 \\\/var\\\/www\\\/owncloud\\\/index.php(49): OC::handleRequest()\\n#5 {main}\",\"File\":\"\\\/var\\\/www\\\/owncloud\\\/apps\\\/testapp\\\/appinfo\\\/routes.php\",\"Line\":5}"}


www-data@48688230c458: ~/owncloud # ./occ upgrade
ownCloud or one of the apps require upgrade - only a limited number of commands are available
You may use your browser or the occ upgrade command to do the upgrade
Set log level to debug
Turned on maintenance mode
Repair warning: You have incompatible or missing apps enabled that could not be found or updated via the marketplace.
Repair warning: please install app manually with tarball or disable them with:
occ app:disable testapp
OC\RepairException: Upgrade is not possible
Update failed
Maintenance mode is kept active
Reset log level


www-data@48688230c458: ~/owncloud # ./occ app:disable testapp
ownCloud or one of the apps require upgrade - only a limited number of commands are available
You may use your browser or the occ upgrade command to do the upgrade
testapp disabled


www-data@48688230c458: ~/owncloud # ./occ upgrade
ownCloud or one of the apps require upgrade - only a limited number of commands are available
You may use your browser or the occ upgrade command to do the upgrade
Set log level to debug
Updating database schema
Updated database
Updating <failedlogins> ...
Updated <failedlogins> to 0.0.2
Drop old database tables

 Done
 28/28 [============================] 100%
Fix permissions so avatars can be stored again
 Done
 2/2 [============================] 100%
Starting code integrity check...
Finished code integrity check
Update successful
Maintenance mode is kept active
Reset log level


www-data@48688230c458: ~/owncloud # ./occ maintenance:mode --off
ownCloud is in maintenance mode - no app have been loaded

Maintenance mode disabled

## Notes

After you change a route definition, you seem to need to upgrade
