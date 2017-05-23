=================
OCS Recipient API
=================

The OCS Recipient API is a new OCS endpoint that is used by the share dialog autocomplete process, when you pick a user or group to share to. 

The base URL for all calls to the share API is: 
*<owncloud_base_url>/ocs/v1.php/apps/files_sharing/api/v1/sharees?format=json*

Get Shares Recipients
---------------------

.. _ocs-recipient-api__get-all-shares:
   
Get All Shares
--------------

Get all shares from the user.

* Syntax: `/shares`
* Method: `GET`

Query Attributes
^^^^^^^^^^^^^^^^

=========== ======= ====================================================== ======== =======
Attribute   Type    Description                                            Required Default
=========== ======= ====================================================== ======== =======
format      string  The response format. Can be either ``xml`` or ``json``          ``xml``
search      string  The search string
itemType    string  The type which is shared.                              Yes
                    Can be either ``file`` or ``folder``
shareType   integer Any one of:
                      - 0 (user)
                      - 1 (group)
                      - 6 (remote)
page        integer The page number in the results to be returned                   1
perPage     integer The number of items per page                           Yes      200
=========== ======= ====================================================== ======== =======

Status Codes
^^^^^^^^^^^^

==== =======================================
Code Description
==== =======================================
100  Successful
400  Failure due to invalid query parameters
==== =======================================

Example Request Response Payloads
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: ../examples/responses/recipients/response-success.json
   :language: json

Code Example
^^^^^^^^^^^^

Curl
~~~~

.. literalinclude:: ../examples/curl/delete-share.sh
   :language: bash

PHP
~~~~

.. literalinclude:: ../examples/php/delete-share.php
   :language: php

Ruby
~~~~

.. literalinclude:: ../examples/ruby/delete-share.rb
   :language: ruby

Go
~~

.. literalinclude:: ../examples/go/delete-share.go
   :language: go
