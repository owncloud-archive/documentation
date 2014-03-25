Examples
========

Init the library
----------------

Start using the library, it is needed to init the object OCCommunication.

We recommend using the singleton method in the AppDelegate class in order to
use the ownCloud iOS library.

Code example
~~~~~~~~~~~~

.. code-block:: objective-c

  #import "OCCommunication.h"

  + (OCCommunication *)sharedOCCommunication
  {
    static OCCommunication* sharedOCCommunication = nil;

    if (sharedOCCommunication == nil)
    {
      sharedOCCommunication = [ [ OCCommunicationalloc] init ];
    }

    return sharedOCCommunication;
  }

Set credentials
---------------

Authentication on the app is possible by 3 different methods:

* Basic authentication, user name and password
* Cookie
* Token (oAuth)


Code example
~~~~~~~~~~~~


.. code-block:: objective-c

 #Basic authentication, user name and password
 [[ AppDelegate sharedOCCommunication ] setCredentialsWithUser : userName andPassword : password ];

 #Authentication with cookie
 [[ AppDelegate sharedOCCommunication ] setCredentialsWithCookie : cookie ];

 #Authentication with token
 [[ AppDelegate sharedOCCommunication ] setCredentialsOauthWithToken : token ];


Create a folder
---------------

Create a new folder on the cloud server, the info needed to be sent is the path
of the new folder.

Code example
~~~~~~~~~~~~

.. code-block:: objective-c

 [[ AppDelegate sharedOCCommunication ] createFolder :path onCommunication : [ AppDelegate sharedOCCommunication ]

 successRequest :^( NSHTTPURLResponse *response, NSString *redirectedServer) {
 //Folder Created
 }

 failureRequest :^( NSHTTPURLResponse *response, NSError *error) {

 //Failure

 switch (response.statusCode) {

 case kOCErrorServerUnauthorized :
   //Bad credentials
   break;
 case kOCErrorServerForbidden :
   //Forbidden
   break;
 case kOCErrorServerPathNotFound :
   //Not Found
   break;
 case kOCErrorServerTimeout :
   //timeout
   break;
 default:
   //default
   break;
 }

 }
 errorBeforeRequest :^( NSError *error) {
 //Error before request

 if (error.code == OCErrorForbidenCharacters) {
   //Forbidden characters
 }
 else
 {
   //Other error
 }

 }];
  
Read folder
-----------

Get the content of an existing folder on the cloud server, the info needed to
be sent is the path of the folder.  As answer of this method, it will be
received an array with all the files and folders stored in the selected folder.

Code example
~~~~~~~~~~~~

.. code-block:: objective-c

  [[ AppDelegate sharedOCCommunication] readFolder:path onCommunication:[ AppDelegate sharedOCCommunication]

  successRequest:^( NSHTTPURLResponse *response, NSArray *items, NSString *redirectedServer) {
    //Success
    for ( OCFileDto * ocFileDto in items) {
      NSLog( @"item path: %@%@" , ocFileDto.filePath, ocFileDto.fileName);
    }
  }

  failureRequest:^( NSHTTPURLResponse *response, NSError *error) {

  //Failure
  switch (response.statusCode) {
  case kOCErrorServerPathNotFound :
    //Path not found
    break;
  case kOCErrorServerUnauthorized :
    //Bad credentials
    break;
  case kOCErrorServerForbidden :
    //Forbidden
    break;
  case kOCErrorServerTimeout :
    //Timeout
    break ;
  default :
    break;
  }

  }];

Read file
---------

Get information related to a certain file or folder. Although, more information
can be obtained, the library only gets the eTag.

Other properties of the file or folder may be obtained: filePath, filename,
isDirectory, size and date

Code example
~~~~~~~~~~~~


