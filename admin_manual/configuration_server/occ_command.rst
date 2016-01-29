=====================
Using the occ Command
=====================

ownCloud's ``occ`` command (ownCloud console) is ownCloud's command-line 
interface. You can perform many common server operations with ``occ``, such as 
installing and upgrading ownCloud, manage users, encryption, passwords, LDAP 
setting, and more.

``occ`` is in the :file:`owncloud/` directory; for example 
:file:`/var/www/owncloud` on Ubuntu Linux. ``occ`` is a PHP script. **You must 
run it as your HTTP user** to ensure that the correct permissions are maintained 
on your ownCloud files and directories, and you must run it from its directory.

occ Command Directory
---------------------

* :ref:`http_user_label`
* :ref:`apps_commands_label`
* :ref:`background_jobs_selector_label`
* :ref:`database_conversion_label`
* :ref:`encryption_label`
* :ref:`file_operations_label`
* :ref:`create_javascript_translation_files_label`
* :ref:`maintenance_commands_label`
* :ref:`user_commands_label`

.. _http_user_label:

Run occ As Your HTTP User
-------------------------

The HTTP user is different on the various Linux distributions. See 
:ref:`strong_perms_label` to learn how to find your HTTP user.
   
* The HTTP user and group in Debian/Ubuntu is www-data.
* The HTTP user and group in Fedora/CentOS is apache.
* The HTTP user and group in Arch Linux is http.
* The HTTP user in openSUSE is wwwrun, and the HTTP group is www.   

If your HTTP server is configured to use a different PHP version than the 
default (/usr/bin/php), ``occ`` should be run with the same version. For 
example, in CentOS 6.5 with SCL-PHP54 installed, the command looks like this::

  $ cd /var/www/html/owncloud/
  $ sudo -u apache /opt/rh/php54/root/usr/bin/php occ

Running it with no options lists all commands and options, like this example on 
Ubuntu::

 $ sudo -u www-data php occ
 ownCloud version 8.1
 Usage:
  [options] command [arguments]

 Options:
  --help (-h)           Display this help message
  --quiet (-q)          Do not output any message
  --verbose (-v|vv|vvv) Increase the verbosity of messages: 1 for normal 
                        output, 2 for more verbose output and 3 for debug
  --version (-V)        Display this application version
  --ansi                Force ANSI output
  --no-ansi             Disable ANSI output
  --no-interaction (-n) Do not ask any interactive question

 Available commands:
  check                       check dependencies of the server environment
  help                        Displays help for a command
  list                        Lists commands
  status                      show some status informationb
  upgrade                     run upgrade routines after installation of a new 
                              release. The release has to be installed before.

This is the same as ``sudo -u www-data php occ list``.

Run it with the ``-h`` option for syntax help::

 $ sudo -u www-data php occ -h
 
Display your ownCloud version::

 $ sudo -u www-data php occ -V
   ownCloud version 8.1
   
Query your ownCloud server status::

 $ sudo -u www-data php occ status
   - installed: true
   - version: 8.1.5.2
   - versionstring: 8.1
   - edition:
   
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

The ``status`` command from above has an option to define the output format.
The default is plain text, but it can also be ``json``::

 $ sudo -u www-data php status --output =json
 {"installed":true,"version":"8.1.5.2","versionstring":"8.1.5",
 "edition":"Enterprise"}

or ``json_pretty``::

 $ sudo -u www-data php status --output =json_pretty
 {
     "installed": true,
     "version": "8.1.5.2",
     "versionstring": "8.1.5",
     "edition": "Enterprise"
 }

This ``output`` option is available on all list and list-like commands:
``status``, ``check``, ``app:list``, ``config:list``, ``encryption:status``
and ``encryption:list-modules``

.. _apps_commands_label:

Apps Commands
-------------

The ``app`` commands list, enable, and disable apps::

 app
  app:check-code     check code to be compliant
  app:disable        disable an app
  app:enable         enable an app
  app:list           List all available apps

List all of your installed apps, and show whether they are 
enabled or disabled::

 $ sudo -u www-data php occ app:list
 
Enable an app, for example the External Storage Support app::

 $ sudo -u www-data php occ app:enable files_external
   files_external enabled
   
Disable an app::

 $ sudo -u www-data php occ app:disable files_external
   files_external disabled   
   
``app:check-code`` has multiple checks: it checks if an app uses ownCloud's 
public API (``OCP``) or private API (``OC_``), and it also checks for 
deprecated 
methods and the validity of the ``info.xml`` file. By default all checks are 
enabled. The Activity app is an example of a correctly-formatted app::

 $ sudo -u www-data php occ app:check-code activity
   App is compliant - awesome job!

