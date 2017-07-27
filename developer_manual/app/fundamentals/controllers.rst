===========
Controllers
===========

.. sectionauthor:: Bernhard Posselt <dev@bernhard-posselt.com>

Controllers are used to connect :doc:`routes <routes>` with application logic. 
Think of them as callbacks that are executed once a request has come in. 
Controllers are defined inside the ``lib/Controller/`` directory.
To create a controller, extend the ``Controller`` class and create a method that should be executed to handle a request.

Here is an example of how to do so.

.. code-block:: php

    <?php
    namespace OCA\MyApp\Controller;

    use OCP\AppFramework\Controller;

    // define a new author controller
    class AuthorController extends Controller {
        // define the method to execute upon the request
        public function index() {

        }
    }

Connecting a Controller and a Route
====================================

To connect a controller and a route the controller has to be registered in the :doc:`container` like this:

.. code-block:: php

    <?php
    namespace OCA\MyApp\AppInfo;

    use OCP\AppFramework\App;
    use OCA\MyApp\Controller\AuthorApiController;

    class Application extends application {

        public function __construct(array $urlParams=[]) {
            parent::__construct('myapp', $urlParams);

            $container = $this->getContainer();

            /**
             * Controllers
             */
            $container->registerService('AuthorApiController', function($c) {
                // register the controller in the container
                return new AuthorApiController(
                    $c->query('AppName'),
                    $c->query('Request')
                );
            });
        }
    }

Every controller requires the application name and the request object to be passed to their parent constructor. 
This can be done as shown in the example code above. 

.. note::
   The important part is not the class name, but rather the string which is passed in as the first parameter of the ``registerService`` method.

The other part is the route name. 
An example route name would look like this::

    author_api#some_method

This name is processed in the following way:

1. Remove the underscore and uppercase the next character::

    authorApi#someMethod

2. Then split the name at the # and uppercase the first letter of the left part::

    AuthorApi
    someMethod

3. Then append Controller to the first part::

    AuthorApiController
    someMethod

4. Finally, retrieve the service listed under ``AuthorApiController`` from the container, look up the parameters of the ``someMethod`` method in the request, cast them if there are `PHPDoc type annotations`, and execute the ``someMethod`` method on the controller with those parameters.

Getting Request Parameters
==========================

Parameters can be passed in many ways, including:

* Extracting them from the URL using curly braces like ``{key}`` inside the URL (see :doc:`routes`)
* Appending them to the URL as a GET request (e.g. ``?something=true``)
* Setting the form's encoding type as ``application/x-www-form-urlencoded`` in a form request
* Setting the encoding type as ``application/json`` in a ``POST``, ``PATCH``, or ``PUT`` request

These parameters can be accessed by adding them to the controller method.
For example:

.. code-block:: php

    <?php
    namespace OCA\MyApp\Controller;

    use OCP\AppFramework\Controller;

    class PageController extends Controller {
        // this method will be executed with the id and name parameter taken
        // from the request
        public function doSomething($id, $name) {

        }
    }

It is also possible to set default parameter values by using PHP default method values.
This allows common values to be omitted. 
For example:

.. code-block:: php

    <?php
    namespace OCA\MyApp\Controller;

    use OCP\AppFramework\Controller;

    class PageController extends Controller {
        /**
         * @param int $id
         */
        public function doSomething($id, $name='john', $job='author') {
            // GET ?id=3&job=killer
            // $id = 3
            // $name = 'john'
            // $job = 'killer'
        }
    }


Casting Parameters
------------------

``URL``, ``GET`` and ``application/x-www-form-urlencoded`` have the problem that every parameter is a string, meaning that ``?doMore=false`` would be passed in as the string ``'false'`` which is not what one would expect. 
To cast these to the correct types, simply add a PHPDoc comment, in the form of ``@param type $name``.
Here's a comprehensive example showing all the options at once.

.. code-block:: php

    <?php
    namespace OCA\MyApp\Controller;

    use OCP\AppFramework\Controller;

    class PageController extends Controller {
        /**
         * @param int $id
         * @param bool $doMore
         * @param float $value
         */
        public function doSomething($id, $doMore, $value) {
            // GET /index.php/apps/myapp?id=3&doMore=false&value=3.5
            // => $id = 3
            //    $doMore = false
            //    $value = 3.5
        }
    }

