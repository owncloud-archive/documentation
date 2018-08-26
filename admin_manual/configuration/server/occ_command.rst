=======================
Using occ core commands
=======================

This command description references to ownCloud core commands only.

ownCloud's ``occ`` command (ownCloud console) is ownCloud's command-line interface.
You can perform many common server operations with ``occ``, such as installing and upgrading ownCloud, managing users and groups, encryption, passwords, LDAP setting, and more.

``occ`` is in the :file:`owncloud/` directory; for example :file:`/var/www/owncloud` on Ubuntu Linux. 
``occ`` is a PHP script. 
**You must run it as your HTTP user** to ensure that the correct permissions are maintained on your ownCloud files and directories. 

occ Command Directory
---------------------

* :ref:`http_user_label`
* :ref:`apps_commands_label`
* :ref:`background_jobs_selector_label`
* :ref:`config_commands_label`
* :ref:`dav_label`
* :ref:`database_conversion_label`
* :ref:`encryption_label`
* :ref:`federation_sync_label`
* :ref:`file_operations_label`
* :ref:`files_external_label`
* :ref:`group_commands_label`
* :ref:`integrity_check_label`
* :ref:`create_javascript_translation_files_label`
* :ref:`logging_commands_label`
* :ref:`maintenance_commands_label`
* :ref:`security_commands_label`
* :ref:`trashbin_label`
* :ref:`user_commands_label`
* :ref:`versions_label`
* :ref:`command_line_installation_label`
* :ref:`command_line_upgrade_label`
* :ref:`disable_user_label`

.. _http_user_label:

Run occ As Your HTTP User
-------------------------

The HTTP user is different on the various Linux distributions. 
See :ref:`strong_perms_label` to learn how to find your HTTP user.
   
* The HTTP user and group in Debian/Ubuntu is www-data.
* The HTTP user and group in Fedora/CentOS is apache.
* The HTTP user and group in Arch Linux is http.
* The HTTP user in openSUSE is wwwrun, and the HTTP group is www.   

If your HTTP server is configured to use a different PHP version than the default (/usr/bin/php), ``occ`` should be run with the same version. 
For example, in CentOS 6.5 with SCL-PHP54 installed, the command looks like this::

  sudo -u apache /opt/rh/php54/root/usr/bin/php /var/www/html/owncloud/occ

The following examples are based on Ubuntu.

Running ``occ`` with no options lists all commands and options

::

 sudo -u www-data php occ 
 ownCloud version 10.0.8

 Usage:
  command [options] [arguments]

 Options:
  -h, --help            Display this help message
  -q, --quiet           Do not output any message
  -V, --version         Display this application version
      --ansi            Force ANSI output
      --no-ansi         Disable ANSI output
  -n, --no-interaction  Do not ask any interactive question
      --no-warnings     Skip global warnings, show command output only
  -v|vv|vvv, --verbose  Increase the verbosity of messages: 1 for normal output, 
                        2 for more verbose output and 3 for debug

 Available commands:
  check                 Check dependencies of the server environment
  help                  Displays help for a command
  list                  Lists commands
  status                Show some status information
  upgrade               Run upgrade routines after installation of 
                        a new release. The release has to be installed before

This is the same as ``sudo -u www-data php occ list``.

General syntax help
~~~~~~~~~~~~~~~~~~~

Run occ with the ``-h`` option for syntax help

::

 sudo -u www-data php occ -h
 
Display your ownCloud version
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

 sudo -u www-data php occ -V
   ownCloud version 10.0.8
   
Query your ownCloud server status
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

 sudo -u www-data php occ status
   - installed: true
   - version: 10.0.8.5
   - versionstring: 10.0.8
   - edition: Community

Command syntax help
~~~~~~~~~~~~~~~~~~~

Get detailed information on individual commands with the ``help`` command, like this example for the ``maintenance:mode`` command

::

 sudo -u www-data php occ --help maintenance:mode
 Usage:
  maintenance:mode [options]

 Options:
      --on              Enable maintenance mode
      --off             Disable maintenance mode
      --output[=OUTPUT] Output format (plain, json or json_pretty, default is plain) [default: "plain"]
  -h, --help            Display this help message
  -q, --quiet           Do not output any message
  -V, --version         Display this application version
      --ansi            Force ANSI output
      --no-ansi         Disable ANSI output
  -n, --no-interaction  Do not ask any interactive question
      --no-warnings     Skip global warnings, show command output only
  -v|vv|vvv, --verbose  Increase the verbosity of messages: 1 for normal output, 
                        2 for more verbose output and 3 for debug

Options and Arguments
~~~~~~~~~~~~~~~~~~~~~

``occ`` has *options*, *commands*, and *arguments*. 
Commands are required.
Options are optional.
Arguments can be required *or* optional.
The, generic, syntax is

::

 occ [options] command [arguments]
 
The ``status`` command from above has an option to define the output format.

The default is plain text, but it can also be ``json``

::

 sudo -u www-data php occ status --output=json
 {"installed":true,"version":"9.0.0.19","versionstring":"9.0.0","edition":""}

or ``json_pretty``

::

 sudo -u www-data php occ status --output=json_pretty
 {
    "installed": true,
    "version": "10.0.8.5",
    "versionstring": "10.0.8",
    "edition": "Community"
 }

This output option is available on all list and list-like commands, which include ``status``, ``check``, ``app:list``, ``config:list``, ``encryption:status`` and ``encryption:list-modules``.

Usage of parameters in Options
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In case an option requires parameters, following format should be used for short or long Options forms

The following example command has an option in ``-p`` (short) form and ``--path`` (long) form.

Parameters for long form options will be written after a blank or equal sign  

::

 sudo -u www-data ./occ files:scan --path="user_x/files/folder"
 
Parameters for short form options will be written either directly after the option or after a blank.
Do not use the equal sign as this could be interpreted as part of the parameter.

::

 sudo -u www-data ./occ files:scan -p "user_x/files/folder"  

.. _apps_commands_label:

Commands managing Apps
----------------------

The ``app`` commands list, enable, and disable apps

::

 app
  app:check-code   check code to be compliant
  app:disable      disable an app
  app:enable       enable an app
  app:getpath      Get an absolute path to the app directory
  app:list         List all available apps

List all of your installed apps or optionally provide a search pattern to restrict the list of apps to those whose name matches the given regular expression.
The output shows whether they are enabled or disabled

::

 sudo -u www-data php occ app:list [<search-pattern>]
 
Enable an app, for example the Market app

::

 sudo -u www-data php occ app:enable market
 market enabled

Disable an app

::

 sudo -u www-data php occ app:disable market
 market disabled

.. note::
   Be aware that the following apps cannot be disabled: *DAV*, *FederatedFileSharing*, *Files* and *Files_External*.

``app:check-code`` has multiple checks: it checks if an app uses ownCloud's public API (``OCP``) or private API (``OC_``), and it also checks for deprecated methods and the validity of the ``info.xml`` file.
By default all checks are enabled.
The Activity app is an example of a correctly-formatted app

::

 sudo -u www-data php occ app:check-code notifications
 App is compliant - awesome job!

If your app has issues, you'll see output like this

::

 sudo -u www-data php occ app:check-code foo_app
 Analysing /var/www/owncloud/apps/files/foo_app.php
 4 errors
    line   45: OCP\Response - Static method of deprecated class must not be 
    called
    line   46: OCP\Response - Static method of deprecated class must not be 
    called
    line   47: OCP\Response - Static method of deprecated class must not be 
    called
    line   49: OC_Util - Static method of private class must not be called

You can get the full file path to an app

::
    
    sudo -u www-data php occ app:getpath notifications
    /var/www/owncloud/apps/notifications

.. note::
   Please see the command set ``market`` for managing apps (install, uninstall ect) from the marketplace


.. _background_jobs_selector_label:   
   
Background Jobs Selector
------------------------

Use the ``background`` command to select which scheduler you want to use for controlling *background jobs*, *Ajax*, *Webcron*, or *Cron*. 
This is the same as using the **Cron** section on your ownCloud Admin page.

.. code-block:: console

 background
  background:ajax       Use ajax to run background jobs
  background:cron       Use cron to run background jobs
  background:webcron    Use webcron to run background jobs

This example selects Ajax::

 sudo -u www-data php occ background:ajax
   Set mode for background jobs to 'ajax'

The other two commands are:

* ``background:cron``
* ``background:webcron``

See :doc:`../../configuration/server/background_jobs_configuration` to learn more.

.. _config_commands_label:

Config Commands
---------------

The ``config`` commands are used to configure the ownCloud server.

::

 config
  config:app:delete      Delete an app config value
  config:app:get         Get an app config value
  config:app:set         Set an app config value
  config:import          Import a list of configuration settings
  config:list            List all configuration settings
  config:system:delete   Delete a system config value
  config:system:get      Get a system config value
  config:system:set      Set a system config value

You can list all configuration values with one command:

::

 sudo -u www-data php occ config:list

By default, passwords and other sensitive data are omitted from the report, so the output can be posted publicly (e.g., as part of a bug report). 
In order to generate a full backport of all configuration values the ``--private`` flag needs to be set:

::

 sudo -u www-data php occ config:list --private

The exported content can also be imported again to allow the fast setup of similar instances. 
The import command will only add or update values. 
Values that exist in the current configuration, but not in the one that is being imported are left untouched. 

::

 sudo -u www-data php occ config:import filename.json

It is also possible to import remote files, by piping the input:

::

 sudo -u www-data php occ config:import < local-backup.json

.. note::

  While it is possible to update/set/delete the versions and installation
  statuses of apps and ownCloud itself, it is **not** recommended to do this
  directly. Use the ``occ app:enable``, ``occ app:disable`` and ``occ update``
  commands instead.  

Getting a Single Configuration Value
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

These commands get the value of a single app or system configuration:

