==========================
Configuration Notes & Tips
==========================

.. _selinux_tips_label:

SELinux
^^^^^^^

See :doc:`selinux_configuration` for a suggested configuration for 
SELinux-enabled distributions such as Fedora and CentOS.

.. _php_ini_tips_label:

php.ini
^^^^^^^

Several core PHP settings must be configured correctly, otherwise ownCloud may not work properly. 
Known settings causing issues are listed here. 
Please note that, there might be other settings which cause unwanted behavior. 
In general, however, it is recommended to keep the ``php.ini`` settings at their defaults, except when you know exactly why the change is required, and its implications.

.. NOTE::
   Keep in mind that, changes to ``php.ini`` may have to be configured in more than one ini file. 
   This can be the case, for example, for the ``date.timezone`` setting.
   
php.ini - Used by the Web server
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

For PHP version 7.0 onward, replace ``php_version`` with the version number installed, e.g., ``7.0`` in the following examples.

::

   /etc/php/[php_version]/apache2/php.ini
 or
   /etc/php/[php_version]/fpm/php.ini
 or ...

php.ini - used by the php-cli and so by ownCloud CRON jobs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

  /etc/php/[php_version]/cli/php.ini


session.auto_start && enable_post_data_reading
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Ensure that `session.auto_start`_ is set to ``0`` or ``Off`` and `enable_post_data_reading`_
to ``1`` or ``On`` in your configuration. If not, you may have issues logging in
to ownCloud via the WebUI, where you see the error: "*Access denied. CSRF check
failed*".

session.save_path
~~~~~~~~~~~~~~~~~

In addition to setting ``session.auto_start`` and ``enable_post_data_reading`` correctly, ensure that, if ``session.save_handler`` is set to ``files``, that ``session.save_path`` is set to a path on the filesystem which **only** the web server process (or process which PHP is running as) can read from and write to.
   
This is especially important if your ownCloud installation is using a shared-hosting arrangement.
In these situations, `session poisoning`_ can occur if all of the session files are stored in the same location. 
Session poisoning is where one web application can manipulate data in the ``$_SESSION`` superglobal array of another. 

When this happens, the original application has no way of knowing that this corruption has occurred and may not treat the data with any sense of suspicion. 
You can `read through a thorough discussion of local session poisoning`_ if you'd like to know more.

suhosin.session.cryptkey
~~~~~~~~~~~~~~~~~~~~~~~~

When `suhosin.session.cryptkey`_ is enabled, session data will be transparently encrypted. 
If enabled, there is less of a concern in storing application session files in the same location, as discussed in session.save_path. 
Ideally, however, session files for each application should always be stored in a location specific to that application, and never stored collectively with any other.

.. note::
   This is only relevant if you’re using PHP 5.x.

post_max_size  
~~~~~~~~~~~~~

Please ensure that you have ``post_max_size`` configured with *at least* the minimum 
amount of memory for use with ownCloud, which is 512 MB. 

.. IMPORTANT::
   Please be careful when you set this value if you use the byte value shortcut as it is very specific.  
   Use `K` for kilobyte, `M` for megabyte and `G` for gigabyte. `KB`, `MB`, and `GB` **do not work!**

realpath_cache_size
~~~~~~~~~~~~~~~~~~~

This determines the size of the realpath cache used by PHP. 
This value should be increased on systems where PHP opens many files, to reflect the number of file operations performed. 
For a detailed description see `realpath-cache-size`_.
This setting has been available since PHP 5.1.0. 
Prior to PHP 7.0.16 and 7.1.2, the default was 16 KB.

To see your current value, query your ``phpinfo()`` output for this key. 
It is recommended to set the value if it is currently set to the default of 16 KB.
A good reading about the background can be found at `tideways.io`_.

How to get a working value
--------------------------

With the assumption of 112 bytes per file path needed, this would allow the cache to hold around 37.000 items with a cache size of 4096K (4M), but only about a hundred entries for a cache size of 16 KB.

.. note:: 
   It’s a good rule of thumb to always have a realpath cache that can hold entries for all your files paths in memory. 
   If you use symlink deployment, then set it to double or triple the amount of files.

The easiest way to get the quantity of PHP files is to use cloc, which can be installed by running ``sudo apt-get install cloc``.
The cloc package is available for nearly all distributions.

::

  sudo cloc /var/www/owncloud --exclude-dir=data --follow-links
     12179 text files.
     11367 unique files.
     73126 files ignored.

  http://cloc.sourceforge.net v 1.60  T=1308.98 s (6.4 files/s, 1283.5 lines/s)
  --------------------------------------------------------------------------------
  Language                      files          blank        comment           code
  --------------------------------------------------------------------------------
  PHP                            4896          96509         285384         558135
  ...

