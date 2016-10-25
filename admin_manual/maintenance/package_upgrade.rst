==============================
Upgrade ownCloud From Packages
==============================

Upgrade Quickstart
------------------

The best method for keeping ownCloud current on Linux servers is by configuring 
your system to use ownCloud's `Open Build Service`_ repository. Then stay 
current by using your Linux package manager to install fresh ownCloud packages. 
After installing upgraded packages you must run a few more steps to complete 
the upgrade. These are the basic steps to upgrading ownCloud:

.. warning:: Make sure that you don't skip a major release when upgrading via repositories.
   For example you can't upgrade from 8.1.x to 9.0.x directly as you would skip the 8.2.x
   major release. See :ref:`skipped_release_upgrade_label` for more information.

* :doc:`Disable <../installation/apps_management_installation>` all third-party apps.
* Make a :doc:`fresh backup <backup>`.
* Upgrade your ownCloud packages.
* Run :ref:`occ upgrade <command_line_upgrade_label>` (Optionally disable the
  :ref:`migration_test_label` which might take a long time on large installations).
* :ref:`Apply strong permissions <strong_perms_label>` to your ownCloud directories.
* Take your ownCloud server out of :ref:`maintenance mode <maintenance_commands_label>`.  
* Re-enable third-party apps.

.. warning:: When upgrading from oC 9.0 to 9.1 with existing Calendars or Addressbooks
   please have a look at the :ref:`9.0 release notes<9.0_release_notes_label>` for
   important information about the needed migration steps during that upgrade.

Upgrade Tips
------------

Upgrading ownCloud from our `Open Build Service`_ repository is just like any 
normal Linux upgrade. For example, on Debian or Ubuntu Linux this is the 
standard system upgrade command::

 apt-get update && apt-get upgrade
 
Or you can upgrade just ownCloud with this command::

 apt-get update && apt-get install owncloud
 
On Fedora, CentOS, and Red Hat Linux use ``yum`` to see all available updates::

 yum check-update
 
You can apply all available updates with this command::
 
 yum update
 
Or update only ownCloud::
 
 yum update owncloud
 
Your Linux package manager only downloads the current ownCloud packages. Then 
your ownCloud server is immediately put into maintenance mode. You may not see 
this until you refresh your ownCloud page.

.. figure:: images/upgrade-1.png
   :scale: 75%
   :alt: ownCloud status screen informing users that it is in maintenance mode.

Then use ``occ`` to complete the upgrade. You must run ``occ`` as your HTTP 
user. This example is for Debian/Ubuntu::

 sudo -u www-data php occ upgrade

This example is for CentOS/RHEL/Fedora::

 sudo -u apache php occ upgrade

Optionally disable the :ref:`migration_test_label` which might take a
long time on large installations.

See :doc:`../configuration_server/occ_command` to learn more.

Setting Strong Directory Permissions
------------------------------------

After upgrading, verify that your ownCloud directory permissions are set 
according to :ref:`strong_perms_label`.

.. _Open Build Service: 
   https://download.owncloud.org/download/repositories/stable/owncloud/

.. _skipped_release_upgrade_label:
   
Upgrading Across Skipped Releases
---------------------------------

It is best to update your ownCloud installation with every new point release (e.g. 8.1.10), 
and to never skip any major release (e.g. don't skip 8.2.x between 8.1.x and 9.0.x). If you
have skipped any major release you can bring your ownCloud current with these steps:

#. Add the repository of your current version (e.g. 8.1.x)
#. Upgrade your current version to the latest point release (e.g. 8.1.10) via your package manager
#. Run the ``occ upgrade`` routine (see Upgrade Quickstart above)
#. Add the repository of the next major release (e.g. 8.2.x)
#. Upgrade your current version to the next major release (e.g. 8.2.8) via your package manager
#. Run the ``occ upgrade`` routine (see Upgrade Quickstart above)
#. Repeat from step 4 until you reach the last available major release (e.g. 9.1.x)

You'll find repositories of previous ownCloud major releases in the `ownCloud Server Changelog 
<https://owncloud.org/changelog/>`_.
