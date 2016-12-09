==================
Restoring ownCloud
==================

When you install ownCloud from packages, follow these steps to restore your ownCloud installation. Start with a fresh ownCloud package installation in a new, empty directory. Then restore these items from your backup (see :doc:`backup`):

#. Your ``config/`` directory.
#. Your ``data/`` directory.
#. Your ownCloud database.
#. Your custom theme files, if you have any. (See `Theming ownCloud <https://doc.owncloud.org/server/9.2/developer_manual/core/theming.html>`_)

When you install ownCloud from the source tarballs you may safely restore your entire ownCloud installation from backup, with the exception of your ownCloud database. Databases cannot be copied, but you must use the database tools to make a correct restoration.

When you have completed your restoration, see :ref:`Setting Strong Permissions <strong_perms_label>`.

Restore Directories
-------------------

Simply copy your configuration and data folder to your ownCloud environment. You could use this command, which restores the backup example in :doc:`backup`::

    rsync -Aax config data /var/www/owncloud/
    
There are many ways to restore normal files from backups, and you may use whatever method you are accustomed to.

Restore Database
----------------

.. note:: This guide assumes that your previous backup is called 
   "owncloud-dbbackup.bak"

MySQL
^^^^^

MySQL is the recommended database engine. To restore MySQL::

    mysql -h [server] -u [username] -p[password] [db_name] < owncloud-dbbackup.bak

SQLite
^^^^^^
::

    rm data/owncloud.db
    sqlite3 data/owncloud.db < owncloud-dbbackup.bak

PostgreSQL
^^^^^^^^^^
::

    PGPASSWORD="password" pg_restore -c -d owncloud -h [server] -U [username] 
    owncloud-dbbackup.bak
