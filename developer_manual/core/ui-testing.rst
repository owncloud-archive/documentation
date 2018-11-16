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
- The testing app installed and enabled.
- Testing utils (running ``make`` in your terminal from the ``webroot`` directory will install them).
- `Docker CE Installed`_
- `Docker Post-install`_ done to put your developer account in the docker group so you can run Docker without ``sudo``
- Docker subnet enabled for any firewall that may be active such as, `ufw`_. The example below shows how to update ufw's firewall rules to allow the ``172.17.0.0/16`` Docker subnet:

  .. code-block:: console

    sudo ufw status
    sudo ufw allow from 172.17.0.0/16

- Docker containers pulled. It is recommended to use ``standalone-chrome-debug`` which allows seeing the browser live. You will also need `MailHog`_. Pull any or all of these Docker containers:

  .. code-block:: console

    docker pull selenium/standalone-chrome
    docker pull selenium/standalone-chrome-debug
    docker pull selenium/standalone-firefox
    docker pull selenium/standalone-firefox-debug
    docker pull mailhog/mailhog

- A ``vnc`` viewer installed (in order to view the browser action as the UI tests run). For example:

  .. code-block:: console

    sudo apt install tigervnc-viewer

- To run the `Selenium server`_ locally (not in Docker) see the notes at the end.

Overview
~~~~~~~~

Tests are divided into suites, enabling each suite to test some logical portion of the functionality and for the total elapsed run-time of a single suite to be reasonable (up to about 40 minutes on Travis-CI, about 10 minutes on drone).
Elapsed run-time on a local developer system is very dependent on the IO as well as CPU performance.
Smaller apps may have all tests in a single suite.

Each suite consists of a number of features. Each feature is described in a ``*.feature`` file.
There are a number of scenarios in each feature file. Each scenario has a number of scenario steps
that define the steps taken to do the test.

Set Up Test
~~~~~~~~~~~

- Start the Selenium Docker container in a terminal:

  .. code-block:: console

    docker run -p 4445:4444 -p 5900:5900 -v /dev/shm:/dev/shm selenium/standalone-chrome-debug

  Ports on the Selenium Docker IP address are mapped to ``localhost`` so they can be accessed by the tests and the ``vnc`` viewer.

- Start the MailHog Docker container in another terminal:

  .. code-block:: console

    docker run -p 1025:1025 -p 8025:8025 mailhog/mailhog

  Ports on the MailHog docker IP address are mapped to ``localhost`` so they can be accessed by the tests.

  By running these in terminal windows, it is simple to press ``ctrl-C`` to stop them when you are finished.

- Set the following environment variables:

  - ``TEST_SERVER_URL`` (The URL of your webserver)
  - ``TEST_SERVER_FED_URL`` (The alternative URL of your webserver for federation share tests.)
  - ``BROWSER`` (Any one of ``chrome``, ``firefox``, ``internet explorer`` or ``MicrosoftEdge``. Defaults to ``chrome``)
  - ``BROWSER_VERSION`` (version of the browser you want to use - optional)

  e.g., to test an instance running on the Docker subnet with Chrome do:

  .. code-block:: console

    export TEST_SERVER_URL=http://172.17.0.1:8080/owncloud-core
    export TEST_SERVER_FED_URL=http://172.17.0.1:8180/owncloud-core
    export BROWSER=chrome

- If your ownCloud install is running locally on Apache, then it should already be available on the Docker subnet at ``172.17.0.1``

- To run the federation Sharing tests:

  1. Make sure you have configured HTTPS with valid certificates on both servers URLs
  2. `Import SSL certificates <https://doc.owncloud.org/server/latest/admin_manual/configuration/server/import_ssl_cert.html>`_ (or do not offer HTTPS).

- Run a suite of tests:

  .. code-block:: console

    make test-acceptance-webui BEHAT_SUITE=webUILogin

  The names of suites are found in the ``tests/acceptance/config/behat.yml`` file, and start with ``webUI``.

  The tests may need to be run as the same user who is running the webserver and this user must also be the owner of the config file (``config/config.php``).
  To run the tests as a user that is different to your current terminal user run ``sudo -E -u <username>``. For example, to execute the script as as ``www-data``, run ``sudo -E -u www-data make test-acceptance-webui BEHAT_SUITE=webUILogin``.

- The browser for the tests runs inside the Selenium docker container. View it by running the ``vnc`` viewer:

  .. code-block:: console

    vncviewer

  And connect to ``localhost``. The VNC password of the docker container is ``secret``.

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

