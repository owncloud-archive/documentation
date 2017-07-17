===============================
Create Custom Filesystem Caches
===============================

.. _custom-cache-backends:

.. sectionauthor:: Matthew Setter <msetter@owncloud.com>

The metadata cache in ownCloud can be overridden by a storage class backend which implements the following methods:

.. _storage-backend-methods:
   
+---------------------------------------------+---------------------------------------------------+
| Method                                      | Description                                       |
+=============================================+===================================================+
| ``getCache($path = '', $storage = null)``   | For overwriting the cache itself.                 |
| ``getScanner($path = '', $storage = null)`` | For overwriting the meta data scanning behavior.  |
| ``getWatcher($path = '', $storage = null)`` | For overwriting the behavior of checking for      |
|                                             | external changes.                                 |
+---------------------------------------------+---------------------------------------------------+

.. note: 
   The ``$storage`` argument should be passed to the created cache, scanner, or watcher and default to the current storage. 
   The ``$path`` argument can be used as a hint to where the cache, scanner, or watcher is going to be used.

It's unlikely that an app will need to override any of the three systems; as long as a storage backend behaves accordingly, the cache systems will work on any storage backend.

But, here are some cases where it may be practical to do so:

* **Overriding the cache:** This may be helpful in the case of shared storage. In this case, the overriding class should redirect any cache operation to the cache of the user that owns the share. 
* **Overriding the scanner:** This is useful in cases where it would provide an efficient way to retrieve the metadata of a significant number of files and folders. In doing so it avoids the need to perform a large number of round-trip requests.
* **Overriding the watcher:** This could be useful for changing the behavior for detecting changes made to a storage from outside ownCloud. 

However — in almost all cases — overriding the ``hasUpdated()`` method of a storage provides sufficient flexibility.

If any of these three systems need to be overridden, one of the following classes should be sub-classed: 

* ``\OC\Files\Cache\Cache``
* ``\OC\Files\Cache\Scanner``
* ``\OC\Files\Cache\Watcher`` 

This class should then return the subclass from one of :ref:`the three methods listed above <storage-backend-methods>`.

Cache
-----

Instead of creating a full, custom, cache object, you can also use the same wrapper pattern as when :ref:`creating custom storage backends <custom-storage-backends>`. 
Cache wrappers should be implemented by overriding the ``getCache()`` method.
In addition, it may also be useful to override the following methods:

