======================
Background Jobs (Cron)
======================

.. sectionauthor:: Bernhard Posselt <dev@bernhard-posselt.com>

Background/cron jobs are usually registered in the :file:`appinfo/info.xml` by using the **background-job** section with the name of the class to run:

.. code-block:: xml

    <background-jobs>
        <job>\OCA\MyApp\Cron\SomeTask</job>
    </background-jobs>

The class for the above example would live in :file:`lib/Cron/SomeTask.php`. Try to keep the method as small as possible because its hard to test static methods. Simply reuse the app container and execute a service that was registered in it.

.. code-block:: php

    <?php
    namespace OCA\MyApp\Cron;

    use \OCA\MyApp\AppInfo\Application;

    class SomeTask {

        public static function run() {
            $app = new Application();
            $container = $app->getContainer();
            $container->query('SomeService')->run();
        }

    }

Dont forget to configure the cron service on the server by executing::

    sudo crontab -u http -e

where **http** is your Web server user, and add::

    */15  *  *  *  * php -f /srv/http/owncloud/cron.php

-------
Testing
-------

For testing, you can run cron manually:

    sudo -u http php cron.php

After a single run, you will need to reset the job to make it runnable manually again. For this, go to the database and run:

    UPDATE oc_jobs SET last_run=0,last_checked=0,reserved_at=0;


