.. _appindex:

.. sectionauthor:: Bernhard Posselt <dev@bernhard-posselt.com>


.. toctree::
   :maxdepth: 2
   :hidden:

   changelog
   tutorial
   startapp
   init
   info
   classloader
   request
   routes
   middleware
   container
   controllers
   api
   templates
   js
   css
   l10n
   schema
   database
   configuration
   filesystem
   users
   two-factor-provider
   extstorage
   hooks
   backgroundjobs
   logging
   testing
   publishing
   code_signing

===============
App Development
===============
.. sectionauthor:: Bernhard Posselt <dev@bernhard-posselt.com>

Introduction
============

Before you start, please check if there already is a similar app in the `ownCloud Marketplace <https://marketplace.owncloud.com/>`_, or an official `ownCloud app <https://marketplace.owncloud.com/publishers/owncloud>`_ (see Apps Repo and Other app repos) that you could contribute to. Also, feel free to communicate your idea and plans to the `user mailing list <https://mailman.owncloud.org/mailman/listinfo/user>`_ or `developer mailing list <https://mailman.owncloud.org/mailman/listinfo/devel>`_ so other contributors might join in.

Then, please make sure you have set up a development environment:

* :doc:`../general/devenv`

Before starting to write an app please read the security and coding guidelines:

* :doc:`../general/security`
* :doc:`../general/codingguidelines`

After this you can start with the tutorial

* :doc:`tutorial`

Once you are ready for publishing, check out the ownCloud Marketplace process:

* :doc:`publishing`

For enhanced security it is also possible to sign your code:

* :doc:`code_signing`

App development
===============
Take a look at the changes in this version:

* :doc:`changelog`

Create a new app:

* :doc:`startapp`

Inner parts of an app:

* :doc:`init`
* :doc:`info`
* :doc:`classloader`

Requests
--------
How a request is being processed:

* :doc:`request`
* :doc:`routes`
* :doc:`middleware`
* :doc:`container`
* :doc:`controllers` | :doc:`api`

View
----
The app's presentation layer:

* :doc:`templates`
* :doc:`js`
* :doc:`css`
* :doc:`l10n`

Storage
-------
Create database tables, run SQL queries, store/retrieve configuration information and access the filesystem:

* :doc:`schema`
* :doc:`database`
* :doc:`configuration`
* :doc:`filesystem`
* :doc:`extstorage`
* :doc:`custom-storage-backend`
* :doc:`custom-cache-backend`

Authentication & Users
----------------------
Creating, deleting, updating, searching, login and logout:

* :doc:`users`

Writing a two-factor auth provider:

* :doc:`two-factor-provider`

Hooks
-----
Listen on events like user creation and execute code:

* :doc:`hooks`

Background Jobs
---------------
Periodically run code in the background:

* :doc:`backgroundjobs`

Logging
-------
Log to the :file:`data/owncloud.log`:

* :doc:`logging`

Testing
-------
Write automated tests to ensure stability and ease maintenance:

* :doc:`testing`

PHPDoc Class Documentation
--------------------------
ownCloud class and function documentation:

* `ownCloud App API <https://api.owncloud.org/namespaces/OCP.html>`_
