=====================
User Provisioning API
=====================

The Provisioning API application enables a set of APIs that external systems can use to:

- Create, edit, delete and query user attributes
- Query, set and remove groups
- Set quota and query total storage used in ownCloud
- Group admin users can also query ownCloud and perform the same functions as an admin for groups they manage.
- Query for active ownCloud applications, application info, and to enable or disable an app.

HTTP requests can be used via `a Basic Auth header`_ to perform any of the functions listed above.
The Provisioning API app is enabled by default.
The base URL for all calls to the share API is **owncloud_base_url/ocs/v1.php/cloud**.

Instruction Set For Users
=========================

Add User
--------

Create a new user on the ownCloud server.
Authentication is done by sending a basic HTTP authentication header.

Syntax
^^^^^^

============================= ============ ==============
Request Path                  Method       Content Type
============================= ============ ==============
``ocs/v1.php/cloud/users``    ``POST``     ``text/plain``
============================= ============ ==============

======== ====== ======================================
Argument Type   Description
======== ====== ======================================
userid   string The required username for the new user
password string The required password for the new user
groups   array  Groups to add the user to [optional]
======== ====== ======================================

Status Codes
^^^^^^^^^^^^

* 100 - successful
* 101 - invalid input data
* 102 - username already exists
* 103 - unknown error occurred whilst adding the user
* 104 - group does not exist

Example
^^^^^^^

.. code-block:: console

  # Creates the user ``Frank`` with password ``frankspassword``
  curl -X POST http://admin:secret@example.com/ocs/v1.php/cloud/users \
     -d userid="Frank" \
     -d password="frankspassword"

  # Creates the user ``Frank`` with password ``frankspassword`` and adds him to the ``finance`` and ``management``groups
  curl -X POST http://admin:secret@example.com/ocs/v1.php/cloud/users \
     -d userid="Frank" \
     -d password="frankspassword" \
     -d groups[]="finance" -d groups[]="management"

XML Output
^^^^^^^^^^

.. code-block:: xml

 <?xml version="1.0"?>
 <ocs>
   <meta>
     <status>ok</status>
     <statuscode>100</statuscode>
     <message/>
   </meta>
   <data/>
 </ocs>

Get Users
---------

Retrieves a list of users from the ownCloud server.
Authentication is done by sending a Basic HTTP Authorization header.

========================== ======= ==============
Request Path               Method  Content Type
========================== ======= ==============
``ocs/v1.php/cloud/users`` ``GET`` ``text/plain``
========================== ======= ==============

======== ====== ======================================
Argument Type   Description
======== ====== ======================================
search   string optional search string
limit    int    optional limit value
offset   int    optional offset value
======== ====== ======================================

Status Codes
^^^^^^^^^^^^

* 100 - successful

Example
^^^^^^^

.. code-block:: console

  # Returns list of users matching the search string.
  curl http://admin:secret@example.com/ocs/v1.php/cloud/users?search=Frank

XML Output
^^^^^^^^^^

.. code-block:: xml

  <?xml version="1.0"?>
  <ocs>
    <meta>
      <statuscode>100</statuscode>
      <status>ok</status>
    </meta>
    <data>
      <users>
        <element>Frank</element>
       </users>
    </data>
  </ocs>

Get User
--------

Retrieves information about a single user.
Authentication is done by sending a Basic HTTP Authorization header.

=========================================== ======= ==============
Request Path                                Method  Content Type
=========================================== ======= ==============
``Syntax: ocs/v1.php/cloud/users/{userid}`` ``GET`` ``text/plain``
=========================================== ======= ==============

======== ====== ======================================
Argument Type   Description
======== ====== ======================================
userid   int    Id of the user to retrieve
======== ====== ======================================

Status Codes
^^^^^^^^^^^^

* 100 - successful

Example
^^^^^^^

.. code-block:: xml

  # Returns information on the user ``Frank``
  curl http://admin:secret@example.com/ocs/v1.php/cloud/users/Frank

XML Output
^^^^^^^^^^

.. code-block:: xml

  <?xml version="1.0"?>
  <ocs>
     <meta>
       <status>ok</status>
       <statuscode>100</statuscode>
       <message/>
     </meta>
     <data>
       <enabled>true</enabled>
       <quota>
         <free>81919008768</free>
         <used>5809166</used>
         <total>81924817934</total>
         <relative>0.01</relative>
       </quota>
       <email>user@example.com</email>
       <displayname>Frank</displayname>
       <home>/mnt/data/files/Frank</home>
       <two_factor_auth_enabled>false</two_factor_auth_enabled>
    </data>
  </ocs>