Taking the math from above and assuming a symlinked instance, using factor 3.
For example: ``4896 * 3 * 112 = 1.6MB``
This result shows that you can run with the PHP setting of 4M two instances of ownCloud.

Having the default of 16 KB means that only 1/100 of the existing PHP file paths can be cached and need continuous cache refresh slowing down performance.
If you run more web services using PHP, you have to calculate accordingly.


.. _php_fpm_tips_label:

PHP-FPM
^^^^^^^

System Environment Variables
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

When you are using ``php-fpm``, system environment variables like 
``PATH``, ``TMP`` or others are not automatically populated in the same way as 
when using ``php-cli``. A PHP call like ``getenv('PATH');`` can therefore 
return an empty result. So you may need to manually configure environment 
variables in the appropriate ``php-fpm`` ini/config file. 

Here are some example root paths for these ini/config files:

+---------------------------------+-----------------------+
| Ubuntu/Mint                     | CentOS/Red Hat/Fedora |
+---------------------------------+-----------------------+ 
| ``/etc/php/[php_version]/fpm/`` | ``/etc/php-fpm.d/``   |
+---------------------------------+-----------------------+ 

In both examples, the ``ini/config`` file is called ``www.conf``, and depending
on the distribution or customizations which you have made, it may be in
a sub-directory.

Usually, you will find some or all of the environment variables 
already in the file, but commented out like this::

	;env[HOSTNAME] = $HOSTNAME
	;env[PATH] = /usr/local/bin:/usr/bin:/bin
	;env[TMP] = /tmp
	;env[TMPDIR] = /tmp
	;env[TEMP] = /tmp

Uncomment the appropriate existing entries. Then run ``printenv PATH`` to 
confirm your paths, for example::

        $ printenv PATH
        /home/user/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:
        /sbin:/bin:/

If any of your system environment variables are not present in the file then 
you must add them.

When you are using shared hosting or a control panel to manage your ownCloud
virtual machine or server, the configuration files are almost certain to be
located somewhere else, for security and flexibility reasons, so check your
documentation for the correct locations.

Please keep in mind that it is possible to create different settings for 
``php-cli`` and ``php-fpm``, and for different domains and Web sites. 
The best way to check your settings is with :ref:`label-phpinfo`.

Maximum Upload Size
~~~~~~~~~~~~~~~~~~~

If you want to increase the maximum upload size, you will also have to modify 
your ``php-fpm`` configuration and increase the ``upload_max_filesize`` and 
``post_max_size`` values. You will need to restart ``php5-fpm`` and your HTTP 
server in order for these changes to be applied.

.htaccess Notes for Apache
~~~~~~~~~~~~~~~~~~~~~~~~~~

ownCloud comes with its own ``owncloud/.htaccess`` file. Because ``php-fpm`` can't 
read PHP settings in ``.htaccess`` these settings and permissions must be set
in the ``owncloud/.user.ini`` file.

No basic authentication headers were found
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This error is shown in your ``data/owncloud.log`` file. 
Some Apache modules like ``mod_fastcgi``, ``mod_fcgid`` or ``mod_proxy_fcgi`` are not passing the needed authentication headers to PHP and so the login to ownCloud via WebDAV, CalDAV and CardDAV clients is failing. 
Information on how to correctly configure your environment can be found `in the forums`_ but we generally recommend against the use of these modules and recommend mod_php instead.

.. _other_http_servers_label:

Other Web Servers
^^^^^^^^^^^^^^^^^

- `Other HTTP servers <https://github.com/owncloud/documentation/wiki/Alternate-Web-server-notes>`_
- `Univention Corporate Server installation <https://github.com/owncloud/documentation/wiki/UCS-Installation>`_

.. Links
 
.. _in the forums: https://central.owncloud.org/t/no-basic-authentication-headers-were-found-message/819
.. _session.auto_start: https://secure.php.net/manual/en/session.configuration.php#ini.session.auto-start
.. _enable_post_data_reading: https://secure.php.net/manual/en/ini.core.php#ini.enable-post-data-reading
.. _session.save_handler: http://php.net/manual/en/session.configuration.php#ini.session.save-handler
.. _session poisoning: https://en.wikipedia.org/wiki/Session_poisoning
.. _read through a thorough discussion of local session poisoning: http://ha.xxor.se/2011/09/local-session-poisoning-in-php-part-1.html
.. _suhosin.session.cryptkey: https://suhosin.org/stories/configuration.html#suhosin-session-cryptkey
.. _realpath-cache-size: http://php.net/manual/en/ini.core.php#ini.realpath-cache-size
.. _`tideways.io`: https://tideways.io/profiler/blog/how-does-the-php-realpath-cache-work-and-how-to-configure-it
