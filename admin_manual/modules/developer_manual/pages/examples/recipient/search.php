<?php

use GuzzleHttp\Client;

require_once ('vendor/autoload.php');

// Configure the basic client
$client = new Client([
    'base_uri' => 'https://your.owncloud.install.com/ocs/v1.php/apps/files_sharing/api/v1/',
]);

try {
    $response = $client->get('sharees', [
        'query' => [
            'format' => 'xml',      // can also be 'json'
            'itemType' => 'file',   // can also be 'folder'
            'shareType' => 0,
            'perPage' => 5
        ],
        'auth' => ['your.username', 'your.password'],
        'debug' => false,
    ]);
    print $response->getBody()->getContents();
} catch (\GuzzleHttp\Exception\ClientException $e) {
    print $e->getMessage();
}

