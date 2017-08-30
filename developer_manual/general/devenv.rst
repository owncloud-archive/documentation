.. _devenv:

.. sectionauthor:: Matthew Setter <matthew@matthewsetter.com>

=======================
Development Environment
=======================

To be able to use and develop with ownCloud takes a few steps.

#. Install the Core Software
#. Setup the web server and database
#. Get the source
#. Install software dependencies
#. Enable debug mode
#. Setup ownCloud

If you have already completed one or more of these steps, feel free to skip them.
Otherwise, if you're just getting started, begin by getting the ownCloud source code.

Install the Core Software 
-------------------------

The first thing to do is to ensure that your server has the necessary software for installing and running ownCloud.
While you can go further, you need to install at least the following:

- `Make <https://www.gnu.org/software/make/>`_
- `Node.js <https://nodejs.org>`_.
- `git <https://git-scm.com/>`_
- `npm <https://www.npmjs.com/>`_
- `unzip <https://linux.die.net/man/1/unzip>`_
- `wget <https://www.gnu.org/software/wget/>`_

Install Dependencies on Ubuntu 16.04
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: console

  # Ensure that Apt's cache is up to date
  sudo apt-get -y -q update

  # Auto-install the required dependencies with a minimum of output
  sudo apt-get install -y -q wget make npm nodejs unzip git

Install Dependencies on openSUSE Leap 42.3
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: console

  # Ensure that Zypper's cache is up to date
  sudo zypper --non-interactive --quiet \
     update --auto-agree-with-licenses --best-effort

  # Auto-install the required dependencies with a minimum of output
  sudo zypper --quiet --non-interactive install \
      wget make nodejs6 nodejs-common unzip git 
      npm6 phantomjs php7-curl php7-openssl openssl php7-phar

Setup the Webserver and Database
--------------------------------

Next, you need to set up your web server and database so that they work properly with ownCloud.
You can find the full guide in `the installation section of the documentation <https://doc.owncloud.org/server/latest/admin_manual/installation/index.html>`_.

Get The Source
--------------

With the web server and database setup, you next need to get a copy of ownCloud.
There are two ways to do so: 

#. Use `the stable version <https://doc.owncloud.org/server/latest/admin_manual/#installation>`_
#. Clone the development version from `GitHub`_:

For the sake of a brief example, assuming you chose to clone from GitHub, here's an example of how to do so:

.. code-block:: console

  # Assuming that /var/www/html is the webserver's document root
  git clone https://github.com/owncloud/core.git /var/www/html/core

.. note:: **What is the Web Server's Root Directory?**

  The quickest way to find out is by using the ``ls`` command, for example:  ``ls -lah /var/wwww``.
  Depending on your Linux distribution, it's likely to be one of ``/var/www``, ``/var/www/html``, or ``/srv/http``.

Set User, Group, and Permissions
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You now need to make sure that the web server user (and optionally the web server's group) have read/write access to the directory where you installed ownCloud:
The following commands assume that ``/var/www`` is the web server's directory and that ``www-data`` is the web server user and group.
The following commands will do this:

.. code-block:: console

  # Set the user and group to the webserver user and group
  sudo chown -R www-data:www-data /var/www/html/core/

  # Set read/write permissions on the directory
  sudo chmod o+rw /var/www/html/core/

.. note:: **What is the Web Server's User and Group?**

  There are a few ways to identify the user and group the webserver is running as. 
  Likely the easiest are ``grep`` and ``ps``.
  Here's an example of using both (which assumes that the distribution is Ubuntu 16.04).

  .. code-block:: console
   
   # Find the user defined in Apache's configuration files
   grep -r 'APACHE_RUN_USER' /etc/apache2/
   
   # Find the user that's running Apache.
   ps -aux | grep apache2

   Depending on your distribution, it will likely be one of ``http``, ``www-data``, ``apache``, or ``wwwrun``.

Install Software Dependencies
-----------------------------

With the ownCloud source `available to your webserver`_, next install ownCloud's dependencies by running `Make`_, from the directory where ownCloud's located.
Here's an example of how to do so:

.. code-block:: console
   
   # Assuming that the ownCloud source is located in ``/var/www/html/core`` 
   cd /var/www/html/core && make

By default, running ``make`` will install the required dependencies for both PHP and JavaScript. 
However, there are other options that it supports, which you can see in the table below, which are useful for a variety of tasks.

================== ============================================================
Target             Description
================== ============================================================
make               Pulls in both Composer and Bower dependencies
make clean         Cleans up dependencies. This is useful for starting over or 
                   when switching to older branches
make dist          Builds a minimal owncloud-core tarball with only core apps
                   in `build/dist/core`, stripped of unwanted files
make docs          Builds the JavaScript documentation using `JSDoc`_
make test          Runs all of the test targets 
make test-external Runs one of the external storage tests, and is configurable 
                   through make variables
make test-js       Runs the Javascript unit tests, replacing `./autotest-js.sh`
make test-php      Runs the PHPUnit tests with SQLite as the data source. This 
                   replaces `./autotest.sh sqlite`  and is configurable through 
                   make variables
================== ============================================================

.. _debugmode:

Enable Debug Mode
-----------------

Now that ownCloud's available to your web server and the dependencies are installed, we strongly encourage you to disable JavaScript and CSS caching during development.
This is so that when changes are made, they're immediately visible, not at some later stage when the respective caches expire.
To do so, enable debug mode by setting ``debug`` to ``true`` in :file:`config/config.php`, as in the example below.

To disable JavaScript and CSS caching debugging has to be enabled by setting ``debug`` to ``true`` in :file:`core/config/config.php`::

  <?php

  $CONFIG = [
      'debug' => true,
      ... configuration goes here ...
  ];

.. warning:: 
   Do not enable this for production! 
   This can create security problems and is only meant for debugging and development!

Setup ownCloud
--------------

With all that done, you're now ready to use either `the installation wizard`_ or `command line installer`_ to finish setting up ownCloud.

.. Links
   
.. _such as the required PHP modules: https://doc.owncloud.org/server/latest/admin_manual/installation/source_installation.html#installing-on-ubuntu-16-04-lts-server
.. _Make: https://www.gnu.org/software/make/
.. _JSDoc: http://usejsdoc.org
.. _GitHub: https://github.com/owncloud
.. _GitHub Help Page: https://help.github.com/
.. _available to your webserver: https://doc.owncloud.org/server/latest/admin_manual/installation/source_installation.html#configure-the-apache-web-server
.. _the installation wizard: https://doc.owncloud.org/server/latest/admin_manual/installation/installation_wizard.html
.. _command line installer: https://doc.owncloud.org/server/latest/admin_manual/installation/command_line_installation.html

