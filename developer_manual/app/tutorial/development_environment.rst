==========================
The Core Application Files
==========================

Now that you know how the request life cycle works, let's look at the core
application files. 
Any ownCloud application, at its most elementary, only needs a few files and
directories; these are:

.. code-block:: console

    .
    ├── appinfo                         # Contains app metadata and configuration
    │   ├── app.php
    │   ├── application.php
    │   ├── info.xml
    │   └── routes.php
    └── lib                             # Contains the application's class files
        └── Controller                  # Contains the application's controllers

In addition to these, there are several additional, commonly used, directories: 

* ``css/``: Contains the CSS files
* ``js/``: Contains the JavaScript files
* ``templates/``: Contains the templates
* ``tests/``: Contains the tests

Now let's get an understanding of the core configuration files.

.. _appinfo_info_xml_label:

appinfo/info.xml
~~~~~~~~~~~~~~~~

This stores the application's properties, or metadata, and is one of the most important files.
Rather like a composer.json file (only in XML format), in this file you can set details such as the application's: *id*, *name*, *description*, *license*, *author*, *version*, *namespace*, *category*, and *dependencies*.

In ``appinfo/info.xml``, add the following XML, changing it as necessary:

.. code-block:: xml
   
   <?xml version="1.0"?>
   <info>
       <id>ownnotes</id>
       <name>Own Notes</name>
       <description>My first ownCloud App</description>
       <licence>AGPL</licence>
       <author>Your Name</author>
       <version>0.0.1</version>
       <namespace>OwnNotes</namespace>
       <category>tool</category>
       <dependencies>
           <owncloud min-version="9" />
           <owncloud max-version="10" />
       </dependencies>
   </info>

.. note::
   Pay careful attention to the ``namespace`` element. 
   This element defines the application's relative namespace. 
   This namespace, in turn, sits inside a parent ownCloud namespace, called ``OCA``.
   As the application’s namespace is ``OwnNotes``, then it’s fully-qualified
   namespace is ``OCA\\OwnNotes``.

To learn more about the options able to be stored in this file, check out :doc:`the App Metadata section of the documentation <../fundamentals/info>`.
        
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
           'id' => 'ownnotes', 

           // The sorting weight for the navigation. 
           // The higher the number, the higher will it be listed in the navigation
           'order' => 10,

           // The route that will be shown on startup
           'href' => $urlGenerator->linkToRoute('ownnotes.page.index'), 

           // The icon that will be shown in the navigation, located in img/
           'icon' => $urlGenerator->imagePath('ownnotes', 'ownnotes.svg'),

           // The application's title, used in the navigation & the settings page of your app
           'name' => \OC::$server->getL10N('ownnotes')->t('Test App'),
       ];
   });

It can also contain :doc:`../fundamentals/backgroundjobs` and :doc:`../fundamentals/hooks` registrations, as in the example below.
    
.. code-block:: php
    
    // execute OCA\MyApp\BackgroundJob\Task::run when cron is called
    \OC::$server->getJobList()->add('OCA\MyApp\BackgroundJob\Task');

    // execute OCA\MyApp\Hooks\User::deleteUser before a user is being deleted
    \OCP\Util::connectHook('OC_User', 'pre_deleteUser', 'OCA\MyApp\Hooks\User', 'deleteUser');

It is also possible to include :doc:`../fundamentals/js` or :doc:`../fundamentals/css` for other apps, by placing the ``addScript`` or ``addStyle`` functions inside this file as well.
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
   namespace OCA\ownnotes\Controller;

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

What we're doing here is to create a minimalist controller with one action, index, which is what will handle the route that we'll define shortly.
The index function returns an array, which we'll see next.

appinfo/routes.php
~~~~~~~~~~~~~~~~~~

As the name implies, in this file you register your application's routes, and
then link them to a handler.
In ``appinfo/routes.php``, add the following code:

.. code-block:: php
   
   <?php

   namespace OCA\ownnotes\AppInfo;

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
   namespace OCA\ownnotes\AppInfo;

   use \OCP\AppFramework\App;
   use \OCA\ownnotes\Controller\PageController;

   class Application extends App {
       public function __construct(array $urlParams=array()){
           parent::__construct('ownnotes', $urlParams);

           $container = $this->getContainer();
           $container->registerService('PageController', function($c) {
               return new PageController(
                   $c->query('AppName'),
                   $c->query('Request')
               );
           });
       }
   }

Create the Core File & Directory Structure
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To create these, in a new directory that will be called `ownnotes`, run the following code in your terminal, from where you want to create the new project:

.. code-block:: console
   
   mkdir -p ownnotes/{appinfo,lib/Controller}
   touch appinfo/{app,application,routes}.php appinfo/info.xml lib/Controller/PageController.php
