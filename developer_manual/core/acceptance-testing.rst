Acceptance Testing
==================

Preparing your system
---------------------

For running the acceptance tests you need Python 2.7 (other versions not tested). If you do not want pollute your
system-wide Python, install virtualenv and activate it.

After installing python, bootstrap this rep::

  python bootstrap.py

Now you can fetch the dependencies using the buildout.cfg::

  bin/buildout

Everything is now fetched and a bin/pybot execute script is created.

Running tests
-------------

Running tests on your own system
--------------------------------

To keep the ownCloud repositories stable you should always test your code
before pushing it. To ensure that your changes do not affect the rest of
ownCloud you should run the acceptance test suite against your code on a
regular base.

Running tests in your test environment
--------------------------------------

The tests get normally executed against http://localhost, this can be overriden from the cli::

    bin/pybot --variable OWNCLOUD_URL:http://localhost/mypath/owncloud/ tests/

Robotframework expects to find the following environment:

1. An admin account with the name "admin" and the password "admin"

1. An user account with the name "user1" and the password "user1"

1. An user account with the name "user2" and the password "user2"

1. An user account with the name "user3" and the password "user3"

1. Users "user1" and "user2" are member of "group1"

To execute the tests run::

    bin/pybot tests

Extending the test suite
------------------------

Having a test suite is cool, but without constantly updating it the test suite 
becomes useless over time.

There are several ways to help us improving the test suite.

Writing new tests
-----------------

Writing user stories is really easy. Just have a look at the existing stories
in /tests and change them according to your needs.

Adapting tests to changes in the UI
-----------------------------------

When an old test fails, there are several possible reasons.

* Someone introduced a bug: Write a bug report in the correct repository.

* The UI changed slightly: Find out what changed and update the user story

* The UI has been redesigned: Consider rewriting all tests regarding this
  feature

* The test has been removed: remove the test.

Note on Patches/Pull Requests
-----------------------------

* Fork the project.

* Make your feature addition or bug fix.

* Test your changes.

* Send a merge request.
