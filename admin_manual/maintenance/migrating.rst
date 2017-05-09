===============================
Migrating to a Different Server
===============================

If the need arises ownCloud can be migrated to a different server. A typical use case would be a hardware change or a migration from the virtual appliance to a physical server. All migrations have to be performed with ownCloud offline and no accesses being made. Online migration is supported by ownCloud only when implementing industry-standard clustering and high-availability solutions before ownCloud is installed for the first time.

To start, let us be specific about the use case. A configured ownCloud instance runs reliably on one machine. For some reason (e.g. more powerful machine is available, but a move to a clustered environment not yet needed) the instance needs to be moved to a new machine. Depending on the size of the ownCloud instance the migration might take several hours. As a prerequisite it is assumed that the end users reach the ownCloud instance via a virtual hostname (a ``CNAME`` record in DNS) which can be pointed at the new location. It is also assumed that the authentication method (e.g. LDAP) remains the same after the migration.

.. warning:: At NO TIME any changes to the **ORIGINAL** system are required
    **EXCEPT** putting ownCloud into maintenance mode.

    This ensures, should anything unforeseen happen, you can go
    back to your existing installation and provide your users
    with a running ownCloud while debugging the problem.

#.  Set up the new machine with your desired Linux distribution. At this point you can either install ownCloud manually via the compressed archive (see :doc:`../installation/source_installation`), or with your Linux package manager (see :doc:`../installation/linux_installation`).

#.  On the original machine turn on maintenance mode and then stop ownCloud. After waiting for 6-7 minutes for all sync clients to register the server as in maintenance mode, stop the application and/or Web server that serves ownCloud. (See :ref:`maintenance_commands_label`.)

#.  Create a dump from the database and copy it to the new machine, and import it into the new database (See :ref:`backup_database_label` and :ref:`restore_database_label`).

#.  Copy ONLY your data, configuration and database files from your original ownCloud instance to the new machine (See :doc:`backing-up-the-config-and-data-directories` and :ref:`restore_directories_label`). 

.. note:: You must keep the ``data/`` directory's original filepath. Do not change this!

#. The data files should keep their original timestamp (can be done by using ``rsync`` with ``-t`` option) otherwise the clients will re-download all the files after the migration. This step might take several hours, depending on your installation.

#.  With ownCloud still in maintenance mode (confirm!) and **BEFORE** changing the ``CNAME`` record in the DNS start up the database, Web server / application server on the new machine and point your Web browser to the migrated ownCloud instance. Confirm that you see the maintenance mode notice, that a logfile entry is written by both the Web server and ownCloud and that no error messages occur. Then take ownCloud out of maintenance mode and repeat. Log in as admin and confirm normal function of ownCloud.

#.  Change the ``CNAME`` entry in the DNS to point your users to the new
    location.
    
With the ``CNAME`` updated, you now need to updated the trusted domains.
    
.. _trusted_domains_label: 

Trusted Domains
---------------

All URLs used to access your ownCloud server must be whitelisted in your 
``config.php`` file, under the ``trusted_domains`` setting. 
Users are allowed to log into ownCloud only when they point their browsers to a URL that is listed in the ``trusted_domains`` setting. 

.. note:: 
   This setting is important when changing or moving to a new domain name.

You may use IP addresses and domain names. 
A typical configuration looks like this::

 'trusted_domains' => 
   array (
    0 => 'localhost', 
    1 => 'server1.example.com', 
    2 => '192.168.1.50',
 ),

The loopback address, ``127.0.0.1``, is automatically whitelisted, so as long as you have access to the physical server you can always log in. 
In the event that a load balancer is in place there will be no issues as long as it sends the correct X-Forwarded-Host header. 
When a user tries a URL that is not whitelisted the following error appears:

.. figure:: ../installation/images/install-wizard-a4.png
   :scale: 75%
   :alt: Error message when URL is not whitelisted

=======
Example
=======

.. note:: For this example to work, you need this on both servers:

* Ubuntu 16.04
* SSH
* PermitRootLogin set to "yes"

optional:

* Domain name (for Let's Encrypt)
* Modules: smb-client nfs-common rpcbin (for WND)


Install SSH::

   apt install ssh -y

Edit ssh-config (enable root ssh login)::

   nano /etc/ssh/sshd_config

Change PermitRootLogin to "yes"::

   PermitRootLogin yes
   
Restart ssh service::

   service ssh stop
   service ssh start

Install ownCloud on new server

=========
Migration
=========

1. Put original server in maintenance mode:

Go in owncloud dir::

      cd /var/www/owncloud/

Switch to maintenance mode::

      sudo -u www-data php occ maintenance:mode --on

wait for 6-7 min and stop apache2::

   service apache2 stop

2. Transfer the database

Go in owncloud dir::

      cd /var/www/owncloud/

Backup the database::

   mysqldump --single-transaction -h localhost -u admin -ppassword owncloud > owncloud-dbbackup.bak

.. note:: You can find the values for the mysqldump command in your config.php at your owncloud directory.
[server]= dbhost, [username]= dbuser, [password]= dbpassword, and [db_name]= dbname.

.. note:: For InnoDB tables only:
The --single-transaction flag will start a transaction before running. Rather than lock the entire database, this will let mysqldump read the database in the current state at the time of the transaction, making for a consistent data dump.

For Mixed MyISAM / InnoDB tables:
Either dumping your MyISAM tables separately from InnoDB tables or use --lock-tables instead of --single-transaction to guarantee the database is in a consistent state when using mysqldump.


Export the database **to** new server::

   rsync -Aaxt owncloud-dbbackup.bak root@new_server_address:/var/www/owncloud 

Import the database **on** new server::

   mysql -h localhost -u admin -ppassword owncloud < owncloud-dbbackup.bak

3. Copy data, config to new server::

      rsync -Aavxt config data root@new_server_address:/var/www/owncloud 

.. warning:: If you want to move your datadirectory to another location on the target server, it is advised to do this as a second step. Please see the datadirectory migration document :ref:`datadir_move_label` for more details.

4. Finish the migration:

On new server:

- verify that owncloud is in maintenance mode::

    sudo -u www-data php occ maintenance:mode

- start up the database::

    service mysql start

- start up web / application server on the new machine::

   service apache2 start

- point your web browser to the migrated ownCloud instance::

   localhost/owncloud

- confirm that you see the maintenance mode notice (check)

- no error messages occur (check)

- take ownCloud out of maintenance mode::

   sudo -u www-data php occ maintenance:mode --off

- log in as admin and confirm normal function of ownCloud

- if you have a domain name, and you want a SSL certificate, we recommend certbot.

5. Reverse the changes you made to the ssh-config:

Edit ssh-config::

   nano /etc/ssh/sshd_config

Change PermitRootLogin to "no"::

   PermitRootLogin no

Restart ssh service::

   service ssh stop
   service ssh start

6.
Change the CNAME entry in the DNS to point your users to the new location.

.. note:: If you have not only migrated phyiscally from server to server but also use a new domain name to access your instance, you need to update (add the new domain) the Trusted Domain setting in config.php at the target server.
