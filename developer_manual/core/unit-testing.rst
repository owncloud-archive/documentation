Unit-Testing
============

PHP Unit Tests
--------------

ownCloud uses PHPUnit >= 4.8 for unit testing PHP code.

Getting PHPUnit
~~~~~~~~~~~~~~~

ownCloud >= 10.0
^^^^^^^^^^^^^^^^

If you are using ownCloud 10.0 or higher, running ``make`` in your terminal from the ``webroot`` directory will prepare everything for testing.
This will install beside necessary dependencies, a local version of PHPUnit at ``<webroot>/lib/composer/phpunit/phpunit``.

- Run ``make help`` to get a list of parameters
- To update your testing environment run ``make clean`` and ``make`` again.
- Take care that the php phpunit file in the path provided has the executable permission set.


ownCloud < 10.0
^^^^^^^^^^^^^^^

If you are on any version earlier than 10.0 you have to setup PHPUnit (and run the tests) manually.
There are three ways to install it:

1. Use Composer

::

  composer require phpunit/phpunit

2. Use your package manager (if you’re using a Linux distribution)

::

  # When using a Debian-based distribution
  sudo apt-get install phpunit

3. Install it manually

::

  wget https://phar.phpunit.de/phpunit.phar
  chmod +x phpunit.phar
  sudo mv phpunit.phar /usr/local/bin/phpunit

After the installation the command ``phpunit`` is available

::

  phpunit --version

.. important::
   Please be aware that PHPUnit 6.0 and above require PHP 7.0.

And you can update it using::

  phpunit --self-update

.. note::
   This option is not supported from PHPUnit 6.0 onward. If you’re using this version or higher, please use either Composer or your package manager to upgrade to the latest version.

You can find more information in `the PHPUnit documentation`_.

Running PHP Unit tests for ownCloud >= 10.0
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

There are existing tests provided by ownCoud which are ready to run.

- Change into ``webroot`` and run ``make help`` to see tests and parameters available.

Testing apps

- To run test for a specific app with the provided PHPUnit version, change into ``<webroot>/apps/<appnname>/<testfolder>`` and call ``<webroot>/lib/composer/phpunit/phpunit/phpunit`` plus optional parameters when needed.



Writing PHP Unit tests
~~~~~~~~~~~~~~~~~~~~~~

To get started, do the following:

 - Create a directory called ``tests`` in the top level of your application
 - Create a PHP file in the directory and ``require_once`` your class which you want to test.

Then you can run the created test with ``phpunit``.

.. note::
   If you use ownCloud functions in your class under test (i.e: OC::getUser()) you'll need to bootstrap ownCloud or use dependency injection.

.. note::
   You'll most likely run your tests under a different user than the Web server. This might cause problems with your PHP settings (i.e., ``open_basedir``) and requires you to adjust your configuration.

An example for a simple test would be:

:file:`/srv/http/owncloud/apps/myapp/tests/testaddtwo.php`

.. code-block:: php

    <?php
    namespace OCA\Myapp\Tests;

    class TestAddTwo extends \Test\TestCase {
        protected $testMe;

        protected function setUp() {
            parent::setUp();
            $this->testMe = new \OCA\Myapp\TestMe();
        }

        public function testAddTwo(){
              $this->assertEquals(5, $this->testMe->addTwo(3));
        }

    }


:file:`/srv/http/owncloud/apps/myapp/lib/testme.php`

.. code-block:: php

    <?php
    namespace OCA\Myapp;

    class TestMe {
        public function addTwo($number){
            return $number + 2;
        }
    }

In :file:`/srv/http/owncloud/apps/myapp/` you run the test with::

  phpunit tests/testaddtwo.php


Make sure to extend the ``\Test\TestCase`` class with your test and always call the parent methods, when overwriting ``setUp()``, ``setUpBeforeClass()``, ``tearDown()`` or ``tearDownAfterClass()`` method from the ``TestCase``.
These methods set up important stuff and clean up the system after the test so that the next test can run without side effects, such as clearing files and entries from the file cache, etc.
For more resources on writing tests for PHPUnit visit `the writing tests section`_ of the PHPUnit documentation.

