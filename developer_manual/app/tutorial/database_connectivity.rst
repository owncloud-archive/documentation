=====================
Database Connectivity
=====================

The Database Schema
-------------------

Now that the application's routes and two controllers have been setup and wired together, we'll flesh out ``NotesController`` so that the notes can be saved in the database. 
But to do that, we first need to create the :doc:`database schema <../fundamentals/database>` by creating ``ownnotes/appinfo/database.xml``, with the following content:

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

The schema consists of one table: ``ownnotes_notes``, which has four fields:

- **id:** An integer
- **title:** A text field
- **user_id:** A text field
- **content:** A CLOB field

With the file created, the :ref:`version tag <appinfo_info_xml_label>` in ``ownnotes/appinfo/info.xml`` needs to be increased. 
This causes ownCloud to trigger the update process when you next load (or reload) the ownCloud UI. 
Part of the update process includes run database migrations, which will create the database table defined in the migration above.

Data Entities
-------------

Now that the tables are created, we want to map the database search results to a PHP object. 
That way, we're able to manage the data more precisely. 
To do that, create an :doc:`entity <../fundamentals/database>` in new file, called: ``ownnotes/lib/Db/Note.php``:

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

.. note:: The ``id`` field exists in the ``Entity``

We also define a ``jsonSerializable`` method and implement the interface, so that we're able to transform the entity to JSON, making it easy to persist and cache the information.

Data Mappers
------------

Entities are returned from so-called :doc:`data mappers <../fundamentals/database>`. 
`Data mappers are`_:

  A layer of Mappers (473) that moves data between objects and a database while keeping them independent of each other and the mapper itself.

Let's create one in ``ownnotes/lib/Db/NoteMapper.php`` and add a ``find`` and ``findAll`` method:

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


.. note:: 
   The first parent constructor parameter is the database connection object (or database handle), the second one is the database table and the third is the entity which the result should be mapped onto. 
   Insert, delete and update methods are already implemented.

Connecting Databases & Controllers
----------------------------------

Now the mapper is finished and can be passed into the controller.
You can do so by adding it as a type-hinted parameter. 
ownCloud will figure out how to :doc:`assemble them by itself <../fundamentals/container>`. 

Additionally we want to know the ``userId`` of the currently logged in user. 
To do so, add a ``$UserId`` parameter to the constructor, which is case-sensitive. 
Open ``ownnotes/lib/Controller/NoteController.php`` and change it to the following:

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

    }

With the constructor defined, we now need to flesh out the rest of the methods, which we previously didn't define bodies for.
In ``index``, below, we'll return a ``DataResponse`` object, which contains the result of using the Data Mapper's ``findAll`` method.

This method, which is supplied with the current user's id, retrieves all notes created by that user.
A ``DataResponse`` object is used to return generic data responses. 
It provides a more generic response than ``JSONResponse``, which also works with JSON data.

.. code-block:: php

    /**
     * @NoAdminRequired
     */
    public function index() {
        return new DataResponse($this->mapper->findAll($this->userId));
    }

Next, we'll flesh out the ``show`` function.
This function will retrieve and return the details for a specific note.
It does so by using the data mapper's find method, which is supplied with the note's and user's ids.
If the note cannot be retrieved, then a ``DataResponse`` is returned, which results in a 404 Not Found response.

.. code-block:: php

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

Next, we’ll flesh out the create method, so that we can create notes.
This method receives the note’s title and content from the route and sets them, along with the current user’s id, on a new ``Note`` entity object.
The function returns the result of calling the data mapper’s insert method, which attempts to persist the Note entity in the database.

.. code-block:: php

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

Next we’ll flesh out the `update` function, which updates an existing note.
Similar to the ``create`` method, it receives the note’s id, title, and content from the route.
It then attempts to retrieve the note, and throws an exception if it’s unable to do so.
If it can retrieve it, it then updates the title and content, and returns the response from calling the data mapper’s ``update`` function.

.. code-block:: php

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

Finally, we’ll flesh out the ``destroy`` function, which deletes an existing note.
This, like ``update``, will first attempt to retrieve a note, based on the supplied id, and throw an exception if it’s not able to be found.
If it’s able to be found, it will then be passed to the data mapper’s ``delete`` function, which will delete the note from the database.

.. code-block:: php

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
   

This is all that is needed on the server side. 
Now let's progress to the client side.

Decoupling Controllers and Increasing Reusability
-------------------------------------------------

Let's now say that our app is now on `the ownCloud Marketplace`, and we get a request that we should save the files in the filesystem which requires access to the filesystem.

The filesystem API is quite different from the database API and throws different exceptions, which means we need to rewrite everything in the ``NoteController`` class to use it. 

This is bad, because a controller's only responsibility should be to deal with incoming HTTP requests and return HTTP responses. 
If we need to change the controller because the data storage was changed the code is probably too tightly coupled. So we need to add another layer in between, a layer called ``Service``.

Let's take the logic that was inside the controller and put it into a separate class inside ``ownnotes/lib/Service/NoteService.php``:

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

            // In order to be able to plug in different storage backends like files
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

Following that, create an exception class in ``ownnotes/lib/Service/ServiceException.php``:

.. code-block:: php

    <?php
    namespace OCA\OwnNotes\Service;

    use Exception;

    class ServiceException extends Exception {}

Then, create another one in ``ownnotes/lib/Service/NotFoundException.php``:

.. code-block:: php

    <?php
    namespace OCA\OwnNotes\Service;

    class NotFoundException extends ServiceException {}

Remember how we had all those ugly try/catch blocks that where checking for ``DoesNotExistException`` and simply returned a 404 response? 
Let's also refactor these into a reusable class. 

Specifically, we’ll use a `trait <http://php.net/manual/en/language.oop5.traits.php>`_, so that we can inherit methods without having to create a large inheritance hierarchy. 
This will be important later on when you've got controllers that inherit from the ``ApiController`` class instead.
The trait is created in ``ownnotes/lib/Controller/Errors.php``:

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

Now we can wire up the trait and the service inside the ``NoteController``:

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

As a result of these changes, the only reason that the controller needs to be changed is when request/response related things change.

.. Links
   
.. _Data mappers are: https://martinfowler.com/eaaCatalog/dataMapper.html
.. _the ownCloud Marketplace: https://marketplace.owncloud.com/
