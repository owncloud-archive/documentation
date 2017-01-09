=========================
External storage backends
=========================

.. sectionauthor:: Vincent Petry <pvince81@owncloud.com>

Have a look at the source code of the `FTP external storage app
<https://github.com/owncloud/files_external_ftp>`_ for a good example.

The following sections will indicate what modifications need to be done in
a standard app to make it a provider of external storage backends.

Filesystem type
===============

The :file:`/appinfo/info.xml` must be adjusted to specify **filesystem** as type:

.. code-block:: xml

.. include:: examples/storage-backend/appinfo/info.xml

Implementing the storage
========================

Usually one should implement the interface **\\OCP\\Files\\Storage\\IStorage**
but the easiest way is to directly extend
**\\OCP\\Files\\Storage\\StorageAdapter** which already provides the
implementation for many commonly required methods.

For this storage, we'll use a fake library which we'll call **FakeStorageLib**.
We create a class that implements all filesystem operations required by
ownCloud.

.. code-block:: php

.. include:: examples/storage-backend/OCA/MyStorageApp/Storage/MyStorage.php

For this example we simply mapped the storage methods to the one from the
library. In many cases, the underlying library might not support some
operations and might need extra code to work this around.

Stat cache
----------

Within a single PHP request, ownCloud might call the same storage methods
repeatedly due to different checks. If the underlying library does not support
stat/metadata caching, you might need to implement a stat cache yourself. For
this, the metadata of any folder entries should be cached in a local array and
returned by the storage methods.

Writing a Flysystem adapter
---------------------------

Instead of writing everything by hand it is also possible to write an ownCloud
adapter to use a Flysystem adapter as external storage. See how it was done in
the `FTP storage
<https://github.com/owncloud/files_external_ftp/blob/master/lib/Storage/FTP.php#L27>`_.

Creating the backend
====================

The storage needs to be registered as follows. Create a class that extends from
**\\OCP\\Files\\External\\Backend**:


.. code-block:: php

.. include:: examples/storage-backend/OCA/MyStorageApp/Backend/MyStorageBackend.php

Definition parameters
---------------------

Flags:

* **DefinitionParameter::FLAG_NONE**: no flags (default)
* **DefinitionParameter::FLAG_OPTIONAL**: for optional parameters

Types:

* **DefinitionParameter::VALUE_TEXT**: text field (default)
* **DefinitionParameter::VALUE_PASSWORD**: masked text field, for passwords and keys
* **DefinitionParameter::VALUE_BOOLEAN**: boolean / checkbox
* **DefinitionParameter::VALUE_HIDDEN**: hidden field, useful with custom scripts

Authentication schemes
----------------------

Several authentication schemes can be specified.

* **AuthMechanism::SCHEME_NULL**: no authentication supported
* **AuthMechanism::SCHEME_BUILTIN**: authentication is provided through definition parameters
* **AuthMechanism::SCHEME_PASSWORD**: support for password-based auth, provides two fields "user" and "password" to the parameter list
* **AuthMechanism::SCHEME_OAUTH1**: OAuth1, provides fields "app_key", "app_secret", "token", "token_secret" and "configured"
* **AuthMechanism::SCHEME_OAUTH2**: OAuth2, provides fields "client_id", "client_secret", "token" and "configured"
* **AuthMechanism::SCHEME_PUBLICKEY**: Public key, provides fields "user", "public_key", "private_key"

Custom user interface
---------------------

When dealing with complex field values or workflows like OAuth, an app might need
to provide custom Javascript code to implement such workflow.

To add a custom script, use the following in the backend constructor:

.. code-block:: php

  $this->addCustomJs('script');

This will automatically load the script :file:`/js/script.js` from the app folder.

The script itself will need to inject events into the external storage GUI as there is currently
no proper public API to do so.


Registering the backend
=======================

To register one or multiple backends, do so in the **Application** class by
implementing the **IBackendProvider** interface:

.. code-block:: php

.. include:: examples/storage-backend/OCA/MyStorageApp/AppInfo/Application.php

Then in :file:"appinfo/app.php" instantiate the **Application** class:

.. code-block:: php

  <?php

    $app = new \OCA\MyStorageApp\AppInfo\Application();

Testing the storage
===================

Once the steps above are done, you should be able to mount the storage in the
external storage section.