::

  sudo -u www-data php occ config:system:get version
  10.0.8.5

  sudo -u www-data php occ config:app:get activity installed_version
  2.2.1

Setting a Single Configuration Value
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

These commands set the value of a single app or system configuration:

::

  sudo -u www-data php occ config:system:set logtimezone 
     --value="Europe/Berlin"
  System config value logtimezone set to Europe/Berlin

  sudo -u www-data php occ config:app:set files_sharing 
  incoming_server2server_share_enabled --value="yes" --type=boolean
  Config value incoming_server2server_share_enabled for app files_sharing set to yes

The ``config:system:set`` command creates the value, if it does not already exist. 
To update an existing value,  set ``--update-only``:

::

  sudo -u www-data php occ config:system:set doesnotexist --value="true" 
     --type=boolean --update-only
  Value not updated, as it has not been set before.

Note that in order to write a Boolean, float, or integer value to the configuration file, you need to specify the type on your command. 
This applies only to the ``config:system:set`` command. The following values are known:

* ``boolean``
* ``integer``
* ``float``
* ``string`` (default)

When you want to e.g., disable the maintenance mode run the following command:

::

  sudo -u www-data php occ config:system:set maintenance --value=false 
     --type=boolean
  ownCloud is in maintenance mode - no app have been loaded
  System config value maintenance set to boolean false

Setting an Array of Configuration Values
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Some configurations (e.g., the trusted domain setting) are an array of data.
In order to set (and also get) the value of one key, you can specify multiple ``config`` names separated by spaces:

::

  sudo -u www-data php occ config:system:get trusted_domains localhost owncloud.local sample.tld

To replace ``sample.tld`` with ``example.com`` trusted_domains => 2 needs to be set:

::

  sudo -u www-data php occ config:system:set trusted_domains 2 
     --value=example.com
  System config value trusted_domains => 2 set to string example.com

  sudo -u www-data php occ config:system:get trusted_domains localhost owncloud.local example.com

Deleting a Single Configuration Value
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

These commands delete the configuration of an app or system configuration:

::

  sudo -u www-data php occ config:system:delete maintenance:mode
  System config value maintenance:mode deleted

  sudo -u www-data php occ config:app:delete appname provisioning_api
  Config value provisioning_api of app appname deleted

The delete command will by default not complain if the configuration was not set before. 
If you want to be notified in that case, set the ``--error-if-not-exists`` flag.

::

  sudo -u www-data php occ config:system:delete doesnotexist --error-if-not-exists
  Config provisioning_api of app appname could not be deleted because it did not exist
  
.. _dav_label:  
   
Dav Commands
------------
  
A set of commands to create address books, calendars, and to migrate address books:

.. code-block:: console

 dav
  dav:cleanup-chunks            Cleanup outdated chunks
  dav:create-addressbook        Create a dav address book
  dav:create-calendar           Create a dav calendar
  dav:sync-birthday-calendar    Synchronizes the birthday calendar
  dav:sync-system-addressbook   Synchronizes users to the system address book
                                      
.. note::
  These commands are not available in :ref:`single-user (maintenance) mode <maintenance_commands_label>`.

``dav:cleanup-chunks`` cleans up outdated chunks (uploaded files) more than a certain number of days old.
By default, the command cleans up chunks more than 2 days old. 
However, by supplying the number of days to the command, the range can be increased.
For example, in the example below, chunks older than 10 days will be removed.

::

 sudo -u www-data php occ dav:cleanup-chunks 10
 
 # example output
 Cleaning chunks older than 10 days(2017-11-08T13:13:45+00:00)
 Cleaning chunks for admin
    0 [>---------------------------]

The syntax for ``dav:create-addressbook`` and  ``dav:create-calendar`` is 
``dav:create-addressbook [user] [name]``. This example creates the addressbook 
``mollybook`` for the user molly::

 sudo -u www-data php occ dav:create-addressbook molly mollybook

This example creates a new calendar for molly:

::

 sudo -u www-data php occ dav:create-calendar molly mollycal
 
Molly will immediately see these on her Calendar and Contacts pages.
Your existing calendars and contacts should migrate automatically when you upgrade. 
If something goes wrong you can try a manual migration. 
First delete any partially-migrated calendars or address books. 
Then run this command to migrate user's contacts:

::

 sudo -u www-data php occ dav:migrate-addressbooks [user]
 
Run this command to migrate calendars:

::

 sudo -u www-data php occ dav:migrate-calendars [user]

``dav:sync-birthday-calendar`` adds all birthdays to your calendar from address books shared with you. 
This example syncs to your calendar from user ``bernie``:

::

 sudo -u www-data php occ dav:sync-birthday-calendar bernie
 
``dav:sync-system-addressbook`` synchronizes all users to the system addressbook.

::

 sudo -u www-data php occ dav:sync-system-addressbook

.. _database_conversion_label:  
  
Database Conversion
-------------------

The SQLite database is good for testing, and for ownCloud servers with small single-user workloads that do not use sync clients, but production servers with multiple users should use MariaDB, MySQL, or PostgreSQL. 
You can use ``occ`` to convert from SQLite to one of these other databases.

.. code-block:: console

 db
  db:convert-type           Convert the ownCloud database to the newly configured one
  db:generate-change-script Generates the change script from the current 
                            connected db to db_structure.xml

You need:

* Your desired database and its PHP connector installed.
* The login and password of a database admin user.
* The database port number, if it is a non-standard port.

This is example converts SQLite to MySQL/MariaDB:

:: 

 sudo -u www-data php occ db:convert-type mysql oc_dbuser 127.0.0.1 oc_database

For a more detailed explanation see :doc:`../../configuration/database/db_conversion`.

.. _encryption_label:

Encryption
----------

``occ`` includes a complete set of commands for managing encryption.

.. code-block:: console

 encryption
  encryption:change-key-storage-root  Change key storage root
  encryption:decrypt-all              Disable server-side encryption and decrypt all files
  encryption:disable                  Disable encryption
  encryption:enable                   Enable encryption
  encryption:encrypt-all              Encrypt all files for all users
  encryption:list-modules             List all available encryption modules
  encryption:migrate                  initial migration to encryption 2.0
  encryption:recreate-master-key      Replace existing master key with new one. Encrypt the file system with 
                                      newly created master key
  encryption:select-encryption-type   Select the encryption type. The encryption types available are: masterkey and 
                                      user-keys. There is also no way to disable it again.
  encryption:set-default-module       Set the encryption default module
  encryption:show-key-storage-root    Show current key storage root
  encryption:status                   Lists the current status of encryption
  
``encryption:status`` shows whether you have active encryption, and your default encryption module. 
To enable encryption you must first enable the Encryption app, and then run ``encryption:enable``:

::

 sudo -u www-data php occ app:enable encryption
 sudo -u www-data php occ encryption:enable
 sudo -u www-data php occ encryption:status
  - enabled: true
  - defaultModule: OC_DEFAULT_MODULE
   
``encryption:change-key-storage-root`` is for moving your encryption keys to a different folder. 
It takes one argument, ``newRoot``, which defines your new root folder. 
The folder must exist, and the path is relative to your root ownCloud directory.

::

 sudo -u www-data php occ encryption:change-key-storage-root ../../etc/oc-keys
 
You can see the current location of your keys folder::

 sudo -u www-data php occ encryption:show-key-storage-root
 Current key storage root:  default storage location (data/)
 
``encryption:list-modules`` displays your available encryption modules. 
You will see a list of modules only if you have enabled the Encryption app. 
Use ``encryption:set-default-module [module name]`` to set your desired module.

``encryption:encrypt-all`` encrypts all data files for all users. 
You must first put your ownCloud server into :ref:`single-user mode<maintenance_commands_label>` to prevent any user activity until encryption is completed.

``encryption:decrypt-all`` decrypts all user data files, or optionally a single user:

::

 sudo -u www-data php occ encryption:decrypt freda

Users must have enabled recovery keys on their Personal pages. 
You must first put your ownCloud server into :ref:`single-user mode <maintenance_commands_label>` to prevent any user activity until decryption is completed.

Use ``encryption:disable`` to disable your encryption module. 
You must first put your ownCloud server into :ref:`single-user mode <maintenance_commands_label>` to prevent any user activity.

``encryption:migrate`` migrates encryption keys after a major ownCloud version upgrade. 
You may optionally specify individual users in a space-delimited list.
See :doc:`../../configuration/files/encryption_configuration` to learn more.
 
``encryption:recreate-master-key`` decrypts the ownCloud file system, replaces the existing master key with a new one, and encrypts the entire ownCloud file system with the new master key. Given the size of your ownCloud filesystem, this may take some time to complete. However, if your filesystem is quite small, then it will complete quite quickly. The ``-y`` switch can be supplied to automate acceptance of user input.
 
.. _federation_sync_label:
 
Federation Sync
---------------

Synchronize the address books of all federated ownCloud servers.

.. code-block:: console

 federation:sync-addressbooks  Synchronizes address books of all federated clouds

Servers connected with federation shares can share user address books, and auto-complete usernames in share dialogs. 
Use this command to synchronize federated servers:

::

  sudo -u www-data php occ federation:sync-addressbooks
  
.. note::
  This command is only available when the "Federation" app (``federation``) is enabled.

.. _file_operations_label:

File Operations
---------------

``occ`` has three commands for managing files in ownCloud.

.. code-block:: console

 files
  files:checksums:verify     Get all checksums in filecache and compares them by
                             recalculating the checksum of the file.
  files:cleanup              Deletes orphaned file cache entries.
  files:scan                 Rescans the filesystem.
  files:transfer-ownership   All files and folders are moved to another user 
                             - outgoing shares are moved as well (incoming shares are 
                             not moved as the sharing user holds the ownership of the respective files).
 
.. note::
  These commands are not available in :ref:`single-user (maintenance) mode <maintenance_commands_label>`.

