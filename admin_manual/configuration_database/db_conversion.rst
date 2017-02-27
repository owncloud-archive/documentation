========================
Converting Database Type
========================

You can convert a SQLite database to a more performing MySQL, MariaDB or 
PostgreSQL database with the ownCloud command line tool. SQLite is good for 
testing and simple single-user ownCloud servers, but it does not scale for multiple-user sites.

.. note:: ownCloud Enterprise edition does not support SQLite.

Run the conversion
------------------

After you have setup the new database, in the ownCloud root folder run the following command to convert the database to the new format:

::

  php occ db:convert-type [options] type username hostname database


.. note::
   The converter searches for apps in your configured app folders and uses the
   schema definitions in the apps to create the new table. As a result, tables
   of removed apps will not be converted — even with option ``--all-apps``

For example

::

  php occ db:convert-type --all-apps mysql oc_mysql_user 127.0.0.1 new_db_name

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
  ...

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
