========
Rest API
========

Retrieve Server Capabilities
----------------------------

============================================== ============ ==============
Request Path                                   Method       Content Type
============================================== ============ ==============
``/ocs/v1.php/cloud/capabilities?format=json`` ``GET``      ``text/plain``
============================================== ============ ==============

To retrieve a list of your ownCloud server's available capabilities, you need to make an authenticated ``GET`` request, as in the example below.

::

  curl --silent -u admin:admin \
    'http://localhost/ocs/v1.php/cloud/capabilities?format=json' | json_pp

.. note::
   The example uses `json_pp`_ to make the response easier to read, and omits some content for the sake of brevity.
  
This will return a JSON response, similar to the example below, along with a status of: ``HTTP/1.1 200 OK``.

.. code-block:: json
   
   {
      "ocs" : {
         "data" : {
            "capabilities" : {
               "checksums" : {
                  "supportedTypes" : [
                     "SHA1"
                  ],
                  "preferredUploadType" : "SHA1"
               },
               "files" : {
                  "blacklisted_files" : [
                     ".htaccess"
                  ],
                  "bigfilechunking" : true,
                  "versioning" : true,
                  "undelete" : true
               },
               "core" : {
                  "status" : {
                     "version" : "10.0.0.12",
                     "maintenance" : "false",
                     "installed" : "true",
                     "versionstring" : "10.0.0",
                     "needsDbUpgrade" : "false",
                     "productname" : "ownCloud",
                     "edition" : "Community"
                  },
                  "pollinterval" : 60,
                  "webdav-root" : "remote.php/webdav"
               },
               "files_sharing" : {
                  "federation" : {
                     "outgoing" : true,
                     "incoming" : true
                  },
                  "api_enabled" : true,
                  "user" : {
                     "send_mail" : false
                  },
                  "public" : {
                     "password" : {
                        "enforced" : false
                     },
                     "upload" : true,
                     "multiple" : true,
                     "expire_date" : {
                        "enabled" : false
                     },
                     "send_mail" : false,
                     "enabled" : true
                  },
                  "resharing" : true,
                  "group_sharing" : true
               },
               "notifications" : {
                  "ocs-endpoints" : [
                     "list",
                     "get",
                     "delete"
                  ]
               },
               "dav" : {
                  "chunking" : "1.0"
               }
            }
         },
      }
   }
   

In the example, in the ``capabilities`` element, you can see that the server lists six capabilities, along with their settings, sub-settings, and their values.

Core
~~~~

Stored under the ``core`` capabilities element, this returns the server’s core status settings, the interval to poll for server side changes, and it’s WebDAV API root.

Checksums     
~~~~~~~~~

Stored under the ``checksums`` capabilities element, this returns the server’s supported checksum types, and preferred upload checksum type.

Files
~~~~~

Stored under the ``files`` capabilities element, this returns the server’s support for big file chunking, file versioning, its ability to undelete files, and the list of files that are currently blacklisted.

Files Sharing
~~~~~~~~~~~~~

Stored under the ``files_sharing`` capabilities element, this returns the server’s support for file sharing, re-sharing (by users and groups), federated file support, and public link shares (as well as whether passwords and expiry dates are enforced), and also whether the sharing API's enabled.

Notifications
~~~~~~~~~~~~~

Stored under the ``notifications`` capabilities element, this returns what the server sends notifications for. 

WebDAV
~~~~~~

Stored under the ``dav`` capabilities element, this returns the server’s WebDAV API support.

.. note::
   Other apps add detail information to the capabilities, to indicate the availability of certain features, for example notifications.

.. Links
   
.. _json_pp: http://search.cpan.org/~makamaka/JSON-PP-2.27103/bin/json_pp
