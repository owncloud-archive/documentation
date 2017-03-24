=========================
External Storage Backends
=========================

.. sectionauthor:: Vincent Petry <pvince81@owncloud.com>

This section shows how a standard app can provide external storage backends. 

To do so, requires several steps. These are:

- `Configure the filesystem type`_
- `Implement the storage class(es)`_
- `Create the backend adapter`_
- `Register the backend adapter`_
- `Test the storage backend`_

.. NOTE:: 
   To save time, however, you can learn from an existing example, by reading
   through the source code of the `FTP external storage app
   <https://github.com/owncloud/files_external_ftp>`_.

Configure the filesystem type
=============================

First, the :file:`/appinfo/info.xml` must be adjusted to specify the ``type`` as:
``filesystem``. For example:

.. literalinclude:: ../examples/storage-backend/appinfo/info.xml
     :language: xml
     :linenos:

Implement the storage class(es)
===============================

Next, you need to create a storage class. Usually, you should implement the
interface ``\\OCP\\Files\\Storage\\IStorage``. But, the easiest way is to
directly extend ``\\OCP\\Files\\Storage\\StorageAdapter``, as it already
provides an implementation for many of the commonly required methods.

Here’s an example of how you would create one that implements all the
filesystem operations required by ownCloud, using a fictitious library called
``FakeStorageLib``.

.. literalinclude:: ../examples/storage-backend/OCA/MyStorageApp/Storage/MyStorage.php
     :language: php

For this example we mapped the available storage methods to the ones from the
library. Note that, in many cases, the underlying library might not support some
operations and might need extra code to work this around.

When extending StorageAdapter, it is good practice to implement the following
methods, for performance reasons: 

- file_exists
- filetype
- fopen
- getId
- mkdir
- opendir
- rmdir
- stat
- touch
- unlink

If you don’t, your storage backend will still work. But, it will likely not
perform as well as it could. In the case of the ``rename`` method, this is
because it uses a combination of a stream copy plus a delete for renaming
a file.

Stat/metadata cache
-------------------

To create a mature implementation, we need to consider stat and metadata
caching. Within a single PHP request, ownCloud might call the same storage
methods repeatedly, due to different checks which it needs to carry out. As
a result, there is the potential to incur significant overhead, when working
with the underlying filesystem. 

To avoid — or at the very least *reduce* this — a stat/metadata cache should be
implemented, if the underlying library does not support stat/metadata caching.
To do this, the metadata of any folder entries which are read should be cached
in a local array and returned by the storage class’ methods.

Writing a Flysystem adapter
---------------------------

Instead of writing everything by hand, it is also possible to write an ownCloud
adapter based on a `Flysystem adapter`_, as external storage. You can see how it
was done in the `FTP storage adapter`_.

Create the backend adapter
==========================

After implementing the storage class, a backend adapter needs to be created. To
do that, create a class that extends from ``\\OCP\\Files\\External\\Backend``:

.. literalinclude:: ../examples/storage-backend/OCA/MyStorageApp/Backend/MyStorageBackend.php
     :language: php

Definition parameters
---------------------

Flags:
^^^^^^

======================================= =======================
Flag                                    Description
======================================= =======================
**DefinitionParameter::FLAG_NONE**      No flags (default)
**DefinitionParameter::FLAG_OPTIONAL**  For optional parameters
======================================= =======================

Types:
^^^^^^

======================================= =======================================
Type                                    Description
======================================= =======================================
**DefinitionParameter::VALUE_TEXT**     Text field (default)
**DefinitionParameter::VALUE_PASSWORD** Masked text field, for passwords and 
                                        keys
**DefinitionParameter::VALUE_BOOLEAN**  Boolean / checkbox
**DefinitionParameter::VALUE_HIDDEN**   Hidden field, useful with custom 
                                        scripts
======================================= =======================================

Authentication schemes
----------------------

Several authentication schemes can be specified.

======================================= =======================================
Scheme                                  Description
======================================= =======================================
**AuthMechanism::SCHEME_NULL**          No authentication supported
**AuthMechanism::SCHEME_BUILTIN**       Authentication is provided through 
                                        definition parameters
**AuthMechanism::SCHEME_PASSWORD**      Support for password-based auth, 
                                        provides two fields "user" and 
                                        "password" to the parameter list
**AuthMechanism::SCHEME_OAUTH1**        OAuth1, provides fields "app_key", 
                                        "app_secret", "token", "token_secret" 
                                        and "configured"
**AuthMechanism::SCHEME_OAUTH2**        OAuth2, provides fields "client_id", 
                                        "client_secret", "token" and "configured"
**AuthMechanism::SCHEME_PUBLICKEY**     Public key, provides fields "user", 
                                        "public_key", "private_key"
======================================= =======================================

Custom user interface
---------------------

When dealing with complex field values or workflows like `OAuth`_, an
application might need to provide custom JavaScript code to implement such
workflow. To add a custom script, use the following in the backend constructor:

.. code-block:: php

  $this->addCustomJs('script');

This will automatically load the script :file:`/js/script.js` from the app
folder. The script itself will need to inject events into the external storage
GUI as there is currently no proper public API to do so.

Register the backend adapter
============================

With the backend adapter created, it next needs to be registered. This can be
done in the ``Application`` class by implementing the ``IBackendProvider``
interface, as in the example below:

.. code-block:: php

  :include: examples/storage-backend/OCA/MyStorageApp/AppInfo/Application.php

Then in :file:`appinfo/app.php` instantiate the ``Application`` class:

.. code-block:: php

  <?php

    $app = new \OCA\MyStorageApp\AppInfo\Application();

Test the storage backend
========================

Once the steps above are done, you should be able to mount the storage in the
external storage section.

.. Links
   
.. _Flysystem adapter: https://flysystem.thephpleague.com/creating-an-adapter/
.. _FTP storage adapter: https://github.com/owncloud/files_external_ftp/blob/master/lib/Storage/FTP.php#L27
.. _OAuth: https://en.wikipedia.org/wiki/OAuth

