====================
Application Metadata
====================

.. sectionauthor:: Bernhard Posselt <dev@bernhard-posselt.com>

The :file:`appinfo/info.xml` contains metadata about the application.
In this section, you will find a complete example configuration, along with an explanation of what each of file's elements.

.. code-block:: xml

  <?xml version="1.0"?>
  <info>
      <!-- Mandatory fields -->
      <id>yourappname</id>
      <name>Your App</name>
      <description>Your application description</description>
      <version>1.0</version>
      <licence>AGPL</licence>
      <screenshot small-thumbnail="https://raw.githubusercontent.com/foo/myapp/master/screenshots/thumb.png"
        >https://raw.githubusercontent.com/foo/myapp/master/screenshots/big.png</screenshot>
      <!-- Category values available at: https://marketplace.owncloud.com/ajax/categories -->
      <category>A category for the application. </category>
      <summary>A summary of the application's purpose (max 90 chars)</summary>

      <types>
          <filesystem/>
      </types>

      <documentation>
          <user>https://doc.owncloud.org/server/10.0/user_manual/pim/contacts.html</user>
          <admin>https://doc.owncloud.org/server/10.0/admin_manual/configuration_server/occ_command.html?highlight=contact#dav-commands</admin>
          <developer>https://github.com/owncloud/contacts/blob/master/README.md</developer>
      </documentation>

      <author>Your Name</author>
      <namespace>YourapplicationsNamespace</namespace>
      <website>https://owncloud.org</website>
      <bugs>https://github.com/owncloud/theapp/issues</bugs>
      <repository type="git">https://github.com/owncloud/theapplication.git</repository>
      <ocsid>1234</ocsid>

      <dependencies>
          <php min-version="5.4" max-version="5.5"/>
          <database>sqlite</database>
          <database>mysql</database>
          <command os="linux">grep</command>
          <command os="windows">notepad.exe</command>
          <lib min-version="1.2">xml</lib>
          <lib max-version="2.0">intl</lib>
          <lib>curl</lib>
          <os>Linux</os>
          <owncloud min-version="6.0.4" max-version="8"/>
      </dependencies>
      
      <!-- For registering panels -->
      <settings>
          <admin>OCA\MyApp\Settings\Admin</admin>
          <personal>OCA\MyApp\Settings\Personal</personal>
      </settings>
      
      <!-- For registering settings sections -->
      <settings-sections>
	  	  <admin>OCA\MyApp\Settings\AdminSection</admin>
		  <personal>OCA\MyApp\Settings\PersonalSection</personal>
      </settings-sections>

      <!-- deprecated, but kept for reference -->
      <public>
          <file id="caldav">appinfo/caldav.php</file>
      </public>
      <remote>
          <file id="caldav">appinfo/caldav.php</file>
      </remote>
      <standalone />
      <default_enable />
      <shipped>true</shipped>
      <!-- end deprecated -->
  </info>

id
--

**Required**. 
This field contains the internal application name, and has to be the same as the folder name of the application. 
This id needs to be unique in ownCloud, meaning no other application should have this id.
This value also represents the URL your application is available on the marketplace.

category
--------

The category you want to publish the application in. 
The following categories are available for applications to be filed under.

+------------------+------------------+
| Category Name    | Value to Use     |
+==================+==================+
| Automation       | automation       |
+------------------+------------------+
| Collaboration    | collaboration    |
+------------------+------------------+
| Customization    | customization    |
+------------------+------------------+
| External plugins | external-plugins |
+------------------+------------------+
| Games            | games            |
+------------------+------------------+
| Integration      | integration      |
+------------------+------------------+
| Multimedia       | multimedia       |
+------------------+------------------+
| Productivity     | productivity     |
+------------------+------------------+
| Security         | security         |
+------------------+------------------+
| Storage          |  storage         |
+------------------+------------------+
| Tools            | tools            |
+------------------+------------------+

.. note:: 
   For publishing themes this tag must be present — but empty.

.. code-block:: xml

 <category></category>

description
-----------

max. 4000 characters; 
This provides all the necessary, detailed information about the application. 
Don't get lost in technical details, focus on the benefits which the application offers. 
You can use `markdown`_ to format the description.

name
----

**Required**. 
This is the human-readable name (or title) of the application that will be displayed in the application overview page.

description
-----------

**Required**. 
This contains the description of the application which will be shown in the application overview page.

version
-------

This sets the version of your application.

licence
-------

**Required**. 
The sets the application's license. 
This license must be compatible with the AGPL and **must not be proprietary**. 

Two good examples are:

* AGPL 3 (recommended)
* MIT

If a proprietary/non-AGPL compatible license must be used, then you have to use the `ownCloud Enterprise Edition`_.

author
------

**Required**. 
The name of the application's author or authors.

namespace
---------

Required if ``routes.php`` returns an array. 
For example, if your application is namespaced, e.g., ``\\OCA\\MyApp\\Controller\\PageController``, then the required namespace value is ``MyApp``. 
If a namespace is not provided, the application tries to default to the first letter upper-cased application id, e.g., ``myapp`` would be tried under ``Myapp``.

