===================
Backing up ownCloud
===================

When you backup your ownCloud server, there are four things that you need to copy:

#. Your ``config/`` directory.
#. Your ``data/`` directory.
#. Your ownCloud database.
#. Your custom theme files, if you have any. (See `Theming ownCloud <https://doc.owncloud.org/server/9.2/developer_manual/core/theming.html>`_)

When you install your ownCloud server from our `Open Build Service <https://download.owncloud.org/download/repositories/stable/owncloud/>`_) packages (or from distro packages, which we do not recommend) **do not backup your ownCloud server files**, which are the other files in your ``owncloud/`` directory such as ``core/``, ``3rdparty/``, ``apps/``, ``assets/``, ``lib/``, and all the rest of the ownCloud files. If you restore these files from backup they may not be in sync with the current package versions, and will fail the code integrity check. This may also cause other errors, such as white pages.

When you install ownCloud from the source tarballs this will not be an issue, and you can safely backup your entire ownCloud installation, with the exception of your ownCloud database. Databases cannot be copied, but you must use the database tools to make a correct database dump.

To restore your ownCloud installation from backup, see :doc:`restore` .

Backing Up the config/ and data/ Directories
--------------------------------------------

Simply copy your ``config/`` and ``data/`` folder to a place outside of your ownCloud environment. This example uses ``rsync`` to copy the two directories to ``/backupdir``::

    rsync -Aax config data /oc-backupdir/
    
There are many ways to backup normal files, and you may use whatever method you are accustomed to.    

Backup Database
---------------

You can't just copy a database, but must use the database tools to make a correct database dump.

MySQL/MariaDB
^^^^^^^^^^^^^

MySQL or MariaDB, which is a drop-in MySQL replacement, is the recommended database engine. To backup MySQL/MariaDB::

    mysqldump --lock-tables -h [server] -u [username] -p[password] [db_name] > owncloud-dbbackup_`date +"%Y%m%d"`.bak

SQLite
^^^^^^
::

    sqlite3 data/owncloud.db .dump > owncloud-dbbackup_`date +"%Y%m%d"`.bak

PostgreSQL
^^^^^^^^^^
::

    PGPASSWORD="password" pg_dump [db_name] -h [server] -U [username] -f owncloud-dbbackup_`date +"%Y%m%d"`.bak

