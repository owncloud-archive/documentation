=======================
Using occ apps commands
=======================

.. note:: This command reference covers the ownCloud maintained apps commands.

ownCloud's ``occ`` command (ownCloud console) is ownCloud's command-line interface. 
You can perform common server operations with ``occ``, including installing and upgrading ownCloud, managing users and groups, encryption, passwords, and LDAP setting.

``occ`` is in the :file:`owncloud/` directory; for example :file:`/var/www/owncloud` on Ubuntu Linux.
``occ`` is a PHP script.
**You must run it as your HTTP user** to ensure that your ownCloud files and directories retain the correct permissions.

occ Command Directory
---------------------

* :ref:`ocapps_http_user_label`
* :ref:`ocapps_calendar_label`
* :ref:`ocapps_contacts_label`
* :ref:`ocapps_files_primary_s3_label`
* :ref:`ocapps_ldap_commands_label`
* :ref:`ocapps_market_commands_label`
* :ref:`ocapps_notifications_commands_label`
* :ref:`ocapps_password_policy_label`
* :ref:`ocapps_reports_commands_label`
* :ref:`ocapps_ransomware_commands_label`
* :ref:`ocapps_shibboleth_label`
* :ref:`ocapps_two_factor_auth_label`

.. _ocapps_http_user_label:

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
   
.. _ocapps_calendar_label:

Calendar Commands
-----------------

For commands for managing the calendar, please see the DAV Command section in the occ core command set.

.. _ocapps_contacts_label:

Contacts Commands
-----------------

For commands for managing contacts, please see the DAV Command section in the occ core command set.

.. _ocapps_files_primary_s3_label:

S3 Objectstore Commands
-----------------------

List objects, buckets or versions of an object
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

  sudo -u www-data occ s3:list

Arguments:

+--------------+-------------------------------------------------+
| ``bucket``   | Name of the bucket; it`s objects will be listed |
+--------------+-------------------------------------------------+
| ``object``   | Key of the object; it`s versions will be listed |
+--------------+-------------------------------------------------+

Create a bucket as necessary to be used
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

  sudo -u www-data occ s3:create-bucket

  
Arguments:

+--------------+-----------------------------------+
| ``bucket``   | Name of the bucket to be created  |
+--------------+-----------------------------------+

Options:

+--------------------------+--------------------------------------------------------------+
| ``update-configuration`` | If the bucket exists the configuration will be updated       |
+--------------------------+--------------------------------------------------------------+
| ``accept-warning``       | No warning about the usage of this command will be displayed |
+--------------------------+--------------------------------------------------------------+

.. _ocapps_ldap_commands_label:
 
LDAP Commands
-------------

.. note::
  These commands are only available when the "LDAP user and group backend" app
  (``user_ldap``) is enabled.

These LDAP commands appear only when you have enabled the LDAP app. 
Then you can run the following LDAP commands with ``occ``:

.. code-block:: console

 ldap
  ldap:check-user               Checks whether a user exists on LDAP.
  ldap:create-empty-config      Creates an empty LDAP configuration
  ldap:delete-config            Deletes an existing LDAP configuration
  ldap:search                   Executes a user or group search
  ldap:set-config               Modifies an LDAP configuration
  ldap:show-config              Shows the LDAP configuration
  ldap:test-config              Tests an LDAP configuration
  ldap:update-group             Update the specified group membership
                                Information stored locally

Search for an LDAP user, using this syntax:

::

 sudo -u www-data php occ ldap:search [--group] [--offset="..."] 
 [--limit="..."] search

Searches match at the beginning of the attribute value only.
This example searches for ``givenNames`` that start with "rob":

::

 sudo -u www-data php occ ldap:search "rob"
 
This will find _robbie_, _roberta_, and _robin_.
Broaden the search to find, for example, ``jeroboam`` with the asterisk wildcard:

::

 sudo -u www-data php occ ldap:search "*rob"

User search attributes are set with ``ldap:set-config`` (below). 
For example, if your search attributes are ``givenName`` and ``sn`` you can find users by first name + last name very quickly. 
For example, you'll find "Terri Hanson" by searching for ``te ha``.
Trailing whitespace is ignored.
 
