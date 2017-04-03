=========================================
Installing ownCloud from the Command Line
=========================================

ownCloud can be installed entirely from the command line. This is convenient for
scripted operations and for systems administrators who prefer using the command
line over a GUI. 

To install ownCloud, first `download the source`_ (whether community or
enterprise) directly from ownCloud, and then unpack (decompress) the tarball
into the appropriate directory.

With that done, you next need to set your webserver user to be the owner of
your, unpacked, ``owncloud`` directory, as in the example below.::

 $ sudo chown -R www-data:www-data /var/www/owncloud/

With those steps completed, next use the ``occ`` command, from the root
directory of the ownCloud source, to perform the installation. This removes the
need to run the graphical Installation Wizard. Here’s an example of how to do
it::

 # Assuming you’ve unpacked the source to /var/www/owncloud/
 $ cd /var/www/owncloud/
 $ sudo -u www-data php occ maintenance:install \ 
    --database "mysql" --database-name "owncloud" \
    --database-user "root" --database-pass "password" \
    --admin-user "admin" --admin-pass "password" 

.. NOTE::
   You must run ``occ`` as your HTTP user. See :ref:`http_user_label`

.. TIP::
   If you want to use a directory other than the default (which is `data` inside
   the root ownCloud directory), you can also supply the `--data-dir` switch.
   For example, if you were using the command above and you wanted the data
   directory to be `/opt/owncloud/data`, then add `--data-dir
   /opt/owncloud/data` to the command.

.. NOTE::
   Supported databases are::

   - SQLite3 (ownCloud Community edition only)
   - MySQL (MySQL/MariaDB)
   - PgSQL (PostgreSQL)
   - Oracle (ownCloud Enterprise edition only)
 
See :ref:`command_line_installation_label` for more information.

When the command completes, apply the correct permissions to your ownCloud files
and directories (see :ref:`strong_perms_label`). This is extremely important, as
it helps protect your ownCloud installation and ensure that it will operate
correctly.

BINLOG_FORMAT = STATEMENT
-------------------------

If your ownCloud installation fails and you see this in your ownCloud log::

 An unhandled exception has been thrown: exception ‘PDOException’ with message 
 'SQLSTATE[HY000]: General error: 1665 Cannot execute statement: impossible to 
 write to binary log since BINLOG_FORMAT = STATEMENT and at least one table 
 uses a storage engine limited to row-based logging. InnoDB is limited to 
 row-logging when transaction isolation level is READ COMMITTED or READ 
 UNCOMMITTED.'

See :ref:`db-binlog-label`.

.. Links

.. _download the source: https://owncloud.org/install/#instructions-server 
