======================
Background Jobs (Cron)
======================

.. sectionauthor:: Bernhard Posselt <dev@bernhard-posselt.com>

ownCloud supports background job functionality (otherwise known as `Cron jobs`_).
To create them requires two steps to be completed:

- Create a job class
- Register the class with ownCloud

Create a job class
==================

The first step is to create a job class, which will provide the job functionality. 
For this example, we will call it: :file:`lib/Cron/SomeTask.php`. 
The class only needs to define one, static, method called ``run``. 
In this example, we’re retrieving a service from the container, and in turn
calling its ``run`` method.

.. NOTE:: 
   Try to keep the method as small as possible, because its hard to test static
   methods.

.. literalinclude:: ../examples/cron/SomeTask.php
   :language: php
   :linenos:

Register the class with ownCloud
================================

Next, you need to register the job as a background job. 
This is done in :file:`appinfo/info.xml` by adding a job element, containing the
name of the job class, to the ``background-jobs`` element. 
The example below shows how to add the ``SomeTask`` class, which we just
created, as a background job.:

.. code-block:: xml
   
    <background-jobs>
        <job>\OCA\MyApp\Cron\SomeTask</job>
    </background-jobs>

Testing
=======

To test the job classes, you can run Cron manually, as in the example below:

    sudo -u http php cron.php

After doing so, you will need to reset the job to allow it to be run, manually, again. 
To do this, go to the database and run the following SQL query:

.. code-block: sql

    UPDATE oc_jobs SET last_run=0,last_checked=0,reserved_at=0;

Is The Cron Service Running?
============================

Finally, don’t forget to add the ownCloud Cron process in the web server’s `crontab`_. To do this, first open the web server’s crontab for editing by running::

    # In this example ``http`` is the web server user
    sudo crontab -u http -e

Then, add the ownCloud Cron process to the crontab, for example, like so::

    */15  *  *  *  * php -f /srv/http/owncloud/cron.php
    

.. Links
   
.. _Cron jobs: https://en.wikipedia.org/wiki/Cron
.. _crontab: http://www.adminschoice.com/crontab-quick-reference