Bootstrapping ownCloud
~~~~~~~~~~~~~~~~~~~~~~
If you use ownCloud functions or classes in your code, you'll need to make them available to your test by bootstrapping ownCloud.

To do this, you'll need to provide the ``--bootstrap`` argument when running PHPUnit

:file:`/srv/http/owncloud`

::

  phpunit --bootstrap tests/bootstrap.php apps/myapp/tests/testsuite.php

If you run the test suite as a user other than your Web server, you'll have to
adjust your php.ini and file rights.

:file:`/etc/php/php.ini`

::

  open_basedir = none

:file:`/srv/http/owncloud`::

  su -c "chmod a+r config/config.php"
  su -c "chmod a+rx data/"
  su -c "chmod a+w data/owncloud.log"

Running Unit Tests for ownCloud Core
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The core project provides a script that runs all the core unit tests using the specified database backend like ``sqlite``, ``mysql``, ``pgsql``, ``oci`` (for Oracle), the default is ``sqlite``

To run tests on ``mysql`` or ``pgsql`` you need a database user called "oc_autotest" with the password "owncloud". This user needs the privilege to create and delete the database called "oc_autotest".

**MySQL setup**

- ``CREATE DATABASE oc_autotest;``
- ``CREATE USER 'oc_autotest'@'localhost' IDENTIFIED BY 'owncloud';``
- ``GRANT ALL ON oc_autotest.* TO 'oc_autotest'@'localhost';``

*for parallel executor support with EXECUTOR_NUMBER=0:* 

- ``CREATE DATABASE oc_autotest0;``
- ``CREATE USER 'oc_autotest0'@'localhost' IDENTIFIED BY 'owncloud';``
- ``GRANT ALL ON oc_autotest0.* TO 'oc_autotest0'@'localhost';``

**PGSQL setup**

- ``su - postgres``
- ``createuser -P oc_autotest`` (enter password "owncloud")
- ``psql -c 'ALTER USER oc_autotest CREATEDB;'`` (to give the user the privileged to create databases)
- to enable dropdb I decided to add following line to ``pg_hba.conf`` (this is not the safest way but fine for a testing machine): ``local	all	all	trust``

*for parallel executor support with EXECUTOR_NUMBER=0:*

- ``su - postgres``
- ``createuser -P oc_autotest0`` (enter password "owncloud")
- ``psql -c 'ALTER USER oc_autotest0 CREATEDB;'`` (to give the user the privileged to create databases)

**run tests**
::

  make test-php

To run tests only for MySQL

::

  make test-php TEST_DATABASE=mysql

To run a particular test suite

::

  make test-php TEST_DATABASE=mysql TEST_PHP_SUITE=tests/lib/share/share.php

Further Reading
~~~~~~~~~~~~~~~

- http://googletesting.blogspot.de/2008/08/by-miko-hevery-so-you-decided-to.html
- http://www.phpunit.de/manual/current/en/writing-tests-for-phpunit.html
- http://www.youtube.com/watch?v=4E4672CS58Q&feature=bf_prev&list=PLBDAB2BA83BB6588E
- Clean Code: A Handbook of Agile Software Craftsmanship (Robert C. Martin)

Unit Testing JavaScript in Core
-------------------------------

JavaScript Unit testing for **core** and **core apps** is done using the `Karma <http://karma-runner.github.io>`_ test runner with `Jasmine <http://pivotal.github.io/jasmine/>`_.

Installing Node JS
~~~~~~~~~~~~~~~~~~

To run the JavaScript unit tests you will need to install **Node JS**.
You can get it here: http://nodejs.org/
After that you will need to setup the **Karma** test environment.
The easiest way to do this is to run the automatic test script first, see next section.

Running All The Tests
~~~~~~~~~~~~~~~~~~~~~