The following types will be cast:

* ``bool`` or ``boolean``
* ``float``
* ``int`` or ``integer``

JSON Parameters
---------------
It is possible to pass JSON data using a ``POST``, ``PUT`` or ``PATCH`` request. 
To do that the ``Content-Type`` header has to be set to ``application/json``. 
The JSON will be parsed as an array.
The first level keys will be used to pass in the arguments, e.g.::

    POST /index.php/apps/myapp/authors
    Content-Type: application/json
    {
        "name": "test",
        "number": 3,
        "publisher": true,
        "customFields": {
            "mail": "test@example.com",
            "address": "Somewhere"
        }
    }

.. code-block:: php

    <?php
    namespace OCA\MyApp\Controller;

    use OCP\AppFramework\Controller;

    class PageController extends Controller {
        public function create($name, $number, $publisher, $customFields) {
            // $name = 'test'
            // $number = 3
            // $publisher = true
            // $customFields = ["mail" => "test@example.com", "address" => "Somewhere"]
        }
    }

Reading Headers, Files, Cookies and Environment Variables
---------------------------------------------------------

Headers, files, cookies, and environment variables can be accessed directly from the request object:

.. code-block:: php

    <?php
    namespace OCA\MyApp\Controller;

    use OCP\AppFramework\Controller;
    use OCP\IRequest;

    class PageController extends Controller {
        public function someMethod() {
            $type = $this->request->getHeader('Content-Type');  // $_SERVER['HTTP_CONTENT_TYPE']
            $cookie = $this->request->getCookie('myCookie');    // $_COOKIES['myCookie']
            $file = $this->request->getUploadedFile('myfile');  // $_FILES['myfile']
            $env = $this->request->getEnv('SOME_VAR');          // $_ENV['SOME_VAR']
        }
    }

Why should those values be accessed from the request object and not from the global array like ``$_FILES``? 
Simple: `because it's bad practice <http://c2.com/cgi/wiki?GlobalVariablesAreBad>`_ and will make testing harder.

Reading and Writing Session Variables
-------------------------------------

To set, get or modify session variables, the ``ISession`` object has to be injected into the controller.
Then session variables can be accessed like this:

.. note:: 
   The session is closed automatically for writing, unless you add the ``@UseSession`` annotation!

.. code-block:: php

    <?php
    namespace OCA\MyApp\Controller;

    use OCP\ISession;
    use OCP\IRequest;
    use OCP\AppFramework\Controller;

    class PageController extends Controller {

        private $session;

        public function __construct($AppName, IRequest $request, ISession $session) {
            parent::__construct($AppName, $request);
            $this->session = $session;
        }

        /**
         * The following annotation is only needed for writing session values
         * @UseSession
         */
        public function writeASessionVariable() {
            // read a session variable
            $value = $this->session['value'];

            // write a session variable
            $this->session['value'] = 'new value';
        }
    }

Setting Cookies
---------------

Cookies can be set or modified directly on the response class:

.. code-block:: php

    <?php
    namespace OCA\MyApp\Controller;

    use DateTime;

    use OCP\AppFramework\Controller;
    use OCP\AppFramework\Http\TemplateResponse;
    use OCP\IRequest;

    class BakeryController extends Controller {
        /**
         * Adds a cookie "foo" with value "bar" that expires after user closes the browser
         * Adds a cookie "bar" with value "foo" that expires 2015-01-01
         */
        public function addCookie() {
            $response = new TemplateResponse(...);
            $response->addCookie('foo', 'bar');
            $response->addCookie('bar', 'foo', new DateTime('2015-01-01 00:00'));
            return $response;
        }

        /**
         * Invalidates the cookie "foo"
         * Invalidates the cookie "bar" and "bazinga"
         */
        public function invalidateCookie() {
            $response = new TemplateResponse(...);
            $response->invalidateCookie('foo');
            $response->invalidateCookies(['bar', 'bazinga']);
            return $response;
        }
   }

