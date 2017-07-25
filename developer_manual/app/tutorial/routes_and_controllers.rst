====================
Routes & Controllers
====================

A typical web application consists of both server side and client side code. 
The glue between those two parts are the URLs. 

In the case of the notes app, the following URLs will be used:

* **GET /**: Returns the interface in HTML
* **GET /notes**: Returns a list of all notes in JSON
* **GET /notes/1**: Returns a note with the id 1 in JSON
* **DELETE /notes/1**: Deletes a note with the id 1
* **POST /notes**: Creates a new note by passing in JSON
* **PUT /notes/1**: Updates a note with the id 1 by passing in JSON

On the client side we can call these URLs with the following jQuery code:

.. code-block:: js

    // example for calling the PUT /notes/1 URL
    var baseUrl = OC.generateUrl('/apps/ownnotes');
    var note = {
        title: 'New note',
        content: 'This is the note text'
    };
    var id = 1;
    $.ajax({
        url: baseUrl + '/notes/' + id,
        type: 'PUT',
        contentType: 'application/json',
        data: JSON.stringify(note)
    }).done(function (response) {
        // handle success
    }).fail(function (response, code) {
        // handle failure
    });

On the server side, we need to register a callback that is executed once the request comes in. 
The callback itself will be a method on a :doc:`controller <controllers>` and the controller will be connected to the URL with a :doc:`route <routes>`. 
The controller and route for the page are already set up in ``ownnotes/appinfo/routes.php``:

.. code-block:: php

    <?php
    return ['routes' => [
        ['name' => 'page#index', 'url' => '/', 'verb' => 'GET']
    ]];

This route calls the controller ``OCA\\OwnNotes\\PageController->index()`` method which is defined in ``ownnotes/lib/Controller/PageController.php``. 
The controller returns a :doc:`template <templates>`, in this case ``ownnotes/templates/main.php``:

.. note:: @NoAdminRequired and @NoCSRFRequired in the comments above the method turn off security checks, see :doc:`controllers`

.. code-block:: php

   <?php
    namespace OCA\OwnNotes\Controller;

    use OCP\IRequest;
    use OCP\AppFramework\Http\TemplateResponse;
    use OCP\AppFramework\Controller;

    class PageController extends Controller {

        public function __construct($AppName, IRequest $request){
            parent::__construct($AppName, $request);
        }

        /**
         * @NoAdminRequired
         * @NoCSRFRequired
         */
        public function index() {
            return new TemplateResponse('ownnotes', 'main');
        }

    }

Since the route which returns the initial HTML has been taken care of, the controller which handles the AJAX requests for the notes needs to be set up. 
Create the following file: ``ownnotes/lib/Controller/NoteController.php`` with the following content:

.. code-block:: php

   <?php
    namespace OCA\OwnNotes\Controller;

    use OCP\IRequest;
    use OCP\AppFramework\Controller;

    class NoteController extends Controller {

        public function __construct($AppName, IRequest $request){
            parent::__construct($AppName, $request);
        }

        /**
         * @NoAdminRequired
         */
        public function index() {
            // empty for now
        }

        /**
         * @NoAdminRequired
         *
         * @param int $id
         */
        public function show($id) {
            // empty for now
        }

        /**
         * @NoAdminRequired
         *
         * @param string $title
         * @param string $content
         */
        public function create($title, $content) {
            // empty for now
        }

        /**
         * @NoAdminRequired
         *
         * @param int $id
         * @param string $title
         * @param string $content
         */
        public function update($id, $title, $content) {
            // empty for now
        }

        /**
         * @NoAdminRequired
         *
         * @param int $id
         */
        public function destroy($id) {
            // empty for now
        }

    }

.. note:: 
   The parameters are extracted from the request body and the url using the controller method's variable names. 
   Since PHP does not support type hints for primitive types such as ints and booleans, we need to add them as annotations in the comments. 
   In order to type cast a parameter to an int, add ``@param int $parameterName``

Now the controller methods need to be connected to the corresponding URLs in the ``ownnotes/appinfo/routes.php`` file:

.. code-block:: php

    <?php
    return [
        'routes' => [
            ['name' => 'page#index', 'url' => '/', 'verb' => 'GET'],
            ['name' => 'note#index', 'url' => '/notes', 'verb' => 'GET'],
            ['name' => 'note#show', 'url' => '/notes/{id}', 'verb' => 'GET'],
            ['name' => 'note#create', 'url' => '/notes', 'verb' => 'POST'],
            ['name' => 'note#update', 'url' => '/notes/{id}', 'verb' => 'PUT'],
            ['name' => 'note#destroy', 'url' => '/notes/{id}', 'verb' => 'DELETE']
        ]
    ];

Since those five routes are so common, they can be abbreviated by adding a resource instead:

.. code-block:: php

    <?php
    return [
        'resources' => [
            'note' => ['url' => '/notes']
        ],
        'routes' => [
            ['name' => 'page#index', 'url' => '/', 'verb' => 'GET']
        ]
    ];