Check if an LDAP user exists. 
This works only if the ownCloud server is connected to an LDAP server.

::

 sudo -u www-data php occ ldap:check-user robert
 
``ldap:check-user`` will not run a check when it finds a disabled LDAP connection. 
This prevents users that exist on disabled LDAP connections from being marked as deleted. 
If you know for sure that the user you are searching for is not in one of the disabled connections, and exists on an active connection, use the ``--force`` option to force it to check all active LDAP connections.

::

 sudo -u www-data php occ ldap:check-user --force robert

``ldap:create-empty-config`` creates an empty LDAP configuration. 
The first one you create has no ``configID``, like this example:

::

 sudo -u www-data php occ ldap:create-empty-config
   Created new configuration with configID ''
   
This is a holdover from the early days, when there was no option to create additional configurations. 
The second, and all subsequent, configurations that you create are automatically assigned IDs.

::
 
 sudo -u www-data php occ ldap:create-empty-config
    Created new configuration with configID 's01' 
 
Then you can list and view your configurations:

::

 sudo -u www-data php occ ldap:show-config
 
And view the configuration for a single ``configID``:

::

 sudo -u www-data php occ ldap:show-config s01
 
``ldap:delete-config [configID]`` deletes an existing LDAP configuration.

:: 

 sudo -u www-data php occ ldap:delete  s01
 Deleted configuration with configID 's01'
 
The ``ldap:set-config`` command is for manipulating configurations, like this example that sets search attributes:

::
 
 sudo -u www-data php occ ldap:set-config s01 ldapAttributesForUserSearch 
 "cn;givenname;sn;displayname;mail"

The command takes the following format:

::

  ldap:set-config <configID> <configKey> <configValue>

All of the available keys, along with default values for `configValue`, are listed in the table below.

================================ ==============================================
Configuration                    Setting
================================ ==============================================
hasMemberOfFilterSupport
hasPagedResultSupport
homeFolderNamingRule
lastJpegPhotoLookup              0 
ldapAgentName                    `cn=admin,dc=owncloudqa,dc=com`
ldapAgentPassword                *\**
ldapAttributesForGroupSearch
ldapAttributesForUserSearch
ldapBackupHost
ldapBackupPort
ldapBase                         `dc=owncloudqa,dc=com`
ldapBaseGroups                   `dc=owncloudqa,dc=com`
ldapBaseUsers                    `dc=owncloudqa,dc=com`
ldapCacheTTL                     600 
ldapConfigurationActive          1
ldapDynamicGroupMemberURL
ldapEmailAttribute
ldapExperiencedAdmin             0 
ldapExpertUUIDGroupAttr
ldapExpertUUIDUserAttr
ldapExpertUsernameAttr                                                                            ldapGroupDisplayName             `cn`
ldapGroupFilter                                                                                  ldapGroupFilterGroups
ldapGroupFilterMode              0
ldapGroupFilterObjectclass
ldapGroupMemberAssocAttr         `uniqueMember`
ldapHost                         `ldap://host`
ldapIgnoreNamingRules
ldapLoginFilter                  `(&((objectclass=inetOrgPerson))(uid=%uid))`
ldapLoginFilterAttributes
ldapLoginFilterEmail             0
ldapLoginFilterMode              0
ldapLoginFilterUsername          1
ldapNestedGroups                 0
ldapOverrideMainServer
ldapPagingSize                   500
ldapPort                         389
ldapQuotaAttribute
ldapQuotaDefault
ldapTLS                          0
ldapUserDisplayName              `displayName`
ldapUserDisplayName2
ldapUserFilter                   `((objectclass=inetOrgPerson))`
ldapUserFilterGroups
ldapUserFilterMode               0
ldapUserFilterObjectclass        `inetOrgPerson`
ldapUuidGroupAttribute           `auto`
ldapUuidUserAttribute            `auto`
turnOffCertCheck                 0
useMemberOfToDetectMembership    1
================================ ==============================================

``ldap:test-config`` tests whether your configuration is correct and can bind to the server.