Edit User
---------

Edits attributes related to a user.
Users are able to edit *email*, *displayname* and *password*; admins can also edit the quota value.
Authentication is done by sending a Basic HTTP Authorization header.

=================================== ======= ==============
Request Path                        Method  Content Type
=================================== ======= ==============
``ocs/v1.php/cloud/users/{userid}`` ``PUT`` ``text/plain``
=================================== ======= ==============

======== ====== ===================================================
Argument Type   Description
======== ====== ===================================================
key      string the field to edit (email, quota, display, password)
value    mixed  the new value for the field
======== ====== ===================================================

Status Codes
^^^^^^^^^^^^

* 100 - successful
* 101 - user not found
* 102 - invalid input data

Examples
^^^^^^^^

.. code-block:: console

  Updates the email address for the user ``Frank``
  curl -X PUT http://admin:secret@example.com/ocs/v1.php/cloud/users/Frank \
      -d key="email" \
      -d value="franksnewemail@example.org"

  Updates the quota for the user ``Frank``
  curl -X PUT http://admin:secret@example.com/ocs/v1.php/cloud/users/Frank \
      -d key="quota" \
      -d value="100MB"

XML Output
^^^^^^^^^^

.. code-block:: xml

  <?xml version="1.0"?>
  <ocs>
    <meta>
      <statuscode>100</statuscode>
      <status>ok</status>
    </meta>
    <data/>
  </ocs>

Enable User
-----------

Enables a user on the ownCloud server.
Authentication is done by sending a Basic HTTP Authorization header.

========================================== ======== ==============
Request Path                               Method   Content Type
========================================== ======== ==============
``ocs/v1.php/cloud/users/{userid}/enable`` ``PUT``  ``text/plain``
========================================== ======== ==============

======== ====== ======================================
Argument Type   Description
======== ====== ======================================
userid   string The id of the user to enable
======== ====== ======================================

Status Codes
^^^^^^^^^^^^

* 100 - successful
* 101 - failure

Example
^^^^^^^

.. code-block:: console

  # Enable the user ``Frank``
  curl -X PUT http://admin:secret@example.com/ocs/v1.php/cloud/users/Frank/enable

XML Output
^^^^^^^^^^

.. code-block:: xml

  <?xml version="1.0"?>
  <ocs>
    <meta>
      <status>ok</status>
      <statuscode>100</statuscode>
       <message/>
    </meta>
    <data/>
  </ocs>

Disable User
------------

Disables a user on the ownCloud server.
Authentication is done by sending a Basic HTTP Authorization header.

=========================================== ======== ==============
Request Path                                Method   Content Type
=========================================== ======== ==============
``ocs/v1.php/cloud/users/{userid}/disable`` ``PUT``  ``text/plain``
=========================================== ======== ==============

======== ====== ======================================
Argument Type   Description
======== ====== ======================================
userid   string The id of the user to disable
======== ====== ======================================

Status Codes
^^^^^^^^^^^^

* 100 - successful
* 101 - failure

Example
^^^^^^^

.. code-block:: console

  # Disable the user ``Frank``
  curl -X PUT http://admin:secret@example.com/ocs/v1.php/cloud/users/Frank/disable

XML Output
^^^^^^^^^^

.. code-block:: xml

  <?xml version="1.0"?>
  <ocs>
    <meta>
      <status>ok</status>
      <statuscode>100</statuscode>
       <message/>
    </meta>
    <data/>
  </ocs>

Delete User
-----------

Deletes a user from the ownCloud server.
Authentication is done by sending a Basic HTTP Authorization header.

=================================== ========== ==============
Request Path                        Method     Content Type
=================================== ========== ==============
``ocs/v1.php/cloud/users/{userid}`` ``DELETE`` ``text/plain``
=================================== ========== ==============

======== ====== ======================================
Argument Type   Description
======== ====== ======================================
userid   string The id of the user to delete
======== ====== ======================================

Status Codes
^^^^^^^^^^^^

* 100 - successful
* 101 - failure

Example
^^^^^^^

.. code-block:: console

  # Deletes the user ``Frank``
  curl -X DELETE http://admin:secret@example.com/ocs/v1.php/cloud/users/Frank