If your app has issues, you'll see output like this::

 $ sudo -u www-data php occ app:check-code foo_app
   Analysing /opt/owncloud/apps/foo_app/events/event/ruleevent.php
   1 errors
    line   33: OC_L10N - private class must not be instantiated
   Analysing /opt/owncloud/apps/foo_app/events/listeners/failurelistener.php
   1 errors
    line   46: OC_User - Static method of private class must not be called
   PHP Fatal error:  Call to undefined method 
   PhpParser\Node\Expr\Variable::toString() in 
   /opt/owncloud/lib/private/app/codechecker/nodevisitor.php on line 171 

.. _background_jobs_selector_label:   
   
Background Jobs Selector
------------------------

Use the ``background`` command to select which scheduler you want to use for 
controlling background jobs, Ajax, Webcron, or Cron. This is the same as using 
the **Cron** section on your ownCloud Admin page::

 background
  background:ajax       Use ajax to run background jobs
  background:cron       Use cron to run background jobs
  background:webcron    Use webcron to run background jobs

This example selects Ajax::

 $ sudo -u www-data php occ background:ajax
   Set mode for background jobs to 'ajax'

The other two commands are:

* ``background:cron``
* ``background:webcron``

See :doc:`../configuration_server/background_jobs_configuration` to learn more.

.. _database_conversion_label:
  
Database Conversion
-------------------

The SQLite database is good for testing, and for ownCloud servers with small 
single-user workloads that do not use sync clients, but production servers with 
multiple users should use MariaDB, MySQL, or PostgreSQL. You can use ``occ`` to 
convert from SQLite to one of these other databases.

::

 db
  db:convert-type           Convert the ownCloud database to the newly 
                            configured one
  db:generate-change-script generates the change script from the current 
                            connected db to db_structure.xml

You need:

* Your desired database and its PHP connector installed.
* The login and password of a database admin user.
* The database port number, if it is a non-standard port.

This is example converts SQLite to MySQL/MariaDB:: 

 $ sudo -u www-data php occ db:convert-type mysql oc_dbuser 127.0.0.1 
 oc_database

For a more detailed explanation see 
:doc:`../configuration_database/db_conversion`

.. _encryption_label:

Encryption
----------

ownCloud 8.2 introduces a new set of encryption commands::

 encryption
  encryption:disable                   Disable encryption
  encryption:enable                    Enable encryption
  encryption:list-modules              List all available encryption modules
  encryption:set-default-module        Set the encryption default module
  encryption:status                    Lists the current status of encryption

``encryption:status`` shows whether you have active encryption, and your default 
encryption module. To enable encryption you must first enable the Encryption 
app, and then run ``encryption:enable``::

 $ sudo -u www-data php occ app:enable encryption
 $ sudo -u www-data php occ encryption:enable
 $ sudo -u www-data php occ encryption:status
  - enabled: true
  - defaultModule: OC_DEFAULT_MODULE

Use ``encryption:disable`` to disable your encryption module. You must first put 
your ownCloud server into :ref:`single-user mode <maintenance_commands_label>` 
to prevent any user activity.

``encryption:list-modules`` displays your available encryption modules. You will 
see a list of modules only if you have enabled the Encryption app. Use 
``encryption:set-default-module [module name]`` to set your desired module.

See :doc:`../configuration_files/encryption_configuration` to learn more.

.. _file_operations_label:

File Operations
---------------

``occ`` has two commands for managing files in ownCloud::

 files
  files:cleanup      cleanup filecache
  files:scan         rescan filesystem

The ``files:scan`` command scans for new files and updates the file cache. You 
may rescan all files, per-user, a space-delimited list of users, and limit the 
search path. If not using ``--quiet``, statistics will be shown at the end of 
the scan::

 $ sudo -u www-data php occ files:scan --help
   Usage:
   files:scan [-p|--path="..."] [-q|--quiet] [-v|vv|vvv --verbose] [--all] 
   [user_id1] ... [user_idN]

 Arguments:
   user_id               will rescan all files of the given user(s)

 Options:
   --path                limit rescan to the user/path given
   --all                 will rescan all files of all known users
   --quiet               suppress any output
   --verbose             files and directories being processed are shown 
                         additionally during scanning

Verbosity levels of ``-vv`` or ``-vvv`` are automatically reset to ``-v``

When using the ``--path`` option, the path must consist of following 
components::

  "user_id/files/path" 
    or
  "user_id/files/mount_name"
    or
  "user_id/files/mount_name/path"

where the term ``files`` is mandatory.

Example::

  --path="/alice/files/Music"