.. code-block:: objective-c

  [[ AppDelegate sharedOCCommunication ] readFile :path onCommunication :[ AppDelegate sharedOCCommunication ]

  successRequest :^( NSHTTPURLResponse *response, NSArray *items, NSString *redirectedServer) {

  OCFileDto *ocFileDto = [items objectAtIndex : 0 ];
  NSLog ( @"item etag: %lld" , ocFileDto.  etag); }
  failureRequest :^( NSHTTPURLResponse *response, NSError *error) {
  switch (response.statusCode) {
  case kOCErrorServerPathNotFound:
    //Path not found
    break;
  case kOCErrorServerUnauthorized:
    //Bad credentials
    break;
  case kOCErrorServerForbidden:
    //Forbidden
    break;
  case kOCErrorServerTimeout:
    //Timeout
    break;
  default:
    break;
  }
  }];

Move file or folder
-------------------


Move a file or folder from their current path to a new one on the cloud server.
The info needed is the origin path and the destiny path.


Code example
~~~~~~~~~~~~

.. code-block:: objective-c

  [[ AppDelegate sharedOCCommunication ] moveFileOrFolder :sourcePath toDestiny :destinyPath onCommunication :[ AppDelegate sharedOCCommunication ]

  successRequest :^( NSHTTPURLResponse *response, NSString *redirectedServer) {
    //File/Folder moved or renamed
  }
  failureRequest :^( NSHTTPURLResponse *response, NSError *error) {
    //Failure
    switch (response.statusCode) {
    case kOCErrorServerPathNotFound:
      //Path not found
      break;
    case kOCErrorServerUnauthorized:
      //Bad credentials
      break;
    case kOCErrorServerForbidden:
      //Forbidden
      break;
    case kOCErrorServerTimeout:
      //Timeout
      break;
    default:
      break;
  }

  }
  errorBeforeRequest :^( NSError *error) {
    if (error.code == OCErrorMovingTheDestinyAndOriginAreTheSame) {
      //The destiny and the origin are the same
    }
    else if (error.code == OCErrorMovingFolderInsideHimself) {
      //Moving folder inside himself
    }
    else if (error.code == OCErrorMovingDestinyNameHaveForbiddenCharacters) {
      //Forbidden Characters
    }
    else
    {
      //Default
    }

  }];


Delete file or folder
---------------------

Delete a file or folder on the cloud server. The info needed is the path to
delete.

Code example
~~~~~~~~~~~~

.. code-block:: objective-c
  
  [[ AppDelegate sharedOCCommunication ] deleteFileOrFolder :path onCommunication :[ AppDelegate

  sharedOCCommunication ] successRequest :^( NSHTTPURLResponse *response, NSString *redirectedServer) {
    //File or Folder deleted
  }
  failureRequest :^( NSHTTPURLResponse *response, NSError *error) {

  switch (response.statusCode) {
  case kOCErrorServerPathNotFound:
  //Path not found
  break;
  case kOCErrorServerUnauthorized:
  //Bad credentials
  break;
  case kOCErrorServerForbidden:
  //Forbidden
  break;
  case kOCErrorServerTimeout:
  //Timeout
  break;
  default:
  break;
  }

  }];


Download a file
---------------

Download an existing file on the cloud server. The info needed is the server
URL, path of the file on the server and localPath, path where the file will be
stored on the device.

Code example
~~~~~~~~~~~~


