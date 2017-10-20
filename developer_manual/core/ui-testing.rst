======================
User Interface Testing
======================

Testing in Core with Selenium
-----------------------------

Requirements
~~~~~~~~~~~~

- ownCloud >= 10.0. Make sure you have a running instance of ownCloud `completely setup <https://doc.owncloud.com/server/latest/admin_manual/installation/>`_.
- Default language set to ``en`` (in ``config/config.php`` set ``'default_language' => 'en',``).
- An admin user called ``admin`` with the password ``admin``.
- No self-signed SSL certificates.
- Testing utils (running ``make`` in your terminal from the ``webroot`` directory will install them).
- `Selenium standalone server <http://docs.seleniumhq.org/download/>`_ version 3.6.0 or newer.
- Browser installed that you would like to test on.
- `Web driver for the browsers that you want to test <http://www.seleniumhq.org/download/#thirdPartyDrivers>`_.

Overview
~~~~~~~~

Tests are divided into suites, enabling each suite to test some logical portion of the functionality
and for the total elapsed run-time of a single suite to be reasonable (up to about 30 minutes).
Smaller apps may have all tests in a single suite.

Each suite consists of a number of features. Each feature is described in a ``*.feature`` file.
There are a number of scenarios in each feature file. Each scenario has a number of scenario steps
that define the steps taken to do the test.

Set Up Test
~~~~~~~~~~~

- Place the Selenium standalone server jar file and the web driver(s) somewhere in the same folder.
- Start the Selenium server:

.. code-block:: console

    java -jar selenium-server-standalone-3.6.0.jar -port 4445 -enablePassThrough false

- Set the following environment variables:

  - ``SRV_HOST_NAME`` (The hostname where ownCloud runs)
  - ``REMOTE_FED_SRV_HOST_NAME`` (An alternative hostname for federation share tests. This should be another IP/hostname on the same server)
  - ``SRV_HOST_URL`` (The path, if ownCloud does not run in the root of the host)
  - ``REMOTE_FED_SRV_HOST_URL`` (The path, if the alternative ownCloud for federation share tests does not run in the root of the host)
  - ``SRV_HOST_PORT`` (The port of your webserver)
  - ``REMOTE_FED_SRV_HOST_PORT`` (The alternative port of your webserver for federation share tests. This should be another port on the same server)
  - ``BROWSER`` (Any one of ``chrome``, ``firefox``, ``internet explorer``)
  - ``BROWSER_VERSION`` (version of the browser you are using)

  e.g., to test an instance running on http://localhost/owncloud-core with Chrome do:

  .. code-block:: console

    export SRV_HOST_NAME=localhost
    export SRV_HOST_URL=owncloud-core
    export SRV_HOST_PORT=80
    export BROWSER=chrome
    export BROWSER_VERSION="60.0"
    
- If you don't have a webserver already running, leave SRV_HOST_URL empty ( ``export SRV_HOST_URL=""`` ), and start the PHP development server with:

.. code-block:: console

  bash tests/travis/start_php_dev_server.sh

The server will bind to: ``$SRV_HOST_NAME:$SRV_HOST_PORT``.

- Run the tests:

.. code-block:: console

  bash tests/travis/start_behat_tests.sh

The tests need to be run as the same user who is running the webserver and this user must be also owner of the config file (``config/config.php``).
To run the tests as user that is different to your current terminal user use ``sudo -E -u <username>`` e.g. to run as 'www-data' user ``sudo -E -u www-data bash tests/travis/start_behat_tests.sh``.

Running UI Tests using IPv6
~~~~~~~~~~~~~~~~~~~~~~~~~~~

The test system must have (at least locally) functioning IPv6:

- working loopback address ::1
- a "real" routable IPv6 address (not just a link-local address)