::

 sudo -u www-data php occ ldap:test-config s01
 The configuration is valid and the connection could be established!

``ldap:update-group`` updates the specified group membership information stored locally.

The command takes the following format:

::

  ldap:update-group <groupID> <groupID <groupID> ...>

The command allows for running a manual group sync on one or more groups, instead of having to wait for group syncing to occur.
If users have been added or removed from these groups in LDAP, ownCloud will update its details.
If a group was deleted in LDAP, ownCloud will also delete the local mapping info about this group.

.. note::
   New groups in LDAP won't be synced with this command.
   The LDAP TTL configuration (by default 10 minutes) still applies. This means
   that recently deleted groups from LDAP might be considered as "active" and
   might not be deleted in ownCloud immediately.

**Configuring the LDAP Refresh Attribute Interval**

You can configure the LDAP refresh attribute interval, but not with the ``ldap`` commands. 
Instead, you need to use the ``config:app:set`` command, as in the following example, which takes a number of seconds to the ``--value`` switch.

::
   
  sudo -u www-data php occ config:app:set user_ldap updateAttributesInterval --value=7200
   
In the example above, the interval is being set to 7200 seconds.
Assuming the above example was used, the command would output the following:

.. code-block:: console
   
  Config value updateAttributesInterval for app user_ldap set to 7200

If you want to reset (or unset) the setting, then you can use the following command:

::
   
  sudo -u www-data php occ config:app:delete user_ldap updateAttributesInterval

.. _ocapps_market_commands_label:
   
Market
------

The ``market`` commands *install*, *uninstall*, *list*, and *upgrade* applications from `the ownCloud Marketplace`.

.. code-block:: console
   
  market
    market:install    Install apps from the marketplace. If already installed and 
                      an update is available the update will be installed.
    market:uninstall  Uninstall apps from the marketplace.
    market:list       Lists apps as available on the marketplace.
    market:upgrade    Installs new app versions if available on the marketplace

.. note::
   The user running the update command, which will likely be your webserver user, requires write permission for the ``/apps`` folder.
   If they don't have write permission, the command may report that the update was successful, but it may silently fail.

.. note::
   These commands are not available in `single-user (maintenance) mode`.
   For more details please see the Maintenance Commands section in the occ core command set.

Install an Application
~~~~~~~~~~~~~~~~~~~~~~

Applications can be installed both from `the ownCloud Marketplace`_ and from a local file archive. 

Install Apps From The Marketplace
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To install an application from the Marketplace, you need to supply the app's id, which can be found in the app's Marketplace URL.
For example, the URL for *Two factor backup codes* is https://marketplace.owncloud.com/apps/twofactor_backup_codes.
So its app id is ``twofactor_backup_codes``.

Install Apps From a File Archive
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To install an application from a local file archive, you need to supply the path to the archive, and that you pass the ``-l`` switch. 
Only ``zip``, ``gzip``, and ``bzip2`` archives are supported.

Usage Example
~~~~~~~~~~~~~

::

  # Install an app from the marketplace.
  sudo -u www-data occ market:install twofactor_backup_codes

  # Install an app from a local archive.
  sudo -u www-data occ market:install -l /mnt/data/richdocuments-2.0.0.tar.gz

.. _ocapps_notifications_commands_label:

Notifications
-------------

If you want to send notifications to users or groups use the following command.

.. code-block:: console
   
  notifications
    notifications:generate   Generates a notification.

Options and Arguments:

::
   
  notifications:generate [-u|--user USER] [-g|--group GROUP] [-l|--link <linktext>] [--] <subject> [<message>]

  Options:
    -u --user              User id to whom the notification shall be sent
    -g --group             Group id to whom the notification shall be sent
    -l --link              A link associated with the notification

  Arguments:
    subject                The notification subject - maximum 255 characters
    message A more extended message - maximum 4000 characters
    linktext               A link to an HTML page

At least one user or group must be set.

A link can be useful for notifications shown in client apps.

Example:

::

 sudo -u www-data php occ notifications:generate -g Office "Emergeny Alert" "Rebooting in 5min"

