============
Comments API
============

The comments API allows for the following functionality files and folders stored in ownCloud:

- :ref:`listing comments <list_comments_label>`
- :ref:`creating comments <create_comments_label>`
- :ref:`updating comments <update_comments_label>`
- :ref:`deleting comments <delete_comments_label>`

It provides all of the functionality available through the UI, from the command-line.

.. _list_comments_label:

List Comments
-------------

========================================== ============ ============
Request Path                               Method       Content Type
========================================== ============ ============
``remote.php/dav/comments/files/<fileid>`` ``PROPFIND`` ``text/xml``
========================================== ============ ============

To retrieve a list of all comments, whether, for a file or folder, you need to make an authenticated ``PROPFIND`` request, and supply it with the path to the file or folder that you want to retrieve the comments of, as in the example below.

::

  curl --silent -u username:password \
    -X PROPFIND \
    -H "Content-Type: text/xml" \
    'http://localhost/remote.php/dav/comments/files/4' | xmllint --format -    

The response payload will look similar to the example below.
It will contain a list of ``d:response`` elements, one for each comment attached to the file specified.

.. note::
   The example above uses xmllint, available in the libxml2 package to make the response easier to read.

.. code-block:: xml
     
   <?xml version="1.0"?>
   <d:multistatus xmlns:d="DAV:" xmlns:s="http://sabredav.org/ns" xmlns:cal="urn:ietf:params:xml:ns:caldav" xmlns:cs="http://calendarserver.org/ns/" xmlns:card="urn:ietf:params:xml:ns:carddav" xmlns:oc="http://owncloud.org/ns">
     <d:response>
       <d:href>/remote.php/dav/comments/files/4/4</d:href>
       <d:propstat>
         <d:prop>
            <d:resourcetype/>
            <oc:id>1</oc:id>
            <oc:parentId>0</oc:parentId>
            <oc:topmostParentId>0</oc:topmostParentId>
            <oc:childrenCount>0</oc:childrenCount>
            <oc:message>Here is a comment.</oc:message>
            <oc:verb>comment</oc:verb>
            <oc:actorType>users</oc:actorType>
            <oc:actorId>admin</oc:actorId>
            <oc:creationDateTime>Tue, 16 May 2017 12:34:10 GMT</oc:creationDateTime>
            <oc:latestChildDateTime/>
            <oc:objectType>files</oc:objectType>
            <oc:objectId>4</oc:objectId>
            <oc:actorDisplayName>admin</oc:actorDisplayName>
            <oc:isUnread>false</oc:isUnread>
         </d:prop>
         <d:status>HTTP/1.1 200 OK</d:status>
       </d:propstat>
     </d:response>
   </d:multistatus>

If you want to filter the information returned in the ``d:prop`` element of the XML response, you can supply a ``PROPFIND`` XML element in the body of the request method.
The example below shows how to filter the information returned to just the ``oc:message`` element.

.. code-block:: xml

   <?xml version="1.0" encoding="utf-8" ?>
   <a:propfind xmlns:a="DAV:" xmlns:oc="http://owncloud.org/ns">
     <a:prop><oc:message/></a:prop>
   </a:propfind>

To use it in the request, add the ``--data-binary`` switch, passing in the name of the file containing the ``PROPFIND`` XML element.
I've called it ``report-propfind.xml`` in the example below.

::

  curl --silent -u username:password \
    -X PROPFIND \
    -H "Content-Type: text/xml" \
     --data-binary "@report-propfind.xml" \
    'http://localhost/remote.php/dav/comments/files/4' | xmllint --format -    

.. _create_comments_label:

Create Comments
---------------

========================================== ======== ====================
Request Path                               Method   Content Type
========================================== ======== ====================
``remote.php/dav/comments/files/<fileid>`` ``POST`` ``application/json``
========================================== ======== ====================

To create a comment, you need to send an authenticated ``POST`` request with a JSON body containing the details of the comment to create.
The example below shows how to create a comment on the file with the file id 4.

::

  curl -u username:password \
    -X POST \
    -H "Content-Type: application/json" \
    --data-binary '{"message":"this is my message","actorType":"users","verb":"comment"}' \
    "http://localhost/remote.php/dav/comments/files/4"

The available options are:

============= ====== =======================================================================
Parameter     Type   Description
============= ====== =======================================================================
``actorType`` String The type of user who’s adding the comment.
``message``   String The comment's message text. It can be up to 1,000 characters in length.
``verb``      String The type of comment to create, typically ``comment``.
============= ====== =======================================================================

.. note:: 
   The comment is attributed to the user making the request.
   
