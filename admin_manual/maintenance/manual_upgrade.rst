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

  # This example assumes Ubuntu Linux and MariaDb
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

Download and unpack the latest ownCloud Server release from `owncloud.org/install/`_ into an empty directory **outside** of your current installation.
Unpacking the server release creates a new ``owncloud`` directory, populated with your new server files. 
   
.. note:: 
   To unpack your new tarball, run ``tar xjf owncloud-[version].tar.bz2``.
    
.. note:: 
   Enterprise users must download their new ownCloud archives from their accounts on `<https://customer.owncloud.com/owncloud/>`_.

Then rename your current ownCloud directory, for example, from ``owncloud`` to ``owncloud-old``.
Copy the newly unpacked ownCloud server directory and its contents, to the original location of your existing server, so that your installation remains in the existing location. 
::

  # Assumes that the new release was unpacked in /tmp/
  mv /tmp/owncloud /var/www/

Setup the New Installation
--------------------------

With the new source files in place of the old ones, next copy the ``config.php`` file from your old ownCloud directory to your new ownCloud directory.
::

  cp -v /var/www/owncloud-old/config/config.php /var/www/owncloud/config/config.php

If you keep your ``data/`` directory *inside* your ``owncloud/`` directory, copy it from your old version of ownCloud to your new version. 
If you keep it *outside* of your ``owncloud/`` directory, then you don't have to do anything with it, because its location is configured in your original ``config.php``, and none of the upgrade steps touch it.

If you are using 3rd party applications, look in your new ``/var/www/owncloud/apps/`` directory to see if they are there. 
If not, copy them from your old ``apps/`` directory to your new one, and make sure that the directory permissions are the same as for the other ones.

With all that done, restart your web server.
::

  sudo service apache2 start

Upgrade the Installation
------------------------

With the new setup in place, next launch the upgrade process from the command line.
::
    
  sudo -u www-data php occ upgrade

.. note:: 
   The optional parameter to skip migration tests during this step was removed in oC 9.2. 
   See :ref:`migration_test_label` for background information. 
   See :doc:`../configuration/server/occ_command` to learn more about the occ command.
     
The upgrade operation can take anywhere from a few minutes to a few hours, depending on the size of your installation. 
When it is finished you will see either a success message, or an error message which indicates why the process did not complete successfully.   

Disable Maintenance Mode
------------------------

Assuming your upgrade succeeded, next disable maintenance mode.
The simplest way is by using occ from the command line.

::

   sudo -u www-data php occ maintenance:mode --off

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