The files:checksums:verify command
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

ownCloud supports file integrity checking, by computing and matching checksums.
Doing so ensures that transferred files arrive at their target in the exact state as they left their origin.

In some rare cases, wrong checksums are written to the database which leads to synchronization issues, such as with the Desktop Client.
To mitigate such problems a new command is available: ``occ files:checksums:verify``.

Executing the command recalculates checksums, either for all files of a user or within a specified filesystem path on the designated storage.
It then compares them with the values in the database.
The command also offers an option to repair incorrect checksum values (``-r, --repair``).

.. note:: 
  Executing this command might take some time depending on the file count.

Below is sample output that you can expect to see when using the command.

::

  ./occ files:checksums:verify
  This operation might take very long.
  Mismatch for files/welcome.txt:
   Filecache:	SHA1:eeb2c08011374d8ad4e483a4938e1aa1007c089d MD5:368e3a6cb99f88c3543123931d786e21 ADLER32:c5ad3a63
   Actual:	SHA1:da39a3ee5e6b4b0d3255bfef95601890afd80709 MD5:d41d8cd98f00b204e9800998ecf8427e ADLER32:00000001
  Mismatch for thumbnails/9/2048-2048-max.png:
   Filecache:	SHA1:2634fed078d1978f24f71892bf4ee0e4bd0c3c99 MD5:dd249372f7a68c551f7e6b2615d49463 ADLER32:821230d4
   Actual:	SHA1:da39a3ee5e6b4b0d3255bfef95601890afd80709 MD5:d41d8cd98f00b204e9800998ecf8427e ADLER32:00000001

The files:cleanup command
~~~~~~~~~~~~~~~~~~~~~~~~~

``files:cleanup`` tidies up the server's file cache by deleting all file entries that have no matching entries in the storage table. 

The files:scan command
~~~~~~~~~~~~~~~~~~~~~~

The ``files:scan`` command 

- Scans for new files.
- Scans not fully scanned files.
- Repairs file cache holes.
- Updates the file cache.

File scans can be performed per-user, for a space-delimited list of users, for groups of users, and for all users.

::

 sudo -u www-data php occ files:scan --help
  Usage:
    files:scan [options] [--] [<user_id>]...

  Arguments:
    user_id                Will rescan all files of the given user(s)

  Options:
        --output[=OUTPUT]  Output format (plain, json or json_pretty, default is plain) [default: "plain"]
    -p, --path=PATH        Limit rescan to this path, eg. --path="/alice/files/Music", the user_id is determined by the path and the user_id parameter and --all are ignored
    -g, --groups=GROUPS    Scan user(s) under the group(s). This option can be used as --groups=foo,bar to scan groups foo and bar
    -q, --quiet            Do not output any message
        --all              Will rescan all files of all known users
        --repair           Will repair detached filecache entries (slow)
        --unscanned        Only scan files which are marked as not fully scanned
    -h, --help             Display this help message
    -V, --version          Display this application version
        --ansi             Force ANSI output
        --no-ansi          Disable ANSI output
    -n, --no-interaction   Do not ask any interactive question
        --no-warnings      Skip global warnings, show command output only
    -v|vv|vvv, --verbose   Increase the verbosity of messages: 1 for normal output, 2 for more verbose output and 3 for debug
   
.. note::
  If not using ``--quiet``, statistics will be shown at the end of the scan.

The ``--path`` Option
~~~~~~~~~~~~~~~~~~~~~

When using the ``--path`` option, the path must be in one of the following formats:

::

  "user_id/files/path" 
  "user_id/files/mount_name"
  "user_id/files/mount_name/path"

For example:

::

  --path="/alice/files/Music"

In the example above, the user_id ``alice`` is determined implicitly from the path component given.

To get a list of scannable mounts for a given user, use following command:

::

  sudo -u www-data php occ files_external:list user_id
  
.. note::
  Mounts are only scannable at the point of origin. Scanning of shares including federated shares 
  is not necessary on the receiver side and therefore not possible.

The ``--path``, ``--all``, ``--groups`` and ``[user_id]`` parameters are exclusive - only one must be specified.

The ``--repair`` Option
~~~~~~~~~~~~~~~~~~~~~~~

As noted above, repairs can be performed for individual users, groups of users, and for all users in an ownCloud installation.
What's more, repair scans can be run even if no files are known to need repairing and if one or more files are known to be in need of repair.
Two examples of when files need repairing are:

- If folders have the same entry twice in the web UI (known as a "*ghost folder*"), this can also lead to strange error messages in the desktop client.
- If entering a folder doesn't seem to lead into that folder.

The repair command needs to be run in single user mode. 
The following commands show how to enable single user mode, run a repair file scan, and then disable single user mode.

::

  sudo -u www-data php occ maintenance:singleuser --on
  sudo -u www-data php occ files:scan --all --repair
  sudo -u www-data php occ maintenance:singleuser --off

.. note:: 
   We strongly suggest that you backup the database before running this command.

The files:transfer-ownership command
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You may transfer all files and shares from one user to another. 
This is useful before removing a user. 
For example, to move all files from ``<source-user>`` to ``<destination-user>``, use the following command:

::

 sudo -u www-data php occ files:transfer-ownership <source-user> <destination-user>

You can also move a limited set of files from ``<source-user>`` to ``<destination-user>`` by making use of the ``--path`` switch, as in the example below. 
In it, ``folder/to/move``, and any file and folder inside it will be moved to ``<destination-user>``. 

::

  sudo -u www-data php occ files:transfer-ownership --path="folder/to/move" <source-user> <destination-user>

When using this command, please keep in mind: 

1. The directory provided to the ``--path`` switch **must** exist inside ``data/<source-user>/files``.
2. The directory (and its contents) won't be moved as is between the users. It'll be moved inside the destination user's ``files`` directory, and placed in a directory which follows the format: ``transferred from <source-user> on <timestamp>``. Using the example above, it will be stored under: ``data/<destination-user>/files/transferred from <source-user> on 20170426_124510/``
3. Currently file versions can't be transferred. Only the latest version of moved files will appear in the destination user's account.

.. _files_external_label:

Files External
--------------

These commands replace the ``data/mount.json`` configuration file used in 
ownCloud releases before 9.0.

Commands for managing external storage.

.. code-block:: console

 files_external
  files_external:applicable  Manage applicable users and groups for a mount
  files_external:backends    Show available authentication and storage backends
  files_external:config      Manage backend configuration for a mount
  files_external:create      Create a new mount configuration
  files_external:delete      Delete an external mount
  files_external:export      Export mount configurations
  files_external:import      Import mount configurations
  files_external:list        List configured mounts
  files_external:option      Manage mount options for a mount
  files_external:verify      Verify mount configuration

These commands replicate the functionality in the ownCloud Web GUI, plus two new features:  ``files_external:export`` and ``files_external:import``. 

Use ``files_external:export`` to export all admin mounts to stdout, and ``files_external:export [user_id]`` to export the mounts of the specified ownCloud user. 

.. note::
  These commands are only available when the "External storage support" app
  (``files_external``) is enabled.
  It is not available in :ref:`single-user (maintenance) mode <maintenance_commands_label>`.

files_external:list        
~~~~~~~~~~~~~~~~~~~

List configured mounts.

Usage::

    files_external:list [--show-password] [--full] [-a|--all] [--] [<user_id>]

Arguments:

+-------------+----------------------------------------------------------------------------------------------+
| ``user_id`` | User ID to list the personal mounts for, if no user is provided admin mounts will be listed. |
+-------------+----------------------------------------------------------------------------------------------+

Example::

    sudo -u www-data php occ files_external:list -- user1

files_external:applicable     
~~~~~~~~~~~~~~~~~~~~~~~~~~

Manage applicable users and groups for a mount.

Usage::

    files_external:applicable 
    [--add-user     ADD-USER]       
    [--remove-user  REMOVE-USER]    
    [--add-group    ADD-GROUP]      
    [--remove-group REMOVE-GROUP]   
    [--remove-all]                  
    [--output       [OUTPUT]]       
    [--]
    <mount_id>                      

Arguments:

+------------------+--------------------------------------------------------------------------+
| ``mount_id``     | The ID of the mount to edit                                              |
+------------------+--------------------------------------------------------------------------+

Options:

+-------------------+--------------------------------------------------------------------------+
| ``--add-user``    | user to add as applicable (multiple values allowed)                      |
+-------------------+--------------------------------------------------------------------------+
| ``--remove-user`` | user to remove as applicable (multiple values allowed)                   |
+-------------------+--------------------------------------------------------------------------+
| ``--add-group``   | group to add as applicable (multiple values allowed)                     |
+-------------------+--------------------------------------------------------------------------+
| ``--remove-group``| group to remove as applicable (multiple values allowed)                  |
+-------------------+--------------------------------------------------------------------------+
| ``--remove-all``  | Set the mount to be globally applicable                                  |
+-------------------+--------------------------------------------------------------------------+
| ``--output``      | The output format to use (plain, json or json_pretty, default is plain). |
+-------------------+--------------------------------------------------------------------------+


files_external:backends    
~~~~~~~~~~~~~~~~~~~~~~~

Show available authentication and storage backends.

Usage::

    files_external:backends [options] 
    [--] 
    [<type>] 
    [<backend>]

Arguments:

+-------------+----------------------------------------------------------------------------------------------+
| ``type``    | Only show backends of a certain type. Possible values are ``authentication`` or ``storage``. |
+-------------+----------------------------------------------------------------------------------------------+
| ``backend`` | Only show information of a specific backend.                                                 |
+-------------+----------------------------------------------------------------------------------------------+

Options:

+------------------+--------------------------------------------------------------------------+
| ``--output``     | The output format to use (plain, json or json_pretty, default is plain). |
+------------------+--------------------------------------------------------------------------+

