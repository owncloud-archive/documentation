==============================
Create Custom Storage Backends
==============================

.. _custom-storage-backends:

.. sectionauthor:: Matthew Setter <msetter@owncloud.com>

The preferred way for applications to create new storage backends is to create a subclass of ``\OC\Files\Storage\Common`` and implement the abstract methods.
It's also possible to create storage backends by implementing the required interface.

However, by sub-classing the common backend a lot of the boiler plate is taken care of.
What's more, it provides common implementations and fallbacks to reduce the amount of work it is to create a storage backend.

Required Methods
----------------

All storage backends sub-classing the common storage backend must implement the
following methods:

+---------------------------------+-------------------------------------------------------------+
| Method                          |  Description                                                |
+=================================+=============================================================+
| ``mkdir($path)``                | Creates a new folder on the storage.                        |
+---------------------------------+-------------------------------------------------------------+
| ``rmdir($path)``                | Deletes an existing folder on the storage.                  |
+---------------------------------+-------------------------------------------------------------+
| ``opendir($path)``              | Opens a directory handle.                                   |
+---------------------------------+-------------------------------------------------------------+
| ``stat($path)``                 | Retrieves the metadata for the file or folder. The returned |
|                                 | array should, at least, contain ``mtime`` and ``size``.     |
+---------------------------------+-------------------------------------------------------------+
| ``filetype($path)``             | Returns the file type; either ``file`` or ``dir``.          |
+---------------------------------+-------------------------------------------------------------+
| ``file_exists($path)``          | Checks if a file or folder exists.                          |
+---------------------------------+-------------------------------------------------------------+
| ``unlink($path)``               | Removes a file or folder. This isn't only for               |
|                                 | deleting files, unlike PHP's unlink method.                 |
+---------------------------------+-------------------------------------------------------------+
| ``fopen($path, $mode)``         | Opens a file handle for a file                              |
+---------------------------------+-------------------------------------------------------------+
| ``touch($path, $mtime = null)`` | Updates the mtime of a file or folder. If ``$mtime``        |
|                                 | is omitted the current time should be used.                 |
+---------------------------------+-------------------------------------------------------------+

Suggested Methods
-----------------

The common storage backends provide fallback implementations for a number of methods to make them easier to implement.
However, some of fallback implementations are either inefficient or don't always provide the correct result for custom storage backends.
Given that, please consider overriding one or more of the following methods:

+--------------------------------------+--------------------------------------------------------------+
| Method                               |  Description                                                 |
+======================================+==============================================================+
| ``rename($sourcePath, $targetPath)`` | Renames a file. The default implementation uses ``copy``     |
|                                      | and ``unlink`` which is very inefficient.                    |
+--------------------------------------+--------------------------------------------------------------+
| ``copy($sourcePath, $targetPath)``   | Copies a file. The default implementation copies using       |
|                                      | streams. This is inefficient for remote storages as it       |
|                                      | downloads and re-uploads the file.                           |
+--------------------------------------+--------------------------------------------------------------+
| ``isReadable($path)``                | Checks if a file is readable. It defaults to ``true`` if the |
|                                      | file exists.                                                 |
+--------------------------------------+--------------------------------------------------------------+
| ``isUpdatable($path)``               | Checks if a file or folder can be updated. This              |
|                                      | includes being written to or renamed. It defaults to         |
|                                      | ``true`` if the file exists.                                 |
+--------------------------------------+--------------------------------------------------------------+
| ``isCreatable($path)``               | Checks if new files can be created in a folder               |
|                                      | It defaults to ``isUpdatable($path)``.                       |
+--------------------------------------+--------------------------------------------------------------+
| ``isDeletable($path)``               | Checks if a file can be deleted. It defaults to              |
|                                      | ``isUpdatable($path)``.                                      |
+--------------------------------------+--------------------------------------------------------------+
| ``isSharable($path)``                | Checks if a file can be shared. It defaults to               |
|                                      | ``isReadable($path)``.                                       |
+--------------------------------------+--------------------------------------------------------------+
| ``free_space($path)``                | Checks the free space on the storage in bits.                |
+--------------------------------------+--------------------------------------------------------------+

