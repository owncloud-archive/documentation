========
Tags API
========

The tags API provides extensive support for managing tags within ownCloud. 
Using the tags API, you can: 

- :ref:`List tags <list_tags_label>`
- :ref:`Create tags <create_tags_label>`
- :ref:`Update tags <update_tags_label>` 
- :ref:`Delete tags <delete_tags_label>` 
- :ref:`Retrieve the tag ids and metadata of a given file <retrieve_tag_ids_and_metadata_label>`
- :ref:`Assign a tag to a file <assign_tag_to_file_label>`
- :ref:`Unassign a tag from a file <unassign_tag_from_file_label>`
- :ref:`Create and assign a tag at the same time <create_and_assign_tag_label>`
- :ref:`Retrieve all files tagged with a tag id <retrieve_files_tagged_with_id>`

In short, it provides all of the functionality available through the UI, from the command-line.

.. _list_tags_label:
   
List Tags
---------

============================= ============ ==============
Request Path                  Method       Content Type
============================= ============ ==============
``remote.php/dav/systemtags`` ``PROPFIND`` ``text/plain``
============================= ============ ==============
   
To retrieve a list of all tags, stored in your ownCloud installation, you need
to make an authenticated ``PROPFIND`` request, as in the example below.

:: 

  curl --silent -u username:password \
    -X PROPFIND \
    'http://localhost/remote.php/dav/systemtags' | xmllint --format -

.. note::
   The curl examples use `xmllint`_, available in the libxml2 package, to make the response easier to read.
   
This request will return an XML response similar to this example and a status of: ``HTTP/1.1 207 Multi-Status``.

.. code-block:: xml
   
   <?xml version="1.0"?>
   <d:multistatus xmlns:d="DAV:" xmlns:s="http://sabredav.org/ns" xmlns:cal="urn:ietf:params:xml:ns:caldav" xmlns:cs="http://calendarserver.org/ns/" xmlns:card="urn:ietf:params:xml:ns:carddav" xmlns:oc="http://owncloud.org/ns">
    <d:response>
      <d:href>/remote.php/dav/systemtags/2</d:href>
      <d:propstat>
        <d:prop>
          <d:resourcetype/>
        </d:prop>
        <d:status>HTTP/1.1 200 OK</d:status>
      </d:propstat>
    </d:response>
   </d:multistatus>
   
Note that it does not return very much, just the ``href`` and ``status`` properties. 
If you want to retrieve more detailed information, you need to supply a `PROPFIND`_ element in the request body, containing all the properties that you want to retrieve in the response.
The sample below, which for the purposes of this example we’ll store in a file called ``report-propfind.xml``, shows how to do so.

.. code-block:: xml

   <?xml version="1.0" encoding="utf-8" ?>
   <a:propfind xmlns:a="DAV:" xmlns:oc="http://owncloud.org/ns">
     <a:prop>
       <!-- Retrieve the display-name, user-visible, and user-assignable properties -->
       <oc:display-name/>
       <oc:user-visible/>
       <oc:user-assignable/>
       <oc:id/>
     </a:prop>
   </a:propfind>

To use it in the request, add the ``--data-binary`` switch, passing in the name of the file containing the ``PROPFIND`` XML element.

::

  curl --silent -u username:password \
    -X PROPFIND \
    -H "Content-Type: text/xml" \
     --data-binary "@report-propfind.xml" \
    'http://localhost/remote.php/dav/systemtags' | xmllint --format -    

.. note::
   We encourage you to store this in a separate file and use the ``--data-binary`` switch to include it in the request, instead of supplying the information in the command directly. This makes the information more maintainable.

Adding the ``PROPFIND`` XML element will cause the XML response to look similar to the following example.