files_external:config      
~~~~~~~~~~~~~~~~~~~~~

Manage backend configuration for a mount.

Usage::

    files_external:config [options] 
    [--] 
    <mount_id> 
    <key> 
    [<value>]

Arguments:

+--------------+--------------------------------------------------------------------------------------------------+
| ``mount_id`` | The ID of the mount to edit.                                                                     |
+--------------+--------------------------------------------------------------------------------------------------+
| ``key``      | Key of the config option to set/get.                                                             |
+--------------+--------------------------------------------------------------------------------------------------+
| ``value``    | Value to set the config option to, when no value is provided the existing value will be printed. |
+--------------+--------------------------------------------------------------------------------------------------+

Options:

+------------------+--------------------------------------------------------------------------+
| ``--output``     | The output format to use (plain, json or json_pretty, default is plain). |
+------------------+--------------------------------------------------------------------------+


files_external:create      
~~~~~~~~~~~~~~~~~~~~~

Create a new mount configuration.

Usage::

    files_external:create [options] 
    [--] 
    <mount_point> 
    <storage_backend> 
    <authentication_backend>

Arguments
^^^^^^^^^

+----------------------------+-------------------------------------------------------------------------------------------------------------+
| ``mount_point``            | Mount point for the new mount.                                                                              |
+----------------------------+-------------------------------------------------------------------------------------------------------------+
| ``storage_backend``        | Storage backend identifier for the new mount, see `occ files_external:backends` for possible values.        |
+----------------------------+-------------------------------------------------------------------------------------------------------------+
| ``authentication_backend`` | Authentication backend identifier for the new mount, see `occ files_external:backends` for possible values. |
+----------------------------+-------------------------------------------------------------------------------------------------------------+

Options
^^^^^^^

+-------------------------+-----------------------------------------------------------------------------------------------+
| ``--user[=USER]``       | User to add the mount configurations for, if not set the mount will be added as system mount. |
+-------------------------+-----------------------------------------------------------------------------------------------+
| ``-c, --config=CONFIG`` | Mount configuration option in ``key=value`` format (multiple values allowed).                 |
+-------------------------+-----------------------------------------------------------------------------------------------+
| ``--dry``               | Don't save the imported mounts, only list the new mounts.                                     |
+-------------------------+-----------------------------------------------------------------------------------------------+
| ``--output``            | The output format to use (plain, json or json_pretty, default is plain).                      |
+-------------------------+-----------------------------------------------------------------------------------------------+

Storage Backend Details
^^^^^^^^^^^^^^^^^^^^^^^

======================== =======================
Storage Backend          Identifier
======================== =======================
Windows Network Drive    windows_network_drive
WebDav                   dav
Local                    local
ownCloud                 owncloud
SFTP                     sftp
Amazon S3                amazons3
Dropbox                  dropbox
Google Drive             googledrive
OpenStack Object Storage swift
SMB / CIFS               smb
======================== =======================

Authentication Details
^^^^^^^^^^^^^^^^^^^^^^

==================================== =========================================
Authentication method                Identifier, name, configuration
==================================== =========================================
Log-in credentials, save in session  password::sessioncredentials
Log-in credentials, save in database password::logincredentials
User entered, store in database      password::userprovided (*)
Global Credentials                   password::global
None                                 null::null
Builtin                              builtin::builtin
Username and password                password::password
OAuth1                               oauth1::oauth1 (*)
OAuth2                               oauth2::oauth2 (*)
RSA public key                       publickey::rsa (*)
OpenStack                            openstack::openstack (*)
Rackspace                            openstack::rackspace (*)
Access key (Amazon S3)               amazons3::accesskey (*)
==================================== =========================================

 (\*) - Authentication methods require additional configuration.

.. note:: Each Storage Backend needs its corresponding authentication methods.

files_external:delete      
~~~~~~~~~~~~~~~~~~~~~

Delete an external mount.

Usage::
    
    files_external:delete [options] [--] <mount_id>

Arguments:

+--------------+------------------------------+
| ``mount_id`` | The ID of the mount to edit. |
+--------------+------------------------------+

Options:

+------------------+--------------------------------------------------------------------------+
| ``-y, --yes``    | Skip confirmation.                                                       |
+------------------+--------------------------------------------------------------------------+
| ``--output``     | The output format to use (plain, json or json_pretty, default is plain). |
+------------------+--------------------------------------------------------------------------+

files_external:export
~~~~~~~~~~~~~~~~~~~~~

Usage::

    files_external:export [options] [--] [<user_id>]

Arguments:

+-------------+--------------------------------------------------------------------------------------------------+
| ``user_id`` | User ID to export the personal mounts for, if no user is provided admin mounts will be exported. |
+-------------+--------------------------------------------------------------------------------------------------+

Options:

+---------------+-------------------------------------------------------+
| ``-a, --all`` | Show both system wide mounts and all personal mounts. |
+---------------+-------------------------------------------------------+

files_external:import      
~~~~~~~~~~~~~~~~~~~~~

Import mount configurations.

Usage::

    files_external:import [options] [--] <path>

Arguments:

+----------+------------------------------------------------------------------------------------+
| ``path`` | Path to a json file containing the mounts to import, use ``-`` to read from stdin. |
+----------+------------------------------------------------------------------------------------+

Options:

+-------------------+-----------------------------------------------------------------------------------------------+
| ``--user[=USER]`` | User to add the mount configurations for, if not set the mount will be added as system mount. |
+-------------------+-----------------------------------------------------------------------------------------------+
| ``--dry``         | Don't save the imported mounts, only list the new mounts.                                     |
+-------------------+-----------------------------------------------------------------------------------------------+
| ``--output``      | The output format to use (plain, json or json_pretty, default is plain).                      |
+-------------------+-----------------------------------------------------------------------------------------------+

files_external:list        
~~~~~~~~~~~~~~~~~~~

List configured mounts.

Usage::

    files_external:list [--show-password] [--full] [-a|--all] [--] [<user_id>]

Arguments:

+-------------+----------------------------------------------------------------------------------------------+
| ``user_id`` | User ID to list the personal mounts for, if no user is provided admin mounts will be listed. |
+-------------+----------------------------------------------------------------------------------------------+

Options:

+---------------------+-----------------------------------------------------------------------------------------------+
| ``--show-password`` | User to add the mount configurations for, if not set the mount will be added as system mount. |
+---------------------+-----------------------------------------------------------------------------------------------+
| ``--full``          | Don't save the imported mounts, only list the new mounts.                                     |
+---------------------+-----------------------------------------------------------------------------------------------+
| ``-a, --all``       | Show both system wide mounts and all personal mounts.                                         |
+---------------------+-----------------------------------------------------------------------------------------------+
| ``--output``        | The output format to use (plain, json or json_pretty, default is plain).                      |
+---------------------+-----------------------------------------------------------------------------------------------+


Example::

   sudo -u www-data php occ files_external:list -- user1

files_external:option      
~~~~~~~~~~~~~~~~~~~~~

Manage mount options for a mount.

Usage::
    files_external:option <mount_id> <key> [<value>]

Arguments:

+--------------+-------------------------------------------------------------------------------------------------+
| ``mount_id`` | The ID of the mount to edit.                                                                    |
+--------------+-------------------------------------------------------------------------------------------------+
| ``key``      | Key of the mount option to set/get.                                                             |
+--------------+-------------------------------------------------------------------------------------------------+
| ``value``    | Value to set the mount option to, when no value is provided the existing value will be printed. |
+--------------+-------------------------------------------------------------------------------------------------+

files_external:verify      
~~~~~~~~~~~~~~~~~~~~~

Verify mount configuration.

Usage::

    files_external:verify [options] [--] <mount_id>

Arguments:

+--------------+-------------------------------+
| ``mount_id`` | The ID of the mount to check. |
+--------------+-------------------------------+

Options:

+-------------------------+------------------------------------------------------------------------------------------------+
| ``-c, --config=CONFIG`` | Additional config option to set before checking in ``key=value``                               |
|                         | pairs, required for certain auth backends such as login credentails (multiple values allowed). |
+-------------------------+------------------------------------------------------------------------------------------------+
| ``--output``            | The output format to use (plain, json or json_pretty, default is plain).                       |
+-------------------------+------------------------------------------------------------------------------------------------+


.. _group_commands_label:

Group Commands
--------------

The ``group`` commands provide a range of functionality for managing ownCloud groups. 
This includes creating and removing groups and managing group membership.
Group names are case-sensitive, so "Finance" and "finance" are two different groups.

The full list of commands is:

.. code-block:: console

 group
  group:add                           Adds a group
  group:add-member                    Add members to a group
  group:delete                        Deletes the specified group
  group:list                          List groups
  group:list-members                  List group members
  group:remove-member                 Remove member(s) from a group

Creating Groups
~~~~~~~~~~~~~~~

You can create a new group with the ``group:add`` command. 
The syntax is::

 group:add groupname

This example adds a new group, called "Finance":

:: 
 
 sudo -u www-data php occ group:add Finance
   Created group "Finance"

Listing Groups
~~~~~~~~~~~~~~

You can list the names of existing groups with the ``group:list`` command.
The syntax is::

  group:list [options] [<search-pattern>]

Groups containing the ``search-pattern`` string are listed. Matching is 
not case-sensitive. If you do not provide a search-pattern then all groups 
are listed.

Options:

::
  
  --output[=OUTPUT]  Output format (plain, json or json_pretty, default is plain) [default: "plain"]

This example lists groups containing the string "finance".

:: 
 
 sudo -u www-data php occ group:list finance
  - All-Finance-Staff
  - Finance
  - Finance-Managers

This example lists groups containing the string "finance" formatted with ``json_pretty``.

::

 sudo -u www-data php occ group:list --output=json_pretty finance
  [
    "All-Finance-Staff",
    "Finance",
    "Finance-Managers"
  ]

