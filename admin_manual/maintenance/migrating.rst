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

#.  Set up the new machine with your desired Linux distribution. At this point you can either install ownCloud manually via the compressed archive (see :doc:`../installation/source_installation`, or with your Linux package manager (see :doc:`../installation/linux_installation`).

#.  On the original machine turn on maintenance mode and then stop ownCloud. After waiting for 6-7 minutes for all sync clients to register the server as in maintenance mode, stop the application and/or Web server that serves ownCloud. (See :ref:`maintenance_commands_label`.)

#.  Create a dump from the database and copy it to the new machine, and import it into the new database (See :doc:`backup` and :doc:`restore`).

#.  Copy ONLY your data, configuration and database files from your original ownCloud instance to the new machine (See :doc:`backup` and :doc:`restore`). 

.. note:: You must keep the ``data/`` directory's original filepath. Do not change this!

5. The data files should keep their original timestamp (can be done by using ``rsync`` with ``-t`` option) otherwise the clients will re-download all the files after the migration. This step might take several hours, depending on your installation.

#.  With ownCloud still in maintenance mode (confirm!) and **BEFORE** changing the ``CNAME`` record in the DNS start up the database, Web server / application server on the new machine and point your Web browser to the migrated ownCloud instance. Confirm that you see the maintenance mode notice, that a logfile entry is written by both the Web server and ownCloud and that no error messages occur. Then take ownCloud out of maintenance mode and repeat. Log in as admin and confirm normal function of ownCloud.

#.  Change the ``CNAME`` entry in the DNS to point your users to the new
    location.
