.. _devenv:

.. sectionauthor:: Bernhard Posselt <dev@bernhard-posselt.com>

=======================
Development Environment
=======================

Please follow the steps on this page to set up your development environment.

Set up web server and database
==============================

First `set up your web server and database <http://doc.owncloud.org/server/7.0/admin_manual/installation.html>`_ (**Section**: Manual Installation - Prerequisites).

Get the source
==============

There are two ways to obtain ownCloud sources: 

* Using the `stable version <http://doc.owncloud.org/server/7.0/admin_manual/installation.html>`_
* Using the development version from `GitHub`_ which will be explained below.

To check out the source from `GitHub`_ you will need to install git (see `Setting up git <https://help.github.com/articles/set-up-git>`_ from the GitHub help)

Gather information about server setup
-------------------------------------

To get started the basic git repositories need to cloned into the web server's directory. Depending on the distribution this will either be

* **/var/www**
* **/var/www/html** 
* **/srv/http** 


Then identify the user and group the web server is running as and the Apache user and group for the **chown** command will either be

* **http**
* **www-data** 
* **apache**

Check out the code
------------------

There are two ways to check out the code, either by using the **ocdev** tool or manually.

Using the ocdev method 
~~~~~~~~~~~~~~~~~~~~~~

The following commands are using **/var/www** as the web server's directory and **www-data** as user name and group.

.. note:: Python 3.4 includes pip by default

Install the development tool (**depends on Python 3 and python3-pip**)::

  sudo pip3 install ocdev

Make the directory writable::

  sudo chmod o+rw /var/www
  
Then install ownCloud from git::

  ocdev setup base

Using the manual method
~~~~~~~~~~~~~~~~~~~~~~~

The following commands are using **/var/www** as the web server's directory and **www-data** as user name and group.

.. code-block:: bash

  sudo chmod o+rw /var/www
  cd /var/www
  git clone https://github.com/owncloud/core.git owncloud
  git clone https://github.com/owncloud/apps.git
  cd owncloud/
  git submodule init
  git submodule update
  mkdir data

Check out additional apps (optional)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you would like to develop on non-core apps, you can check them out into the **apps** directory as well.
For example for the calendar, contact and notes apps:

.. code-block:: bash

  cd /var/www/owncloud/apps
  git clone https://github.com/owncloud/calendar.git
  git clone https://github.com/owncloud/contacts.git
  git clone https://github.com/owncloud/notes.git

Finalizing the setup
--------------------

Adjust rights::

  sudo chown -R www-data:www-data /var/www/owncloud/data/
  sudo chmod o-rw /var/www


Finally restart the web server (this might vary depending on your distribution)::

  sudo systemctl restart httpd.service

or::

  sudo /etc/init.d/apache2 restart

After the clone Open http://localhost/owncloud (or the corresponding URL) in your web browser to set up your instance.

Enabling debug mode
-------------------
.. _debugmode:

.. note:: Do not enable this for production! This can create security problems and is only meant for debugging and development!

To disable JavaScript and CSS caching debugging has to be enabled in :file:`core/config/config.php` by adding this to the end of the file::

  DEFINE('DEBUG', true);

.. _GitHub: https://github.com/owncloud
.. _GitHub Help Page: https://help.github.com/

