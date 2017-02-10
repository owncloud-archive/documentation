===============================
Create Custom Filesystem Caches
===============================

.. sectionauthor:: Matthew Setter <msetter@owncloud.com>

The metadata cache in ownCloud can be overwritten by a storage class backend which implements the following methods:

+---------------------------------------------+---------------------------------------------------+
| Method                                      | Description                                       |
+=============================================+===================================================+
| ``getCache($path = '', $storage = null)``   | For overwriting the cache itself.                 |
| ``getScanner($path = '', $storage = null)`` | For overwriting the meta data scanning behavior.  |
| ``getWatcher($path = '', $storage = null)`` | For overwriting the behavior of checking for      |
|                                             | external changes.                                 |
+---------------------------------------------+---------------------------------------------------+

.. note: 
   The ``$storage`` argument should be passed to the created cache, scanner, or watcher and default to the current storage. The ``$path`` argument can be used as a hint to where the cache, scanner, or watcher is going to be used for.

It's unlikely that an app will need to overwrite any of the three systems. 
As long as a storage backend behaves accordingly the cache systems will work on any storage backend.

An example where the storage backend should overwrite the cache is shared storage.
This redirects any cache operation to the cache of the user that owns the share. 
But, cases like this are rare.

Overwriting the scanner is useful, mostly, in cases where it would provide an efficient way to retrieve the metadata of a large amount of files and folders, and in so doing avoiding the need to perform a large amount of round-trips.

Overwriting the watcher could be useful for changing the behavior regarding detecting changes made to a storage from outside ownCloud. 
However, in almost all cases, overriding the ``hasUpdated`` method of a storage provides sufficient flexibility.

If any of these three systems should be changed an app should subclass one of: ``\OC\Files\Cache\Cache``, ``\OC\Files\Cache\Scanner`` or ``\OC\Files\Cache\Watcher``.
This class should then return the subclass from one of the three methods listed above.

Cache
-----

Instead of creating a full custom cache object, you can also use the same wrapper pattern as with storage backends. 
Cache wrappers should be implemented by overriding the ``getCache()`` method.
In addition, it can be useful to override the following methods:

+------------------------------------------------------------+------------------------------------------------------------------+
| Method                                                     | Description                                                      |
+============================================================+==================================================================+
| ``get($file)``                                             | Return the cache entry for a file or folder or false if the file |
|                                                            | is no in the cache.                                              |
+------------------------------------------------------------+------------------------------------------------------------------+
| ``getFolderContents($path)``                               | Return the cache entries for all files and folders in a folder   |
|                                                            | or an empty array if the folder is not                           |
|                                                            | in the cache.                                                    |
+------------------------------------------------------------+------------------------------------------------------------------+
| ``getFolderContentsById($id)``                             | Same as ``getFolderContents`` but using a file id                |
|                                                            | instead of a path.                                               |
+------------------------------------------------------------+------------------------------------------------------------------+
| ``put($file, $data)``                                      | Save a cache entry for a file, if the file is                    |
|                                                            | already in the cache ``update`` is called automatically.         |
+------------------------------------------------------------+------------------------------------------------------------------+
| ``update($id, $data)``                                     | Update an existing cache entry, only changed values              |
|                                                            | need to be provided in $data, any value that's omitted           |
|                                                            | will remain unchanged.                                           |
+------------------------------------------------------------+------------------------------------------------------------------+
| ``getId($path)``                                           | Get the file id for a file or folder,  A file id is a            |
|                                                            | numeric id for a file or folder that's unique within             |
|                                                            | an ownCloud instance which stays the same for the                |
|                                                            | lifetime of a file even trough renaming.                         |
+------------------------------------------------------------+------------------------------------------------------------------+
| ``getParentId($path)``                                     | Get the file id of the parent folder or =1 if the file           |
|                                                            | has no parent (root entry).                                      |
+------------------------------------------------------------+------------------------------------------------------------------+
| ``inCache($file)``                                         | Check if a file is in the cache.                                 |
+------------------------------------------------------------+------------------------------------------------------------------+
| ``remove($file)``                                          | Remove a file or folder from the cache, should remove            |
|                                                            | all child entries in case of removing a folder.                  |
+------------------------------------------------------------+------------------------------------------------------------------+
| ``move($source, $target)``                                 | Rename a file or folder in the cache, should move all            |
|                                                            | child entries in case of moving a folder.                        |
+------------------------------------------------------------+------------------------------------------------------------------+
| ``moveFromFolder($sourceCache, $sourcePath, $targetPath)`` | Move a file or folder from a different cache instance.           |
+------------------------------------------------------------+------------------------------------------------------------------+
| ``clear()``                                                | Remove all entries from the cache.                               |
+------------------------------------------------------------+------------------------------------------------------------------+
| ``getStatus($file)``                                       | Get the scanned status of a file or folder.                      |
+------------------------------------------------------------+------------------------------------------------------------------+
| ``search($pattern)``                                       | Search the cache for a file or folder where the filename matches |
|                                                            | ``$pattern``, SQL style wildcards are used in the pattern.       |
+------------------------------------------------------------+------------------------------------------------------------------+
| ``searchByMime($mimetype)``                                | Search a file or folder with a matching mimetype, both full      |
|                                                            | mimetypes ('text/plain') and mimetype groups ('text') should be  |
|                                                            | supported as search option.                                      |
+------------------------------------------------------------+------------------------------------------------------------------+
| ``correctFolderSize($path)``                               | Recalculate the size of a folder and all parent folders.         |
+------------------------------------------------------------+------------------------------------------------------------------+
| ``calculateFolderSize($path)``                             | recalculate the size of a single folder.                         |
+------------------------------------------------------------+------------------------------------------------------------------+
| ``getAll()``                                               | Get the file id for all files and folder in the cache            |
+------------------------------------------------------------+------------------------------------------------------------------+
| ``getIncomplete()``                                        | Get one folder which a status of ``Cache::SHALLOW``.             |
+------------------------------------------------------------+------------------------------------------------------------------+
| ``getPathById($id)``                                       | Get the path of a file or folder by fileId or null if not found. |
+------------------------------------------------------------+------------------------------------------------------------------+
| static ``getById($id)``                                    | Get the path and storage id for a file id, deprecated in favor   |
|                                                            | of ``getPathById``.                                              |
+------------------------------------------------------------+------------------------------------------------------------------+