.. code-block:: xml
   
   <?xml version="1.0"?>
   <d:multistatus xmlns:d="DAV:" xmlns:s="http://sabredav.org/ns" xmlns:cal="urn:ietf:params:xml:ns:caldav" xmlns:cs="http://calendarserver.org/ns/" xmlns:card="urn:ietf:params:xml:ns:carddav" xmlns:oc="http://owncloud.org/ns">
     <d:response>
       <d:href>/remote.php/dav/systemtags/10</d:href>
       <d:propstat>
         <d:prop>
           <oc:display-name>file</oc:display-name>
           <oc:user-visible>true</oc:user-visible>
           <oc:id>10</oc:id>
         </d:prop>
         <d:status>HTTP/1.1 200 OK</d:status>
       </d:propstat>
     </d:response>
     <d:response>
       <d:href>/remote.php/dav/systemtags/9</d:href>
       <d:propstat>
         <d:prop>
           <oc:display-name>for</oc:display-name>
           <oc:user-visible>true</oc:user-visible>
           <oc:id>9</oc:id>
         </d:prop>
         <d:status>HTTP/1.1 200 OK</d:status>
       </d:propstat>
     </d:response>
   </d:multistatus>

You can see that, along with the ``href`` and ``status`` elements, each element now contains the ``display-name``, ``user-visible``, and ``id`` elements.

.. note:: 
   To clarify, ``display-name`` contains the visible tag name.

.. _create_tags_label:
   
Create Tags
-----------

============================= ====== ====================
Request Path                  Method Content Type
============================= ====== ====================
``remote.php/dav/systemtags`` POST   ``application/json``
============================= ====== ====================

To create a tag, you need to send an authenticated ``POST`` request with a JSON body containing the details of the tag to create.
The example below shows how to create a tag with the name ``test5``, which is visible to all users.

::

  curl -u username:password \
    -X POST \
    -H "Content-Type: application/json" \
    --data-binary '{"name":"test5","userVisible":"true","userAssignable":"true"}' \
    "http://localhost/remote.php/dav/systemtags"

Available Parameters
~~~~~~~~~~~~~~~~~~~~

============== ======= ====== ========
Parameter      Type    Length Required 
============== ======= ====== ========
name           string         yes
userVisible    boolean        no
userAssignable boolean        no
============== ======= ====== ========

Response
~~~~~~~~

Regardless of success or failure, no response body is returned. 
However, if the tag is created successfully a status of ``HTTP/1.1 201 Created`` will be sent, and the location (and id) of the new tag will be available in the Content-Location header.
For example: ``Content-Location: /remote.php/dav/systemtags/15``.
If a tag with the name supplied already exists a status of ``HTTP/1.1 409 Conflict`` will be sent.
   
.. _update_tags_label:
   
Update Tags
-----------

===================================== ============= ============
Request Path                          Method        Content Type
===================================== ============= ============
``remote.php/dav/systemtags/<tagid>`` ``PROPPATCH`` ``text/xml``
===================================== ============= ============

To update an existing tag, you need to send an authenticated ``PROPPATCH`` request and provide a ``PROPFIND`` XML element in the body. 
Below is an example request, which will change the tag with the id of 15.

::

  curl -u username:password -X PROPPATCH \
    -H "Content-Type: text/xml" \
    --data-binary '@update-tag.xml' \
    "http://localhost/remote.php/dav/systemtags/15" | xmllint --format -

Below is an example ``PROPPATCH`` element, which changes the message text but leaves the rest of the message unchanged.

.. code-block:: xml
   
   <?xml version="1.0" encoding="utf-8" ?>
   <a:propertyupdate xmlns:a="DAV:" xmlns:oc="http://owncloud.org/ns">
     <a:set>
         <a:prop>
           <oc:name>This is an updated tag.</oc:name>
         </a:prop>
     </a:set>
   </a:propertyupdate>
   
Response
~~~~~~~~

If the update is successful, then an XML response body will be returned, which looks similar to the example below.
In addition an ``HTTP/1.1 207 Multi-Status`` status will also be returned.

