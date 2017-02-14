Background Jobs
========================
A system like ownCloud sometimes requires tasks to be done on a regular basis without the need for user interaction or hindering ownCloud performance. For that purpose, as a system administrator, you can define background jobs (for example, database clean-ups) which are executed without any need for user interaction.

These jobs are typically referred to as *cron jobs*.  Cron jobs are commands or shell-based scripts that are scheduled to run periodically at fixed times, dates, or intervals.   ``cron.php`` is an ownCloud internal process that runs such background jobs on demand.

ownCloud plug-in applications register actions with ``cron.php`` automatically to take care of typical housekeeping operations, such as garbage collecting of temporary files or checking for newly updated files using ``filescan()`` for externally mounted file systems.

Parameters
----------
In the admin settings menu you can configure how cron-jobs should be executed.
You can choose between the following options:

-   AJAX
-   Webcron
-   Cron

Cron Jobs
---------

You can schedule cron jobs in three ways -- using AJAX, Webcron, or cron. The default method is to use AJAX.  However, the recommended method is to use cron.  The following sections describe the differences between each method.

AJAX
~~~~

The AJAX scheduling method is the default option.  Unfortunately, however, it is also the least reliable. Each time a user visits the ownCloud page, a single background job is executed. The advantage of this mechanism is that it does not require access to the system nor registration with a third party service. The disadvantage of this mechanism, when compared to the Webcron service, is that it requires regular visits to the page for it to be triggered.

.. note:: Especially when using the Activity App or external storages, where new
   files are added, updated or deleted one of the two methods below should be
   preferred.

Webcron
~~~~~~~

By registering your ownCloud ``cron.php`` script address at an external webcron
service (for example, easyCron_), you ensure that background jobs are executed
regularly. To use this type of service, your server you must be able to access
your server using the Internet. For example::

  URL to call: http[s]://<domain-of-your-server>/owncloud/cron.php

Cron
~~~~

Using the operating system cron feature is the preferred method for executing regular tasks.  This method enables the execution of scheduled jobs without the inherent limitations the Web server might have.

To run a cron job on a \*nix system, every 15 minutes, under the default Web server user (often, ``www-data`` or ``wwwrun``), you must set up the following cron job to call the **cron.php** script::

  # crontab -u www-data -e
  */15  *  *  *  * php -f /var/www/owncloud/cron.php

You can verify if the cron job has been added and scheduled by executing::

  # crontab -u www-data -l
  */15  *  *  *  * php -f /var/www/owncloud/cron.php

.. note:: You have to replace the path ``/var/www/owncloud/cron.php`` with the path to your current ownCloud installation.

.. note:: You have to make sure that ``php`` is found by ``cron``. Best practice is to expressly add the full path like ``/usr/bin/php``.

.. note:: On some systems it might be required to call **php-cli** instead of **php**.

Available Background Jobs
~~~~~~~~~~~~~~~~~~~~~~~~~

A number of existing background jobs are available to be run just for specific tasks.

.. NOTE::
   These jobs are generally only needed on large instances and can be run as background jobs.
   If the number of users in your installation ranges between 1,000 and 3,000, or if you’re using LDAP
   and it becomes a bottleneck, then admins can delete several entries in the `oc_jobs` table and replace
   them with the corresponding `occ` command, which you can see here:

   * `OCA\\Files_Trashbin\\BackgroundJob\\ExpireTrash` -> `occ trashbin:expire`
   * `OCA\\Files_Versions\\BackgroundJob\\ExpireVersions` -> `occ versions:expire`
   * `OCA\\DAV\CardDAV\\SyncJob` -> `occ dav:sync-system-addressbook`
   * `OCA\\Federation\\SyncJob` -> `occ federation:sync-addressbooks`

   If used, these should be scheduled to run on a daily basis.

While not exhaustive, these include:

ExpireTrash
^^^^^^^^^^^

The ExpireTrash job, contained in ``OCA\Files_Trashbin\BackgroundJob\ExpireTrash``, will remove any file in the ownCloud trash bin which is older than the specified maximum file retention time.  
It can be run, as follows, using the OCC command::

  occ trashbin:expire

ExpireVersions 
^^^^^^^^^^^^^^

The ExpireVersions job, contained in ``OCA\Files_Versions\BackgroundJob\ExpireVersions``, will expire versions of files which are older than the specified maximum version retention time.
It can be run, as follows, using the OCC command::

  occ versions:expire

SyncJob (CardDAV)
^^^^^^^^^^^^^^^^^

The CardDAV SyncJob, contained in ``OCA\DAV\CardDAV\SyncJob``, syncs the local
system address book, updating any existing contacts, and deleting any expired
contacts.
It can be run, as follows, using the OCC command::

  occ dav:sync-system-addressbook

SyncJob (Federation)
^^^^^^^^^^^^^^^^^^^^

OCA\Federation\SyncJob 

It can be run, as follows, using the OCC command::

  occ federation:sync-addressbooks

.. Links

.. _easyCron: http://www.easycron.com/
