=======
Routing
=======

.. sectionauthor:: Bernhard Posselt <dev@bernhard-posselt.com>

Routes map an URL and a method to a controller method. Routes are defined inside :file:`appinfo/routes.php` by passing a configuration array to the registerRoutes method. An example route would look like this:

.. code-block:: php

    <?php
    namespace OCA\MyApp\AppInfo;

    $application = new Application();
    $application->registerRoutes($this, array(
        'routes' => array(
            array('name' => 'page#index', 'url' => '/', 'verb' => 'GET'),
        )
    ));


The route array contains the following parts:

* **url**: The url that is matched after */index.php/apps/myapp*
* **name**: The controller and the method to call; *page#index* is being mapped to *PageController->index()*, *articles_api#drop_latest* would be mapped to *ArticlesApiController->dropLatest()*. The controller that matches the page#index name would have to be registered in the following way inside :file:`appinfo/application.php`:

  .. code-block:: php

        <?php
        namespace OCA\MyApp\AppInfo;

        use \OCP\AppFramework\App;

        use \OCA\MyApp\Controller\PageController;


        class Application extends App {

            public function __construct(array $urlParams=array()){
                parent::__construct('myapp', $urlParams);

                $container = $this->getContainer();

                /**
                 * Controllers
                 */
                $container->registerService('PageController', function($c) {
                    return new PageController(
                        $c->query('AppName'),
                        $c->query('Request')
                    );
                });
            }

        }