Other Useful Methods
---------------------

The default implementation for the following methods are good for most storage backends.
But, providing an alternate implementation *can* improve user experience.

+-------------------------------------+---------------------------------------------------------+
| Method                              | Description                                             |
+=====================================+=========================================================+
| ``file_put_contents($path, $data)`` | Stores a file on the storage. It defaults to using      |
|                                     | ``fopen($path, 'w')``.                                  |
+-------------------------------------+---------------------------------------------------------+
| ``file_get_contents($path)``        | Retrieves a file from storage. Defaults to using        |
|                                     | ``fopen($path, 'r')``.                                  |
+-------------------------------------+---------------------------------------------------------+
| ``getMimeType($path)``              | Retrieves the mimetype of a file or folder. Defaults to |
|                                     | guessing the mimetype from the extension. The           |
|                                     | mimetype of a folder is _required_ to be                |
|                                     | ``'httpd/unix-directory'``.                             |
+-------------------------------------+---------------------------------------------------------+
| ``hasUpdated($path, $time)``        | Checks if a file or folder has been updated since       |
|                                     | ``$time``. If you're certain the files on the           |
|                                     | storage will not be updated outside of ownCloud you     |
|                                     | can always return ``false`` to increase performance.    |
+-------------------------------------+---------------------------------------------------------+
| ``getETag($path)``                  | Retrieves the `Etag`_ for a file or folder.             |
+-------------------------------------+---------------------------------------------------------+
| ``verifyPath($path, $fileName)``    | Checks if a filename is valid for the storage           |
|                                     | backend. It defaults to checking for invalid            |
|                                     | characters or names for the server                      |
|                                     | platform.                                               |
+-------------------------------------+---------------------------------------------------------+

Copying and Moving Between Storage Backends
-------------------------------------------

When copying or moving files between different storages a stream copy is used by default.
This works well for copying between different types of storages, such as from local to SMB.
But, there are cases where a more efficient copy is possible, such as between two SMB storages on the same server.
In these cases, storage backends can override the cross-storage behavior by overriding the following methods:

- ``copyFromStorage(\OCP\Files\Storage $sourceStorage, $sourceInternalPath, $targetInternalPath, $preserveMtime = false);``
- ``moveFromStorage(\OCP\Files\Storage $sourceStorage, $sourceInternalPath ,$targetInternalPath);``

Working With Streams
--------------------

Both ``fopen()`` and ``opendir()`` require storage backends to return native PHP streams for maximum compatibility. 
ownCloud comes with several classes which make it easier for storage backends to create native PHP streams for backends not supported by PHP's own `streamWrapper`_.

IteratorDirectory
~~~~~~~~~~~~~~~~~

``Icewind\Streams\IteratorDirectory`` allows for creating a directory handle from an array or iterator.

.. code-block:: php

  $fileNames = $this->getFolderContentsSomehow();
  return IteratorDirectory::wrap($fileNames);

CallbackWrapper
~~~~~~~~~~~~~~~

``Icewind\Streams\CallbackWrapper`` wraps an existing file handle, and allows for hooking into file reads and writes, and closing streams. 
The most common use case for this class in storage backends is for implementing ``fopen()`` with writable streams. 
This is because writing to and closing streams happens outside the storage implementation.
As a result, the storage backend needs a way to upload the changed file back to the backend. 
This can be done by attaching a close-callback to a stream for a temporary file.

