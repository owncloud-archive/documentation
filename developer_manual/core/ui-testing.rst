======================
User Interface Testing
======================

Testing in Core with Selenium
-----------------------------

Requirements
~~~~~~~~~~~~

- ownCloud >= 10.0. Make sure you have an running instance of ownCloud `completely setup <https://doc.owncloud.com/server/latest/admin_manual/installation/>`_.
- Default language set to ``en`` (in ``config/config.php`` set ``'default_language' => 'en',``).
- ``skeletondirectory`` set to ``<owncloud-base-folder>/tests/ui/skeleton``.
- An admin user called ``admin`` with the password ``admin``.
- No self-signed SSL certificates.
- Testing utils (running ``make`` in your terminal from the ``webroot`` directory will install them).
- `Selenium standalone server <http://docs.seleniumhq.org/download/>`_.
- Browser installed that you would like to test on.
- Web driver for the browsers that you want to test. You can download the Chrome driver from: https://sites.google.com/a/chromium.org/chromedriver/. The Firefox web driver is included in the selenium server.

Set Up Test
~~~~~~~~~~~

- Place the Selenium standalone server jar file and the web driver(s) somewhere in the same folder.
- Start the Selenium server ``java -jar selenium-server-standalone-3.0.1.jar -port 4445``.
- Set the following environment variables:

  - ``SRV_HOST_NAME`` (the hostname where ownCloud runs)
  - ``SRV_HOST_URL`` (path if ownCloud does not run in the root of the host)
  - ``SRV_HOST_PORT`` (port of your webserver)
  - ``BROWSER`` (chrome, firefox, internet explorer)

  e.g., to test an instance running on http://localhost/owncloud-core with Chrome do:

  .. code-block:: console

    export SRV_HOST_NAME=localhost
    export SRV_HOST_URL=owncloud-core
    export SRV_HOST_PORT=80
    export BROWSER=chrome

- If you don't have a webserver already running start the PHP development server with:
  ``bash tests/travis/start_php_dev_server.sh`` (leave SRV_HOST_URL empty in that case. ``export SRV_HOST_URL=""``).
  The server will bind to: ``$SRV_HOST_NAME:$SRV_HOST_PORT``.
- Run the tests: ``bash tests/travis/start_behat_tests.sh``.

The tests need to be run as the same user who is running the webserver and this user must be also owner of the config file (``config/config.php``).
To run the tests as user that is different to your current terminal user use ``sudo -E -u <username>`` e.g. to run as 'www-data' user ``sudo -E -u www-data bash tests/travis/start_behat_tests.sh``.

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

- The web driver for the current version of Firefox is not working correctly, so we need to test on 47.0.2 and to use selenium server 2.53.1 for it

  - `Download and install version 47.0.2 of Firefox <https://ftp.mozilla.org/pub/firefox/releases/47.0.2/>`_. 
  - `Download version 2.53.2 of the Selenium web driver <https://selenium-release.storage.googleapis.com/index.html?path=2.53/>`_.
