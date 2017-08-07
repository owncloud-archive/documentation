===============================
Migrating to a Different Server
===============================

If the need arises, ownCloud can be migrated to a different server. 
A typical use case would be a hardware change or a migration from :doc:`the Enterprise appliance <../enterprise/appliance/index>` to a physical server. 
All migrations have to be performed with ownCloud in maintenance mode. 
Online migration is supported by ownCloud only when implementing industry-standard clustering and high-availability solutions **before** ownCloud is installed for the first time.

To start, let's work through a potential use case. 
A configured ownCloud instance runs reliably on one machine, but for some reason the instance needs to be moved to a new machine. 
Depending on the size of the ownCloud instance the migration might take several hours. 

For the purpose of this use case, it is assumed that:

#. The end users reach the ownCloud instance via a virtual hostname (such as a DNS ``CNAME`` record) which can be pointed at the new location. 
#. The authentication method (e.g., LDAP) remains the same after the migration.

.. warning:: 
   During the migration, do not make any changes to the original system, except for putting it into maintenance mode.
   This ensures, should anything unforeseen happen, that you can go back to your existing installation and resume availability of your |name| installation while debugging the problem.

How to Migrate
--------------

Firstly, set up the new machine with your desired Linux distribution. 
At this point you can either :doc:`install ownCloud manually <../installation/source_installation>` via the compressed archive, or doc:`with your Linux package manager <../installation/linux_installation>`.

Then, on the original machine turn on maintenance mode and then stop ownCloud. 
After waiting for 6 - 7 minutes for all sync clients to register that the server is in maintenance mode, ref:`stop the web server <maintenance_commands_label>` that is serving ownCloud.

After that, :ref:`create a database dump from the database <backup_database_label>`, copy it to the new machine, and :ref:`import it into the new database <restore_database_label>`.

Then, copy only your data, configuration, and database files from your original ownCloud instance to the new machine (See :doc:`backup` and :ref:`restore_directories_label`). 

.. warning::
   You must keep the ``data/`` directory's original file path during the migration. 
   However, :ref:`you can change it <datadir_move_label>` before you begin the migration, or after the migration’s completed.

The data files should keep their original timestamp otherwise the clients will re-download all the files after the migration. 
This step might take several hours, depending on your installation. 
This can be done on a number of sync clients, such as by using ``rsync`` with ``-t`` option

With ownCloud still in maintenance mode and before changing the DNS ``CNAME`` record, start up the database and web server on the new machine. 
Then point your web browser to the migrated ownCloud instance and confirm that: 

1. You see the maintenance mode notice
2. That a log file entry is written by both the web server and ownCloud
3. That no error messages occur. 

If all of these things occur, then take ownCloud out of maintenance mode and repeat. 
After doing this, log in as an admin and confirm that ownCloud functions as normal.

At this point, change the DNS ``CNAME`` entry to point your users to the new location.
And with the ``CNAME`` entry updated, you now need to update the trusted domains.
    
.. _trusted_domains_label: 

Managing Trusted Domains
------------------------

All URLs used to access your ownCloud server must be whitelisted in your ``config.php`` file, under the ``trusted_domains`` setting. 
Users are allowed to log into ownCloud only when they point their browsers to a URL that is listed in the ``trusted_domains`` setting. 

.. note:: 
   This setting is important when changing or moving to a new domain name.
   You may use IP addresses and domain names.
 
A typical configuration looks like this:

.. code-block:: php

  'trusted_domains' => [
     0 => 'localhost', 
     1 => 'server1.example.com', 
     2 => '192.168.1.50',
  ],

The loopback address, ``127.0.0.1``, is automatically whitelisted, so as long as you have access to the physical server you can always log in. 
In the event that a load-balancer is in place, there will be no issues as long as it sends the correct ``X-Forwarded-Host`` header. 
When a user tries a URL that is not whitelisted, the following error message will appear:

.. figure:: ../installation/images/install-wizard-a4.png
   :scale: 75%
   :alt: Error message when URL is not whitelisted

Example Migration
-----------------

Now, let’s step through an example migration. 
For this example to work, you will need the following on both the servers that you will use for the migration:

- Ubuntu 16.04
- SSH with ``PermitRootLogin`` set to ``yes``

Preparation
~~~~~~~~~~~

Before you can perform a migration, you have to prepare.
To do this, first make sure SSH is installed:

.. code-block:: console
   
   apt install ssh -y

Next, edit ssh-config and enable root ssh login.

.. code-block:: console
   
   nano /etc/ssh/sshd_config
   PermitRootLogin yes

And then restart SSH.
   
.. code-block:: console
   
   service ssh restart

Lastly, install ownCloud on the new server.

Migration
~~~~~~~~~

Enable Maintenance Mode
^^^^^^^^^^^^^^^^^^^^^^^

The first step is to enable maintenance mode. 
To do that, use the following commands:

.. code-block:: console

    cd /var/www/owncloud/
    sudo -u www-data php occ maintenance:mode --on

After that's done, wait for 6-7 minutes and stop Apache:

.. code-block:: console

   service apache2 stop

Transfer the Database
^^^^^^^^^^^^^^^^^^^^^

Now, you have to transfer the database from the old server to the new one.
To do that, first backup the database.

.. code-block:: console 

    cd /var/www/owncloud/
    mysqldump --single-transaction -h localhost -u admin -ppassword owncloud > owncloud-dbbackup.bak

Then, export the database to the new server.

.. code-block:: console 

    rsync -Aaxt owncloud-dbbackup.bak root@new_server_address:/var/www/owncloud 

With that completed, import the database on new server.

.. code-block:: console 

    mysql -h localhost -u admin -ppassword owncloud < owncloud-dbbackup.bak

.. note:: 
   You can find the values for the mysqldump command in your config.php, in your owncloud root directory.
   ``[server]= dbhost, [username]= dbuser, [password]= dbpassword, and [db_name]= dbname``.

.. note:: 
   **For InnoDB tables only** 
   The --single-transaction flag will start a transaction before running. 
   Rather than lock the entire database, this will let mysqldump read the database in the current state at the time of the transaction, making for a consistent data dump.

.. note:: 
   **For Mixed MyISAM / InnoDB tables**
   Either dumping your MyISAM tables separately from InnoDB tables or use --lock-tables
   instead of --single-transaction to guarantee the database is in a consistent state when using mysqldump.

Transfer Data and Configure the New Server
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   rsync -Aavxt config data root@new_server_address:/var/www/owncloud 

.. warning:: 
   If you want to move your data directory to another location on the target server, it is advised to do   
   this as a second step. Please see the data directory migration document :ref:`datadir_move_label` for more details.

Finish the Migration
^^^^^^^^^^^^^^^^^^^^

Now it’s time to finish the migration. 
To do that, on the new server, first verify that ownCloud is in maintenance mode.

.. code-block:: console 

   sudo -u www-data php occ maintenance:mode

Next, start up the database and web server on the new machine. 

.. code-block:: console

   service mysql start
   service apache2 start

With that done, point your web browser to the migrated ownCloud instance, and confirm that you see the maintenance mode notice, and that no error messages occur.
If both of these occur, take ownCloud out of maintenance mode.

.. code-block:: console

   sudo -u www-data php occ maintenance:mode --off

And finally, log in as admin and confirm normal function of ownCloud.
If you have a domain name, and you want an SSL certificate, we recommend `certbot`_.

Reverse the Changes to ssh-config
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Now you need to reverse the change to ssh-config.
Specifically, set ``PermitRootLogin`` to ``no`` and restart ssh.
To do that, run the following command:

.. code-block:: console
    
   service ssh restart

Update DNS and Trusted Domains
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Finally, update the DNS' ``CNAME`` entry to point to your new server.
If you have not only migrated physically from server to server but have also changed your ownCloud server's domain name, you also need to update the domain in :ref:`the Trusted Domain setting <trusted_domains_label>` in ``config.php``, on the target server.
   
.. Links
   
.. _the Enterprise appliance: http://admin.manual.localdomain/enterprise/appliance/index.html
.. _certbot: https://certbot.eff.org/
