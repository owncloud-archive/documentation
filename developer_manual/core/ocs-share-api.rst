=============
OCS Share API
=============

The OCS Share API allows you to access the sharing API from outside over
pre-defined OCS calls.

The base URL for all calls to the share API is: 
*<owncloud_base_url>/ocs/v1.php/apps/files_sharing/api/v1*

Local Shares
============

.. _ocs-share-api__get-all-shares:
   
Get All Shares
--------------

Get all shares from the user.

* Syntax: `/shares`
* Method: `GET`

Returns
^^^^^^^

XML with all shares

Status Codes
^^^^^^^^^^^^

==== =====================
Code Description
==== =====================
100  Successful
404  Couldn't fetch shares
997  Unauthorised
==== =====================

Code Example
^^^^^^^^^^^^

Curl
~~~~

.. literalinclude:: examples/curl/list-all-shares.sh
   :caption: List all shares for the current user
   :linenos:

PHP
~~~~

.. literalinclude:: examples/php/list-all-shares.php
   :caption: List all shares for the current user
   :language: php
   :linenos:

Ruby
~~~~

.. literalinclude:: examples/ruby/list-all-shares.ruby
   :caption: List all shares for the current user
   :language: ruby
   :linenos:

Go
~~

.. literalinclude:: examples/go/list-all-shares.go
   :caption: List all shares for the current user
   :language: go
   :linenos:

Example Request Response Payloads
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If the user that you’re connecting with is not authorized, then you will see
output similar to the following:

.. literalinclude::
   examples/responses/not-authorised-response.xml
   :caption: Example of a "Not Authorised" response
   :language: xml
   :linenos:

If the user that you’re connecting with is authorized, then you will see
output similar to the following:

.. literalinclude::
   examples/responses/shares/get-all-shares-success-no-shares.xml
   :caption: Example of retrieving all shares where no shares are available
   :language: xml
   :linenos:

.. _ocs-share-api__get-shares-from-file-folder:

Get Shares From A Specific File Or Folder
-----------------------------------------

Get all shares from a given file or folder.

* Syntax: `/shares`
* Method: `GET`

Request Attributes
~~~~~~~~~~~~~~~~~~

========= ======= =============================================================
Attribute Type    Description
========= ======= =============================================================
path      string  path to file/folder
reshares  boolean returns not only the shares from the current user but all 
                  shares from the given file.
subfiles  boolean returns all shares within a folder, given that path defines 
                  a folder
========= ======= =============================================================

Mandatory fields: path

Returns
^^^^^^^

XML with the shares

Code Example
^^^^^^^^^^^^

Curl
~~~~

.. literalinclude:: examples/curl/list-share-details.sh
   :caption: List details about a specific share, including reshares
   :language: bash
   :linenos:

PHP
~~~~

.. literalinclude:: examples/php/list-share-details.php
   :caption: List details about a specific share, including reshares
   :language: php
   :linenos:

Ruby
~~~~

.. literalinclude:: examples/ruby/list-share-details.ruby
   :caption: List details about a specific share, including reshares
   :language: ruby
   :linenos:

Go
~~

.. literalinclude:: examples/php/list-share-details.go
   :caption: List details about a specific share, including reshares
   :language: go
   :linenos:

Example Request Response Payloads
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: examples/responses/list-share-details-failure.xml
   :caption: Example Failure Response
   :language: xml
   :linenos:

.. literalinclude:: examples/responses/list-share-details-success.xml
   :caption: Example Failure Response
   :language: xml
   :linenos:

Status Codes
^^^^^^^^^^^^

==== ====================================================
Code Description
==== ====================================================
100  Successful
400  Not a directory (if the 'subfile' argument was used)
404  File doesn't exist
==== ====================================================

.. _ocs-share-api__get-shares-information:

Get Information About A Known Share
-----------------------------------

Get information about a given share.

* Syntax: `/shares/<share_id>`
* Method: `GET`

========= ==== =====================
Attribute Type Description
========= ==== =====================
share_id  int  The share’s unique id
========= ==== =====================

Returns
^^^^^^^

XML with the share information

Status Codes
^^^^^^^^^^^^

==== ===================
Code Description
==== ===================
100  Successful
404  Share doesn't exist
==== ===================

Code Example
^^^^^^^^^^^^

Curl
~~~~

.. literalinclude:: examples/curl/get-share-info.sh
   :caption: Get information about a known share
   :language: bash
   :linenos:

PHP
~~~~

.. literalinclude:: examples/php/get-share-info.php
   :caption: Get information about a known share
   :language: php
   :linenos:

Ruby
~~~~

.. literalinclude:: examples/ruby/get-share-info.ruby
   :caption: Get information about a known share
   :language: ruby
   :linenos:

Go
~~

.. literalinclude:: examples/php/get-share-info.go
   :caption: Get information about a known share
   :language: go
   :linenos:

Example Request Response Payloads
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: examples/responses/get-share-info-failure.xml
   :caption: Example Failure Response
   :language: xml
   :linenos:

