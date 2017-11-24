===================================
How to Upgrade Your ownCloud Server
===================================

We recommend that you keep your ownCloud server upgraded regularly installing all point releases and major releases, without skipping any of them, as doing so increases the risk of errors. 

- Major releases are 8.0, 8.1, 8.2, 9.0, 9.1, and 10.0. 
- Point releases are intermediate releases for each major release, e.g., 8.0.9, 8.1.3, and 10.0.2. 

When an update is available for your ownCloud server, you will see a notification at the top of your ownCloud Web interface. 
When you click the notification, it will bring you here.

Before beginning an upgrade, please keep the following points in mind:

- Review :doc:`the release notes </release_notes>` for important information about the needed migration steps during that upgrade to help ensure a smooth upgrade process.
- Skipping major releases is not supported. However *you can* migrate from 9.0.9 straight to 10.0.   
- Downgrading is not supported.
- Upgrading is disruptive, as your ownCloud server will be put into :ref:`maintenance mode <maintenance_mode_label>`. 
- Large installations may take several hours to complete the upgrade.
- Downgrading **is not supported** as it risks corrupting your data. If you want to revert to an older ownCloud version, make a new, fresh installation and then restore your data from backup. Before doing this, file a support ticket (if you have paid support) or ask for help in the ownCloud forums to resolve your issue without downgrading.
- Metadata (i.e., shares) will be lost since the DB will not be restored.

Prerequisites
-------------

We strongly recommend that you always maintain :doc:`regular backups <backup>` as well as make a fresh backup before every upgrade.
We also recommend that you review any installed third-party apps for compatibility with the new ownCloud release. 
Ensure that they are all disabled before beginning the upgrade.
After the upgrade is complete re-enable any which are compatible with the new release.

.. warning::
   Install unsupported apps at your own risk.

.. _owncloud.org/install/:
   https://owncloud.org/install/  

Upgrade Options
---------------

There are three ways to upgrade your ownCloud server:

#. Using the :doc:`Updater App <update>` (Server Edition only). This is recommended for shared hosters and for users who want an easy way to track different release channels. It is *not available* and *not supported* on the Enterprise edition. This is the recommended method.
#. Using your :doc:`Linux package manager <package_upgrade>` with our official ownCloud repositories. 
#. :doc:`Manually upgrading <manual_upgrade>` with the latest ownCloud release from `owncloud.org/install/`_. 

.. note::
   Please remember that in scale-out deployments (where your database is sitting somewehere else, not on the same machine as the webserver) using the package manager is going to install all the related dependencies, unless the ``owncloud-enterprise-files`` (for the Enterprise edition) or the ``owncloud-files`` (for the Community edition) package is being used.

.. note::
   Enterprise customers will use their Enterprise software repositories to maintain their ownCloud servers, rather than the Open Build Service. Please see :doc:`../enterprise/installation/install` for more information.


Reverse Upgrade
---------------

If you need to reverse your upgrade, see :doc:`restore`.

Troubleshooting
---------------

When upgrading ownCloud and you are running MySQL or MariaDB with binary logging enabled, your upgrade may fail with these errors in your MySQL/MariaDB log::

 An unhandled exception has been thrown:
 exception 'PDOException' with the message 'SQLSTATE[HY000]: General error: 1665 
 Cannot execute statement: impossible to write to binary log since 
 BINLOG_FORMAT = STATEMENT and at least one table uses a storage engine limited to row-based logging. InnoDB is limited to row-logging when transaction isolation level is READ COMMITTED or READ UNCOMMITTED.' 

Please refer to :ref:`db-binlog-label` on how to correctly configure your environment.

Occasionally, *files do not show up after an upgrade*. A rescan of the files can help::

 sudo -u www-data php console.php files:scan --all

See `the owncloud.org support page <https://owncloud.org/support>`_ for further resources for both home and enterprise users.

Sometimes, ownCloud can get *stuck in a upgrade*. 
This is usually due to the process taking too long and encountering a PHP time-out. Stop the upgrade process this way::

 sudo -u www-data php occ maintenance:mode --off
  
Then start the manual process::
  
 sudo -u www-data php occ upgrade

If this does not work properly, try the repair function::

 sudo -u www-data php occ maintenance:repair

.. _migration_test_label:

Testing a Migration 
-------------------

Previous versions of ownCloud included a migration test. 
ownCloud first ran a migration simulation by copying the ownCloud database and performing the upgrade on the copy, to ensure that the migration would succeed. 

Then the copied tables were deleted after the upgrade was completed. 
This doubled the upgrade time, so admins could skip this test (by risking a failed upgrade) with ``php occ upgrade --skip-migration-test``.

The migration test has been removed from ownCloud 9.2. ownCloud server admins should have current backups before migration, and rely on backups to correct any problems from the migration.

Migrating with the Encryption Backend Enabled
---------------------------------------------

The encryption backend was changed twice between ownCloud 7.0 and 8.0 as well as
between 8.0 and 8.1. If you're upgrading from these older versions, please refer to :ref:`upgrading_encryption_label` for the needed migration steps.

Migrating from Debian to Official ownCloud Packages
---------------------------------------------------

As of March 2016, Debian will not include ownCloud packages. Debian users can 
migrate to the official ownCloud packages by following this guide, `Upgrading ownCloud on Debian Stable to official packages <https://owncloud.org/blog/upgrading-owncloud-on-debian-stable-to-official-packages/>`_.

Upgrading from 9.10 to 10.0.2
-----------------------------

