<?php

use GuzzleHttp\Client;

require_once ('vendor/autoload.php');

// Configure the basic client
$client = new Client([
    'base_uri' => 'https://your.owncloud.install.com/owncloud/ocs/v1.php/apps/files_sharing/api/v1/',
]);

try {
    $response = $client->post('shares', [
        'auth' => ['your.username', 'your.password'],
        'debug' => true,
        'form_params' => [
            'path' => 'Photos/Paris.jpg',
            'shareType' => 3,
            'permissions' => 1
        ]
    ]);
    print $response->getBody()->getContents();
} catch (\GuzzleHttp\Exception\ClientException $e) {
    print $e->getMessage();
}