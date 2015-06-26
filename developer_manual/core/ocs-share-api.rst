OCS Share API
=============

The OCS Share API allows you to access the sharing API from outside over
pre-defined OCS calls.

The base URL for all calls to the share API is: *<owncloud_base_url>/ocs/v1.php/apps/files_sharing/api/v1*


Get All Shares
--------------

Get all shares from the user.

* Syntax: /shares
* Method: GET

* Result: XML with all shares

Statuscodes:

* 100 - successful
* 404 - couldn't fetch shares

Returns:

* A list of shares (see share_return_)

Get Shares from a specific file or folder
-----------------------------------------

Get all shares from a given file/folder.

* Syntax: /shares
* Method: GET

* URL Arguments: path - (string) path to file/folder
* URL Arguments: reshares - (boolean) returns not only the shares from the current user but all shares from the given file.
* URL Arguments: subfiles - (boolean) returns all shares within a folder, given that
  *path* defines a folder
* Mandatory fields: path

* Result: XML with the shares

Statuscodes

* 100 - successful
* 400 - not a directory (if the 'subfile' argument was used)
* 404 - file doesn't exist

Returns:

* A list of shares (see share_return_)


Get information about a known Share
-----------------------------------

Get information about a given share.

* Syntax: /shares/*<share_id>*
* Method: GET

* Arguments: share_id - (int) share ID

* Result: XML with the share information

Statuscodes:

* 100 - successful
* 404 - share doesn't exist

.. _share_return:

Returns:

* id
* item_type
* item_source
* parent
* share_type
* share_with
* file_source
* file_target
* path
* permissions
* stime
* expiration
* token
* storage
* mail_send
* uid_owner
* storage_id
* share_with_displayname
* displayname_owner



Create a new Share
------------------

Share a file/folder with a user/group or as public link.

* Syntax: /shares
* Method: POST

* POST Arguments: path - (string) path to the file/folder which should be shared
* POST Arguments: shareType - (int) '0' = user; '1' = group; '3' = public link
* POST Arguments: shareWith - (string) user / group id with which the file should be shared
* POST Arguments: publicUpload - (boolean) allow public upload to a public shared folder (true/false)
* POST Arguments: password - (string) password to protect public link Share with
* POST Arguments: permissions - (int) 1 = read; 2 = update; 4 = create; 8 = delete;
  16 = share; 31 = all (default: 31, for public shares: 1)
* Mandatory fields: shareType, path and shareWith for shareType 0 or 1.

* Result: XML containing the share ID (int) of the newly created share

Statuscodes:

* 100 - successful
* 400 - unknown share type
* 403 - public upload was disabled by the admin
* 404 - file couldn't be shared

Returns:

* id
* url (only for public shares)
* token (only for public shares)

Delete Share
------------

Remove the given share.

* Syntax: /shares/*<share_id>*
* Method: DELETE

* Arguments: share_id - (int) share ID

Statuscodes:

* 100 - successful
* 404 - file couldn't be deleted

Returns:

    Nothing is returned since the share is deleted.

Update Share
------------

Update a given share. Only one value can be updated per request.

* Syntax: /shares/*<share_id>*
* Method: PUT

* Arguments: share_id - (int) share ID
* PUT Arguments: permissions - (int) update permissions (see "Create share"
  above)
* PUT Arguments: password - (string) updated password for public link Share
* PUT Arguments: publicUpload - (boolean) enable (true) /disable (false) public
  upload for public shares.
* PUT Arguments: expireDate - (string) set a expire date for public link
  shares. This argument expects a well formated date string, e.g. 'YYYY-MM-DD'

.. note:: Only one of the update parameters can be specified at once.

Statuscodes:

* 100 - successful
* 400 - wrong or no update parameter given
* 403 - public upload disabled by the admin
* 404 - couldn't update share

Returns:

    Nothing is returned