To upgrade ownCloud from version 9.10 to 10.0.2 requires just a few steps.
In this guide, the following assumptions are made:

#. ownCloud 10.0.2 is the latest version.
#. Your existing installation is in ``/var/www/owncloud``.
#. Your new installation is in ``/var/www/owncloud-10.0.2``.
#. The commands are executed as the web server user, which is ``www-data``.
#. Your ownCloud installation is run with *Apache 2*, *PHP 5.6*, and *Ubuntu 14.04*.

Put ownCloud in Maintenance Mode
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Before you begin, enable maintenance mode in the existing ownCloud installation.
You can do this by running the following command:

.. code-block:: console
   
   cd /var/www/owncloud/
   sudo -u www-data ./occ maintenance:mode --on

Stop the Webserver
~~~~~~~~~~~~~~~~~~

Next, stop your web server. 
To do this, run the following command:

.. code-block:: console
   
   sudo service apache2 stop

Get a Copy of ownCloud 10.0.2
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can download ownCloud 10 from several places. 
However, the best place is <download.owncloud.org>. 
To do so, run the following command:

.. code-block:: console
   
   # Download and extract the code to /var/www/owncloud-10.0.2
   wget -qO- https://download.owncloud.org/community/owncloud-10.0.2.tar.bz2 | \ 
     tar --transform 's/^owncloud/owncloud-10.0.2/' -jxv -C /var/www/

Copy config/config.php from the existing installation to the new source

Next, copy ``config/config.php`` from the current installation to the new, 10.0.2, source.
You can do this by running the following command:

.. code-block:: console
   
   cp -v /var/www/owncloud/config/config.php /var/www/owncloud-10.0.2/config/config.php

If you use the default ownCloud data directory, then you need to copy it from the existing installation to the new source directory as well. 
You can do this by running the following command:

.. code-block:: console
   
   cp -rv /var/www/owncloud/data /var/www/owncloud-10.0.2/data

If your data directory is located outside of the ownCloud installation directory, then you can safely skip this command.

Update config/config.php (optional)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If the data directory is inside the new ownCloud directory, you need to update ``config/config.php`` to point to it.
In your editor of choice, open ``config/config.php`` and change the value of ``datadirectory`` to the new data directory location.

Update the Web Server Configuration to Use the New Source 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Let’s assume that Apache 2 is configured to serve ownCloud from a `VirtualHost`_ that has the following configuration:

.. code-block:: console
   
   <VirtualHost *:80>

     ServerName owncloud.app.localdomain
     ServerAlias www.owncloud.app.localdomain
     DocumentRoot /var/www/owncloud/
     ErrorLog ${APACHE_LOG_DIR}/error.owncloud.log
     CustomLog ${APACHE_LOG_DIR}/access.owncloud.log combined

     Alias /owncloud "/var/www/owncloud/"

     <Directory /var/www/owncloud/>
       Options +FollowSymlinks
       AllowOverride All

      <IfModule mod_dav.c>
       Dav off
      </IfModule>

      SetEnv HOME /var/www/owncloud
      SetEnv HTTP_HOME /var/www/owncloud

     </Directory>

   </VirtualHost>
   
In that configuration, change the `Alias`_ and `DocumentRoot`_ directives to point to the ownCloud 10.0.2 source. 
Specifically, change them to be as in the following example:

.. code-block:: console

   Alias /owncloud "/var/www/owncloud-10.0.0RC1/"
   DocumentRoot /var/www/owncloud-10.0.0RC1/

Run the Update Process
~~~~~~~~~~~~~~~~~~~~~~

You can update ownCloud either by using the Web UI or the command-line. 
To update via the Web UI, open http://owncloud.app.localdomain in your web browser of choice.
Alternatively, use the command-line tool, :ref:`occ <command_line_upgrade_label>`, to upgrade the installation.

.. note::
   ``occ`` offers many advantages, and far more functionality and flexibility than the Web UI. A key one is its scriptability.
   
To upgrade from the command-line, run:

.. code-block:: console
   
   sudo -u www-data ./occ upgrade

Depending on your installation, you should see output similar to the following:

.. code-block:: console
   
   ownCloud or one of the apps require upgrade - only a limited number of commands are available
   You may use your browser or the occ upgrade command to do the upgrade
   Set log level to debug
   Updating database schema
   Updated database
   Updating <dav> ...
   Updated <dav> to 0.2.8
   Drop old database tables

    Done
    28/28 [============================] 100%
   Remove old (< 9.0) calendar/contact shares
    Done
    4/4 [============================] 100%
   Fix permissions so avatars can be stored again
    Done
    2/2 [============================] 100%
   Move user avatars outside the homes to the new location
    Done
    1/1 [============================] 100%
   Update successful
   Maintenance mode is kept active
   Reset log level

Disable Maintenance Mode
~~~~~~~~~~~~~~~~~~~~~~~~

Now that ownCloud is upgraded, disable maintenance mode using the following command:

.. code-block:: console
   
   sudo -u www-data ./occ maintenance:mode --off

Restart the Webserver
~~~~~~~~~~~~~~~~~~~~~

Finally, restart the web server, by running the following command:

.. code-block:: console
   
   sudo service apache2 start
   
.. Links
   
.. _Alias: https://httpd.apache.org/docs/current/mod/mod_alias.html#alias
.. _DocumentRoot: https://httpd.apache.org/docs/current/mod/core.html#documentroot
.. _VirtualHost: https://httpd.apache.org/docs/current/mod/core.html#virtualhost
