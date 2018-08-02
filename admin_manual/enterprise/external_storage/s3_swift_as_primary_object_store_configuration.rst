=================================
Configuring S3 as Primary Storage
=================================

In ownCloud Enterprise edition, administrators can configure Amazon S3 objects as the primary storage.
Doing this replaces the default ownCloud ``owncloud/data`` directory.

You may still need to keep the ``owncloud/data`` directory for these reasons:

* The ownCloud log file is saved in the data directory
* Legacy apps may not support using anything but the ``owncloud/data`` directory

Administrators can move their ownCloud log file, by changing its location in ``config.php``.
However, even when this is done, ``owncloud/data`` may still be required for backward compatibility with some apps.

Implications
------------

- Apply this configuration before the first login of any user – including the admin user; otherwise, ownCloud can no longer find the user's files.

- ownCloud, in "object store" mode, expects exclusive access to the object store container, because it only stores the binary data for each file.

.. note:: While in this mode, ownCloud stores the metadata in the local database for performance reasons.

- The current implementation is incompatible with any app that uses direct file I/O (input/output) as it circumvents the ownCloud virtual filesystem. Two excellent examples are:

  #. **The Encryption app:** It fetches critical files in addition to any requested file, which results in significant overhead.
  #. **The Gallery app:** It stores thumbnails directly in the filesystem.

Configuration
-------------

Look in ``config.sample.php`` for example configurations.
Copy the relevant part to your ``config.php`` file.
Any object store needs to implement ``\\OCP\\Files\\ObjectStore\\IObjectStore``, and can be passed parameters in the constructor with the ``arguments`` key, as in the following example:

.. code-block:: php

    $CONFIG = [
        'objectstore' => [
            'class' => 'Implementation\\Of\\OCP\\Files\\ObjectStore\\IObjectStore',
            'arguments' => [
                ...
            ],
        ],
    ],

Amazon S3
~~~~~~~~~

The S3 backend mounts a bucket of the Amazon S3 object store into the virtual filesystem.
The class to be used is ``OCA\Files_Primary_S3\S3Storage``, as in the following example:

.. code-block:: php

   <?php

    $CONFIG = [
        'objectstore' => [
            'class' => 'OCA\Files_Primary_S3\S3Storage',
            'arguments' => [
                // replace with your bucket
                'bucket' => 'owncloud',
                'autocreate' => true,
                // uncomment to enable server side encryption
                //'serversideencryption' => 'AES256',
                'options' => [
                    // version and region are required
                    'version' => '2006-03-01',
                    // change to your region
                    'region'  => 'eu-central-1',
                    'credentials' => [
                        // replace key and secret with your credentials
                        'key' => 'EJ39ITYZEUH5BGWDRUFY',
                        'secret' => 'M5MrXTRjkyMaxXPe2FRXMTfTfbKEnZCu+7uRTVSj',
                    ],
                ],
            ],
       ],
   ],


Ceph S3
~~~~~~~

The S3 backend can also be used to mount the bucket of a Ceph S3 object store via the Amazon S3 API into the virtual filesystem.
The class to be used is ``OCA\Files_Primary_S3\S3Storage``:

.. code-block:: php

    <?php

    $CONFIG = [
        'objectstore' => [
            'class' => 'OCA\Files_Primary_S3\S3Storage',
            'arguments' => [
                // replace with your bucket
                'bucket' => 'OWNCLOUD',
                'autocreate' => true,
                // uncomment to enable server side encryption
                //'serversideencryption' => 'AES256',
                'options' => [
                    // version and region are required
                    'version' => '2006-03-01',
                    'region'  => 'us-central-1',
                    'credentials' => [
                        // replace key and secret with your credentials
                        'key' => 'owncloud123456',
                        'secret' => 'secret123456',
                    ],
                    'use_path_style_endpoint' => true,
                    'endpoint' => 'http://ceph:80/',
                ],
            ],
        ],
    ];

Scality S3
~~~~~~~~~~

.. code-block:: php

    <?php

    $CONFIG = [
        'objectstore' => [
            'class' => 'OCA\Files_Primary_S3\S3Storage',
            'arguments' => [
                // replace with your bucket
                'bucket' => 'owncloud',
                'autocreate' => true,
                // uncomment to enable server side encryption
                //'serversideencryption' => 'AES256',
                'options' => [
                    // version and region are required
                    'version' => '2006-03-01',
                    'region'  => 'us-east-1',
                    'credentials' => [
                        // replace key and secret with your credentials
                        'key' => 'accessKey1',
                        'secret' => 'verySecretKey1',
                    ],
                    'use_path_style_endpoint' => true,
                    'endpoint' => 'http://scality:8000/',
                ],
            ],
        ],
    ];
