================
Acceptance Tests
================

The Test Directory Structure
----------------------------

This is the structure of the acceptance directory inside `the core repository's`_ ``tests`` directory:

.. code-block:: bash

    tests
    ├── acceptance
    │   ├── config
    │   │   └── behat.yml
    │   ├── data
    │   │   └── textfile.txt
    │   ├── features
    │   │   ├── apiMain (suite of acceptance test features)
    │   │   │   └── feature files for the suite (behat gherkin files)
    │   │   └── bootstrap
    │   │       └── Contexts and traits (php files)
    │   ├── run.sh
    │   └── skeleton

Here’s a short description of each component of the directory.

``config/``
~~~~~~~~~~~

This directory contains ``behat.yml`` which sets up the acceptance tests.
In this file we can add new contexts and new features.
Here's an example configuration:

::

    default:
      autoload:
        '': %paths.base%/../features/bootstrap
      suites:
        apiMain:
          paths:
            - %paths.base%/../features/apiMain
          contexts:
            - FeatureContext: &common_feature_context_params
                baseUrl:  http://localhost:8080
                adminUsername: admin
                adminPassword: admin
                regularUserPassword: 123456
                ocPath: ../../
            - CardDavContext:
            - CalDavContext:
            - AppManagementContext:

``data/``
~~~~~~~~~

This folder can be used in tests to store temporary data.

``features/``
~~~~~~~~~~~~~

This directory stores `Behat's feature files`_. 
These contain Behat's test cases, called scenarios, which use the Gherkin language.
Features are grouped into suites. The features for a suite are stored in a folder like ``features/apiMain``.

``features/bootstrap``
~~~~~~~~~~~~~~~~~~~~~~

This folder contains all the Behat contexts. 
Contexts contain the PHP code required to run Behat's scenarios. 
The contexts needed by each suite are listed in ``behat.yml``.

``run.sh``
~~~~~~~~~~
  
This script runs the test suites.
To use it we need to run it as the web server user, which is normally ``www-data`` or ``apache``.

``skeleton/``
~~~~~~~~~~~~~

This folder stores the initial files loaded for a new user.

How to Add a New Feature
------------------------

Creation of a new feature file is recommended when the task being tested is independent enough from the existing features.
In this section, we'll step through the creation of a hypothetical feature.

The first thing we need to do is create a new file for the context; we'll name it TaskToTestContext.php.
In the file, we'll add the code snippet below:

.. code-block:: php

    <?php

    use Behat\Behat\Context\Context;
    use Behat\Behat\Context\SnippetAcceptingContext;

    require __DIR__ . '/../../vendor/autoload.php';

    /**
     * Example Context.
     */
    class ExampleContext implements Context, SnippetAcceptingContext {
      use Webdav;
    }

Each scenario relating to the new feature being tested should be added here.
To add a function to run as a scenario step, do the following:

- Use a ``@When``, ``@Given``, or ``@Then`` statement at the beginning.
- For parameters you could use either regular expressions or use a ``:variable``. But, using colons is preferred.
- Document all the parameters of the function and their expected type.
- Be careful to write the exact sentence that you will write in the gherkin code. Behat won't parse it properly otherwise.


Here’s example code for a scenario:

.. code-block:: php

  /**
   * @When Sending a :method to :url with requesttoken
   *
   * @param string $method
   * @param string $url
   */
  public function exampleFunction($method, $url) {


Following this, add a new feature file in the ``features/`` folder structure.
The name should be in the format: ``<task-to-test>.feature``.
The content of this file should be Gherkin code. 
You can use all the sentences available in the rest of the core contexts, just use the appropriate trait in your context.

For example "use Webdav;" for using WebDAV related functions.
Lets show an example of a feature file with scenarios:

.. code-block:: yaml

    Feature: provisioning
      Background:
        Given using OCS API version "1"

      Scenario: Getting an not existing user
        When user "admin" sends HTTP method "GET" to OCS API endpoint "/cloud/users/test"
        Then the OCS status code should be "998"
        And the HTTP status code should be "200"

- ``Feature``: gives the feature its name, in this case: ``provisioning``.
- ``Background``: gives contextual information on assumptions which the feature makes, what it relates to, and other aspects so that the scenario can be properly understood.
- ``Scenario``: contains the core information about a test scenario in human-readable language, so that you can understand what the code will have to do for the scenario to have been successfully implemented. 

A scenario requires three parts, ``"Given"``, ``"When"``, and ``"Then"`` sections. 
``"Given"`` and ``"Then"`` can have several sentences joined together by ``"And"``, but ``"When"`` statements should just have one.
And this should be the functionality to test.
The other parts are preconditions and post-conditions of the test. 

To be able to run your new feature tests you'll have to add a new context to ``config/behat.yml`` file.
To do so, in the ``contexts`` section add your new context:

::

    contexts:
          - FeatureContext: *common_feature_context_params
          - TaskToTestContext:

After the name, add any variables required for your context; you likely will not need any.
With that done, we're now ready to run the tests.

Preparing to Run Acceptance Tests
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This is a concise guide to running acceptance tests on ownCloud 10.0.
Before you can do so, you need to meet a few prerequisites available; these are

- ownCloud 
- Composer 
- MySQL

In ``php.ini`` on your system, set ``opcache.revalidate_freq=0`` so that changes made to ownCloud ``config.php`` by test scenarios are implemented immediately.

After cloning core, run ``make`` as your webserver's user in the root directory of the project.

.. NOTE: 
   Having a clean database is a also good idea.

Now that the prerequisites are satisfied, and assuming that ``$installation_path`` is the location where you cloned the ``ownCloud/core`` repository, the following commands will prepare the installation for running the acceptance tests.

.. code-block:: bash

    # Remove current configuration (if existing)
    sudo rm -rf $installation_path/data/*
    sudo rm -rf $installation_path/config/*
    
    # Remove existing 'owncloud' database 
    mysql -u root -h localhost -e "drop database owncloud"
    mysql -u root -h localhost -e "drop user oc_admin"
    mysql -u root -h localhost -e "drop user oc_admin@localhost"
    
    # Install owncloud server with the cli
    sudo -u www-data $installation_path/occ maintenance:install \
      
      --database='mysql' --database-name='owncloud' --database-user='root' \
      --database-pass='' --admin-user='admin' --admin-pass='admin'

Types of Acceptance Tests
~~~~~~~~~~~~~~~~~~~~~~~~~

There are 3 types of acceptance tests; API, CLI and webUI.

- API tests test the ownCloud public APIs.
- CLI tests test the ``occ`` command-line commands.
- webUI tests test the browser-based user interface.

webUI tests require an additional environment to be set up.
See the UI testing documentation for more information.
API and CLI tests are run by using the ``test-acceptance-api`` and ``test-acceptance-cli`` make commands.

Running Acceptance Tests for a Suite
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Run a command like the following:

.. code-block:: bash

  sudo -u www-data make test-acceptance-api BEHAT_SUITE=apiTags
  sudo -u www-data make test-acceptance-cli BEHAT_SUITE=cliProvisioning

Running Acceptance Tests for a Feature
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Run a command like the following:

.. code-block:: bash

  sudo -u www-data make test-acceptance-api BEHAT_FEATURE=tests/acceptance/features/apiTags/createTags.feature
  sudo -u www-data make test-acceptance-cli BEHAT_FEATURE=tests/acceptance/features/cliProvisioning/addUser.feature

Running Acceptance Tests for a Tag
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Some test scenarios are tagged. For example, tests that are known to fail and are awaiting fixes are tagged ``@skip``.
To run test scenarios with a particular tag:

.. code-block:: bash

  sudo -u www-data make test-acceptance-api BEHAT_SUITE=apiTags BEHAT_FILTER_TAGS=@skip
  sudo -u www-data make test-acceptance-cli BEHAT_SUITE=cliProvisioning BEHAT_FILTER_TAGS=@skip

Displaying the ownCloud Log
~~~~~~~~~~~~~~~~~~~~~~~~~~~

It can be useful to see the tail of the ownCloud log when the test run ends. To do that, specify ``SHOW_OC_LOGS``:

.. code-block:: bash

  sudo -u www-data make test-acceptance-api BEHAT_SUITE=apiTags SHOW_OC_LOGS=true

Optional Environment Variables
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you want to use an alternative home name using the ``env`` variable add to the execution ``OC_TEST_ALT_HOME=1``, as in the following example:

::

  sudo -u www-data make test-acceptance-api BEHAT_SUITE=apiTags OC_TEST_ALT_HOME=1

If you want to have encryption enabled add ``OC_TEST_ENCRYPTION_ENABLED=1``, as in the following example:

::

  sudo -u www-data make test-acceptance-api BEHAT_SUITE=apiTags OC_TEST_ENCRYPTION_ENABLED=1

For more information on Behat, and how to write acceptance tests using it, check out `the online documentation`_.

.. Links
   
.. _the core repository's: https://github.com/owncloud/core
.. _Behat's feature files: http://docs.behat.org/en/v2.5/guides/1.gherkin.html
.. _the online documentation: http://behat.org/en/latest/guides.html
