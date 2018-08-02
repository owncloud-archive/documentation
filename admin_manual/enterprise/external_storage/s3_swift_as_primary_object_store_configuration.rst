=================================
Configuring S3 as Primary Storage
=================================

Administrators can configure Amazon S3 objects as the primary ownCloud storage location.
Doing this replaces the default ownCloud ``owncloud/data`` directory.
However, if you use S3 objects as the primary storage, you *need* to keep the ``owncloud/data`` directory for the following reasons:

* The ownCloud log file is saved in the data directory.
* Legacy apps may not support using anything but the ``owncloud/data`` directory.

.. note::
   Even if the ownCloud log file is stored in an alternate location (by changing the location in ``config.php``)
   ``owncloud/data`` may still be required for backward compatibility with some apps.

That said, `the Object Storage Support app`_ (``objectstore``) is still available, but `the S3 Object Storage app`_ (`files_primary_s3`_) is the preferred way to provide S3 storage support.
However, OpenStack Swift has been deprecated.

When using ``files_primary_s3``, the Amazon S3 bucket needs to be created manually `according to the developer documentation`_, and versioning needs to be enabled.

.. note:: ownCloud GmbH provides consulting for migrations from ``objectstore`` to ``files_primary_s3``.

.. important:: **Implications**

    1. Apply this configuration before the first login of any user – including the admin user; otherwise, ownCloud can no longer find the user's files.

    2. ownCloud, in "object store" mode, expects exclusive access to the object store container, because it only stores the binary data for each file. While in this mode, ownCloud stores the metadata in the local database for performance reasons.

    3. The current implementation is incompatible with any app that uses direct file I/O (input/output) as it circumvents the ownCloud virtual filesystem. Two excellent examples are:

       A. **The Encryption app:** It fetches critical files in addition to any requested file, which results in significant overhead.
       B. **The Gallery app:** It stores thumbnails directly in the filesystem.

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

The S3 backend can also be used to mount the bucket of a Scality S3 object store via the Amazon S3 API into the virtual filesystem.
The class to be used is ``OCA\Files_Primary_S3\S3Storage``:

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

.. Links

.. _the S3 Object Storage app: https://marketplace.owncloud.com/apps/files_primary_s3
.. _files_primary_s3: https://github.com/owncloud/files_primary_s3
.. _The Object Storage Support app: https://marketplace.owncloud.com/apps/objectstore
.. _according to the developer documentation: https://docs.aws.amazon.com/AmazonS3/latest/gsg/CreatingABucket.html