* **method** (Optional, defaults to GET): The HTTP method that should be matched, (e.g. GET, POST, PUT, DELETE, HEAD, OPTIONS, PATCH)
* **requirements** (Optional): lets you match and extract URLs that have slashes in them (see **Matching suburls**)
* **postfix** (Optional): lets you define a route id postfix. Since each route name will be transformed to a route id (**page#method** -> **myapp.page.method**) and the route id can only exist once you can use the postfix option to alter the route id creation by adding a string to the route id e.g.: **'name' => 'page#method', 'postfix' => 'test'** will yield the route id **myapp.page.methodtest**. This makes it possible to add more than one route/url for a controller method
* **defaults** (Optional): If this setting is given, a default value will be assumed for each url parameter which is not present. The default values are passed in as a key => value par array

Extracting values from the URL
==============================

It is possible to extract values from the URL to allow RESTful URL design. To extract a value, you have to wrap it inside curly braces:

.. code-block:: php

    <?php

    // Request: GET /index.php/apps/myapp/authors/3

    // appinfo/routes.php
    array('name' => 'author#show', 'url' => '/authors/{id}', 'verb' => 'GET'),

    // controller/authorcontroller.php
    class AuthorController {

        public function show($id) {
            // $id is '3'
        }

    }

The identifier used inside the route is being passed into controller method by reflecting the method parameters. So basically if you want to get the value **{id}** in your method, you need to add **$id** to your method parameters.

Matching suburls
================
Sometimes its needed to match more than one URL fragment. An example would be to match a request for all URLs that start with **OPTIONS /index.php/apps/myapp/api**. To do this, use the **requirements** parameter in your route which is an array containing pairs of **'key' => 'regex'**:

.. code-block:: php

    <?php

    // Request: OPTIONS /index.php/apps/myapp/api/my/route

    // appinfo/routes.php
    array('name' => 'author_api#cors', 'url' => '/api/{path}', 'verb' => 'OPTIONS',
          'requirements' => array('path' => '.+')),

    // controller/authorapicontroller.php
    class AuthorApiController {

        public function cors($path) {
            // $path will be 'my/route'
        }

    }

Default values for suburl
==========================
Apart from matching requirements, a suburl may also have a default value. Say you want to support pagination (a 'page' parameter) for your **/posts** suburl that displays posts entries list. You may set a default value for the 'page' parameter, that will be used if not already set in the url. Use the **defaults** parameter in your route which is an array containing pairs of **'urlparameter' => 'defaultvalue'**:

.. code-block:: php

    <?php

    // Request: GET /index.php/app/myapp/post

    // appinfo/routes.php
    array(
        'name'     => 'post#index',
        'url'      => '/post/{page}',
        'verb'     => 'GET',
        'defaults' => array('page' => 1) // this allows same url as /index.php/myapp/post/1
    ),

    // controller/postcontroller.php
    class PostController
    {
        public function index($page = 1)
        {
            // $page will be 1
        }
    }

Registering resources
=====================
When dealing with resources, writing routes can become quite repetitive since most of the time routes for the following tasks are needed:

* Get all entries
* Get one entry by id
* Create an entry
* Update an entry
* Delete an entry

To prevent repetition, it's possible to define resources. The following routes:

.. code-block:: php

    <?php
    namespace OCA\MyApp\AppInfo;

    $application = new Application();
    $application->registerRoutes($this, array(
        'routes' => array(
            array('name' => 'author#index', 'url' => '/authors', 'verb' => 'GET'),
            array('name' => 'author#show', 'url' => '/authors/{id}', 'verb' => 'GET'),
            array('name' => 'author#create', 'url' => '/authors', 'verb' => 'POST'),
            array('name' => 'author#update', 'url' => '/authors/{id}', 'verb' => 'PUT'),
            array('name' => 'author#destroy', 'url' => '/authors/{id}', 'verb' => 'DELETE'),
            // your other routes here
        )
    ));

can be abbreviated by using the **resources** key:

.. code-block:: php

    <?php
    namespace OCA\MyApp\AppInfo;

    $application = new Application();
    $application->registerRoutes($this, array(
        'resources' => array(
            'author' => array('url' => '/authors')
        ),
        'routes' => array(
            // your other routes here
        )
    ));

Using the URLGenerator
========================
Sometimes its useful to turn a route into a URL to make the code independent from the URL design or to generate an URL for an image in **img/**. For that specific use case, the ServerContainer provides a service that can be used in your container:

.. code-block:: php

    <?php
    namespace OCA\MyApp\AppInfo;

    use \OCP\AppFramework\App;

    use \OCA\MyApp\Controller\PageController;


    class Application extends App {

        public function __construct(array $urlParams=array()){
            parent::__construct('myapp', $urlParams);

            $container = $this->getContainer();

            /**
             * Controllers
             */
            $container->registerService('PageController', function($c) {
                return new PageController(
                    $c->query('AppName'),
                    $c->query('Request'),

                    // inject the URLGenerator into the page controller
                    $c->query('ServerContainer')->getURLGenerator()
                );
            });
        }

    }

Inside the PageController the URL generator can now be used to generate an URL for a redirect:

.. code-block:: php

    <?php
    namespace OCA\MyApp\Controller;

    use \OCP\IRequest;
    use \OCP\IURLGenerator;
    use \OCP\AppFramework\Controller;
    use \OCP\AppFramework\Http\RedirectResponse;

    class PageController extends Controller {

        private $urlGenerator;

        public function __construct($appName, IRequest $request,
                                    IURLGenerator $urlGenerator) {
            parent::__construct($appName, $request);
            $this->urlGenerator = $urlGenerator;
        }

        /**
         * redirect to /apps/news/myapp/authors/3
         */
        public function redirect() {
            // route name: author_api#do_something
            // route url: /apps/news/myapp/authors/{id}

            // # needs to be replaced with a . due to limitations and prefixed
            // with your app id
            $route = 'myapp.author_api.do_something';
            $parameters = array('id' => 3);

            $url = $this->urlGenerator->linkToRoute($route, $parameters);

            return new RedirectResponse($url);
        }

    }

URLGenerator is case sensitive, so **appName** must match **exactly** the name you use in :doc:`configuration <configuration>`.
If you use a CamelCase name as *myCamelCaseApp*,

.. code-block:: php

    <?php
    $route = 'myCamelCaseApp.author_api.do_something';
