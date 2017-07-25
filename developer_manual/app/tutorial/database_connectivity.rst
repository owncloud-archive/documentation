=====================
Database Connectivity
=====================

Now that the routes are set up and connected the notes should be saved in the database. To do that first create a :doc:`database schema <schema>` by creating **ownnotes/appinfo/database.xml**:

.. code-block:: xml

    <database>
        <name>*dbname*</name>
        <create>true</create>
        <overwrite>false</overwrite>
        <charset>utf8</charset>
        <table>
            <name>*dbprefix*ownnotes_notes</name>
            <declaration>
                <field>
                    <name>id</name>
                    <type>integer</type>
                    <notnull>true</notnull>
                    <autoincrement>true</autoincrement>
                    <unsigned>true</unsigned>
                    <primary>true</primary>
                    <length>8</length>
                </field>
                <field>
                    <name>title</name>
                    <type>text</type>
                    <length>200</length>
                    <default></default>
                    <notnull>true</notnull>
                </field>
                <field>
                    <name>user_id</name>
                    <type>text</type>
                    <length>200</length>
                    <default></default>
                    <notnull>true</notnull>
                </field>
                <field>
                    <name>content</name>
                    <type>clob</type>
                    <default></default>
                    <notnull>true</notnull>
                </field>
            </declaration>
        </table>
    </database>

To create the tables in the database, the :doc:`version tag <info>` in **ownnotes/appinfo/info.xml** needs to be increased:

.. code-block:: xml

    <?xml version="1.0"?>
    <info>
        <id>ownnotes</id>
        <name>Own Notes</name>
        <description>My first ownCloud app</description>
        <licence>AGPL</licence>
        <author>Your Name</author>
        <version>0.0.2</version>
        <namespace>OwnNotes</namespace>
        <category>tool</category>
        <dependencies>
            <owncloud min-version="8" />
        </dependencies>
    </info>

Reload the page to trigger the database migration.

Now that the tables are created we want to map the database result to a PHP object to be able to control data. First create an :doc:`entity <database>` in **ownnotes/lib/Db/Note.php**:


.. code-block:: php

    <?php
    namespace OCA\OwnNotes\Db;

    use JsonSerializable;

    use OCP\AppFramework\Db\Entity;

    class Note extends Entity implements JsonSerializable {

        protected $title;
        protected $content;
        protected $userId;

        public function jsonSerialize() {
            return [
                'id' => $this->id,
                'title' => $this->title,
                'content' => $this->content
            ];
        }
    }

.. note:: A field **id** is automatically set in the Entity base class

We also define a **jsonSerializable** method and implement the interface to be able to transform the entity to JSON easily.

Entities are returned from so called :doc:`Mappers <database>`. Let's create one in **ownnotes/lib/Db/NoteMapper.php** and add a **find** and **findAll** method:

.. code-block:: php

    <?php
    namespace OCA\OwnNotes\Db;

    use OCP\IDb;
    use OCP\AppFramework\Db\Mapper;

    class NoteMapper extends Mapper {

        public function __construct(IDb $db) {
            parent::__construct($db, 'ownnotes_notes', '\OCA\OwnNotes\Db\Note');
        }

        public function find($id, $userId) {
            $sql = 'SELECT * FROM *PREFIX*ownnotes_notes WHERE id = ? AND user_id = ?';
            return $this->findEntity($sql, [$id, $userId]);
        }

        public function findAll($userId) {
            $sql = 'SELECT * FROM *PREFIX*ownnotes_notes WHERE user_id = ?';
            return $this->findEntities($sql, [$userId]);
        }

    }

.. note:: The first parent constructor parameter is the database layer, the second one is the database table and the third is the entity on which the result should be mapped onto. Insert, delete and update methods are already implemented.

Connect Database & Controllers
------------------------------

The mapper which provides the database access is finished and can be passed into the controller.

You can pass in the mapper by adding it as a type hinted parameter. ownCloud will figure out how to :doc:`assemble them by itself <container>`. Additionally we want to know the userId of the currently logged in user. Simply add a **$UserId** parameter to the constructor (case sensitive!). To do that open **ownnotes/lib/Controller/NoteController.php** and change it to the following:

