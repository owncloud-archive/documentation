=====================================
How To Manually Move a Data Directory
=====================================

.. _datadir_move_label:

If you need to move your ownCloud data directory from its current location to
somewhere else, here is a manual process that you can take to make it happen.

.. NOTE:: 
   This example assumes that:

   - The current folder is: `/var/www/owncloud/data`
   - The new folder is: `/mnt/owncloud`
   - You're using Apache as your webserver

1. Stop Apache
2. Use rsync to sync the files from the current folder to the new one 
3. Create a symbolic link from the new directory to the old one 
4. Double-check `the directory permissions`_ on the new directory 
5. Restart Apache

To save time, here's the commands which you can copy and use::

  apachectl -k stop 
  rsync -avz /var/www/owncloud/data /mnt/owncloud
  ln -s /mnt/owncloud /www/owncloud/data
  apachectl -k graceful 

.. note:: 
   If you're on CentOS/Fedora, try ``systemctl restart httpd``.
   If you're on Debian/Ubuntu try ``sudo systemctl restart apache2``
   To learn more about the systemctl command, please refer to `the systemd essentials guide`_

Fix Hardcoded Database Path Variables
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you want to manually change the location of the data folder in the database,
run the SQL below:

.. code-block:: sql
   
  UPDATE oc_storages SET id='local::/mnt/owncloud' 
    WHERE id='local::/var/www/owncloud/data'

The other area to check is the `oc_jobs` table. The logrotate process may have
hard-coded a non-standard (or old) value for the data path. To check it, run the
SQL below and see if any results are returned:

.. code-block:: sql

  SELECT * FROM oc_jobs WHERE class = 'OC\Log\Rotate';

If any are, run the SQL below to update them, changing the value as appropriate.

.. code-block:: sql

  UPDATE oc_jobs SET argument = '/your/new/data/path' 
    WHERE id = <id of the incorrect record>;

Fix Application Settings 
~~~~~~~~~~~~~~~~~~~~~~~~

One thing worth noting is that individual apps may reference the data directory
separate from the core system configuration. If so, then you will need to find
which applications do this, and change them as needed. 

For example, if you listed the application configuration by running `occ
config:list`, then you might see output similar to that below:

.. code-block:: json

  {
      "apps": {
          "fictitious": {
              "enabled": "yes",
              "installed_version": "2.3.2",
              "types": "filesystem",
              "datadir": "var/www/owncloud/data"
          }
      }
  }

Here, the "fictitious" application references the data directory as being set to
`var/www/owncloud/data`. So you would have to change the value by using the
`config:app:set` option. Here's an example of how you would update the setting:

.. code-block:: console

  occ config:app:set --value /mnt/owncloud fictitious datadir

.. Links

.. _the directory permissions: https://doc.owncloud.org/server/9.1/admin_manual/installation/installation_wizard.html#strong-perms-label
.. _the systemd essentials guide: https://www.digitalocean.com/community/tutorials/systemd-essentials-working-with-services-units-and-the-journal
