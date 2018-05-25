<?php
$CONFIG = [
    'apps_paths' => [
        [
            'path' => OC::$SERVERROOT.'/apps',
            'url' => '/apps',
            'writable' => false,
        ],
        [
            'path' => OC::$SERVERROOT.'/apps-external',
            'url' => '/apps-external',
            'writable' => true,
        ],
    ],
    // remainder of the configuration
];
