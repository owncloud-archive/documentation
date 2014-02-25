Usage
=====

The interval at which this script is executed, and thus the ownCloud registered actions, can depend on the size of the installation and the load of the system.
Recommended intervals are 15 or 30 minutes.

Cron.php needs to be called by the system’s cron daemon and run as the same user the web server runs as.

As an example, on an ordinary Linux distribution, place the following in the webserver’s user’s crontab:

\*/15
*
*
*
* /usr/bin/php -f /srv/http/owncloud/cron.php /dev/null 2>&1


This will run cron.php every 15 minutes and suppress any warnings or output which may be generated.






