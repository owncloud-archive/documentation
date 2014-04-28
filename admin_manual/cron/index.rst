========================
Driving Events with Cron
========================

Introduction
============

ownCloud is written in PHP, and because PHP is a request driven language – in
other words it runs only when a client takes an action and calls php, and then
it executes and ends – it does not have a built in CRON process. Instead,
ownCloud provides ``cron.php``, which is called by the server’s CRON daemon.
``cron.php`` is an ownCloud internal process that runs various background jobs
on demand.  It is called by the server cron, and can be set by the
administrator.

ownCloud plug-in applications register actions with ``cron.php`` automatically to
take care of typical housekeeping operations, such as garbage collecting of
temporary files or checking for newly updated files using ``filescan()`` for
externally mounted file systems.

Usage
=====

The interval at which this script is executed, and thus the ownCloud registered
actions, can depend on the size of the installation and the load of the system.
Recommended intervals are 15 or 30 minutes.

Cron.php needs to be called by the system’s cron daemon and run as the same
user the web server runs as.

As an example, on an ordinary Linux distribution, place the following in the
web server’s user’s crontab::

    */15 * * * * /usr/bin/php -f /srv/http/owncloud/cron.php /dev/null 2>&1

This will run ``cron.php`` every 15 minutes and suppress any warnings or output
which may be generated.