.. code-block:: objective-c

  NSOperation *op = nil;
  op = [[ AppDelegate sharedOCCommunication ] downloadFile :remotePath toDestiny :localPath onCommunication :[ AppDelegate sharedOCCommunication ]

  progressDownload :^( NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {

  //Calculate percent
  float percent = ( float)totalBytesRead / totalBytesExpectedToRead;
   NSLog ( @"Percent of download: %f" , percent); }
  successRequest :^(NSHTTPURLResponse *response, NSString *redirectedServer) {
    //Download complete
  }
  failureRequest :^(NSHTTPURLResponse *response, NSError *error) {
    switch (response.  statusCode) {
    case kOCErrorServerUnauthorized:
      //Bad credentials
      break;
    case kOCErrorServerForbidden:
      //Forbidden
      break;
    case kOCErrorProxyAuth:
      //Proxy access required
      break;
    case kOCErrorServerPathNotFound:
      //Path not found
      break;
    default:
      //Default
      break;
    }
  }
  shouldExecuteAsBackgroundTaskWithExpirationHandler :^{
    [op cancel ];
  }];


Upload a file
-------------

Upload a new file to the cloud server. The info needed is localPath, path where
the file is stored on the device and server URL, path where the file will be
stored on the server.

Code example
~~~~~~~~~~~~

.. code-block:: objective-c

  NSOperation *op = nil;
  op = [[ AppDelegate sharedOCCommunication ] uploadFile :localPath toDestiny : remotePath onCommunication :[ AppDelegate sharedOCCommunication ]

  progressUpload :^( NSUInteger bytesWrote, long long totalBytesWrote, long long totalBytesExpectedToWrite) {
    //Calculate upload percent
    if ( totalBytesExpectedToRead/1024 != 0) {
      if ( bytesWrote > 0) {
       float percent = totalBytesWrote* 100 / totalBytesExpectedToRead;
        NSLog ( @"Percent: %f" , percent);
      }
    }
  }
  successRequest :^( NSHTTPURLResponse *response, NSString *redirectedServer) {
    //Upload complete
  }
  failureRequest :^( NSHTTPURLResponse *response, NSString *redirectedServer, NSError *error) {
    switch (response.  statusCode) {
    case kOCErrorServerUnauthorized :
      //Bad credentials
      break;
    case kOCErrorServerForbidden:
      //Forbidden
      break;
    case kOCErrorProxyAuth:
      //Proxy access required
      break;
    case kOCErrorServerPathNotFound:
      //Path not found
      break;
    default:
      //Default
      break;
    }
  }
  failureBeforeRequest :^( NSError *error) {
    switch (error.code) {
      case OCErrorFileToUploadDoesNotExist:
        //File does not exist
        break;
      default:
        //Default
        break;
    }
  }
  shouldExecuteAsBackgroundTaskWithExpirationHandler :^{
    [op cancel];
  }];


Check if the server supports Sharing api
----------------------------------------


The Sharing API is included in ownCloud 5.0.13 and greater versions. The info
needed is activeUser.url, the server URL that you want to check.

Code Example
~~~~~~~~~~~~

.. code-block:: objective-c

  [[ AppDelegate sharedOCCommunication ] hasServerShareSupport :_activeUser.url onCommunication :[ AppDelegate sharedOCCommunication ]

    successRequest :^( NSHTTPURLResponse *response, BOOL hasSupport, NSString *redirectedServer) {
    }
    failureRequest :^( NSHTTPURLResponse *response, NSError *error){
    }
  }];


Read shared all items by link 
-----------------------------

Get information about what files and folder are shared by link.

The info needed is Path, the server URL that you want to check.

Code example
~~~~~~~~~~~~

.. code-block:: objective-c

  [[ AppDelegate sharedOCCommunication ] readSharedByServer :path onCommunication :[ AppDelegate sharedOCCommunication ]

  successRequest :^( NSHTTPURLResponse *response, NSArray *items, NSString *redirectedServer) {
    NSLog ( @"Item: %d" , items);
  }

  failureRequest :^( NSHTTPURLResponse *response, NSError *error){
    NSLog ( @"error: %@" , error);
    NSLog ( @"Operation error: %d" , response.statusCode);
  }];


Read shared items by link of a path
------------------------------------

Get information about what files and folder are shared by link in a specific path.

The info needed is the server URL that you want to check and the specific path tha you want to check.

Code example
~~~~~~~~~~~~

.. code-block:: objective-c

  [[AppDelegate sharedOCCommunication] readSharedByServer:serverPath andPath:path onCommunication:[AppDelegate sharedOCCommunication] successRequest:^(NSHTTPURLResponse *response, NSArray *items, NSString *redirectedServer) {
            NSLog ( @"Item: %d" , items);
            
            
        } failureRequest:^(NSHTTPURLResponse *response, NSError *error) {
             NSLog ( @"error: %@" , error);
             NSLog ( @"Operation error: %d" , response.statusCode);            
  }];

Share link of file or folder
----------------------------


Share a file or a folder from your cloud server by link.
The info needed is Path, your server URL and the path of the item that you want
to share (for example ``/folder/file.pdf``)


Code example
~~~~~~~~~~~~


