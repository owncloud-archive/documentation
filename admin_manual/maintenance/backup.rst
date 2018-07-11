===================
Backing up ownCloud
===================

When you backup your ownCloud server, there are four things that you need to copy:

#. Your ``config/`` directory.
#. Your ``data/`` directory.
#. Your ownCloud database.
#. Your custom theme files, if you have any. (See `Theming ownCloud <https://doc.owncloud.org/server/latest/developer_manual/core/theming.html>`_)

When you install your ownCloud server from our `Open Build Service <https://download.owncloud.org/download/repositories/stable/owncloud/>`_ packages (or from distro packages, which we do not recommend) **do not backup your ownCloud server files**, which are the other files in your ``owncloud/`` directory such as ``core/``, ``3rdparty/``, ``apps/``, ``lib/``, and all the rest of the ownCloud files. If you restore these files from backup they may not be in sync with the current package versions, and will fail the code integrity check. This may also cause other errors, such as white pages.

When you install ownCloud from the source tarballs this will not be an issue, and you can safely backup your entire ownCloud installation, with the exception of your ownCloud database. Databases cannot be copied, but you must use the database tools to make a correct database dump.

To restore your ownCloud installation from backup, see :doc:`restore` .

.. _backing_up_the_config_and_data_directories_label:

Backing Up the config/ and data/ Directories
--------------------------------------------

Simply copy your ``config/`` and ``data/`` folder to a place outside of your ownCloud environment. This example uses ``rsync`` to copy the two directories to ``/oc-backupdir``::

    rsync -Aax config data /oc-backupdir/
    
There are many ways to backup normal files, and you may use whatever method you are accustomed to.    

.. _backup_database_label:

Backup Database
---------------

You can't just copy a database, but must use the database tools to make a correct database dump.

MySQL/MariaDB
^^^^^^^^^^^^^

MySQL or MariaDB, which is a drop-in MySQL replacement, is the recommended database engine. To backup MySQL/MariaDB::

    mysqldump --single-transaction -h [server] -u [username] -p [password] [db_name] > owncloud-dbbackup_`date +"%Y%m%d"`.bak



Example::

      mysqldump --single-transaction -h localhost -u username -p password owncloud > owncloud-dbbackup_`date +"%Y%m%d"`.bak


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
was enabled, here's how to do it.

.. NOTE::
   This is effective from at least version v8.2.7 of ownCloud onwards. Also,
   this is **not officially supported**. ownCloud officially supports either
   restoring the full backup or restoring nothing — not restoring individual
   parts of it.

1. Restore the file from backup.

2. Restore the file's encryption keys from your backup.

3. Run ``occ files:scan``; this makes the scanner find it.

.. NOTE::
   In the DB it will:

   - Have the "size" set to the encrypted size, which is wrong (and bigger);
   - The "encrypted" flag will be set to 0

4. :ref:`Retrieve the encrypted flag value <retrieve_encrypted_flag_value_label>`.

5. Update the encrypted flag.

.. NOTE::
   There's no need to update the encrypted flag for files in either
   "files_versions" or "files_trashbin", because these aren't scanned or found
   by ``occ files:scan``.

6. Download the file once as the user; the file's size will be corrected
   automatically.

This process might not be suitable across all environments.
If it's not suitable for yours, you might need to run an OCC command that does the scanning.
But, that will require the user's password or recovery key.

.. _retrieve_encrypted_flag_value_label:

Retrieve the Encrypted Flag Value
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. In the backup database, retrieve the ``numeric_id`` value for `the storage`_
   where the file was located from the ``oc_storages`` table and store the value
   for later reference.

   For example, if you have the following in your ``oc_storages`` table, then
   ``numeric_id`` you should use is ``3``, if you need to restore a file for ``user1``.

   ::

    +--------------------------------+------------+-----------+--------------+
    | id                             | numeric_id | available | last_checked |
    +--------------------------------+------------+-----------+--------------+
    | home::admin                    |          1 |         1 |         NULL |
    | local::/var/www/owncloud/data/ |          2 |         1 |         NULL |
    | home::user1                    |          3 |         1 |         NULL |
    +--------------------------------+------------+-----------+--------------+

2. In the live database instance, find the ``fileid`` of the file to restore by
   running the query below, substituting the placeholders for the retrieved
   values, and store the value for later reference.

   ::

     SELECT fileid
     FROM oc_filecache
     WHERE path = 'path/to/the/file/to/restore'
       AND storage = <numeric_id>

3. Retrieve the backup, which includes the data folder and database.

4. Retrieve the required file from your backup and copy it to the real instance.

5. In the backup database, retrieve the file's ``encrypted`` value, by running
   the query below and store the value for later reference.

   ::

     SELECT encrypted
     FROM oc_filecache
     WHERE path = 'path/to/the/file/to/restore'
       AND storage = <numeric_id>

   This assumes the storage was the same and the file was in the same location.
   If not, you will need to track down where the file was before.

6. Update the live database instance with retrieved information, by running the
   following query, substituting the placeholders for the retrieved values:

   ::

    UPDATE oc_filecache
     SET encrypted = <encrypted>
     WHERE fileid = <fileid>.

.. Links

.. _the storage: https://github.com/owncloud/core/wiki/Storage-IDs