.. literalinclude:: examples/responses/get-share-info-success.xml
   :caption: Example Failure Response
   :language: xml
   :linenos:

Response Attributes
^^^^^^^^^^^^^^^^^^^

====================== ========================================================
Attribute              Description
====================== ========================================================
id
share_type
uid_owner
displayname_owner
permissions
stime
parent
expiration
token
uid_file_owner
displayname_file_owner
path
item_type
mimetype
storage_id
storage
item_source
file_source
file_parent
file_target
share_with
share_with_displayname
mail_send
====================== ========================================================

.. _ocs-share-api__create-share:

Create A New Share
------------------

Share an existing file or folder with a user, a group, or as public link.

* Syntax: `/shares`
* Method: `POST`

Function Arguments
^^^^^^^^^^^^^^^^^^

============ ======= ==========================================================
Argument     Type    Description 
============ ======= ==========================================================
path         string  path to the file/folder which should be shared
shareType    int     0 = user; 1 = group; 3 = public link; 
                     6 = federated cloud share
shareWith    string  user / group id with which the file should be shared
publicUpload boolean allow public upload to a public shared folder
password     string  password to protect public link Share with
permissions  int     1 = read; 2 = update; 4 = create; 8 = delete;
                     16 = share; 31 = all (default: 31, for public shares: 1)
============ ======= ==========================================================
Mandatory fields: shareType, path and shareWith for shareType 0 or 1.

Returns
^^^^^^^

XML containing the share ID (int) of the newly created share

Status Codes
^^^^^^^^^^^^^

==== =======================================
Code Description
==== =======================================
100  Successful
400  Unknown share type
403  Public upload was disabled by the admin
404  File couldn't be shared
==== =======================================

Code Example
^^^^^^^^^^^^

Curl
~~~~

.. literalinclude:: examples/curl/create-share.sh
   :caption: Create a new share
   :language: bash
   :linenos:

PHP
~~~~

.. literalinclude:: examples/php/create-share.php
   :caption: Create a new share
   :language: php
   :linenos:

Ruby
~~~~

.. literalinclude:: examples/ruby/create-share.ruby
   :caption: Create a new share
   :language: ruby
   :linenos:

Go
~~

.. literalinclude:: examples/php/create-share.go
   :caption: Create a new share 
   :language: go
   :linenos:

Example Request Response Payloads
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: examples/responses/create-share-failure.xml
   :caption: Example Failure Response because of an unknown share type
   :language: xml
   :linenos:

.. literalinclude:: examples/responses/create-share-success.xml
   :caption: Example Failure Response
   :language: xml
   :linenos:

Response Attributes
^^^^^^^^^^^^^^^^^^^

====================== ========================================================
Attribute              Description
====================== ========================================================
id
share_type
uid_owner
displayname_owner
permissions
stime
parent
expiration
token
uid_file_owner
displayname_file_owner
path
item_type
mimetype
storage_id
storage
item_source
file_source
file_parent
file_target
share_with
share_with_displayname
url
mail_send
====================== ========================================================

.. _ocs-share-api__delete-share:

Delete A Share
------------

Remove the given share.

* Syntax: `/shares/<share_id>`
* Method: `DELETE`

========= ======= =====================
Attribute Type    Description
========= ======= =====================
share_id  int     The share’s unique id
========= ======= =====================

Status Codes
^^^^^^^^^^^^

==== ========================
Code Description
==== ========================
100  Successful
404  File couldn't be deleted
==== ========================

Code Example
^^^^^^^^^^^^

Curl
~~~~

.. literalinclude:: examples/curl/delete-share.sh
   :caption: Delete an existing share
   :language: bash
   :linenos:

PHP
~~~~

.. literalinclude:: examples/php/delete-share.php
   :caption: Delete an existing share
   :language: php
   :linenos:

Ruby
~~~~

.. literalinclude:: examples/ruby/delete-share.ruby
   :caption: Delete an existing share
   :language: ruby
   :linenos:

Go
~~

.. literalinclude:: examples/php/delete-share.go
   :caption: Delete an existing share
   :language: go
   :linenos:

Example Request Response Payloads
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: examples/responses/delete-share-success.xml
   :caption: Example Failure Response
   :language: xml
   :linenos:

.. literalinclude:: examples/responses/delete-share-failure.xml
   :caption: Example Failure Response
   :language: xml
   :linenos:

.. _ocs-share-api__update-share:

Update Share
------------

Update a given share. Only one value can be updated per request.

* Syntax: `/shares/<share_id>`
* Method: `PUT`

Request Arguments
~~~~~~~~~~~~~~~~~

============ ======= ==================================================
Argument     Type    Description
============ ======= ==================================================
share_id     int     The share’s unique id
permissions  int     Update permissions 
                     (see :ref:`the create share section 
                     <_ocs-share-api__create-share>` above)
password     string  Updated password for public link Share
publicUpload boolean Enable (true) / disable (false) 
                     public upload for public shares.
