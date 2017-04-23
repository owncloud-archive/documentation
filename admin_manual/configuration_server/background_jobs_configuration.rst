.. _background-jobs-header:

Background Jobs
========================

A system like ownCloud sometimes requires tasks to be done on a regular basis without requiring user interaction or hindering ownCloud's performance. 
For that reason, as a system administrator, you can configure background jobs (for example, database clean-ups) to be executed without any user interaction.

These jobs are typically referred to as `Cron Jobs`_.  
Cron jobs are commands or shell-based scripts that are scheduled to periodically run at fixed times, dates, or intervals. 
``cron.php`` is an ownCloud internal process that runs such background jobs on demand.

ownCloud plug-in applications can register actions with ``cron.php`` automatically to take care of typical housekeeping operations. 
These actions can include garbage collecting of temporary files or checking for newly updated files using ``filescan()`` on externally mounted file systems.

Cron Jobs
---------

You can schedule Cron jobs in three ways: `Cron`_, `Webcron`_, or `AJAX`_. 
These can all be configured in the admin settings menu. 
However, the recommended method is to use Cron.  
The following sections describe the differences between each method.

There are a number of things to keep in mind when choosing an automation
option: 

Firstly, while the default method is AJAX, though the preferred way is to use Cron.
The reason for this distinction is that AJAX is easier to get up and running. 
As a result, it makes sense (often times) to accept it in the interests of expediency.

However, doing so is known to cause issues, such as backlogs and potentially not running every job on a heavily-loaded system.
What’s more, an increasing amount of ownCloud automation has been migrated from Ajax to Cron in recent versions.
For this reason, we encourage you to not use it for too long — especially if your site is rapidly growing.

Secondly, while Webcron is better than Ajax, it too has limitations. 
For example, running Webcron will only remove a single item from the job queue,
not all of them.
Cron, however, will clear the entire queue.

.. note:: 
   It’s for this reason that we encourage you to use Cron — if at all possible.

Cron
~~~~

Using the operating system Cron feature is the preferred method for executing regular tasks.  
This method enables the execution of scheduled jobs without the inherent limitations which the web server might have.

For example, to run a Cron job on a \*nix system every 15 minutes, under the default web server user (often, ``www-data`` or ``wwwrun``) you must set up the following Cron job to call the **cron.php** script::

  # crontab -u www-data -e
  */15  *  *  *  * php -f /path/to/your/owncloud/cron.php

You can verify if the cron job has been added and scheduled by executing::

  # crontab -u www-data -l
  */15  *  *  *  * php -f /path/to/your/owncloud/cron.php

.. note:: You have to make sure that ``php`` is found by ``cron``. Best practice is to expressly add the full path like ``/usr/bin/php``. On some systems it might be necessary to call **php-cli** instead of **php**.

Please refer to `the crontab man page`_ for the exact command syntax.

Webcron
~~~~~~~

By registering your ownCloud ``cron.php`` script address as an external webcron service (for example, easyCron_), you ensure that background jobs are executed regularly. 
To use this type of service, your external webcron service must be able to access your ownCloud server using the Internet. 
For example::

  URL to call: http[s]://<domain-of-your-server>/owncloud/cron.php

AJAX
~~~~

The AJAX scheduling method is the default option. 
However, it is also the *least* reliable. 
Each time a user visits the ownCloud page, a single background job is executed. 
The advantage of this mechanism, however, is that it does not require access to the system nor registration with a third party service. 
The disadvantage of this mechanism, when compared to the `Webcron`_ service, is that it requires regular visits to the page for it to be triggered.

.. note:: Especially when using the Activity App or external storages, where new
   files are added, updated, or deleted one of the other methods should be
   used.

Parallel Task Execution
~~~~~~~~~~~~~~~~~~~~~~~

Regardless of the approach which you take, since ownCloud 9.1, Cron jobs can be run in parallel. This is done by running ``cron.php`` multiple times.
Depending on the process which you’re automating, this may not be necessary.
However, for longer-running tasks, such as those which are LDAP related, it may be very beneficial.

There is no way to do so via the ownCloud UI.
But, the most direct way to do so, is by opening three console tabs and in each one run ``php cron.php``. 
Each of these processes would acquire their own list of jobs to process without overlapping any other.

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
.. _Cron Jobs: https://en.wikipedia.org/wiki/Cron
.. _the crontab man page: https://linux.die.net/man/1/crontab
