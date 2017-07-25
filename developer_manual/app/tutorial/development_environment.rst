==========================
The Core Application Files
==========================

Any ownCloud application, at its most elementary, only needs a few files. 
These are:

.. code-block:: console

    .
    ├── appinfo
    │   ├── app.php
    │   ├── application.php
    │   ├── info.xml
    │   └── routes.php
    └── lib
        └── Controller
            └── PageController.php

Over the course of this documentation, we'll expand on this basic structure.
However, here are a several of the commonly used directories, that you may see in other apps, and what they're for. 

* **appinfo/**: Contains app metadata and configuration
* **css/**: Contains the CSS files
* **js/**: Contains the JavaScript files
* **lib/**: Contains the application's class files
* **lib/Controller/**: Contains the application's controllers
* **templates/**: Contains the templates
* **tests/**: Contains the tests

To create these, run the following code in your terminal:

.. code-block:: console
   
   mkdir -p testapp/{appinfo,lib/Controller}
   touch appinfo/{app,application,routes}.php appinfo/info.xml lib/Controller/PageController.php

Now let's look at the basic structure that you need.

appinfo/info.xml
~~~~~~~~~~~~~~~~

This stores the application's properties, or metadata, and is one of the most important files.
Rather like a composer.json file (only in XML format), in this file you can set details such as the application's: *id*, *name*, *description*, *license*, *author*, *version*, *namespace*, *category*, and *dependencies*.

In ``appinfo/info.xml``, add the following XML, changing it as necessary:

.. code-block:: xml
   
   <?xml version="1.0"?>
   <info>
       <id>testapp</id>
       <name>Test App</name>
       <description>My first ownCloud App</description>
       <licence>AGPL</licence>
       <author>Your Name</author>
       <version>0.0.1</version>
       <namespace>TestApp</namespace>
       <category>tool</category>
       <dependencies>
           <owncloud min-version="9" />
           <owncloud max-version="10" />
       </dependencies>
   </info>

To learn more about the options able to be stored in this file, check out :doc:`the App Metadata section of the documentation <info>`.
        
appinfo/app.php
~~~~~~~~~~~~~~~

The :file:`appinfo/app.php` is the first file that is loaded and executed. 
It usually contains the application's core configuration settings. 
These can include: 

- **id:** This is the string under which your app will be referenced in ownCloud.
- **order:** Indicates the order in which your application will appear in the apps menu.
- **href:** The application's default route, rendered when the application's first loaded.
- **icon:** The application's icon.
- **name:** The application's title used in ownCloud.

To start off with, in ``appinfo/app.php``, add the following code:

.. code-block:: php
   
   <?php

   \OC::$server->getNavigationManager()->add(function () {
       $urlGenerator = \OC::$server->getURLGenerator();
       return [
           // The string under which your app will be referenced in owncloud
           'id' => 'testapp', 

           // The sorting weight for the navigation. 
           // The higher the number, the higher will it be listed in the navigation
           'order' => 10,

           // The route that will be shown on startup
           'href' => $urlGenerator->linkToRoute('testapp.page.index'), 

           // The icon that will be shown in the navigation, located in img/
           'icon' => $urlGenerator->imagePath('testapp', 'testapp.svg'),

           // The application’s title, used in the navigation & the settings page of your app
           'name' => \OC::$server->getL10N('testapp')->t('Test App'),
       ];
   });

It can also contain :doc:`backgroundjobs` and :doc:`hooks` registrations, as in the example below.
    
.. code-block:: php
    
    // execute OCA\MyApp\BackgroundJob\Task::run when cron is called
    \OC::$server->getJobList()->add('OCA\MyApp\BackgroundJob\Task');

    // execute OCA\MyApp\Hooks\User::deleteUser before a user is being deleted
    \OCP\Util::connectHook('OC_User', 'pre_deleteUser', 'OCA\MyApp\Hooks\User', 'deleteUser');

It is also possible to include :doc:`js` or :doc:`css` for other apps, by placing the **addScript** or **addStyle** functions inside this file as well.
However, this is strongly discouraged, because the file is loaded on each request, as well as for requests that do not return HTML, such as JSON and WebDAV.

.. code-block:: php
    
    <?php

    \OCP\Util::addScript('myapp', 'script');  // include js/script.js for every app
    \OCP\Util::addStyle('myapp', 'style');    // include css/style.css for every app

lib/Controller/PageController.php
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

While not strictly necessary, if you want to do anything of value, you're likely
going to need a controller. 
This can be to render page content, API content, or something else entirely.
In ``lib/Controller/PageController.php``, add the following code:

.. code-block:: php
   
   <?php
   namespace OCA\TestApp\Controller;

   use OCP\AppFramework\{
       Controller,
       Http\TemplateResponse
   };

   /**
    - Define a new page controller
    */
   class PageController extends Controller {
       /**
        - @NoCSRFRequired
        */
       public function index() {
           return ['test' => 'hi'];
       }
   }

What we’re doing here is to create a minimalist controller with one action, index, which is what will handle the route that we’ll define shortly.
The index function returns an array, which we’ll see next.

appinfo/routes.php
~~~~~~~~~~~~~~~~~~

As the name implies, in this file you register your application's routes, and
then link them to a handler.
In ``appinfo/routes.php``, add the following code:

.. code-block:: php
   
   <?php

   namespace OCA\TestApp\AppInfo;

   $application = new Application();
   $application->registerRoutes($this, [
       'routes' => [
           [
               // The handler is the PageController's index method
               'name' => 'page#index',
               // The route
               'url' => '/',
               // Only accessible with GET requests
               'verb' => 'GET'
           ],
       ]
   ]);

appinfo/application.php
~~~~~~~~~~~~~~~~~~~~~~~

This is the core class of the application. 
Here, you setup your controllers among a range of other things.
In ``appinfo/application.php``, add the following code:

.. code-block:: php

   <?php
   namespace OCA\TestApp\AppInfo;

   use \OCP\AppFramework\App;
   use \OCA\TestApp\Controller\PageController;

   class Application extends App {
       public function __construct(array $urlParams=array()){
           parent::__construct('testapp', $urlParams);

           $container = $this->getContainer();
           $container->registerService('PageController', function($c) {
               return new PageController(
                   $c->query('AppName'),
                   $c->query('Request')
               );
           });
       }
   }
