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
				"notifications" : {
				   "ocs-endpoints" : [
					  "list",
					  "get",
					  "delete"
				   ]
				},
				"files" : {
				   "blacklisted_files" : [
					  ".htaccess"
				   ],
				   "bigfilechunking" : true,
				   "privateLinks" : true,
				   "undelete" : true,
				   "versioning" : true
				},
				"checksums" : {
				   "preferredUploadType" : "SHA1",
				   "supportedTypes" : [
					  "SHA1"
				   ]
				},
				"files_sharing" : {
				   "default_permissions" : 31,
				   "user" : {
					  "send_mail" : false
				   },
				   "federation" : {
					  "incoming" : true,
					  "outgoing" : true
				   },
				   "resharing" : true,
				   "user_enumeration" : {
					  "enabled" : true,
					  "group_members_only" : false
				   },
				   "api_enabled" : true,
				   "group_sharing" : true,
				   "share_with_group_members_only" : true,
				   "public" : {
					  "enabled" : true,
					  "password" : {
						 "enforced" : false
					  },
					  "multiple" : true,
					  "social_share" : true,
					  "send_mail" : false,
					  "upload" : true,
					  "expire_date" : {
						 "enabled" : false
					  },
					  "supports_upload_only" : true
				   }
				},
				"dav" : {
				   "chunking" : "1.0"
				},
				"core" : {
				   "webdav-root" : "remote.php/webdav",
				   "status" : {
					  "edition" : "Community",
					  "installed" : "true",
					  "needsDbUpgrade" : "false",
					  "versionstring" : "10.0.3",
					  "productname" : "ownCloud",
					  "maintenance" : "false",
					  "version" : "10.0.3.3"
				   },
				   "pollinterval" : 60
				}
			 }
		  }
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
