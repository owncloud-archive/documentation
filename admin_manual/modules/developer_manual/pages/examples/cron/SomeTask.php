<?php

namespace OCA\MyApp\Cron;

use \OCA\MyApp\AppInfo\Application;

class SomeTask extends OC\BackgroundJob\TimedJob {
    
    protected function run($argument) {
        (new Application())
            ->getContainer()
            ->query('SomeService')
            ->run();
    }
}
