===================================
How to Upgrade Your ownCloud Server
===================================

There are three ways to upgrade your ownCloud server:

* Using your :doc:`Linux package manager <package_upgrade>` with our official 
  ownCloud repositories. This is the recommended method. 
* With the :doc:`Updater App <update>` (Server Edition only). Recommended for 
  shared hosters, and for users who want an easy way to track different 
  release channels. (It is not available and not supported on the Enterprise 
  edition.)
* :doc:`Manually upgrading <manual_upgrade>` with the ownCloud ``.tar`` archive 
  from `owncloud.org/install/`_. 
* Manually upgrading is also an option for users on shared hosting; download 
  and unpack the ownCloud tarball to your PC. Delete your existing ownCloud 
  files, except ``data/`` and ``config/`` files, on your hosting account. Then 
  transfer the new ownCloud files to your hosting account, again 
  preserving your existing ``data/`` and ``config/`` files.
* Enterprise customers will use their Enterprise software 
  repositories to maintain their ownCloud servers, rather than the Open Build 
  Service. Please see :doc:`../enterprise_installation/linux_installation` for 
  more information.

.. warning:: When upgrading from oC 9.0 to 9.1 with existing Calendars or Adressbooks
   please have a look at the :doc:`../release_notes` of oC 9.0 for important info
   about the needed migration steps during that upgrade.

When an update is available for your ownCloud server, you will see a 
notification at the top of your ownCloud Web interface. When you click the 
notification it brings you here, to this page.

**It is best to keep your ownCloud server upgraded regularly**, and to install 
all point releases and major releases without skipping any of them, as skipping 
releases increases the risk of errors. Major releases are 8.0, 8.1, 8.2, and 
9.0. Point releases are intermediate releases for each major release. For 
example, 8.0.9 and 8.1.3 are point releases. **Skipping major releases is not 
supported.**

**Upgrading is disruptive**. Your ownCloud server will be put into maintenance 
mode, so your users will be locked out until the upgrade is completed. Large 
installations may take several hours to complete the upgrade.

.. warning:: **Downgrading is not supported** and risks corrupting your data! If 
   you want to revert to an older ownCloud version, make a new, fresh 
   installation and then restore your data from backup. Before doing this, 
   file a support ticket (if you have paid support) or ask for help in the 
   ownCloud forums to see if your issue can be resolved without downgrading.

.. not sure about notifications
.. Update Notifier and Updater App Are Not the Same
.. ------------------------------------------------

.. ownCloud has two update tools: the ownCloud core update notifier, and the 
.. Updater app. Figure 1 shows what you see when the Updater app is enabled: 
.. both 
.. the core notifier and the Updater app control panel are visible on your 
.. admin 
.. page.

.. .. figure:: images/2-updates.png
..   :alt: Both update mechanisms displayed on Admin page.
   
..   *Figure 1: The top yellow banner is the update notifier, and the Updates 
..   section is the Updater app.*
   
.. The core update notifier has only one function, and that is to display a 
.. notification when a new ownCloud release is available. Then you decide which 
.. upgrade method to use. When you maintain your ownCloud server via your Linux 
.. package manager you should ensure that the Updater app is disabled.
  
Prerequisites
-------------

You should always maintain :doc:`regular backups <backup>` and make a fresh 
backup before every upgrade.

Then review third-party apps, if you have any, for compatibility with the new 
ownCloud release. Any apps that are not developed by ownCloud show a 3rd party 
designation. **Install unsupported apps at your own risk**. Then, before the 
upgrade, all 3rd party apps must be disabled. After the upgrade is complete you 
may re-enable them.

.. _owncloud.org/install/:
   https://owncloud.org/install/

Previous ownCloud Releases
--------------------------

You'll find previous ownCloud releases in the `ownCloud Server Changelog 
<https://owncloud.org/changelog/>`_.

Reverse Upgrade
---------------

If you need to reverse your upgrade, see :doc:`restore`.

Troubleshooting
---------------

When upgrading ownCloud and you are running MySQL or MariaDB with binary 
logging enabled, your upgrade may fail with these errors in your MySQL/MariaDB log::

 An unhandled exception has been thrown:
 exception 'PDOException' with message 'SQLSTATE[HY000]: General error: 1665 
 Cannot execute statement: impossible to write to binary log since 
 BINLOG_FORMAT = STATEMENT and at least one table uses a storage engine limited 
 to row-based logging. InnoDB is limited to row-logging when transaction 
 isolation level is READ COMMITTED or READ UNCOMMITTED.' 

Please refer to :ref:`db-binlog-label` on how to correctly configure your 
environment.

Occasionally, *files do not show up after a upgrade*. A rescan of the files can 
help::

 sudo -u www-data php console.php files:scan --all

See `the owncloud.org support page <https://owncloud.org/support>`_ for further
resources for both home and enterprise users.

Sometimes, ownCloud can get *stuck in a upgrade*. This is usually due to the 
process taking too long and encountering a PHP time-out. Stop the upgrade 
process this way::

 sudo -u www-data php occ maintenance:mode --off
  
Then start the manual process::
  
 sudo -u www-data php occ upgrade

If this does not work properly, try the repair function::

 sudo -u www-data php occ maintenance:repair

.. _migration_test_label:

Migration Test
--------------

Before completing the upgrade, ownCloud first runs a simulation by copying all 
database tables to new tables, and then performs the upgrade on them, to ensure 
that the upgrade will complete correctly. The copied tables are deleted after 
the upgrade. This takes twice as much time, which on large installations can be 
many hours, so you can omit this step (by risking a failed upgrade) with the
``--skip-migration-test`` option, like this example on CentOS::

 $ sudo -u apache php occ upgrade --skip-migration-test

or this example on Ubuntu::

 $ sudo -u www-data php occ upgrade --skip-migration-test

See :doc:`../configuration_server/occ_command` to learn more.

Encryption migration from oC 7.0 to 8.0 and 8.0 to 8.1
------------------------------------------------------

The encryption backend was changed twice between ownCloud 7.0 and 8.0 as well as
between 8.0 and 8.1. If you're upgrading from these older versions please refer to 
:ref:`upgrading_encryption_label` for the needed migration steps.

Debian Migration to Official ownCloud Packages
----------------------------------------------

As of March 2016 Debian will not include ownCloud packages. Debian users can 
migrate to the official ownCloud packages by following this guide, 
`Upgrading ownCloud on Debian Stable to official packages 
<https://owncloud.org/blog/upgrading-owncloud-on-debian-stable-to-official- 
packages/>`_.
