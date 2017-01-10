<?php

namespace OCA\MyApp\Cron;

use \OCA\MyApp\AppInfo\Application;

class SomeTask extends OC\BackgroundJob\TimedJob
{
    public static function run()
    {
        (new Application())
            ->getContainer()
            ->query('SomeService')
            ->run();
    }
}