.. _ocapps_password_policy_label:

Password Policy
---------------

**Command to expire a users password**

::

  sudo -u www-data occ user:expire-password

Arguments:

+------------------+--------------------------------------------------------------------------------------+
| ``expiredate``   | The date and time when a password expires, e.g. "2019-01-01 14:00:00 CET" or -1 days |
+------------------+--------------------------------------------------------------------------------------+

Options:

+-----------------+--------------------------------------------------------------------------------------+
| ``-a, --all``   | Will add password expiry to all known users. uid and group option are discarded if   |
|                 | the option is provided by user                                                       |
+-----------------+--------------------------------------------------------------------------------------+
| ``-u, --uid``   | The user's uid is used. This option can be used as --uid "Alice" --uid Bob"          |
+-----------------+--------------------------------------------------------------------------------------+
| ``-g, --group`` | Add password expiry to user(s) under group(s). This option can be used as --group    |
|                 | "foo" --group "bar" to add expiry passwords for users in group foo and bar. If       |
|                 | uid option (eg: --uid "user1") is passed with group, then uid will also be processed |
+-----------------+--------------------------------------------------------------------------------------+

.. _ocapps_reports_commands_label:

Reports
-------

If you're working with ownCloud support and need to send them a configuration summary, you can generate it using the ``configreport:generate`` command. 
This command generates the same JSON-based report as the Admin Config Report, which you can access under ``admin -> Settings -> Admin -> Help & Tips -> Download ownCloud config report``.

From the command-line in the root directory of your ownCloud installation, run it as your webserver user as follows, (assuming your webserver user is ``www-data``):

::

  sudo -u www-data occ configreport:generate

This generates the report and send it to ``STDOUT``.
You can optionally pipe the output to a file and then attach it to an email to ownCloud support, by running the following command:

::

  sudo -u www-data occ configreport:generate > generated-config-report.txt

Alternatively, you could generate the report and email it all in one command, by running:

::

  sudo -u www-data occ configreport:generate | mail -s "configuration report" \ 
      -r <the email address to send from> \
      support@owncloud.com

.. note::
  These commands are not available in :ref:`single-user (maintenance) mode <maintenance_commands_label>`.

.. _ocapps_ransomware_commands_label:

Ransomware Protection
---------------------

Use these commands to help users recover from a Ransomware attack.
You can find more information about the application :doc:`in the documentation <../../enterprise/ransomware-protection/index>`.

.. note::
  Ransomware Protection (which is an Enterprise app) needs to be installed and enabled to be able to use these commands.

::

  occ ransomguard:scan <timestamp> <user>     Report all changes in a user's account, starting from timestamp.
  occ ransomguard:restore <timestamp> <user>  Revert all operations in a user account after a point in time.
  occ ransomguard:lock <user>                 Set a user account as read-only for ownCloud and other WebDAV 
                                              clients when malicious activity is suspected.
  occ ransomguard:unlock <user>               Unlock a user account after ransomware issues have been resolved.

.. _ocapps_shibboleth_label:

Shibboleth Modes (Enterprise Edition only)
------------------------------------------

``shibboleth:mode`` sets your Shibboleth mode to ``notactive``, 
``autoprovision``, or ``ssoonly``

.. code-block:: console

 shibboleth:mode [mode]

.. note::
  These commands are only available when the "Shibboleth user backend" app
  (``user_shibboleth``) is enabled.

.. _ocapps_two_factor_auth_label:

Two-factor Authentication
-------------------------

If a two-factor provider app is enabled, it is enabled for all users by default (though the provider can decide whether or not the user has to pass the challenge).
In the case of an user losing access to the second factor (e.g., a lost phone with two-factor SMS verification), the admin can temporarily disable the two-factor check for that user via the occ command:

::

 sudo -u www-data php occ twofactor:disable <username>

To re-enable two-factor authentication again, use the following commmand:

::

 sudo -u www-data php occ twofactor:enable <username>

.. Links
   
.. _the ownCloud Marketplace: https://marketplace.owncloud.com/
.. _the Password Policy app: https://marketplace.owncloud.com/apps/password_policy
