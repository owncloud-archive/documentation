Add a RESTful API (optional)
============================

A :doc:`RESTful API <api>` allows other apps such as Android or iPhone apps to access and change your notes. Since syncing is a big core component of ownCloud it is a good idea to add (and document!) your own RESTful API.

Because we put our logic into the ``NoteService`` class it is very easy to reuse it. 
The only pieces that need to be changed are the annotations which disable the CSRF check (not needed for a REST call usually) and add support for `CORS <https://developer.mozilla.org/en-US/docs/Web/HTTP/Access_control_CORS>`_ so your API can be accessed from other webapps.

With that in mind create a new controller in ``ownnotes/lib/Controller/NoteApiController.php``:

.. code-block:: php

    <?php
    namespace OCA\OwnNotes\Controller;

    use OCP\IRequest;
    use OCP\AppFramework\Http\DataResponse;
    use OCP\AppFramework\ApiController;

    use OCA\OwnNotes\Service\NoteService;

    class NoteApiController extends ApiController {

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
         * @CORS
         * @NoCSRFRequired
         * @NoAdminRequired
         */
        public function index() {
            return new DataResponse($this->service->findAll($this->userId));
        }

        /**
         * @CORS
         * @NoCSRFRequired
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
         * @CORS
         * @NoCSRFRequired
         * @NoAdminRequired
         *
         * @param string $title
         * @param string $content
         */
        public function create($title, $content) {
            return $this->service->create($title, $content, $this->userId);
        }

        /**
         * @CORS
         * @NoCSRFRequired
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
         * @CORS
         * @NoCSRFRequired
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

All that is left is to connect the controller to a route and enable the built in pre-flighted CORS method which is defined in the ``ApiController`` base class:

.. code-block:: php

    <?php
    return [
        'resources' => [
            'note' => ['url' => '/notes'],
            'note_api' => ['url' => '/api/0.1/notes']
        ],
        'routes' => [
            ['name' => 'page#index', 'url' => '/', 'verb' => 'GET'],
            ['name' => 'note_api#preflighted_cors', 'url' => '/api/0.1/{path}',
             'verb' => 'OPTIONS', 'requirements' => ['path' => '.+']]
        ]
    ];

.. note:: It is a good idea to version your API in your URL

You can test the API by running a GET request with **curl**::

    curl -u user:password http://localhost:8080/index.php/apps/ownnotes/api/0.1/notes

Since the ``NoteApiController`` is basically identical to the ``NoteController``, the unit test for it simply inherits its tests from the ``NoteControllerTest``. 
Create the file ``ownnotes/tests/Unit/Controller/NoteApiControllerTest.php``:

.. code-block:: php

    <?php
    namespace OCA\OwnNotes\Tests\Unit\Controller;

    require_once __DIR__ . '/NoteControllerTest.php';

    class NoteApiControllerTest extends NoteControllerTest {

        public function setUp() {
            parent::setUp();
            $this->controller = new NoteApiController(
                'ownnotes', $this->request, $this->service, $this->userId
            );
        }

    }