Responses
=========

Similar to how every controller receives a request object, every controller method has to to return a Response. 
This can be in the form of a ``Response`` subclass or in the form of a value that can be handled by a registered responder.

JSON
----

Returning JSON is simple, just pass an array to a ``JSONResponse``:

.. code-block:: php

    <?php
    namespace OCA\MyApp\Controller;

    use OCP\AppFramework\Controller;
    use OCP\AppFramework\Http\JSONResponse;

    class PageController extends Controller {
        public function returnJSON() {
            $params = ['test' => 'hi'];
            return new JSONResponse($params);
        }
    }

Because returning JSON is such an common task, there's even a shorter way to do this:

.. code-block:: php

    <?php
    namespace OCA\MyApp\Controller;

    use OCP\AppFramework\Controller;

    class PageController extends Controller {
        public function returnJSON() {
            return ['test' => 'hi'];
        }
    }

Why does this work? 
Because the dispatcher sees that the controller did not return a subclass of a ``Response`` and asks the controller to turn the value into a ``Response``. 
That's where responders come in.

Responders
----------

Responders are short functions that take a value and return a response. 
They are used to return different kinds of responses based on a ``format`` parameter which is supplied by the client. 
Think of an API that is able to return both XML and JSON depending on if you call the URL with::

    ?format=xml

or::

    ?format=json

The appropriate responder is being chosen by the following criteria:

- First the dispatcher checks the Request if there is a ``format`` parameter, e.g.::

    ?format=xml

or::

    /index.php/apps/myapp/authors.{format}

- If there is none, take the ``Accept`` header, use the first mimetype and cut off ``application/``. In the following example the format would be XML::

    Accept: application/xml, application/json

- If there is no Accept header or the responder does not exist, format defaults to ``json``.

By default there is only a responder for JSON but more can be added easily:

.. code-block:: php

    <?php
    namespace OCA\MyApp\Controller;

    use OCP\AppFramework\Controller;
    use OCP\AppFramework\Http\DataResponse;

    class PageController extends Controller {

        public function returnHi() {
            // XMLResponse has to be implemented
            $this->registerResponder('xml', function($value) {
                if ($value instanceof DataResponse) {
                    return new XMLResponse(
                        $value->getData(),
                        $value->getStatus(),
                        $value->getHeaders()
                    );
                } else {
                    return new XMLResponse($value);
                }
            });

            return ['test' => 'hi'];
        }

    }

.. note:: 
   The above example would only return XML if the ``format`` parameter was
   ``XML``. If you want to return an XMLResponse regardless of the format
   parameter, extend the Response class and return a new instance of it from the
   controller method instead.

Because returning values works fine in case of a success but not in case of failure that requires a custom HTTP error code, you can always wrap the value in a ``DataResponse``. 
This works for both normal responses and error responses.

.. code-block:: php

    <?php
    namespace OCA\MyApp\Controller;

    use OCP\AppFramework\Controller;
    use OCP\AppFramework\Http\DataResponse;
    use OCP\AppFramework\Http\Http;

    class PageController extends Controller {

        public function returnHi() {
            try {
                return new DataResponse(calculate_hi());
            } catch (\Exception $ex) {
                return new DataResponse(['msg' => 'not found!'], Http::STATUS_NOT_FOUND);
            }
        }

    }


Templates
---------

A :doc:`template <templates>` can be rendered by returning a ``TemplateResponse``. 
A ``TemplateResponse`` takes the following parameters:

* ``appName``: tells the template engine in which application the template should be located
* ``templateName``: the name of the template inside the ``template/`` folder without the .php extension
* ``parameters``: optional array parameters that are available in the template through $_, e.g.::

    ['key' => 'something']

can be accessed through::

    $_['key']

* ``renderAs``: defaults to ``user``, tells ownCloud if it should include it in the web interface, or in case `blank` is passed solely render the template

.. code-block:: php

    <?php
    namespace OCA\MyApp\Controller;

    use OCP\AppFramework\Controller;
    use OCP\AppFramework\Http\TemplateResponse;

    class PageController extends Controller {
        public function index() {
            $templateName = 'main';  // will use templates/main.php
            $parameters = ['key' => 'hi'];
            return new TemplateResponse($this->appName, $templateName, $parameters);
        }
    }