If you have a server set up that listens on both IPv4 and IPv6 (e.g. localhost on 127.0.0.1 and ::1) 
then the UI tests will access the server via whichever protocol your operating system prefers. 
If there are tests that specifically specify IPv4 or IPv6, then those will choose a suitable local 
address to come from so that they access the server using the required IP version.

If you are using the PHP dev server, then before starting it, in addition to the exports in the Set Up Test section, 
specify where the IPv6 server should listen:

.. code-block:: console

  export IPV6_HOST_NAME=ip6-localhost

Then both IPv4 and IPv6 PHP dev servers will be started by the script:

.. code-block:: console

  bash tests/travis/start_php_dev_server.sh

If you want the tests to drive the UI over IPv6, then export an IPv6 name or address for ``SRV_HOST_NAME``
and an IPv4 name or address for ``IPV4_HOST_NAME``:

.. code-block:: console

  export SRV_HOST_NAME=ip6-localhost
  export IPV4_HOST_NAME=localhost

Because not everyone will have functional IPv6 on their test system yet, tests that specifically 
require IPv6 are tagged ``@skip @ipv6``. To run those tests, follow the section below on running 
skipped tests and specify ``--tags @ipv6``.

Running UI Tests for One Suite
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can run the UI tests for just a single suite by specifying the suite name:

.. code-block:: console

  bash tests/travis/start_behat_tests.sh --suite files
  
The names of suites are found in the ``behat.yml`` file.

Running UI Tests for One Feature
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can run the UI tests for just a single feature by specifying the feature file:

.. code-block:: console

  bash tests/travis/start_behat_tests.sh --feature tests/ui/features/other/login.feature

To run just a single scenario within a feature, specify the line number of the scenario:

.. code-block:: console

  bash tests/travis/start_behat_tests.sh --feature tests/ui/features/other/login.feature:<linenumber>

Running UI Tests for an App
~~~~~~~~~~~~~~~~~~~~~~~~~~~

With the app installed, run the UI tests for the app by specifying the location of the app's ``behat.yml`` config file:

.. code-block:: console

  bash tests/travis/start_behat_tests.sh --config apps/files_texteditor/tests/ui/config/behat.yml

Run UI the tests for just a single feature of the app by also specifying the feature file:

.. code-block:: console

  bash tests/travis/start_behat_tests.sh --config apps/files_texteditor/tests/ui/config/behat.yml --feature apps/files_texteditor/tests/ui/features/createtextfile.feature

Skipping Tests
~~~~~~~~~~~~~~

If a UI test is known to fail because of an existing bug, then it is left in the test set *but* is skipped by default.
Skip a test by tagging it ``@skip`` and then put another tag with text that describes the reason it is skipped. e.g.,:

.. code-block:: console

  @skip @quota-should-not-be-set-to-invalid-values-issue-1234
  Scenario Outline: change quota to an invalid value

Skipped tests are listed at the end of a default UI test run.
You can locally run the skipped test(s). 
Run all skipped tests with:

.. code-block:: console

   bash tests/travis/start_behat_tests.sh --tags @skip

Or run just a particular test by using its unique tag:

.. code-block:: console

  bash tests/travis/start_behat_tests.sh --tags @quota-should-not-be-set-to-invalid-values-issue-1234

When fixing the bug, remove these skip tags in the PR along with the bug fix code.

Known Issues
~~~~~~~~~~~~
- Tests that are known not to work in specific browsers are tagged e.g. ``@skipOnFIREFOX47+`` or ``@skipOnINTERNETEXPLORER`` and will be skipped by the script automatically

- The web driver for the current version of Firefox works differently to the old one. If you want to test FF < 56 you need to test on 47.0.2 and to use selenium server 2.53.1 for it

  - `Download and install version 47.0.2 of Firefox <https://ftp.mozilla.org/pub/firefox/releases/47.0.2/>`_. 
  - `Download version 2.53.2 of the Selenium web driver <https://selenium-release.storage.googleapis.com/index.html?path=2.53/>`_.