Listing Group Members
~~~~~~~~~~~~~~~~~~~~~

You can list the user IDs of group members with the ``group:list-members`` command.
The syntax is::

  group:list-members [options] <group>

Options:

::
  
  --output[=OUTPUT]  Output format (plain, json or json_pretty, default is plain) [default: "plain"]

This example lists members of the "Finance" group.

:: 
 
 sudo -u www-data php occ group:list-members Finance
  - aaron: Aaron Smith
  - julie: Julie Jones

This example lists members of the Finance group formatted with ``json_pretty``.

::

 sudo -u www-data php occ group:list-members --output=json_pretty Finance
  {
    "aaron": "Aaron Smith",
    "julie": "Julie Jones"
  }

Adding Members to Groups
~~~~~~~~~~~~~~~~~~~~~~~~

You can add members to an existing group with the ``group:add-member`` command.
Members must be existing users. 
The syntax is

::

 group:add-member [-m|--member [MEMBER]] <group>

This example adds members "aaron" and "julie" to group "Finance":: 

 sudo -u www-data php occ group:add-member --member aaron --member julie Finance
   User "aaron" added to group "Finance"
   User "julie" added to group "Finance"

You may attempt to add members that are already in the group, without error.
This allows you to add members in a scripted way without needing to know if the user is already a member of the group. 
For example::

 sudo -u www-data php occ group:add-member --member aaron --member julie --member fred Finance
   User "aaron" is already a member of group "Finance"
   User "julie" is already a member of group "Finance"
   User fred" added to group "Finance"

Removing Members from Groups
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can remove members from a group with the ``group:remove-member`` command.
The syntax is::

 group:remove-member [-m|--member [MEMBER]] <group>

This example removes members "aaron" and "julie" from group "Finance".

:: 

 sudo -u www-data php occ group:remove-member --member aaron --member julie Finance
   Member "aaron" removed from group "Finance"
   Member "julie" removed from group "Finance"

You may attempt to remove members that have already been removed from the group, without error. 
This allows you to remove members in a scripted way without needing to know if the user is still a member of the group. 
For example:

::

 sudo -u www-data php occ group:remove-member --member aaron --member fred Finance
   Member "aaron" could not be found in group "Finance"
   Member "fred" removed from group "Finance"

Deleting a Group
~~~~~~~~~~~~~~~~~

To delete a group, you use the ``group:delete`` command, as in the example below:

::

 sudo -u www-data php occ group:delete Finance
   
.. _integrity_check_label:

Integrity Check
---------------

Apps which have an official tag MUST be code signed. 
Unsigned official apps won't be installable anymore. 
Code signing is optional for all third-party applications.

.. code-block:: console

 integrity
  integrity:check-app                 Check app integrity using a signature.
  integrity:check-core                Check core integrity using a signature.
  integrity:sign-app                  Signs an app using a private key.
  integrity:sign-core                 Sign core using a private key
  
After creating your signing key, sign your app like this example:

:: 
 
 sudo -u www-data php occ integrity:sign-app --privateKey=/Users/karlmay/contacts.key --certificate=/Users/karlmay/CA/contacts.crt --path=/Users/karlmay/Programming/contacts
 
Verify your app:

::

  sudo -u www-data php occ integrity:check-app --path=/pathto/app appname
  
When it returns nothing, your app is signed correctly. 
When it returns a message then there is an error. 
See `Code Signing <https://doc.owncloud.org/server/latest/developer_manual/app/code_signing.html#how-to-get-your-app-signed>`_ in the Developer manual for more detailed information.

``integrity:sign-core`` is for ownCloud core developers only.

See :doc:`../../issues/code_signing` to learn more.

.. _create_javascript_translation_files_label:
 
l10n, Create Javascript Translation Files for Apps
--------------------------------------------------

This command creates JavaScript and JSON translation files for ownCloud applications.

.. note::
   The command does not update existing translations if the source translation
   file has been updated. It only creates translation files when none are
   present for a given language.

.. code-block:: console

 l10n
   l10n:createjs                Create Javascript translation files for a given app

The command takes two parameters; these are:

- ``app``: the name of the application.
- ``lang``: the output language of the translation files; more than one can be supplied.

To create the two translation files, the command reads translation data from a source PHP translation file. 

A Working Example
~~~~~~~~~~~~~~~~~

In this example, we'll create Austrian German translations for the Gallery app.