.. code-block:: xml

    <?xml version="1.0"?>
    <d:multistatus xmlns:d="DAV:" xmlns:s="http://sabredav.org/ns" xmlns:cal="urn:ietf:params:xml:ns:caldav" xmlns:cs="http://calendarserver.org/ns/" xmlns:card="urn:ietf:params:xml:ns:carddav" xmlns:oc="http://owncloud.org/ns">
      <d:response>
        <d:href>/remote.php/dav/systemtags/15</d:href>
        <d:propstat>
          <d:prop>
            <oc:name/>
          </d:prop>
          <d:status>HTTP/1.1 200 OK</d:status>
        </d:propstat>
      </d:response>
    </d:multistatus>
   
.. _delete_tags_label:
   
Delete Tags
-----------

===================================== ====== ============
Request Path                          Method Content Type
===================================== ====== ============
``remote.php/dav/systemtags/<tagid>`` DELETE text/plain
===================================== ====== ============

To delete a tag, send an authenticated ``DELETE`` request, specifying the path to the tag that you want to delete. 

::

  curl -u username:password -X DELETE 'http://localhost/remote.php/dav/systemtags/15'  

If the comment was successfully deleted, an ``HTTP/1.1 204 No Content`` status will be returned but with no response body.
However, if the comment does not exist, then the following response will be returned, along with an ``HTTP/1.1 404 Not Found`` status.

.. code-block:: xml
   
   <?xml version="1.0" encoding="utf-8"?>
   <d:error xmlns:d="DAV:" xmlns:s="http://sabredav.org/ns">
     <s:exception>Sabre\DAV\Exception\NotFound</s:exception>
     <s:message>Tag with id 15 not found</s:message>
   </d:error>
   
.. _retrieve_tag_ids_and_metadata_label:
   
Retrieve the Tag Ids and Metadata of a Given File
-------------------------------------------------

======================================================== ======== ============
Request Path                                             Method   Content Type
======================================================== ======== ============
``remote.php/dav/systemtags-relations/files/<fileid>``   PROPFIND ``text/xml``
======================================================== ======== ============

To retrieve the tag ids and metadata of a given file, send an authenticated ``PROPFIND`` request, specifying the path to the file to retrieve the information from. 

::

  # Retrieve the details from file with id 4 
  curl -u username:password -X PROPFIND \
    -H "Content-Type: text/xml" \
    "http://localhost/remote.php/dav/systemtags-relations/files/4" | xmllint --format -

Response
~~~~~~~~

.. code-block:: xml

    <?xml version="1.0"?>
    <d:multistatus xmlns:d="DAV:" xmlns:s="http://sabredav.org/ns" xmlns:cal="urn:ietf:params:xml:ns:caldav" xmlns:cs="http://calendarserver.org/ns/" xmlns:card="urn:ietf:params:xml:ns:carddav" xmlns:oc="http://owncloud.org/ns">
      <d:response>
        <d:href>/remote.php/dav/systemtags-relations/files/4/</d:href>
        <d:propstat>
          <d:prop>
            <d:resourcetype>
              <d:collection/>
            </d:resourcetype>
          </d:prop>
          <d:status>HTTP/1.1 200 OK</d:status>
        </d:propstat>
      </d:response>
    </d:multistatus>

If more detailed information is desired, a ``PROPFIND`` element in the request body is required.
The sample below, which for the purposes of this example we’ll store in a file called ``report-propfind.xml`` will return the display-name, user-visible, user-assignable, and id values for each tag.

.. code-block:: xml

   <?xml version="1.0" encoding="utf-8" ?>
   <a:propfind xmlns:a="DAV:" xmlns:oc="http://owncloud.org/ns">
     <a:prop>
       <oc:display-name/>
       <oc:user-visible/>
       <oc:user-assignable/>
       <oc:id/>
     </a:prop>
   </a:propfind>

To use it, as in previous examples, the ``--data-binary`` switch is required, as in the example below.