.. note::
   To retrieve a file id, refer to the `relevant section of the documentation`_.

Response
~~~~~~~~

If the request is successful, there will be no response body returned. 
However, it will have an ``HTTP/1.1 201 Created`` status.

.. _update_comments_label:

Update Comments
---------------

====================================================== ============= ============
Request Path                                           Method        Content Type
====================================================== ============= ============
``remote.php/dav/comments/files/<fileid>/<commentid>`` ``PROPPATCH`` ``text/xml``
====================================================== ============= ============

To update an existing comment, you need to send an authenticated ``PROPPATCH`` request and provide a ``PROPFIND`` XML element in the body. 

.. note::
   As with creating comments, we encourage you to store this in a separate file and use the ``--data-binary`` switch to include it in the request. This makes the information more maintainable.

Below is an example request, which will change the comment with the id of 4, on the file with the file id of 4.

::

  curl -u username:password \
    -X PROPPATCH \
    -H "Content-Type: text/xml" \
    --data-binary "@update-comment.xml" \
    'http://localhost/remote.php/dav/comments/files/4/4' | xmllint --format -    

Below is an example ``PROPPATCH`` element, which changes the message text but leaves the rest of the message unchanged.

.. code-block:: xml
   
   <?xml version="1.0" encoding="utf-8" ?>
   <a:propertyupdate xmlns:a="DAV:" xmlns:oc="http://owncloud.org/ns">
     <a:set>
         <a:prop>
           <oc:message>This is an updated message.</oc:message>
         </a:prop>
     </a:set>
   </a:propertyupdate>

Response
~~~~~~~~

Update comment requests will return the status: ``HTTP/1.1 207 Multi-Status``, and an XML response similar to the example below.
In it, you can see, in the ``d:href`` element the comment which was changed.
In the ``d:status`` element, you can see if the update was successful or not.

.. code-block:: xml

   <?xml version="1.0"?>
   <d:multistatus xmlns:d="DAV:" xmlns:s="http://sabredav.org/ns" xmlns:cal="urn:ietf:params:xml:ns:caldav" xmlns:cs="http://calendarserver.org/ns/" xmlns:card="urn:ietf:params:xml:ns:carddav" xmlns:oc="http://owncloud.org/ns">
     <d:response>
       <d:href>/remote.php/dav/comments/files/4/4</d:href>
       <d:propstat>
         <d:prop>
           <oc:message/>
         </d:prop>
         <d:status>HTTP/1.1 200 OK</d:status>
       </d:propstat>
     </d:response>
   </d:multistatus>

If something goes wrong, you should receive a response similar to the following

.. code-block:: xml

    <?xml version="1.0" encoding="utf-8"?>
    <d:error xmlns:d="DAV:" xmlns:s="http://sabredav.org/ns">
      <s:exception>Sabre\DAV\Exception\BadRequest</s:exception>
      <s:message>This should never happen (famous last words)</s:message>
    </d:error>

If the tag is not available, then you will receive the following response, along with an ``HTTP/1.1 404 Not Found`` status code.

.. code-block:: xml
   
   <?xml version="1.0" encoding="utf-8"?>
   <d:error xmlns:d="DAV:" xmlns:s="http://sabredav.org/ns">
     <s:exception>Sabre\DAV\Exception\NotFound</s:exception>
     <s:message/>
   </d:error>

.. _delete_comments_label:

Delete Comments
---------------

====================================================== ========== ==============
Request Path                                           Method     Content Type
====================================================== ========== ==============
``remote.php/dav/comments/files/<fileid>/<commentid>`` ``DELETE`` ``text/plain``
====================================================== ========== ==============

To delete a comment, send an authenticated ``DELETE`` request, specifying the path to the comment that you want to delete. 

::

  curl -u username:password -X DELETE 'http://localhost/remote.php/dav/comments/files/4/5'  

If the comment was successfully deleted, no response body would be returned, but an ``HTTP/1.1 204 No Content`` status code will be returned.
However, if the comment does not exist, then the following response will be returned, along with an ``HTTP/1.1 404 Not Found`` status code.

.. code-block:: xml
   
   <?xml version="1.0" encoding="utf-8"?>
   <d:error xmlns:d="DAV:" xmlns:s="http://sabredav.org/ns">
     <s:exception>Sabre\DAV\Exception\NotFound</s:exception>
     <s:message/>
   </d:error>
   
.. Links
   
.. _relevant section of the documentation: https://doc.owncloud.com/server/latest/user_manual/files/access_webdav.html#webdav_api_retrieve_fileid