.. note:: 
   This example assumes that the ownCloud directory is `/var/www/owncloud`` and that it uses ownCloud's standard apps directory, ``app``.

First, create a source translation file in ``/var/www/owncloud/apps/gallery/l10n``, called ``de_AT.php``.
In it, add the required translation strings, as in the following example.
Refer to the developer documentation on `creating translation files`_, if you're not familiar with creating them.

.. code-block:: php

  <?php
  // The source string is the key, the translated string is the value.
  $TRANSLATIONS = [
    "Share" => "Freigeben"
  ];
  $PLURAL_FORMS = "nplurals=2; plural=(n != 1);";

After that, run the following command to create the translation.

:: 

 sudo -u www-data php occ l10n:createjs gallery de_AT

This will generate two translation files, ``de_AT.js`` and ``de_AT.json``, in ``/var/www/owncloud/apps/gallery/l10n``.

Create Translations in Multiple Languages
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To create translations in multiple languages simultaneously, supply multiple languages to the command, as in the following example:

::

 sudo -u www-data php occ l10n:createjs gallery de_AT de_DE hu_HU es fr

.. _logging_commands_label:

Logging Commands
----------------

These commands view and configure your ownCloud logging preferences.

.. code-block:: console

 log
  log:manage     Manage logging configuration
  log:owncloud   Manipulate ownCloud logging backend

Run ``log:owncloud`` to see your current logging status:

::

 sudo -u www-data php occ log:owncloud 
 Log backend ownCloud: enabled
 Log file: /opt/owncloud/data/owncloud.log
 Rotate at: disabled

Options for ``log:owncloud``:

::

  --enable                   Enable this logging backend
  --file=FILE                Set the log file path
  --rotate-size=ROTATE-SIZE  Set the file size for log rotation, 0 = disabled

Use the ``--enable`` option to turn on logging. Use ``--file`` to set a different log file path. 
Set your rotation by log file size in bytes with ``--rotate-size``; 0 disables rotation. 

Run ``log:manage`` to set your logging backend, log level, and timezone:

The defaults are ``owncloud``, ``Warning``, and ``UTC``. 

Options for ``log:manage``:

::

  --backend=BACKEND    set the logging backend [owncloud, syslog, errorlog]
  --level=LEVEL        set the log level [debug, info, warning, error, fatal]

Log level can be adjusted by entering the number or the name:

::

   sudo -u www-data php occ log:manage --level 4
   sudo -u www-data php occ log:manage --level error

.. note::
   Setting the log level to debug ( 0 ) can be used for finding the cause of an error, but should not be the standard
   as it increases the log file size.

.. _maintenance_commands_label:
   
Maintenance Commands
--------------------

Use these commands when you upgrade ownCloud, manage encryption, perform backups and other tasks that require locking users out until you are finished.

.. code-block:: console

 maintenance
  maintenance:data-fingerprint        Update the systems data-fingerprint after a backup is restored
  maintenance:mimetype:update-db      Update database mimetypes and update filecache
  maintenance:mimetype:update-js      Update mimetypelist.js
  maintenance:mode                    Set maintenance mode
  maintenance:repair                  Repair this installation
  maintenance:singleuser              Set single user mode
  maintenance:update:htaccess         Updates the .htaccess file

.. _maintenance_mode_label:

``maintenance:mode`` locks the sessions of all logged-in users, including administrators, and displays a status screen warning that the server is in maintenance mode. 
Users who are not already logged in cannot log in until maintenance mode is turned off. 
When you take the server out of maintenance mode logged-in users must refresh their Web browsers to continue working.

::

 sudo -u www-data php occ maintenance:mode --on
 sudo -u www-data php occ maintenance:mode --off
 
Putting your ownCloud server into single-user mode allows admins to log in and work, but not ordinary users. 
This is useful for performing maintenance and troubleshooting on a running server.

::

 sudo -u www-data php occ maintenance:singleuser --on
 Single user mode enabled
   
Turn it off when you're finished:

::

 sudo -u www-data php occ maintenance:singleuser --off
 Single user mode disabled
 
Run ``maintenance:data-fingerprint`` to tell desktop and mobile clients that a server backup has been restored. 
Users will be prompted to resolve any conflicts between newer and older file versions.

Run ``maintenance:data-fingerprint`` to tell desktop and mobile clients that a server backup has been restored. 
This command changes the ETag for all files in the communication with sync clients, informing them that one or more files were modified.
After the command completes, users will be prompted to resolve any conflicts between newer and older file versions.

The ``maintenance:repair`` command runs automatically during upgrades to clean up the database, so while you can run it manually there usually isn't a need to.

::

 sudo -u www-data php occ maintenance:repair

``maintenance:mimetype:update-db`` updates the ownCloud database and file cache with changed mimetypes found in ``config/mimetypemapping.json``.
Run this command after modifying ``config/mimetypemapping.json``.
If you change a mimetype, run ``maintenance:mimetype:update-db --repair-filecache`` to apply the change to existing files.

.. _security_commands_label:

Security
--------


Use these commands when you manage security related tasks

Routes dispays all routes of ownCloud. You can use this information to grant strict access via firewalls, proxies or loadbalancers etc.

.. code-block:: console

  security:routes [options]

Options:

::

  --output	  Output format (plain, json or json-pretty, default is plain)
  --with-details  Adds more details to the output

Example 1:

::

  sudo -uwww-data ./occ security:routes

::

  +-----------------------------------------------------------+-----------------+
  | Path                                                      | Methods         |
  +-----------------------------------------------------------+-----------------+
  | /apps/federation/auto-add-servers                         | POST            |
  | /apps/federation/trusted-servers                          | POST            |
  | /apps/federation/trusted-servers/{id}                     | DELETE          |
  | /apps/files/                                              | GET             |
  | /apps/files/ajax/download.php                             |                 |
  ...

Example 2:

::

  sudo  -uwww-data ./occ security:routes --output=json-pretty

::

  [
    {
        "path": "\/apps\/federation\/auto-add-servers",
        "methods": [
            "POST"
        ]
    },
  ...

Example 3:

::

  sudo  -uwww-data ./occ security:routes --with-details

::

  +---------------------------------------------+---------+-------------------------------------------------------+--------------------------------+
  | Path                                        | Methods | Controller                                            | Annotations                    |
  +---------------------------------------------+---------+-------------------------------------------------------+--------------------------------+
  | /apps/files/api/v1/sorting                  | POST    | OCA\Files\Controller\ApiController::updateFileSorting | NoAdminRequired                |
  | /apps/files/api/v1/thumbnail/{x}/{y}/{file} | GET     | OCA\Files\Controller\ApiController::getThumbnail      | NoAdminRequired,NoCSRFRequired |
  ...  

|
  
The following commands manage server-wide SSL certificates. 
These are useful when you create federation shares with other ownCloud servers that use self-signed certificates.

.. code-block:: console

  security:certificates         List trusted certificates
  security:certificates:import  Import trusted certificate
  security:certificates:remove  Remove trusted certificate

This example lists your installed certificates:

::

 sudo -u www-data php occ security:certificates
 
Import a new certificate:

::

 sudo -u www-data php occ security:certificates:import /path/to/certificate
 
Remove a certificate:

::

 sudo -u www-data php occ security:certificates:remove [certificate name]

.. _sharing_commands_label:

Sharing
-------

This is an occ command to cleanup orphaned remote storages.
To explain why this is necessary, a little background is required.
While shares are able to be deleted as a normal matter of course, remote storages with "shared::" are not included in this process.

This might not, normally, be a problem.
However, if a user has re-shared a remote share which has been deleted it will.
This is because when the original share is deleted, the remote re-share reference is not.
Internally, the fileid will remain in the file cache and storage for that file will not be deleted.

As a result, any user(s) who the share was re-shared with will now get an error when trying to access that file or folder.
That's why the command is available.

So, to cleanup all orphaned remote storages, run it as follows:

::

  sudo -u www-data php occ sharing:cleanup-remote-storages

You can also set it up to run as :ref:`a background job <background-jobs-header>`

.. note::
  These commands are not available in :ref:`single-user (maintenance) mode <maintenance_commands_label>`.

.. _trashbin_label:

Trashbin
--------

.. note::
  These commands are only available when the "Deleted files" app
  (``files_trashbin``) is enabled.
  These commands are not available in :ref:`single-user (maintenance) mode <maintenance_commands_label>`.

.. code-block:: console

 trashbin
  trashbin:cleanup   Remove deleted files
  trashbin:expire    Expires the users trash bin  

The ``trashbin:cleanup`` command removes the deleted files of the specified users in a space-delimited list, or all users if none are specified. 
This example removes all the deleted files of all users:

::  
  
  sudo -u www-data php occ trashbin:cleanup 
  Remove all deleted files
  Remove deleted files for users on backend Database
   freda
   molly
   stash
   rosa 
   edward

This example removes the deleted files of users ""molly"" and ""freda"":

::  

 sudo -u www-data php occ trashbin:cleanup molly freda
 Remove deleted files of   molly
 Remove deleted files of   freda
 
``trashbin:expire`` deletes only expired files according to the ``trashbin_retention_obligation`` setting in ``config.php`` (see the Deleted Files section in :doc:`config_sample_php_parameters`). 
The default is to delete expired files for all users, or you may list users in a space-delimited list.

.. _user_commands_label: 
 
User Commands
-------------

The ``user`` commands provide a range of functionality for managing ownCloud users. 
This includes: creating and removing users, resetting user passwords, displaying a report which shows how many users you have, and when a user was last logged in. 

The full list, of commands is:

.. code-block:: console

 user
  user:add                            Adds a user
  user:delete                         Deletes the specified user
  user:disable                        Disables the specified user
  user:enable                         Enables the specified user
  user:inactive                       Reports users who are known to owncloud, 
                                      but have not logged in for a certain number of days
  user:lastseen                       Shows when the user was logged in last time
  user:list                           List users
  user:list-groups                    List groups for a user
  user:modify                         Modify user details
  user:report                         Shows how many users have access
  user:resetpassword                  Resets the password of the named user
  user:setting                        Read and modify user application settings
  user:sync                           Sync local users with an external backend service

Creating Users
~~~~~~~~~~~~~~

You can create a new user with the ``user:add`` command.
This command lets you set the following attributes:

- **uid:** The ``uid`` is the user's username and their login name
- **display name:** This corresponds to the **Full Name** on the Users page in your ownCloud Web UI
- **email address**
- **group**
- **login name**
- **password**

The command's syntax is:

.. code-block:: console

 user:add [--password-from-env] [--display-name [DISPLAY-NAME]] [--email [EMAIL]] [-g|--group [GROUP]] [--] <uid>

This example adds new user Layla Smith, and adds her to the **users** and **db-admins** groups. 
Any groups that do not exist are created.

:: 
 
 sudo -u www-data php occ user:add --display-name="Layla Smith" \
   --group="users" --group="db-admins" --email=layla.smith@example.com layla
   Enter password: 
   Confirm password: 
   The user "layla" was created successfully
   Display name set to "Layla Smith"
   Email address set to "layla.smith@example.com"
   User "layla" added to group "users"
   User "layla" added to group "db-admins"

After the command completes, go to your Users page, and you will see your new user. 

Setting a User's Password
~~~~~~~~~~~~~~~~~~~~~~~~~

``password-from-env`` allows you to set the user's password from an environment variable. 
This prevents the password from being exposed to all users via the process list, and will only be visible in the history of the user (root) running the command. 
This also permits creating scripts for adding multiple new users.

To use ``password-from-env`` you must run as "real" root, rather than ``sudo``, because ``sudo`` strips environment variables. 
This example adds new user Fred Jones:

::

 export OC_PASS=newpassword
 su -s /bin/sh www-data -c 'php occ user:add --password-from-env 
   --display-name="Fred Jones" --group="users" fred'
 The user "fred" was created successfully
 Display name set to "Fred Jones"
 User "fred" added to group "users" 

You can reset any user's password, including administrators (see :doc:`../../configuration/user/reset_admin_password`):

::

 sudo -u www-data php occ user:resetpassword layla
   Enter a new password: 
   Confirm the new password: 
   Successfully reset password for layla
   
You may also use ``password-from-env`` to reset passwords:

::

 export OC_PASS=newpassword
 sudo -u www-data php occ user:resetpassword --password-from-env layla
   Successfully reset password for layla
   
Deleting A User
~~~~~~~~~~~~~~~

To delete a user, you use the ``user:delete`` command, as in the example below:

::

 sudo -u www-data php occ user:delete fred

.. _user-expire-password_label:

Expiring a User's Password
~~~~~~~~~~~~~~~~~~~~~~~~~~

.. note:: This command is only available when `the Password Policy app`_ is installed.

::

  sudo -u www-data php user:expire-password <uid> [<expiredate>]

To expire a user's password at a specific date and time, use the ``user:expire-password`` command.
The command accepts two arguments, the user's uid and an expiry date.
The expiry date can be provided using any of `PHP's supported date and time formats`_.

If an expiry date is not supplied, the password will expire with immediate effect.
This is because the password will be set as being expired 24 hours before the command was run.
For example, if the command was run at "2018-07-**12** 13:15:28 UTC", then the password's expiry date will be set to "2018-07-**11** 13:15:28 UTC".

After the command completes, console output, similar to that below, confirms when the user's password is set to expire.

::

  The password for frank is set to expire on 2018-07-12 13:15:28 UTC.

Command Examples
^^^^^^^^^^^^^^^^

::

  # The password for user "frank" will be set as being expired 24 hours before the command was run.
  sudo -u www-data php occ user:expire-password frank

  # Expire the user "frank"'s password in 2 days time.
  sudo -u www-data php occ user:expire-password frank '+2 days'

  # Expire the user "frank"'s password on the 15th of August 2005, at 15:52:01 in the local timezone.
  sudo -u www-data php occ user:expire-password frank '2005-08-15T15:52:01+00:00'

  # Expire the user "frank"'s password on the 15th of August 2005, at 15:52:01 UTC.
  sudo -u www-data php occ user:expire-password frank '15-Aug-05 15:52:01 UTC'

Caveats
^^^^^^^

Please be aware of the following implications of enabling or changing the password policy's "*days until user password expires*" option.

- Administrators need to run the ``occ user:expire-password`` command to initiate expiry for new users.
- Passwords will never expire for users who have *not* changed their initial password, because they do not have a password history. To force password expiration use the ``occ user:expire-password`` command.
- A password expiration date will be set after users change their password for the first time. To force password expiration use the ``occ user:expire-password`` command.
- Passwords changed for the first time, will expire based on the *active* password policy. If the policy is later changed, it will not update the password's expiry date to reflect the new setting.
- Password expiration dates of users where the administrator has run the ``occ user:expire-password`` command *won't* automatically update to reflect the policy change. In these cases, Administrators need to run the ``occ user:expire-password`` command again and supply a new expiry date.

Listing Users
~~~~~~~~~~~~~

You can list existing users with the ``user:list`` command.
The syntax is

.. code-block:: console

  user:list [options] [<search-pattern>]

User IDs containing the ``search-pattern`` string are listed. Matching is 
not case-sensitive. If you do not provide a search-pattern then all users 
are listed.

Options:

::

  --output[=OUTPUT]	         Output format (plain, json or json-pretty, default is plain)
  -a, --attributes[=ATTRIBUTES]  Adds more details to the output

Allowed attributes, multiple values possible

::

  uid, displayName, email, quota, enabled, lastLogin, home, 
  backend, cloudId, searchTerms [default: ["displayName"]]

This example lists user IDs containing the string "aron"

:: 
 
 sudo -u www-data php occ user:list ron
  - aaron: Aaron Smith

The output can be formatted in JSON with the output option ``json`` or ``json_pretty``.

::

 sudo -u www-data php occ user:list --output=json_pretty 
  {
    "aaron": "Aaron Smith",
    "herbert": "Herbert Smith",
    "julie": "Julie Jones"
  }

This example lists all users including the attribute "enabled".

:: 
 
 sudo -u www-data php occ user:list -a enabled
  - admin: true
  - foo: true


Listing Group Membership of a User
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can list the group membership of a user with the ``user:list-groups`` command.
The syntax is

.. code-block:: console

  user:list-groups [options] <uid>

This example lists group membership of user julie:: 
 
 sudo -u www-data php occ user:list-groups julie
  - Executive
  - Finance

The output can be formatted in JSON with the output option ``json`` or ``json_pretty``::

 sudo -u www-data php occ user:list-groups --output=json_pretty julie
  [
    "Executive",
    "Finance"
  ]

Finding The User's Last Login
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To view a user's most recent login, use the ``user:lastseen`` command, as in the example below:

::   
   
 sudo -u www-data php occ user:lastseen layla 
   layla's last login: 09.01.2015 18:46

User Application Settings
~~~~~~~~~~~~~~~~~~~~~~~~~

To manage application settings for a user, use the ``user:setting`` command. 
This command provides the ability to:

- Retrieve all settings for an application
- Retrieve a single setting
- Set a setting value
- Delete a setting

If you run the command and pass the help switch (``--help``), you will see the following output, in your terminal:

.. code-block:: console

  Usage:
    user:setting [options] [--] <uid> [<app>] [<key>]

  Arguments:
    uid    User ID used to login
    app    Restrict the settings to a given app [default: ""]
    key    Setting key to set, get or delete [default: ""]

::

  sudo -u www-data php occ user:setting --help

If you're new to the ``user:setting`` command, the descriptions for the ``app`` and ``key`` arguments may not be completely transparent. 
So, here's a lengthier description of both.

======== ======================================================================
Argument Description
======== ======================================================================
app      When an value is supplied, ``user:setting`` limits the settings 
         displayed, to those for that, specific, application — assuming that 
         the application is installed, and that there are settings available 
         for it. Some example applications are "core", "files_trashbin", and 
         "user_ldap". A complete list, unfortunately, cannot be supplied, as it 
         is impossible to know the entire list of applications which a user 
         could, potentially, install.
key      This value specifies the setting key to be manipulated (set, 
         retrieved, or deleted) by the ``user:setting`` command.
======== ======================================================================

Retrieving User Settings
~~~~~~~~~~~~~~~~~~~~~~~~

To retrieve all settings for a user, you need to call the ``user:setting`` command and supply the user's username, as in the example below.

::

 sudo -u www-data php occ user:setting layla
   - core:
     - lang: en
   - login:
     - lastLogin: 1465910968
   - settings:
     - email: layla@example.tld

Here, we see that the user has settings for the application ``core``, when they last logged in, and what their email address is. 

To retrieve the user's settings for a specific application, you have to supply the username and the application's name, which you want to retrieve the settings for; such as in the example below::

 sudo -u www-data php occ user:setting layla core
  - core:
     - lang: en

In the output, you can see that one setting is in effect, ``lang``, which is set to ``en``. 
To retrieve the value of a single application for a user, use the ``user:setting`` command, as in the example below.

::

 sudo -u www-data php occ user:setting layla core lang
 
This will display the value for that setting, such as ``en``.

Setting a Setting
~~~~~~~~~~~~~~~~~

To set a setting, you need to supply four things; these are: 

- the username
- the application (or setting category)
- the ``--value`` switch
- the, quoted, value for that setting

Here's an example of how you would set the email address of the user ``layla``.

::

 sudo -u www-data php occ user:setting layla settings email --value "new-layla@example.tld"

Deleting a Setting
~~~~~~~~~~~~~~~~~~

Deleting a setting is quite similar to setting a setting. 
In this case, you supply the username, application (or setting category) and key as above. 
Then, in addition, you supply the ``--delete`` flag.

::

 sudo -u www-data php occ user:setting layla settings email --delete

Modify user details
^^^^^^^^^^^^^^^^^^^

.. versionadded:: 10.0.8

This command modifies either the users username or email address.

.. code-block:: console

  user:modify [options] [--] <uid> <key> <value>
  
  Arguments:
    uid      User ID used to login
    key      Key to be changed. Valid keys are: displayname, email
    value    The new value of the key
  
All three arguments are mandatory and can not be empty.

Example to set the email address:

::

  sudo -u www-data php occ user:modify carla email foobar@foo.com

The email address of ``carla`` is updated to ``foobar@foo.com``

Generating a User Count Report
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Generate a simple report that counts all users, including users on external user authentication servers such as LDAP.

::

 sudo -u www-data php occ user:report
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

.. _syncing_user_accounts_label:

Syncing User Accounts
^^^^^^^^^^^^^^^^^^^^^

This command syncs users stored in external backend services, such as *LDAP*, *Shibboleth*, and *Samba*, with ownCloud's, internal, user database.
However, it's not essential to run it regularly, unless you have a large number of users whose account properties have changed in a backend outside of ownCloud.
When run, it will pick up changes from alternative user backends, such as LDAP where properties like ``cn`` or ``display name`` have changed, and sync them with ownCloud's user database.
If accounts are found that no longer exist in the external backend, you are given the choice of either removing or disabling the accounts. 

.. note:: 
   It's also :ref:`one of the commands <available_background_jobs_label>` that you should run on a regular basis to ensure that your ownCloud installation is running optimally.

.. note::
   This command replaces the old ``show-remnants`` functionality, and brings the LDAP feature more in line with the rest of ownCloud's functionality.

Usage:

::

  user:sync [options] [--] [<backend-class>]

  Arguments:
    backend-class                                        The quoted PHP class name for the backend, eg
                                                         - LDAP:        "OCA\User_LDAP\User_Proxy"
                                                         - Samba:       "OCA\User\SMB"
                                                         - Shibboleth:  "OCA\User_Shibboleth\UserBackend"

  Options:
    -l, --list                                           List all enabled backend classes
    -u, --uid=UID                                        Sync only the user with the given user id
    -s, --seenOnly                                       Sync only seen users
    -c, --showCount                                      Calculate user count before syncing
    -m, --missing-account-action=MISSING-ACCOUNT-ACTION  Action to take if the account isn't connected to a backend any longer. Options are "disable" and "remove". Note that removing the account will also remove the stored data and files for that account.
    -r, --re-enable                                      When syncing multiple accounts re-enable accounts that are disabled in ownCloud but available in the synced backend.
    -h, --help                                           Display this help message
    -q, --quiet                                          Do not output any message
    -V, --version                                        Display this application version
        --ansi                                           Force ANSI output
        --no-ansi                                        Disable ANSI output
    -n, --no-interaction                                 Do not ask any interactive question
        --no-warnings                                    Skip global warnings, show command output only
    -v|vv|vvv, --verbose                                 Increase the verbosity of messages: 1 for normal output, 2 for more verbose output and 3 for debug

  Help:
    Synchronize users from a given backend to the accounts table.

Below are examples of how to use the command with different backends:

LDAP
~~~~

::

  sudo -u www-data ./occ user:sync "OCA\User_LDAP\User_Proxy" 

Samba
~~~~~

::

  sudo -u www-data ./occ user:sync "OCA\User\SMB"

Shibboleth
~~~~~~~~~~

::

  sudo -u www-data ./occ user:sync "OCA\User_Shibboleth\UserBackend"


Below are examples of how to use the command with the *LDAP* backend along with example console output.

Example 1:

::

  sudo ./occ user:sync "OCA\User_LDAP\User_Proxy" -m disable -r
  Analysing all users ...
      6 [============================]

  No removed users have been detected.

  No existing accounts to re-enable.

  Insert new and update existing users ...
      4 [============================]

Example 2:

::

  sudo  ./occ user:sync "OCA\User_LDAP\User_Proxy" -m disable -r
  Analysing all users ...
      6 [============================]

  Following users are no longer known with the connected backend.
  Disabling accounts:
  9F625F70-08DD-4838-AD52-7DE1F72DBE30, Bobbie, bobbie@example.org disabled
  53CDB5AC-B02E-4A49-8FEF-001A13725777, David, dave@example.org disabled
  34C3F461-90FE-417C-ADC5-CE97FE5B8E72, Carol, carol@example.org disabled

  No existing accounts to re-enable.

  Insert new and update existing users ...
      1 [============================]

Example 3:

::

  sudo./occ user:sync "OCA\User_LDAP\User_Proxy" -m disable -r
  Analysing all users ...
      6 [============================]

  Following users are no longer known with the connected backend.
  Disabling accounts:
  53CDB5AC-B02E-4A49-8FEF-001A13725777, David, dave@example.org skipped, already disabled
  34C3F461-90FE-417C-ADC5-CE97FE5B8E72, Carol, carol@example.org skipped, already disabled
  B5275C13-6466-43FD-A129-A12A6D3D9A0D, Alicia3, alicia3@example.org disabled

  Re-enabling accounts:
  9F625F70-08DD-4838-AD52-7DE1F72DBE30, Bobbie, bobbie@example.org enabled

  Insert new and update existing users ...
      1 [============================]

Example 4:

::

  sudo ./occ user:sync "OCA\User_LDAP\User_Proxy" -m disable -r
  Analysing all users ...
      6 [============================]

  No removed users have been detected.

  Re-enabling accounts:
  53CDB5AC-B02E-4A49-8FEF-001A13725777, David, dave@example.org enabled
  34C3F461-90FE-417C-ADC5-CE97FE5B8E72, Carol, carol@example.org enabled
  B5275C13-6466-43FD-A129-A12A6D3D9A0D, Alicia3, alicia3@example.org enabled

  Insert new and update existing users ...
      4 [============================]

Syncing via cron job
~~~~~~~~~~~~~~~~~~~~

Here is an example for syncing with LDAP four times a day on Ubuntu:

::

  crontab -e -u www-data
  
  * */6 * * * /usr/bin/php /var/www/owncloud/occ user:sync -vvv --missing-account-action="disable" -n "OCA\User_LDAP\User_Proxy"

.. _versions_label:
 
Versions
--------

.. code-block:: console

 versions
  versions:cleanup   Delete versions
  versions:expire    Expires the users file versions  

``versions:cleanup`` can delete all versioned files, as well as the ``files_versions`` folder, for either specific users, or for all users.
The example below deletes all versioned files for all users::

 sudo -u www-data php occ versions:cleanup
 Delete all versions
 Delete versions for users on backend Database
   freda
   molly
   stash
   rosa
   edward

You can delete versions for specific users in a space-delimited list:

::

 sudo -u www-data php occ versions:cleanup freda molly
 Delete versions of   freda
 Delete versions of   molly
 
``versions:expire`` deletes only expired files according to the ``versions_retention_obligation`` setting in ``config.php`` (see the File versions section in :doc:`config_sample_php_parameters`). 
The default is to delete expired files for all users, or you may list users in a space-delimited list.
 
.. note::
  These commands are only available when the "Versions" app (``files_versions``) is
  enabled.
  These commands are not available in :ref:`single-user (maintenance) mode <maintenance_commands_label>`.

.. _command_line_installation_label: 
 
Command Line Installation
-------------------------

ownCloud can be installed entirely from the command line. 
After downloading the tarball and copying ownCloud into the appropriate directories, or after installing ownCloud packages (See :doc:`../../installation/linux_installation` and :doc:`../../installation/source_installation`) you can use ``occ`` commands in place of running the graphical Installation Wizard.

.. note::
   These instructions assume that you have a fully working and configured webserver. If not, please refer to the documentation on :ref:`configuring the Apache web server <apache_configuration_label>` for detailed instructions.

Apply correct permissions to your ownCloud directories; see :ref:`strong_perms_label`. 
Then choose your ``occ`` options. 
This lists your available options:

::

 sudo -u www-data php occ
 ownCloud is not installed - only a limited number of commands are available
 ownCloud version 10.0.8

 Usage:
  [options] command [arguments]

 Options:
  --help (-h)           Display this help message
  --quiet (-q)          Do not output any message
  --verbose (-v|vv|vvv) Increase the verbosity of messages: 1 for normal output,
                        2 for more verbose output and 3 for debug
  --version (-V)        Display this application version
  --ansi                Force ANSI output
  --no-ansi             Disable ANSI output
  --no-interaction (-n) Do not ask any interactive question

 Available commands:
  check                 Check dependencies of the server environment
  help                  Displays help for a command
  list                  Lists commands
  status                Show some status information
  app
   app:check-code       Check code to be compliant
  l10n
   l10n:createjs        Create javascript translation files for a given app
  maintenance
   maintenance:install  Install ownCloud
  
Display your ``maintenance:install`` options

::

 sudo -u www-data php occ help maintenance:install
 ownCloud is not installed - only a limited number of commands are available
 Usage:

.. code-block:: console

  maintenance:install [--database="..."] [--database-name="..."] 
 [--database-host="..."] [--database-user="..."] [--database-pass[="..."]] 
 [--database-table-prefix[="..."]] [--admin-user="..."] [--admin-pass="..."] 
 [--data-dir="..."]

 Options:
  --database               Supported database type (default: "sqlite")
  --database-name          Name of the database
  --database-host          Hostname of the database (default: "localhost")
  --database-user          User name to connect to the database
  --database-pass          Password of the database user
  --database-table-prefix  Prefix for all tables (default: oc_)
  --admin-user             User name of the admin account (default: "admin")
  --admin-pass             Password of the admin account
  --data-dir               Path to data directory (default: "/var/www/owncloud/data")
  --help (-h)              Display this help message
  --quiet (-q)             Do not output any message
  --verbose (-v|vv|vvv)    Increase the verbosity of messages: 1 for normal output,
                           2 for more verbose output and 3 for debug
  --version (-V)           Display this application version
  --ansi                   Force ANSI output
  --no-ansi                Disable ANSI output
  --no-interaction (-n)    Do not ask any interactive question

This example completes the installation:

::

 cd /var/www/owncloud/
 sudo -u www-data php occ maintenance:install --database 
 "mysql" --database-name "owncloud"  --database-user "root" --database-pass 
 "password" --admin-user "admin" --admin-pass "password" 
 ownCloud is not installed - only a limited number of commands are available
 ownCloud was successfully installed

Supported databases are:

::

 - sqlite (SQLite3 - ownCloud Community edition only)
 - mysql (MySQL/MariaDB)
 - pgsql (PostgreSQL)
 - oci (Oracle - ownCloud Enterprise edition only)
 
.. _command_line_upgrade_label: 
   
Command Line Upgrade
--------------------

These commands are available only after you have downloaded upgraded packages or tar archives, and before you complete the upgrade.
List all options, like this example on CentOS Linux:

::

 sudo -u www-data php occ upgrade -h
 Usage:

.. code-block:: console

  upgrade [options]

 Options:
      --no-app-disable  Skips the disable of third party apps
  -h, --help            Display this help message
  -q, --quiet           Do not output any message
  -V, --version         Display this application version
      --ansi            Force ANSI output
      --no-ansi         Disable ANSI output
  -n, --no-interaction  Do not ask any interactive question
      --no-warnings     Skip global warnings, show command output only
  -v|vv|vvv, --verbose  Increase the verbosity of messages: 1 for normal output, 2 for more verbose output and 3 for debug

 Help:
  run upgrade routines after installation of a new release. The release has to be installed before.


When you are performing an update or upgrade on your ownCloud server (see the Maintenance section of this manual), it is better to use ``occ`` to perform the database upgrade step, rather than the Web GUI, in order to avoid timeouts. 
PHP scripts invoked from the Web interface are limited to 3600 seconds. 
In larger environments this may not be enough, leaving the system in an inconsistent 
state. 
After performing all the preliminary steps (see :doc:`../../maintenance/upgrade`) use this command to upgrade your databases, like this example on CentOS Linux:

::

 sudo -u www-data php occ upgrade
 ownCloud or one of the apps require upgrade - only a limited number of 
 commands are available                            
 Turned on maintenance mode                                                      
 Checked database schema update           
 Checked database schema update for apps
 Updated database      
 Updating <gallery> ...                                                          
 Updated <gallery> to 0.6.1               
 Updating <activity> ...
 Updated <activity> to 2.1.0            
 Update successful
 Turned off maintenance mode

Note how it details the steps.
Enabling verbosity displays timestamps:

::

 sudo -u www-data php occ upgrade -v
 ownCloud or one of the apps require upgrade - only a limited number of commands are available
 2017-06-23T09:06:15+0000 Turned on maintenance mode
 2017-06-23T09:06:15+0000 Checked database schema update
 2017-06-23T09:06:15+0000 Checked database schema update for apps
 2017-06-23T09:06:15+0000 Updated database
 2017-06-23T09:06:15+0000 Updated <files_sharing> to 0.6.6
 2017-06-23T09:06:15+0000 Update successful
 2017-06-23T09:06:15+0000 Turned off maintenance mode

If there is an error it throws an exception, and the error is detailed in your ownCloud logfile, so you can use the log output to figure out what went wrong, or to use in a bug report.

::

 Turned on maintenance mode
 Checked database schema update
 Checked database schema update for apps
 Updated database
 Updating <files_sharing> ...
 Exception
 ServerNotAvailableException: LDAP server is not available
 Update failed
 Turned off maintenance mode

.. _disable_user_label:

Disable Users
-------------

Admins can disable users via the occ command too:

::

 sudo -u www-data php occ user:disable <username>

Use the following command to enable the user again:

::

 sudo -u www-data php occ user:enable <username>

.. note::
   Once users are disabled, their connected browsers will be disconnected.

Finding Inactive Users
~~~~~~~~~~~~~~~~~~~~~~

To view a list of users who've not logged in for a given number of days, use the ``user:inactive`` command
The example below searches for users inactive for five days, or more.

::
   
   sudo -u www-data php occ user:inactive 5 
   

Options

::

  --output[=OUTPUT] Output format (plain, json or json_pretty, default is plain) [default: "plain"]

By default, this will generate output in the following format:

::
   
   - 0:
     - uid: admin
     - displayName: admin
     - inactiveSinceDays: 5

You can see the user's user id, display name, and the number of days they've been inactive.
If you're passing or piping this information to another application for further processing, you can also use the ``--output`` switch to change its format. 

Using the output option ``json`` will render the output formatted as follows.

.. code-block:: json

   [{"uid":"admin","displayName":"admin","inactiveSinceDays":5}]

Using the output option ``json_pretty`` will render the output formatted as follows.

.. code-block:: json

   [
       {
           "uid": "admin",
           "displayName": "admin",
           "inactiveSinceDays": 5
       }
   ]

.. Links

.. _creating translation files: https://doc.owncloud.org/server/latest/developer_manual/app/advanced/l10n.html#creating-translatable-files-label
.. _PHP's supported date and time formats: https://secure.php.net/manual/en/datetime.formats.php
