=========================
External storage backends
=========================

.. sectionauthor:: Vincent Petry <pvince81@owncloud.com>

Have a look at the source code of the `FTP external storage app <https://github.com/owncloud/files_external_ftp>`_ for a good example.

The following sections will indicate what modifications need to be done in a standard app to make it a provider of external storage backends.

Filesystem type
===============

The :file:`/appinfo/info.xml` must be adjusted to specify **filesystem** as type:

.. code-block:: xml

  <?xml version="1.0"?>
  <info>
    <id>mystorageapp</id>
    <name>My storage app</name>
    ...
    <types>
      <filesystem/>
    </types>
    ...
  </info>

Implementing the storage
========================

Usually one should implement the interface **\\OCP\\Files\\Storage\\IStorage** but the easiest way is to
directly extend **\\OCP\\Files\\Storage\\StorageAdapter** which already provides the implementation
for many commonly required methods.

For this storage, we'll use a fake library which we'll call **FakeStorageLib**.

We create a class that implements all filesystem operations required by ownCloud.

.. code-block:: php

  <?php

    namespace OCA\MyStorageApp\Storage;

    use \OCP\Files\Storage\StorageAdapter;
    use Icewind\Streams\IteratorDirectory;
    use Icewind\Streams\CallbackWrapper;

    // for this storage we use a fake library
    use \SomeVendor\FakeStorageLib;

    class MyStorage extends StorageAdapter {

      /**
       * Storage parameters
       */
      private $params;

      /**
       * Connection
       * 
       * @var \SomeVendor\FakeStorageLib\Connection
       */
      private $connection;

      public function __construct($params) {
        // validate and store parameters here, don't initialize the storage yet
        $this->params = $params;
      }

      public function getConnection() {
        if ($this->connection === null) {
          // do the connection to the storage lazily
          $this->connection = new \SomeVendor\FakeStorageLib\Connection($params);
        }
        return $this->connection;
      }

      public function getId() {
        // id specific to this storage type and also unique for the specified user and path
        return 'mystorage::' . $this->params['user'] . '@' . $this->params['host'] . '/' . $this->params['root'];
      }

      public function filemtime($path) {
        return $this->connection->getModifiedTime($path);
      }

      public function filesize($path) {
        // let's say the library doesn't support getting the size directly,
        // so we use stat instead
        $data = $this->stat($path);
        return $data['size'];
      }

      public function filetype($path) {
        if ($this->connection->isDirectory($path)) {
          return 'dir';
        }
        return 'file';
      }

      public function mkdir($path) {
        return $this->connection->createDirectory($path);
      }

      public function rmdir($path) {
        return $this->connection->delete($path);
      }

      public function unlink($path) {
        return $this->connection->delete($path);
      }

      public function file_get_contents($path) {
        return $this->connection->getContents($path);
      }

      public function file_put_contents($path) {
        return $this->connection->setContents($path);
      }

      public function touch($path, $time = null) {
        if ($time === null) {
          $time = time();
        }

        // many libraries might not support touch, so need to adapt
        if (!$this->file_exists($path)) {
          // create empty file
          $this->file_put_contents($path, '');
        }
        // set mtime to existing file
        return $this->connection->setModifiedTime($path, $time);
      }

      public function file_exists($path) {
        return $this->connection->pathExists($path);
      }

      public function rename($source, $target) {
        return $this->connection->move($source, $target);
      }

      public function copy($source, $target) {
        return $this->connection->copy($source, $target);
      }

      public function opendir($path) {
        // let's say the library returns an array of entries
        $allEntries = $this->connection->listFolder($path);
        // extract the names
        $names = array_map(function ($object) {
          return $object['name'];
        }, $allEntries);

        // wrap them in an iterator
        return IteratorDirectory::wrap($names);
      }

      public function stat($path) {
        $data = $this->connection->getMetadata($path);
        // convert to format expected by ownCloud
        return [
          'mtime' => $data['mtime'],
          'size' => $data['size'],
        ];
      }

      public function fopen($path, $mode) {
        switch ($mode) {
          case 'r':
          case 'rb':
            // this works if the library returns a PHP stream directly
            return $this->connection->getStream($path);
          case 'w':
          case 'w+':
          case 'wb':
          case 'wb+':
          case 'a':
          case 'ab':
          case 'r+':
          case 'a+':
          case 'x':
          case 'x+':
          case 'c':
          case 'c+':
          // most storages do not support on the fly stream upload for all modes,
          // so we use a temporary file first
          $ext = pathinfo($filename, PATHINFO_EXTENSION);
          $tmpFile = \OC::$server->getTempManager()->getTemporaryFile($ext);

          // this wrapper will call the callback whenever fclose() was called on the file,
          // after which we send the file to the library
          $result = CallbackWrapper::wrap(
            $source,
            null,
            null,
            function () use ($tmpFile, $path) {
              $this->connection->putFile($tmpFile, $path);
              unlink($tmpFile);
            }
          );
        }
        return false;
      }

      public function isReadable($path) {
        return $this->connection->canRead($path);
      }

      public function isUpdatable($path) {
        return $this->connection->canUpdate($path);
      }

      public function isCreatable($path) {
        return $this->connection->canUpdate($path);
      }

      public function isDeletable($path) {
        return $this->connection->canUpdate($path);
      }

      public function isSharable($path) {
        return $this->connection->canRead($path);
      }
    }


