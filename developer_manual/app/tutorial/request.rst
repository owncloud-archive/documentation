======================
The Request Life Cycle
======================

.. sectionauthor:: Bernhard Posselt <dev@bernhard-posselt.com>, Morris Jobke <hey@morrisjobke.de>

Before we dive in to creating an application, it’s important to have an overview of how the request life cycle of an ownCloud application works.

If you are not interested in the internals or don't want to execute anything before and after your controller, feel free to skip this section and continue directly with defining :doc:`your app's routes <../fundamentals/routes>`.

As with other web-based applications, it’s centered around an HTTP request, which typically consists of the following, four, components:

* **A URL**: e.g. ``/index.php/apps/myapp/something``
* **Request Parameters**: e.g. ``?something=true&name=tom``
* **A Method**: e.g. ``GET``
* **Request headers**: e.g. ``Accept: application/json``

These requests are, in turn, handled by five ownCloud components:

- `The Front Controller`_
- `The Router`_
- `Middleware`_
- `The Dependency Injection Container`_
- `The Controller`_

The Front Controller
--------------------

All requests are sent to ownCloud's Front Controller: :file:`index.php`, which in turn executes :file:`lib/base.php`. 
This file: 

- Inspects the HTTP headers
- Abstracts away differences between different web servers
- Initializes the core classes 

Following this, ownCloud then loads its core applications; these are:

* The authentication backends
* The filesystem handler
* The logging handler

With these three applications loaded, the remaining initialization steps are then executed. 
These are:

- Attempt to authenticate the user is made.
- Load and execute all the remaining applications' main files. 

  To do this, the application’s :ref:`main file <appinfo_info_xml_label>` (``appinfo/app.php``) is loaded and executed. 
  If you want to execute code before your application is loaded, you need to place code in your app's main file.

- Load all the routes in the applications' :file:`appinfo/routes.php`.
- Execute the router.

With the setup completed, ownCloud then handles the user's request.

The Router
----------

The router:

- Parses the application's :doc:`routing <../fundamentals/routes>` configuration file: :file:`appinfo/routes.php`
- Inspects the request's method and URL 
- Retrieves the handling :doc:`controller <../fundamentals/controllers>` from the :doc:`../fundamentals/container`
- Passes control to the dispatcher 

The dispatcher:

- Handles the requested routes by running hooks, called `Middleware`_, before and after invoking the controller which handles the route
- Executes the controller method
- Renders the request's output

Middleware
----------

:doc:`Middleware <../fundamentals/middleware>` is a convenient way to execute common tasks, such as custom authentication, before or after a :doc:`controller method <../fundamentals/controllers>` is executed. 
You can execute middleware at the following locations:

* Before calling the controller method
* After calling the controller method
* After an exception is thrown (also if it is thrown from middleware, e.g., if an authentication request fails)
* Before the output is rendered

The Dependency Injection Container
----------------------------------

The :doc:`Dependency Injection (DI) container <../fundamentals/container>` is where you define all the services (or dependencies) that your application will need; in particular, all of your application's controllers. 
A key benefit of DI containers is that they handle all dependency instantiation. 
This means that you no longer have to rely on either globals or singletons. 

The Controller
--------------

The :doc:`controller <../fundamentals/controllers>` contains the code that you actually want to run when a request has come in. 
Think of it like a callback that is executed if everything before went fine. 
The controller collects all the information necessary to perform the request, such as from the route and environment, and returns a response.

This response is then run through follow-up middleware (``afterController`` and ``beforeOutput``) for final processing.
When those steps are complete, HTTP headers are then set along with the body of the response to the client.
