===================
Backing up ownCloud
===================

When you backup your ownCloud server, there are four things that you need to copy:

#. Your ``config/`` directory.
#. Your ``data/`` directory.
#. Your ownCloud database.
#. Your custom theme files, if you have any. (See `Theming ownCloud <https://doc.owncloud.org/server/10.0/developer_manual/core/theming.html>`_)

When you install your ownCloud server from our `Open Build Service <https://download.owncloud.org/download/repositories/stable/owncloud/>`_ packages (or from distro packages, which we do not recommend) **do not backup your ownCloud server files**, which are the other files in your ``owncloud/`` directory such as ``core/``, ``3rdparty/``, ``apps/``, ``assets/``, ``lib/``, and all the rest of the ownCloud files. If you restore these files from backup they may not be in sync with the current package versions, and will fail the code integrity check. This may also cause other errors, such as white pages.

When you install ownCloud from the source tarballs this will not be an issue, and you can safely backup your entire ownCloud installation, with the exception of your ownCloud database. Databases cannot be copied, but you must use the database tools to make a correct database dump.

To restore your ownCloud installation from backup, see :doc:`restore` .

.. _backing_up_the_config_and_data_directories_label:

Backing Up the config/ and data/ Directories
--------------------------------------------

Simply copy your ``config/`` and ``data/`` folder to a place outside of your ownCloud environment. This example uses ``rsync`` to copy the two directories to ``/backupdir``::

    rsync -Aax config data /oc-backupdir/
    
There are many ways to backup normal files, and you may use whatever method you are accustomed to.    

.. _backup_database_label:

Backup Database
---------------

You can't just copy a database, but must use the database tools to make a correct database dump.

MySQL/MariaDB
^^^^^^^^^^^^^

MySQL or MariaDB, which is a drop-in MySQL replacement, is the recommended database engine. To backup MySQL/MariaDB::

    mysqldump --single-transaction -h [server] -u [username] -p[password] [db_name] > owncloud-dbbackup_`date +"%Y%m%d"`.bak



Example::

      mysqldump --single-transaction -h localhost -u username -ppassword owncloud > owncloud-dbbackup_`date +"%Y%m%d"`.bak


SQLite
^^^^^^
::

    sqlite3 data/owncloud.db .dump > owncloud-dbbackup_`date +"%Y%m%d"`.bak

PostgreSQL
^^^^^^^^^^
::

    PGPASSWORD="password" pg_dump [db_name] -h [server] -U [username] -f owncloud-dbbackup_`date +"%Y%m%d"`.bak

Restoring Files From Backup When Encryption Is Enabled
------------------------------------------------------

If you need to restore files from backup, which were backed up when encryption
was enabled, here’s how to do it.

.. NOTE:: 
   This is effective from at least version v8.2.7 of ownCloud onwards. Also,
   this is **not officially supported**. ownCloud officially supports either
   restoring the full backup or restoring nothing — not restoring individual
   parts of it.

1. Restore the file from backup
2. Restore the file's encryption keys from backup
3. Run ``occ files:scan``; this makes the scanner find it. Note that, in the DB
   it will (1) have the "size" set to the encrypted size, which is wrong (and
   bigger) and (2) the "encrypted" flag will be set to 0
4. Update the "encrypted" flag to 1 in the DB to all *files* under
   ``files/path``, but **not** directories. Setting the flag to 1 tells the
   encryption application that the file is encrypted and needs to be processed.
   
.. NOTE::
   There's no need to update the encrypted flag for files in either
   "files_versions" or "files_trashbin", because these aren't scanned or found
   by ``occ files:scan``.
   
5. Download the file once as the user; the file's size will be corrected
   automatically

This process might not be suitable across all environments. 
If it’s not suitable for yours, you might need to run an OCC command that does
the scanning. 
But, that will require the user's password or recovery key.
