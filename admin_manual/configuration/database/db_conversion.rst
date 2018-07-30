========================
Converting Database Type
========================

SQLite is good for testing ownCloud, as well as small, single-user, ownCloud servers. 
But, **it does not scale** for large, multi-user sites.
If you have an existing ownCloud installation which uses SQLite, and you want to convert to a better performing database, such as *MySQL*, *MariaDB* or *PostgreSQL*, you can use :ref:`the ownCloud command line tool: occ <database_conversion_label>`. 

.. note::

	ownCloud Enterprise edition does not support SQLite.


Preparation
-----------

Add the following to your ownCloud ``config/config.php``.

::

	'mysql.utf8mb4' => true,

Add, or adjust, the following in ``/etc/mysql/mariadb.conf.d/50-server.cnf``.

.. note::

	You can do the same for MySQL by replacing mariadb.conf.d/50-server.cnf with mysql.conf.d/mysqld.cnf

::

	key_buffer_size         = 32M
	table_cache             = 400
	query_cache_size        = 128M

	#in InnoDB:
	innodb_flush_method=O_DIRECT
	innodb_flush_log_at_trx_commit=1
	innodb_log_file_size=256M
	innodb_log_buffer_size = 128M
	innodb_buffer_pool_size=2048M
	innodb_buffer_pool_instances=3
	innodb_read_io_threads=4
	innodb_write_io_threads=4
	innodb_io_capacity = 500
	innodb_thread_concurrency=2
	innodb_file_format=Barracuda
	innodb_file_per_table=ON
	innodb_large_prefix = 1

	character-set-server  = utf8mb4
	collation-server      = utf8mb4_general_ci


Restart the Database Server
---------------------------

When you have changed the database parameters, restart your database by running following command:

::

	sudo service mysql restart

Run the Conversion
------------------

After you have restarted the database, run the following occ command in your ownCloud root folder, to convert the database to the new format:

::

  sudo -uwww-data ./occ db:convert-type [options] type username hostname database


.. note::

   The converter searches for apps in your configured app folders and uses the
   schema definitions in the apps to create the new table. As a result, tables
   of removed apps will not be converted — even with option ``--all-apps``

For example

::

  sudo -uwww-data ./occ db:convert-type --all-apps mysql oc_mysql_user 127.0.0.1 new_db_name

To successfully proceed with the conversion, you must type ``yes`` when prompted 
with the question ``Continue with the conversion?``
On success the converter will automatically configure the new database in your 
ownCloud config ``config.php``.

Unconvertible Tables
--------------------

If you updated your ownCloud installation then the old tables, which are not used anymore, might still exist. 
The converter will tell you which ones.

::

  The following tables will not be converted:
    oc_permissions

You can ignore these tables.
Here is a list of known old tables:

* oc_calendar_calendars
* oc_calendar_objects
* oc_calendar_share_calendar
* oc_calendar_share_event
* oc_fscache
* oc_log
* oc_media_albums
* oc_media_artists
* oc_media_sessions
* oc_media_songs
* oc_media_users
* oc_permissions
* oc_queuedtasks
* oc_sharing
