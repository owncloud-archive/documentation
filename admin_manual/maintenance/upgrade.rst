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