summary
-------

**Required**. 
Provide a short application description (max. 90 chars). 
This gets displayed below the product title and on the product tiles. 
It is mandatory since ownCloud 10.0.0.

types
-----

ownCloud supports five types. 
These are:

- ``prelogin``: applications which need to load on the login page
- ``filesystem``: applications which provide filesystem functionality (e.g., file-sharing applications)
- ``authentication``: applications which provide authentication backends
- ``logging``: applications which implement a logging system
- ``prevent_group_restriction``: applications which can not be enabled for specific groups (e.g., notifications app).

.. note:: 
   ``prevent_group_restriction`` was introduced with ownCloud 9.0. 
   It can be used in earlier versions, but the functionality will be ignored.

.. note::
   Due to technical reasons applications of any type listed above can not be enabled for specific groups only.

documentation
-------------

**Required**. 
Link to *admin*, *user*, and *developer* documentation.
Common places are: (where ``$name`` is the name of your app, e.g. ``$name=theapp``)

.. code-block:: xml

  $DOCUMENTATION_BASE = 'https://doc.owncloud.org';
  $DOCUMENTATION_DEVELOPER = $DOCUMENTATION_BASE.'/server/'.$VERSIONS_SERVER_MAJOR_DEV_DOCS.'/developer_manual/$name/';`
  $DOCUMENTATION_ADMIN = $DOCUMENTATION_BASE.'/server/'.$VERSIONS_SERVER_MAJOR_STABLE.'/admin_manual/$name/';
  $DOCUMENTATION_USER = $DOCUMENTATION_BASE.'/server/'.$VERSIONS_SERVER_MAJOR_STABLE.'/user_manual/$name/';

These places are maintained at https://github.com/owncloud/documentation/.
Another popular starting point for developer documentation is the `README.md` in GitHub.

website
-------

**Required**. 
A link to the project's web page.

repository
----------

**Required**. 
A link to the version control repository.

bugs
----

**Required**. 
A link to the bug tracker, if any.

category
--------

The ownCloud Marketplace category. 
It can be one of the following:

- multimedia
- productivity
- game
- tool

Dependencies
============

All tags within the dependencies tag define a set of requirements which have to be fulfilled in order to operate properly. 
As soon as one of these requirements is not met the application cannot be installed.

php
---

Defines the minimum and the maximum version of PHP required to run this application.

database
--------

Each supported database has to be listed here. 
Valid values are ``sqlite``, ``mysql``, ``pgsql``, ``oci`` and ``mssql``. 
In the future it will be possible to specify versions here as well.
In case no database is specified it is assumed that all databases are supported.

command
-------

Defines a command line tool to be available. 
With the attribute ``os`` the required operating system for this tool can be specified. 
Valid values for the ``os`` attribute are as returned by the php function `php_uname`_.

lib
---

Defines a required PHP extension with a required minimum and/or maximum version. 
The names for the libraries have to match the result as returned by the php function `get_loaded_extensions`_.
The explicit version of an extension is read from `phpversion`_ - with some exception as to be read up in the `code base`_

os
--

Defines the required target operating system the application can run on. 
Valid values are as returned by the php function `php_uname`_.

owncloud
--------

Defines the minimum and maximum versions of ownCloud core. 

.. important:: This will be mandatory from version 11 onwards.

Deprecated
==========

The following sections are listed just for reference and should not be used because:

- **public/remote**: Use :doc:`api` instead because you'll have to use :doc:`../../core/externalapi` which is known to be buggy (works only properly with GET/POST)
- **standalone/default_enable**: They tell core what do on setup, you will not be able to even activate your application if it has those entries. This should be replaced by a config file inside core.

public
------

Used to provide a public interface (requires no login) for the application. 
The id is appended to the URL ``/owncloud/index.php/public``. 
Example with id set to 'calendar'::

    /owncloud/index.php/public/calendar

Also take a look at :doc:`../../core/externalapi`.

remote
------

Same as public, but requires login. 
The id is appended to the URL ``/owncloud/index.php/remote``. 
Example with id set to 'calendar'::

    /owncloud/index.php/remote/calendar

Also take a look at :doc:`../../core/externalapi`.


standalone
----------

Can be set to ``true`` to indicate that this application is a web application. 
This can be used to tell GNOME Web for instance to treat this like a native application.

default_enable
--------------

**Core applications only**: Used to tell ownCloud to enable them after the installation.

shipped
-------

**Core applications only**: Used to tell ownCloud that the application is in the standard release.
Please note that if this attribute is set to ``FALSE`` or not set at all, every time you disable the application, all the files of the application itself will be *REMOVED* from the server!

.. Links
   
.. _markdown: https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet
.. _ownCloud Enterprise Edition: https://owncloud.com/overview/enterprise-edition
.. _php_uname: http://php.net/manual/en/function.php-uname.php
.. _get_loaded_extensions: http://php.net/manual/en/function.get-loaded-extensions.php
.. _phpversion: http://php.net/manual/de/function.phpversion.php
.. _code base: https://github.com/owncloud/core/blob/master/lib/private/app/platformrepository.php#L45
