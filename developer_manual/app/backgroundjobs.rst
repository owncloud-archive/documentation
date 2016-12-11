======================
Background Jobs (Cron)
======================

.. sectionauthor:: Bernhard Posselt <dev@bernhard-posselt.com>

Background/cron jobs should be registered in the :file:`appinfo/install.php` and :file:`appinfo/update.php`. Previously this was mostly done in :file:`appinfo/app.php`, but that causes a query on each page load.
Background jobs have to implement the ``OCP\BackgroundJob\IJob`` interface, then you can simply add them to the JobList object.

.. code-block:: php

    <?php
    \OC::$server->getJobList()->add('\OCA\MyApp\Cron\SomeTask', ['some' => 'additional arguments']);

The class for the above example would live in :file:`cron/sometask.php`. If you load your container in :file:`appinfo/app.php` and you use a full namespaced class name for the job, the class is loaded from the container and you can use full dependency injection.

.. code-block:: php

    <?php
    new \OCP\AppFramework\App('myapp');

In your job, you only have to implement the **run** method, where you get the arguments from the **add** call passed in:

.. code-block:: php

    <?php
    namespace OCA\MyApp\Cron;

    use \OCA\MyApp\AppInfo\Application;

    class SomeTask implements \OCP\BackgroundJob\IJob {

        // For default implementation look at \OC\BackgroundJob\Job

    }

Dont forget to configure the cron service on the server by executing::

    sudo crontab -u http -e

where **http** is your Web server user, and add::

    */15  *  *  *  * php -f /srv/http/owncloud/cron.php