+-----------------------------------------------------------+--------------------------------------------------------------------------------+
| Method                                                    | Description                                                                    |
+===========================================================+================================================================================+
| ``get($file)``                                            | Returns either :ref:`the cache entry <label-cache-entry>` for a file or folder |
|                                                           | or false if the file is not in the cache.                                      |
+-----------------------------------------------------------+--------------------------------------------------------------------------------+
| ``getFolderContents($path)``                              | Returns the cache entries for all files and folders in a folder                |
|                                                           | or an empty array if the folder is not in the cache.                           |
+-----------------------------------------------------------+--------------------------------------------------------------------------------+
| ``getFolderContentsById($id)``                            | Same as ``getFolderContents()``, but it uses a file id instead of a path.      |
+-----------------------------------------------------------+--------------------------------------------------------------------------------+
| ``put($file, $data)``                                     | Saves a cache entry for a file. If the file is already in the cache            |
|                                                           | then ``update()`` is called automatically.                                     |
+-----------------------------------------------------------+--------------------------------------------------------------------------------+
| ``update($id, $data)``                                    | Updates an existing cache entry. Only the changed values need to be            |
|                                                           | provided in ``$data``, any omitted values will remain unchanged.               |
+-----------------------------------------------------------+--------------------------------------------------------------------------------+
| ``getId($path)``                                          | Retrieves the file id for a file or folder. A file id is a numeric id for      |
|                                                           | a file or folder that's unique within an ownCloud instance which stays the     |
|                                                           | same for the lifetime of a file even through renaming.                         |
+-----------------------------------------------------------+--------------------------------------------------------------------------------+
| ``getParentId($path)``                                    | Retrieves the file id of the parent folder or ``=1`` if the file has no        |
|                                                           | parent, root, entry.                                                           |
+-----------------------------------------------------------+--------------------------------------------------------------------------------+
| ``inCache($file)``                                        | Checks if a file is in the cache.                                              |
+-----------------------------------------------------------+--------------------------------------------------------------------------------+
| ``remove($file)``                                         | Removes a file or folder from the cache. In the case of removing a folder,     |
|                                                           | it should remove all child entries as well.                                    |
+-----------------------------------------------------------+--------------------------------------------------------------------------------+
| ``move($source, $target)``                                | Renames a file or folder in the cache. In the case of moving a folder,         |
|                                                           | it should also move all child entries.                                         |
+-----------------------------------------------------------+--------------------------------------------------------------------------------+
| ``moveFromCache($sourceCache, $sourcePath, $targetPath)`` | Moves a file or folder from a cache instance to a local path.                  |
+-----------------------------------------------------------+--------------------------------------------------------------------------------+
| ``clear()``                                               | Removes all entries from the cache.                                            |
+-----------------------------------------------------------+--------------------------------------------------------------------------------+
| ``getStatus($file)``                                      | Retrieves the scanned status of a file or folder.                              |
+-----------------------------------------------------------+--------------------------------------------------------------------------------+
| ``search($pattern)``                                      | Searches the cache for a file or folder where the filename matches             |
|                                                           | ``$pattern``. SQL style wildcards are used in the pattern.                     |
+-----------------------------------------------------------+--------------------------------------------------------------------------------+
| ``searchByMime($mimetype)``                               | Searches for a file or folder with a matching mimetype. Both full              |
|                                                           | mimetypes ('text/plain') and mimetype groups ('text') should be                |
|                                                           | supported as search option.                                                    |
+-----------------------------------------------------------+--------------------------------------------------------------------------------+
| ``correctFolderSize($path)``                              | Recalculates the size of a folder and all parent folders.                      |
+-----------------------------------------------------------+--------------------------------------------------------------------------------+
| ``calculateFolderSize($path)``                            | Recalculates the size of a single folder.                                      |
+-----------------------------------------------------------+--------------------------------------------------------------------------------+
| ``getAll()``                                              | Retrieves the file id for all files and folder in the cache                    |
+-----------------------------------------------------------+--------------------------------------------------------------------------------+
| ``getIncomplete()``                                       | Retrieve folders which have a status of ``Cache::SHALLOW``.                    |
+-----------------------------------------------------------+--------------------------------------------------------------------------------+
| ``getPathById($id)``                                      | Retrieve the path of a file or folder whose file id matches ``$id``.           |
|                                                           | Returns null if a match is not found.                                          |
+-----------------------------------------------------------+--------------------------------------------------------------------------------+
| static ``getById($id)``                                   | Retrieves the path and storage id for a file whose file id matches ``$id``.    |
|                                                           | This is deprecated in favor of ``getPathById()``.                              |
+-----------------------------------------------------------+--------------------------------------------------------------------------------+

.. _label-cache-entry:
   
Cache Entries
~~~~~~~~~~~~~

A cache entry is an associative array that should contain, at least, the following values:

+-------------------+--------+----------------------------------------------------------------------------------+
| Method            | Type   | Description                                                                      |
+===================+========+==================================================================================+
| ``fileid``        | int    | The numeric id of a file (see ``getId()``, above).                               |
+-------------------+--------+----------------------------------------------------------------------------------+
| ``storage``       | int    | The numeric id of the storage the file is stored on.                             |
+-------------------+--------+----------------------------------------------------------------------------------+
| ``path``          | string | The path of the file within the storage (e.g., 'foo/bar.txt').                   |
+-------------------+--------+----------------------------------------------------------------------------------+
| ``name``          | string | The basename of a file or folder ('bar.txt).                                     |
+-------------------+--------+----------------------------------------------------------------------------------+
| ``mimetype``      | string | The full mimetype of the file (e.g., 'text/plain').                              |
+-------------------+--------+----------------------------------------------------------------------------------+
| ``mimepart``      | string | The mimetype group (e.g., 'text').                                               |
+-------------------+--------+----------------------------------------------------------------------------------+
| ``size``          | int    | The size of the file or folder in bytes.                                         |
+-------------------+--------+----------------------------------------------------------------------------------+
| ``mtime``         | int    | The last modified date of the file as a UNIX timestamp as shown in the UI.       |
+-------------------+--------+----------------------------------------------------------------------------------+
| ``storage_mtime`` | int    | The last modified date of the file as a UNIX timestamp as stored on the storage. |
+-------------------+--------+----------------------------------------------------------------------------------+

Note that when a file is updated ownCloud also updates the modification time of **all** parent folders.
Doing so makes it visible to the user exactly which folder has most recently been updated. 
However, ownCloud's modification time can differ from the mtime value on the underlying storage. 
But, this usually only changes when a direct child is added, removed, or renamed.

+-----------------+--------+----------------------------------------------------------------------------+
| Method          | Type   | Description                                                                |
+=================+========+============================================================================+
| ``etag``        | string | An Etag is used to detect changes to files and folders. An Etag            |
|                 |        | of a *file* changes whenever the content of the file changes.              |
|                 |        | An Etag of a *folder* changes whenever a file *in* the folder has changed. |
+-----------------+--------+----------------------------------------------------------------------------+
| ``permissions`` | int    | The permissions for the file. These are stored as a bitwise combination of |
|                 |        | ``\OCP\PERMISSION_READ``, ``\OCP\PERMISSION_CREATE``,                      |
|                 |        | ``\OCP\PERMISSION_UPDATE``, ``\OCP\PERMISSION_DELETE``,                    |
|                 |        | and ``\OCP\PERMISSION_SHARE``.                                             |
+-----------------+--------+----------------------------------------------------------------------------+

CacheWrappers
-------------

Just like storage wrappers, cache wrappers can be used to change the behavior of an existing cache. 
ownCloud comes with two cache wrappers which can be useful for applications; these are: 

* ``\OC\Files\Cache\Wrapper\CacheJail`` 
* ``\OC\Files\Cache\Wrapper\CachePermissionsMask``

These serve the same purpose as the two similarly named storage wrappers.
Implementing a cache wrapper can be done by sub-classing ``\OC\Files\Cache\CacheWrapper``. 
Inside this class, the wrapped cache will be available as ``$this->cache``.

Besides providing the options to override any method of the wrapped cache, the cache wrapper also provides the convenience method ``formatCacheEntry($entry)``.
This can be overridden to allow for easier changes to any method that returns cache entries.

Scanner
-------

It might be useful to override the following methods of the scanner:

+----------------------+------------------------------------------------------------------------------------------------+
| Method               | Description                                                                                    |
+======================+================================================================================================+
| ``getData($path)``   | Retrieves all metadata of a path to put in the cache. It returns an array which should contain |
|                      | the following keys: ``mimetype``, ``mtime``, ``size``, ``etag``,                               |
|                      | ``storage_mtime`, and ``permissions``. ``size`` should always being ``-1`` for folders.        |
+----------------------+------------------------------------------------------------------------------------------------+
| ``scanFile($file)``  | Scans a single file, or scans a folder by passing ``self::SCAN_RECURSIVE`` (or `true`)         |
|                      | as the second parameter. When scanning folders, the scanner should recurse into any            |
|                      | sub-directory and the size of any folder should be calculated correctly.                       |
|                      | If not, the scanner should only scan the direct children of the folder.                        |
|                      | Any folder that's not fully scanned should have it's size set to ``-1``.                       |
+----------------------+------------------------------------------------------------------------------------------------+
| ``backgroundScan()`` | Should do a recursive scan on all folders which have not previously been fully scanned.        |
|                      | The size should be set to ``-1``.                                                              |
+----------------------+------------------------------------------------------------------------------------------------+

Watcher
-------

The watcher is responsible for checking for outside changes made to the filesystem and updating the cache accordingly.
As noted above, in most cases overriding the ``hasUpdated()`` method of a storage backend sub-class is sufficient. 
However, the following methods could be overridden, if necessary:

+------------------------+-----------------------------------------------------------------------------------------+
| Method                 | Description                                                                             |
+========================+=========================================================================================+
| ``checkUpdate($path)`` | Checks if a file or folder has been changed externally. If so it updates the cache and  |
|                        | return ``true``, else return ``false``.                                                 |
+------------------------+-----------------------------------------------------------------------------------------+
| ``cleanFolder($path)`` | Checks a folder for any child entries that are no longer in the storage. This should be |
|                        | called automatically by ``checkUpdate()`` if that method detects an update.             |
+------------------------+-----------------------------------------------------------------------------------------+

An app or admin can also change the watcher behavior by setting it's policy by calling ``setPolicy($policy)``. 
This method can take the following values:

+---------------------------+----------------------------------------------------------------------------+
| Method                    | Description                                                                |
+===========================+============================================================================+
| ``Watcher::CHECK_NEVER``  | Don’t check for any external change. This is recommended if you're certain |
|                           | that no outside changes will be made.                                      |
+---------------------------+----------------------------------------------------------------------------+
| ``Watcher::CHECK_ONCE``   | Check each path for updates at most once during a request (default).       |
+---------------------------+----------------------------------------------------------------------------+
| ``Watcher::CHECK_ALWAYS`` | Check for external changes any number of times during a request.           |
|                           | It is mostly useful for unit tests.                                        |
+---------------------------+----------------------------------------------------------------------------+

Updater
-------

Another cache related system, which developers should be aware of when working with custom caches, is the updater. 
The updater (``\OC\Files\Cache\Updater``) is responsible for updating the cache when any change is made from inside ownCloud.
It will call either the scanner or the cache of a storage to make the required changes.
The updater **can not** be overwritten by storage backends.