::

  curl -u username:password -X PROPFIND \
    -H "Content-Type: text/xml" \
    --data-binary '@report-propfind.xml' \
    "http://localhost/remote.php/dav/systemtags-relations/files/4" | xmllint --format -

Below is an example of the response returned from this request:

.. code-block:: xml
   
   <?xml version="1.0"?>
   <d:multistatus xmlns:d="DAV:" xmlns:s="http://sabredav.org/ns" xmlns:cal="urn:ietf:params:xml:ns:caldav" xmlns:cs="http://calendarserver.org/ns/" xmlns:card="urn:ietf:params:xml:ns:carddav" xmlns:oc="http://owncloud.org/ns">
     <d:response>
       <d:href>/remote.php/dav/systemtags-relations/files/4/2</d:href>
       <d:propstat>
         <d:prop>
           <oc:display-name>test</oc:display-name>
           <oc:user-visible>true</oc:user-visible>
           <oc:user-assignable>true</oc:user-assignable>
           <oc:id>2</oc:id>
         </d:prop>
         <d:status>HTTP/1.1 200 OK</d:status>
       </d:propstat>
     </d:response>

.. _assign_tag_to_file_label:
   
Assign a Tag to a File
----------------------

================================================================ ====== ================
Request Path                                                     Method Content Type
================================================================ ====== ================
``remote.php/dav/systemtags-relations/files/<fileid>/<tagid>``   PUT    ``text/xml``
================================================================ ====== ================

To assign a tag to a file, send an authenticated ``PUT`` request specifying the path to the file to tag.
Here is an example of how to do it using Curl.

::

  curl -u username:password -X PUT \
    -H "Content-Type: text/xml" \
    "http://localhost/remote.php/dav/systemtags-relations/files/4/6"

Response
~~~~~~~~

If the request is successful, no response body will be returned, but an ``HTTP/1.1 201 Created`` status will be returned.
If the request is not successful, then either an ``HTTP/1.1 404 Not Found`` or an ``HTTP/1.1 409 Conflict`` status will be returned. 
A 404 status is returned if the file or folder doesn't exist.
A 409 status is returned if the tag has already been assigned to that file or folder.

.. _unassign_tag_from_file_label:
   
Unassign a Tag From a File
--------------------------

================================================================ ====== ================
Request Path                                                     Method Content Type
================================================================ ====== ================
``remote.php/dav/systemtags-relations/files/<fileid>/<tagid>``   DELETE ``text/xml``
================================================================ ====== ================

To un-assign or remove a tag from a file, send an authenticated ``DELETE`` request specifying the path to the file and the tag to remove.
Here is an example of how to do it using Curl.

::

  curl --silent --verbose -u username:password -X DELETE \                                                           
    -H "Content-Type: text/xml" \
    "http://localhost/remote.php/dav/systemtags-relations/files/4/6"

Response
~~~~~~~~

If the request is successful, no response body will be returned, but an ``HTTP/1.1 204 No Content`` status will be returned.
If the request is not successful, likely because the tag was not assigned to the file or folder, then an ``HTTP/1.1 404 Not Found`` status will be returned. 

.. _create_and_assign_tag_label:

Create and Assign a Tag at the Same Time
----------------------------------------

======================================================== ====== ================
Request Path                                             Method Content Type
======================================================== ====== ================
``remote.php/dav/systemtags-relations/files/<fileid>``   POST   application/json
======================================================== ====== ================
   
In addition to assigning existing tags to a file, you can also create a new tag and assign it to a file in one request.
You do this by sending an authenticated ``POST`` request specifying the path to the file and a JSON body containing the details of the tag to create.

The new tag will be created and assigned, effectively, in one atomic operation.
Here is an example of how to do it using Curl.

::

  curl --silent --verbose -u username:password -X POST \
    -H "Content-Type: application/json" \
    --data-binary '{"name":"variabletag","userVisible":"true","userAssignable":"true"}' \
    "http://localhost/remote.php/dav/systemtags-relations/files/4"