.. code-block:: php

  $tempFile = $this->downloadFile($path);
  $handle = fopen($tempFile, $mode);
  return CallBackWrapper::wrap($handle, null, null function() use ($path, $tempFile) {
      $this->uploadFile($tempFile, $path);
      unlink($tempFile);
  }

Storage Wrappers
----------------

Besides implementing a complete custom storage backend, ownCloud allows for modifying the behavior of an existing storage by applying a wrapper to it.
Storage wrappers need to implement the full storage API methods. 
Examples of storage wrappers are

* **The Quota wrapper.** This changes the behavior of `free_space` by limiting the free space returned by the wrapped storage to a configured maximum 
* **The Encryption wrapper**. This encrypts and decrypts the data on the fly by overwriting ``file_put_contents``, ``file_get_contents``, and ``fopen``.

When implementing a storage wrapper, the wrapped storage is available as ``$this->storage``.
Storage wrappers can either be applied globally to all used storages using ``\OC\Files\Filesystem::addStorageWrapper($name, $wrapper)`` or to a specific storage, while mounting the storage from the app.
Implementing a storage wrapper is done by sub-classing ``\OC\Files\Storage\Wrapper\Wrapper`` and overwriting any of its methods.

Global Storage Wrappers
~~~~~~~~~~~~~~~~~~~~~~~

For using a storage wrapper globally, you provide a callback which will be called for each used storage. 
The callback can than determine if a wrapper should be applied to the given storage, based on the storage or mountpoint, or whether it needs to return the storage unwrapped.

.. code-block:: php

  Filesystem::addStorageWrapper('fooWrapper', function($mountPoint, $storage) {
      if ($storage->instanceOfStorage('FooStorage')) {
          return new FooWrapper(['storage' => $storage]);
      } else {
          return $storage;
      }
  }

Wrappers for a Single Storage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Sometimes an app can avoid having to create a custom storage backend by instead modifying the behavior of an existing one. 
ownCloud comes with a few generic storage wrappers which might be useful when doing so, which include ``PermissionsMask`` and ``Jail``.

PermissionsMask
^^^^^^^^^^^^^^^

``\OC\Files\Storage\Wrapper\PermissionsMask`` can be used to restrict the permissions on an existing storage.
A sample use case is to create a read-only ftp backend.

.. code-block:: php

  $storage = $this->createStorageToWrapSomehow();
  return new PermissionsMask([
     'storage' => $storage, 
     'mask' => \OCP\Constant::PERMISSION_READ | \OCP\Constant::PERMISSION_SHARE
  ]);

Jail
^^^^

``\OC\Files\Storage\Wrapper\Jail`` can be used to limit storage interaction to a sub-folder of an existing storage.

.. code-block:: php

  $storage = $this->createStorageToWrapSomehow();
  return new Jail([
     'storage' => $storage, 
     'root' => 'some/folder/in/the/storage'
  ]);

A Note on instanceof()
~~~~~~~~~~~~~~~~~~~~~~

Since storage wrappers wrap an existing storage instead of sub-classing it, it is not possible to determine if the storage is a specific class using PHP's ``instanceof`` operator.
Instead, you need to call the ``instanceOfStorage()`` method on the class with the fully-qualified class name.

.. code-block:: php

  // Only works if no wrappers are applied
  if ($storage instanceof \OC\Files\Storage\DAV) {
      // ...
  }

  // Works regardless of any wrapper
  if ($storage->instanceOfStorage('\OC\Files\Storage\DAV')) {
      // ...
  }

``instanceOfStorage()`` can also be used to check if a certain wrapper is applied to a storage.

Mounting Storages
-----------------

For an app to add its storages to the filesystem it should implement a mount provider and register it with the filesystem.
Implementing mount providers is done by implementing the ``\OCP\Files\Config\IMountProvider`` interface, containing the ``getMountsForUser(IUser $user, IStorageFactory $storageFactory)`` method, which returns a list of mountpoints that should be created for a user.

.. code-block:: php

  class MyMountProvider implements IMountProvider {
      public function getMountsForUser(IUser $user, IStorageFactory $loader) {
          $config = magicallyGetMountConfigurations();
          return array_map(function($mountOptions) use ($loader) {
              return new Mount(
                  $mountOptions['class'], 
                  $mountOptions['mountPoint'], 
                  $mountOptions['storageOptions'], 
                  $loader
              );
          }, $config);
      }
  }


Registering a mount provider should be done from an app's ``appinfo/app.php``. 
Note that any mount provider registered after the filesystem is setup for a user will not be called again for that user.

.. code-block:: php

  $provider = new MyMountProvider();
  \OC::$server->getMountProviderCollection()
              ->registerProvider($provider);

.. Links

.. _streamWrapper: https://secure.php.net/manual/en/class.streamwrapper.php
.. _Etag: https://en.wikipedia.org/wiki/HTTP_ETag
