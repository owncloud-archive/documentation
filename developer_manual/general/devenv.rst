.. _devenv:

.. sectionauthor:: Bernhard Posselt <dev@bernhard-posselt.com>

=======================
Development Environment
=======================

Please follow the steps on this page to set up your development environment.

Set up web server and database
==============================

First `set up your web server and database <http://doc.owncloud.org/server/7.0/admin_manual/#installation>`_ (**Section**: Manual Installation - Prerequisites).

Get the source
==============

To get started the basic git repositories need to cloned into the web server's directory. Depending on your distribution this might be one of the following:

* **/var/www**
* **/var/www/html** 
* **/srv/http** 

Make this directory writable with::

  sudo chmod o+rw </path/to/webserver/dir>

There are two ways to obtain ownCloud sources: 

* the `stable version <http://doc.owncloud.org/server/7.0/admin_manual/#installation>`_
* the development version from `GitHub`_.  There are two options for this both of which require you to have git installed (see `Setting up git <https://help.github.com/articles/set-up-git>`_ from the GitHub help):

  * `use the ocdev tool`_
  * `or get the source manually`_

Use The ocdev Tool
------------------

Install the `development tool <https://github.com/owncloud/ocdev/blob/master/README.rst#installation>`_.  Then install ownCloud from git with the following command (make sure you're in your webserver's directory)::

  ocdev setup base

Or Get The Source Manually
--------------------------

You can also clone the repositories from the command line.  Make sure you're in your webserver's directory, then issue the following commands::

  git clone https://github.com/owncloud/core.git owncloud
  cd owncloud
  git submodule init && git submodule update
  mkdir data

Set Up Permissions
==================

Identify the user and group the web server is running as and the Apache user and group for the **chown** command.  Depending on your distribution this might be one of the following:

* **http**
* **www-data** 
* **apache**
* **wwwrun**

Adjust rights (replacing :code:`<web-server-user>` and :code:`<web-server-group>` with their appropriate values)::

  sudo chown <web-server-user>:<web-server-group> core/data
  sudo chown :<web-server-group> config/
  sudo chmod 775 config/
  sudo chown :<web-server-group> apps/
  sudo chmod 775 apps/
  sudo chmod o-rw </path/to/webserver/dir>

Restart The Server
==================

Finally restart the web server.  Depending on your distribution this might be one of the following:

* :code:`sudo service apache2 restart` (ubuntu)
* :code:`sudo systemctl restart httpd.service`
* :code:`sudo /etc/init.d/apache2 restart`

You should now be able to open http://localhost/core (or the corresponding URL) in your web browser to set up your instance.

Enabling debug mode
===================
.. _debugmode:

.. note:: Do not enable this for production! This can create security problems and is only meant for debugging and development!

To disable JavaScript and CSS caching debugging has to be enabled in :file:`core/config/config.php` by adding this to the end of the file::

  DEFINE('DEBUG', true);

Keep the code up-to-date
========================

If you have more than one repository cloned, it can be time consuming to do the same the action to all repositories one by one. To solve this, you can use the following command template::

  find . -maxdepth <DEPTH> -type d -name .git -exec sh -c 'cd "{}"/../ && pwd && <GIT COMMAND>' \;

then, e.g. to pull all changes in all repositories, you only need this::

  find . -maxdepth 3 -type d -name .git -exec sh -c 'cd "{}"/../ && pwd && git pull --rebase' \;

or to prune all merged branches, you would execute this::

  find . -maxdepth 3 -type d -name .git -exec sh -c 'cd "{}"/../ && pwd && git remote prune origin' \;

It is even easier if you create alias from these commands in case you want to avoid retyping those each time you need them.


.. _GitHub: https://github.com/owncloud
.. _GitHub Help Page: https://help.github.com/