XML Output
^^^^^^^^^^

.. code-block:: xml

  <?xml version="1.0"?>
  <ocs>
    <meta>
      <statuscode>100</statuscode>
      <status>ok</status>
    </meta>
    <data/>
  </ocs>

Get Groups
----------

Retrieves a list of groups the specified user is a member of.
Authentication is done by sending a Basic HTTP Authorization header.

========================================== ======= ==============
Request Path                               Method  Content Type
========================================== ======= ==============
``ocs/v1.php/cloud/users/{userid}/groups`` ``GET`` ``text/plain``
========================================== ======= ==============

======== ====== =========================================
Argument Type   Description
======== ====== =========================================
userid   string The id of the user to retrieve groups for
======== ====== =========================================

Status Codes
^^^^^^^^^^^^

* 100 - successful

Example
^^^^^^^

.. code-block:: console

  # Retrieves a list of groups of which ``Frank`` is a member
  curl http://admin:secret@example.com/ocs/v1.php/cloud/users/Frank/groups

XML Output
^^^^^^^^^^

.. code-block:: xml

  <?xml version="1.0"?>
  <ocs>
    <meta>
      <statuscode>100</statuscode>
      <status>ok</status>
    </meta>
    <data>
      <groups>
        <element>admin</element>
        <element>group1</element>
      </groups>
    </data>
  </ocs>

Add To Group
------------

Adds the specified user to the specified group.
Authentication is done by sending a Basic HTTP Authorization header.

========================================== ======== ==============
Request Path                               Method   Content Type
========================================== ======== ==============
``ocs/v1.php/cloud/users/{userid}/groups`` ``POST`` ``text/plain``
========================================== ======== ==============

======== ====== =========================================
Argument Type   Description
======== ====== =========================================
userid   string The id of the user to retrieve groups for
groupid  string The group to add the user to
======== ====== =========================================

Status Codes
^^^^^^^^^^^^

* 100 - successful
* 101 - no group specified
* 102 - group does not exist
* 103 - user does not exist
* 104 - insufficient privileges
* 105 - failed to add user to group

Example
^^^^^^^

.. code-block:: console

  # Adds the user ``Frank`` to the group ``newgroup``
  curl -X POST http://admin:secret@example.com/ocs/v1.php/cloud/users/Frank/groups -d groupid="newgroup"

XML Output
^^^^^^^^^^

.. code-block:: xml

  <?xml version="1.0"?>
  <ocs>
    <meta>
      <statuscode>100</statuscode>
      <status>ok</status>
    </meta>
    <data/>
  </ocs>

Remove From Group
-----------------

Removes the specified user from the specified group.
Authentication is done by sending a Basic HTTP Authorization header.

========================================== ========== ==============
Request Path                               Method     Content Type
========================================== ========== ==============
``ocs/v1.php/cloud/users/{userid}/groups`` ``DELETE`` ``text/plain``
========================================== ========== ==============

======== ====== =========================================
Argument Type   Description
======== ====== =========================================
userid   string The id of the user to retrieve groups for
groupid  string The group to remove the user from
======== ====== =========================================

Status Codes
^^^^^^^^^^^^

* 100 - successful
* 101 - no group specified
* 102 - group does not exist
* 103 - user does not exist
* 104 - insufficient privileges
* 105 - failed to remove user from group

Example
^^^^^^^

.. code-block:: console

  # Removes the user ``Frank`` from the group ``newgroup``
  curl -X DELETE http://admin:secret@example.com/ocs/v1.php/cloud/users/Frank/groups -d groupid="newgroup"

XML Output
^^^^^^^^^^

.. code-block:: xml

  <?xml version="1.0"?>
  <ocs>
    <meta>
      <statuscode>100</statuscode>
      <status>ok</status>
    </meta>
    <data/>
  </ocs>

Create Sub-admin
----------------

Makes a user the sub-admin of a group.
Authentication is done by sending a Basic HTTP Authorization header.

============================================= ======== ==============
Request Path                                   Method   Content Type
============================================= ======== ==============
``ocs/v1.php/cloud/users/{userid}/subadmins`` ``POST`` ``text/plain``
============================================= ======== ==============

======== ====== ===============================================
Argument Type   Description
======== ====== ===============================================
userid   string The id of the user to be made a sub-admin
groupid  string the group of which to make the user a sub-admin
======== ====== ===============================================