A cache entry is an associative array that should contain at least the following values:

+-------------------+--------+--------------------------------------------------------------------------------+
| Method            | Type   | Description                                                                    |
+===================+========+================================================================================+
| ``fileid``        | int    | The numeric id of a file (see getId).                                          |
+-------------------+--------+--------------------------------------------------------------------------------+
| ``storage``       | int    | The numeric id of the storage the file is stored on.                           |
+-------------------+--------+--------------------------------------------------------------------------------+
| ``path``          | string | The path of the file within the storage (e.g., 'foo/bar.txt').                 |
+-------------------+--------+--------------------------------------------------------------------------------+
| ``name``          | string | The basename of a file ('bar.txt).                                             |
+-------------------+--------+--------------------------------------------------------------------------------+
| ``mimetype``      | string | The full mimetype of the file (e.g., 'text/plain').                            |
+-------------------+--------+--------------------------------------------------------------------------------+
| ``mimepart``      | string | The first half of the mimetype (e.g., 'text').                                 |
+-------------------+--------+--------------------------------------------------------------------------------+
| ``size``          | int    | The size of the file or folder in bytes.                                       |
+-------------------+--------+--------------------------------------------------------------------------------+
| ``mtime``         | int    | The last modified date of the file as UNIX timestamp as shown in the UI.       |
+-------------------+--------+--------------------------------------------------------------------------------+
| ``storage_mtime`` | int    | The last modified date of the file as UNIX timestamp as stored on the storage. |
+-------------------+--------+--------------------------------------------------------------------------------+

Note that when a file is updated ownCloud also updates the modification time of all parent folders.
This makes it visible to the user exactly which folder has most recently been updated. 
However, this can differ from the mtime on the underlying storage. 
This usually only changes when a direct child is added, removed, or renamed.

+-----------------+--------+--------------------------------------------------------------------------+
| Method          | Type   | Description                                                              |
+=================+========+==========================================================================+
| ``etag``        | string | An Etag is used to detect changes to files and folders. An Etag          |
|                 |        | of a file changes whenever the content of the file changes.              |
|                 |        | An Etag of a folder changes whenever a file *in* the folder has changed. |
+-----------------+--------+--------------------------------------------------------------------------+
| ``permissions`` | int    | The permissions for the file stored a s bitwise combination of           |
|                 |        | ``\OCP\PERMISSION_READ``, ``\OCP\PERMISSION_CREATE``,                    |
|                 |        | ``\OCP\PERMISSION_UPDATE``, ``\OCP\PERMISSION_DELETE``,                  |
|                 |        | and ``\OCP\PERMISSION_SHARE``.                                           |
+-----------------+--------+--------------------------------------------------------------------------+

CacheWrappers
-------------

Just like storage wrappers, cache wrappers can be used to change the behavior of an existing cache. 
ownCloud comes with two cache wrappers which can be useful for apps; these are: ``\OC\Files\Cache\Wrapper\CacheJail`` and ``\OC\Files\Cache\Wrapper\CachePermissionsMask``.
These serve the same purpose as the two similarly named storage wrappers.

Implementing a cache wrapper can be done by sub-classing ``\OC\Files\Cache\CacheWrapper``. 
Inside this class, the wrapped cache will be available as ``$this->cache``.
Besides providing the options to overwrite any method of the wrapped cache, the cache wrapper also provides the convenience method ``formatCacheEntry($entry)``.
This can be overridden to allow for easier changes to any method that return cache entries.

Scanner
-------

It might be useful to override the following methods of the scanner:

+----------------------+--------------------------------------------------------------------------------------------------+
| Method               | Description                                                                                      |
+======================+==================================================================================================+
| ``getData($path)``   | Get all metadata of a path to put in the cache. This is an array which should contain            |
|                      | the following keys: ``mimetype``, ```mtime``, ```size``, ```etag``,                              |
|                      | ```storage_mtime`, and ``permissions``. ``size`` should always being ``-1`` for folders.         |
+----------------------+--------------------------------------------------------------------------------------------------+
| ``scanFile($file)``  | Scan a single file, or scan a folder by passing ``self::SCAN_RECURSIVE`` or `true` as the second |
|                      | parameter. When scanning folders, the scanner should                                             |
|                      | recursive into any sub-directory and the size of any folder should be calculated                 |
|                      | correctly. If not, the scanner should only scan the direct children of the folder.               |
|                      | Any folder that's not fully scanned should have it's size set to -1.                             |
+----------------------+--------------------------------------------------------------------------------------------------+
| ``backgroundScan()`` | Should do a recursive scan on all folder which have not been previously been                     |
|                      | scanned fully. The size should be set to -1.                                                     |
+----------------------+--------------------------------------------------------------------------------------------------+

Watcher
-------

The watcher is responsible for checking for outside changes made to the filesystem and updating the cache accordingly.
As noted above, in most cases overriding the ``hasUpdated()`` method of a storage backend sub-class is sufficient. 
However, the following methods could be overwritten, if needed:

+------------------------+----------------------------------------------------------------------------------------+
| Method                 | Description                                                                            |
+========================+========================================================================================+
| ``checkUpdate($path)`` | Check if a file or folder has been changed externally, if so update the cache and      |
|                        | return ``true``, else return ``false``.                                                |
+------------------------+----------------------------------------------------------------------------------------+
| ``cleanFolder($path)`` | Check a folder for any child entries that are no longer in the storage. This should be |
|                        | called automatically by ``checkUpdate()``, if that method detects an update.           |
+------------------------+----------------------------------------------------------------------------------------+

.. note:: 
   An app or admin can also change the watcher behavior by setting it's policy by calling ``setPolicy($policy)``. 
   This method can take the following values:

+---------------------------+-------------------------------------------------------------------------------+
| Method                    | Description                                                                   |
+===========================+===============================================================================+
| ``Watcher::CHECK_NEVER``  | Don’t check for any external change (recommended if you're certain no outside |
|                           | changes will be made).                                                        |
+---------------------------+-------------------------------------------------------------------------------+
| ``Watcher::CHECK_ONCE``   | Check each path for updates at most once during a request (default).          |
+---------------------------+-------------------------------------------------------------------------------+
| ``Watcher::CHECK_ALWAYS`` | Check for external changes any number of times during a request.              |
|                           | It is mostly useful for unit tests.                                           |
+---------------------------+-------------------------------------------------------------------------------+

Updater
-------

Another cache related system, which developers should be aware of when working with custom caches, is the updater. 
The updater (``\OC\Files\Cache\Updater``) is responsible for updating the cache when any change is mode from inside ownCloud.
It will call either the scanner or the cache of a storage to make the required changes.
The updater can **not** be overwritten by storage backends.

+------------------------+----------------------------------------------------------------------------------------------+
| Method                 | Description                                                                                  |
+========================+==============================================================================================+
| ``checkUpdate($path)`` | Checks if a file or folder has been changed externally. If it has, then update the cache and |
|                        | return ``true``. Otherwise, it returns ``false``.                                            |
+------------------------+----------------------------------------------------------------------------------------------+
| ``cleanFolder($path)`` | Checks a folder for any child entries that are no longer in the storage. It should be        |
|                        | called automatically by ``checkUpdate`` if that method detects an update.                    |
+------------------------+----------------------------------------------------------------------------------------------+

An app or an administrator can also change the watcher behavior, by setting it's policy through ``setPolicy($policy)``. 
This method can take the following values:

+---------------------------+-------------------------------------------------------------------------------+
| Method                    | Description                                                                   |
+===========================+===============================================================================+
| ``Watcher::CHECK_NEVER``  | Don’t check for any external change (recommended if you're certain no outside |
|                           | changes will be made).                                                        |
+---------------------------+-------------------------------------------------------------------------------+
| ``Watcher::CHECK_ONCE``   | Check each path for updates at most once during a request (default).          |
+---------------------------+-------------------------------------------------------------------------------+
| ``Watcher::CHECK_ALWAYS`` | Check for external changes any number of times during a request, discouraged, |
|                           | mostly useful for unit tests.                                                 |
+---------------------------+-------------------------------------------------------------------------------+