For this example we simply mapped the storage methods to the one from the library.
In many cases, the underlying library might not support some operations and might need
extra code to work this around.

Stat cache
----------

Within a single PHP request, ownCloud might call the same storage methods repeatedly due to
different checks. If the underlying library does not support stat/metadata caching, you might
need to implement a stat cache yourself. For this, the metadata of any folder entries should be cached
in a local array and returned by the storage methods.

Writing a Flysystem adapter
---------------------------

Instead of writing everything by hand it is also possible to write an ownCloud adapter to use
a Flysystem adapter as external storage. See how it was done in the `FTP storage <https://github.com/owncloud/files_external_ftp/blob/master/lib/Storage/FTP.php#L27>`_.

Creating the backend
====================

The storage needs to be registered as follows.

Create a class that extends from **\\OCP\\Files\\External\\Backend**:


.. code-block:: php

  <?php

    namespace OCA\MyStorageApp\Backend;

    use \OCP\IL10N;
    use \OCP\Files\External\Backend\Backend;
    use \OCP\Files\External\DefinitionParameter;
    use \OCP\Files\External\Auth\AuthMechanism;

    class MyStorageBackend extends Backend {
      public function __construct(IL10N $l) {
        $this
          ->setIdentifier('mystorage')
          // specify the storage class as defined above
          ->setStorageClass('\OCA\MyStorageApp\Storage\MyStorage')
          // label as displayed in the web UI
          ->setText($l->t('My Storage'))
          // configuration parameters
          ->addParameters([
            (new DefinitionParameter('host', $l->t('Host'))),
            (new DefinitionParameter('root', $l->t('Root')))
              ->setFlag(DefinitionParameter::FLAG_OPTIONAL),
            (new DefinitionParameter('secure', $l->t('Use SSL')))
              ->setType(DefinitionParameter::VALUE_BOOLEAN),
          ])
          // support for password scheme, will expect two parameters "user" and "password"
          ->addAuthScheme(AuthMechanism::SCHEME_PASSWORD)
      }
    }

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

  <?php
    namespace OCA\MyStorageApp\AppInfo;

    use OCP\AppFramework\App;
    use OCP\AppFramework\IAppContainer;
    use OCP\IContainer;
    use OCP\Files\External\Config\IBackendProvider;

    /**
     * @package OCA\MyStorageApp\AppInfo
     */
    class Application extends App implements IBackendProvider {
      public function __construct(array $urlParams = array()) {
        parent::__construct('mystorageapp', $urlParams);
        $container = $this->getContainer();

        // retrieve the backend service
        $backendService = $container->getServer()->getStoragesBackendService();

        // register this class as backend provider
        $backendService->registerBackendProvider($this);
      }

      /**
       * Return a list of backends to register
       */
      public function getBackends() {
        $container = $this->getContainer();
        $backends = [
          $container->query('OCA\MyStorageApp\Backend\MyStorageBackend'),
        ];
        return $backends;
      }
    }

Then in :file:"appinfo/app.php" instantiate the **Application** class:

.. code-block:: php

  <?php

    $app = new \OCA\MyStorageApp\AppInfo\Application();

Testing the storage
===================

Once the steps above are done, you should be able to mount the storage in the
external storage section.