Status Codes
^^^^^^^^^^^^

* 100 - successful
* 101 - user does not exist
* 102 - group does not exist
* 103 - unknown failure

Example
^^^^^^^

.. code-block:: console

  # Makes the user ``Frank`` a sub-admin of the ``group`` group
  curl -X POST https://admin:secret@example.com/ocs/v1.php/cloud/users/Frank/subadmins -d groupid="group"

XML Output
^^^^^^^^^^

.. code-block:: xml

  <?xml version="1.0"?>
  <ocs>
    <meta>
      <statuscode>100</statuscode>
      <status>ok</status>
    </meta>
    <data/>
  </ocs>

Remove Sub-admin
----------------

Removes the sub-admin rights for the user specified from the group specified.
Authentication is done by sending a Basic HTTP Authorization header.

============================================= ========== ==============
Request Path                                   Method     Content Type
============================================= ========== ==============
``ocs/v1.php/cloud/users/{userid}/subadmins`` ``DELETE`` ``text/plain``
============================================= ========== ==============

======== ====== ==========================================================
Argument Type   Description
======== ====== ==========================================================
userid   string the id of the user to retrieve groups for
groupid  string the group from which to remove the user's sub-admin rights
======== ====== ==========================================================

Status Codes
^^^^^^^^^^^^

* 100 - successful
* 101 - user does not exist
* 102 - user is not a sub-admin of the group / group does not exist
* 103 - unknown failure

Example
^^^^^^^

.. code-block:: console

  # Removes ``Frank's`` sub-admin rights from the ``oldgroup`` group
  curl -X DELETE https://admin:secret@example.com/ocs/v1.php/cloud/users/Frank/subadmins -d groupid="oldgroup"

XML Output
^^^^^^^^^^

.. code-block:: xml

  <?xml version="1.0"?>
  <ocs>
    <meta>
      <statuscode>100</statuscode>
      <status>ok</status>
    </meta>
    <data/>
  </ocs>

Get Sub-admin Groups
--------------------

Returns the groups in which the user is a sub-admin.
Authentication is done by sending a Basic HTTP Authorization header.

============================================= ======= ==============
Request Path                                   Method  Content Type
============================================= ======= ==============
``ocs/v1.php/cloud/users/{userid}/subadmins`` ``GET`` ``text/plain``
============================================= ======= ==============

======== ====== ===================================================
Argument Type   Description
======== ====== ===================================================
userid   string The id of the user to retrieve sub-admin groups for
======== ====== ===================================================

Status Codes
^^^^^^^^^^^^

* 100 - successful
* 101 - user does not exist
* 102 - unknown failure

Example
^^^^^^^

.. code-block:: console

  # Returns the groups of which ``Frank`` is a sub-admin
  curl -X GET https://admin:secret@example.com/ocs/v1.php/cloud/users/Frank/subadmins

XML Output
^^^^^^^^^^

.. code-block:: xml

  <?xml version="1.0"?>
  <ocs>
    <meta>
        <status>ok</status>
        <statuscode>100</statuscode>
      <message/>
    </meta>
    <data>
      <element>testgroup</element>
    </data>
  </ocs>

Instruction Set For Groups
==========================

Get Groups
----------

Retrieves a list of groups from the ownCloud server.
Authentication is done by sending a Basic HTTP Authorization header.

=========================== ======= ==============
Request Path                Method  Content Type
=========================== ======= ==============
``ocs/v1.php/cloud/groups`` ``GET`` ``text/plain``
=========================== ======= ==============

======== ====== ======================================
Argument Type   Description
======== ====== ======================================
search   string optional search string
limit    int    optional limit value
offset   int    optional offset value
======== ====== ======================================

Status Codes
^^^^^^^^^^^^

* 100 - successful

Example
^^^^^^^

.. code-block:: console

  # Returns list of groups matching the search string.
  curl http://admin:secret@example.com/ocs/v1.php/cloud/groups?search=admi

XML Output
^^^^^^^^^^

.. code-block:: xml

  <?xml version="1.0"?>
  <ocs>
    <meta>
      <statuscode>100</statuscode>
      <status>ok</status>
    </meta>
    <data>
      <groups>
        <element>admin</element>
      </groups>
    </data>
  </ocs>

Add Group
---------

Adds a new group.
Authentication is done by sending a Basic HTTP Authorization header.