If the request is successful, no response body will be returned, but an ``HTTP/1.1 201 Created`` status will be returned.
If the request is not successful, likely because the tag already exists, then an ``HTTP/1.1 409 Conflict`` status will be returned. 
   
   
.. _retrieve_files_tagged_with_id:
   
Retrieve All Files Tagged with a Tag Id
---------------------------------------

====================== ====== ============
Request Path           Method Content Type
====================== ====== ============
``remote.php/webdav/`` REPORT ``text/xml``
====================== ====== ============

To retrieve all the files tagged with a given tag id send an authenticated ``REPORT`` request with a ``PROPFIND`` element in the request body containing the tag id to filter on and the list of properties to return.

The sample a ``PROPFIND`` element below, which for the purposes of this example we’ll store in a file called ``report-propfind.xml``, will return every tag property, and will filter on tag id 17.

.. code-block:: xml

   <oc:filter-files  xmlns:d="DAV:" xmlns:oc="http://owncloud.org/ns">
       <d:prop>
           <d:getlastmodified />
           <d:getetag />
           <d:getcontenttype />
           <d:resourcetype />
           <oc:fileid />
           <oc:permissions />
           <oc:size />
           <d:getcontentlength />
           <oc:tags />
           <oc:favorite />
           <oc:comments-unread />
           <oc:owner-display-name />
           <oc:share-types />
       </d:prop>
       <oc:filter-rules>
           <oc:systemtag>17</oc:systemtag>
       </oc:filter-rules>
   </oc:filter-files>

And here is an example of how to make the request using Curl.

:: 

  curl --silent --verbose -u username:password -X REPORT \
    -H "Content-Type: text/xml" \
    --data-binary "@find-tags-by-file.xml" \
    "http://localhost/remote.php/webdav/" | xmllint --format -

Response
~~~~~~~~

A successful response which you can see an example of below, along with a status of ``HTTP/1.1 207 Multi-Status`` will be returned.

.. code-block:: xml

    <?xml version="1.0"?>
    <d:multistatus xmlns:d="DAV:" xmlns:s="http://sabredav.org/ns" xmlns:oc="http://owncloud.org/ns">
      <d:response>
        <d:href>/remote.php/webdav/Photos/Squirrel.jpg</d:href>
        <d:propstat>
          <d:prop>
            <d:getlastmodified>Wed, 03 May 2017 11:05:49 GMT</d:getlastmodified>
            <d:getetag>"0169c644a1580687b346ef43315d5ac8"</d:getetag>
            <d:getcontenttype>image/jpeg</d:getcontenttype>
            <d:resourcetype/>
            <oc:fileid>6</oc:fileid>
            <oc:permissions>RDNVW</oc:permissions>
            <oc:size>233724</oc:size>
            <d:getcontentlength>233724</d:getcontentlength>
            <oc:tags/>
            <oc:favorite>0</oc:favorite>
            <oc:comments-unread>0</oc:comments-unread>
            <oc:owner-display-name>admin</oc:owner-display-name>
            <oc:share-types/>
          </d:prop>
          <d:status>HTTP/1.1 200 OK</d:status>
        </d:propstat>
      </d:response>
    </d:multistatus>

If the request was unsuccessful, likely because the tag specified didn't exist, then an ``HTTP/1.1 412 Precondition failed`` status will be returned, along with the following XML payload in the body of the response.

.. code-block:: xml
   
   <?xml version="1.0" encoding="utf-8"?>
   <d:error xmlns:d="DAV:" xmlns:s="http://sabredav.org/ns">
     <s:exception>Sabre\DAV\Exception\PreconditionFailed</s:exception>
     <s:message>Cannot filter by non-existing tag</s:message>
   </d:error>

.. Links
   
.. _xmllint: http://xmlsoft.org/xmllint.html
.. _PROPFIND: https://webmasters.stackexchange.com/questions/59211/what-is-http-method-propfind-used-for