In the example above, the user_id ``alice`` is determined implicitly from the 
path component given.

The ``--path``, ``--all`` and ``[user_id]`` parameters and are exclusive - only 
one must be specified.

``files:cleanup`` tidies up the server's file cache by deleting all file 
entries that have no matching entries in the storage table.

.. _create_javascript_translation_files_label:
 
l10n, Create Javascript Translation Files for Apps
--------------------------------------------------

This command is for app developers to update their translation mechanism from
ownCloud 7 to ownCloud 8 and later.

.. _maintenance_commands_label:
   
Maintenance Commands
--------------------

Use these commands when you upgrade ownCloud, manage encryption, perform 
backups and other tasks that require locking users out until you are finished::

 maintenance
  maintenance:mode                     set maintenance mode
  maintenance:repair                   repair this installation
  maintenance:singleuser               set single user mode

``maintenance:mode`` locks the sessions of all logged-in users, including 
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
   
Turn it off when you're finished::

 $ sudo -u www-data php occ maintenance:singleuser --off
   Single user mode disabled

The ``maintenance:repair`` command runs automatically during upgrades to clean 
up the database, so while you can run it manually there usually isn't a need 
to::
  
  $ sudo -u www-data php occ maintenance:repair
     - Repair mime types
 - Repair legacy storages
 - Repair config
 - Clear asset cache after upgrade
     - Asset pipeline disabled -> nothing to do
 - Generate ETags for file where no ETag is present.
     - ETags have been fixed for 0 files/folders.
 - Clean tags and favorites
     - 0 tags for delete files have been removed.
     - 0 tag entries for deleted tags have been removed.
     - 0 tags with no entries have been removed.
 - Re-enable file app

.. _user_commands_label: 
 
User Commands
-------------

The ``user`` commands create and remove users, reset passwords, display a 
simple 
report showing how many users you have, and when a user was last logged in::

 user
  user:add            adds a user
  user:delete         deletes the specified user
  user:lastseen       shows when the user was logged it last 
                      time
  user:report         shows how many users have access
  user:resetpassword  Resets the password of the named user

You can create a new user with their display name, login name, and any group 
memberships with the ``user:add`` command. The syntax is::

 user:add [--password-from-env] [--display-name[="..."]] [-g|--group[="..."]] 
 uid

The ``display-name`` corresponds to the **Full Name** on the Users page in your 
ownCloud Web UI, and the ``uid`` is their **Username**, which is their 
login name. This example adds new user Layla Smith, and adds her to the 
**users** and **db-admins** groups. Any groups that do not exist are created:: 
 
 $ sudo -u www-data php occ user:add --display-name="Layla Smith" 
   --group="users" --group="db-admins" layla
   Enter password: 
   Confirm password: 
   The user "layla" was created successfully
   Display name set to "Layla Smith"
   User "layla" added to group "users"
   User "layla" added to group "db-admins"

Go to your Users page, and you will see your new user.   

``password-from-env`` allows you to set the user's password from an environment 
variable. This prevents the password from being exposed to all users via the 
process list, and will only be visible in the history of the user (root) 
running the command. This also permits creating scripts for adding multiple new 
users.

To use ``password-from-env`` you must run as "real" root, rather than ``sudo``, 
because ``sudo`` strips environment variables. This example adds new user Fred 
Jones::

 # export OC_PASS=newpassword
 # su -s /bin/sh www-data -c 'php occ user:add --password-from-env 
   --display-name="Fred Jones" --group="users" fred'
 The user "fred" was created successfully
 Display name set to "Fred Jones"
 User "fred" added to group "users" 

You can reset any user's password, including administrators (see 
:doc:`../configuration_user/reset_admin_password`)::

 $ sudo -u www-data php occ user:resetpassword layla
   Enter a new password: 
   Confirm the new password: 
   Successfully reset password for layla
   
You may also use ``password-from-env`` to reset passwords::

 # export OC_PASS=newpassword
 # su -s /bin/sh www-data -c 'php occ user:resetpassword --password-from-env 
   layla'
   Successfully reset password for layla
   
You can delete users::

 $ sudo -u www-data php occ user:delete fred
   
View a user's most recent login::   
   
 $ sudo -u www-data php occ user:lastseen layla 
   layla's last login: 09.01.2015 18:46
   
Generate a simple report that counts all users, including users on external user
authentication servers such as LDAP::

 $ sudo -u www-data php occ user:report
 +------------------+----+
 | User Report      |    |
 +------------------+----+
 | Database         | 12 |
 | LDAP             | 86 |
 |                  |    |
 | total users      | 98 |
 |                  |    |
 | user directories | 2  |
 +------------------+----+