expireDate   string  Set an expire date for public link shares. 
                     This argument expects a well-formated date string, 
                     such as: 'YYYY-MM-DD'
============ ======= ==================================================

.. note:: 
   
   Only one of the update parameters can be specified at once. 
   Also, a permission cannot be changed for a public link share.

Status Codes
^^^^^^^^^^^^

==== ===================================
Code Description
==== ===================================
100  Successful
400  Wrong or no update parameter given
403  Public upload disabled by the admin
404  Couldn't update share
==== ===================================

Code Example
^^^^^^^^^^^^

Curl
~~~~

.. literalinclude:: examples/curl/update-share.sh
   :caption: Update an existing share
   :language: bash
   :linenos:

PHP
~~~~

.. literalinclude:: examples/php/update-share.php
   :caption: Update an existing share
   :language: php
   :linenos:

Ruby
~~~~

.. literalinclude:: examples/ruby/update-share.ruby
   :caption: Update an existing share
   :language: ruby
   :linenos:

Go
~~

.. literalinclude:: examples/php/update-share.go
   :caption: Update an existing share
   :language: go
   :linenos:

Example Request Response Payloads
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: examples/responses/update-share-failure.xml
   :caption: Example Failure Response
   :language: xml
   :linenos:

.. literalinclude:: examples/responses/update-share-success.xml
   :caption: Example Failure Response
   :language: xml
   :linenos:

Federated Cloud Shares
======================

Both the sending and the receiving instance need to have federated cloud sharing
enabled and configured. See `Configuring Federated Cloud Sharing <https://doc.owncloud.org/server/9.0/admin_manual/configuration_files/federated_cloud_sharing_configuration.html>`_.

Create A New Federated Cloud Share
----------------------------------

Creating a federated cloud share can be done via the local share endpoint, using
(int) 6 as a shareType and the `Federated Cloud ID <https://owncloud.org/federation/>`_
of the share recipient as shareWith. See `Create a new Share`_ for more information.

List Accepted Federated Cloud Shares
------------------------------------

Get all federated cloud shares the user has accepted.

* Syntax: `/remote_shares`
* Method: `GET`

Returns
^^^^^^^

XML with all accepted federated cloud shares

Status Codes
^^^^^^^^^^^^

==== ===========
Code Description
==== ===========
100  Successful
==== ===========

Get Information About A Known Federated Cloud Share
---------------------------------------------------

Get information about a given received federated cloud that was sent from a remote instance.

* Syntax: `/remote_shares/<share_id>`
* Method: `GET`

========= ======= ======================================
Attribute Type    Description
========= ======= ======================================
share_id  int     The share id as listed in the id field 
                  in the ``remote_shares`` list
========= ======= ======================================

Returns
^^^^^^^

XML with the share information

Status Codes
^^^^^^^^^^^^

==== ===================
Code Description
==== ===================
100  Successful
404  Share doesn't exist
==== ===================

Delete An Accepted Federated Cloud Share
----------------------------------------

Locally delete a received federated cloud share that was sent from a remote instance.

* Syntax: `/remote_shares/<share_id>`
* Method: `DELETE`

========= ======= ======================================
Attribute Type    Description
========= ======= ======================================
share_id  int     The share id as listed in the id field 
                  in the ``remote_shares`` list
========= ======= ======================================

Returns
^^^^^^^

XML with the share information

Status Codes
^^^^^^^^^^^^

==== ===================
Code Description
==== ===================
100  Successful
404  Share doesn't exist
==== ===================

List Pending Federated Cloud Shares
-----------------------------------

Get all pending federated cloud shares the user has received.

* Syntax: `/remote_shares/pending`
* Method: `GET`

Returns
^^^^^^^

XML with all pending federated cloud shares

Status Codes
^^^^^^^^^^^^

==== ===================
Code Description
==== ===================
100  Successful
404  Share doesn't exist
==== ===================

Accept a pending Federated Cloud Share
--------------------------------------

Locally accept a received federated cloud share that was sent from a remote instance.

* Syntax: `/remote_shares/pending/*<share_id>*`
* Method: `POST`

========= ======= ======================================
Attribute Type    Description
========= ======= ======================================
share_id  int     The share id as listed in the id field 
                  in the ``remote_shares/pending`` list
========= ======= ======================================

Returns
^^^^^^^

XML with the share information

Status Codes
^^^^^^^^^^^^

==== ===================
Code Description
==== ===================
100  Successful
404  Share doesn't exist
==== ===================

Decline a pending Federated Cloud Share
---------------------------------------

Locally decline a received federated cloud share that was sent from a remote instance.

* Syntax: `/remote_shares/pending/<share_id>`
* Method: `DELETE`

========= ======= ======================================
Attribute Type    Description
========= ======= ======================================
share_id  int     The share id as listed in the id field 
                  in the ``remote_shares/pending`` list
========= ======= ======================================

Returns
^^^^^^^

XML with the share information

Status Codes
^^^^^^^^^^^^

==== ===================
Code Description
==== ===================
100  Successful
404  Share doesn't exist
==== ===================
