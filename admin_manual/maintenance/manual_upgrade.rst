=======================
Manual ownCloud Upgrade
=======================

.. warning:: 
   When upgrading from oC 9.0 to 9.1 with existing Calendars or Addressbooks, please have a look at the :doc:`../release_notes` of ownCloud 9.0 for important info about the needed migration steps during that upgrade.

Backup Your Existing Installation
---------------------------------

First, :doc:`backup <backup>` the following items: 

- The ownCloud server data directory
- The ``config.php`` file
- All 3rd party apps
- The ownCloud server database 

::

  # This example assumes Ubuntu Linux and MariaDB

  cp -rv /var/www/owncloud /opt/backup/owncloud
  mysqldump <db_name> > /opt/backup/backup-file.sql

Enable Maintenance Mode
-----------------------

Then, put your server in :doc:`maintenance mode <enable_maintenance>`, and disable :ref:`Cron jobs <cron_job_label>`. 
Doing so prevents new logins, locks the sessions of logged-in users, and displays a status screen so that users know what is happening. 

There are two ways to enable maintenance mode. 
The preferred method is to use the :doc:`occ command <../configuration/server/occ_command>` — which you must run as your webserver user. 
The other way is by entering your ``config.php`` file and changing ``'maintenance' => false,`` to ``'maintenance' => true,``. 
::

  # Enable maintenance mode using the occ command.
  sudo -u www-data php occ maintenance:mode --on
  
  # Disable Cron jobs
  sudo service cron stop
   
Irrespective of the approach that you take, with those steps completed, next stop your webserver.
::

  sudo service apache2 stop

Download the Latest Installation
--------------------------------

Download the latest ownCloud server release from `owncloud.org/install/`_ into an empty directory **outside** of your current installation.
    
.. note:: 
   Enterprise users must download their new ownCloud archives from their accounts on `<https://customer.owncloud.com/owncloud/>`_.

Setup the New Installation
--------------------------

Not all installations are the same, so we encourage you to take one of two paths to upgrade your ownCloud installation. 
These are the standard upgrade and the power user upgrade.

If you're reasonably new to ownCloud, or not too familiar with upgrading an ownCloud installation, please follow the standard upgrade.
Otherwise, take the approach that you're most comfortable with, likely the power
user upgrade.

.. note::
   Regardless of which approach that you take, they will both assume that your existing ownCloud installation is located in the default location: ``/var/www/owncloud``.

The Standard Upgrade
~~~~~~~~~~~~~~~~~~~~

Delete all files and folders in your existing ownCloud directory (``/var/www/owncloud``) — **except** ``data`` and ``config``. 

.. attention:: Don't keep the ``apps`` directory.

With those files and folders deleted, extract the archive of the latest ownCloud server, over the top of your existing installation.

::

  # Extract the .tar.bz2 archive
  tar -jxf owncloud-10.0.3.tar.bz2 -C /var/www/

  # Extract the zip archive
  unzip -q owncloud-10.0.3.zip -d /var/www/

The Power User Upgrade
~~~~~~~~~~~~~~~~~~~~~~

Rename your current ownCloud directory, for example, from ``owncloud`` to ``owncloud-old``.
Extract the unpacked ownCloud server directory and its contents to the location of your original ownCloud installation.
::

  # Assumes that the new release was unpacked into /tmp/
  mv /tmp/owncloud /var/www/

With the new source files now in place of the old ones, next copy the ``config.php`` file from your old ownCloud directory to your new ownCloud directory.
::

  cp /var/www/owncloud-old/config/config.php /var/www/owncloud/config/config.php

If you keep your ``data/`` directory *inside* your ``owncloud/`` directory, copy it from your old version of ownCloud to your new version. 
If you keep it *outside* of your ``owncloud/`` directory, then you don't have to do anything with it, because its location is configured in your original ``config.php``, and none of the upgrade steps touch it.

Upgrade the Installation
------------------------

With all that done, restart your web server.
::

  sudo service apache2 start

Disable Core Apps
~~~~~~~~~~~~~~~~~

Before the upgrade can run, several apps need to be disabled, if they’re enabled, before the upgrade can succeed. 
These are: *activity*, *files_pdfviewer*, *files_texteditor*, and *gallery*.
The following command provides an example of how to do so.

::

  sudo -u www-data php occ app:disable activity
  sudo -u www-data php occ app:disable files_pdfviewer
  sudo -u www-data php occ app:disable files_texteditor
  sudo -u www-data php occ app:disable gallery

Start the Upgrade
~~~~~~~~~~~~~~~~~

With the apps disabled and the webserver started, launch the upgrade process from the command line.
::
    
  # Here is an example on CentOS Linux
  sudo -u apache php occ upgrade

.. note:: 
   The optional parameter to skip migration tests during this step was removed in oC 10.0. 
   See :ref:`migration_test_label` for background information. 
   See :doc:`../configuration/server/occ_command` to learn more about the occ command.
     
The upgrade operation can take anywhere from a few minutes to a few hours, depending on the size of your installation. 
When it is finished you will see either a success message, or an error message which indicates why the process did not complete successfully.   

Disable Maintenance Mode
~~~~~~~~~~~~~~~~~~~~~~~~

Assuming your upgrade succeeded, next disable maintenance mode.
The simplest way is by using occ from the command line.

::

   sudo -u www-data php occ maintenance:mode --off

Copy Old Apps
~~~~~~~~~~~~~

If you are using 3rd party applications, look in your new ``/var/www/owncloud/apps/`` directory to see if they are there. 
If not, copy them from your old ``apps/`` directory to your new one, and make sure that the directory permissions are the same as for the other ones.

Finalize the Installation
-------------------------

With maintenance mode disabled, login and:

- Check that the version number reflects the new installation. It's visible at the bottom of your Admin page. 
- Check that your other settings are correct. 
- Go to the Apps page and review the core apps to make sure the right ones are enabled. 
- Re-enable your third-party apps. 
- :ref:`Apply strong permissions <strong_perms_label>` to your ownCloud directories.

.. _owncloud.org/install/:
   https://owncloud.org/install/