Redirects
---------

A redirect can be achieved by returning a ``RedirectResponse``:

.. code-block:: php

    <?php
    namespace OCA\MyApp\Controller;

    use OCP\AppFramework\Controller;
    use OCP\AppFramework\Http\RedirectResponse;

    class PageController extends Controller {
        public function toGoogle() {
            return new RedirectResponse('https://google.com');
        }
    }

Downloads
---------

A file download can be triggered by returning a ``DownloadResponse``:

.. code-block:: php

    <?php
    namespace OCA\MyApp\Controller;

    use OCP\AppFramework\Controller;
    use OCP\AppFramework\Http\DownloadResponse;

    class PageController extends Controller {
        public function downloadXMLFile() {
            $path = '/some/path/to/file.xml';
            $contentType = 'application/xml';

            return new DownloadResponse($path, $contentType);
        }
    }

Creating Custom Responses
-------------------------

If no premade ``Response`` object fits the needed use case, its possible to extend the ``Response`` base class and create a custom one. 
The only thing that needs to be implemented is the ``render`` method which returns the result as string.
Creating a custom ``XMLResponse`` class could look like this:

.. code-block:: php

    <?php
    namespace OCA\MyApp\Http;

    use OCP\AppFramework\Http\Response;

    class XMLResponse extends Response {

        private $xml;

        public function __construct(array $xml) {
            $this->addHeader('Content-Type', 'application/xml');
            $this->xml = $xml;
        }

        public function render() {
            $root = new SimpleXMLElement('<root/>');
            array_walk_recursive($this->xml, [$root, 'addChild']);
            return $xml->asXML();
        }
    }

Streamed and Lazily Rendered Responses
--------------------------------------

By default all responses are rendered at once and sent as a string through middleware. 
In certain cases this is not a desirable behavior, for instance if you want to stream a file in order to save memory. 
To do that, use the ``OCP\\AppFramework\\Http\\StreamResponse`` class:

.. code-block:: php

    <?php
    namespace OCA\MyApp\Controller;

    use OCP\AppFramework\Controller;
    use OCP\AppFramework\Http\StreamResponse;

    class PageController extends Controller {

        public function downloadXMLFile() {
            return new StreamResponse('/some/path/to/file.xml');
        }
    }

If you want to use a custom, lazily rendered response simply implement the interface ``OCP\\AppFramework\\Http\\ICallbackResponse`` for your response:

.. code-block:: php

    <?php
    namespace OCA\MyApp\Http;

    use OCP\AppFramework\Http\Response;
    use OCP\AppFramework\Http\ICallbackResponse;

    class LazyResponse extends Response implements ICallbackResponse {
        public function callback(IOutput $output) {
            // custom code in here
        }
    }

.. note:: 
   Because this code is rendered after several usually built in helpers, you
   need to take care of errors and proper HTTP caching by yourself.

Modifying the Content Security Policy
-------------------------------------

By default ownCloud disables all resources which are not served on the same domain, forbids cross domain requests and disables inline CSS and JavaScript by setting a `Content Security Policy`_. 
However if an application relies on third party media or other features which are forbidden by the current policy the policy can be relaxed.

.. note:: Double check your content and edge cases before you relax the policy! Also read the `documentation provided by MDN`_

To relax the policy pass an instance of the Content Security Policy class to your response. 
The methods on the class can be chained.
The following methods turn off security features by passing in ``true`` as the ``$isAllowed`` parameter:

* ``allowInlineScript`` (bool $isAllowed)
* ``allowInlineStyle`` (bool $isAllowed)
* ``allowEvalScript`` (bool $isAllowed)

The following methods whitelist domains by passing in a domain or \* for any domain:

* ``addAllowedScriptDomain`` (string $domain)
* ``addAllowedStyleDomain`` (string $domain)
* ``addAllowedFontDomain`` (string $domain)
* ``addAllowedImageDomain`` (string $domain)
* ``addAllowedConnectDomain`` (string $domain)
* ``addAllowedMediaDomain`` (string $domain)
* ``addAllowedObjectDomain`` (string $domain)
* ``addAllowedFrameDomain`` (string $domain)
* ``addAllowedChildSrcDomain`` (string $domain)

