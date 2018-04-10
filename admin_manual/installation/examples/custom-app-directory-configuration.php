<?php
$CONFIG = [
    'apps_paths' => [
        [
            'path' => '/var/www/owncloud/apps',
            'url' => '/apps',
            'writable' => false,
        ],
        [
            'path' => '/var/www/owncloud/apps-external',
            'url' => '/apps-external',
            'writable' => true,
        ],
    ],
    // remainder of the configuration
];
