Integration tests
============

Using Behat to test core 
----------------

Tests location and structure
~~~~~~~~~~~~~~~~~~~~~~

In core repository we can find this structure:

.. code-block:: bash
    build
    ├── integration
    │   ├── composer.json
    │   ├── composer.lock
    │   ├── config
    │   │   └── behat.yml
    │   ├── data
    │   │   └── textfile.txt
    │   ├── features
    │   │   ├── feature files (behat gherkin files)
    │   │   └── bootstrap
    │   │       └── Contexts and traits (php files)
    │   ├── federation_features
    │   │   └── federated.feature (feature on a separated context)
    │   ├── run.sh
    │   ├── vendor

Let's detail each part.

- "composer.json" and "composer.lock":
    These files store the required dependencies for the integration tests, libraries like sabredav, guzzle or behat are tracked here.

- Folder "config":
    Here is located the behat.yml file which sets up the integration tests execution.

    In this file we can add new contexts and new features.

    Example of a part of behat.yml:

  .. code-block:: yaml
      default:
        autoload:
          '': %paths.base%/../features/bootstrap
        suites:
          default:
            paths:
              - %paths.base%/../features
            contexts:
              - FeatureContext:
                  baseUrl:  http://localhost:8080/ocs/
                  admin:
                    - admin
                    - admin
                  regular_user_password: 123456
              - CommentsContext:
                  baseUrl: http://localhost:8080


- Folder "data":
  This folder is used in some tests to store temporary data.

- Folder "features":
  Here there are stored the behat's feature files. Those files contain the test cases, called scenarios.
  They use the Gherkin language to define the scenarios.

- Folder "feature/bootstrap":
  In this folder are located all the behat Contexts. These contexts contain the php classes required to run the scenarios. Every feature file has to have a Context associated. In contexts live the code which is run when behat parses the steps of each scenario.

- Script "run.sh":
  This script runs the tests suites. To use it we need to use the web server user (www-data|apache).


Process to add a new feature
~~~~~~~~~~~~~~~~~~~~~~

Creation of a new feature file is recommended when the task to test is independent enough from the rest of features.

Create a new file for the context, naming it TaskToTestContext.php.

This is an snippet for creating a new context:

.. code-block::php
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

Each scenario underlying code belonging to the new feature to test should be added here.

To add a function to run as a scenario step, do the following:

- Use a @When @Given or @Then statement at the beginning.
- For parameters you could use either the regular expressions way or the :variable way. But using colons is preferred.
- Document all the parameters of the function an their expected type.
- Be careful to write the exact sentence that you will write in the gherkin code. Behat won't parse it properly otherwise.

Example code:

.. code-block::php
  /**
   * @When Sending a :method to :url with requesttoken
   * @param string $method
   * @param string $url
   */
  public function exampleFunction($method, $url) {


Add a new feature file to features folder. The name should be task-to-test.feature.

The content of this file should be gherkin code. You can use all the sentences available in the rest of core contexts, just use the apropiate trait in your context. For example "use Webdav;" for using webdav related functions.

Lets show an example of a feature file with scenarios:

..code-block::
    Feature: provisioning
      Background:
        Given using api version "1"

      Scenario: Getting an not existing user
        Given As an "admin"
        When sending "GET" to "/cloud/users/test"
        Then the OCS status code should be "998"
        And the HTTP status code should be "200"

At the beginning we can see the feature name Feature: provisioning and some variables set in the Background section. This sentence 'Given using api version "1"' corresponds with the use of the v1 of the provisioning API.

A scenario requires three parts, "Given", "When" and "Then" sections. "Given" and "Then" can have several sentences joined together by "And", but "Then" statement should be just one. And this should be the function to test. The other parts are preconditions and postconditions of the test. 




Here are some useful links about how to write integration tests with Behat:

- http://behat.org/en/latest/guides.html
