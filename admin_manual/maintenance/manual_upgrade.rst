=======================
Manual ownCloud Upgrade
=======================

.. warning:: When upgrading from oC 9.0 to 9.1 with existing Calendars or Adressbooks
   please have a look at the :doc:`../release_notes` of oC 9.0 for important info
   about the needed migration steps during that upgrade.

Always start by making a fresh backup and disabling all 3rd party apps.

Put your server in maintenance mode. This prevents new logins, locks the 
sessions of logged-in users, and displays a status screen so users know what is 
happening. There are two ways to do this, and the preferred method is to use the 
:doc:`occ command <../configuration_server/occ_command>`, which you must run as 
your HTTP user. This example is for Ubuntu Linux::

 sudo -u www-data php occ maintenance:mode --on
 
The other way is by entering your ``config.php`` file and changing 
``'maintenance' => false,`` to ``'maintenance' => true,``. 

1. Back up your existing ownCloud Server database, data directory, and 
   ``config.php`` file. (See :doc:`backup`.)
2. Download and unpack the latest ownCloud Server release (Archive file) from 
   `owncloud.org/install/`_ into an empty directory outside 
   of your current installation.
   
   .. note:: To unpack your new tarball, run:
      tar xjf owncloud-[version].tar.bz2
    
.. note:: Enterprise users must download their new ownCloud archives from 
   their accounts on `<https://customer.owncloud.com/owncloud/>`_
   
3. Stop your Web server.

4. Rename your current ownCloud directory, for example ``owncloud-old``.

5. Unpacking the new archive creates a new ``owncloud`` directory populated 
   with your new server files. Copy this directory and its contents to the 
   original location of your old server, for example ``/var/www/``, so that 
   once again you have ``/var/www/owncloud``.

6. Copy the ``config.php`` file from your old ownCloud directory to your new 
   ownCloud directory.

7. If you keep your ``data/`` directory in your ``owncloud/`` directory, copy 
   it from your old version of ownCloud to your new ``owncloud/``. If you keep 
   it outside of ``owncloud/`` then you don't have to do anything with it, 
   because its location is configured in your original ``config.php``, and 
   none of the upgrade steps touch it.

8. If you are using 3rd party applications, look in your new ``owncloud/apps/`` 
   directory to see if they are there. If not, copy them from your old ``apps/``
   directory to your new one. Make sure the directory permissions of your third
   party application directories are the same as for the other ones.

9. Restart your Web server.

10. Now launch the upgrade from the command  line using ``occ``, like this 
    example on CentOS Linux::
    
     sudo -u apache php occ upgrade

  Optionally disable the :ref:`migration_test_label` which might take a
  long time on large installations.

  See :doc:`../configuration_server/occ_command` to learn more.
     
11. The upgrade operation takes a few minutes to a few hours, depending on the 
    size of your installation. When it is finished you will see a success 
    message, or an error message that will tell where it went wrong.   

Assuming your upgrade succeeded, disable the maintenance mode::

     sudo -u www-data php occ maintenance:mode --off

Login and take a look at the bottom of your Admin page to 
verify the version number. Check your other settings to make sure they're 
correct. Go to the Apps page and review the core apps to make sure the right 
ones are enabled. Re-enable your third-party apps. Then apply strong 
permissions to your ownCloud directories (:ref:`strong_perms_label`).

.. _owncloud.org/install/:
   https://owncloud.org/install/