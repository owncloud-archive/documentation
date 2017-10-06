====================
Routes & Controllers
====================

Routes
------

A typical web application consists of both server side and client side code. 
The glue between those two parts are the URLs. 
In the case of the own notes application, the following URLs will be used:

* **GET /**: Returns the interface in HTML format
* **GET /notes**: Returns a list of all notes in JSON format
* **GET /notes/1**: Returns a note with the id 1 in JSON format
* **DELETE /notes/1**: Deletes a note with the id 1
* **POST /notes**: Creates a new note by passing in JSON format
* **PUT /notes/1**: Updates a note with the id 1 by passing in JSON format

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
The callback will be a method on a :doc:`controller <../fundamentals/controllers>` and the controller will be connected to the URL with a :doc:`route <../fundamentals/routes>`. 

To do that, we create the routes configuration file: ``ownnotes/appinfo/routes.php``, which you can see the definition for below. 

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

.. note:: A handy feature of routing in ownCloud is that as the final five routes are so similar, they can be abbreviated by adding a resource instead:

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

Let's look at the route below first, so that you get a better understanding of how they're composed.

.. code-block:: php

    <?php
    return ['routes' => [
        ['name' => 'page#index', 'url' => '/', 'verb' => 'GET']
    ]];

This route (``/``) is accessible only via a GET request and is called ``page#index``.
When called, the request will be handled by ``OCA\\OwnNotes\\PageController``'s ``index`` method. 
The reason why is defined in the route's name. 
The name is composed of the name of a controller and a method on that controller, separated by a hash symbol.

.. _routes_and_controllers_controllers_label:

Controllers
-----------

The controller, more specifically the controller function, as in other MVC-based frameworks, is the central place of logic for a route (or action).
These functions, as you would expect, can return a range of responses to the user, including: JSON, HTML, XML, and plain text; a redirect or 404 Not Found response, or the download of a file. 

In the example below, we'll return an HTML response, based on the contents of a :doc:`template <../fundamentals/templates>` file, using the ``TemplateResponse`` object.
The ``TemplateResponse`` object renders a template located in an application's templates directory. 

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
            // Renders ownnotes/templates/main.php
            return new TemplateResponse('ownnotes', 'main');
        }

    }

The first argument to the constructor specifies which application’s template directory to search.
The second argument specifies the template to use, minus file extension (``.php``).
Templates are, effectively, not much more than the original PHP files, which were a combination of PHP and HTML.
   
.. note::
   The ``OCP`` namespace maps to ``ownCloud/core/lib/public``.

.. note:: 
   The ``@NoAdminRequired`` and ``@NoCSRFRequired`` annotations in index's docblock above turn off security checks, as they're not necessary for this method. 
   See :doc:`../fundamentals/controllers` for more information.

With an initial overview of controllers (and templates) completed, we'll now create the core of a controller which handles AJAX requests for the application. 
Create a new controller, called ``ownnotes/lib/Controller/NoteController.php``, with the following content:

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

You can see that it's largely the same as the ``PageController``, but with a range of CRUD methods.
Take special note of ``show``, ``create``, ``update``, and ``destroy``.
The parameters to these functions are extracted from the request body and the URL, using the controller method's variable names. 
   
We're not going to do anything further in this chapter.
However, we'll flesh out the controller in the next chapter on database interaction.