The following policy for instance allows images, audio, and videos from other domains:

.. code-block:: php

    <?php
    namespace OCA\MyApp\Controller;

    use OCP\AppFramework\Controller;
    use OCP\AppFramework\Http\TemplateResponse;
    use OCP\AppFramework\Http\ContentSecurityPolicy;

    class PageController extends Controller {
        public function index() {
            $response = new TemplateResponse('myapp', 'main');
            $csp = new ContentSecurityPolicy();
            $csp->addAllowedImageDomain('*');
                ->addAllowedMediaDomain('*');
            $response->setContentSecurityPolicy($csp);
        }
    }

OCS
---

.. note:: 
   This is purely for compatibility reasons. If you are planning to offer an
   external API, go for a :doc:`api` instead.

In order to ease migration from OCS API routes to the application Framework, an additional controller and response have been added. 
To migrate your API you can use the ``OCP\\AppFramework\\OCSController`` base class and return your data in the form of an array in the following way:

.. code-block:: php

    <?php
    namespace OCA\MyApp\Controller;

    use OCP\AppFramework\OCSController;

    class ShareController extends OCSController {

        /**
         * @NoAdminRequired
         * @NoCSRFRequired
         * @PublicPage
         * @CORS
         */
        public function getShares() {
            return [
                'data' => [
                    // actual data is in here
                ],
                // optional
                'statuscode' => 100,
                'status' => 'OK'
            ];
        }
    }

The format parameter works out of the box, no intervention is required.

Handling Errors
---------------

Sometimes a request should fail, for instance if an author with id 1 is requested but does not exist. 
In that case use an appropriate `HTTP error code`_ to signal the client that an error occurred.

Each response subclass has access to the ``setStatus`` method which lets you set an HTTP status code. 
To return a ``JSONResponse`` signaling that the author with id 1 has not been found, use the following code:

.. code-block:: php

    <?php
    namespace OCA\MyApp\Controller;

    use OCP\AppFramework\Controller;
    use OCP\AppFramework\Http;
    use OCP\AppFramework\Http\JSONResponse;

    class AuthorController extends Controller {
        public function show($id) {
            try {
                // try to get author with $id

            } catch (NotFoundException $ex) {
                return new JSONResponse([], Http::STATUS_NOT_FOUND);
            }
        }
    }

Authentication
==============

By default every controller method enforces the maximum security, which is:

* Ensure that the user is admin
* Ensure that the user is logged in
* Check the CSRF token

Most of the time though it makes sense to also allow normal users to access the page and the ``PageController->index()`` method should not check the CSRF token because it has not yet been sent to the client and because of that can't work.
To turn off checks the following *Annotations* can be added before the controller:

* ``@NoAdminRequired``: Also users that are not admins can access the page
* ``@NoSubAdminRequired``: Allow normal users access to the page
* ``@NoCSRFRequired``: Don't check the CSRF token (use this wisely since you might create a security hole, to understand what it does see :doc:`../../general/security`)
* ``@PublicPage``: Everyone can access the page without having to log in

A controller method that turns off all checks would look like this:

.. code-block:: php

    <?php
    namespace OCA\MyApp\Controller;

    use OCP\IRequest;
    use OCP\AppFramework\Controller;

    class PageController extends Controller {
        /**
         * @NoAdminRequired
         * @NoCSRFRequired
         * @PublicPage
         */
        public function freeForAll() {

        }
    }
    
.. Links
   
.. _Content Security Policy: https://developer.mozilla.org/en-US/docs/Web/Security/CSP/Introducing_Content_Security_Policy
.. _documentation provided by MDN: https://developer.mozilla.org/en-US/docs/Web/Security/CSP/Introducing_Content_Security_Policy
.. _HTTP error code : https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#4xx_Client_Error
.. _PHPDoc type annotations: https://phpdoc.org/docs/latest/references/phpdoc/basic-syntax.html
