=====================
Using the occ Command
=====================

ownCloud's ``occ`` command (ownCloud console) is ownCloud's command-line 
interface. You can perform many common server operations with ``occ``::

* Maintenance tasks
* Manage apps
* Upgrade the ownCloud database
* Reset passwords, including administrator passwords
* List files owned by users
* Convert the ownCloud database from SQLite to a more performant DB
* Query and change LDAP settings

``occ`` is in the :file:`owncloud/` directory; for example 
:file:`/var/www/owncloud` on Ubuntu Linux. ``occ`` is a PHP script. The 
preferred way to run it is as your HTTP user. Running it with no options lists 
all commands and options, like this example on Ubuntu:: 

 $ sudo -u www-data php occ

This is the same as ``sudo -u www-data php occ list``.
 
Run it with the ``-h`` option for syntax help::

 $ sudo -u www-data php occ -h
 
Display your ownCloud version::

 $ sudo -u www-data php occ -V
   ownCloud version 7.0.4
   
Query your ownCloud server status::
 
 $ sudo -u www-data php occ status
   Array
   (
    [installed] => true
    [version] => 7.0.4.2
    [versionstring] => 7.0.4
    [edition] => 
   )
   
``occ`` has options, commands, and arguments. Options and arguments are 
optional, while commands are required. The syntax is::

 occ [options] command [arguments]
 
Get detailed information on individual commands with the ``help`` command, like 
this example for the ``maintenance:mode`` command::
 
 $ sudo -u www-data php occ help maintenance:mode
   Usage:
   maintenance:mode [--on] [--off]

   Options:
   --on                  enable maintenance mode
   --off                 disable maintenance mode
   --help (-h)           Display this help message.
   --quiet (-q)          Do not output any message.
   --verbose (-v|vv|vvv) Increase the verbosity of messages: 1 for normal 
   output, 2 for more verbose output and 3 for debug
   --version (-V)        Display this application version.
   --ansi                Force ANSI output.
   --no-ansi             Disable ANSI output.
   --no-interaction (-n) Do not ask any interactive question.
   
Maintenance Commands
--------------------

These three maintenance commands put your ownCloud server into three modes: maintenance, 
singleuser, and repair.

You must put your ownCloud server into maintenance mode whenever you perform an 
update or upgrade. This locks the sessions of all logged-in users, including 
administrators, and displays a status screen warning that the server is in 
maintenance mode. Users who are not already logged in cannot log in until 
maintenance mode is turned off. When you take the server out of maintenance mode 
logged-in users must refresh their Web browsers to continue working::

 $ sudo -u www-data php occ maintenance:mode --on
 $ sudo -u www-data php occ maintenance:mode --off
 
Putting your ownCloud server into single-user mode allows admins to log in and 
work, but not ordinary users. This is useful for performing maintenance and 
troubleshooting on a running server::

 $ sudo -u www-data php occ maintenance:singleuser --on
   Single user mode enabled
   
And turn it off when you're finished::

 $ sudo -u www-data php occ maintenance:singleuser --off
   Single user mode disabled

TODO: What does  maintenance:repair do? Needs details::
  
  $ sudo -u www-data php occ maintenance:repair
    - Repair mime types  
    - Repair config
 
User Commands
-------------

The ``user`` commands reset passwords, display a simple report showing how 
many users you have, and when a user was last logged in.

You can reset any user's password, including administrators (see 
:doc:`reset_admin_password`). In this example the username is layla::

 $ sudo -u www-data php occ user:resetpassword layla
   Enter a new password: 
   Confirm the new password: 
   Successfully reset password for layla
   
View a user's most recent login::   
   
 $ sudo -u www-data php occ user:lastseen layla 
   layla`s last login: 09.01.2015 18:46
   
TODO: does this count LDAP and other external users, or local only?::

 $ sudo -u www-data php occ user:report
   +------------------+---+
   | User Report      |   |
   +------------------+---+
   | OC_User_Database | 2 |
   |                  |   |
   | total users      | 2 |
   |                  |   |
   | user directories | 3 |
   +------------------+---+
   
Apps Commands
-------------

The ``app`` commands list, enable, and disable apps. This lists all of your 
installed apps, and shows whether they are enabled or disabled::

 $ sudo -u www-data php occ app:list
 
Enable an app::

 $ sudo -u www-data php occ app:enable external
   external enabled
   
Disable an app::

 $ sudo -u www-data php occ app:disable external
   external disabled
   
Upgrade Command
---------------

When you are performing an update or upgrade on your ownCloud server, it is 
better to use ``occ`` to perform the database upgrade step, rather than the Web 
GUI,  in order to avoid timeouts.

TODO: what timeouts? What causes them?

You can perform a dry-run first to see what will happen, without changing 
anything::

 $ sudo -u www-data php occ upgrade --dry-run

When this looks satisfactory, you can go ahead and perform the upgrade::

 $ sudo -u www-data php occ upgrade
 
TODO why would you want to use --skip-migration-test? ::
  
 $ sudo -u www-data php occ upgrade --skip-migration-test
 

File Scanning
-------------

The ``files:scan`` command lists all files belonging to a specified user, and 
all files that belong to all users. This lists all files that belong to user 
layla::

 $ sudo -u www-data php occ files:scan layla
 
This lists all files owned by all of your ownCloud users::

 $ sudo -u www-data php occ files:scan --all

You can store all those filenames in a text file. The file must be created in a 
directory that you have write permissions to, such as your home directory::

  $ sudo -u www-data php occ files:scan layla --all > /home/user/ocfilelist.txt

Database Conversion
-------------------

The SQLite database is good for testing, and for ownCloud servers with small 
workloads, but servers with more than a few users and data files should use 
MariaDB, MySQL, PostgreSQL, or Oracle. You can use ``occ`` to convert from 
SQLite to one of these other databases. You need:

* Your desired database installed and its PHP connector
* The login and password of a database admin user
* The database port number, if it is a non-standard port

This is example converts to MariaDB, and also converts the schema for all 
installed apps:: 

 $ sudo -u www-data php occ db:generate-change-script
 $ sudo -u www-data php occ db:convert-type --all-apps mysql oc_dbuser 127.0.0.1 oc_database

For a more detailed explanation see :doc:`../maintenance/convert_db`   

LDAP Commands
-------------

TODO: explanation of each LDAP command, and example command output

These all do something::

 $ sudo -u www-data php occ ldap:search
 $ sudo -u www-data php occ ldap:set-config
 $ sudo -u www-data php occ ldap:show-config
 $ sudo -u www-data php occ ldap:test-config

 

 




   






 

 
 

 
 



 
   