To run all tests, just run

::

  make test-js

This will also automatically set up your test environment.

Debugging Tests in the Browser
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To debug tests in the browser, you need to run **Karma** in browser mode

::

  karma start tests/karma.config.js

From there, open the URL http://localhost:9876 in a web browser.
On that page, click on the "Debug" button.
An empty page will appear, from which you must open the browser console (F12 in Firefox/Chrome).
Every time you reload the page, the unit tests will be relaunched and will output the results in the browser console.

Unit Test File Paths
~~~~~~~~~~~~~~~~~~~~

JavaScript unit test examples can be found in :file:`apps/files/tests/js/`
Unit tests for the core app JavaScript code can be found in :file:`core/js/tests/specs`

Documentation
~~~~~~~~~~~~~

Here are some useful links about how to write unit tests with Jasmine and Sinon:

- Karma test runner: http://karma-runner.github.io
- Jasmine: http://pivotal.github.io/jasmine
- Sinon (for mocking and stubbing): http://sinonjs.org/

.. links

.. _the PHPUnit documentation: https://phpunit.de/manual/current/en/installation.html
.. _the writing tests section: http://www.phpunit.de/manual/current/en/writing-tests-for-phpunit.html


UI testing in Core with selenium
--------------------------------

Requirements:
~~~~~~~~~~~~~
- ownCloud >= 10.0 (make sure you have an running instance of ownCloud completely setup)
- default language set to "en" (in ``config/config.php`` set ``'default_language' => 'en',``)
- skeletondirectory set to ``<owncloud-base-folder>/tests/ui/skeleton``
- An admin user called "admin" with the password "admin"
- no self-signed SSL certificates
- testing utils (running ``make`` in your terminal from the ``webroot`` directory will install them)
- Selenium standalone server (download Selenium standalone server jar from http://docs.seleniumhq.org/download/)
- browser installed that you would like to test on
- webdriver for the browsers you want to test (e.g. download the chromedriver from: https://sites.google.com/a/chromium.org/chromedriver/ , firefox webdriver is included in the selenium server)

Set Up test
~~~~~~~~~~~
- place the selenium standalone server jar file and the webdriver(s) somewhere in the same folder
- start the selenium server ``java -jar selenium-server-standalone-3.0.1.jar -port 4445``
- set the following environment variables:
  - ``SRV_HOST_NAME`` (the hostname where ownCloud runs)
  - ``SRV_HOST_URL`` (path if ownCloud does not run in the root of the host)
  - ``SRV_HOST_PORT`` (port of your webserver)
  - ``BROWSER`` (chrome, firefox, internet explorer)

  e.g. to test an instance running on http://localhost/owncloud-core with chrome do:

  ::

    export SRV_HOST_NAME=localhost
    export SRV_HOST_URL=owncloud-core
    export SRV_HOST_PORT=80
    export BROWSER=chrome


- if you don't have a webserver already running start the PHP development server with:
  ``bash tests/travis/start_php_dev_server.sh`` (leave SRV_HOST_URL empty in that case. ``export SRV_HOST_URL=""``)
  The server will bind to: ``$SRV_HOST_NAME:$SRV_HOST_PORT``
- run the tests: ``bash tests/travis/start_behat_tests.sh``

  The tests need to be run as the same user who is running the webserver and this user must be also owner of the config file (``config/config.php``)
  To run the tests as user that is different to your current terminal user use ``sudo -E -u <username>`` e.g. to run as 'www-data' user ``sudo -E -u www-data bash tests/travis/start_behat_tests.sh``

Known issues
~~~~~~~~~~~~

- the webdriver for the current version of Firefox is not working correctly, so we need to test on 47.0.2 and to use selenium server 2.53.1 for it
  - download and install version 47.0.2 of Firefox from here: https://ftp.mozilla.org/pub/firefox/releases/47.0.2/
  - download version 2.53.2 of selenium webdriver from here: https://selenium-release.storage.googleapis.com/index.html?path=2.53/