=========================== ========= ==============
Request Path                Method    Content Type
=========================== ========= ==============
``ocs/v1.php/cloud/groups`` ``POST``  ``text/plain``
=========================== ========= ==============

======== ====== ====================
Argument Type   Description
======== ====== ====================
groupid  string the new group’s name
======== ====== ====================

Status Codes
^^^^^^^^^^^^

* 100 - successful
* 101 - invalid input data
* 102 - group already exists
* 103 - failed to add the group

Example
^^^^^^^

.. code-block:: console

  # Adds a new group called ``newgroup``
  curl -X POST http://admin:secret@example.com/ocs/v1.php/cloud/groups -d groupid="newgroup"

XML Output
^^^^^^^^^^

.. code-block:: xml

  <?xml version="1.0"?>
  <ocs>
    <meta>
      <statuscode>100</statuscode>
      <status>ok</status>
    </meta>
    <data/>
  </ocs>

Get Group
---------

Retrieves a list of group members.
Authentication is done by sending a Basic HTTP Authorization header.

===================================== ======= ==============
Request Path                          Method  Content Type
===================================== ======= ==============
``ocs/v1.php/cloud/groups/{groupid}`` ``GET`` ``text/plain``
===================================== ======= ==============

======== ====== ===================================
Argument Type   Description
======== ====== ===================================
groupid  string The group id to return members from
======== ====== ===================================

Status Codes
^^^^^^^^^^^^

* 100 - successful

Example
^^^^^^^

.. code-block:: console

  # Returns a list of users in the ``admin`` group
  curl http://admin:secret@example.com/ocs/v1.php/cloud/groups/admin

XML Output
^^^^^^^^^^

.. code-block:: xml

  <?xml version="1.0"?>
  <ocs>
    <meta>
      <statuscode>100</statuscode>
      <status>ok</status>
    </meta>
    <data>
      <users>
        <element>Frank</element>
      </users>
    </data>
  </ocs>

Get Sub-admins
--------------

Returns sub-admins of the group.
Authentication is done by sending a Basic HTTP Authorization header.

=============================================== ======= ==============
Request Path                                     Method  Content Type
=============================================== ======= ==============
``ocs/v1.php/cloud/groups/{groupid}/subadmins`` ``GET`` ``text/plain``
=============================================== ======= ==============

======== ====== ======================================
Argument Type   Description
======== ====== ======================================
groupid  string The group id to get sub-admins for
======== ====== ======================================

Status Codes
^^^^^^^^^^^^

* 100 - successful
* 101 - group does not exist
* 102 - unknown failure

Example
^^^^^^^

.. code-block:: console

  # Return the sub-admins of the group: ``mygroup``
  curl https://admin:secret@example.com/ocs/v1.php/cloud/groups/mygroup/subadmins

XML Output
^^^^^^^^^^

.. code-block:: xml

  <?xml version="1.0"?>
  <ocs>
    <meta>
      <status>ok</status>
      <statuscode>100</statuscode>
      <message/>
    </meta>
    <data>
      <element>Tom</element>
    </data>
  </ocs>

Delete Group
------------

Removes a group.
Authentication is done by sending a Basic HTTP Authorization header.

===================================== ========== ==============
Request Path                          Method     Content Type
===================================== ========== ==============
``ocs/v1.php/cloud/groups/{groupid}`` ``DELETE`` ``text/plain``
===================================== ========== ==============

======== ====== ======================================
Argument Type   Description
======== ====== ======================================
groupid  string the group to delete
======== ====== ======================================

Status Codes
^^^^^^^^^^^^

* 100 - successful
* 101 - group does not exist
* 102 - failed to delete group

Example
^^^^^^^

.. code-block:: console

  # Delete the group ``mygroup``
  curl -X DELETE http://admin:secret@example.com/ocs/v1.php/cloud/groups/mygroup

XML Output
^^^^^^^^^^

.. code-block:: xml

  <?xml version="1.0"?>
  <ocs>
    <meta>
      <statuscode>100</statuscode>
      <status>ok</status>
    </meta>
    <data/>
  </ocs>

Instruction Set For Apps
=========================

Get Apps
--------

Returns a list of apps installed on the ownCloud server.
Authentication is done by sending a Basic HTTP Authorization header.

========================== ======= ==============
Request Path               Method  Content Type
========================== ======= ==============
``ocs/v1.php/cloud/apps/`` ``GET`` ``text/plain``
========================== ======= ==============

