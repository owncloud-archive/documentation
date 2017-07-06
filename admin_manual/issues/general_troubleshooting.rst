=======================
General Troubleshooting
=======================

If you have trouble installing, configuring or maintaining ownCloud, please 
refer to our community support channels:

* `The ownCloud Forums`_

.. note:: The ownCloud forums have a `FAQ category`_ where each topic corresponds 
   to typical mistakes or frequently occurring issues

* `The ownCloud User mailing list`_
*  The ownCloud IRC chat channel ``irc://#owncloud@freenode.net`` on 
   freenode.net, also accessible via `webchat`_

Please understand that all these channels essentially consist of users like you 
helping each other out. Consider helping others out where you can, to contribute 
back for the help you get. This is the only way to keep a community like 
ownCloud healthy and sustainable!

If you are using ownCloud in a business or otherwise large scale deployment, 
note that ownCloud Inc. offers the `Enterprise Edition`_ with commercial 
support options.

Bugs
----

If you think you have found a bug in ownCloud, please:

* Search for a solution (see the options above)
* Double-check your configuration

If you can't find a solution, please use our `bugtracker`_. You can generate a 
configuration report with the :ref:`occ config command 
<config_commands_label>`, with passwords automatically obscured.

.. _the ownCloud Forums: https://central.owncloud.org
.. _FAQ category: https://central.owncloud.org/c/faq
.. _the ownCloud User mailing list: 
   https://mailman.owncloud.org/mailman/listinfo/user
.. _webchat: http://webchat.freenode.net/?channels=owncloud
.. _Enterprise Edition: https://owncloud.com/lp/community-or-enterprise/
.. _bugtracker: 
   https://doc.owncloud.org/server/10.0/developer_manual/bugtracker/index.html

.. TODO ON RELEASE: Update version number above on release

General Troubleshooting
-----------------------

Check the ownCloud :doc:`../installation/system_requirements`, especially 
supported browser versions.

When you see warnings about ``code integrity``, refer to :doc:`code_signing`.

Disable 3rdparty / non-shipped apps
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

It might be possible that 3rd party / non-shipped apps are causing various 
different issues. Always disable 3rd party apps before upgrades, and for 
troubleshooting. Please refer to the :ref:`apps_commands_label` on how
to disable an app from command line.

ownCloud Logfiles
^^^^^^^^^^^^^^^^^

In a standard ownCloud installation the log level is set to ``Normal``. To find 
any issues you need to raise the log level to ``All`` in your ``config.php`` 
file, or to **Everything** on your ownCloud Admin page. Please see 
:doc:`../configuration/server/logging_configuration` for more information on 
these log levels.

Some logging - for example JavaScript console logging - needs debugging 
enabled. Edit :file:`config/config.php` and change ``'debug' => false,`` to 
``'debug' => true,`` Be sure to change it back when you are finished.

For JavaScript issues you will also need to view the javascript console. All 
major browsers have developer tools for viewing the console, and you 
usually access them by pressing F12. For Firefox we recommend to installing 
the `Firebug extension <https://getfirebug.com/>`_.

.. note:: The logfile of ownCloud is located in the data directory 
   ``owncloud/data/owncloud.log``.

.. _label-phpinfo:
   
PHP Version and Information
^^^^^^^^^^^^^^^^^^^^^^^^^^^

You will need to know your PHP version and configurations. To do this, create a 
plain-text file named **phpinfo.php** and place it in your Web root, for 
example ``/var/www/html/phpinfo.php``. (Your Web root may be in a different 
location; your Linux distribution documentation will tell you where.) This file 
contains just this line::

 <?php phpinfo(); ?>

Open this file in a Web browser by pointing your browser to 
``localhost/phpinfo.php``:

.. figure:: ../images/phpinfo.png

Your PHP version is at the top, and the rest of the page contains abundant 
system information such as active modules, active ``.ini`` files, and much more. 
When you are finished reviewing your information you must delete 
``phpinfo.php``, or move it outside of your Web directory, because it is a 
security risk to expose such sensitive data.

Debugging Sync Issues
^^^^^^^^^^^^^^^^^^^^^

.. warning:: The data directory on the server is exclusive to ownCloud and must 
   not be modified manually.

Disregarding this can lead to unwanted behaviours like:

* Problems with sync clients
* Undetected changes due to caching in the database

If you need to directly upload files from the same server please use a WebDAV 
command line client like ``cadaver`` to upload files to the WebDAV interface at:

``https://example.com/owncloud/remote.php/dav``

Common problems / error messages
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Some common problems / error messages found in your logfiles as described above:

* ``SQLSTATE[HY000] [1040] Too many connections`` -> You need to increase the
  connection limit of your database, please refer to the manual of your database
  for more information.
