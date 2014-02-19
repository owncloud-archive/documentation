Introduction
============

ownCloud is written in PHP, and because PHP is a request driven language – in other words it runs only when a client takes an action and calls php, and then it executes and ends – it does not have a built in CRON process. Instead, ownCloud provides Cron.php, which is called by the server’s CRON daemon. Cron.php is an ownCloud internal process that runs various background jobs on demand.
It is called by the server cron, and can be set by the administrator. ownCloud plug-in applications register actions with cron.php automatically to take care of typical housekeeping operations, such as garbage collecting of temporary files or checking for newly updated files using filescan() for externally mounted file systems.