======== ====== ======================================
Argument Type   Description
======== ====== ======================================
filter   string Whether to retrieve enabled or disable
                apps. Available values are ``enabled``
                and ``disabled``.
======== ====== ======================================

Status Codes
^^^^^^^^^^^^

* 100 - successful
* 101 - invalid input data

Example
^^^^^^^

.. code-block:: console

  # Gets enabled apps
  curl http://admin:secret@example.com/ocs/v1.php/cloud/apps?filter=enabled

XML Output
^^^^^^^^^^

.. code-block:: xml

  <?xml version="1.0"?>
  <ocs>
    <meta>
      <statuscode>100</statuscode>
      <status>ok</status>
    </meta>
    <data>
      <apps>
        <element>files</element>
        <element>provisioning_api</element>
      </apps>
    </data>
  </ocs>

Get App Info
------------

Provides information on a specific application.
Authentication is done by sending a Basic HTTP Authorization header.

================================= ======= ==============
Request Path                      Method  Content Type
================================= ======= ==============
``ocs/v1.php/cloud/apps/{appid}`` ``GET`` ``text/plain``
================================= ======= ==============

======== ====== ======================================
Argument Type   Description
======== ====== ======================================
appid    string The app to retrieve information for
======== ====== ======================================

Status Codes
^^^^^^^^^^^^

* 100 - successful

Example
^^^^^^^

.. code-block:: console

  # Get app info for the ``files`` app
  curl http://admin:secret@example.com/ocs/v1.php/cloud/apps/files

XML Output
^^^^^^^^^^

.. code-block:: xml

  <?xml version="1.0"?>
  <ocs>
    <meta>
      <statuscode>100</statuscode>
      <status>ok</status>
    </meta>
    <data>
      <info/>
      <remote>
        <files>appinfo/remote.php</files>
        <webdav>appinfo/remote.php</webdav>
        <filesync>appinfo/filesync.php</filesync>
      </remote>
      <public/>
      <id>files</id>
      <name>Files</name>
      <description>File Management</description>
      <licence>AGPL</licence>
      <author>Robin Appelman</author>
      <require>4.9</require>
      <shipped>true</shipped>
      <standalone></standalone>
      <default_enable></default_enable>
      <types>
        <element>filesystem</element>
      </types>
    </data>
  </ocs>

Enable
------

Enable an app.
Authentication is done by sending a Basic HTTP Authorization header.

================================= ======== ==============
Request Path                      Method   Content Type
================================= ======== ==============
``ocs/v1.php/cloud/apps/{appid}`` ``POST`` ``text/plain``
================================= ======== ==============

======== ====== ======================================
Argument Type   Description
======== ====== ======================================
appid    string The id of the app to enable
======== ====== ======================================

Status Codes
^^^^^^^^^^^^

* 100 - successful

Example
^^^^^^^

.. code-block:: console

  # Enable the ``files_texteditor`` app
  curl -X POST http://admin:secret@example.com/ocs/v1.php/cloud/apps/files_texteditor

XML Output
^^^^^^^^^^

.. code-block:: xml

  <?xml version="1.0"?>
  <ocs>
    <meta>
      <statuscode>100</statuscode>
      <status>ok</status>
    </meta>
  </ocs>

Disable
-------

Disables the specified app. Authentication is done by sending a Basic HTTP Authorization header.

================================= ========== ==============
Request Path                      Method     Content Type
================================= ========== ==============
``ocs/v1.php/cloud/apps/{appid}`` ``DELETE`` ``text/plain``
================================= ========== ==============

======== ====== ======================================
Argument Type   Description
======== ====== ======================================
appid    string The id of the app to disable
======== ====== ======================================

Status Codes
^^^^^^^^^^^^

* 100 - successful

Example
^^^^^^^

.. code-block:: console

  Disable the ``files_texteditor`` app
  curl -X DELETE http://admin:secret@example.com/ocs/v1.php/cloud/apps/files_texteditor

XML Output
^^^^^^^^^^

.. code-block:: xml

  <?xml version="1.0"?>
  <ocs>
    <meta>
      <statuscode>100</statuscode>
      <status>ok</status>
    </meta>
  </ocs>

.. Links

.. _a Basic Auth header: https://en.wikipedia.org/wiki/Basic_access_authentication
