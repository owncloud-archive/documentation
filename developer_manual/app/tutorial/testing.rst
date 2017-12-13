=============
Writing Tests
=============

Tests are essential for having happy users and a carefree life. 
No one wants their users to rant about your app breaking their ownCloud or being buggy. 
To do that you need to test your app. 
Since this amounts to a ton of repetitive tasks, we need to automate the tests.

Unit Tests
----------

A unit test is a test that tests a class in isolation. It is very fast and catches most of the bugs, so we want many unit tests.
Because ownCloud uses :doc:`Dependency Injection <../fundamentals/container>` to assemble your app, it is very easy to write unit tests by passing mocks into the constructor. A simple test for the update method can be added by adding this to ``ownnotes/tests/Unit/Controller/NoteControllerTest.php``:

.. code-block:: php

    <?php
    namespace OCA\OwnNotes\Tests\Unit\Controller;

    use PHPUnit_Framework_TestCase;

    use OCP\AppFramework\Http;
    use OCP\AppFramework\Http\DataResponse;

    use OCA\OwnNotes\Service\NotFoundException;


    class NoteControllerTest extends PHPUnit_Framework_TestCase {

        protected $controller;
        protected $service;
        protected $userId = 'john';
        protected $request;

        public function setUp() {
            $this->request = $this->getMockBuilder('OCP\IRequest')->getMock();
            $this->service = $this->getMockBuilder('OCA\OwnNotes\Service\NoteService')
                ->disableOriginalConstructor()
                ->getMock();
            $this->controller = new NoteController(
                'ownnotes', $this->request, $this->service, $this->userId
            );
        }

        public function testUpdate() {
            $note = 'just check if this value is returned correctly';
            $this->service->expects($this->once())
                ->method('update')
                ->with($this->equalTo(3),
                        $this->equalTo('title'),
                        $this->equalTo('content'),
                       $this->equalTo($this->userId))
                ->will($this->returnValue($note));

            $result = $this->controller->update(3, 'title', 'content');

            $this->assertEquals($note, $result->getData());
        }


        public function testUpdateNotFound() {
            // test the correct status code if no note is found
            $this->service->expects($this->once())
                ->method('update')
                ->will($this->throwException(new NotFoundException()));

            $result = $this->controller->update(3, 'title', 'content');

            $this->assertEquals(Http::STATUS_NOT_FOUND, $result->getStatus());
        }

    }


We can and should also create a test for the ``NoteService`` class:

.. code-block:: php

    <?php
    namespace OCA\OwnNotes\Tests\Unit\Service;

    use PHPUnit_Framework_TestCase;

    use OCP\AppFramework\Db\DoesNotExistException;

    use OCA\OwnNotes\Db\Note;

    class NoteServiceTest extends PHPUnit_Framework_TestCase {

        private $service;
        private $mapper;
        private $userId = 'john';

        public function setUp() {
            $this->mapper = $this->getMockBuilder('OCA\OwnNotes\Db\NoteMapper')
                ->disableOriginalConstructor()
                ->getMock();
            $this->service = new NoteService($this->mapper);
        }

        public function testUpdate() {
            // the existing note
            $note = Note::fromRow([
                'id' => 3,
                'title' => 'yo',
                'content' => 'nope'
            ]);
            $this->mapper->expects($this->once())
                ->method('find')
                ->with($this->equalTo(3))
                ->will($this->returnValue($note));

            // the note when updated
            $updatedNote = Note::fromRow(['id' => 3]);
            $updatedNote->setTitle('title');
            $updatedNote->setContent('content');
            $this->mapper->expects($this->once())
                ->method('update')
                ->with($this->equalTo($updatedNote))
                ->will($this->returnValue($updatedNote));

            $result = $this->service->update(3, 'title', 'content', $this->userId);

            $this->assertEquals($updatedNote, $result);
        }


        /**
         * @expectedException OCA\OwnNotes\Service\NotFoundException
         */
        public function testUpdateNotFound() {
            // test the correct status code if no note is found
            $this->mapper->expects($this->once())
                ->method('find')
                ->with($this->equalTo(3))
                ->will($this->throwException(new DoesNotExistException('')));

            $this->service->update(3, 'title', 'content', $this->userId);
        }

    }

If `PHPUnit is installed <https://phpunit.de/>`_ we can run the tests inside ``ownnotes/`` with the following command::

    phpunit

.. note:: You need to adjust the ``ownnotes/tests/Unit/Controller/PageControllerTest`` file to get the tests passing: remove the ``testEcho`` method since that method is no longer present in your ``PageController`` and do not test the user id parameters since they are not passed anymore

Integration Tests
-----------------

Integration tests are slow and need a fully working instance but make sure that our classes work well together. 
Instead of mocking out all classes and parameters we can decide whether to use full instances or replace certain classes. 
Because they are slow we don't want as many integration tests as unit tests.

In our case we want to create an integration test for the udpate method without mocking out the ``NoteMapper`` class so we actually write to the existing database.
To do that create a new file called ``ownnotes/tests/Integration/NoteIntegrationTest.php`` with the following content:

.. code-block:: php

    <?php
    namespace OCA\OwnNotes\Tests\Integration\Controller;

    use OCP\AppFramework\Http\DataResponse;
    use OCP\AppFramework\App;
    use Test\TestCase;

    use OCA\OwnNotes\Db\Note;

    class NoteIntregrationTest extends TestCase {

        private $controller;
        private $mapper;
        private $userId = 'john';

        public function setUp() {
            parent::setUp();
            $app = new App('ownnotes');
            $container = $app->getContainer();

            // only replace the user id
            $container->registerService('UserId', function($c) {
                return $this->userId;
            });

            $this->controller = $container->query(
                'OCA\OwnNotes\Controller\NoteController'
            );

            $this->mapper = $container->query(
                'OCA\OwnNotes\Db\NoteMapper'
            );
        }

        public function testUpdate() {
            // create a new note that should be updated
            $note = new Note();
            $note->setTitle('old_title');
            $note->setContent('old_content');
            $note->setUserId($this->userId);

            $id = $this->mapper->insert($note)->getId();

            // fromRow does not set the fields as updated
            $updatedNote = Note::fromRow([
                'id' => $id,
                'user_id' => $this->userId
            ]);
            $updatedNote->setContent('content');
            $updatedNote->setTitle('title');

            $result = $this->controller->update($id, 'title', 'content');

            $this->assertEquals($updatedNote, $result->getData());

            // clean up
            $this->mapper->delete($result->getData());
        }

    }

To run the integration tests change into the ``ownnotes`` directory and run

.. code-block:: console

    phpunit -c phpunit.integration.xml

