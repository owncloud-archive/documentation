=================
Integration Tests
=================

The Test Directory Structure
----------------------------

This is the structure of integration directory inside `the core repository's`_ ``tests`` directory:

.. code-block:: bash

    tests
    ├── integration
    │   ├── composer.json
    │   ├── composer.lock
    │   ├── config
    │   │   └── behat.yml
    │   ├── data
    │   │   └── textfile.txt
    │   ├── features
    │   │   ├── feature files (behat gherkin files)
    │   │   └── bootstrap
    │   │       └── Contexts and traits (php files)
    │   ├── federation_features
    │   │   └── federated.feature (feature on a separated context)
    │   ├── run.sh
    │   ├── vendor

Here’s a short description of each component of the directory.

``composer.json`` and ``composer.lock``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

These files store the required dependencies for the integration tests. This can include libraries such as sabredav, guzzle, or behat.

``config/``
~~~~~~~~~~~

This directory contains ``behat.yml`` which sets up the integration tests.
In this file we can add new contexts and new features.
Here's an example configuration:

.. code-block:: yaml

    default:
      autoload:
        '': %paths.base%/../features/bootstrap
      suites:
        default:
          paths:
            + %paths.base%/../features
          contexts:
            + FeatureContext:
                baseUrl:  http://localhost:8080/ocs/
                admin:
                  + admin
                  + admin
                regular_user_password: 123456
            + CommentsContext:
                baseUrl: http://localhost:8080

``data/``
~~~~~~~~~

This folder can be used in tests to store temporary data.

``features/``
~~~~~~~~~~~~~

This directory stores `Behat's feature files`_. 
These contain the Behat's test cases, called scenarios, which use the Gherkin language.

``feature/bootstrap``
~~~~~~~~~~~~~~~~~~~~~

This folder contains all the Behat contexts. 
Contexts contain the PHP code required to run Behat's scenarios. 
Every feature file has to have at least one context associated with it. 

``run.sh``
~~~~~~~~~~
  
This script runs the tests suites. 
To use it we need to use the web server user, which is normally ``www-data`` or ``apache``.

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
   * @param string $method
   * @param string $url
   */
  public function exampleFunction($method, $url) {


Following this, add a new feature file to ``features/`` folder. 
The name should be in the format: ``<task-to-test>.feature``.
The content of this file should be Gherkin code. 
You can use all the sentences available in the rest of core contexts, just use the appropriate trait in your context. 

For example "use Webdav;" for using WebDAV related functions.
Lets show an example of a feature file with scenarios:

.. code-block:: yaml

    Feature: provisioning
      Background:
        Given using api version "1"

      Scenario: Getting an not existing user
        Given As an "admin"
        When sending "GET" to "/cloud/users/test"
        Then the OCS status code should be "998"
        And the HTTP status code should be "200"

- ``Feature``: gives the feature its name, in this case: ``provisioning``.
- ``Background``: gives contextual information on assumptions which the feature makes, what it relates to, and other aspects so that the scenario can be properly understood.
- ``Scenario``: contains the core information about a test scenario in human-readable language, so that you can understand what the code will have to do for the scenario to have been successfully implemented. 

A scenario requires three parts, ``"Given"``, ``"When"``, and ``"Then"`` sections. 
``"Given"`` and ``"Then"`` can have several sentences joined together by ``"And"``, but ``"Then"`` statements should just have one. 
And this should be the function to test. 
The other parts are preconditions and post-conditions of the test. 

To be able to run your new feature tests you'll have to add a new context to ``config/behat.yml`` file.
To do so, in the ``contexts`` section add your new context:

.. code-block:: yaml
    contexts:
          * TaskToTestContext:
              baseUrl:  http://localhost:8080/ocs/

After the name, add all the variables required for your context. 
In this example we add just the required ``baseUrl`` variable.
With that done, we're now ready to run the tests. 

Running Integration Tests
~~~~~~~~~~~~~~~~~~~~~~~~~

This is a concise guide to running integration tests on ownCloud 10.0.
Before you can do so, you need to meet a few prerequisites available; these are

- ownCloud 
- Composer 
- MySQL


After cloning core, run ``make`` as your webserver's user in the root directory of the project.

.. NOTE: 
   Having a clean database is a also good idea.

Now that the prerequisites are satisfied, and assuming that ``$installation_path`` is the location where you cloned the ``ownCloud/core`` repository, the following commands will prepare the installation for running the integration tests.

..code-block:: bash

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

With the installtion prepared, you should now be able to run the tests. 
Go to the ``build/integration`` folder and, assuming that your web user is ``www-data``, run the following command::

  sudo -u www-data ./run.sh features/task-to-test.feature

If you want to use an alternative home name using the ``env`` variable add to the execution ``OC_TEST_ALT_HOME=1``, as in the following example:

  sudo -u www-data OC_TEST_ALT_HOME=1 ./run.sh features/task-to-test.feature

If you want to have encryption enabled add ``OC_TEST_ENCRYPTION_ENABLED=1``, as in the following example:

  sudo -u www-data OC_TEST_ENCRYPTION_ENABLED=1 ./run.sh features/task-to-test.feature

For more information on Behat, and how to write integration tests using it, check out `the online documentation`_.

.. Links
   
.. _the core repository's: https://github.com/owncloud/core
.. _Behat's feature files: http://docs.behat.org/en/v2.5/guides/1.gherkin.html
.. _the online documentation: http://behat.org/en/latest/guides.html