Running UI Tests for One Feature
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can run the UI tests for just a single feature by specifying the feature file:

.. code-block:: console

  make test-acceptance-webui BEHAT_FEATURE=tests/acceptance/features/webUITrashbin/trashbinDelete.feature

To run just a single scenario within a feature, specify the line number of the scenario:

.. code-block:: console

  make test-acceptance-webui BEHAT_FEATURE=tests/acceptance/features/webUITrashbin/trashbinDelete.feature:<linenumber>

Running UI Tests for an App
~~~~~~~~~~~~~~~~~~~~~~~~~~~

With the app installed, run the UI tests for the app from the app root folder:

.. code-block:: console

  cd apps/files_texteditor
  ../../tests/acceptance/run.sh --suite webUITextEditor

Run UI the tests for just a single feature of the app by specifying the feature file:

.. code-block:: console

  cd apps/files_texteditor
  ../../tests/acceptance/run.sh tests/acceptance/features/webUITextEditor/editTextFiles.feature

Skipping Tests
~~~~~~~~~~~~~~

If a UI test is known to fail because of an existing bug, then it is left in the test set *but* is skipped by default.
Skip a test by tagging it ``@skip`` and then put another tag with text that describes the reason it is skipped. e.g.,:

.. code-block:: console

  @skip @trashbin-restore-problem-issue-1234
  Scenario: restore a single file from the trashbin

Skipped tests are listed at the end of a default UI test run.
You can locally run the skipped test(s).
Run all skipped tests for a suite with:

.. code-block:: console

  make test-acceptance-webui BEHAT_SUITE=webUITrashbin BEHAT_FILTER_TAGS=@skip

Or run just a particular test by using its unique tag:

.. code-block:: console

  make test-acceptance-webui BEHAT_SUITE=webUITrashbin BEHAT_FILTER_TAGS=@trashbin-restore-problem-issue-1234

When fixing the bug, remove these skip tags in the PR along with the bug fix code.

Additional Command Options
~~~~~~~~~~~~~~~~~~~~~~~~~~

Running all test suites in a single run is not recommended.
It will take more than 1 hour on a typical development system.
However, you may run all UI tests with:

.. code-block:: console

  make test-acceptance-webui

By default, any test scenarios that fail are automatically rerun once.
This minimizes transient failures caused by browser and Selenium driver timing issues.
When developing tests it can be convenient to override this behavior.
To not rerun failed test scenarios:

.. code-block:: console

  make test-acceptance-webui NORERUN=true BEHAT_SUITE=webUILogin

Local Selenium Setup
~~~~~~~~~~~~~~~~~~~~

You may optionally run the Selenium server locally.
Docker is now the recommended way, but local Selenium is also possible:

- `Selenium standalone server <http://docs.seleniumhq.org/download/>`_ e.g. version 3.12.0 or newer.
- Browser installed that you would like to test on (e.g. chrome)
- `Web driver for the browser that you want to test <http://www.seleniumhq.org/download/#thirdPartyDrivers>`_.
- Place the Selenium standalone server jar file and the web driver(s) somewhere in the same folder.
- Start the Selenium server:

  .. code-block:: console

    java -jar selenium-server-standalone-3.12.0.jar -port 4445 -enablePassThrough false

- In this configuration, the tests will continually open the browser-under-test on your local system.

- If you run any test scenarios that need MailHog (to test password reset etc.), then you need to run the MailHog Docker container. That is much simpler than trying to configure MailHog on your local system.

Known Issues
~~~~~~~~~~~~
- Tests that are known not to work in specific browsers are tagged e.g. ``@skipOnFIREFOX`` or ``@skipOnINTERNETEXPLORER`` and will be skipped by the script automatically

- The web driver for the current version of Firefox works differently to the old one. If you want to test FF < 56 you need to test on 47.0.2 and to use Selenium server 2.53.1 for it

  - `Download and install version 47.0.2 of Firefox <https://ftp.mozilla.org/pub/firefox/releases/47.0.2/>`_.
  - `Download version 2.53.2 of the Selenium web driver <https://selenium-release.storage.googleapis.com/index.html?path=2.53/>`_.

.. Links

.. _Docker CE Installed: https://docs.docker.com/install/linux/docker-ce/ubuntu/
.. _Docker Post-install: https://docs.docker.com/install/linux/linux-postinstall/
.. _ufw: https://help.ubuntu.com/community/UFW
.. _MailHog: https://github.com/mailhog/MailHog
.. _Selenium server: https://www.seleniumhq.org