.. code-block:: objective-c

 [[ AppDelegate sharedOCCommunication ] shareFileOrFolderByServer :path andFileOrFolderPath :itemPath onCommunication :[ AppDelegate sharedOCCommunication ]
 successRequest :^( NSHTTPURLResponse *response, NSString *token, NSString *redirectedServer) {

 NSString *sharedLink = [ NSString stringWithFormat:@ `path/public.php?service=files&t=%@ <mailto:path/public.php?service=files&t=%25@>`_
 , token];

 }
 failureRequest :^( NSHTTPURLResponse *response, NSError *error){
   [ _delegate endLoading ];

 DLog ( @”error.code: %d” , error.  code);
 DLog (@”server.error: %d”, response.  statusCode);
 int code = response.  statusCode ;
 if (error.code == kOCErrorServerPathNotFound) {
 }

 switch (code) {
 case kOCErrorServerPathNotFound:
   //File to share not exists
   break;
 case kOCErrorServerUnauthorized:
   //Error login
   break;
 case kOCErrorServerForbidden:
   //Permission error
   break;
 case kOCErrorServerTimeout:
   //Not possible to connect to server
   break;
 default:
 if (error.code == kOCErrorServerPathNotFound) {
   //File to share not exists
 } else {
   //Not possible to connect to the server
 }
 break;

 }

 }];

 }

 NSLog ( @"error: %@" , error);
 NSLog ( @"Operation error: %d" , response.statusCode);
 }];

Unshare a folder or file by link
--------------------------------


Stop sharing by link a file or a folder from your cloud server.

The info needed is Path, your server URL and the Id of the item that you want
to Unshare.

Before unsharing an item, you have to read the shared items on the selected
server, using the method “ readSharedByServer ” so that you get the array
“items” with all the shared elements.  These are objects OCShareDto, one of
their properties is idRemoteShared, parameter needed to unshared an element.

Code example
~~~~~~~~~~~~

.. code-block:: objective-c

  [[ AppDelegate sharedOCCommunication ] unShareFileOrFolderByServer :path andIdRemoteSharedShared :sharedByLink.  idRemoteShared onCommunication :[ AppDelegate sharedOCCommunication ]

    successRequest :^( NSHTTPURLResponse *response, NSString *redirectedServer) {
      //File unshared
    }
    failureRequest :^( NSHTTPURLResponse *response, NSError *error){
      //Error
    }
  ];


Check if file of folder is shared
----------------------------------

Check if a specific file or folder is shared in your cloud server.

Teh info need is Path, your server URL and the Id of the item that you want.


Before check an item, you have to read the shared items on the selected
server, using the method “ readSharedByServer ” so that you get the array
“items” with all the shared elements.  These are objects OCShareDto, one of
their properties is idRemoteShared, parameter needed to unshared an element.

Code example
~~~~~~~~~~~~

.. code-block:: objective-c

  [[AppDelegate sharedOCCommunication] isShareFileOrFolderByServer:path andIdRemoteShared:_shareDto.idRemoteShared onCommunication:[AppDelegate sharedOCCommunication] successRequest:^(NSHTTPURLResponse *response, NSString *redirectedServer, BOOL isShared) {
       //File/Folder is shared 
        
    } failureRequest:^(NSHTTPURLResponse *response, NSError *error) {
       //File/Folder is not shared 
  }];


Tips
----

* Credentials must be set before calling any method
* Paths must not be on URL Encoding
* Correct path: ``http://www.myowncloudserver.com/owncloud/remote.php/webdav/Pop_Music/``
* Wrong path: ``http://www.myowncloudserver.com/owncloud/remote.php/webdav/Pop%20Music/``
* There are some forbidden characters to be used in folder and files names on the server, same on the ownCloud iOS library "\", "/","<",">",":",""","","?","*"
* To move a folder the origin path and the destination path must end with “/”
* To move a file the origin path and the destination path must not end with “/”
* Upload and download actions may be cancelled thanks to the object “NSOperation”
* Unit tests, before launching unit tests you have to enter your account information (server url, user and password) on OCCommunicationLibTests.m