* ``SQLSTATE[HY000]: General error: 5 database is locked`` -> You're using 
  ``SQLite``
  which can't handle a lot of parallel requests. Please consider converting to
  another database like described in 
  :doc:`../configuration/database/db_conversion`.
* ``SQLSTATE[HY000]: General error: 2006 MySQL server has gone away`` -> Please
  refer to :ref:`db-troubleshooting-label` for more information.
* ``SQLSTATE[HY000] [2002] No such file or directory`` -> There is a problem
  accessing your SQLite database file in your data directory 
  (``data/owncloud.db``). Please check the permissions of this folder/file or 
  if it exists at all. If you're using MySQL please start your database.
* ``Connection closed / Operation cancelled`` -> This could be caused by wrong 
  ``KeepAlive`` settings within your Apache config. Make sure that 
  ``KeepAlive`` is set to ``On`` and  also try to raise the limits of 
  ``KeepAliveTimeout`` and  ``MaxKeepAliveRequests``.
* ``No basic authentication headers were found`` -> This error is shown in your
  ``data/owncloud.log`` file. Some Apache modules like ``mod_fastcgi``, ``mod_fcgid``
  or ``mod_proxy_fcgi`` are not passing the needed authentication headers to
  PHP and so the login to ownCloud via WebDAV, CalDAV and CardDAV clients is
  failing. Information on how to correctly configure your environment can be
  found at the `forums <https://central.owncloud.org/t/no-basic-authentication-headers-were-found-message/819>`_.

Missing Data Directory
----------------------

During the normal course of operations, the ownCloud data directory may be
temporarily unavailable for a variety of reasons. 
These can include network timeouts on mounted network disks, unintentional
unmounting of the partition on which the directory sits, or a corruption of the
RAID setup. 
If you have experienced this, here’s how ownCloud works and what you can expect.

During normal operation, ownCloud's data directory contains a hidden file, named ``.ocdata``.
The purpose of this file is for setups where the data folder is mounted (such as via NFS) and for some reason the mount disappeared.
If the directory isn’t available, the data folder would, in effect, be completely empty and the ".ocdata" would be missing.
When this happens, ownCloud will return a `503 Service not available`_ error, to prevent clients believing that the files are gone.

.. NOTE: Regarding display of the installation page

   The ownCloud installation page will **not** be displayed if the data
   directory is missing. As the installation-related details are stored in
   "config.php", it’s only if ``config/config.php`` is missing that the
   installation page would appear again.

Troubleshooting Web server and PHP problems
-------------------------------------------

Logfiles
^^^^^^^^

When having issues the first step is to check the logfiles provided by PHP, the 
Web server and ownCloud itself.

.. note:: In the following the paths to the logfiles of a default Debian 
   installation running Apache2 with mod_php is assumed. On other Web servers, 
   Linux distros or operating systems they can differ.

* The logfile of Apache2 is located in ``/var/log/apache2/error.log``.
* The logfile of PHP can be configured in your ``/etc/php5/apache2/php.ini``. 
  You need to set the directive ``log_errors`` to ``On`` and choose the path
  to store the logfile in the ``error_log`` directive. After those changes you
  need to restart your Web server.
* The logfile of ownCloud is located in the data directory 
  ``/var/www/owncloud/data/owncloud.log``.

Web Server and PHP Modules
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. note:: Lighttpd is not supported with ownCloud, and some ownCloud features 
   may not work at all on Lighttpd.

There are some Web server or PHP modules which are known to cause various 
problems like broken up-/downloads. The following shows a draft overview of 
these modules:

1. Apache

* libapache2-mod-php5filter (use libapache2-mod-php5 instead)
* mod_dav
* mod_deflate
* mod_evasive
* mod_pagespeed
* mod_proxy_html (can cause broken PDF downloads)
* mod_reqtimeout
* mod_security
* mod_spdy together with libapache2-mod-php5 / mod_php (use fcgi or php-fpm instead)
* mod_xsendfile / X-Sendfile (causing broken downloads if not configured correctly)

2. NGINX

* ngx_pagespeed
* HttpDavModule
* X-Sendfile (causing broken downloads if not configured correctly)

3. PHP

* eAccelerator

.. _trouble-webdav-label:

Troubleshooting WebDAV
----------------------

General troubleshooting
^^^^^^^^^^^^^^^^^^^^^^^

ownCloud uses SabreDAV, and the SabreDAV documentation is comprehensive and 
helpful.

.. note: Lighttpd is not supported on ownCloud, and Lighttpd WebDAV does not 
   work with ownCloud.

See:

* `SabreDAV FAQ <http://sabre.io/dav/faq/>`_
* `Web servers <http://sabre.io/dav/webservers>`_ (Lists lighttpd as not 
  recommended)
* `Working with large files <http://sabre.io/dav/large-files/>`_ (Shows a PHP 
  bug in older SabreDAV versions and information for mod_security problems)
* `0 byte files <http://sabre.io/dav/0bytes>`_ (Reasons for empty files on the 
  server)
* `Clients <http://sabre.io/dav/clients/>`_ (A comprehensive list of WebDAV 
  clients, and possible problems with each one)
* `Finder, OS X's built-in WebDAV client 
  <http://sabre.io/dav/clients/finder/>`_ 
  (Describes problems with Finder on various Web servers)

There is also a well maintained FAQ thread available at the `ownCloud Forums 
<https://central.owncloud.org/t/how-to-fix-caldav-carddav-webdav-problems/852>`_
which contains various additional information about WebDAV problems.

Error 0x80070043 "The network name cannot be found." while adding a network drive
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The windows native WebDAV client might fail with the following error message::

    Error 0x80070043 "The network name cannot be found." while adding a network drive

A known workaround for this issue is to update your Web server configuration. For Apache
you need to add something like the following (please update the path accordingly) to your 
main Web server / Vhost configuration or the ``.htaccess`` placed in your document root::

    RewriteEngine On
    RewriteCond %{REQUEST_URI} ^(/)$ [NC]
    RewriteCond %{REQUEST_METHOD} ^(OPTIONS)$
    RewriteRule .* https://%{SERVER_NAME}/owncloud/remote.php/webdav/ [R=301,L]

For NGINX an example config addition could be::

    location = / {
        if ($http_user_agent = DavClnt) {
            return 401;
        }
    }

Troubleshooting Contacts & Calendar
-----------------------------------

.. _service-discovery-label:

Service discovery
^^^^^^^^^^^^^^^^^

Some clients - especially on iOS/Mac OS X - have problems finding the proper
sync URL, even when explicitly configured to use it.

If you want to use CalDAV or CardDAV clients together with ownCloud it is
important to have a correct working setup of the following URLs:

| ``https://example.com/.well-known/carddav``
| ``https://example.com/.well-known/caldav``
|

Those need to be redirecting your clients to the correct DAV endpoints. If
running ownCloud at the document root of your Web server the correct URL is:

``https://example.com/remote.php/dav``

and if running in a subfolder like ``owncloud``:

``https://example.com/owncloud/remote.php/dav``

For the first case the :file:`.htaccess` file shipped with ownCloud should do
this work for your when running Apache. You only need to make sure that your
Web server is using this file.

If your ownCloud instance is installed in a subfolder called ``owncloud`` and
you're running Apache create or edit the :file:`.htaccess` file within the
document root of your Web server and add the following lines::

    Redirect 301 /.well-known/carddav /owncloud/remote.php/dav
    Redirect 301 /.well-known/caldav /owncloud/remote.php/dav

Now change the URL in the client settings to just use:

``https://example.com``

instead of e.g.

``https://example.com/owncloud/remote.php/dav/principals/username``.

There are also several techniques to remedy this, which are described extensively at 
the `Sabre DAV website <http://sabre.io/dav/service-discovery/>`_.

Unable to update Contacts or Events
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If you get an error like:

``PATCH https://example.com/remote.php/dav HTTP/1.0 501 Not Implemented``

it is likely caused by one of the following reasons:

Using Pound reverse-proxy/load balancer
  As of writing this Pound doesn't support the HTTP/1.1 verb.
  Pound is easily `patched 
  <http://www.apsis.ch/pound/pound_list/archive/2013/2013-08/1377264673000>`_ 
  to support HTTP/1.1.

Misconfigured Web server
  Your Web server is misconfigured and blocks the needed DAV methods.
  Please refer to :ref:`trouble-webdav-label` above for troubleshooting steps.
  
Client Sync Stalls
------------------

One known reason is stray locks. These should expire automatically after an hour. If stray
locks don't expire (identified by e.g. repeated ``file.txt is locked`` and/or ``Exception\\\\FileLocked``
messages in your :file:`data/owncloud.log`), make sure that you are running system cron and
not Ajax cron (See :doc:`../configuration/server/background_jobs_configuration`).
See `<https://github.com/owncloud/core/issues/22116>`_ and `<https://central.owncloud.org/t/file-is-locked-how-to-unlock/985>`_
for some discussion and additional info of this issue.

Other issues
------------

Some services like *Cloudflare* can cause issues by minimizing JavaScript
and loading it only when needed. When having issues like a not working
login button or creating new users make sure to disable such services
first.

.. Links
   
.. _503 Service not available: https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#5xx_Server_Error