.. code-block:: php

   <?php
    namespace OCA\OwnNotes\Controller;

    use Exception;

    use OCP\IRequest;
    use OCP\AppFramework\Http;
    use OCP\AppFramework\Http\DataResponse;
    use OCP\AppFramework\Controller;

    use OCA\OwnNotes\Db\Note;
    use OCA\OwnNotes\Db\NoteMapper;

    class NoteController extends Controller {

        private $mapper;
        private $userId;

        public function __construct($AppName, IRequest $request, NoteMapper $mapper, $UserId){
            parent::__construct($AppName, $request);
            $this->mapper = $mapper;
            $this->userId = $UserId;
        }

        /**
         * @NoAdminRequired
         */
        public function index() {
            return new DataResponse($this->mapper->findAll($this->userId));
        }

        /**
         * @NoAdminRequired
         *
         * @param int $id
         */
        public function show($id) {
            try {
                return new DataResponse($this->mapper->find($id, $this->userId));
            } catch(Exception $e) {
                return new DataResponse([], Http::STATUS_NOT_FOUND);
            }
        }

        /**
         * @NoAdminRequired
         *
         * @param string $title
         * @param string $content
         */
        public function create($title, $content) {
            $note = new Note();
            $note->setTitle($title);
            $note->setContent($content);
            $note->setUserId($this->userId);
            return new DataResponse($this->mapper->insert($note));
        }

        /**
         * @NoAdminRequired
         *
         * @param int $id
         * @param string $title
         * @param string $content
         */
        public function update($id, $title, $content) {
            try {
                $note = $this->mapper->find($id, $this->userId);
            } catch(Exception $e) {
                return new DataResponse([], Http::STATUS_NOT_FOUND);
            }
            $note->setTitle($title);
            $note->setContent($content);
            return new DataResponse($this->mapper->update($note));
        }

        /**
         * @NoAdminRequired
         *
         * @param int $id
         */
        public function destroy($id) {
            try {
                $note = $this->mapper->find($id, $this->userId);
            } catch(Exception $e) {
                return new DataResponse([], Http::STATUS_NOT_FOUND);
            }
            $this->mapper->delete($note);
            return new DataResponse($note);
        }

    }

.. note:: The actual exceptions are **OCP\\AppFramework\\Db\\DoesNotExistException** and **OCP\\AppFramework\\Db\\MultipleObjectsReturnedException** but in this example we will treat them as the same. DataResponse is a more generic response than JSONResponse and also works with JSON.

This is all that is needed on the server side. Now let's progress to the client side.

Making things reusable and decoupling controllers from the database
-------------------------------------------------------------------

Let's say our app is now on the ownCloud Marketplace and and we get a request that we should save the files in the filesystem which requires access to the filesystem.

The filesystem API is quite different from the database API and throws different exceptions, which means we need to rewrite everything in the **NoteController** class to use it. This is bad because a controller's only responsibility should be to deal with incoming Http requests and return Http responses. If we need to change the controller because the data storage was changed the code is probably too tightly coupled and we need to add another layer in between. This layer is called **Service**.

Let's take the logic that was inside the controller and put it into a separate class inside **ownnotes/lib/Service/NoteService.php**:

.. code-block:: php

    <?php
    namespace OCA\OwnNotes\Service;

    use Exception;

    use OCP\AppFramework\Db\DoesNotExistException;
    use OCP\AppFramework\Db\MultipleObjectsReturnedException;

    use OCA\OwnNotes\Db\Note;
    use OCA\OwnNotes\Db\NoteMapper;


    class NoteService {

        private $mapper;

        public function __construct(NoteMapper $mapper){
            $this->mapper = $mapper;
        }

        public function findAll($userId) {
            return $this->mapper->findAll($userId);
        }

        private function handleException ($e) {
            if ($e instanceof DoesNotExistException ||
                $e instanceof MultipleObjectsReturnedException) {
                throw new NotFoundException($e->getMessage());
            } else {
                throw $e;
            }
        }

        public function find($id, $userId) {
            try {
                return $this->mapper->find($id, $userId);

            // in order to be able to plug in different storage backends like files
            // for instance it is a good idea to turn storage related exceptions
            // into service related exceptions so controllers and service users
            // have to deal with only one type of exception
            } catch(Exception $e) {
                $this->handleException($e);
            }
        }

        public function create($title, $content, $userId) {
            $note = new Note();
            $note->setTitle($title);
            $note->setContent($content);
            $note->setUserId($userId);
            return $this->mapper->insert($note);
        }

        public function update($id, $title, $content, $userId) {
            try {
                $note = $this->mapper->find($id, $userId);
                $note->setTitle($title);
                $note->setContent($content);
                return $this->mapper->update($note);
            } catch(Exception $e) {
                $this->handleException($e);
            }
        }

        public function delete($id, $userId) {
            try {
                $note = $this->mapper->find($id, $userId);
                $this->mapper->delete($note);
                return $note;
            } catch(Exception $e) {
                $this->handleException($e);
            }
        }

    }

Following up create the exceptions in **ownnotes/lib/Service/ServiceException.php**:

.. code-block:: php

    <?php
    namespace OCA\OwnNotes\Service;

    use Exception;

    class ServiceException extends Exception {}

and **ownnotes/lib/Service/NotFoundException.php**:

.. code-block:: php

    <?php
    namespace OCA\OwnNotes\Service;

    class NotFoundException extends ServiceException {}


Remember how we had all those ugly try catches that where checking for **DoesNotExistException** and simply returned a 404 response? Let's also put this into a reusable class. In our case we chose a `trait <http://php.net/manual/en/language.oop5.traits.php>`_ so we can inherit methods without having to add it to our inheritance hierarchy. This will be important later on when you've got controllers that inherit from the **ApiController** class instead.

The trait is created in **ownnotes/lib/Controller/Errors.php**:


.. code-block:: php

    <?php

    namespace OCA\OwnNotes\Controller;

    use Closure;

    use OCP\AppFramework\Http;
    use OCP\AppFramework\Http\DataResponse;

    use OCA\OwnNotes\Service\NotFoundException;


    trait Errors {

        protected function handleNotFound (Closure $callback) {
            try {
                return new DataResponse($callback());
            } catch(NotFoundException $e) {
                $message = ['message' => $e->getMessage()];
                return new DataResponse($message, Http::STATUS_NOT_FOUND);
            }
        }

    }

Now we can wire up the trait and the service inside the **NoteController**:

.. code-block:: php

    <?php
    namespace OCA\OwnNotes\Controller;

    use OCP\IRequest;
    use OCP\AppFramework\Http\DataResponse;
    use OCP\AppFramework\Controller;

    use OCA\OwnNotes\Service\NoteService;

    class NoteController extends Controller {

        private $service;
        private $userId;

        use Errors;

        public function __construct($AppName, IRequest $request,
                                    NoteService $service, $UserId){
            parent::__construct($AppName, $request);
            $this->service = $service;
            $this->userId = $UserId;
        }

        /**
         * @NoAdminRequired
         */
        public function index() {
            return new DataResponse($this->service->findAll($this->userId));
        }

        /**
         * @NoAdminRequired
         *
         * @param int $id
         */
        public function show($id) {
            return $this->handleNotFound(function () use ($id) {
                return $this->service->find($id, $this->userId);
            });
        }

        /**
         * @NoAdminRequired
         *
         * @param string $title
         * @param string $content
         */
        public function create($title, $content) {
            return $this->service->create($title, $content, $this->userId);
        }

        /**
         * @NoAdminRequired
         *
         * @param int $id
         * @param string $title
         * @param string $content
         */
        public function update($id, $title, $content) {
            return $this->handleNotFound(function () use ($id, $title, $content) {
                return $this->service->update($id, $title, $content, $this->userId);
            });
        }

        /**
         * @NoAdminRequired
         *
         * @param int $id
         */
        public function destroy($id) {
            return $this->handleNotFound(function () use ($id) {
                return $this->service->delete($id, $this->userId);
            });
        }

    }

Great! Now the only reason that the controller needs to be changed is when request/response related things change.


